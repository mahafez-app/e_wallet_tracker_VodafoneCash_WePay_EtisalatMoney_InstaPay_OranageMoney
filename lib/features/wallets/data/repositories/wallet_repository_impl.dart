import 'dart:developer';

import '../../../../core/cache/wallet_meta_cache.dart';
import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/device_info_service.dart';
import '../../../../core/services/inbox_sms_service.dart';
import '../../../../core/utils/egyptian_phone_number.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/wallet_details_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_details_remote_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
    required WalletDetailsRemoteDataSource detailsDataSource,
    required DeviceInfoService deviceInfoService,
    required WalletMetaCache walletMetaCache,
    required InboxSmsService inboxSmsService,
  }) : _remoteDataSource = remoteDataSource,
       _detailsDataSource = detailsDataSource,
       _deviceInfoService = deviceInfoService,
       _walletMetaCache = walletMetaCache,
       _inboxSmsService = inboxSmsService;

  final WalletRemoteDataSource _remoteDataSource;
  final WalletDetailsRemoteDataSource _detailsDataSource;
  final DeviceInfoService _deviceInfoService;
  final WalletMetaCache _walletMetaCache;
  final InboxSmsService _inboxSmsService;
  static const _tag = 'WalletRepositoryImpl';

  @override
  Future<Result<List<WalletEntity>>> getWallets() {
    return executeAndHandleErrors(() async {
      final wallets = await _remoteDataSource.getWallets();
      return wallets.map((dto) => dto.toEntity()).toList();
    }, tag: 'WalletRepositoryImpl.getWallets');
  }

  @override
  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
  }) {
    return executeAndHandleErrors(() async {
      final deviceId = await _resolveDeviceId();
      final existingWallets = await _remoteDataSource.getWallets();

      final initialBalances = <String, double>{};
      final historicalTransactions = <String, List<TransactionDto>>{};

      for (final providerStr in providers) {
        final provider = WalletProvider.fromString(providerStr);
        final sameProviderWalletPhoneNumbers =
            await _resolveSameProviderPhoneNumbers(
              provider: provider,
              targetPhoneNumber: phoneNumber,
              existingWallets: existingWallets,
            );
        final knownWalletBalances = _resolveKnownWalletBalances(
          provider: provider,
          targetPhoneNumber: phoneNumber,
          existingWallets: existingWallets,
        );

        final balance = await _inboxSmsService.getLatestBalance(
          provider: provider,
          targetPhoneNumber: phoneNumber,
          sameProviderWalletPhoneNumbers: sameProviderWalletPhoneNumbers,
          sameProviderWalletBalances: knownWalletBalances,
        );
        if (balance != null) {
          initialBalances[providerStr] = balance;
        }

        // Fetch historical transactions
        final transactions = await _inboxSmsService.getHistoricalTransactions(
          provider: provider,
          walletId: '', // To be filled by data source
          walletOwnerUid: '', // To be filled by data source
          phoneNumber: phoneNumber,
          sameProviderWalletPhoneNumbers: sameProviderWalletPhoneNumbers,
          sameProviderWalletBalances: knownWalletBalances,
        );
        historicalTransactions[providerStr] = transactions;
      }

      await _remoteDataSource.addWallets(
        phoneNumber: phoneNumber,
        providers: providers,
        initialBalances: initialBalances,
        deviceId: deviceId,
        historicalTransactions: historicalTransactions,
      );
    }, tag: 'WalletRepositoryImpl.addWallets');
  }

  @override
  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId) {
    return executeAndHandleErrors(() async {
      final walletDto = await _detailsDataSource.getWallet(walletId);
      final wallet = walletDto.toEntity();
      final transactionsDto = await _detailsDataSource.getRecentTransactions(
        wallet,
      );
      return WalletDetailsEntity(
        wallet: wallet,
        recentTransactions: transactionsDto
            .map((dto) => dto.toEntity())
            .toList(),
      );
    }, tag: 'WalletRepositoryImpl.getWalletDetails');
  }

  @override
  Future<Result<void>> deleteWallet(String walletId) {
    return executeAndHandleErrors(() async {
      await _remoteDataSource.deleteWallet(walletId);
      _walletMetaCache.invalidate(walletId);
    }, tag: 'WalletRepositoryImpl.deleteWallet');
  }

  @override
  Future<Result<void>> resetWalletStats(String walletId) {
    return executeAndHandleErrors(
      () => _remoteDataSource.resetWalletStats(walletId),
      tag: 'WalletRepositoryImpl.resetWalletStats',
    );
  }

  @override
  Future<Result<void>> updateWalletBalance({
    required String walletId,
    required double balance,
  }) {
    return executeAndHandleErrors(
      () => _remoteDataSource.updateWalletBalance(
        walletId: walletId,
        balance: balance,
      ),
      tag: 'WalletRepositoryImpl.updateWalletBalance',
    );
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<String> _resolveDeviceId() async {
    final deviceId = await _deviceInfoService.getDeviceId();
    final deviceName = await _deviceInfoService.getDeviceName();

    if (deviceName.isEmpty && deviceId.isEmpty) {
      throw const UnknownFailure(
        technicalMessage: 'Unable to resolve device metadata for wallet setup.',
      );
    }

    if (deviceName.isEmpty) return deviceId;
    if (deviceId.isEmpty) return deviceName;
    return '$deviceName ($deviceId)';
  }

  Future<List<String>> _resolveSameProviderPhoneNumbers({
    required WalletProvider provider,
    required String targetPhoneNumber,
    required List<WalletEntity> existingWallets,
  }) async {
    final phoneNumbers =
        existingWallets
            .where((wallet) => wallet.provider == provider)
            .map((wallet) => wallet.phoneNumber)
            .toSet()
          ..add(targetPhoneNumber);

    log(
      'Using persisted wallet numbers for ${provider.toValue} during wallet setup.',
      name: _tag,
    );
    return phoneNumbers.toList(growable: false);
  }

  /// Builds a map of normalized phone number → current balance for all
  /// existing wallets of [provider] that are NOT the [targetPhoneNumber].
  /// Used as anchors for the backward balance-walk in history attribution.
  Map<String, double> _resolveKnownWalletBalances({
    required WalletProvider provider,
    required String targetPhoneNumber,
    required List<WalletEntity> existingWallets,
  }) {
    final normalizedTarget = EgyptianPhoneNumber.tryNormalizeMobile(
      targetPhoneNumber,
    );
    final balances = <String, double>{};
    for (final wallet in existingWallets) {
      if (wallet.provider != provider) continue;
      final normalized = EgyptianPhoneNumber.tryNormalizeMobile(
        wallet.phoneNumber,
      );
      if (normalized == null || normalized == normalizedTarget) continue;
      balances[normalized] = wallet.currentBalance;
    }
    return balances;
  }
}

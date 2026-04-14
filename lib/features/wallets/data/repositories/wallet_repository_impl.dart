import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/device_info_service.dart';
import '../../../../core/services/phone_number_service.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/wallet_details_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_details_remote_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
    required WalletDetailsRemoteDataSource detailsDataSource,
    required PhoneNumberService phoneNumberService,
    required DeviceInfoService deviceInfoService,
  }) : _remoteDataSource = remoteDataSource,
       _detailsDataSource = detailsDataSource,
       _phoneNumberService = phoneNumberService,
       _deviceInfoService = deviceInfoService;

  final WalletRemoteDataSource _remoteDataSource;
  final WalletDetailsRemoteDataSource _detailsDataSource;
  final PhoneNumberService _phoneNumberService;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<Result<List<String>>> getDevicePhoneNumbers() {
    return executeAndHandleErrors(
      () => _phoneNumberService.getDevicePhoneNumbers(),
      tag: 'WalletRepositoryImpl.getDevicePhoneNumbers',
    );
  }

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
      await _remoteDataSource.addWallets(
        phoneNumber: phoneNumber,
        providers: providers,
        deviceId: deviceId,
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
    return executeAndHandleErrors(
      () => _remoteDataSource.deleteWallet(walletId),
      tag: 'WalletRepositoryImpl.deleteWallet',
    );
  }

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
}

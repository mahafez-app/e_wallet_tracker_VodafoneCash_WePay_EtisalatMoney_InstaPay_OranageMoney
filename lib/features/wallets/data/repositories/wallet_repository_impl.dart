import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/wallet_details_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/sms_permission_data_source.dart';
import '../datasources/wallet_details_remote_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;
  final WalletDetailsRemoteDataSource _detailsDataSource;
  final SmsPermissionDataSource _permissionDataSource;

  const WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
    required WalletDetailsRemoteDataSource detailsDataSource,
    required SmsPermissionDataSource permissionDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _detailsDataSource = detailsDataSource,
       _permissionDataSource = permissionDataSource;

  @override
  Future<Result<List<WalletEntity>>> getWallets() {
    return _executeAndHandleErrors(() async {
      final wallets = await _remoteDataSource.getWallets();
      return wallets.map((dto) => dto.toEntity()).toList();
    }, tag: 'WalletRepositoryImpl.getWallets');
  }

  @override
  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required String deviceId,
  }) {
    return _executeAndHandleErrors(
      () => _remoteDataSource.addWallets(
        phoneNumber: phoneNumber,
        providers: providers,
        deviceId: deviceId,
      ),
      tag: 'WalletRepositoryImpl.addWallets',
    );
  }

  @override
  Future<Result<bool?>> requestSmsPermission() {
    return _executeAndHandleErrors(
      () => _permissionDataSource.requestSmsPermission(),
      tag: 'WalletRepositoryImpl.requestSmsPermission',
    );
  }

  @override
  Future<Result<bool>> hasSmsPermission() {
    return _executeAndHandleErrors(
      () => _permissionDataSource.hasSmsPermission(),
      tag: 'WalletRepositoryImpl.hasSmsPermission',
    );
  }

  @override
  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId) {
    return _executeAndHandleErrors(() async {
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

  Future<Result<T>> _executeAndHandleErrors<T>(
    Future<T> Function() action, {
    required String tag,
  }) {
    return executeAndHandleErrors(action, tag: tag);
  }
}

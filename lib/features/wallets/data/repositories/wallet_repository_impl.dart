import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/sms_permission_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;
  final SmsPermissionDataSource _permissionDataSource;

  const WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
    required SmsPermissionDataSource permissionDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _permissionDataSource = permissionDataSource;

  @override
  Future<Result<List<WalletEntity>>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required String deviceId,
  }) {
    return executeAndHandleErrors(
      () async {
        final models = await _remoteDataSource.addWallets(
          phoneNumber: phoneNumber,
          providerStrs: providers,
          deviceId: deviceId,
        );

        return models.map((e) => e.toEntity()).toList();
      },
      tag: 'WalletRepository.addWallets',
    );
  }

  @override
  Future<Result<bool>> requestSmsPermission() {
    return executeAndHandleErrors(
      () => _permissionDataSource.requestSmsPermission(),
      tag: 'WalletRepository.requestSmsPermission',
    );
  }

  @override
  Future<Result<bool>> hasSmsPermission() {
    return executeAndHandleErrors(
      () => _permissionDataSource.hasSmsPermission(),
      tag: 'WalletRepository.hasSmsPermission',
    );
  }
}

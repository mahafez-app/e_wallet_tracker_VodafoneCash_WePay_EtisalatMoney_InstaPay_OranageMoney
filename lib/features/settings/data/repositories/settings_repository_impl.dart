import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/sms_permission_data_source.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._smsPermissionDataSource);

  final SmsPermissionDataSource _smsPermissionDataSource;

  @override
  Future<Result<bool>> requestSmsPermission() {
    return executeAndHandleErrors(
      () => _smsPermissionDataSource.requestPermission(),
      tag: 'SettingsRepositoryImpl.requestSmsPermission',
    );
  }

  @override
  Future<Result<bool>> checkSmsPermission() {
    return executeAndHandleErrors(
      () => _smsPermissionDataSource.hasPermission(),
      tag: 'SettingsRepositoryImpl.checkSmsPermission',
    );
  }

  @override
  Future<Result<void>> openSmsPermissionSettings() {
    return executeAndHandleErrors(
      () => _smsPermissionDataSource.openSettings(),
      tag: 'SettingsRepositoryImpl.openSmsPermissionSettings',
    );
  }
}

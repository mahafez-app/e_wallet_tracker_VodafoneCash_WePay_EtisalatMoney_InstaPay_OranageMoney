import '../../../../core/error/result.dart';

abstract interface class SettingsRepository {
  Future<Result<bool>> requestSmsPermission();

  Future<Result<bool>> checkSmsPermission();

  Future<Result<void>> openSmsPermissionSettings();
}

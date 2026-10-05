import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/app_preferences_entity.dart';
import '../../domain/enums/app_language_preference.dart';
import '../../domain/enums/app_theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/app_preferences_local_data_source.dart';
import '../datasources/sms_permission_data_source.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({
    required this._smsPermissionDataSource,
    required this._appPreferencesLocalDataSource,
  });

  final SmsPermissionDataSource _smsPermissionDataSource;
  final AppPreferencesLocalDataSource _appPreferencesLocalDataSource;

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

  @override
  Future<Result<AppPreferencesEntity>> getAppPreferences() async {
    return executeAndHandleErrorsSync(
      () => _appPreferencesLocalDataSource.getAppPreferences(),
      tag: 'SettingsRepositoryImpl.getAppPreferences',
    );
  }

  @override
  Future<Result<void>> saveThemePreference(AppThemePreference preference) {
    return executeAndHandleErrors(
      () => _appPreferencesLocalDataSource.saveThemePreference(preference),
      tag: 'SettingsRepositoryImpl.saveThemePreference',
    );
  }

  @override
  Future<Result<void>> saveLanguagePreference(
    AppLanguagePreference preference,
  ) {
    return executeAndHandleErrors(
      () => _appPreferencesLocalDataSource.saveLanguagePreference(preference),
      tag: 'SettingsRepositoryImpl.saveLanguagePreference',
    );
  }

  @override
  Future<Result<void>> saveFontScalePreference(double fontScale) {
    return executeAndHandleErrors(
      () => _appPreferencesLocalDataSource.saveFontScalePreference(fontScale),
      tag: 'SettingsRepositoryImpl.saveFontScalePreference',
    );
  }
}

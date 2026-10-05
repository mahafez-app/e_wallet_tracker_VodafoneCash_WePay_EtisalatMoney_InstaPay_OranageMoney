import '../entities/app_preferences_entity.dart';
import '../enums/app_language_preference.dart';
import '../enums/app_theme_preference.dart';
import 'package:mahafez_core/mahafez_core.dart';
abstract interface class SettingsRepository {
  Future<Result<bool>> requestSmsPermission();

  Future<Result<bool>> checkSmsPermission();

  Future<Result<void>> openSmsPermissionSettings();

  Future<Result<AppPreferencesEntity>> getAppPreferences();

  Future<Result<void>> saveThemePreference(AppThemePreference preference);

  Future<Result<void>> saveLanguagePreference(AppLanguagePreference preference);

  Future<Result<void>> saveFontScalePreference(double fontScale);
}

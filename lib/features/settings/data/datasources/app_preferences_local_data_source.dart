import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_preferences_entity.dart';
import '../../domain/enums/app_language_preference.dart';
import '../../domain/enums/app_theme_preference.dart';

abstract interface class AppPreferencesLocalDataSource {
  AppPreferencesEntity getAppPreferences();

  Future<void> saveThemePreference(AppThemePreference preference);

  Future<void> saveLanguagePreference(AppLanguagePreference preference);
}

final class AppPreferencesLocalDataSourceImpl
    implements AppPreferencesLocalDataSource {
  const AppPreferencesLocalDataSourceImpl(this._sharedPreferences);

  static const String _themePreferenceKey = 'theme_preference';
  static const String _languagePreferenceKey = 'language_preference';

  final SharedPreferences _sharedPreferences;

  @override
  AppPreferencesEntity getAppPreferences() {
    return AppPreferencesEntity(
      themePreference: _resolveThemePreference(),
      languagePreference: _resolveLanguagePreference(),
    );
  }

  @override
  Future<void> saveThemePreference(AppThemePreference preference) async {
    await _sharedPreferences.setString(_themePreferenceKey, preference.name);
  }

  @override
  Future<void> saveLanguagePreference(AppLanguagePreference preference) async {
    await _sharedPreferences.setString(_languagePreferenceKey, preference.name);
  }

  AppThemePreference _resolveThemePreference() {
    final savedValue = _sharedPreferences.getString(_themePreferenceKey);

    return switch (savedValue) {
      'light' => AppThemePreference.light,
      'dark' => AppThemePreference.dark,
      _ => AppThemePreference.system,
    };
  }

  AppLanguagePreference _resolveLanguagePreference() {
    final savedValue = _sharedPreferences.getString(_languagePreferenceKey);

    return switch (savedValue) {
      'english' => AppLanguagePreference.english,
      'arabic' => AppLanguagePreference.arabic,
      _ => AppLanguagePreference.system,
    };
  }
}

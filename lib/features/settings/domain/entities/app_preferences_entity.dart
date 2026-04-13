import 'package:equatable/equatable.dart';

import '../enums/app_language_preference.dart';
import '../enums/app_theme_preference.dart';

final class AppPreferencesEntity extends Equatable {
  const AppPreferencesEntity({
    required this.themePreference,
    required this.languagePreference,
  });

  const AppPreferencesEntity.initial()
    : themePreference = AppThemePreference.system,
      languagePreference = AppLanguagePreference.system;

  final AppThemePreference themePreference;
  final AppLanguagePreference languagePreference;

  AppPreferencesEntity copyWith({
    AppThemePreference? themePreference,
    AppLanguagePreference? languagePreference,
  }) {
    return AppPreferencesEntity(
      themePreference: themePreference ?? this.themePreference,
      languagePreference: languagePreference ?? this.languagePreference,
    );
  }

  @override
  List<Object?> get props => [themePreference, languagePreference];
}

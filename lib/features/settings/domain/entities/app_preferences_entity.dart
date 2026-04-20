import 'package:equatable/equatable.dart';

import '../enums/app_language_preference.dart';
import '../enums/app_theme_preference.dart';

final class AppPreferencesEntity extends Equatable {
  const AppPreferencesEntity({
    required this.themePreference,
    required this.languagePreference,
    required this.fontScale,
  });

  const AppPreferencesEntity.initial()
    : themePreference = AppThemePreference.system,
      languagePreference = AppLanguagePreference.system,
      fontScale = defaultFontScale;

  static const double minFontScale = 0.85;
  static const double maxFontScale = 1.30;
  static const double defaultFontScale = 1.0;
  static const double fontScaleStep = 0.05;

  final AppThemePreference themePreference;
  final AppLanguagePreference languagePreference;
  final double fontScale;

  AppPreferencesEntity copyWith({
    AppThemePreference? themePreference,
    AppLanguagePreference? languagePreference,
    double? fontScale,
  }) {
    return AppPreferencesEntity(
      themePreference: themePreference ?? this.themePreference,
      languagePreference: languagePreference ?? this.languagePreference,
      fontScale: normalizeFontScale(fontScale ?? this.fontScale),
    );
  }

  static double normalizeFontScale(double value) {
    final clampedValue = value.clamp(minFontScale, maxFontScale);
    final steppedValue =
        ((clampedValue - minFontScale) / fontScaleStep).round() * fontScaleStep;

    return double.parse((minFontScale + steppedValue).toStringAsFixed(2));
  }

  @override
  List<Object?> get props => [themePreference, languagePreference, fontScale];
}

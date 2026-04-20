import '../entities/app_preferences_entity.dart';

abstract final class AppFontScale {
  static const double min = AppPreferencesEntity.minFontScale;
  static const double max = AppPreferencesEntity.maxFontScale;
  static const double step = AppPreferencesEntity.fontScaleStep;
  static const double initial = AppPreferencesEntity.defaultFontScale;
  static final int divisions = ((max - min) / step).round();
}

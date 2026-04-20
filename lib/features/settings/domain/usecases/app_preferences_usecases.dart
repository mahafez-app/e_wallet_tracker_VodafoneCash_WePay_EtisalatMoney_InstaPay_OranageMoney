import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_preferences_entity.dart';
import '../enums/app_language_preference.dart';
import '../enums/app_theme_preference.dart';
import '../repositories/settings_repository.dart';

final class GetAppPreferencesUseCase
    implements NoParamsUseCase<AppPreferencesEntity> {
  const GetAppPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<AppPreferencesEntity>> call() {
    return _repository.getAppPreferences();
  }
}

final class SaveThemePreferenceUseCase
    implements UseCase<void, AppThemePreference> {
  const SaveThemePreferenceUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(AppThemePreference params) {
    return _repository.saveThemePreference(params);
  }
}

final class SaveLanguagePreferenceUseCase
    implements UseCase<void, AppLanguagePreference> {
  const SaveLanguagePreferenceUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(AppLanguagePreference params) {
    return _repository.saveLanguagePreference(params);
  }
}

final class SaveFontScalePreferenceUseCase implements UseCase<void, double> {
  const SaveFontScalePreferenceUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(double params) {
    return _repository.saveFontScalePreference(params);
  }
}

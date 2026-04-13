import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/app_preferences_local_data_source.dart';
import '../data/datasources/sms_permission_data_source.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/usecases/app_preferences_usecases.dart';
import '../domain/usecases/sms_permission_usecases.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden during app bootstrap.',
  );
});

final smsPermissionDataSourceProvider = Provider<SmsPermissionDataSource>(
  (_) => const SmsPermissionDataSourceImpl(),
);

final appPreferencesLocalDataSourceProvider =
    Provider<AppPreferencesLocalDataSource>(
      (ref) => AppPreferencesLocalDataSourceImpl(
        ref.watch(sharedPreferencesProvider),
      ),
    );

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(
    smsPermissionDataSource: ref.watch(smsPermissionDataSourceProvider),
    appPreferencesLocalDataSource: ref.watch(
      appPreferencesLocalDataSourceProvider,
    ),
  ),
);

final requestSmsPermissionUseCaseProvider =
    Provider<RequestSmsPermissionUseCase>(
      (ref) =>
          RequestSmsPermissionUseCase(ref.watch(settingsRepositoryProvider)),
    );

final checkSmsPermissionUseCaseProvider = Provider<CheckSmsPermissionUseCase>(
  (ref) => CheckSmsPermissionUseCase(ref.watch(settingsRepositoryProvider)),
);

final openSmsPermissionSettingsUseCaseProvider =
    Provider<OpenSmsPermissionSettingsUseCase>(
      (ref) => OpenSmsPermissionSettingsUseCase(
        ref.watch(settingsRepositoryProvider),
      ),
    );

final getAppPreferencesUseCaseProvider = Provider<GetAppPreferencesUseCase>(
  (ref) => GetAppPreferencesUseCase(ref.watch(settingsRepositoryProvider)),
);

final saveThemePreferenceUseCaseProvider = Provider<SaveThemePreferenceUseCase>(
  (ref) => SaveThemePreferenceUseCase(ref.watch(settingsRepositoryProvider)),
);

final saveLanguagePreferenceUseCaseProvider =
    Provider<SaveLanguagePreferenceUseCase>(
      (ref) =>
          SaveLanguagePreferenceUseCase(ref.watch(settingsRepositoryProvider)),
    );

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/sms_permission_data_source.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/usecases/sms_permission_usecases.dart';

final smsPermissionDataSourceProvider = Provider<SmsPermissionDataSource>(
  (_) => const SmsPermissionDataSourceImpl(),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(smsPermissionDataSourceProvider)),
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

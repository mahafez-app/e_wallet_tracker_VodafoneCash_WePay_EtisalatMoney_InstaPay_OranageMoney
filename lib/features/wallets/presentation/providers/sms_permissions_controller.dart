import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/sms_providers.dart';
import '../../providers/wallets_providers.dart';

final smsPermissionsControllerProvider =
    AsyncNotifierProvider.autoDispose<SmsPermissionsController, void>(
      SmsPermissionsController.new,
    );

class SmsPermissionsController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<bool> requestPermission() async {
    state = const AsyncLoading();

    final requestUseCase = ref.read(requestSmsPermissionUseCaseProvider);
    final result = await requestUseCase();

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        ref.invalidate(smsReadinessProvider);
        return true;
      },
    );
  }
}

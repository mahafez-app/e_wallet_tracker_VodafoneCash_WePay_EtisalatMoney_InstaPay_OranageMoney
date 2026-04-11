import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallets/providers/wallets_providers.dart';

final homeSmsControllerProvider =
    AsyncNotifierProvider.autoDispose<HomeSmsController, void>(
      HomeSmsController.new,
    );

/// Handles the one-time SMS permission prompt on the home screen.
/// Called once per session when wallet data first arrives.
class HomeSmsController extends AsyncNotifier<void> {
  @override
  void build() {}

  /// Checks wallet permissions and calls [navigate] if the prompt is needed.
  /// Guards against duplicate prompts within the same session using
  /// [hasPromptedWalletPermissionsSessionProvider].
  Future<void> checkAndPromptIfNeeded({
    required bool hasWallets,
    required VoidCallback navigate,
  }) async {
    if (!hasWallets) return;

    final hasPrompted = ref.read(hasPromptedWalletPermissionsSessionProvider);
    if (hasPrompted) return;

    // Mark immediately to prevent double-triggers from stream re-emissions.
    ref.read(hasPromptedWalletPermissionsSessionProvider.notifier).state = true;

    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    result.fold((_) => null, (hasPermission) {
      if (!hasPermission) navigate();
    });
  }
}

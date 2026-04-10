import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallets/providers/wallets_providers.dart';

final checkAndPromptSmsPermissionProvider =
    Provider.autoDispose<
      Future<void> Function(bool hasWallets, void Function() onPrompt)
    >((ref) {
      return (bool hasWallets, void Function() onPrompt) async {
        if (!hasWallets) return;

        final hasPrompted = ref.read(hasPromptedSmsPermissionSessionProvider);
        if (hasPrompted) return;

        // Mark as prompted immediately to avoid duplicate prompts
        ref.read(hasPromptedSmsPermissionSessionProvider.notifier).state = true;

        final checkUseCase = ref.read(checkSmsPermissionUseCaseProvider);
        final result = await checkUseCase();

        result.fold((_) => null, (hasPermission) {
          if (!hasPermission) onPrompt();
        });
      };
    });

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../features/transactions/providers/transactions_providers.dart';
import '../../features/wallets/providers/wallets_providers.dart';
import '../domain/entities/wallet_entity.dart';
import '../services/sms_transaction_service.dart';

/// Internal representation of SMS readiness state.
typedef SmsReadiness = ({bool isPermitted, List<WalletEntity> wallets});

/// Tracks whether the SMS permission prompt has already been shown in the
/// current app session.
final hasPromptedWalletPermissionsSessionProvider = StateProvider<bool>(
  (ref) => false,
);

/// Evaluates wallet-sync permissions and fetches wallets once per session.
/// Invalidate this provider after permission is granted to re-evaluate.
final smsReadinessProvider = FutureProvider<SmsReadiness>((ref) async {
  final permissionResult = await ref.read(checkSmsPermissionUseCaseProvider)();
  final isPermitted = permissionResult.fold((_) => false, (granted) => granted);

  if (!isPermitted) {
    return (isPermitted: false, wallets: const <WalletEntity>[]);
  }

  final walletResult = await ref.read(getWalletsUseCaseProvider).call();
  final wallets = walletResult.fold((_) => <WalletEntity>[], (w) => w);

  return (isPermitted: true, wallets: wallets);
});

/// Manages the [SmsTransactionService] lifecycle.
/// Activating this provider registers the SMS listener with the native side
/// as soon as permissions are granted — even if the wallet list is empty.
final smsTransactionListenerProvider =
    Provider.autoDispose<SmsTransactionService?>((ref) {
      final readiness = ref.watch(smsReadinessProvider).value;
      if (readiness == null || !readiness.isPermitted) return null;

      final service = SmsTransactionService(
        wallets: readiness.wallets,
        saveTransactionUseCase: ref.watch(saveTransactionUseCaseProvider),
      );
      service.startListening();
      ref.onDispose(service.stopListening);
      return service;
    });

final smsPermissionPromptControllerProvider =
    AsyncNotifierProvider.autoDispose<SmsPermissionPromptController, void>(
      SmsPermissionPromptController.new,
    );

class SmsPermissionPromptController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> checkAndPromptIfNeeded({
    required bool hasWallets,
    required VoidCallback navigate,
  }) async {
    if (!hasWallets) return;

    final hasPrompted = ref.read(hasPromptedWalletPermissionsSessionProvider);
    if (hasPrompted) return;

    ref.read(hasPromptedWalletPermissionsSessionProvider.notifier).state = true;

    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    result.fold((_) => null, (hasPermission) {
      if (!hasPermission) {
        navigate();
      }
    });
  }
}

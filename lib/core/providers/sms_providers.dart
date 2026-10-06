import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/providers/settings_providers.dart';

import 'package:wallet_product/wallet_product.dart';

import 'connectivity_providers.dart';

typedef SmsReadiness = ({bool isPermitted});

/// Evaluates platform permission. Wallet resolution remains product-owned.
/// Invalidate after permission changes to re-evaluate.
final smsReadinessProvider = FutureProvider<SmsReadiness>((ref) async {
  final permissionResult = await ref.read(checkSmsPermissionUseCaseProvider)();
  final isPermitted = permissionResult.fold((_) => false, (granted) => granted);

  if (!isPermitted) {
    return (isPermitted: false);
  }
  return (isPermitted: true);
});

/// Activating this provider registers the native SMS listener as soon as
/// permissions are confirmed — even if the wallet list is empty, so we never
/// miss an SMS that arrives before wallets sync.
final smsTransactionListenerProvider = Provider<void>((ref) {
  // Activate connectivity-based retries.
  ref.watch(connectivityRetryProvider);
  ref.watch(appLifecycleSmsSyncProvider);

  final readiness = ref.watch(smsReadinessProvider).value;
  if (readiness == null || !readiness.isPermitted) return;

  final service = ref.watch(walletSmsTransactionServiceProvider);
  ref.watch(pruneDeletedTransactionTombstonesProvider)();
  service.startListening();

  // Sweep any leftover items from a previous session.
  service.sweepRetryQueue();
  service.reconcileInboxHistory();
});

final appLifecycleSmsSyncProvider = Provider<void>((ref) {
  final listener = AppLifecycleListener(
    onResume: () {
      ref.invalidate(smsReadinessProvider);
    },
  );
  ref.onDispose(listener.dispose);
});

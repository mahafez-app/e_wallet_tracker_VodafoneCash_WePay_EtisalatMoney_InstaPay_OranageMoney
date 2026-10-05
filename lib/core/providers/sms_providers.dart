import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/providers/settings_providers.dart';
import '../../features/transactions/providers/transactions_providers.dart';
import '../../features/wallets/providers/wallets_providers.dart';
import '../domain/entities/wallet_entity.dart';
import 'package:mahafez_sms_engine/mahafez_sms_engine.dart'
    hide InboxSmsService, InboxSmsServiceImpl;
import '../services/inbox_sms_service.dart';
import '../services/sms_transaction_service.dart';
import 'cache_providers.dart';
import 'connectivity_providers.dart';

/// Internal record type for SMS readiness state.
typedef SmsReadiness = ({bool isPermitted, List<WalletEntity> wallets});

/// Evaluates SMS permission and fetches wallets once per session.
/// Invalidate after permission is granted to re-evaluate.
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
///
/// Activating this provider registers the native SMS listener as soon as
/// permissions are confirmed — even if the wallet list is empty, so we never
/// miss an SMS that arrives before wallets sync.
final smsTransactionServiceProvider = Provider<SmsTransactionService>(
  (ref) => SmsTransactionService(
    saveTransactionUseCase: ref.watch(saveTransactionUseCaseProvider),
    getLatestTransactionDateUseCase: ref.watch(
      getLatestTransactionDateUseCaseProvider,
    ),
    inboxSmsService: ref.watch(inboxSmsServiceProvider),
    pendingSmsRetryService: ref.watch(pendingSmsRetryServiceProvider),
  ),
);

final pendingSmsRetryServiceProvider = Provider<PendingSmsRetryService>(
  (ref) => PendingSmsRetryService(box: ref.watch(pendingSmsRetryBoxProvider)),
);

final inboxSmsServiceProvider = Provider<InboxSmsService>(
  (ref) => const InboxSmsServiceImpl(),
);

final smsTransactionListenerProvider = Provider<void>((ref) {
  // Activate connectivity-based retries.
  ref.watch(connectivityRetryProvider);
  ref.watch(appLifecycleSmsSyncProvider);

  final readiness = ref.watch(smsReadinessProvider).value;
  if (readiness == null || !readiness.isPermitted) return;

  final service = ref.watch(smsTransactionServiceProvider);
  ref.watch(deletedTransactionLocalDataSourceProvider).pruneExpired();
  service.updateWallets(readiness.wallets);
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

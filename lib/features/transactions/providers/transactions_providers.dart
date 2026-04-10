import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../wallets/providers/wallets_providers.dart';
import '../../../core/domain/entities/wallet_entity.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/services/sms_transaction_service.dart';
import '../data/datasources/transaction_remote_data_source.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/usecases/get_transactions_usecase.dart';
import '../domain/usecases/save_transaction_usecase.dart';

// ── DI wiring ──────────────────────────────────────────────────────────────

final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>((ref) {
  return TransactionRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    remoteDataSource: ref.watch(transactionRemoteDataSourceProvider),
  );
});

final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  return GetTransactionsUseCase(ref.watch(transactionRepositoryProvider));
});

final saveTransactionUseCaseProvider = Provider<SaveTransactionUseCase>((ref) {
  return SaveTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

// ── SMS listener wiring ──────────────────────────────────────────────────────

/// Internal representation of SMS readiness.
typedef SmsReadiness = ({bool isPermitted, List<WalletEntity> wallets});

/// Evaluates SMS permissions and fetches wallets.
final smsReadinessProvider = FutureProvider<SmsReadiness>((ref) async {
  final permissionResult =
      await ref.read(checkSmsPermissionUseCaseProvider).call();
  final isPermitted = permissionResult.fold((_) => false, (granted) => granted);

  if (!isPermitted) {
    return (isPermitted: false, wallets: const <WalletEntity>[]);
  }

  final walletResult = await ref.read(getWalletsUseCaseProvider).call();
  final wallets = walletResult.fold((_) => <WalletEntity>[], (w) => w);

  return (isPermitted: true, wallets: wallets);
});

/// Manages the [SmsTransactionService] lifecycle.
/// Activating this provider ensures that the SMS listener is registered with
/// the native side as soon as permissions are granted, even if the wallet list
/// is temporarily empty.
final smsTransactionListenerProvider = Provider<SmsTransactionService?>((ref) {
  final readinessAsync = ref.watch(smsReadinessProvider);
  final readiness = readinessAsync.value;

  if (readiness == null || !readiness.isPermitted) return null;

  final service = SmsTransactionService(
    wallets: readiness.wallets,
    saveTransactionUseCase: ref.watch(saveTransactionUseCaseProvider),
  );

  service.startListening();
  ref.onDispose(service.stopListening);

  return service;
});

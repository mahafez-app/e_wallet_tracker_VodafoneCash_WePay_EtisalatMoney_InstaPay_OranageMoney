import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/datasources/transaction_remote_data_source.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/usecases/get_wallet_transactions_usecase.dart';
import '../domain/usecases/get_workspace_transactions_usecase.dart';
import '../domain/usecases/mark_paid_usecases.dart';
import '../domain/usecases/note_usecases.dart';
import '../domain/usecases/save_transaction_usecase.dart';

// ── Infrastructure ───────────────────────────────────────────────────────────

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

// ── Use cases ────────────────────────────────────────────────────────────────

final saveTransactionUseCaseProvider = Provider<SaveTransactionUseCase>((ref) {
  return SaveTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

final getWalletTransactionsUseCaseProvider =
    Provider<GetWalletTransactionsUseCase>((ref) {
      return GetWalletTransactionsUseCase(
        ref.watch(transactionRepositoryProvider),
      );
    });

final getWorkspaceTransactionsUseCaseProvider =
    Provider<GetWorkspaceTransactionsUseCase>((ref) {
      return GetWorkspaceTransactionsUseCase(
        ref.watch(transactionRepositoryProvider),
      );
    });

final markAsPaidUseCaseProvider = Provider<MarkAsPaidUseCase>((ref) {
  return MarkAsPaidUseCase(ref.watch(transactionRepositoryProvider));
});

final markAsUnpaidUseCaseProvider = Provider<MarkAsUnpaidUseCase>((ref) {
  return MarkAsUnpaidUseCase(ref.watch(transactionRepositoryProvider));
});

final addNoteUseCaseProvider = Provider<AddNoteUseCase>((ref) {
  return AddNoteUseCase(ref.watch(transactionRepositoryProvider));
});

final editNoteUseCaseProvider = Provider<EditNoteUseCase>((ref) {
  return EditNoteUseCase(ref.watch(transactionRepositoryProvider));
});

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  return DeleteNoteUseCase(ref.watch(transactionRepositoryProvider));
});

final getNotesUseCaseProvider = Provider<GetNotesUseCase>((ref) {
  return GetNotesUseCase(ref.watch(transactionRepositoryProvider));
});

final getHistoryUseCaseProvider = Provider<GetHistoryUseCase>((ref) {
  return GetHistoryUseCase(ref.watch(transactionRepositoryProvider));
});

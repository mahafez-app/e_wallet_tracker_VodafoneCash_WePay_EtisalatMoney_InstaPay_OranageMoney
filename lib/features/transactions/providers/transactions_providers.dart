import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/cache_providers.dart';
import '../../../core/providers/firebase_providers.dart';
import '../data/datasources/deleted_transaction_local_data_source.dart';
import '../data/datasources/transaction_cache_local_data_source.dart';
import '../data/datasources/transaction_watch_remote_data_source.dart';
import '../data/datasources/transaction_firestore_support.dart';
import '../data/datasources/wallet_transaction_remote_data_source.dart';
import '../data/datasources/workspace_transactions_overview_remote_data_source.dart';
import '../data/datasources/workspace_transaction_remote_data_source.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/entities/transaction_page.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/usecases/delete_transaction_usecase.dart';
import '../domain/usecases/get_workspace_transactions_overview_usecase.dart';
import '../domain/usecases/get_latest_transaction_date_usecase.dart';
import '../domain/usecases/get_wallet_transactions_usecase.dart';
import '../domain/usecases/get_workspace_transactions_usecase.dart';
import '../domain/usecases/mark_paid_usecases.dart';
import '../domain/usecases/note_usecases.dart';
import '../domain/usecases/save_transaction_usecase.dart';
import '../domain/usecases/watch_transaction_usecase.dart';

// ── Infrastructure ───────────────────────────────────────────────────────────

/// Single session-scoped support class wired with the shared WalletMeta cache.
/// Not autoDispose — the cache must outlive individual screen navigations.
final transactionFirestoreSupportProvider =
    Provider<TransactionFirestoreSupport>(
      (ref) => TransactionFirestoreSupport(
        firestore: ref.watch(firestoreProvider),
        metaCache: ref.watch(walletMetaCacheProvider),
      ),
    );

final transactionWatchRemoteDataSourceProvider =
    Provider<TransactionWatchRemoteDataSource>((ref) {
      return TransactionWatchRemoteDataSourceImpl(
        support: ref.watch(transactionFirestoreSupportProvider),
      );
    });

final walletTransactionRemoteDataSourceProvider =
    Provider<WalletTransactionRemoteDataSource>((ref) {
      return WalletTransactionRemoteDataSourceImpl(
        support: ref.watch(transactionFirestoreSupportProvider),
      );
    });

final workspaceTransactionRemoteDataSourceProvider =
    Provider<WorkspaceTransactionRemoteDataSource>((ref) {
      return WorkspaceTransactionRemoteDataSourceImpl(
        support: ref.watch(transactionFirestoreSupportProvider),
      );
    });

final workspaceTransactionsOverviewRemoteDataSourceProvider =
    Provider<WorkspaceTransactionsOverviewRemoteDataSource>((ref) {
      return WorkspaceTransactionsOverviewRemoteDataSourceImpl(
        support: ref.watch(transactionFirestoreSupportProvider),
      );
    });

// ── Phase 4 — Hive local cache data source ───────────────────────────────────

final transactionCacheLocalDataSourceProvider =
    Provider<TransactionCacheLocalDataSource>(
      (ref) => TransactionCacheLocalDataSourceImpl(
        box: ref.watch(txFirstPageCacheBoxProvider),
      ),
    );

final deletedTransactionLocalDataSourceProvider =
    Provider<DeletedTransactionLocalDataSource>(
      (ref) => DeletedTransactionLocalDataSourceImpl(
        box: ref.watch(deletedTransactionTombstonesBoxProvider),
      ),
    );

/// Reads the cached first page for [walletId] without triggering any network
/// fetch. Used by [_TransactionsControllerPagination.loadInitial] to
/// pre-populate the screen on cold open before the Firestore response arrives.
final transactionFirstPageCacheProvider = FutureProvider.autoDispose
    .family<TransactionPage?, String>((ref, walletId) async {
      final cached = await ref
          .read(transactionCacheLocalDataSourceProvider)
          .getFirstPage(walletId);
      if (cached == null) return null;
      return TransactionPage(
        transactions: cached.transactions.map((e) => e.toEntity()).toList(),
        totalCount: cached.totalCount,
        nextCursor: null,
      );
    });

// ── Repository ────────────────────────────────────────────────────────────────

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    transactionWatchRemoteDataSource: ref.watch(
      transactionWatchRemoteDataSourceProvider,
    ),
    walletRemoteDataSource: ref.watch(
      walletTransactionRemoteDataSourceProvider,
    ),
    workspaceRemoteDataSource: ref.watch(
      workspaceTransactionRemoteDataSourceProvider,
    ),
    workspaceOverviewRemoteDataSource: ref.watch(
      workspaceTransactionsOverviewRemoteDataSourceProvider,
    ),
    cacheDataSource: ref.watch(transactionCacheLocalDataSourceProvider),
    deletedTransactionLocalDataSource: ref.watch(
      deletedTransactionLocalDataSourceProvider,
    ),
  );
});

// ── Use cases ────────────────────────────────────────────────────────────────

final saveTransactionUseCaseProvider = Provider<SaveTransactionUseCase>((ref) {
  return SaveTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

final getLatestTransactionDateUseCaseProvider =
    Provider<GetLatestTransactionDateUseCase>(
      (ref) => GetLatestTransactionDateUseCase(
        ref.watch(transactionRepositoryProvider),
      ),
    );

final deleteTransactionUseCaseProvider = Provider<DeleteTransactionUseCase>((
  ref,
) {
  return DeleteTransactionUseCase(ref.watch(transactionRepositoryProvider));
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

final getWorkspaceTransactionsOverviewUseCaseProvider =
    Provider<GetWorkspaceTransactionsOverviewUseCase>((ref) {
      return GetWorkspaceTransactionsOverviewUseCase(
        ref.watch(transactionRepositoryProvider),
      );
    });

final watchTransactionUseCaseProvider = Provider<WatchTransactionUseCase>((
  ref,
) {
  return WatchTransactionUseCase(ref.watch(transactionRepositoryProvider));
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

final getTransactionHistoryUseCaseProvider =
    Provider<GetTransactionHistoryUseCase>((ref) {
      return GetTransactionHistoryUseCase(
        ref.watch(transactionRepositoryProvider),
      );
    });

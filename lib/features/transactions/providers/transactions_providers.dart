import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_product/wallet_product.dart';

import '../data/datasources/workspace_transaction_remote_data_source.dart';
import '../data/datasources/workspace_transactions_overview_remote_data_source.dart';
import '../data/repositories/workspace_transaction_repository_impl.dart';
import '../domain/repositories/workspace_transaction_repository.dart';
import '../domain/usecases/get_workspace_transactions_overview_usecase.dart';
import '../domain/usecases/get_workspace_transactions_usecase.dart';

// Re-export wallet_product so presentation callers in transactions feature
// have transparent access to wallet-scoped transaction entities, use cases, and providers.
export 'package:wallet_product/wallet_product.dart';

// ── Workspace Remote Data Sources ─────────────────────────────────────────────

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

// ── Workspace Repository ──────────────────────────────────────────────────────

final workspaceTransactionRepositoryProvider =
    Provider<WorkspaceTransactionRepository>((ref) {
  return WorkspaceTransactionRepositoryImpl(
    workspaceRemoteDataSource:
        ref.watch(workspaceTransactionRemoteDataSourceProvider),
    workspaceOverviewRemoteDataSource:
        ref.watch(workspaceTransactionsOverviewRemoteDataSourceProvider),
  );
});

// ── Workspace Use Cases ───────────────────────────────────────────────────────

final getWorkspaceTransactionsUseCaseProvider =
    Provider<GetWorkspaceTransactionsUseCase>((ref) {
  return GetWorkspaceTransactionsUseCase(
    ref.watch(workspaceTransactionRepositoryProvider),
  );
});

final getWorkspaceTransactionsOverviewUseCaseProvider =
    Provider<GetWorkspaceTransactionsOverviewUseCase>((ref) {
  return GetWorkspaceTransactionsOverviewUseCase(
    ref.watch(workspaceTransactionRepositoryProvider),
  );
});

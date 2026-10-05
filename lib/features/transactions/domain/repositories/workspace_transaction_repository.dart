import 'package:mahafez_core/mahafez_core.dart';
import 'package:wallet_product/wallet_product.dart';

import '../entities/workspace_transactions_overview_entity.dart';

abstract interface class WorkspaceTransactionRepository {
  /// Merged + sorted list of transactions across multiple wallet IDs.
  Future<Result<TransactionPage>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WorkspaceTransactionsPageCursor? cursor,
  });

  /// High-level totals and recent slice for the workspace header.
  Future<Result<WorkspaceTransactionsOverviewEntity>>
      getWorkspaceTransactionsOverview({
    required List<String> walletIds,
  });
}

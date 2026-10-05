import 'package:mahafez_core/mahafez_core.dart';
import 'package:wallet_product/wallet_product.dart';

import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/workspace_transactions_overview_entity.dart';
import '../../domain/repositories/workspace_transaction_repository.dart';
import '../datasources/workspace_transaction_remote_data_source.dart';
import '../datasources/workspace_transactions_overview_remote_data_source.dart';

final class WorkspaceTransactionRepositoryImpl
    implements WorkspaceTransactionRepository {
  const WorkspaceTransactionRepositoryImpl({
    required WorkspaceTransactionRemoteDataSource workspaceRemoteDataSource,
    required WorkspaceTransactionsOverviewRemoteDataSource
        workspaceOverviewRemoteDataSource,
  })  : _workspaceRemoteDataSource = workspaceRemoteDataSource,
        _workspaceOverviewRemoteDataSource = workspaceOverviewRemoteDataSource;

  final WorkspaceTransactionRemoteDataSource _workspaceRemoteDataSource;
  final WorkspaceTransactionsOverviewRemoteDataSource
      _workspaceOverviewRemoteDataSource;

  @override
  Future<Result<TransactionPage>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WorkspaceTransactionsPageCursor? cursor,
  }) =>
      executeAndHandleErrors(() async {
        final result = await _workspaceRemoteDataSource
            .getWorkspaceTransactions(
          walletIds: walletIds,
          type: type,
          paidStatusFilter: paidStatusFilter,
          counterpartySuffixQuery: counterpartySuffixQuery,
          dateRange: dateRange,
          limit: limit,
          cursor: cursor,
        );
        return TransactionPage(
          transactions: result.transactions.map((e) => e.toEntity()).toList(),
          totalCount: result.totalCount,
          nextCursor: result.nextCursor,
        );
      }, tag: 'WorkspaceTransactionRepository.getWorkspaceTransactions');

  @override
  Future<Result<WorkspaceTransactionsOverviewEntity>>
      getWorkspaceTransactionsOverview({
    required List<String> walletIds,
  }) =>
          executeAndHandleErrors(
            () async {
              final result = await _workspaceOverviewRemoteDataSource
                  .getWorkspaceTransactionsOverview(walletIds: walletIds);
              return result.toEntity();
            },
            tag: 'WorkspaceTransactionRepository.getWorkspaceTransactionsOverview',
          );
}

import '../entities/transaction_date_range.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../entities/transaction_page.dart';
import '../entities/transaction_paid_status_filter.dart';
import '../repositories/transaction_repository.dart';

final class GetWorkspaceTransactionsUseCase
    implements UseCase<TransactionPage, GetWorkspaceTransactionsParams> {
  const GetWorkspaceTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<TransactionPage>> call(GetWorkspaceTransactionsParams params) =>
      _repository.getWorkspaceTransactions(
        walletIds: params.walletIds,
        type: params.type,
        paidStatusFilter: params.paidStatusFilter,
        counterpartySuffixQuery: params.counterpartySuffixQuery,
        dateRange: params.dateRange,
        limit: params.limit,
        cursor: params.cursor,
      );
}

final class GetWorkspaceTransactionsParams {
  const GetWorkspaceTransactionsParams({
    required this.walletIds,
    this.type,
    this.paidStatusFilter = TransactionPaidStatusFilter.all,
    this.counterpartySuffixQuery,
    this.dateRange,
    this.limit = 20,
    this.cursor,
  });

  final List<String> walletIds;
  final TransactionType? type;
  final TransactionPaidStatusFilter paidStatusFilter;
  final String? counterpartySuffixQuery;
  final TransactionDateRange? dateRange;
  final int limit;
  final WorkspaceTransactionsPageCursor? cursor;
}

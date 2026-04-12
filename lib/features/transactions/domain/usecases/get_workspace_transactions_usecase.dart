import '../entities/transaction_date_range.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/transaction_page.dart';
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
        dateRange: params.dateRange,
        limit: params.limit,
        cursor: params.cursor,
      );
}

final class GetWorkspaceTransactionsParams {
  const GetWorkspaceTransactionsParams({
    required this.walletIds,
    this.type,
    this.dateRange,
    this.limit = 20,
    this.cursor,
  });

  final List<String> walletIds;
  final TransactionType? type;
  final TransactionDateRange? dateRange;
  final int limit;
  final WorkspaceTransactionsPageCursor? cursor;
}

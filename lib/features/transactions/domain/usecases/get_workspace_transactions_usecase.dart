import '../entities/transaction_date_range.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

final class GetWorkspaceTransactionsUseCase
    implements
        UseCase<List<TransactionEntity>, GetWorkspaceTransactionsParams> {
  const GetWorkspaceTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<List<TransactionEntity>>> call(
    GetWorkspaceTransactionsParams params,
  ) => _repository.getWorkspaceTransactions(
    walletIds: params.walletIds,
    type: params.type,
    dateRange: params.dateRange,
    limit: params.limit,
  );
}

final class GetWorkspaceTransactionsParams {
  const GetWorkspaceTransactionsParams({
    required this.walletIds,
    this.type,
    this.dateRange,
    this.limit = 20,
  });

  final List<String> walletIds;
  final TransactionType? type;
  final TransactionDateRange? dateRange;
  final int limit;
}

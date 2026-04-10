import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

final class GetTransactionsUseCase
    implements UseCase<List<TransactionEntity>, GetTransactionsParams> {
  const GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<List<TransactionEntity>>> call(GetTransactionsParams params) {
    return _repository.getTransactions(
      walletId: params.walletId,
      limit: params.limit,
      before: params.before,
    );
  }
}

final class GetTransactionsParams {
  const GetTransactionsParams({
    this.walletId,
    this.limit,
    this.before,
  });

  final String? walletId;
  final int? limit;
  final DateTime? before;
}

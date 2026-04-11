import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

final class SaveTransactionUseCase implements UseCase<void, TransactionEntity> {
  const SaveTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(TransactionEntity params) {
    return _repository.saveTransaction(params);
  }
}

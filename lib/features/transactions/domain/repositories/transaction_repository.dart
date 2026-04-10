import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/result.dart';

abstract interface class TransactionRepository {
  Future<Result<List<TransactionEntity>>> getTransactions({
    String? walletId,
    int? limit,
    DateTime? before,
  });

  Future<Result<void>> markAsPaid(String transactionId, String walletId);
}

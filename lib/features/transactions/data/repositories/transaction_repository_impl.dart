import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required TransactionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final TransactionRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<TransactionEntity>>> getTransactions({
    String? walletId,
    int? limit,
    DateTime? before,
  }) {
    return executeAndHandleErrors(
      () async {
        final transactions = await _remoteDataSource.getTransactions(
          walletId: walletId,
          limit: limit,
          before: before,
        );
        return transactions.map((e) => e.toEntity()).toList();
      },
      tag: 'TransactionRepository.getTransactions',
    );
  }

  @override
  Future<Result<void>> markAsPaid(String transactionId, String walletId) {
    return executeAndHandleErrors(
      () => _remoteDataSource.markAsPaid(transactionId, walletId),
      tag: 'TransactionRepository.markAsPaid',
    );
  }

  @override
  Future<Result<void>> saveTransaction(TransactionEntity transaction) {
    return executeAndHandleErrors(
      () => _remoteDataSource.saveTransaction(transaction),
      tag: 'TransactionRepository.saveTransaction',
    );
  }
}

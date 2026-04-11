import '../entities/transaction_date_range.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/transaction_page.dart';
import '../repositories/transaction_repository.dart';

final class GetWalletTransactionsUseCase
    implements UseCase<TransactionPage, GetWalletTransactionsParams> {
  const GetWalletTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<TransactionPage>> call(GetWalletTransactionsParams params) =>
      _repository.getWalletTransactions(
        walletId: params.walletId,
        type: params.type,
        dateRange: params.dateRange,
        limit: params.limit,
        cursor: params.cursor,
      );
}

final class GetWalletTransactionsParams {
  const GetWalletTransactionsParams({
    required this.walletId,
    this.type,
    this.dateRange,
    this.limit = 20,
    this.cursor,
  });

  final String walletId;
  final TransactionType? type;
  final TransactionDateRange? dateRange;
  final int limit;
  final TransactionPageCursor? cursor;
}

import '../../domain/entities/transaction_page.dart';
import '../../../../core/data/models/transaction_dto.dart';

final class TransactionPageDto {
  const TransactionPageDto({
    required this.transactions,
    required this.totalCount,
    this.nextCursor,
  });

  final List<TransactionDto> transactions;
  final int totalCount;
  final TransactionPageCursor? nextCursor;
}

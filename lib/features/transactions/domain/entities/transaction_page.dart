import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/transaction_entity.dart';

final class TransactionPageCursor extends Equatable {
  const TransactionPageCursor({
    required this.createdAt,
    required this.transactionId,
  });

  final DateTime createdAt;
  final String transactionId;

  @override
  List<Object?> get props => [createdAt, transactionId];
}

final class TransactionPage extends Equatable {
  const TransactionPage({
    required this.transactions,
    required this.totalCount,
    this.nextCursor,
  });

  final List<TransactionEntity> transactions;
  final int totalCount;
  final TransactionPageCursor? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [transactions, totalCount, nextCursor];
}

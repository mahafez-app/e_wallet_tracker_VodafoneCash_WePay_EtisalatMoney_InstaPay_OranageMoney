import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/transaction_entity.dart';

final class MissingWalletTransactionsPreview extends Equatable {
  const MissingWalletTransactionsPreview({
    required this.transactions,
    this.fromDate,
  });

  final List<TransactionEntity> transactions;
  final DateTime? fromDate;

  int get count => transactions.length;

  @override
  List<Object?> get props => [transactions, fromDate];
}

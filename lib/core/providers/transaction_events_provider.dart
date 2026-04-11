import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/transaction_entity.dart';

final transactionUpdatesProvider =
    NotifierProvider.autoDispose<
      TransactionUpdatesNotifier,
      TransactionEntity?
    >(TransactionUpdatesNotifier.new);

class TransactionUpdatesNotifier extends Notifier<TransactionEntity?> {
  @override
  TransactionEntity? build() => null;

  void notifyUpdated(TransactionEntity transaction) => state = transaction;
}

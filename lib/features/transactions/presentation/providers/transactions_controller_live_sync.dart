part of 'transactions_controller.dart';

mixin _TransactionsControllerLiveSync on Notifier<TransactionsState> {
  Map<String, StreamSubscription<Result<TransactionEntity>>>
  get itemSubscriptions;

  void syncItemSubscriptions(List<TransactionEntity> transactions) {
    final activeKeys = transactions.map(transactionKey).toSet();
    final staleKeys = itemSubscriptions.keys
        .where((key) => !activeKeys.contains(key))
        .toList();
    for (final staleKey in staleKeys) {
      cancelItemSubscription(staleKey);
    }

    for (final transaction in transactions) {
      final key = transactionKey(transaction);
      if (itemSubscriptions.containsKey(key)) continue;
      itemSubscriptions[key] = ref
          .read(watchTransactionUseCaseProvider)
          .call(
            WatchTransactionParams(
              walletId: transaction.walletId,
              transactionId: transaction.id,
            ),
          )
          .listen((result) {
            if (!ref.mounted) return;
            result.fold((failure) {
              log(
                'Live transaction update failed: $failure',
                name: 'Presentation',
              );
            }, applyUpdatedTransaction);
          });
    }
  }

  void applyUpdatedTransaction(TransactionEntity updatedTransaction) {
    final index = state.transactions.indexWhere(
      (transaction) =>
          transaction.id == updatedTransaction.id &&
          transaction.walletId == updatedTransaction.walletId,
    );
    if (index == -1) return;

    final updatedTransactions = List<TransactionEntity>.of(state.transactions);
    updatedTransactions[index] = updatedTransaction;
    state = state.copyWith(transactions: updatedTransactions);
  }

  String transactionKey(TransactionEntity transaction) {
    return '${transaction.walletId}:${transaction.id}';
  }

  void cancelItemSubscription(String key) {
    itemSubscriptions.remove(key)?.cancel();
  }

  void disposeItemSubscriptions() {
    for (final subscription in itemSubscriptions.values) {
      subscription.cancel();
    }
    itemSubscriptions.clear();
  }
}

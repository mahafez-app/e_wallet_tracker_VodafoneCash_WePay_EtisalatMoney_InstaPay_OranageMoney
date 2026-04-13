part of 'transactions_controller.dart';

mixin _TransactionsControllerLiveSync on Notifier<TransactionsState> {
  void bindTransactionUpdates() {
    ref.listen<TransactionEntity?>(transactionUpdatesProvider, (_, next) {
      if (next == null) {
        return;
      }

      applyUpdatedTransaction(next);
    });
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
}

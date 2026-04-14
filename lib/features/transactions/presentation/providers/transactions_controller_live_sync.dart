part of 'transactions_controller.dart';

mixin _TransactionsControllerLiveSync on Notifier<TransactionsState> {
  TransactionsRouteData get arg;

  int startRequest();

  Future<void> loadInitial({required int requestId});

  void bindTransactionUpdates() {
    ref.listen<TransactionEvent?>(transactionUpdatesProvider, (_, next) {
      if (next == null) {
        return;
      }

      switch (next) {
        case TransactionUpdatedEvent(:final transaction):
          applyUpdatedTransaction(transaction);
        case TransactionDeletedEvent(
          :final walletId,
          :final transactionId,
        ):
          handleDeletedTransaction(
            deletedWalletId: walletId,
            transactionId: transactionId,
          );
      }
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

  void handleDeletedTransaction({
    required String deletedWalletId,
    required String transactionId,
  }) {
    final isRelevantWallet = switch (arg) {
      WalletTransactionsRouteData(:final walletId) => walletId == deletedWalletId,
      WorkspaceTransactionsRouteData(:final wallets) => wallets.any(
        (wallet) => wallet.walletId == deletedWalletId,
      ),
    };
    if (!isRelevantWallet) return;

    Future<void>(() => loadInitial(requestId: startRequest()));
  }
}

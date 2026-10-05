import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../transactions/domain/usecases/save_transaction_usecase.dart';
import '../../../transactions/providers/transactions_providers.dart';
import '../../domain/usecases/preview_missing_wallet_transactions_usecase.dart';
import '../../providers/wallets_providers.dart';
import 'wallet_transaction_sync_state.dart';

final walletTransactionSyncControllerProvider = NotifierProvider.autoDispose
    .family<
      WalletTransactionSyncController,
      WalletTransactionSyncState,
      String
    >(WalletTransactionSyncController.new);

class WalletTransactionSyncController
    extends Notifier<WalletTransactionSyncState> {
  WalletTransactionSyncController(this._walletId);

  final String _walletId;

  @override
  WalletTransactionSyncState build() => const WalletTransactionSyncState();

  Future<void> loadPreview() async {
    if (state.status == WalletTransactionSyncStatus.loading ||
        state.status == WalletTransactionSyncStatus.saving) {
      return;
    }

    state = state.copyWith(
      status: WalletTransactionSyncStatus.loading,
      clearFailure: true,
      syncedCount: 0,
    );

    final result = await ref.read(
      previewMissingWalletTransactionsUseCaseProvider,
    )(PreviewMissingWalletTransactionsParams(walletId: _walletId));

    result.fold(
      (failure) => state = state.copyWith(
        status: WalletTransactionSyncStatus.failure,
        failure: failure,
      ),
      (preview) => state = state.copyWith(
        status: WalletTransactionSyncStatus.ready,
        preview: preview,
        selectedTransactionIds: preview.transactions
            .map((transaction) => transaction.id)
            .toSet(),
        clearFailure: true,
      ),
    );
  }

  void toggleTransaction(String transactionId) {
    if (state.isBusy) return;

    final updatedSelection = Set<String>.of(state.selectedTransactionIds);
    if (!updatedSelection.add(transactionId)) {
      updatedSelection.remove(transactionId);
    }

    state = state.copyWith(selectedTransactionIds: updatedSelection);
  }

  Future<void> saveSelectedTransactions() async {
    final preview = state.preview;
    if (preview == null || state.selectedTransactionIds.isEmpty) {
      return;
    }

    state = state.copyWith(
      status: WalletTransactionSyncStatus.saving,
      clearFailure: true,
      syncedCount: 0,
    );

    final selectedTransactions =
        preview.transactions
            .where(
              (transaction) =>
                  state.selectedTransactionIds.contains(transaction.id),
            )
            .toList(growable: false)
          ..sort((left, right) => left.createdAt.compareTo(right.createdAt));

    var syncedCount = 0;
    for (final transaction in selectedTransactions) {
      final result = await ref.read(saveTransactionUseCaseProvider)(
        SaveTransactionParams(
          transaction: transaction,
          allowLocallyDeletedRestore: true,
        ),
      );
      final failure = result.fold<Failure?>((failure) => failure, (_) => null);
      if (failure == null || _isAlreadyExistsFailure(failure)) {
        syncedCount += 1;
        continue;
      }

      state = state.copyWith(
        status: WalletTransactionSyncStatus.failure,
        failure: failure,
        syncedCount: syncedCount,
      );
      return;
    }

    state = state.copyWith(
      status: WalletTransactionSyncStatus.success,
      syncedCount: syncedCount,
    );
  }

  bool _isAlreadyExistsFailure(Failure failure) {
    return failure is ValidationFailure &&
        failure.code == 'transaction-already-exists';
  }
}

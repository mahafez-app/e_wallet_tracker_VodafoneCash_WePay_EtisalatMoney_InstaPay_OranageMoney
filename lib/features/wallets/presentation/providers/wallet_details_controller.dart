import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/providers/transaction_events_provider.dart';
import '../../domain/entities/wallet_details_entity.dart';
import '../../domain/usecases/wallet_details_usecases.dart';
import '../../providers/wallets_providers.dart';

final walletDetailsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WalletDetailsController, WalletDetailsEntity, String>(
      WalletDetailsController.new,
    );

class WalletDetailsController extends AsyncNotifier<WalletDetailsEntity> {
  WalletDetailsController(this._walletId);

  final String _walletId;

  @override
  Future<WalletDetailsEntity> build() async {
    _listenTransactionUpdates();

    final result = await ref.read(getWalletDetailsUseCaseProvider)(
      GetWalletDetailsParams(walletId: _walletId),
    );

    return result.fold(
      (failure) => throw failure,
      (walletDetails) => walletDetails,
    );
  }

  void _listenTransactionUpdates() {
    ref.listen<TransactionEntity?>(transactionUpdatesProvider, (
      _,
      updatedTransaction,
    ) {
      if (updatedTransaction == null) return;
      _applyUpdatedTransaction(updatedTransaction);
    });
  }

  void _applyUpdatedTransaction(TransactionEntity updatedTransaction) {
    final currentDetails = state.asData?.value;
    if (currentDetails == null) return;

    final transactionIndex = currentDetails.recentTransactions.indexWhere(
      (transaction) => transaction.id == updatedTransaction.id,
    );
    if (transactionIndex == -1) return;

    final updatedTransactions = List<TransactionEntity>.of(
      currentDetails.recentTransactions,
    );
    updatedTransactions[transactionIndex] = updatedTransaction;

    state = AsyncValue.data(
      WalletDetailsEntity(
        wallet: currentDetails.wallet,
        recentTransactions: updatedTransactions,
      ),
    );
  }
}

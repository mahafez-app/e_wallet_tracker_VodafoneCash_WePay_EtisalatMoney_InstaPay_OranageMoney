import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../transactions/providers/transactions_providers.dart';
import '../../domain/entities/manual_wallet_transaction_assessment.dart';
import '../../domain/usecases/process_manual_wallet_transaction_usecase.dart';
import '../../providers/wallets_providers.dart';
import 'manual_wallet_transaction_state.dart';

final manualWalletTransactionControllerProvider = NotifierProvider.autoDispose
    .family<
      ManualWalletTransactionController,
      ManualWalletTransactionState,
      String
    >(ManualWalletTransactionController.new);

class ManualWalletTransactionController
    extends Notifier<ManualWalletTransactionState> {
  ManualWalletTransactionController(this._walletId);

  final String _walletId;

  @override
  ManualWalletTransactionState build() => const ManualWalletTransactionState();

  Future<void> analyze(String message) async {
    state = state.copyWith(
      status: ManualWalletTransactionStatus.analyzing,
      clearAssessment: true,
      clearFailure: true,
      clearSavedTransaction: true,
    );

    final result =
        await ref.read(processManualWalletTransactionUseCaseProvider)(
          ProcessManualWalletTransactionParams(
            walletId: _walletId,
            message: message,
            smsReceivedAt: DateTime.now(),
          ),
        );

    await result.fold(_setFailure, (assessment) async {
      if (assessment.requiresReview) {
        state = state.copyWith(
          status: ManualWalletTransactionStatus.reviewRequired,
          assessment: assessment,
        );
        return;
      }

      await _save(assessment.transaction, assessment: assessment);
    });
  }

  Future<void> confirmSelectedWalletSave() async {
    final assessment = state.assessment;
    if (assessment == null || !assessment.allowsSaveToSelectedWallet) {
      return;
    }

    await _save(assessment.transaction, assessment: assessment);
  }

  void resetTransientState() {
    if (state.status == ManualWalletTransactionStatus.idle &&
        state.assessment == null &&
        state.failure == null) {
      return;
    }

    state = const ManualWalletTransactionState();
  }

  Future<void> _save(
    TransactionEntity transaction, {
    required ManualWalletTransactionAssessment assessment,
  }) async {
    state = state.copyWith(
      status: ManualWalletTransactionStatus.saving,
      assessment: assessment,
      clearFailure: true,
      clearSavedTransaction: true,
    );

    final result = await ref.read(saveTransactionUseCaseProvider)(transaction);
    result.fold(
      _setFailure,
      (_) => state = state.copyWith(
        status: ManualWalletTransactionStatus.success,
        savedTransaction: transaction,
      ),
    );
  }

  Future<void> _setFailure(Failure failure) async {
    state = state.copyWith(
      status: ManualWalletTransactionStatus.failure,
      failure: failure,
      clearSavedTransaction: true,
    );
  }
}

import '../../../../core/domain/entities/transaction_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/manual_wallet_transaction_assessment.dart';

enum ManualWalletTransactionStatus {
  idle,
  analyzing,
  reviewRequired,
  saving,
  success,
  failure,
}

final class ManualWalletTransactionState {
  const ManualWalletTransactionState({
    this.status = ManualWalletTransactionStatus.idle,
    this.assessment,
    this.failure,
    this.savedTransaction,
  });

  final ManualWalletTransactionStatus status;
  final ManualWalletTransactionAssessment? assessment;
  final Failure? failure;
  final TransactionEntity? savedTransaction;

  bool get isBusy =>
      status == ManualWalletTransactionStatus.analyzing ||
      status == ManualWalletTransactionStatus.saving;

  ManualWalletTransactionState copyWith({
    ManualWalletTransactionStatus? status,
    ManualWalletTransactionAssessment? assessment,
    Failure? failure,
    TransactionEntity? savedTransaction,
    bool clearAssessment = false,
    bool clearFailure = false,
    bool clearSavedTransaction = false,
  }) {
    return ManualWalletTransactionState(
      status: status ?? this.status,
      assessment: clearAssessment ? null : assessment ?? this.assessment,
      failure: clearFailure ? null : failure ?? this.failure,
      savedTransaction: clearSavedTransaction
          ? null
          : savedTransaction ?? this.savedTransaction,
    );
  }
}

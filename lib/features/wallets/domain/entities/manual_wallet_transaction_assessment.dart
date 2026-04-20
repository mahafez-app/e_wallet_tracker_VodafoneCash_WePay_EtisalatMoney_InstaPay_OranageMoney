import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/entities/wallet_entity.dart';

enum ManualWalletTransactionReviewKind {
  none,
  needsConfirmation,
  explicitWalletMismatch,
  inferredWalletMismatch,
}

final class ManualWalletTransactionAssessment extends Equatable {
  const ManualWalletTransactionAssessment({
    required this.transaction,
    this.reviewKind = ManualWalletTransactionReviewKind.none,
    this.suggestedWallet,
    this.explicitWalletPhone,
  });

  final TransactionEntity transaction;
  final ManualWalletTransactionReviewKind reviewKind;
  final WalletEntity? suggestedWallet;
  final String? explicitWalletPhone;

  bool get requiresReview =>
      reviewKind != ManualWalletTransactionReviewKind.none;

  bool get allowsSaveToSelectedWallet =>
      reviewKind != ManualWalletTransactionReviewKind.explicitWalletMismatch;

  @override
  List<Object?> get props => [
    transaction,
    reviewKind,
    suggestedWallet,
    explicitWalletPhone,
  ];
}

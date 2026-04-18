import 'package:equatable/equatable.dart';
import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';

import '../../../../core/domain/entities/wallet_entity.dart';

final class WalletDetailsEntity extends Equatable {
  const WalletDetailsEntity({
    required this.wallet,
    required this.recentTransactions,
  });

  final WalletEntity wallet;
  final List<TransactionEntity> recentTransactions;

  double get suggestedBalance {
    for (final transaction in recentTransactions) {
      final statusBalance = transaction.statusBalance;
      if (statusBalance != null) {
        return statusBalance;
      }
    }

    return wallet.currentBalance;
  }

  @override
  List<Object?> get props => [wallet, recentTransactions];
}

import 'package:equatable/equatable.dart';

import '../enums/transaction_type.dart';
import '../enums/wallet_provider.dart';

base class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
    this.isPaid,
    this.message,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime createdAt;
  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;
  final bool? isPaid;
  final String? message;

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        createdAt,
        walletId,
        provider,
        phoneNumber,
        isPaid,
        message,
      ];
}

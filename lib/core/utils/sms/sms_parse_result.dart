import '../../domain/enums/transaction_type.dart';
import '../../domain/enums/wallet_provider.dart';

class SmsParseResult {
  const SmsParseResult({
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.provider,
    this.counterpartyNumber,
    this.referenceNumber,
    this.balance,
  });

  final double amount;
  final TransactionType type;
  final DateTime createdAt;
  final WalletProvider provider;
  final String? counterpartyNumber;
  final String? referenceNumber;
  final double? balance;
}

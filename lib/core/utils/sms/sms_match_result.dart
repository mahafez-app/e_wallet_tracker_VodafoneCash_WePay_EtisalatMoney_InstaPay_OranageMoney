// lib/core/utils/sms/sms_match_result.dart

import '../../domain/enums/transaction_type.dart';

class SmsMatchResult {
  const SmsMatchResult({
    required this.amount,
    required this.type,
    this.counterpartyNumber,
  });

  final double amount;
  final TransactionType type;
  final String? counterpartyNumber;
}

import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';

extension TransactionCounterpartyX on TransactionEntity {
  /// Extracts the counterparty Egyptian phone number from the SMS message.
  /// Looks for any valid Egyptian mobile number in the message,
  /// then excludes the wallet's own number to get the counterparty.
  /// Returns null if no counterparty number is found.
  String? get counterpartyNumber {
    final msg = message;
    if (msg == null || msg.isEmpty) return null;

    final numbers = _extractAllEgyptianNumbers(msg);
    if (numbers.isEmpty) return null;

    // Remove the wallet's own number from candidates
    final normalized = _normalizeEgyptianNumber(phoneNumber);
    final counterparties = numbers.where((n) => n != normalized).toList();

    return counterparties.firstOrNull;
  }

  /// Finds all Egyptian mobile numbers in the message and normalizes them.
  List<String> _extractAllEgyptianNumbers(String msg) {
    // Matches local (01XXXXXXXXX), international (+201XXXXXXXXX), or (00201XXXXXXXXX)
    final pattern = RegExp(r'(?:\+20|0020|0)(1[0-9]\d{8})');

    return pattern
        .allMatches(msg)
        .map((m) => '0${m.group(1)!}')
        .toSet() // deduplicate
        .toList();
  }

  String _normalizeEgyptianNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'\s+'), '');
    if (digits.startsWith('002')) return '0${digits.substring(3)}';
    if (digits.startsWith('+2')) return '0${digits.substring(2)}';
    return digits;
  }
}
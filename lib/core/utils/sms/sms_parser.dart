// lib/core/utils/sms/sms_parser.dart

import '../../domain/enums/wallet_provider.dart';
import 'sms_parse_result.dart';
import 'sms_pattern_matcher.dart';
import 'sms_patterns.dart';

abstract class SmsParser {
  WalletProvider get provider;
  List<String> get senderIds;

  List<RegExp> get receivePatterns;
  List<RegExp> get sendPatterns;
  List<RegExp> get refPatterns;

  SmsParseResult? parse(String message, DateTime smsReceivedAt) {
    final match = SmsPatternMatcher.match(
      message,
      receivePatterns: receivePatterns,
      sendPatterns: sendPatterns,
    );
    if (match == null) return null;

    return SmsParseResult(
      amount: match.amount,
      type: match.type,
      createdAt: extractDateTime(message) ?? smsReceivedAt,
      provider: provider,
      counterpartyNumber: match.counterpartyNumber,
      referenceNumber: extractRef(message),
    );
  }

  /// Override if a provider uses a non-standard date format.
  DateTime? extractDateTime(String message) =>
      parseDateShort(message) ??
      parseDateLongEn(message) ??
      parseDateArabicBank(message);

  String? extractRef(String message) {
    for (final pattern in refPatterns) {
      final m = pattern.firstMatch(message);
      if (m != null) return m.group(1);
    }
    return null;
  }

  // ─── Shared date parsers ──────────────────────────────────────────────────

  DateTime? parseDateShort(String msg) {
    final m = SmsPatterns.dateShort.firstMatch(msg);
    if (m == null) return null;
    return DateTime(
      2000 + int.parse(m.group(3)!),
      int.parse(m.group(2)!),
      int.parse(m.group(1)!),
      int.parse(m.group(4)!),
      int.parse(m.group(5)!),
    );
  }

  DateTime? parseDateLongEn(String msg) {
    final m = SmsPatterns.dateLongEn.firstMatch(msg);
    if (m == null) return null;
    var hour = int.parse(m.group(4)!);
    final isPm = m.group(7)!.toUpperCase() == 'PM';
    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;
    return DateTime(
      int.parse(m.group(3)!),
      _monthFromAbbr(m.group(1)!),
      int.parse(m.group(2)!),
      hour,
      int.parse(m.group(5)!),
      int.parse(m.group(6)!),
    );
  }

  DateTime? parseDateArabicBank(String msg) {
    final m = SmsPatterns.dateArabicBank.firstMatch(msg);
    if (m == null) return null;
    return DateTime(
      2000 + int.parse(m.group(3)!),
      int.parse(m.group(2)!),
      int.parse(m.group(1)!),
      int.parse(m.group(4)!),
      int.parse(m.group(5)!),
    );
  }

  int _monthFromAbbr(String abbr) {
    const map = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    return map[abbr.toLowerCase()] ?? 1;
  }
}

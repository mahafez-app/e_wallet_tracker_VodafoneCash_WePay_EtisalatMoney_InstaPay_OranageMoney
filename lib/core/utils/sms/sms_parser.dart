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
    final extractedDate = extractDateTime(message);

    return SmsParseResult(
      amount: match.amount,
      type: match.type,
      createdAt: extractedDate ?? smsReceivedAt,
      provider: provider,
      counterpartyNumber: match.counterpartyNumber,
      referenceNumber: extractRef(message),
      balance: extractBalance(message) ?? match.balance,
    );
  }

  /// Override if a provider uses a non-standard date format.
  DateTime? extractDateTime(String message) =>
      parseDateShort(message) ??
      parseDateShortReverse(message) ??
      parseDateLongEn(message) ??
      parseDateArabicBank(message);

  String? extractRef(String message) {
    for (final pattern in refPatterns) {
      final m = pattern.firstMatch(message);
      if (m != null) {
        // Return the last non-null group (the number)
        for (int i = m.groupCount; i >= 1; i--) {
          if (m.group(i) != null) return m.group(i);
        }
      }
    }
    return null;
  }

  double? extractBalance(String message) {
    final m = SmsPatterns.balanceAr.firstMatch(message) ??
        SmsPatterns.balanceEn.firstMatch(message);
    if (m == null) return null;
    return double.tryParse(m.group(1)!.replaceAll(',', '').trim());
  }

  // ─── Shared date parsers ──────────────────────────────────────────────────

  DateTime? parseDateShort(String msg) {
    final m = SmsPatterns.dateShort.firstMatch(msg);
    if (m == null) return null;

    int g1 = int.parse(m.group(1)!);
    int g2 = int.parse(m.group(2)!);
    int g3 = int.parse(m.group(3)!);
    int hh = int.parse(m.group(4)!);
    int mm = int.parse(m.group(5)!);

    // Heuristic: If first group is 4 digits or looks like a recent year (e.g. 26 for 2026)
    // while the third group is < 31, assume YY-MM-DD.
    // Otherwise assume DD-MM-YY (Egyptian standard).
    int year, month, day;
    if (g1 > 31 || (g1 == 26 && g3 != 26)) {
      year = g1 < 100 ? 2000 + g1 : g1;
      month = g2;
      day = g3;
    } else {
      year = g3 < 100 ? 2000 + g3 : g3;
      month = g2;
      day = g1;
    }

    return DateTime(year, month, day, hh, mm);
  }

  DateTime? parseDateShortReverse(String msg) {
    final m = SmsPatterns.dateShortReverse.firstMatch(msg);
    if (m == null) return null;

    int hh = int.parse(m.group(1)!);
    int mm = int.parse(m.group(2)!);
    int g1 = int.parse(m.group(3)!);
    int g2 = int.parse(m.group(4)!);
    int g3 = int.parse(m.group(5)!);

    int year, month, day;
    if (g1 > 31 || (g1 == 26 && g3 != 26)) {
      year = g1 < 100 ? 2000 + g1 : g1;
      month = g2;
      day = g3;
    } else {
      year = g3 < 100 ? 2000 + g3 : g3;
      month = g2;
      day = g1;
    }

    return DateTime(year, month, day, hh, mm);
  }

  DateTime? parseDateLongEn(String msg) {
    final m = SmsPatterns.dateLongEn.firstMatch(msg);
    if (m == null) return null;

    var hour = int.parse(m.group(4)!);
    final amPm = m.group(7)?.toUpperCase();

    if (amPm != null) {
      if (amPm == 'PM' && hour != 12) hour += 12;
      if (amPm == 'AM' && hour == 12) hour = 0;
    }

    final secondStr = m.group(6);
    final second = secondStr != null ? int.parse(secondStr) : 0;

    return DateTime(
      int.parse(m.group(3)!),
      _monthFromAbbr(m.group(1)!),
      int.parse(m.group(2)!),
      hour,
      int.parse(m.group(5)!),
      second,
    );
  }

  DateTime? parseDateArabicBank(String msg) {
    final m = SmsPatterns.dateArabicBank.firstMatch(msg);
    if (m == null) return null;

    // Groups: 1=Ref(optional), 2=Day, 3=Month, 4=Year(optional), 5=Hour, 6=Minute
    final day = int.parse(m.group(2)!);
    final month = int.parse(m.group(3)!);
    final yearStr = m.group(4);
    int year = yearStr != null ? int.parse(yearStr) : DateTime.now().year;
    if (year < 100) year += 2000;

    return DateTime(
      year,
      month,
      day,
      int.parse(m.group(5)!),
      int.parse(m.group(6)!),
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

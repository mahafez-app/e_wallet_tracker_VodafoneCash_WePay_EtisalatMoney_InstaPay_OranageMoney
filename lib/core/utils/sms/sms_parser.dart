// lib/core/utils/sms/sms_parser.dart

import '../../domain/enums/wallet_provider.dart';
import 'sms_parse_result.dart';
import 'sms_pattern_matcher.dart';
import 'sms_patterns.dart';

abstract class SmsParser {
  const SmsParser();

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

  // ── Shared date parsers ──────────────────────────────────────────────────

  DateTime? parseDateShort(String msg) {
    final m = SmsPatterns.dateShort.firstMatch(msg);
    if (m == null) return null;

    final g1 = int.parse(m.group(1)!);
    final g2 = int.parse(m.group(2)!);
    final g3 = int.parse(m.group(3)!);
    final hh = int.parse(m.group(4)!);
    final mm = int.parse(m.group(5)!);

    // Determine order: YY-MM-DD vs DD-MM-YY.
    // A value > 31 must be a year. For two-digit values, the one that
    // cannot be a valid day (> 31) or month (> 12) identifies the year.
    final int year, month, day;
    if (g1 > 31) {
      // e.g. 2026-04-14 or 26-04-14 where 26 > 12 (can't be month) and > ... actually check g3
      year = _expandYear(g1);
      month = g2;
      day = g3;
    } else if (g3 > 31) {
      // e.g. 14-04-2026
      year = _expandYear(g3);
      month = g2;
      day = g1;
    } else if (g1 > 12) {
      // g1 can't be a month, so it's DD-MM-YY
      year = _expandYear(g3);
      month = g2;
      day = g1;
    } else if (g3 <= 31 && g1 <= 12 && g3 < g1) {
      // Heuristic: if g3 < g1 and both are plausible days, g3 is likely year (YY)
      year = _expandYear(g3);
      month = g2;
      day = g1;
    } else {
      // Default to DD-MM-YY (Egyptian convention)
      year = _expandYear(g3);
      month = g2;
      day = g1;
    }

    return DateTime(year, month, day, hh, mm);
  }

  DateTime? parseDateShortReverse(String msg) {
    final m = SmsPatterns.dateShortReverse.firstMatch(msg);
    if (m == null) return null;

    final hh = int.parse(m.group(1)!);
    final mm = int.parse(m.group(2)!);
    final g1 = int.parse(m.group(3)!);
    final g2 = int.parse(m.group(4)!);
    final g3 = int.parse(m.group(5)!);

    final int year, month, day;
    if (g1 > 31) {
      year = _expandYear(g1);
      month = g2;
      day = g3;
    } else if (g3 > 31) {
      year = _expandYear(g3);
      month = g2;
      day = g1;
    } else if (g1 > 12) {
      year = _expandYear(g3);
      month = g2;
      day = g1;
    } else {
      year = _expandYear(g3);
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

    final day = int.parse(m.group(2)!);
    final month = int.parse(m.group(3)!);
    final yearStr = m.group(4);
    final year = _expandYear(
      yearStr != null ? int.parse(yearStr) : DateTime.now().year,
    );

    return DateTime(year, month, day, int.parse(m.group(5)!),
        int.parse(m.group(6)!));
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  /// Expands a two-digit year to four digits (e.g. 26 → 2026).
  /// Four-digit years are returned unchanged.
  static int _expandYear(int year) => year < 100 ? 2000 + year : year;

  static int _monthFromAbbr(String abbr) {
    const map = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4,
      'may': 5, 'jun': 6, 'jul': 7, 'aug': 8,
      'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    return map[abbr.toLowerCase()] ?? 1;
  }
}

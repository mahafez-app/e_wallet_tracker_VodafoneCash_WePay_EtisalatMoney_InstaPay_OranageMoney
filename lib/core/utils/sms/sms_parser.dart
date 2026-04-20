// lib/core/utils/sms/sms_parser.dart

import 'dart:developer';

import '../../domain/enums/wallet_provider.dart';
import 'sms_parse_result.dart';
import 'sms_pattern_matcher.dart';
import 'sms_patterns.dart';
import 'sms_phone_number_extractor.dart';

abstract class SmsParser {
  const SmsParser();

  WalletProvider get provider;
  List<String> get senderIds;

  List<RegExp> get receivePatterns;
  List<RegExp> get sendPatterns;
  List<RegExp> get refPatterns;

  SmsParseResult? parse(
    String message,
    DateTime smsReceivedAt, {
    bool useContentDate = false,
  }) {
    final match = SmsPatternMatcher.match(
      message,
      receivePatterns: receivePatterns,
      sendPatterns: sendPatterns,
    );
    if (match == null) return null;

    log(
      'Parsing SMS from ${senderIds.first} with system date: $smsReceivedAt',
      name: 'SmsParser',
    );

    final createdAt = useContentDate
        ? extractDateTime(message, smsReceivedAt)
        : smsReceivedAt;

    return SmsParseResult(
      amount: match.amount,
      type: match.type,
      createdAt: createdAt,
      provider: provider,
      counterpartyNumber: match.counterpartyNumber,
      referenceNumber: extractRef(message),
      balance: extractBalance(message) ?? match.balance,
      mentionedPhoneNumbers:
          SmsPhoneNumberExtractor.extractEgyptianMobileNumbers(message),
    );
  }

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
    final m =
        SmsPatterns.balanceAr.firstMatch(message) ??
        SmsPatterns.balanceEn.firstMatch(message);
    if (m == null) return null;
    return double.tryParse(m.group(1)!.replaceAll(',', '').trim());
  }

  DateTime extractDateTime(String message, DateTime defaultDate) {
    int day = defaultDate.day;
    int month = defaultDate.month;
    int year = defaultDate.year;
    bool dateFound = false;

    // 1. Try ISO (YYYY-MM-DD or YYYY/MM/DD)
    final iso = SmsPatterns.dateIso.firstMatch(message);
    if (iso != null) {
      year = int.tryParse(iso.group(1) ?? '') ?? year;
      month = int.tryParse(iso.group(2) ?? '') ?? month;
      day = int.tryParse(iso.group(3) ?? '') ?? day;
      dateFound = true;
    }

    // 2. Try English (MMM DD, YYYY)
    if (!dateFound) {
      final eng = SmsPatterns.dateEnglish.firstMatch(message);
      if (eng != null) {
        month = _monthToNumber(eng.group(1) ?? '');
        day = int.tryParse(eng.group(2) ?? '') ?? day;
        year = int.tryParse(eng.group(3) ?? '') ?? year;
        dateFound = true;
      }
    }

    // 3. Try Day-First (DD-MM-YYYY or DD-MM-YY)
    if (!dateFound) {
      final dayFirst = SmsPatterns.dateDayFirst.firstMatch(message);
      if (dayFirst != null) {
        final d = int.tryParse(dayFirst.group(1) ?? '') ?? 0;
        final m = int.tryParse(dayFirst.group(2) ?? '') ?? 0;
        final yStr = dayFirst.group(3) ?? '';
        final y = _resolveYear(yStr);

        // Sanity check: if it looks like YY-MM-DD but matched Day-First
        // (e.g. 26-04-14), prioritize the year-first interpretation if group 1 > 31
        if (d <= 31 && m <= 12) {
          day = d;
          month = m;
          year = y;
          dateFound = true;
        }
      }
    }

    // 4. Try Year-First (YY-MM-DD)
    if (!dateFound) {
      final yearFirst = SmsPatterns.dateYearFirst.firstMatch(message);
      if (yearFirst != null) {
        year = 2000 + (int.tryParse(yearFirst.group(1) ?? '') ?? 0);
        month = int.tryParse(yearFirst.group(2) ?? '') ?? month;
        day = int.tryParse(yearFirst.group(3) ?? '') ?? day;
        dateFound = true;
      }
    }

    int hour = defaultDate.hour;
    int minute = defaultDate.minute;
    int second = defaultDate.second;

    final timeMatch = SmsPatterns.timePattern.firstMatch(message);
    if (timeMatch != null) {
      hour = int.tryParse(timeMatch.group(1) ?? '') ?? hour;
      minute = int.tryParse(timeMatch.group(2) ?? '') ?? minute;
      second = int.tryParse(timeMatch.group(3) ?? '0') ?? 0;

      final amPm = timeMatch.group(4)?.toUpperCase();
      if (amPm == 'PM' && hour < 12) hour += 12;
      if (amPm == 'AM' && hour == 12) hour = 0;
    }

    try {
      final result = DateTime(year, month, day, hour, minute, second);
      // Basic sanity check: if the date is way in the future or past, fallback.
      if (result.year < 2020 || result.year > 2035) return defaultDate;
      return result;
    } catch (_) {
      return defaultDate;
    }
  }

  int _monthToNumber(String month) {
    const months = {
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
    return months[month.toLowerCase()] ?? 1;
  }

  int _resolveYear(String yearStr) {
    if (yearStr.length == 2) return 2000 + (int.tryParse(yearStr) ?? 0);
    if (yearStr.length == 4) {
      return int.tryParse(yearStr) ?? DateTime.now().year;
    }
    return DateTime.now().year;
  }
}

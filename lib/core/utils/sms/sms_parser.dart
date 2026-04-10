// sms_parser.dart

import '../../domain/enums/wallet_provider.dart';
import 'sms_parse_result.dart';

abstract class SmsParser {
  /// The provider this parser handles.
  WalletProvider get provider;

  /// SMS sender IDs / shortcodes that belong to this provider.
  /// Case-insensitive matching is applied by the registry.
  List<String> get senderIds;

  /// Returns null if the message is not a transaction SMS.
  SmsParseResult? parse(String message, DateTime smsReceivedAt);

  // ─── Shared utilities available to all parsers ──────────────────────────

  /// Normalizes any Egyptian number format to 01XXXXXXXXX.
  /// 00201XXXXXXXXX → 01XXXXXXXXX
  /// +201XXXXXXXXX  → 01XXXXXXXXX
  String? normalizeNumber(String? raw) {
    if (raw == null) return null;
    final digits = raw.replaceAll(RegExp(r'\s+'), '');
    if (digits.startsWith('002')) return '0${digits.substring(3)}';
    if (digits.startsWith('+2')) return '0${digits.substring(2)}';
    if (digits.startsWith('01') && digits.length == 11) return digits;
    return null; // unrecognizable format — don't store garbage
  }

  /// Parses amounts like "1,500.00", "1500", "150.5"
  double? parseAmount(String raw) {
    return double.tryParse(raw.replaceAll(',', '').trim());
  }

  /// DD-MM-YY HH:mm  (e.g. "08-04-26 17:50")
  DateTime? parseDdMmYyHhMm(String msg) {
    final pattern = RegExp(r'(\d{2})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})');
    final m = pattern.firstMatch(msg);
    if (m == null) return null;
    return DateTime(
      2000 + int.parse(m.group(3)!),
      int.parse(m.group(2)!),
      int.parse(m.group(1)!),
      int.parse(m.group(4)!),
      int.parse(m.group(5)!),
    );
  }

  /// "Mar 22, 2026 11:37:20 AM"
  DateTime? parseEnglishLongDate(String msg) {
    final pattern = RegExp(
      r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d{1,2}),\s+(\d{4})\s+(\d{1,2}):(\d{2}):(\d{2})\s+(AM|PM)',
      caseSensitive: false,
    );
    final m = pattern.firstMatch(msg);
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

  /// "يوم 08-04-26 الساعة 17:50"
  DateTime? parseArabicBankDate(String msg) {
    final pattern = RegExp(
      r'يوم\s+(\d{2})-(\d{2})-(\d{2}).*?الساعة\s+(\d{2}):(\d{2})',
    );
    final m = pattern.firstMatch(msg);
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
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4,
      'may': 5, 'jun': 6, 'jul': 7, 'aug': 8,
      'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    return map[abbr.toLowerCase()] ?? 1;
  }
}
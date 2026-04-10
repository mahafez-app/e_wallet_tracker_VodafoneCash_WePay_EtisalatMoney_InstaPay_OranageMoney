// registry/sms_parser_registry.dart

import '../parsers/etisalat_cash_sms_parser.dart';
import '../parsers/insta_pay_sms_parser.dart';
import '../parsers/orange_money_sms_parser.dart';
import '../parsers/vodafone_cash_sms_parser.dart';
import '../parsers/we_pay_sms_parser.dart';
import '../sms_parser.dart';

class SmsParserRegistry {
  SmsParserRegistry._();

  static final _parsers = <SmsParser>[
    VodafoneCashSmsParser(),
    OrangeMoneySmsParser(),
    EtisalatCashSmsParser(),
    WePaySmsParser(),
    InstaPaySmsParser(),
  ];

  /// Returns the correct parser for the given SMS sender, or null if unknown.
  static SmsParser? resolve(String sender) {
    final normalized = sender.toLowerCase().replaceAll(RegExp(r'[\s\-_]'), '');
    for (final parser in _parsers) {
      for (final id in parser.senderIds) {
        if (normalized.contains(
          id.toLowerCase().replaceAll(RegExp(r'[\s\-_]'), ''),
        )) {
          return parser;
        }
      }
    }
    return null;
  }

  /// Register a new parser at runtime (e.g. from remote config).
  static void register(SmsParser parser) => _parsers.add(parser);
}

// lib/core/utils/sms/sms_parser.dart

import 'dart:developer';

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

    log(
      'Parsing SMS from ${senderIds.first} with system date: $smsReceivedAt',
      name: 'SmsParser',
    );

    return SmsParseResult(
      amount: match.amount,
      type: match.type,
      createdAt: smsReceivedAt,
      provider: provider,
      counterpartyNumber: match.counterpartyNumber,
      referenceNumber: extractRef(message),
      balance: extractBalance(message) ?? match.balance,
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
}

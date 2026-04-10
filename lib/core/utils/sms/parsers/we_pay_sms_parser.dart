// parsers/we_pay_sms_parser.dart

import '../../../domain/enums/wallet_provider.dart';
import '../sms_parser.dart';
import '../sms_patterns.dart';

class WePaySmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.wePay;

  @override
  List<String> get senderIds => ['WE-Pay', 'WEPay', 'WE'];

  @override
  List<RegExp> get receivePatterns => [
    SmsPatterns.arReceiveFromNumber,
    SmsPatterns.enReceiveFromNumber,
    SmsPatterns.enTransferReceivedFromNumber,
  ];

  @override
  List<RegExp> get sendPatterns => [
    SmsPatterns.arSendToNumber,
    SmsPatterns.enSendToNumber,
    SmsPatterns.enTransferSentToNumber,
  ];

  @override
  List<RegExp> get refPatterns => [
    SmsPatterns.refOperationAr,
    SmsPatterns.refEn,
  ];
}

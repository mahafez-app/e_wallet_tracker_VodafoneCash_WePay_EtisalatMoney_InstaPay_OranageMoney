// parsers/vodafone_cash_sms_parser.dart

import '../../../domain/enums/wallet_provider.dart';
import '../sms_parser.dart';
import '../sms_patterns.dart';

class VodafoneCashSmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.vodafoneCash;

  @override
  List<String> get senderIds => ['VF-Cash', 'VFCash', 'Vodafone-Cash'];

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

// parsers/etisalat_cash_sms_parser.dart

import '../../../domain/enums/wallet_provider.dart';
import '../sms_parser.dart';
import '../sms_patterns.dart';

class EtisalatCashSmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.etisalatCash;

  @override
  List<String> get senderIds => ['Etisalat', 'E-Cash', 'ECash', 'Etisalat-Cash', 'EtisalatCash'];

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
  List<RegExp> get refPatterns => [SmsPatterns.refNumberAr, SmsPatterns.refEn];
}

// parsers/insta_pay_sms_parser.dart

import '../../../domain/enums/wallet_provider.dart';
import '../sms_parser.dart';
import '../sms_patterns.dart';

class InstaPaySmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.instaPay;

  @override
  List<String> get senderIds => [
    'InstaPay',
    'Insta-Pay',
    'BanK-AlAhly',
    'BankAlAhly',
    'NBE',
    'CIB',
    'Banque-Misr',
    'BanqueMisr',
    'QNB',
    'AAIB',
    'HSBC',
    'Fawry',
  ];

  @override
  List<RegExp> get receivePatterns => [
    SmsPatterns.arBankReceive,
    SmsPatterns.enTransferReceivedFromNumber,
  ];

  @override
  List<RegExp> get sendPatterns => [
    SmsPatterns.arBankSend,
    SmsPatterns.enTransferSentToNumber,
  ];

  @override
  List<RegExp> get refPatterns => [SmsPatterns.refBankAr, SmsPatterns.refEn];

  // InstaPay uses Arabic bank date format primarily
  @override
  DateTime? extractDateTime(String message) =>
      parseDateArabicBank(message) ??
      parseDateShort(message) ??
      parseDateLongEn(message);
}

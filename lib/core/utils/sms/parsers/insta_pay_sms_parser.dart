import '../../../domain/enums/wallet_provider.dart';
import '../sms_parser.dart';
import '../sms_patterns.dart';

final class InstaPaySmsParser extends SmsParser {
  const InstaPaySmsParser();

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
  List<RegExp> get refPatterns => [
    SmsPatterns.refBankAr,
    SmsPatterns.refBeforeDateAr,
    SmsPatterns.refEn,
  ];
}

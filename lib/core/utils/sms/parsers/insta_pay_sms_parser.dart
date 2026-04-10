// parsers/insta_pay_sms_parser.dart

import '../../../domain/enums/transaction_type.dart';
import '../../../domain/enums/wallet_provider.dart';
import '../sms_parse_result.dart';
import '../sms_parser.dart';

/// InstaPay transfers are bank-to-bank.
/// Counterparty is identified by name only — no phone number in the SMS.
/// Date format: "يوم DD-MM-YY الساعة HH:mm"
class InstaPaySmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.instaPay;

  @override
  List<String> get senderIds => [
        'InstaPay',
        'Insta-Pay',
        'BanK-AlAhly',
        'NBE',
        'CIB',
        'Banque-Misr',
        'BanqueMisr',
        'QNB',
        'AAIB',
        'HSBC',
        'Fawry',
      ];

  // Send: "تم تنفيذ تحويل لحظي من حسابكم رقم XXXX بمبلغ 600.00 جم إلى NAME"
  static final _arSend = RegExp(
    r'(?:تم تنفيذ تحويل|تم تحويل مبلغ).*?بمبلغ\s*([\d,\.]+)\s*(?:جم|جنيه|ج\.م)',
  );

  // Receive: "تم إضافة تحويل لحظي لحسابكم رقم XXXX بمبلغ 1000.00 جم من NAME"
  static final _arReceive = RegExp(
    r'(?:تم إضافة تحويل|تم إيداع مبلغ).*?بمبلغ\s*([\d,\.]+)\s*(?:جم|جنيه|ج\.م)',
  );

  // Ref: "رقم مرجعي 643111494336"
  static final _ref = RegExp(r'رقم مرجعي\s*([\d]+)');

  @override
  SmsParseResult? parse(String message, DateTime smsReceivedAt) {
    Match? match;
    TransactionType? type;

    if ((match = _arReceive.firstMatch(message)) != null) {
      type = TransactionType.receive;
    } else if ((match = _arSend.firstMatch(message)) != null) {
      type = TransactionType.send;
    }

    if (match == null || type == null) return null;

    final amount = parseAmount(match.group(1)!);
    if (amount == null) return null;

    return SmsParseResult(
      amount: amount,
      type: type,
      createdAt: parseArabicBankDate(message) ??
          parseDdMmYyHhMm(message) ??
          smsReceivedAt,
      provider: provider,
      counterpartyNumber: null, // InstaPay has no phone number in SMS
      referenceNumber: _ref.firstMatch(message)?.group(1),
    );
  }
}
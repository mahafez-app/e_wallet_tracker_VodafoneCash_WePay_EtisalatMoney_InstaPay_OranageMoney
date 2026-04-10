// parsers/orange_money_sms_parser.dart

import '../../../domain/enums/transaction_type.dart';
import '../../../domain/enums/wallet_provider.dart';
import '../sms_parse_result.dart';
import '../sms_parser.dart';

class OrangeMoneySmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.orangeMoney;

  @override
  List<String> get senderIds => ['Orange-Cash', 'OrangeCash', 'Orange-Money'];

  // Orange uses similar Arabic patterns to VF-Cash
  static final _arReceive = RegExp(
    r'(?:تم استلام|تم إيداع)\s*(?:مبلغ)?\s*([\d,\.]+)\s*(?:جنيه|ج\.م).*?(?:من رقم|من)\s*(\+?[\d]{8,13})',
  );
  static final _arSend = RegExp(
    r'(?:تم تحويل|تم إرسال)\s*([\d,\.]+)\s*(?:جنيه|ج\.م).*?(?:لرقم|إلى رقم)\s*(\+?[\d]{8,13})',
  );
  static final _ref = RegExp(r'(?:رقم العملية|كود العملية)\s*([\d]+)');

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
      createdAt: parseDdMmYyHhMm(message) ?? smsReceivedAt,
      provider: provider,
      counterpartyNumber: normalizeNumber(match.group(2)),
      referenceNumber: _ref.firstMatch(message)?.group(1),
    );
  }
}
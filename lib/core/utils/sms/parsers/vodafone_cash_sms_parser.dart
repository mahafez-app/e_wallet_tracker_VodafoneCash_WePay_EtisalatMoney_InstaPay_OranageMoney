// parsers/vodafone_cash_sms_parser.dart

import '../../../domain/enums/transaction_type.dart';
import '../../../domain/enums/wallet_provider.dart';
import '../sms_parse_result.dart';
import '../sms_parser.dart';

class VodafoneCashSmsParser extends SmsParser {
  @override
  WalletProvider get provider => WalletProvider.vodafoneCash;

  @override
  List<String> get senderIds => ['VF-Cash', 'VFCash', 'Vodafone-Cash'];

  // Arabic receive: "تم استلام مبلغ 545 جنيه من رقم 01015698339"
  static final _arReceive = RegExp(
    r'تم استلام مبلغ\s*([\d,\.]+)\s*جنيه.*?من رقم\s*(\+?[\d]{8,13})',
  );

  // Arabic send: "تم تحويل 500 جنيه لرقم 01120892874"
  static final _arSend = RegExp(
    r'تم تحويل\s*([\d,\.]+)\s*جنيه.*?لرقم\s*(\+?[\d]{8,13})',
  );

  // English receive: "Received EGP150 from 00201140932674 to Mobile Account"
  static final _enReceive = RegExp(
    r'Received\s+EGP\s*([\d,\.]+)\s+from\s+(\+?[\d]{8,13})',
  );

  // Ref: "رقم العملية 018959810019"
  static final _ref = RegExp(r'رقم العملية\s*([\d]+)');

  @override
  SmsParseResult? parse(String message, DateTime smsReceivedAt) {
    Match? match;
    TransactionType? type;

    if ((match = _arReceive.firstMatch(message)) != null) {
      type = TransactionType.receive;
    } else if ((match = _arSend.firstMatch(message)) != null) {
      type = TransactionType.send;
    } else if ((match = _enReceive.firstMatch(message)) != null) {
      type = TransactionType.receive;
    }

    if (match == null || type == null) return null;

    final amount = parseAmount(match.group(1)!);
    if (amount == null) return null;

    return SmsParseResult(
      amount: amount,
      type: type,
      createdAt: parseDdMmYyHhMm(message) ??
          parseEnglishLongDate(message) ??
          smsReceivedAt,
      provider: provider,
      counterpartyNumber: normalizeNumber(match.group(2)),
      referenceNumber: _ref.firstMatch(message)?.group(1),
    );
  }
}
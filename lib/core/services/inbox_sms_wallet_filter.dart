import '../utils/egyptian_phone_number.dart';
import '../utils/sms/sms_parse_result.dart';
import '../utils/sms/sms_parsing_service.dart';

final class InboxSmsWalletFilter {
  const InboxSmsWalletFilter._();

  static DateTime resolveMessageDate(int? timestampMs) {
    if (timestampMs == null) return DateTime.now();
    return DateTime.fromMillisecondsSinceEpoch(timestampMs);
  }

  static bool shouldUseMessageForWallet({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required String targetPhoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
  }) {
    final parseResult = SmsParsingService.parseRaw(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
    );
    if (parseResult == null) return false;

    return shouldUseParsedSmsForWallet(
      parseResult: parseResult,
      targetPhoneNumber: targetPhoneNumber,
      sameProviderWalletPhoneNumbers: sameProviderWalletPhoneNumbers,
    );
  }

  static bool shouldUseParsedSmsForWallet({
    required SmsParseResult parseResult,
    required String targetPhoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
  }) {
    final normalizedTargetPhoneNumber = EgyptianPhoneNumber.tryNormalizeMobile(
      targetPhoneNumber,
    );
    if (normalizedTargetPhoneNumber == null) return false;

    final providerWalletPhoneNumbers =
        sameProviderWalletPhoneNumbers
            .map(EgyptianPhoneNumber.tryNormalizeMobile)
            .whereType<String>()
            .toSet()
          ..add(normalizedTargetPhoneNumber);

    if (providerWalletPhoneNumbers.length <= 1) {
      return true;
    }

    final mentionedWalletPhoneNumbers = parseResult.mentionedPhoneNumbers
        .where(providerWalletPhoneNumbers.contains)
        .toSet();

    return mentionedWalletPhoneNumbers.length == 1 &&
        mentionedWalletPhoneNumbers.first == normalizedTargetPhoneNumber;
  }
}

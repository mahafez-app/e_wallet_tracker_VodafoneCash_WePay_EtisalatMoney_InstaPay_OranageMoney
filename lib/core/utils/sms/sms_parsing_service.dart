// sms_parsing_service.dart

import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import 'registry/sms_parser_registry.dart';
import 'sms_parse_result.dart';

class SmsParsingService {
  SmsParsingService._();

  static const _uuid = Uuid();

  /// Full single-pass parse for when the wallet is already known.
  ///
  /// Returns null if the sender is unrecognized or the body matches no pattern.
  static TransactionEntity? parse({
    required String sender,
    required String message,
    required DateTime smsReceivedAt,
    required String walletId,
    required String walletOwnerUid,
    required String walletPhoneNumber,
  }) {
    final result = parseRaw(sender: sender, message: message, smsReceivedAt: smsReceivedAt);
    if (result == null) return null;

    return buildEntity(
      result: result,
      walletId: walletId,
      walletOwnerUid: walletOwnerUid,
      walletPhoneNumber: walletPhoneNumber,
      rawMessage: message,
    );
  }

  /// Phase-1 of the two-phase pipeline: parse the SMS body without committing
  /// to a wallet. Returns the extracted transaction signals (amount, type,
  /// balance) that the [SmsWalletMatcher] uses for disambiguation.
  ///
  /// Returns null if the sender is unrecognized or the body matches no pattern.
  static SmsParseResult? parseRaw({
    required String sender,
    required String message,
    required DateTime smsReceivedAt,
  }) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return null;
    return parser.parse(message, smsReceivedAt);
  }

  /// Phase-2 of the two-phase pipeline: converts a [SmsParseResult] into a
  /// fully hydrated [TransactionEntity] once the wallet has been chosen.
  static TransactionEntity buildEntity({
    required SmsParseResult result,
    required String walletId,
    required String walletOwnerUid,
    required String walletPhoneNumber,
    required String rawMessage,
  }) {
    // Generate deterministic ID so retries don't create duplicates
    final deterministicId = _uuid.v5(
      Namespace.url.value,
      '${result.provider}_${rawMessage.trim()}_${result.createdAt.millisecondsSinceEpoch}_$walletId',
    );

    return TransactionEntity(
      id: deterministicId,
      type: result.type,
      amount: result.amount,
      createdAt: result.createdAt,
      walletId: walletId,
      walletOwnerUid: walletOwnerUid,
      provider: result.provider,
      phoneNumber: walletPhoneNumber,
      counterpartyNumber: result.counterpartyNumber,
      referenceNumber: result.referenceNumber,
      isPaid: null,
      message: rawMessage,
      statusBalance: result.balance,
    );
  }
}

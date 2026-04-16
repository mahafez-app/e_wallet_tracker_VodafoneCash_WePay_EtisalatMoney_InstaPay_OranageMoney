// sms_parsing_service.dart

import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import 'registry/sms_parser_registry.dart';
import 'sms_parse_result.dart';

class SmsParsingService {
  SmsParsingService._();

  static const _uuid = Uuid();

  /// Returns null if the SMS sender is unrecognized or the body
  /// doesn't match any transaction pattern for that provider.
  static TransactionEntity? parse({
    required String sender,
    required String message,
    required DateTime smsReceivedAt,
    required String walletId,
    required String walletOwnerUid,
    required String walletPhoneNumber,
  }) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return null;

    final result = parser.parse(message, smsReceivedAt);
    if (result == null) return null;

    return _toEntity(
      result: result,
      walletId: walletId,
      walletOwnerUid: walletOwnerUid,
      walletPhoneNumber: walletPhoneNumber,
      rawMessage: message,
    );
  }

  static TransactionEntity _toEntity({
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
    );
  }
}


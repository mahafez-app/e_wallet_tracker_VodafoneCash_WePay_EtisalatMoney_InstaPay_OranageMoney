import 'dart:developer';

import 'package:another_telephony/telephony.dart';

import '../data/models/transaction_dto.dart';
import '../domain/enums/wallet_provider.dart';
import 'inbox_sms_wallet_filter.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_parsing_service.dart';

abstract interface class InboxSmsService {
  Future<double?> getLatestBalance({
    required WalletProvider provider,
    required String targetPhoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
  });

  Future<List<TransactionDto>> getHistoricalTransactions({
    required WalletProvider provider,
    required String walletId,
    required String walletOwnerUid,
    required String phoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
  });
}

class InboxSmsServiceImpl implements InboxSmsService {
  const InboxSmsServiceImpl();

  @override
  Future<double?> getLatestBalance({
    required WalletProvider provider,
    required String targetPhoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
  }) async {
    final parser = SmsParserRegistry.resolveByProvider(provider);
    if (parser == null) {
      log(
        'No parser found for provider ${provider.toValue}',
        name: 'InboxSmsService',
      );
      return null;
    }

    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final thirtyDaysAgoMs = thirtyDaysAgo.millisecondsSinceEpoch;

      final messages = await Telephony.instance.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(
          SmsColumn.DATE,
        ).greaterThan(thirtyDaysAgoMs.toString()),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      log(
        'Queried ${messages.length} messages from inbox for provider ${provider.toValue}',
        name: 'InboxSmsService',
      );

      final filteredMessages = messages.where((message) {
        final address = message.address;
        if (address == null) return false;
        return parser.senderIds.any(
          (id) => id.toLowerCase() == address.toLowerCase(),
        );
      });

      for (final message in filteredMessages) {
        final body = message.body;
        final sender = message.address;
        if (body == null || sender == null) continue;

        if (!InboxSmsWalletFilter.shouldUseMessageForWallet(
          sender: sender,
          body: body,
          smsReceivedAt: InboxSmsWalletFilter.resolveMessageDate(message.date),
          targetPhoneNumber: targetPhoneNumber,
          sameProviderWalletPhoneNumbers: sameProviderWalletPhoneNumbers,
        )) {
          continue;
        }

        final balance = parser.extractBalance(body);
        if (balance != null) {
          log(
            'Found balance $balance for ${provider.toValue} in SMS history',
            name: 'InboxSmsService',
          );
          return balance;
        }
      }
    } catch (e, st) {
      log(
        'Failed to query inbox for provider ${provider.toValue}',
        name: 'InboxSmsService',
        error: e,
        stackTrace: st,
      );
    }

    return null;
  }

  @override
  Future<List<TransactionDto>> getHistoricalTransactions({
    required WalletProvider provider,
    required String walletId,
    required String walletOwnerUid,
    required String phoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
  }) async {
    final parser = SmsParserRegistry.resolveByProvider(provider);
    if (parser == null) return const [];

    try {
      final lastWeek = DateTime.now().subtract(const Duration(days: 7));
      final lastWeekMs = lastWeek.millisecondsSinceEpoch;
      final filter = SmsFilter.where(
        SmsColumn.ADDRESS,
      ).equals(parser.senderIds.first);
      for (final id in parser.senderIds) {
        filter.or(SmsColumn.ADDRESS).equals(id);
      }
      final messages = await Telephony.instance.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: filter.and(SmsColumn.DATE).greaterThan(lastWeekMs.toString()),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      final transactions = <TransactionDto>[];

      for (final message in messages) {
        final address = message.address;
        if (address == null) continue;

        final isMatch = parser.senderIds.any(
          (id) => id.toLowerCase() == address.toLowerCase(),
        );
        if (!isMatch) continue;

        final body = message.body;
        if (body == null) continue;

        final date = InboxSmsWalletFilter.resolveMessageDate(message.date);
        final parseResult = SmsParsingService.parseRaw(
          sender: address,
          message: body,
          smsReceivedAt: date,
        );
        if (parseResult == null) continue;

        if (!InboxSmsWalletFilter.shouldUseParsedSmsForWallet(
          parseResult: parseResult,
          targetPhoneNumber: phoneNumber,
          sameProviderWalletPhoneNumbers: sameProviderWalletPhoneNumbers,
        )) {
          continue;
        }

        transactions.add(
          TransactionDto(
            id: '', // To be generated by Firestore
            type: parseResult.type,
            amount: parseResult.amount,
            createdAt: date,
            walletId: walletId,
            walletOwnerUid: walletOwnerUid,
            provider: provider,
            phoneNumber: phoneNumber,
            counterpartyNumber: parseResult.counterpartyNumber,
            referenceNumber: parseResult.referenceNumber,
            statusBalance: parseResult.balance,
            message: body,
          ),
        );
      }

      return transactions;
    } catch (e, st) {
      log(
        'Failed to query historical transactions for provider ${provider.toValue}',
        name: 'InboxSmsService',
        error: e,
        stackTrace: st,
      );
      return const [];
    }
  }
}

import 'dart:developer';

import 'package:another_telephony/telephony.dart';

import '../domain/enums/wallet_provider.dart';
import '../utils/sms/registry/sms_parser_registry.dart';

abstract interface class InboxSmsService {
  Future<double?> getLatestBalance(WalletProvider provider);
}

class InboxSmsServiceImpl implements InboxSmsService {
  const InboxSmsServiceImpl();

  @override
  Future<double?> getLatestBalance(WalletProvider provider) async {
    final parser = SmsParserRegistry.resolveByProvider(provider);
    if (parser == null) {
      log(
        'No parser found for provider ${provider.toValue}',
        name: 'InboxSmsService',
      );
      return null;
    }

    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;

      final messages = await Telephony.instance.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.DATE).greaterThan(thirtyDaysAgo.toString()),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      print('Queried ${messages.length} messages from inbox for provider ${provider.toValue}');

      final filteredMessages = messages.where((message) {
        final address = message.address;
        if (address == null) return false;
        return parser.senderIds.any(
          (id) => id.toLowerCase() == address.toLowerCase(),
        );
      });

      for (final message in filteredMessages) {
        final body = message.body;
        if (body == null) continue;

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
}

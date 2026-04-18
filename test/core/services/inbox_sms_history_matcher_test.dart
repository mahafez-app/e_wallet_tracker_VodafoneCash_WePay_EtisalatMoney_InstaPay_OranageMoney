import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/core/domain/enums/transaction_type.dart';
import 'package:wallet_tracker/core/domain/enums/wallet_provider.dart';
import 'package:wallet_tracker/core/services/inbox_sms_history_matcher.dart';
import 'package:wallet_tracker/core/utils/sms/sms_parse_result.dart';

void main() {
  group('InboxSmsHistoryMatcher', () {
    test(
      'keeps explicit target messages and infers adjacent ambiguous matches',
      () {
        final records = <ParsedInboxSmsRecord>[
          _record(
            createdAt: DateTime(2026, 4, 10, 10),
            amount: 100,
            type: TransactionType.receive,
            balance: 600,
          ),
          _record(
            createdAt: DateTime(2026, 4, 10, 11),
            amount: 50,
            type: TransactionType.receive,
            balance: 650,
            mentionedPhoneNumbers: const <String>['01011111111'],
          ),
          _record(
            createdAt: DateTime(2026, 4, 10, 12),
            amount: 100,
            type: TransactionType.send,
            balance: 550,
          ),
          _record(
            createdAt: DateTime(2026, 4, 10, 13),
            amount: 70,
            type: TransactionType.receive,
            balance: 970,
            mentionedPhoneNumbers: const <String>['01022222222'],
          ),
        ];

        final matchedHistory = InboxSmsHistoryMatcher.resolveWalletHistory(
          records: records,
          targetPhoneNumber: '01011111111',
          sameProviderPhoneNumbers: const <String>[
            '01011111111',
            '01022222222',
          ],
        );

        expect(matchedHistory, hasLength(3));
        expect(
          InboxSmsHistoryMatcher.resolveLatestBalance(
            records: records,
            targetPhoneNumber: '01011111111',
            sameProviderPhoneNumbers: const <String>[
              '01011111111',
              '01022222222',
            ],
          ),
          550,
        );
      },
    );
  });
}

ParsedInboxSmsRecord _record({
  required DateTime createdAt,
  required double amount,
  required TransactionType type,
  double? balance,
  List<String> mentionedPhoneNumbers = const <String>[],
}) {
  return (
    createdAt: createdAt,
    body: 'sms_${createdAt.millisecondsSinceEpoch}',
    parseResult: SmsParseResult(
      amount: amount,
      type: type,
      createdAt: createdAt,
      provider: WalletProvider.vodafoneCash,
      balance: balance,
      mentionedPhoneNumbers: mentionedPhoneNumbers,
    ),
  );
}

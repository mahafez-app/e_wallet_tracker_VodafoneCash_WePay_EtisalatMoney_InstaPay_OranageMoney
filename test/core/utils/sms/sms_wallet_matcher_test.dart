import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/core/domain/entities/wallet_entity.dart';
import 'package:wallet_tracker/core/domain/enums/transaction_type.dart';
import 'package:wallet_tracker/core/domain/enums/wallet_provider.dart';
import 'package:wallet_tracker/core/utils/sms/sms_parsing_service.dart';
import 'package:wallet_tracker/core/utils/sms/sms_wallet_matcher.dart';

void main() {
  group('SmsParsingService.parseRaw', () {
    test('captures normalized phone numbers mentioned in the sms body', () {
      final result = SmsParsingService.parseRaw(
        sender: 'Orange-Cash',
        message:
            'Received EGP100 from 01012345678 on your wallet 01234567890. '
            'Available Balance: 500',
        smsReceivedAt: DateTime(2026, 4, 18),
      );

      expect(result, isNotNull);
      expect(
        result!.mentionedPhoneNumbers,
        containsAll(<String>['01012345678', '01234567890']),
      );
    });
  });

  group('SmsWalletMatcher.resolve', () {
    test('prefers the wallet explicitly mentioned in the sms', () {
      final wallets = <WalletEntity>[
        _buildWallet(
          id: 'wallet_a',
          phoneNumber: '01211111111',
          currentBalance: 900,
          lastBalanceAt: DateTime(2026, 4, 18, 8),
        ),
        _buildWallet(
          id: 'wallet_b',
          phoneNumber: '01222222222',
          currentBalance: 1200,
          lastBalanceAt: DateTime(2026, 4, 18, 9),
        ),
      ];

      final resolvedWallet = SmsWalletMatcher.resolve(
        wallets: wallets,
        input: const SmsWalletMatchInput(
          amount: 100,
          transactionType: TransactionType.receive,
          parsedBalance: 1000,
          counterpartyNumber: '01012345678',
          mentionedPhoneNumbers: <String>['01012345678', '01222222222'],
        ),
      );

      expect(resolvedWallet.id, 'wallet_b');
    });

    test(
      'falls back to the closest balance match when no wallet phone exists',
      () {
        final wallets = <WalletEntity>[
          _buildWallet(
            id: 'wallet_a',
            phoneNumber: '01211111111',
            currentBalance: 1000,
            lastBalanceAt: DateTime(2026, 4, 18, 8),
          ),
          _buildWallet(
            id: 'wallet_b',
            phoneNumber: '01222222222',
            currentBalance: 600,
            lastBalanceAt: DateTime(2026, 4, 18, 9),
          ),
        ];

        final resolvedWallet = SmsWalletMatcher.resolve(
          wallets: wallets,
          input: const SmsWalletMatchInput(
            amount: 150,
            transactionType: TransactionType.receive,
            parsedBalance: 1150,
            mentionedPhoneNumbers: <String>['01012345678'],
          ),
        );

        expect(resolvedWallet.id, 'wallet_a');
      },
    );
  });
}

WalletEntity _buildWallet({
  required String id,
  required String phoneNumber,
  required double currentBalance,
  required DateTime lastBalanceAt,
}) {
  return WalletEntity(
    id: id,
    phoneNumber: phoneNumber,
    provider: WalletProvider.orangeMoney,
    deviceId: 'device_1',
    ownerUid: 'owner_1',
    currentBalance: currentBalance,
    totalReceived: 0,
    totalSent: 0,
    lastBalanceAt: lastBalanceAt,
    createdAt: DateTime(2026, 4, 1),
  );
}

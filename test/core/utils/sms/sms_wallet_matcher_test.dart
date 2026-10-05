import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:sms_engine/sms_engine.dart';

void main() {
  final now = DateTime(2026, 4, 20, 12);
  final wallets = [
    WalletEntity(
      id: 'wallet-a',
      phoneNumber: '01011111111',
      provider: WalletProvider.vodafoneCash,
      deviceId: 'device-1',
      ownerUid: 'owner-1',
      currentBalance: 14212.66,
      totalReceived: 0,
      totalSent: 0,
      lastBalanceAt: now,
      createdAt: now,
    ),
    WalletEntity(
      id: 'wallet-b',
      phoneNumber: '01022222222',
      provider: WalletProvider.vodafoneCash,
      deviceId: 'device-1',
      ownerUid: 'owner-1',
      currentBalance: 4000,
      totalReceived: 0,
      totalSent: 0,
      lastBalanceAt: now,
      createdAt: now,
    ),
  ];

  test('matches wallet by balance delta when unique', () {
    final result = SmsWalletMatcher.resolve(
      wallets: wallets,
      input: const SmsWalletMatchInput(
        amount: 6750,
        transactionType: TransactionType.send,
        parsedBalance: 7462.66,
        counterpartyNumber: '01020565524',
        mentionedPhoneNumbers: ['01020565524'],
      ),
    );

    expect(result, isA<SmsWalletMatchedResult>());
    expect((result as SmsWalletMatchedResult).wallet.id, 'wallet-a');
  });

  test('returns no candidate instead of unsafe fallback', () {
    final result = SmsWalletMatcher.resolve(
      wallets: wallets,
      input: const SmsWalletMatchInput(
        amount: 100,
        transactionType: TransactionType.send,
        parsedBalance: 50,
      ),
    );

    expect(result, isA<SmsWalletNoCandidate>());
  });
}

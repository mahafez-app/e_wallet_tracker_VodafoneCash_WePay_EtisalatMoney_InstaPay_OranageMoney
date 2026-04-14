import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/core/data/models/transaction_dto.dart';
import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';
import 'package:wallet_tracker/core/domain/enums/transaction_type.dart';
import 'package:wallet_tracker/core/domain/enums/wallet_provider.dart';

void main() {
  group('TransactionDto.toFirestore', () {
    test('stores counterparty suffixes and unpaid receive as false', () {
      final transaction = TransactionEntity(
        id: 'tx_1',
        type: TransactionType.receive,
        amount: 150,
        createdAt: DateTime(2026, 4, 14, 10),
        walletId: 'wallet_1',
        walletOwnerUid: 'owner_1',
        provider: WalletProvider.vodafoneCash,
        phoneNumber: '01012345678',
        counterpartyNumber: '01076543210',
        isPaid: null,
        message: 'message',
      );

      final firestoreMap = TransactionDto.fromEntity(transaction).toFirestore();

      expect(
        firestoreMap['counterpartySuffixes'],
        containsAll(<String>['210', '3210', '43210']),
      );
      expect(firestoreMap['isPaid'], isFalse);
      expect(firestoreMap['walletOwnerUid'], 'owner_1');
    });
  });
}

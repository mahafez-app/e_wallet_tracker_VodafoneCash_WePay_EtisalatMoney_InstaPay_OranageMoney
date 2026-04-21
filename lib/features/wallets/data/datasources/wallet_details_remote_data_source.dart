import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet_tracker/core/domain/entities/wallet_entity.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/data/models/wallet_dto.dart';

abstract interface class WalletDetailsRemoteDataSource {
  Future<WalletDto> getWallet(String walletId);
  Future<List<TransactionDto>> getRecentTransactions(WalletEntity wallet);
  Future<List<TransactionDto>> getTransactionsSince({
    required WalletEntity wallet,
    required DateTime fromDate,
  });
}

final class WalletDetailsRemoteDataSourceImpl
    implements WalletDetailsRemoteDataSource {
  const WalletDetailsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<WalletDto> getWallet(String walletId) async {
    final doc = await _firestore.collection('wallets').doc(walletId).get();

    return WalletDto.fromFirestore(doc);
  }

  @override
  Future<List<TransactionDto>> getRecentTransactions(
    WalletEntity wallet,
  ) async {
    final snapshot = await _firestore
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .get();

    return snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            wallet.provider,
            wallet.phoneNumber,
            wallet.id,
            wallet.ownerUid,
          ),
        )
        .toList();
  }

  @override
  Future<List<TransactionDto>> getTransactionsSince({
    required WalletEntity wallet,
    required DateTime fromDate,
  }) async {
    final snapshot = await _firestore
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate),
        )
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            wallet.provider,
            wallet.phoneNumber,
            wallet.id,
            wallet.ownerUid,
          ),
        )
        .toList(growable: false);
  }
}

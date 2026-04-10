import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/domain/enums/wallet_provider.dart';

abstract interface class TransactionRemoteDataSource {
  Future<List<TransactionDto>> getTransactions({
    String? walletId,
    int? limit,
    DateTime? before,
  });

  Future<void> markAsPaid(String transactionId, String walletId);

  Future<void> saveTransaction(TransactionEntity transaction);
}

final class TransactionRemoteDataSourceImpl
    implements TransactionRemoteDataSource {
  const TransactionRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<TransactionDto>> getTransactions({
    String? walletId,
    int? limit,
    DateTime? before,
  }) async {
    if (walletId == null) {
      final query = _firestore
          .collectionGroup('transactions')
          .orderBy('createdAt', descending: true);

      var filteredQuery = query;
      if (limit != null) filteredQuery = filteredQuery.limit(limit);
      if (before != null) {
        filteredQuery = filteredQuery
            .startAfter([Timestamp.fromDate(before)]);
      }

      final snapshot = await filteredQuery.get();
      final List<TransactionDto> results = [];

      for (final doc in snapshot.docs) {
        final walletDoc = await doc.reference.parent.parent!.get();
        final walletData = walletDoc.data() as Map<String, dynamic>;
        final provider = WalletProvider.fromString(
          walletData['provider'] as String? ?? '',
        );
        final phoneNumber = walletData['phoneNumber'] as String? ?? '';

        results.add(TransactionDto.fromFirestore(
          doc,
          provider,
          phoneNumber,
          walletDoc.id,
        ));
      }
      return results;
    }

    final walletDoc =
        await _firestore.collection('wallets').doc(walletId).get();
    final walletData = walletDoc.data() as Map<String, dynamic>;
    final provider = WalletProvider.fromString(
      walletData['provider'] as String? ?? '',
    );
    final phoneNumber = walletData['phoneNumber'] as String? ?? '';

    var query = _firestore
        .collection('wallets')
        .doc(walletId)
        .collection('transactions')
        .orderBy('createdAt', descending: true);

    if (limit != null) query = query.limit(limit);
    if (before != null) {
      query = query.startAfter([Timestamp.fromDate(before)]);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => TransactionDto.fromFirestore(
              doc,
              provider,
              phoneNumber,
              walletId,
            ))
        .toList();
  }

  @override
  Future<void> markAsPaid(String transactionId, String walletId) async {
    await _firestore
        .collection('wallets')
        .doc(walletId)
        .collection('transactions')
        .doc(transactionId)
        .update({'isPaid': true});
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final walletRef =
        _firestore.collection('wallets').doc(transaction.walletId);
    final txRef = walletRef
        .collection('transactions')
        .doc(transaction.id);

    final dto = TransactionDto.fromEntity(transaction);
    final isReceive = transaction.type == TransactionType.receive;
    final amount = transaction.amount;

    final batch = _firestore.batch();

    batch.set(txRef, dto.toFirestore());

    // Atomically update wallet aggregate stats.
    // currentBalance increases on receive, decreases on send.
    batch.update(walletRef, {
      'currentBalance': FieldValue.increment(isReceive ? amount : -amount),
      'totalReceived':
          FieldValue.increment(isReceive ? amount : 0),
      'totalSent':
          FieldValue.increment(isReceive ? 0 : amount),
      'lastBalanceAt': Timestamp.fromDate(transaction.createdAt),
    });

    await batch.commit();
  }
}

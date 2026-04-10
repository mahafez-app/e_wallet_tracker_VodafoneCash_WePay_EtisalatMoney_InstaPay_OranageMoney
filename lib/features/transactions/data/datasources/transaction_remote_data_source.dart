import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/domain/enums/wallet_provider.dart';

abstract interface class TransactionRemoteDataSource {
  Future<List<TransactionDto>> getTransactions({
    String? walletId,
    int? limit,
    DateTime? before,
  });

  Future<void> markAsPaid(String transactionId, String walletId);
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
    // If walletId is provided, we fetch from a specific subcollection.
    // In a real app with global history, you might use a collection group query 
    // or a flattened transactions collection. 
    // For now, if walletId is null, we might need a different approach.
    // Let's assume for MVP we always filter by wallet for the history screen.
    
    if (walletId == null) {
      // In this app, transactions are stored under wallets/{id}/transactions
      // To get ALL transactions, we'd need a collection group query.
      final query = _firestore
          .collectionGroup('transactions')
          .orderBy('createdAt', descending: true);
          
      var filteredQuery = query;
      if (limit != null) filteredQuery = filteredQuery.limit(limit);
      if (before != null) filteredQuery = filteredQuery.startAfter([Timestamp.fromDate(before)]);

      final snapshot = await filteredQuery.get();
      
      // We need to fetch the parent wallet to get provider/phoneNumber for each transaction
      // This is inefficient. Ideally, DTOs in Firestore should be self-contained.
      // For now, let's fetch them and see.
      
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

    final walletDoc = await _firestore.collection('wallets').doc(walletId).get();
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
    if (before != null) query = query.startAfter([Timestamp.fromDate(before)]);

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
}

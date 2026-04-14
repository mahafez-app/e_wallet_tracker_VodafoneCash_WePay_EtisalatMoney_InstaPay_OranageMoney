import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet_tracker/core/di/app_initializer.dart';
import 'package:wallet_tracker/core/domain/enums/transaction_type.dart';
import 'package:wallet_tracker/features/transactions/data/mappers/transaction_search_terms.dart';

Future<void> main() async {
  await initializeApp();
  final firestore = FirebaseFirestore.instance;
  final walletsSnapshot = await firestore.collection('wallets').get();

  var updatedTransactionsCount = 0;
  for (final walletDoc in walletsSnapshot.docs) {
    updatedTransactionsCount += await _backfillWalletTransactions(
      firestore: firestore,
      walletId: walletDoc.id,
    );
  }

  log(
    'Backfill complete. Updated $updatedTransactionsCount transactions.',
    name: 'TransactionBackfill',
  );
}

Future<int> _backfillWalletTransactions({
  required FirebaseFirestore firestore,
  required String walletId,
}) async {
  final collection = firestore
      .collection('wallets')
      .doc(walletId)
      .collection('transactions');
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument;
  var updatedCount = 0;

  while (true) {
    var query = collection.orderBy(FieldPath.documentId).limit(200);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      return updatedCount;
    }

    final batch = firestore.batch();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final transactionType = TransactionType.fromString(data['type']);
      final expectedSuffixes = TransactionSearchTerms.counterpartySuffixes(
        data['counterpartyNumber'] as String?,
      );
      final existingSuffixes = (data['counterpartySuffixes'] as List<Object?>?)
              ?.whereType<String>()
              .toList() ??
          const <String>[];
      final expectedIsPaid = transactionType == TransactionType.receive
          ? (data['isPaid'] as bool? ?? false)
          : data['isPaid'] as bool?;

      final shouldUpdate =
          !_listEquals(existingSuffixes, expectedSuffixes) ||
          data['isPaid'] != expectedIsPaid;
      if (!shouldUpdate) {
        continue;
      }

      batch.update(doc.reference, {
        'counterpartySuffixes': expectedSuffixes,
        'isPaid': expectedIsPaid,
      });
      updatedCount++;
    }

    await batch.commit();
    lastDocument = snapshot.docs.last;
  }
}

bool _listEquals(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

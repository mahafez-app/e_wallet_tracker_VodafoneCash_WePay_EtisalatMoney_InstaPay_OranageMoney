import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../models/note_dto.dart';
import '../models/transaction_history_entry_dto.dart';
import '../models/transaction_page_dto.dart';
import 'transaction_firestore_support.dart';

abstract interface class WalletTransactionRemoteDataSource {
  Future<TransactionPageDto> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  });

  Future<void> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<void> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<void> saveTransaction(TransactionEntity transaction);

  Future<void> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  });

  Future<void> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  });

  Future<void> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  });

  Stream<List<NoteDto>> getNotes({
    required String walletId,
    required String transactionId,
  });

  Stream<List<TransactionHistoryEntryDto>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  });
}

final class WalletTransactionRemoteDataSourceImpl
    implements WalletTransactionRemoteDataSource {
  const WalletTransactionRemoteDataSourceImpl({
    required TransactionFirestoreSupport support,
  }) : _support = support;

  final TransactionFirestoreSupport _support;

  @override
  Future<TransactionPageDto> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  }) async {
    final meta = await _support.walletMeta(walletId);
    final countQuery = _support.applyFilters(
      _support.txCollection(walletId),
      type: type,
      dateRange: dateRange,
    );
    final countSnapshot = await countQuery.count().get();
    final total = countSnapshot.count ?? 0;

    var dataQuery = _support
        .applyFilters(
          _support.walletTransactionsQuery(walletId),
          type: type,
          dateRange: dateRange,
        )
        .limit(limit);

    if (cursor != null) {
      dataQuery = dataQuery.startAfter([
        Timestamp.fromDate(cursor.createdAt),
        cursor.transactionId,
      ]);
    }

    final snapshot = await dataQuery.get();
    final docs = snapshot.docs;
    final transactions = docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            meta.provider,
            meta.phoneNumber,
            walletId,
          ),
        )
        .toList();

    return TransactionPageDto(
      transactions: transactions,
      totalCount: total,
      nextCursor: docs.length == limit
          ? _support.toWalletCursor(docs.last)
          : null,
    );
  }

  @override
  Future<void> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) => _updatePaidStatus(
    walletId: walletId,
    transactionId: transactionId,
    userId: userId,
    userName: userName,
    isPaid: true,
  );

  @override
  Future<void> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) => _updatePaidStatus(
    walletId: walletId,
    transactionId: transactionId,
    userId: userId,
    userName: userName,
    isPaid: false,
  );

  Future<void> _updatePaidStatus({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
    required bool isPaid,
  }) async {
    final txRef = _support.txCollection(walletId).doc(transactionId);
    final historyRef = txRef.collection('history').doc();
    final batch = txRef.firestore.batch();

    batch.update(txRef, {'isPaid': isPaid});
    batch.set(historyRef, {
      'isPaid': isPaid,
      'actorUid': userId,
      'actorName': userName,
      'occurredAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final walletRef = _support.walletDocument(transaction.walletId);
    final txRef = _support
        .txCollection(transaction.walletId)
        .doc(transaction.id);
    final dto = TransactionDto.fromEntity(transaction);
    final isReceive = transaction.type == TransactionType.receive;
    final amount = transaction.amount;

    final batch = txRef.firestore.batch();
    batch.set(txRef, dto.toFirestore());
    batch.update(walletRef, {
      'currentBalance': FieldValue.increment(isReceive ? amount : -amount),
      'totalReceived': FieldValue.increment(isReceive ? amount : 0),
      'totalSent': FieldValue.increment(isReceive ? 0 : amount),
      'lastBalanceAt': Timestamp.fromDate(transaction.createdAt),
    });
    await batch.commit();
  }

  @override
  Future<void> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  }) async {
    final noteRef = _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .doc();
    await noteRef.set({
      'text': text,
      'authorUid': userId,
      'authorName': userName,
      'createdAt': FieldValue.serverTimestamp(),
      'editedAt': null,
    });
  }

  @override
  Future<void> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  }) async {
    await _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .doc(noteId)
        .update({'text': text, 'editedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<void> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  }) async {
    await _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  @override
  Stream<List<NoteDto>> getNotes({
    required String walletId,
    required String transactionId,
  }) {
    return _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(NoteDto.fromFirestore).toList());
  }

  @override
  Stream<List<TransactionHistoryEntryDto>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  }) {
    return _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('history')
        .orderBy('occurredAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(TransactionHistoryEntryDto.fromFirestore)
              .toList(),
        );
  }
}

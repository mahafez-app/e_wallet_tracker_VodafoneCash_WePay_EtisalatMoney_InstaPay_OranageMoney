import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../models/history_entry_dto.dart';
import '../models/note_dto.dart';

abstract interface class TransactionRemoteDataSource {
  Future<
    ({List<TransactionDto> transactions, DocumentSnapshot? lastDoc, int total})
  >
  getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  });

  Future<List<TransactionDto>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
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

  Stream<List<HistoryEntryDto>> getHistory({
    required String walletId,
    required String transactionId,
  });
}

final class TransactionRemoteDataSourceImpl
    implements TransactionRemoteDataSource {
  const TransactionRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  // ── Internal helpers ───────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _txCollection(String walletId) =>
      _firestore.collection('wallets').doc(walletId).collection('transactions');

  Future<({WalletProvider provider, String phoneNumber})> _walletMeta(
    String walletId,
  ) async {
    final doc = await _firestore.collection('wallets').doc(walletId).get();
    final wallet = WalletDto.fromFirestore(doc);
    return (provider: wallet.provider, phoneNumber: wallet.phoneNumber);
  }

  Query<Map<String, dynamic>> _applyFilters(
    Query<Map<String, dynamic>> query, {
    TransactionType? type,
    TransactionDateRange? dateRange,
  }) {
    var q = query;
    if (type != null) q = q.where('type', isEqualTo: type.name);
    if (dateRange != null) {
      q = q
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start),
          )
          .where(
            'createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end),
          );
    }
    return q;
  }

  // ── Queries ────────────────────────────────────────────────────────────────

  @override
  Future<
    ({List<TransactionDto> transactions, DocumentSnapshot? lastDoc, int total})
  >
  getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    final meta = await _walletMeta(walletId);

    // Count query for totalCount (Firestore AggregateQuery).
    final countQuery = _applyFilters(
      _txCollection(walletId),
      type: type,
      dateRange: dateRange,
    );
    final countSnapshot = await countQuery.count().get();
    final total = countSnapshot.count ?? 0;

    // Data query with pagination cursor.
    var dataQuery = _applyFilters(
      _txCollection(walletId).orderBy('createdAt', descending: true),
      type: type,
      dateRange: dateRange,
    ).limit(limit);

    if (lastDocument != null) {
      dataQuery = dataQuery.startAfterDocument(lastDocument);
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

    return (
      transactions: transactions,
      lastDoc: docs.length == limit ? docs.last : null,
      total: total,
    );
  }

  @override
  Future<List<TransactionDto>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
  }) async {
    // Fetch each wallet's slice in parallel then merge-sort.
    final futures = walletIds.map(
      (id) => _fetchWalletSlice(
        walletId: id,
        type: type,
        dateRange: dateRange,
        limit: limit,
      ),
    );
    final slices = await Future.wait(futures);
    final merged = slices.expand((s) => s).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return merged.take(limit).toList();
  }

  Future<List<TransactionDto>> _fetchWalletSlice({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
  }) async {
    final meta = await _walletMeta(walletId);
    final query = _applyFilters(
      _txCollection(walletId).orderBy('createdAt', descending: true),
      type: type,
      dateRange: dateRange,
    ).limit(limit);
    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            meta.provider,
            meta.phoneNumber,
            walletId,
          ),
        )
        .toList();
  }

  // ── Mutations ──────────────────────────────────────────────────────────────

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
    final txRef = _txCollection(walletId).doc(transactionId);
    final historyRef = txRef.collection('history').doc();
    final batch = _firestore.batch();

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
    final walletRef = _firestore
        .collection('wallets')
        .doc(transaction.walletId);
    final txRef = _txCollection(transaction.walletId).doc(transaction.id);
    final dto = TransactionDto.fromEntity(transaction);
    final isReceive = transaction.type == TransactionType.receive;
    final amount = transaction.amount;

    final batch = _firestore.batch();
    batch.set(txRef, dto.toFirestore());
    batch.update(walletRef, {
      'currentBalance': FieldValue.increment(isReceive ? amount : -amount),
      'totalReceived': FieldValue.increment(isReceive ? amount : 0),
      'totalSent': FieldValue.increment(isReceive ? 0 : amount),
      'lastBalanceAt': Timestamp.fromDate(transaction.createdAt),
    });
    await batch.commit();
  }

  // ── Notes ──────────────────────────────────────────────────────────────────

  @override
  Future<void> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  }) async {
    final noteRef = _txCollection(
      walletId,
    ).doc(transactionId).collection('notes').doc();
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
    await _txCollection(walletId)
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
    await _txCollection(
      walletId,
    ).doc(transactionId).collection('notes').doc(noteId).delete();
  }

  @override
  Stream<List<NoteDto>> getNotes({
    required String walletId,
    required String transactionId,
  }) {
    return _txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(NoteDto.fromFirestore).toList());
  }

  // ── History ────────────────────────────────────────────────────────────────

  @override
  Stream<List<HistoryEntryDto>> getHistory({
    required String walletId,
    required String transactionId,
  }) {
    return _txCollection(walletId)
        .doc(transactionId)
        .collection('history')
        .orderBy('occurredAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(HistoryEntryDto.fromFirestore).toList(),
        );
  }
}

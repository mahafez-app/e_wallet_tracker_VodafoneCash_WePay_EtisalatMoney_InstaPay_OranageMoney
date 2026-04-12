import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../models/note_dto.dart';
import '../models/transaction_history_entry_dto.dart';
import '../models/transaction_page_dto.dart';

abstract interface class TransactionRemoteDataSource {
  Future<TransactionPageDto> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionPageCursor? cursor,
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

  Stream<List<TransactionHistoryEntryDto>> getTransactionHistory({
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
  Future<TransactionPageDto> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionPageCursor? cursor,
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
      _walletTransactionsQuery(walletId),
      type: type,
      dateRange: dateRange,
    ).limit(limit);

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
      nextCursor: docs.length == limit ? _toCursor(docs.last) : null,
    );
  }

  @override
  Future<List<TransactionDto>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
  }) async {
    if (walletIds.isEmpty || limit <= 0) {
      return const <TransactionDto>[];
    }

    final states = await Future.wait(
      walletIds.map(
        (walletId) => _createWorkspaceTransactionState(walletId: walletId),
      ),
    );

    return _collectLatestWorkspaceTransactions(
      states: states,
      type: type,
      dateRange: dateRange,
      limit: limit,
    );
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
  Stream<List<TransactionHistoryEntryDto>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  }) {
    return _txCollection(walletId)
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

  Query<Map<String, dynamic>> _walletTransactionsQuery(String walletId) =>
      _txCollection(walletId)
          .orderBy('createdAt', descending: true)
          .orderBy(FieldPath.documentId, descending: true);

  Future<_WorkspaceWalletTransactionState> _createWorkspaceTransactionState({
    required String walletId,
  }) async {
    final meta = await _walletMeta(walletId);
    return _WorkspaceWalletTransactionState(
      walletId: walletId,
      provider: meta.provider,
      phoneNumber: meta.phoneNumber,
    );
  }

  Future<List<TransactionDto>> _collectLatestWorkspaceTransactions({
    required List<_WorkspaceWalletTransactionState> states,
    required int limit,
    required TransactionType? type,
    required TransactionDateRange? dateRange,
  }) async {
    final results = <TransactionDto>[];
    final batchSize = _resolveWorkspaceBatchSize(limit);

    while (results.length < limit) {
      final candidate = await _selectLatestWorkspaceTransaction(
        states: states,
        batchSize: batchSize,
        type: type,
        dateRange: dateRange,
      );
      if (candidate == null) {
        break;
      }

      results.add(candidate.transaction);
      candidate.state.pendingTransactions.removeAt(0);
    }

    return results;
  }

  Future<_WorkspaceWalletTransactionCandidate?>
  _selectLatestWorkspaceTransaction({
    required List<_WorkspaceWalletTransactionState> states,
    required int batchSize,
    required TransactionType? type,
    required TransactionDateRange? dateRange,
  }) async {
    _WorkspaceWalletTransactionCandidate? selectedCandidate;

    for (final state in states) {
      final transaction = await _peekWorkspaceTransaction(
        state: state,
        batchSize: batchSize,
        type: type,
        dateRange: dateRange,
      );
      if (transaction == null) {
        continue;
      }

      if (selectedCandidate == null ||
          _isTransactionAfter(transaction, selectedCandidate.transaction)) {
        selectedCandidate = _WorkspaceWalletTransactionCandidate(
          state: state,
          transaction: transaction,
        );
      }
    }

    return selectedCandidate;
  }

  Future<TransactionDto?> _peekWorkspaceTransaction({
    required _WorkspaceWalletTransactionState state,
    required int batchSize,
    required TransactionType? type,
    required TransactionDateRange? dateRange,
  }) async {
    if (state.pendingTransactions.isNotEmpty) {
      return state.pendingTransactions.first;
    }
    if (state.exhausted) {
      return null;
    }

    final batch = await _fetchWorkspaceTransactionBatch(
      state: state,
      batchSize: batchSize,
      type: type,
      dateRange: dateRange,
    );

    state.pendingTransactions.addAll(batch.transactions);
    state.lastFetchedDocument = batch.lastFetchedDocument;
    state.exhausted = batch.transactions.length < batchSize;

    if (state.pendingTransactions.isEmpty) {
      return null;
    }

    return state.pendingTransactions.first;
  }

  Future<_WorkspaceTransactionBatch> _fetchWorkspaceTransactionBatch({
    required _WorkspaceWalletTransactionState state,
    required int batchSize,
    required TransactionType? type,
    required TransactionDateRange? dateRange,
  }) async {
    var query = _applyFilters(
      _walletTransactionsQuery(state.walletId),
      type: type,
      dateRange: dateRange,
    );
    if (state.lastFetchedDocument != null) {
      query = query.startAfterDocument(state.lastFetchedDocument!);
    }

    final snapshot = await query.limit(batchSize).get();
    final transactions = snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            state.provider,
            state.phoneNumber,
            state.walletId,
          ),
        )
        .toList();

    return _WorkspaceTransactionBatch(
      transactions: transactions,
      lastFetchedDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
    );
  }

  int _resolveWorkspaceBatchSize(int limit) {
    if (limit <= 0) {
      return 1;
    }
    if (limit < 5) {
      return limit;
    }
    return 5;
  }

  bool _isTransactionAfter(TransactionDto left, TransactionDto right) {
    final dateComparison = left.createdAt.compareTo(right.createdAt);
    if (dateComparison != 0) {
      return dateComparison > 0;
    }

    return left.id.compareTo(right.id) > 0;
  }

  TransactionPageCursor _toCursor(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final createdAt =
        (document.data()['createdAt'] as Timestamp? ?? Timestamp.now())
            .toDate();

    return TransactionPageCursor(
      createdAt: createdAt,
      transactionId: document.id,
    );
  }
}

final class _WorkspaceWalletTransactionState {
  _WorkspaceWalletTransactionState({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;
  final List<TransactionDto> pendingTransactions = <TransactionDto>[];
  QueryDocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
  bool exhausted = false;
}

final class _WorkspaceTransactionBatch {
  const _WorkspaceTransactionBatch({
    required this.transactions,
    required this.lastFetchedDocument,
  });

  final List<TransactionDto> transactions;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
}

final class _WorkspaceWalletTransactionCandidate {
  const _WorkspaceWalletTransactionCandidate({
    required this.state,
    required this.transaction,
  });

  final _WorkspaceWalletTransactionState state;
  final TransactionDto transaction;
}

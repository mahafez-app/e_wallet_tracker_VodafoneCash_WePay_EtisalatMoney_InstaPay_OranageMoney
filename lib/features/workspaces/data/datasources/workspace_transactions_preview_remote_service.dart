import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/domain/enums/wallet_provider.dart';

class WorkspaceTransactionsPreviewRemoteService {
  const WorkspaceTransactionsPreviewRemoteService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<TransactionDto>> getWorkspaceTransactionsPreview({
    required List<String> walletIds,
    int limit = 5,
  }) async {
    if (walletIds.isEmpty || limit <= 0) {
      return const <TransactionDto>[];
    }

    final states = await Future.wait(
      walletIds.map(
        (walletId) => _createWorkspacePreviewState(walletId: walletId),
      ),
    );

    return _collectLatestWorkspacePreviewTransactions(
      states: states.whereType<_WorkspacePreviewState>().toList(),
      limit: limit,
    );
  }

  Future<_WorkspacePreviewState?> _createWorkspacePreviewState({
    required String walletId,
  }) async {
    final walletSnapshot = await _firestore
        .collection('wallets')
        .doc(walletId)
        .get();
    if (!walletSnapshot.exists) {
      return null;
    }

    final wallet = WalletDto.fromFirestore(walletSnapshot);
    return _WorkspacePreviewState(
      walletId: wallet.id,
      provider: wallet.provider,
      phoneNumber: wallet.phoneNumber,
    );
  }

  Future<List<TransactionDto>> _collectLatestWorkspacePreviewTransactions({
    required List<_WorkspacePreviewState> states,
    required int limit,
  }) async {
    final results = <TransactionDto>[];

    while (results.length < limit) {
      final candidate = await _selectLatestWorkspacePreviewTransaction(
        states: states,
        batchSize: limit,
      );
      if (candidate == null) {
        break;
      }

      results.add(candidate.transaction);
      candidate.state.pendingTransactions.removeAt(0);
    }

    return results;
  }

  Future<_WorkspacePreviewCandidate?> _selectLatestWorkspacePreviewTransaction({
    required List<_WorkspacePreviewState> states,
    required int batchSize,
  }) async {
    _WorkspacePreviewCandidate? selectedCandidate;

    for (final state in states) {
      final transaction = await _peekWorkspacePreviewTransaction(
        state: state,
        batchSize: batchSize,
      );
      if (transaction == null) {
        continue;
      }

      if (selectedCandidate == null ||
          _isTransactionAfter(transaction, selectedCandidate.transaction)) {
        selectedCandidate = _WorkspacePreviewCandidate(
          state: state,
          transaction: transaction,
        );
      }
    }

    return selectedCandidate;
  }

  Future<TransactionDto?> _peekWorkspacePreviewTransaction({
    required _WorkspacePreviewState state,
    required int batchSize,
  }) async {
    if (state.pendingTransactions.isNotEmpty) {
      return state.pendingTransactions.first;
    }
    if (state.exhausted) {
      return null;
    }

    final batch = await _fetchWorkspacePreviewBatch(
      state: state,
      batchSize: batchSize,
    );

    state.pendingTransactions.addAll(batch.transactions);
    state.lastFetchedDocument = batch.lastFetchedDocument;
    state.exhausted = batch.transactions.length < batchSize;

    if (state.pendingTransactions.isEmpty) {
      return null;
    }

    return state.pendingTransactions.first;
  }

  Future<_WorkspacePreviewBatch> _fetchWorkspacePreviewBatch({
    required _WorkspacePreviewState state,
    required int batchSize,
  }) async {
    var query = _workspaceWalletTransactionsQuery(state.walletId);
    if (state.lastFetchedDocument != null) {
      query = query.startAfterDocument(state.lastFetchedDocument!);
    }

    final snapshot = await query.limit(batchSize).get();
    final transactions = snapshot.docs
        .map(
          (document) => TransactionDto.fromFirestore(
            document,
            state.provider,
            state.phoneNumber,
            state.walletId,
          ),
        )
        .toList();

    return _WorkspacePreviewBatch(
      transactions: transactions,
      lastFetchedDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
    );
  }

  Query<Map<String, dynamic>> _workspaceWalletTransactionsQuery(
    String walletId,
  ) {
    return _firestore
        .collection('wallets')
        .doc(walletId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .orderBy(FieldPath.documentId, descending: true);
  }

  bool _isTransactionAfter(TransactionDto left, TransactionDto right) {
    final dateComparison = left.createdAt.compareTo(right.createdAt);
    if (dateComparison != 0) {
      return dateComparison > 0;
    }

    return left.id.compareTo(right.id) > 0;
  }
}

final class _WorkspacePreviewState {
  _WorkspacePreviewState({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;
  final List<TransactionDto> pendingTransactions = <TransactionDto>[];
  DocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
  bool exhausted = false;
}

final class _WorkspacePreviewBatch {
  const _WorkspacePreviewBatch({
    required this.transactions,
    required this.lastFetchedDocument,
  });

  final List<TransactionDto> transactions;
  final DocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
}

final class _WorkspacePreviewCandidate {
  const _WorkspacePreviewCandidate({
    required this.state,
    required this.transaction,
  });

  final _WorkspacePreviewState state;
  final TransactionDto transaction;
}

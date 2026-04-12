import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/data/models/workspace_dto.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../models/workspace_member_dto.dart';

abstract interface class WorkspaceRemoteDataSource {
  Future<WorkspaceDto> createWorkspace({required String name});

  Future<int> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  });

  Future<WorkspaceDto> getWorkspace(String workspaceId);

  Stream<WorkspaceDto> watchWorkspace(String workspaceId);

  Future<List<WorkspaceMemberDto>> getWorkspaceMembers(String workspaceId);

  Future<List<WalletDto>> getWorkspaceWallets(String workspaceId);

  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId);

  Future<List<TransactionDto>> getWorkspaceTransactionsPreview({
    required List<String> walletIds,
    int limit = 5,
  });
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  static const String _usersCollection = 'users';

  const WorkspaceRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<WorkspaceDto> createWorkspace({required String name}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in.');
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const ValidationFailure(
        code: 'workspace-name-required',
        technicalMessage: 'Workspace name is required.',
      );
    }

    final workspaceRef = _firestore.collection('workspaces').doc();
    final memberRef = workspaceRef.collection('members').doc(currentUser.uid);
    final batch = _firestore.batch();
    final now = DateTime.now();

    final workspaceDto = WorkspaceDto(
      id: workspaceRef.id,
      name: trimmedName,
      ownerUid: currentUser.uid,
      walletsCount: 0,
      totalReceived: 0,
      totalSent: 0,
      createdAt: now,
    );

    batch.set(workspaceRef, workspaceDto.toFirestore());
    batch.set(memberRef, {
      'uid': currentUser.uid,
      'role': 'owner',
      'joinedAt': Timestamp.fromDate(now),
    });

    await batch.commit();
    return workspaceDto;
  }

  @override
  Future<int> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  }) async {
    if (_auth.currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in.');
    }

    final uniqueWalletIds = walletIds.toSet().toList();
    if (uniqueWalletIds.isEmpty) {
      return 0;
    }

    final workspaceWalletsRef = _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('wallets');

    final existingLinkSnapshots = await Future.wait(
      uniqueWalletIds.map(
        (walletId) => workspaceWalletsRef.doc(walletId).get(),
      ),
    );

    final walletIdsToLink = <String>[];
    for (var index = 0; index < uniqueWalletIds.length; index++) {
      if (!existingLinkSnapshots[index].exists) {
        walletIdsToLink.add(uniqueWalletIds[index]);
      }
    }

    if (walletIdsToLink.isNotEmpty) {
      final batch = _firestore.batch();
      final now = Timestamp.fromDate(DateTime.now());

      for (final walletId in walletIdsToLink) {
        batch.set(workspaceWalletsRef.doc(walletId), {
          'walletId': walletId,
          'addedAt': now,
        });
      }

      await batch.commit();
    }

    await _syncWorkspaceAggregate(workspaceId);
    return walletIdsToLink.length;
  }

  @override
  Future<WorkspaceDto> getWorkspace(String workspaceId) async {
    final doc = await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .get();
    if (!doc.exists) {
      throw const ServerFailure(
        code: '404',
        technicalMessage: 'Workspace not found.',
      );
    }

    return WorkspaceDto.fromFirestore(doc);
  }

  @override
  Stream<WorkspaceDto> watchWorkspace(String workspaceId) {
    return _firestore.collection('workspaces').doc(workspaceId).snapshots().map(
      (doc) {
        if (!doc.exists) {
          throw const ServerFailure(
            code: '404',
            technicalMessage: 'Workspace not found.',
          );
        }

        return WorkspaceDto.fromFirestore(doc);
      },
    );
  }

  @override
  Future<List<WorkspaceMemberDto>> getWorkspaceMembers(
    String workspaceId,
  ) async {
    final snapshot = await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('members')
        .orderBy('joinedAt')
        .get();

    if (snapshot.docs.isEmpty) {
      return const <WorkspaceMemberDto>[];
    }

    final futures = snapshot.docs.map(_getWorkspaceMemberProfile);
    return Future.wait(futures);
  }

  @override
  Future<List<WalletDto>> getWorkspaceWallets(String workspaceId) async {
    final linksSnapshot = await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('wallets')
        .orderBy('addedAt')
        .get();

    final walletIds = linksSnapshot.docs
        .map((doc) => doc.data()['walletId'] as String? ?? doc.id)
        .toList();

    if (walletIds.isEmpty) {
      return const <WalletDto>[];
    }

    final futures = walletIds.map(
      (walletId) => _firestore.collection('wallets').doc(walletId).get(),
    );
    final walletDocs = await Future.wait(futures);

    return walletDocs
        .where((doc) => doc.exists)
        .map((doc) => WalletDto.fromFirestore(doc))
        .toList();
  }

  @override
  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId) {
    final linksStream = _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('wallets')
        .orderBy('addedAt')
        .snapshots();

    return linksStream.switchMap((snapshot) {
      final walletIds = snapshot.docs
          .map((doc) => doc.data()['walletId'] as String? ?? doc.id)
          .toList();

      if (walletIds.isEmpty) {
        return Stream.value(const <WalletDto>[]);
      }

      final walletStreams = walletIds.map(
        (walletId) =>
            _firestore.collection('wallets').doc(walletId).snapshots(),
      );

      return Rx.combineLatestList(walletStreams).map((walletDocs) {
        return walletDocs
            .where((doc) => doc.exists)
            .map((doc) => WalletDto.fromFirestore(doc))
            .toList();
      });
    });
  }

  @override
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
    if (!walletSnapshot.exists) return null;

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
          (doc) => TransactionDto.fromFirestore(
            doc,
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
  ) => _firestore
      .collection('wallets')
      .doc(walletId)
      .collection('transactions')
      .orderBy('createdAt', descending: true)
      .orderBy(FieldPath.documentId, descending: true);

  bool _isTransactionAfter(TransactionDto left, TransactionDto right) {
    final dateComparison = left.createdAt.compareTo(right.createdAt);
    if (dateComparison != 0) {
      return dateComparison > 0;
    }

    return left.id.compareTo(right.id) > 0;
  }

  Future<WorkspaceMemberDto> _getWorkspaceMemberProfile(
    DocumentSnapshot<Map<String, dynamic>> membershipDoc,
  ) async {
    final membershipData = membershipDoc.data();
    final uid = membershipData?['uid'] as String? ?? membershipDoc.id;
    final userDoc = await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .get();
    final userData = userDoc.data();

    return WorkspaceMemberDto.fromFirestore(
      membershipDoc,
      userData: userData == null ? null : Map<String, Object?>.from(userData),
    );
  }

  Future<void> _syncWorkspaceAggregate(String workspaceId) async {
    final linkedWallets = await getWorkspaceWallets(workspaceId);

    final latestActivityAt = linkedWallets.isEmpty
        ? null
        : linkedWallets
              .map((wallet) => wallet.lastBalanceAt)
              .reduce(
                (current, next) => current.isAfter(next) ? current : next,
              );

    await _firestore.collection('workspaces').doc(workspaceId).update({
      'walletsCount': linkedWallets.length,
      'totalReceived': linkedWallets.fold<double>(
        0,
        (total, wallet) => total + wallet.totalReceived,
      ),
      'totalSent': linkedWallets.fold<double>(
        0,
        (total, wallet) => total + wallet.totalSent,
      ),
      'latestActivityAt': latestActivityAt == null
          ? null
          : Timestamp.fromDate(latestActivityAt),
    });
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
  QueryDocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
  bool exhausted = false;
}

final class _WorkspacePreviewBatch {
  const _WorkspacePreviewBatch({
    required this.transactions,
    required this.lastFetchedDocument,
  });

  final List<TransactionDto> transactions;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
}

final class _WorkspacePreviewCandidate {
  const _WorkspacePreviewCandidate({
    required this.state,
    required this.transaction,
  });

  final _WorkspacePreviewState state;
  final TransactionDto transaction;
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallet_product/wallet_product.dart';

import '../../../../core/data/models/workspace_dto.dart';

abstract interface class HomeRemoteDataSource {
  Stream<List<WalletEntity>> watchUserWallets();
  Stream<List<WorkspaceDto>> watchUserWorkspaces();
  Stream<List<WalletEntity>> watchWorkspaceWallets(String workspaceId);
  Stream<int> watchPendingInvitationsCount();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({
    required this._firestore,
    required this._auth,
    required this._walletQueries,
  });

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final WalletQueries _walletQueries;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return uid;
  }

  @override
  Stream<List<WalletEntity>> watchUserWallets() => _walletQueries.watchMine();

  @override
  Stream<List<WorkspaceDto>> watchUserWorkspaces() {
    return _firestore
        .collectionGroup('members')
        .where('uid', isEqualTo: _uid)
        .snapshots()
        .switchMap((memberSnapshot) {
          final workspaceIds = memberSnapshot.docs
              .map((doc) => doc.reference.parent.parent?.id)
              .whereType<String>()
              .toSet()
              .toList();

          if (workspaceIds.isEmpty) {
            return Stream.value(const <WorkspaceDto>[]);
          }

          final workspaceStreams = workspaceIds.map(
            (id) => _firestore.collection('workspaces').doc(id).snapshots(),
          );

          return Rx.combineLatestList(workspaceStreams).map((documents) {
            return documents
                .where((document) => document.exists)
                .map(WorkspaceDto.fromFirestore)
                .toList();
          });
        });
  }

  @override
  Stream<List<WalletEntity>> watchWorkspaceWallets(String workspaceId) {
    return _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('wallets')
        .orderBy('addedAt')
        .snapshots()
        .switchMap((snapshot) {
          final walletIds = snapshot.docs
              .map((doc) => doc.data()['walletId'] as String? ?? doc.id)
              .toList();

          if (walletIds.isEmpty) {
            return Stream.value(const <WalletEntity>[]);
          }

          return _walletQueries.watchByIds(walletIds);
        });
  }

  @override
  Stream<int> watchPendingInvitationsCount() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(0);

    return _firestore
        .collection('invites')
        .where('invitedUserId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallet_product/wallet_product.dart';

import '../../../../core/data/models/workspace_dto.dart';

abstract interface class HomeRemoteDataSource {
  Stream<List<WalletDto>> watchUserWallets();
  Stream<List<WorkspaceDto>> watchUserWorkspaces();
  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId);
  Stream<int> watchPendingInvitationsCount();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return uid;
  }

  @override
  Stream<List<WalletDto>> watchUserWallets() {
    return _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: _uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => WalletDto.fromFirestore(doc)).toList(),
        );
  }

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
  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId) {
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
            return Stream.value(const <WalletDto>[]);
          }

          final walletStreams = walletIds.map(
            (walletId) =>
                _firestore.collection('wallets').doc(walletId).snapshots(),
          );

          return Rx.combineLatestList(walletStreams).map((documents) {
            return documents
                .where((document) => document.exists)
                .map(WalletDto.fromFirestore)
                .toList();
          });
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

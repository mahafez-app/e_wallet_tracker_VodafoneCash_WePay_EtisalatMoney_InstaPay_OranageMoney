import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallet_tracker/core/data/models/wallet_dto.dart';

import '../../../../core/data/models/workspace_dto.dart';

abstract interface class HomeRemoteDataSource {
  Stream<List<WalletDto>> watchUserWallets();
  Stream<List<WorkspaceDto>> watchUserWorkspaces();
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
        .asyncMap((memberSnapshot) async {
          final workspaceIds = memberSnapshot.docs
              .map((doc) => doc.reference.parent.parent?.id)
              .whereType<String>()
              .toSet()
              .toList();

          if (workspaceIds.isEmpty) return <WorkspaceDto>[];

          final futures = workspaceIds.map(
            (id) => _firestore
                .collection('workspaces')
                .where(FieldPath.documentId, isEqualTo: id)
                .get(),
          );

          final snapshots = await Future.wait(futures);

          return snapshots
              .expand((s) => s.docs)
              .map((doc) => WorkspaceDto.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Stream<int> watchPendingInvitationsCount() {
    final email = _auth.currentUser?.email;
    if (email == null) return Stream.value(0);

    return _firestore
        .collection('invites')
        .where('email', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}

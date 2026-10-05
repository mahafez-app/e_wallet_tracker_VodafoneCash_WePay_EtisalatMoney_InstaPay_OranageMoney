import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'package:wallet_product/wallet_product.dart';

import '../../../../core/data/models/workspace_dto.dart';

import 'package:mahafez_core/mahafez_core.dart';

import '../models/workspace_member_dto.dart';

class WorkspaceQueryRemoteService {
  static const String _usersCollection = 'users';

  const WorkspaceQueryRemoteService({
    required FirebaseFirestore firestore,
    required WalletQueries walletQueries,
  }) : _firestore = firestore,
       _walletQueries = walletQueries;

  final FirebaseFirestore _firestore;
  final WalletQueries _walletQueries;

  CollectionReference<Map<String, dynamic>> get _workspacesCollection =>
      _firestore.collection('workspaces');

  Future<WorkspaceDto> getWorkspace(String workspaceId) async {
    final document = await _workspacesCollection.doc(workspaceId).get();
    if (!document.exists) {
      throw const ServerFailure(
        code: '404',
        technicalMessage: 'Workspace not found.',
      );
    }

    return WorkspaceDto.fromFirestore(document);
  }

  Stream<WorkspaceDto?> watchWorkspace(String workspaceId) {
    return _workspacesCollection.doc(workspaceId).snapshots().map((document) {
      if (!document.exists) {
        return null;
      }

      return WorkspaceDto.fromFirestore(document);
    });
  }

  Future<List<WorkspaceMemberDto>> getWorkspaceMembers(
    String workspaceId,
  ) async {
    final snapshot = await _workspacesCollection
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

  Stream<List<WorkspaceMemberDto>> watchWorkspaceMembers(String workspaceId) {
    final membersStream = _workspacesCollection
        .doc(workspaceId)
        .collection('members')
        .orderBy('joinedAt')
        .snapshots();

    return membersStream.switchMap((snapshot) {
      if (snapshot.docs.isEmpty) {
        return Stream.value(const <WorkspaceMemberDto>[]);
      }

      return Stream.fromFuture(
        Future.wait(snapshot.docs.map(_getWorkspaceMemberProfile)),
      );
    });
  }

  Future<List<WalletEntity>> getWorkspaceWallets(String workspaceId) async {
    final linkedWalletIds = await _getLinkedWalletIds(workspaceId);
    if (linkedWalletIds.isEmpty) {
      return const <WalletEntity>[];
    }
    return _walletQueries.getByIds(linkedWalletIds);
  }

  Stream<List<WalletEntity>> watchWorkspaceWallets(String workspaceId) {
    final linksStream = _workspacesCollection
        .doc(workspaceId)
        .collection('wallets')
        .orderBy('addedAt')
        .snapshots();

    return linksStream.switchMap((snapshot) {
      final walletIds = snapshot.docs
          .map((doc) => doc.data()['walletId'] as String? ?? doc.id)
          .toList();

      if (walletIds.isEmpty) {
        return Stream.value(const <WalletEntity>[]);
      }
      return _walletQueries.watchByIds(walletIds);
    });
  }

  Future<List<String>> getLinkedWalletIds(String workspaceId) {
    return _getLinkedWalletIds(workspaceId);
  }

  Future<List<String>> getWorkspaceIdsContainingWallet(String walletId) async {
    final links = await _firestore
        .collectionGroup('wallets')
        .where('walletId', isEqualTo: walletId)
        .get();
    return links.docs
        .map((document) => document.reference.parent.parent?.id)
        .whereType<String>()
        .toSet()
        .toList();
  }

  Future<WorkspaceMemberDto> _getWorkspaceMemberProfile(
    DocumentSnapshot<Map<String, dynamic>> membershipDoc,
  ) async {
    final membershipData = membershipDoc.data();
    final uid = membershipData?['uid'] as String? ?? membershipDoc.id;
    final userDocument = await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .get();
    final userData = userDocument.data();

    return WorkspaceMemberDto.fromFirestore(
      membershipDoc,
      userData: userData == null ? null : Map<String, Object?>.from(userData),
    );
  }

  Future<List<String>> _getLinkedWalletIds(String workspaceId) async {
    final linksSnapshot = await _workspacesCollection
        .doc(workspaceId)
        .collection('wallets')
        .orderBy('addedAt')
        .get();

    return linksSnapshot.docs
        .map((doc) => doc.data()['walletId'] as String? ?? doc.id)
        .toList();
  }
}

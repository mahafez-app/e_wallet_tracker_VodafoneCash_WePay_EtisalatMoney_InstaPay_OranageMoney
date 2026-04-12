import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/data/models/workspace_dto.dart';
import '../../../../core/error/failures.dart';
import '../models/workspace_member_dto.dart';

class WorkspaceQueryRemoteService {
  static const String _usersCollection = 'users';

  const WorkspaceQueryRemoteService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

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

  Stream<WorkspaceDto> watchWorkspace(String workspaceId) {
    return _workspacesCollection.doc(workspaceId).snapshots().map((document) {
      if (!document.exists) {
        throw const ServerFailure(
          code: '404',
          technicalMessage: 'Workspace not found.',
        );
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

  Future<List<WalletDto>> getWorkspaceWallets(String workspaceId) async {
    final linkedWalletIds = await _getLinkedWalletIds(workspaceId);
    if (linkedWalletIds.isEmpty) {
      return const <WalletDto>[];
    }

    final futures = linkedWalletIds.map(
      (walletId) => _firestore.collection('wallets').doc(walletId).get(),
    );
    final walletDocuments = await Future.wait(futures);

    return walletDocuments
        .where((document) => document.exists)
        .map(WalletDto.fromFirestore)
        .toList();
  }

  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId) {
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
        return Stream.value(const <WalletDto>[]);
      }

      final walletStreams = walletIds.map(
        (walletId) =>
            _firestore.collection('wallets').doc(walletId).snapshots(),
      );

      return Rx.combineLatestList(walletStreams).map((walletDocuments) {
        return walletDocuments
            .where((document) => document.exists)
            .map(WalletDto.fromFirestore)
            .toList();
      });
    });
  }

  Future<List<String>> getLinkedWalletIds(String workspaceId) {
    return _getLinkedWalletIds(workspaceId);
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

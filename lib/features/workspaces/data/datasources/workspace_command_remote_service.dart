import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/models/workspace_dto.dart';
import '../../../../core/error/failures.dart';
import 'workspace_query_remote_service.dart';

class WorkspaceCommandRemoteService {
  const WorkspaceCommandRemoteService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required WorkspaceQueryRemoteService queryService,
  }) : _firestore = firestore,
       _auth = auth,
       _queryService = queryService;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final WorkspaceQueryRemoteService _queryService;

  CollectionReference<Map<String, dynamic>> get _workspacesCollection =>
      _firestore.collection('workspaces');

  CollectionReference<Map<String, dynamic>> get _invitesCollection =>
      _firestore.collection('invites');

  User get _currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in.');
    }

    return user;
  }

  Future<WorkspaceDto> createWorkspace({required String name}) async {
    final currentUser = _currentUser;
    final trimmedName = _validateAndTrimName(name);

    final workspaceRef = _workspacesCollection.doc();
    final memberRef = workspaceRef.collection('members').doc(currentUser.uid);
    final batch = _firestore.batch();
    final now = DateTime.now();

    final workspace = WorkspaceDto(
      id: workspaceRef.id,
      name: trimmedName,
      ownerUid: currentUser.uid,
      walletsCount: 0,
      totalReceived: 0,
      totalSent: 0,
      createdAt: now,
    );

    batch.set(workspaceRef, workspace.toFirestore());
    batch.set(memberRef, {
      'uid': currentUser.uid,
      'role': 'owner',
      'joinedAt': Timestamp.fromDate(now),
    });

    await batch.commit();
    return workspace;
  }

  Future<WorkspaceDto> updateWorkspaceName({
    required String workspaceId,
    required String name,
  }) async {
    final currentUser = _currentUser;
    final trimmedName = _validateAndTrimName(name);
    final workspaceRef = _workspacesCollection.doc(workspaceId);
    final workspaceSnapshot = await workspaceRef.get();
    final workspaceData = _getWorkspaceDataOrThrow(workspaceSnapshot);

    _ensureWorkspaceOwner(workspaceData, currentUser.uid);
    await workspaceRef.update({'name': trimmedName});

    final updatedSnapshot = await workspaceRef.get();
    return WorkspaceDto.fromFirestore(updatedSnapshot);
  }

  Future<int> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  }) async {
    _currentUser;

    final uniqueWalletIds = walletIds.toSet().toList();
    if (uniqueWalletIds.isEmpty) {
      return 0;
    }

    final workspaceWalletsRef = _workspacesCollection
        .doc(workspaceId)
        .collection('wallets');
    final existingLinks = await Future.wait(
      uniqueWalletIds.map(
        (walletId) => workspaceWalletsRef.doc(walletId).get(),
      ),
    );

    final walletIdsToLink = <String>[];
    for (var index = 0; index < uniqueWalletIds.length; index++) {
      if (!existingLinks[index].exists) {
        walletIdsToLink.add(uniqueWalletIds[index]);
      }
    }

    if (walletIdsToLink.isNotEmpty) {
      final batch = _firestore.batch();
      final addedAt = Timestamp.fromDate(DateTime.now());

      for (final walletId in walletIdsToLink) {
        batch.set(workspaceWalletsRef.doc(walletId), {
          'walletId': walletId,
          'addedAt': addedAt,
        });
      }

      await batch.commit();
    }

    await _syncWorkspaceAggregate(workspaceId);
    return walletIdsToLink.length;
  }

  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String memberUid,
  }) async {
    final currentUser = _currentUser;
    final workspaceSnapshot = await _workspacesCollection
        .doc(workspaceId)
        .get();
    final workspaceData = _getWorkspaceDataOrThrow(workspaceSnapshot);

    _ensureWorkspaceOwner(workspaceData, currentUser.uid);

    final ownerUid = workspaceData['ownerUid'] as String? ?? '';
    if (memberUid == ownerUid) {
      throw const ValidationFailure(
        code: 'workspace-owner-removal-not-allowed',
        technicalMessage: 'The workspace owner cannot be removed.',
      );
    }

    final memberRef = workspaceSnapshot.reference
        .collection('members')
        .doc(memberUid);
    final memberSnapshot = await memberRef.get();
    if (!memberSnapshot.exists) {
      throw const ValidationFailure(
        code: 'workspace-member-not-found',
        technicalMessage: 'Workspace member not found.',
      );
    }

    await memberRef.delete();
  }

  Future<void> deleteWorkspace({required String workspaceId}) async {
    final currentUser = _currentUser;
    final workspaceRef = _workspacesCollection.doc(workspaceId);
    final workspaceSnapshot = await workspaceRef.get();
    final workspaceData = _getWorkspaceDataOrThrow(workspaceSnapshot);

    _ensureWorkspaceOwner(workspaceData, currentUser.uid);

    final membersSnapshot = await workspaceRef.collection('members').get();
    final walletsSnapshot = await workspaceRef.collection('wallets').get();
    final invitationsSnapshot = await _invitesCollection
        .where('workspaceId', isEqualTo: workspaceId)
        .get();

    await _deleteDocumentsInBatches([
      workspaceSnapshot.reference,
      ...membersSnapshot.docs.map((doc) => doc.reference),
      ...walletsSnapshot.docs.map((doc) => doc.reference),
      ...invitationsSnapshot.docs.map((doc) => doc.reference),
    ]);
  }

  String _validateAndTrimName(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const ValidationFailure(
        code: 'workspace-name-required',
        technicalMessage: 'Workspace name is required.',
      );
    }

    return trimmedName;
  }

  Map<String, dynamic> _getWorkspaceDataOrThrow(
    DocumentSnapshot<Map<String, dynamic>> workspaceSnapshot,
  ) {
    final workspaceData = workspaceSnapshot.data();
    if (!workspaceSnapshot.exists || workspaceData == null) {
      throw const ServerFailure(
        code: '404',
        technicalMessage: 'Workspace not found.',
      );
    }

    return workspaceData;
  }

  void _ensureWorkspaceOwner(
    Map<String, dynamic> workspaceData,
    String currentUid,
  ) {
    final ownerUid = workspaceData['ownerUid'] as String? ?? '';
    if (ownerUid != currentUid) {
      throw const PermissionFailure(
        technicalMessage: 'Only the workspace owner can manage the workspace.',
      );
    }
  }

  Future<void> _syncWorkspaceAggregate(String workspaceId) async {
    final linkedWallets = await _queryService.getWorkspaceWallets(workspaceId);

    final latestActivityAt = linkedWallets.isEmpty
        ? null
        : linkedWallets
              .map((wallet) => wallet.lastBalanceAt)
              .reduce(
                (current, next) => current.isAfter(next) ? current : next,
              );

    await _workspacesCollection.doc(workspaceId).update({
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

  Future<void> _deleteDocumentsInBatches(
    List<DocumentReference<Map<String, dynamic>>> references,
  ) async {
    for (var index = 0; index < references.length; index += 450) {
      final end = (index + 450) > references.length
          ? references.length
          : index + 450;
      final batch = _firestore.batch();
      for (final reference in references.sublist(index, end)) {
        batch.delete(reference);
      }
      await batch.commit();
    }
  }
}

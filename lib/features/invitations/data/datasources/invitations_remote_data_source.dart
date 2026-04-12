import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../domain/enums/invitation_status.dart';
import '../models/invitation_dto.dart';

typedef _WorkspaceContext = ({
  DocumentReference<Map<String, dynamic>> reference,
  Map<String, dynamic> data,
});

typedef _UserContext = ({String uid, Map<String, dynamic> data});

abstract interface class InvitationsRemoteDataSource {
  Future<void> createInvitation({
    required String workspaceId,
    required String email,
  });

  Future<List<InvitationDto>> getPendingInvitations();

  Future<void> acceptInvitation(String invitationId);

  Future<void> declineInvitation(String invitationId);
}

class InvitationsRemoteDataSourceImpl implements InvitationsRemoteDataSource {
  const InvitationsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _invitesCollection =>
      _firestore.collection('invites');

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _workspacesCollection =>
      _firestore.collection('workspaces');

  String get _currentUid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in.');
    }
    return uid;
  }

  @override
  Future<void> createInvitation({
    required String workspaceId,
    required String email,
  }) async {
    final ownerUid = _currentUid;
    final workspace = await _getWorkspaceContext(workspaceId);
    _ensureWorkspaceOwner(workspace.data, ownerUid);

    final invitedUser = await _getUserByEmail(_normalizeEmail(email));
    _ensureNotSelfInvite(invitedUser.uid, ownerUid);
    await _ensureNoPendingInvitation(workspaceId, invitedUser.uid);
    await _ensureUserIsNotWorkspaceMember(workspace.reference, invitedUser.uid);

    final invitation = _buildInvitation(
      workspaceId: workspaceId,
      invitedUserId: invitedUser.uid,
      invitedByUid: ownerUid,
    );
    await _invitesCollection.doc(invitation.id).set(invitation.toFirestore());
  }

  @override
  Future<List<InvitationDto>> getPendingInvitations() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const <InvitationDto>[];
    }

    final snapshot = await _invitesCollection
        .where('invitedUserId', isEqualTo: uid)
        .where('status', isEqualTo: InvitationStatus.pending.name)
        .get();

    final invitations = snapshot.docs.map(InvitationDto.fromFirestore).toList()
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return invitations;
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    await _respondToInvitation(invitationId: invitationId, accept: true);
  }

  @override
  Future<void> declineInvitation(String invitationId) async {
    await _respondToInvitation(invitationId: invitationId, accept: false);
  }

  Future<void> _respondToInvitation({
    required String invitationId,
    required bool accept,
  }) async {
    final currentUid = _currentUid;
    final invitation = await _getPendingInvitation(invitationId);
    _ensureInvitationRecipient(invitation, currentUid);

    final batch = _firestore.batch();
    _applyInvitationResponse(
      batch: batch,
      invitationId: invitationId,
      accept: accept,
      currentUid: currentUid,
    );

    if (accept) {
      final workspace = await _getWorkspaceContext(invitation.workspaceId);
      _addWorkspaceMember(
        batch: batch,
        workspaceRef: workspace.reference,
        currentUid: currentUid,
        role: invitation.role,
      );
    }

    await batch.commit();
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  Future<_WorkspaceContext> _getWorkspaceContext(String workspaceId) async {
    final document = await _workspacesCollection.doc(workspaceId).get();
    final data = document.data();
    if (!document.exists || data == null) {
      throw const ServerFailure(
        code: '404',
        technicalMessage: 'Workspace not found.',
      );
    }

    return (reference: document.reference, data: data);
  }

  void _ensureWorkspaceOwner(
    Map<String, dynamic> workspaceData,
    String currentUid,
  ) {
    final ownerUid = workspaceData['ownerUid'] as String? ?? '';
    if (ownerUid != currentUid) {
      throw const PermissionFailure(
        technicalMessage: 'Only the workspace owner can send invitations.',
      );
    }
  }

  Future<_UserContext> _getUserByEmail(String email) async {
    final snapshot = await _usersCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      throw const ValidationFailure(
        code: 'invitation-user-not-found',
        technicalMessage: 'The invited email is not linked to any user.',
      );
    }

    final document = snapshot.docs.first;
    return (uid: document.id, data: document.data());
  }

  void _ensureNotSelfInvite(String invitedUserId, String currentUid) {
    if (invitedUserId == currentUid) {
      throw const ValidationFailure(
        code: 'invitation-self-not-allowed',
        technicalMessage: 'Owner cannot invite themselves.',
      );
    }
  }

  Future<void> _ensureNoPendingInvitation(
    String workspaceId,
    String invitedUserId,
  ) async {
    final snapshot = await _invitesCollection
        .where('workspaceId', isEqualTo: workspaceId)
        .where('invitedUserId', isEqualTo: invitedUserId)
        .where('status', isEqualTo: InvitationStatus.pending.name)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      throw const ValidationFailure(
        code: 'invitation-already-pending',
        technicalMessage: 'A pending invitation already exists for this user.',
      );
    }
  }

  Future<void> _ensureUserIsNotWorkspaceMember(
    DocumentReference<Map<String, dynamic>> workspaceRef,
    String invitedUserId,
  ) async {
    final memberDoc = await workspaceRef
        .collection('members')
        .doc(invitedUserId)
        .get();
    if (memberDoc.exists) {
      throw const ValidationFailure(
        code: 'invitation-user-already-member',
        technicalMessage: 'The invited user is already a workspace member.',
      );
    }
  }

  InvitationDto _buildInvitation({
    required String workspaceId,
    required String invitedUserId,
    required String invitedByUid,
  }) {
    return InvitationDto(
      id: _invitesCollection.doc().id,
      workspaceId: workspaceId,
      invitedUserId: invitedUserId,
      invitedByUid: invitedByUid,
      role: 'member',
      status: InvitationStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  Future<InvitationDto> _getPendingInvitation(String invitationId) async {
    final document = await _invitesCollection.doc(invitationId).get();
    if (!document.exists) {
      throw const ServerFailure(
        code: '404',
        technicalMessage: 'Invitation not found.',
      );
    }

    final invitation = InvitationDto.fromFirestore(document);
    if (invitation.status != InvitationStatus.pending) {
      throw const ValidationFailure(
        code: 'invitation-not-pending',
        technicalMessage: 'Invitation is no longer pending.',
      );
    }
    return invitation;
  }

  void _ensureInvitationRecipient(InvitationDto invitation, String currentUid) {
    if (invitation.invitedUserId != currentUid) {
      throw const PermissionFailure(
        technicalMessage: 'Current user cannot respond to this invitation.',
      );
    }
  }

  void _applyInvitationResponse({
    required WriteBatch batch,
    required String invitationId,
    required bool accept,
    required String currentUid,
  }) {
    batch.update(_invitesCollection.doc(invitationId), {
      'status': accept
          ? InvitationStatus.accepted.name
          : InvitationStatus.declined.name,
      'respondedAt': Timestamp.fromDate(DateTime.now()),
      'respondedByUid': currentUid,
    });
  }

  void _addWorkspaceMember({
    required WriteBatch batch,
    required DocumentReference<Map<String, dynamic>> workspaceRef,
    required String currentUid,
    required String role,
  }) {
    batch.set(workspaceRef.collection('members').doc(currentUid), {
      'uid': currentUid,
      'role': role,
      'joinedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }
}

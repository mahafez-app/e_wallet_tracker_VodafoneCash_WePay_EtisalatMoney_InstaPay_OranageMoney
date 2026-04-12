import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../domain/enums/invitation_status.dart';
import '../models/invitation_dto.dart';
import '../models/workspace_pending_invitation_dto.dart';

typedef WorkspaceContext = ({
  DocumentReference<Map<String, dynamic>> reference,
  Map<String, dynamic> data,
});

typedef UserContext = ({String uid, Map<String, dynamic> data});

class InvitationRemoteQueryService {
  const InvitationRemoteQueryService({
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

  String get currentUid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in.');
    }
    return uid;
  }

  String? get currentUidOrNull => _auth.currentUser?.uid;

  Future<List<InvitationDto>> getPendingInvitations() async {
    final uid = currentUidOrNull;
    if (uid == null) {
      return const <InvitationDto>[];
    }

    final snapshot = await _invitesCollection
        .where('invitedUserId', isEqualTo: uid)
        .where('status', isEqualTo: InvitationStatus.pending.name)
        .get();

    return snapshot.docs.map(InvitationDto.fromFirestore).toList()
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
  }

  Future<List<InvitationDto>> getRecentRespondedInvitations() async {
    final uid = currentUidOrNull;
    if (uid == null) {
      return const <InvitationDto>[];
    }

    final snapshot = await _invitesCollection
        .where('invitedUserId', isEqualTo: uid)
        .where(
          'status',
          whereIn: <String>[
            InvitationStatus.accepted.name,
            InvitationStatus.declined.name,
          ],
        )
        .orderBy('respondedAt', descending: true)
        .limit(2)
        .get();

    return snapshot.docs.map(InvitationDto.fromFirestore).toList();
  }

  Future<List<WorkspacePendingInvitationDto>> getWorkspacePendingInvitations(
    String workspaceId,
  ) async {
    final currentUid = this.currentUid;
    final workspace = await getWorkspaceContext(workspaceId);
    _ensureWorkspaceOwner(workspace.data, currentUid);

    final snapshot = await _invitesCollection
        .where('workspaceId', isEqualTo: workspaceId)
        .where('status', isEqualTo: InvitationStatus.pending.name)
        .get();

    if (snapshot.docs.isEmpty) {
      return const <WorkspacePendingInvitationDto>[];
    }

    final futures = snapshot.docs.map(_mapWorkspacePendingInvitation);
    final invitations = await Future.wait(futures);
    invitations.sort(
      (left, right) => right.createdAt.compareTo(left.createdAt),
    );
    return invitations;
  }

  Future<WorkspaceContext> getWorkspaceContext(String workspaceId) async {
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

  Future<UserContext> getUserByEmail(String email) async {
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

  Future<InvitationDto> getPendingInvitation(String invitationId) async {
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

  Future<bool> hasPendingInvitation({
    required String workspaceId,
    required String invitedUserId,
  }) async {
    final snapshot = await _invitesCollection
        .where('workspaceId', isEqualTo: workspaceId)
        .where('invitedUserId', isEqualTo: invitedUserId)
        .where('status', isEqualTo: InvitationStatus.pending.name)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> isWorkspaceMember({
    required DocumentReference<Map<String, dynamic>> workspaceRef,
    required String userId,
  }) async {
    final memberDoc = await workspaceRef
        .collection('members')
        .doc(userId)
        .get();
    return memberDoc.exists;
  }

  Future<WorkspacePendingInvitationDto> _mapWorkspacePendingInvitation(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) async {
    final invitation = InvitationDto.fromFirestore(document);
    final user = await getUserById(invitation.invitedUserId);
    final email = (user?.data['email'] as String?)?.trim();

    return WorkspacePendingInvitationDto(
      id: invitation.id,
      workspaceId: invitation.workspaceId,
      email: email != null && email.isNotEmpty
          ? email
          : invitation.invitedUserId,
      createdAt: invitation.createdAt,
    );
  }

  Future<UserContext?> getUserById(String uid) async {
    final document = await _usersCollection.doc(uid).get();
    final data = document.data();
    if (!document.exists || data == null) {
      return null;
    }

    return (uid: document.id, data: data);
  }

  void _ensureWorkspaceOwner(
    Map<String, dynamic> workspaceData,
    String currentUid,
  ) {
    final ownerUid = workspaceData['ownerUid'] as String? ?? '';
    if (ownerUid != currentUid) {
      throw const PermissionFailure(
        technicalMessage: 'Only the workspace owner can manage invitations.',
      );
    }
  }
}

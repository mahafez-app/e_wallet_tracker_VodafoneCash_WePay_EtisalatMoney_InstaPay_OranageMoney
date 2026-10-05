import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/enums/invitation_status.dart';
import '../models/invitation_dto.dart';
import 'invitation_remote_query_service.dart';

class InvitationRemoteCommandService {
  const InvitationRemoteCommandService({
    required this._firestore,
    required this._queryService,
  });

  final FirebaseFirestore _firestore;
  final InvitationRemoteQueryService _queryService;

  CollectionReference<Map<String, dynamic>> get _invitesCollection =>
      _firestore.collection('invites');

  String get _currentUid => _queryService.currentUid;

  Future<void> createInvitation({
    required String workspaceId,
    required String email,
  }) async {
    final ownerUid = _currentUid;
    final workspace = await _queryService.getWorkspaceContext(workspaceId);
    _ensureWorkspaceOwner(workspace.data, ownerUid);

    final invitedUser = await _queryService.getUserByEmail(
      _normalizeEmail(email),
    );
    _ensureNotSelfInvite(invitedUser.uid, ownerUid);
    await _ensureNoPendingInvitation(workspaceId, invitedUser.uid);
    await _ensureUserIsNotWorkspaceMember(workspace.reference, invitedUser.uid);
    final inviter = await _queryService.getUserById(ownerUid);
    final workspaceName = (workspace.data['name'] as String?)?.trim();
    final inviterName = (inviter?.data['name'] as String?)?.trim();

    final invitation = InvitationDto(
      id: _invitesCollection.doc().id,
      workspaceId: workspaceId,
      invitedUserId: invitedUser.uid,
      invitedByUid: ownerUid,
      role: 'member',
      status: InvitationStatus.pending,
      createdAt: DateTime.now(),
      workspaceName: workspaceName,
      inviterName: inviterName,
    );
    await _invitesCollection.doc(invitation.id).set(invitation.toFirestore());
  }

  Future<void> respondToInvitation({
    required String invitationId,
    required bool accept,
  }) async {
    final currentUid = _currentUid;
    final invitation = await _queryService.getPendingInvitation(invitationId);
    _ensureInvitationRecipient(invitation, currentUid);

    final batch = _firestore.batch();
    _applyInvitationResponse(
      batch: batch,
      invitationId: invitationId,
      accept: accept,
      currentUid: currentUid,
    );

    if (accept) {
      final workspace = await _queryService.getWorkspaceContext(
        invitation.workspaceId,
      );
      _addWorkspaceMember(
        batch: batch,
        workspaceRef: workspace.reference,
        currentUid: currentUid,
        role: invitation.role,
      );
    }

    await batch.commit();
  }

  Future<void> cancelInvitation(String invitationId) async {
    final ownerUid = _currentUid;
    final invitation = await _queryService.getPendingInvitation(invitationId);
    final workspace = await _queryService.getWorkspaceContext(
      invitation.workspaceId,
    );
    _ensureWorkspaceOwner(workspace.data, ownerUid);
    await _invitesCollection.doc(invitationId).delete();
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

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
    final hasPending = await _queryService.hasPendingInvitation(
      workspaceId: workspaceId,
      invitedUserId: invitedUserId,
    );
    if (hasPending) {
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
    final isMember = await _queryService.isWorkspaceMember(
      workspaceRef: workspaceRef,
      userId: invitedUserId,
    );
    if (isMember) {
      throw const ValidationFailure(
        code: 'invitation-user-already-member',
        technicalMessage: 'The invited user is already a workspace member.',
      );
    }
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

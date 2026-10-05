import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/invitation_entity.dart';
import '../../domain/entities/workspace_pending_invitation_entity.dart';
import '../../domain/repositories/invitations_repository.dart';
import '../datasources/invitations_remote_data_source.dart';

class InvitationsRepositoryImpl implements InvitationsRepository {
  const InvitationsRepositoryImpl({required this._remote});

  final InvitationsRemoteDataSource _remote;

  @override
  Future<Result<void>> createInvitation({
    required String workspaceId,
    required String email,
  }) {
    return executeAndHandleErrors(
      () => _remote.createInvitation(workspaceId: workspaceId, email: email),
      tag: 'InvitationsRepositoryImpl.createInvitation',
    );
  }

  @override
  Future<Result<List<InvitationEntity>>> getPendingInvitations() {
    return executeAndHandleErrors(() async {
      final invitations = await _remote.getPendingInvitations();
      return invitations.map((invitation) => invitation.toEntity()).toList();
    }, tag: 'InvitationsRepositoryImpl.getPendingInvitations');
  }

  @override
  Future<Result<List<WorkspacePendingInvitationEntity>>>
  getWorkspacePendingInvitations(String workspaceId) {
    return executeAndHandleErrors(() async {
      final invitations = await _remote.getWorkspacePendingInvitations(
        workspaceId,
      );
      return invitations.map((invitation) => invitation.toEntity()).toList();
    }, tag: 'InvitationsRepositoryImpl.getWorkspacePendingInvitations');
  }

  @override
  Stream<Result<List<WorkspacePendingInvitationEntity>>>
  watchWorkspacePendingInvitations(String workspaceId) {
    return executeStreamAndHandleErrors(() {
      return _remote
          .watchWorkspacePendingInvitations(workspaceId)
          .map(
            (invitations) =>
                invitations.map((invitation) => invitation.toEntity()).toList(),
          );
    }, tag: 'InvitationsRepositoryImpl.watchWorkspacePendingInvitations');
  }

  @override
  Future<Result<List<InvitationEntity>>> getRecentRespondedInvitations() {
    return executeAndHandleErrors(() async {
      final invitations = await _remote.getRecentRespondedInvitations();
      return invitations.map((invitation) => invitation.toEntity()).toList();
    }, tag: 'InvitationsRepositoryImpl.getRecentRespondedInvitations');
  }

  @override
  Future<Result<void>> acceptInvitation(String invitationId) {
    return executeAndHandleErrors(
      () => _remote.acceptInvitation(invitationId),
      tag: 'InvitationsRepositoryImpl.acceptInvitation',
    );
  }

  @override
  Future<Result<void>> declineInvitation(String invitationId) {
    return executeAndHandleErrors(
      () => _remote.declineInvitation(invitationId),
      tag: 'InvitationsRepositoryImpl.declineInvitation',
    );
  }

  @override
  Future<Result<void>> cancelInvitation(String invitationId) {
    return executeAndHandleErrors(
      () => _remote.cancelInvitation(invitationId),
      tag: 'InvitationsRepositoryImpl.cancelInvitation',
    );
  }
}

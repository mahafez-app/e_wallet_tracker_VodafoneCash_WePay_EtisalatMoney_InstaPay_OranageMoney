import '../../../../core/error/result.dart';
import '../entities/invitation_entity.dart';
import '../entities/workspace_pending_invitation_entity.dart';

abstract interface class InvitationsRepository {
  Future<Result<void>> createInvitation({
    required String workspaceId,
    required String email,
  });

  Future<Result<List<InvitationEntity>>> getPendingInvitations();

  Future<Result<List<WorkspacePendingInvitationEntity>>>
  getWorkspacePendingInvitations(String workspaceId);

  Future<Result<List<InvitationEntity>>> getRecentRespondedInvitations();

  Future<Result<void>> acceptInvitation(String invitationId);

  Future<Result<void>> declineInvitation(String invitationId);

  Future<Result<void>> cancelInvitation(String invitationId);
}

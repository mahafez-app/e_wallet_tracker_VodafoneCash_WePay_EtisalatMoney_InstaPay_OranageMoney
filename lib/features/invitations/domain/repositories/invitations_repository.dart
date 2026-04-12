import '../../../../core/error/result.dart';
import '../entities/invitation_entity.dart';

abstract interface class InvitationsRepository {
  Future<Result<void>> createInvitation({
    required String workspaceId,
    required String email,
  });

  Future<Result<List<InvitationEntity>>> getPendingInvitations();

  Future<Result<void>> acceptInvitation(String invitationId);

  Future<Result<void>> declineInvitation(String invitationId);
}

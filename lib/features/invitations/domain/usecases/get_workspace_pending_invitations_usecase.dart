import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workspace_pending_invitation_entity.dart';
import '../repositories/invitations_repository.dart';

class GetWorkspacePendingInvitationsParams {
  const GetWorkspacePendingInvitationsParams({required this.workspaceId});

  final String workspaceId;
}

class GetWorkspacePendingInvitationsUseCase
    implements
        UseCase<
          List<WorkspacePendingInvitationEntity>,
          GetWorkspacePendingInvitationsParams
        > {
  const GetWorkspacePendingInvitationsUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<List<WorkspacePendingInvitationEntity>>> call(
    GetWorkspacePendingInvitationsParams params,
  ) {
    return _repository.getWorkspacePendingInvitations(params.workspaceId);
  }
}

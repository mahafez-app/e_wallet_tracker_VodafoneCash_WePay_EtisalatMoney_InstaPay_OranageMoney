import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workspace_pending_invitation_entity.dart';
import '../repositories/invitations_repository.dart';

class WatchWorkspacePendingInvitationsParams {
  const WatchWorkspacePendingInvitationsParams({required this.workspaceId});

  final String workspaceId;
}

class WatchWorkspacePendingInvitationsUseCase
    implements
        StreamUseCase<
          List<WorkspacePendingInvitationEntity>,
          WatchWorkspacePendingInvitationsParams
        > {
  const WatchWorkspacePendingInvitationsUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Stream<Result<List<WorkspacePendingInvitationEntity>>> call(
    WatchWorkspacePendingInvitationsParams params,
  ) {
    return _repository.watchWorkspacePendingInvitations(params.workspaceId);
  }
}

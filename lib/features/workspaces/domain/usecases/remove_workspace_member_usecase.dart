import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/workspace_repository.dart';

class RemoveWorkspaceMemberParams {
  const RemoveWorkspaceMemberParams({
    required this.workspaceId,
    required this.memberUid,
  });

  final String workspaceId;
  final String memberUid;
}

class RemoveWorkspaceMemberUseCase
    implements UseCase<void, RemoveWorkspaceMemberParams> {
  const RemoveWorkspaceMemberUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<void>> call(RemoveWorkspaceMemberParams params) {
    return _repository.removeWorkspaceMember(
      workspaceId: params.workspaceId,
      memberUid: params.memberUid,
    );
  }
}

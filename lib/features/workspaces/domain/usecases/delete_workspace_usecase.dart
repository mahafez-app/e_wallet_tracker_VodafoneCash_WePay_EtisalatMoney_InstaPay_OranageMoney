import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/workspace_repository.dart';

class DeleteWorkspaceParams {
  const DeleteWorkspaceParams({required this.workspaceId});

  final String workspaceId;
}

class DeleteWorkspaceUseCase implements UseCase<void, DeleteWorkspaceParams> {
  const DeleteWorkspaceUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<void>> call(DeleteWorkspaceParams params) {
    return _repository.deleteWorkspace(workspaceId: params.workspaceId);
  }
}

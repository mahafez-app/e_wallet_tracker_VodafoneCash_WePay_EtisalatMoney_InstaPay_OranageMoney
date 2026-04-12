import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/workspace_repository.dart';

class UpdateWorkspaceNameParams {
  const UpdateWorkspaceNameParams({
    required this.workspaceId,
    required this.name,
  });

  final String workspaceId;
  final String name;
}

class UpdateWorkspaceNameUseCase
    implements UseCase<WorkspaceEntity, UpdateWorkspaceNameParams> {
  const UpdateWorkspaceNameUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<WorkspaceEntity>> call(UpdateWorkspaceNameParams params) {
    return _repository.updateWorkspaceName(
      workspaceId: params.workspaceId,
      name: params.name,
    );
  }
}

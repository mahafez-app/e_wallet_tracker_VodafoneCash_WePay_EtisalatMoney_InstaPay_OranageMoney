import '../../../../core/domain/entities/workspace_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
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

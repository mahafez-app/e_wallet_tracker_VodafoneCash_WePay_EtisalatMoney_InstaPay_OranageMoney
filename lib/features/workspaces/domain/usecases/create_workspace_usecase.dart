import '../../../../core/domain/entities/workspace_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspaceParams {
  const CreateWorkspaceParams({required this.name});

  final String name;
}

class CreateWorkspaceUseCase
    implements UseCase<WorkspaceEntity, CreateWorkspaceParams> {
  const CreateWorkspaceUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<WorkspaceEntity>> call(CreateWorkspaceParams params) {
    return _repository.createWorkspace(name: params.name);
  }
}

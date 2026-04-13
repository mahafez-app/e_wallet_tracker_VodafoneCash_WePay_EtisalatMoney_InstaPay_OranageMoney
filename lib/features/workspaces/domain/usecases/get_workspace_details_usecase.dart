import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workspace_details_entity.dart';
import '../repositories/workspace_repository.dart';

class GetWorkspaceDetailsParams {
  const GetWorkspaceDetailsParams({required this.workspaceId});

  final String workspaceId;
}

class GetWorkspaceDetailsUseCase
    implements UseCase<WorkspaceDetailsEntity, GetWorkspaceDetailsParams> {
  const GetWorkspaceDetailsUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<WorkspaceDetailsEntity>> call(
    GetWorkspaceDetailsParams params,
  ) {
    return _repository.getWorkspaceDetails(workspaceId: params.workspaceId);
  }
}

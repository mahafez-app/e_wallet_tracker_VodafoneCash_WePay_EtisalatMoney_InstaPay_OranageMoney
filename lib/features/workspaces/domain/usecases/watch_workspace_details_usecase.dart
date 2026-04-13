import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workspace_details_entity.dart';
import '../repositories/workspace_repository.dart';

class WatchWorkspaceDetailsParams {
  const WatchWorkspaceDetailsParams({required this.workspaceId});

  final String workspaceId;
}

class WatchWorkspaceDetailsUseCase
    implements
        StreamUseCase<WorkspaceDetailsEntity, WatchWorkspaceDetailsParams> {
  const WatchWorkspaceDetailsUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Stream<Result<WorkspaceDetailsEntity>> call(
    WatchWorkspaceDetailsParams params,
  ) {
    return _repository.watchWorkspaceDetails(workspaceId: params.workspaceId);
  }
}

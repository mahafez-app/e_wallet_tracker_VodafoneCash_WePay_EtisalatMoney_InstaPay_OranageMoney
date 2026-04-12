import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/workspace_repository.dart';

class RemoveWalletsFromWorkspaceParams {
  const RemoveWalletsFromWorkspaceParams({
    required this.workspaceId,
    required this.walletIds,
  });

  final String workspaceId;
  final List<String> walletIds;
}

class RemoveWalletsFromWorkspaceUseCase
    implements UseCase<int, RemoveWalletsFromWorkspaceParams> {
  const RemoveWalletsFromWorkspaceUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<int>> call(RemoveWalletsFromWorkspaceParams params) {
    return _repository.removeWalletsFromWorkspace(
      workspaceId: params.workspaceId,
      walletIds: params.walletIds,
    );
  }
}

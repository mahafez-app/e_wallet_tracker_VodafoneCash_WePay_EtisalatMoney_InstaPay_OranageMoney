import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/workspace_repository.dart';

class AddWalletsToWorkspaceParams {
  const AddWalletsToWorkspaceParams({
    required this.workspaceId,
    required this.walletIds,
  });

  final String workspaceId;
  final List<String> walletIds;
}

class AddWalletsToWorkspaceUseCase
    implements UseCase<int, AddWalletsToWorkspaceParams> {
  const AddWalletsToWorkspaceUseCase(this._repository);

  final WorkspaceRepository _repository;

  @override
  Future<Result<int>> call(AddWalletsToWorkspaceParams params) {
    return _repository.addWalletsToWorkspace(
      workspaceId: params.workspaceId,
      walletIds: params.walletIds,
    );
  }
}

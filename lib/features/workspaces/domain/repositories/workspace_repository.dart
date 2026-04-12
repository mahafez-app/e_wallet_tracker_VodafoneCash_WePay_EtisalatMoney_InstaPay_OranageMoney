import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/result.dart';
import '../entities/workspace_details_entity.dart';

abstract interface class WorkspaceRepository {
  Future<Result<WorkspaceEntity>> createWorkspace({required String name});

  Future<Result<WorkspaceEntity>> updateWorkspaceName({
    required String workspaceId,
    required String name,
  });

  Future<Result<int>> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  });

  Future<Result<void>> removeWorkspaceMember({
    required String workspaceId,
    required String memberUid,
  });

  Future<Result<void>> deleteWorkspace({required String workspaceId});

  Future<Result<WorkspaceDetailsEntity>> getWorkspaceDetails({
    required String workspaceId,
    int transactionsPreviewLimit = 5,
  });

  Stream<Result<WorkspaceDetailsEntity>> watchWorkspaceDetails({
    required String workspaceId,
    int transactionsPreviewLimit = 5,
  });
}

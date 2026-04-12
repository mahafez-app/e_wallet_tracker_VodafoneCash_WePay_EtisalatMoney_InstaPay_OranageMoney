import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/result.dart';

abstract interface class WorkspaceRepository {
  Future<Result<WorkspaceEntity>> createWorkspace({required String name});
}

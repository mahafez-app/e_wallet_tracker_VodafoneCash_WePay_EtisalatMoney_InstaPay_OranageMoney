import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/workspace_remote_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  const WorkspaceRepositoryImpl({required WorkspaceRemoteDataSource remote})
    : _remote = remote;

  final WorkspaceRemoteDataSource _remote;

  @override
  Future<Result<WorkspaceEntity>> createWorkspace({required String name}) {
    return executeAndHandleErrors(() async {
      final workspace = await _remote.createWorkspace(name: name);
      return workspace.toEntity();
    }, tag: 'WorkspaceRepositoryImpl.createWorkspace');
  }
}

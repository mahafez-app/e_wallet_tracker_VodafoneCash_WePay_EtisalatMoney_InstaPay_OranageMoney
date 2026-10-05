import 'dart:developer';
import 'package:rxdart/rxdart.dart';

import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/failure_mapper.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/workspace_details_entity.dart';
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

  @override
  Future<Result<WorkspaceEntity>> updateWorkspaceName({
    required String workspaceId,
    required String name,
  }) {
    return executeAndHandleErrors(() async {
      final workspace = await _remote.updateWorkspaceName(
        workspaceId: workspaceId,
        name: name,
      );
      return workspace.toEntity();
    }, tag: 'WorkspaceRepositoryImpl.updateWorkspaceName');
  }

  @override
  Future<Result<int>> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  }) {
    return executeAndHandleErrors(
      () => _remote.addWalletsToWorkspace(
        workspaceId: workspaceId,
        walletIds: walletIds,
      ),
      tag: 'WorkspaceRepositoryImpl.addWalletsToWorkspace',
    );
  }

  @override
  Future<Result<int>> removeWalletsFromWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  }) {
    return executeAndHandleErrors(
      () => _remote.removeWalletsFromWorkspace(
        workspaceId: workspaceId,
        walletIds: walletIds,
      ),
      tag: 'WorkspaceRepositoryImpl.removeWalletsFromWorkspace',
    );
  }

  @override
  Future<Result<void>> removeWorkspaceMember({
    required String workspaceId,
    required String memberUid,
  }) {
    return executeAndHandleErrors(
      () => _remote.removeWorkspaceMember(
        workspaceId: workspaceId,
        memberUid: memberUid,
      ),
      tag: 'WorkspaceRepositoryImpl.removeWorkspaceMember',
    );
  }

  @override
  Future<Result<void>> deleteWorkspace({required String workspaceId}) {
    return executeAndHandleErrors(
      () => _remote.deleteWorkspace(workspaceId: workspaceId),
      tag: 'WorkspaceRepositoryImpl.deleteWorkspace',
    );
  }

  @override
  Future<Result<WorkspaceDetailsEntity>> getWorkspaceDetails({
    required String workspaceId,
  }) {
    return executeAndHandleErrors(() async {
      final workspaceFuture = _remote.getWorkspace(workspaceId);
      final membersFuture = _remote.getWorkspaceMembers(workspaceId);
      final walletsFuture = _remote.getWorkspaceWallets(workspaceId);

      final workspace = await workspaceFuture;
      final members = await membersFuture;
      final wallets = await walletsFuture;

      return WorkspaceDetailsEntity(
        workspace: workspace.toEntity(),
        wallets: wallets.map((wallet) => wallet.toEntity()).toList(),
        members: members.map((member) => member.toEntity()).toList(),
      );
    }, tag: 'WorkspaceRepositoryImpl.getWorkspaceDetails');
  }

  @override
  Stream<Result<WorkspaceDetailsEntity>> watchWorkspaceDetails({
    required String workspaceId,
  }) {
    final stream = Rx.combineLatest3(
      _remote.watchWorkspace(workspaceId),
      _remote.watchWorkspaceMembers(workspaceId),
      _remote.watchWorkspaceWallets(workspaceId),
      (workspace, members, wallets) => (workspace, members, wallets),
    );

    return stream.map<Result<WorkspaceDetailsEntity>>((data) {
      final workspaceDto = data.$1;
      final membersDtos = data.$2;
      final walletDtos = data.$3;

      if (workspaceDto == null) {
        return const FailureResult(
          ServerFailure(code: '404', technicalMessage: 'Workspace not found.'),
        );
      }

      return Success(
        WorkspaceDetailsEntity(
          workspace: workspaceDto.toEntity(),
          wallets: walletDtos.map((wallet) => wallet.toEntity()).toList(),
          members: membersDtos.map((member) => member.toEntity()).toList(),
        ),
      );
    }).handleError((Object e, StackTrace st) {
      log(
        '[WorkspaceRepositoryImpl.watchWorkspaceDetails] Stream error ${e.runtimeType}: $e',
        stackTrace: st,
        name: 'Repository',
      );
      return FailureResult<WorkspaceDetailsEntity>(
        const FailureMapper().map(e),
      );
    });
  }
}

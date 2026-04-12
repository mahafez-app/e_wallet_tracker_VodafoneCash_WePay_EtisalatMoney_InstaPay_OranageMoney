import 'package:rxdart/rxdart.dart';

import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/result.dart';
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
    int transactionsPreviewLimit = 5,
  }) {
    return executeAndHandleErrors(() async {
      final workspaceFuture = _remote.getWorkspace(workspaceId);
      final membersFuture = _remote.getWorkspaceMembers(workspaceId);
      final walletsFuture = _remote.getWorkspaceWallets(workspaceId);

      final workspace = await workspaceFuture;
      final members = await membersFuture;
      final wallets = await walletsFuture;
      final recentTransactions = await _remote.getWorkspaceTransactionsPreview(
        walletIds: wallets.map((wallet) => wallet.id).toList(),
        limit: transactionsPreviewLimit,
      );

      return WorkspaceDetailsEntity(
        workspace: workspace.toEntity(),
        wallets: wallets.map((wallet) => wallet.toEntity()).toList(),
        members: members.map((member) => member.toEntity()).toList(),
        recentTransactions: recentTransactions
            .map((transaction) => transaction.toEntity())
            .toList(),
      );
    }, tag: 'WorkspaceRepositoryImpl.getWorkspaceDetails');
  }

  @override
  Stream<Result<WorkspaceDetailsEntity>> watchWorkspaceDetails({
    required String workspaceId,
    int transactionsPreviewLimit = 5,
  }) {
    return executeStreamAndHandleErrors(() {
      final membersStream = Stream.fromFuture(
        _remote.getWorkspaceMembers(workspaceId),
      );

      return Rx.combineLatest3(
        _remote.watchWorkspace(workspaceId),
        membersStream,
        _remote.watchWorkspaceWallets(workspaceId),
        (workspace, members, wallets) => (workspace, members, wallets),
      ).asyncMap((data) async {
        final workspace = data.$1;
        final members = data.$2;
        final wallets = data.$3;
        final recentTransactions = await _remote
            .getWorkspaceTransactionsPreview(
              walletIds: wallets.map((wallet) => wallet.id).toList(),
              limit: transactionsPreviewLimit,
            );

        return WorkspaceDetailsEntity(
          workspace: workspace.toEntity(),
          wallets: wallets.map((wallet) => wallet.toEntity()).toList(),
          members: members.map((member) => member.toEntity()).toList(),
          recentTransactions: recentTransactions
              .map((transaction) => transaction.toEntity())
              .toList(),
        );
      });
    }, tag: 'WorkspaceRepositoryImpl.watchWorkspaceDetails');
  }
}

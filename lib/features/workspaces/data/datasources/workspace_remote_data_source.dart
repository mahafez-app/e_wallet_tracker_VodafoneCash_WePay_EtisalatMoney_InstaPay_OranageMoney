import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/data/models/workspace_dto.dart';
import '../models/workspace_member_dto.dart';
import 'workspace_command_remote_service.dart';
import 'workspace_query_remote_service.dart';

abstract interface class WorkspaceRemoteDataSource {
  Future<WorkspaceDto> createWorkspace({required String name});

  Future<WorkspaceDto> updateWorkspaceName({
    required String workspaceId,
    required String name,
  });

  Future<int> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  });

  Future<int> removeWalletsFromWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  });

  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String memberUid,
  });

  Future<void> deleteWorkspace({required String workspaceId});

  Future<WorkspaceDto> getWorkspace(String workspaceId);

  Stream<WorkspaceDto> watchWorkspace(String workspaceId);

  Future<List<WorkspaceMemberDto>> getWorkspaceMembers(String workspaceId);

  Stream<List<WorkspaceMemberDto>> watchWorkspaceMembers(String workspaceId);

  Future<List<WalletDto>> getWorkspaceWallets(String workspaceId);

  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId);
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  factory WorkspaceRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) {
    final queryService = WorkspaceQueryRemoteService(firestore: firestore);
    return WorkspaceRemoteDataSourceImpl._(
      commandService: WorkspaceCommandRemoteService(
        firestore: firestore,
        auth: auth,
        queryService: queryService,
      ),
      queryService: queryService,
    );
  }

  const WorkspaceRemoteDataSourceImpl._({
    required WorkspaceCommandRemoteService commandService,
    required WorkspaceQueryRemoteService queryService,
  }) : _commandService = commandService,
       _queryService = queryService;

  final WorkspaceCommandRemoteService _commandService;
  final WorkspaceQueryRemoteService _queryService;

  @override
  Future<WorkspaceDto> createWorkspace({required String name}) {
    return _commandService.createWorkspace(name: name);
  }

  @override
  Future<WorkspaceDto> updateWorkspaceName({
    required String workspaceId,
    required String name,
  }) {
    return _commandService.updateWorkspaceName(
      workspaceId: workspaceId,
      name: name,
    );
  }

  @override
  Future<int> addWalletsToWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  }) {
    return _commandService.addWalletsToWorkspace(
      workspaceId: workspaceId,
      walletIds: walletIds,
    );
  }

  @override
  Future<int> removeWalletsFromWorkspace({
    required String workspaceId,
    required List<String> walletIds,
  }) {
    return _commandService.removeWalletsFromWorkspace(
      workspaceId: workspaceId,
      walletIds: walletIds,
    );
  }

  @override
  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String memberUid,
  }) {
    return _commandService.removeWorkspaceMember(
      workspaceId: workspaceId,
      memberUid: memberUid,
    );
  }

  @override
  Future<void> deleteWorkspace({required String workspaceId}) {
    return _commandService.deleteWorkspace(workspaceId: workspaceId);
  }

  @override
  Future<WorkspaceDto> getWorkspace(String workspaceId) {
    return _queryService.getWorkspace(workspaceId);
  }

  @override
  Stream<WorkspaceDto> watchWorkspace(String workspaceId) {
    return _queryService.watchWorkspace(workspaceId);
  }

  @override
  Future<List<WorkspaceMemberDto>> getWorkspaceMembers(String workspaceId) {
    return _queryService.getWorkspaceMembers(workspaceId);
  }

  @override
  Stream<List<WorkspaceMemberDto>> watchWorkspaceMembers(String workspaceId) {
    return _queryService.watchWorkspaceMembers(workspaceId);
  }

  @override
  Future<List<WalletDto>> getWorkspaceWallets(String workspaceId) {
    return _queryService.getWorkspaceWallets(workspaceId);
  }

  @override
  Stream<List<WalletDto>> watchWorkspaceWallets(String workspaceId) {
    return _queryService.watchWorkspaceWallets(workspaceId);
  }
}

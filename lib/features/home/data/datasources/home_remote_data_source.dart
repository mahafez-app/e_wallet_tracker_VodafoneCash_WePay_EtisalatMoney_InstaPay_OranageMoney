import 'package:wallet_product/wallet_product.dart';
import 'package:workspace_product/workspace_product.dart';

abstract interface class HomeRemoteDataSource {
  Stream<List<WalletEntity>> watchUserWallets();
  Stream<List<WorkspaceEntity>> watchUserWorkspaces();
  Stream<int> watchPendingInvitationsCount();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({
    required this._walletQueries,
    required this._workspaceSummaries,
    required this._pendingInvitationsCount,
  });

  final WalletQueries _walletQueries;
  final Stream<List<WorkspaceEntity>> Function() _workspaceSummaries;
  final Stream<int> Function() _pendingInvitationsCount;

  @override
  Stream<List<WalletEntity>> watchUserWallets() => _walletQueries.watchMine();

  @override
  Stream<List<WorkspaceEntity>> watchUserWorkspaces() => _workspaceSummaries();

  @override
  Stream<int> watchPendingInvitationsCount() => _pendingInvitationsCount();
}

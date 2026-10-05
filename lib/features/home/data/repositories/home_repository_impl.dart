import 'package:rxdart/rxdart.dart';

import 'package:wallet_product/wallet_product.dart';

import '../../../../core/data/models/workspace_dto.dart';
import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/failure_mapper.dart';

import 'package:mahafez_core/mahafez_core.dart';

import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required this._remote,
    FailureMapper failureMapper = const FailureMapper(),
  }) : _mapper = failureMapper;

  final HomeRemoteDataSource _remote;
  final FailureMapper _mapper;

  @override
  Stream<Result<HomeDashboardEntity>> watchHomeDashboard() {
    return executeStreamAndHandleErrors(
      () =>
          Rx.combineLatest3<
            List<WalletEntity>,
            List<WorkspaceEntity>,
            int,
            HomeDashboardEntity
          >(
            _remote.watchUserWallets(),
            _watchWorkspaceSummaries(),
            _remote.watchPendingInvitationsCount(),
            (wallets, workspaces, invitesCount) {
              final walletEntities = wallets;

              final totalBalance = walletEntities.fold<double>(
                0.0,
                (sum, wallet) => sum + wallet.currentBalance,
              );

              final totalReceived = walletEntities.fold<double>(
                0.0,
                (sum, wallet) => sum + wallet.totalReceived,
              );

              final totalSent = walletEntities.fold<double>(
                0.0,
                (sum, wallet) => sum + wallet.totalSent,
              );

              return HomeDashboardEntity(
                totalBalance: totalBalance,
                totalReceived: totalReceived,
                totalSent: totalSent,
                wallets: walletEntities,
                workspaces: workspaces,
                invitationsCount: invitesCount,
              );
            },
          ),
      tag: 'HomeRepository.watchHomeDashboard',
      mapper: _mapper,
    );
  }

  Stream<List<WorkspaceEntity>> _watchWorkspaceSummaries() {
    return _remote.watchUserWorkspaces().switchMap((workspaces) {
      if (workspaces.isEmpty) {
        return Stream.value(const <WorkspaceEntity>[]);
      }

      final workspaceStreams = workspaces.map(
        (workspace) => _remote
            .watchWorkspaceWallets(workspace.id)
            .map(
              (wallets) => _buildWorkspaceSummary(
                workspace: workspace,
                wallets: wallets,
              ),
            ),
      );

      return Rx.combineLatestList(workspaceStreams);
    });
  }

  WorkspaceEntity _buildWorkspaceSummary({
    required WorkspaceDto workspace,
    required List<WalletEntity> wallets,
  }) {
    final totalReceived = wallets.fold<double>(
      0.0,
      (sum, wallet) => sum + wallet.totalReceived,
    );
    final totalSent = wallets.fold<double>(
      0.0,
      (sum, wallet) => sum + wallet.totalSent,
    );
    final latestActivityAt = wallets.fold<DateTime?>(
      workspace.latestActivityAt,
      (latest, wallet) {
        if (latest == null || wallet.lastBalanceAt.isAfter(latest)) {
          return wallet.lastBalanceAt;
        }

        return latest;
      },
    );

    return workspace.toEntity().copyWith(
      walletsCount: wallets.length,
      totalReceived: totalReceived,
      totalSent: totalSent,
      latestActivityAt: latestActivityAt,
    );
  }
}

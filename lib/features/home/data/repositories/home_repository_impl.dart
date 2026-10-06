import 'package:rxdart/rxdart.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:workspace_product/workspace_product.dart';

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
            _remote.watchUserWorkspaces(),
            _remote.watchPendingInvitationsCount(),
            (wallets, workspaces, invitesCount) {
              final totalBalance = wallets.fold<double>(
                0,
                (sum, wallet) => sum + wallet.currentBalance,
              );
              final totalReceived = wallets.fold<double>(
                0,
                (sum, wallet) => sum + wallet.totalReceived,
              );
              final totalSent = wallets.fold<double>(
                0,
                (sum, wallet) => sum + wallet.totalSent,
              );
              return HomeDashboardEntity(
                totalBalance: totalBalance,
                totalReceived: totalReceived,
                totalSent: totalSent,
                wallets: wallets,
                workspaces: workspaces,
                invitationsCount: invitesCount,
              );
            },
          ),
      tag: 'HomeRepository.watchHomeDashboard',
      mapper: _mapper,
    );
  }
}

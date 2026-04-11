import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required HomeRemoteDataSource remote,
    FailureMapper failureMapper = const FailureMapper(),
  }) : _remote = remote,
       _mapper = failureMapper;

  final HomeRemoteDataSource _remote;
  final FailureMapper _mapper;

  @override
  Stream<Result<HomeDashboardEntity>> watchHomeDashboard() {
    return executeStreamAndHandleErrors(
      () => Rx.combineLatest3(
        _remote.watchUserWallets(),
        _remote.watchUserWorkspaces(),
        _remote.watchPendingInvitationsCount(),
        (wallets, workspaces, invitesCount) {
          final walletEntities = wallets.map((w) => w.toEntity()).toList();
          final workspaceEntities = workspaces
              .map((w) => w.toEntity())
              .toList();

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
            workspaces: workspaceEntities,
            invitationsCount: invitesCount,
          );
        },
      ),
      tag: 'HomeRepository.watchHomeDashboard',
      mapper: _mapper,
    );
  }
}

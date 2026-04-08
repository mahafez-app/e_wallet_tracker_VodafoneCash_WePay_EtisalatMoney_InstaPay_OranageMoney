import 'package:equatable/equatable.dart';

import 'package:wallet_tracker/core/domain/entities/wallet_entity.dart';
import '../../../../core/domain/entities/workspace_entity.dart';

final class HomeDashboardEntity extends Equatable {
  const HomeDashboardEntity({
    required this.totalBalance,
    required this.totalReceived,
    required this.totalSent,
    required this.wallets,
    required this.workspaces,
    required this.invitationsCount,
  });

  final double totalBalance;
  final double totalReceived;
  final double totalSent;
  final List<WalletEntity> wallets;
  final List<WorkspaceEntity> workspaces;
  final int invitationsCount;

  @override
  List<Object?> get props => [
    totalBalance,
    totalReceived,
    totalSent,
    wallets,
    workspaces,
    invitationsCount,
  ];
}

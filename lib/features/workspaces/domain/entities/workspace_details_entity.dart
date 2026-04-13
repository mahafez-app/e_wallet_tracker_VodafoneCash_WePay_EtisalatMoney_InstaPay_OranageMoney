import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/domain/entities/workspace_entity.dart';
import 'workspace_member_entity.dart';

class WorkspaceDetailsEntity extends Equatable {
  const WorkspaceDetailsEntity({
    required this.workspace,
    required this.wallets,
    required this.members,
  });

  final WorkspaceEntity workspace;
  final List<WalletEntity> wallets;
  final List<WorkspaceMemberEntity> members;

  double get totalBalance =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.currentBalance);

  double get totalReceived =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.totalReceived);

  double get totalSent =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.totalSent);

  DateTime? get latestActivityAt =>
      wallets.fold<DateTime?>(workspace.latestActivityAt, (latest, wallet) {
        if (latest == null || wallet.lastBalanceAt.isAfter(latest)) {
          return wallet.lastBalanceAt;
        }

        return latest;
      });

  WorkspaceDetailsEntity copyWith({
    WorkspaceEntity? workspace,
    List<WalletEntity>? wallets,
    List<WorkspaceMemberEntity>? members,
  }) {
    return WorkspaceDetailsEntity(
      workspace: workspace ?? this.workspace,
      wallets: wallets ?? this.wallets,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props => [workspace, wallets, members];
}

import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/domain/entities/workspace_entity.dart';
import 'workspace_member_entity.dart';

class WorkspaceDetailsEntity extends Equatable {
  const WorkspaceDetailsEntity({
    required this.workspace,
    required this.wallets,
    required this.members,
    required this.recentTransactions,
  });

  final WorkspaceEntity workspace;
  final List<WalletEntity> wallets;
  final List<WorkspaceMemberEntity> members;
  final List<TransactionEntity> recentTransactions;

  double get totalBalance =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.currentBalance);

  double get totalReceived =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.totalReceived);

  double get totalSent =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.totalSent);

  DateTime? get latestActivityAt {
    if (recentTransactions.isNotEmpty) {
      return recentTransactions.first.createdAt;
    }

    return workspace.latestActivityAt;
  }

  @override
  List<Object?> get props => [workspace, wallets, members, recentTransactions];
}

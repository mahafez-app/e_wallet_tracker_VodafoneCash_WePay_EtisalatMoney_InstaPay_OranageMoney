import 'package:equatable/equatable.dart';

import '../../../../core/domain/enums/wallet_provider.dart';

class WorkspaceActiveWalletEntity extends Equatable {
  const WorkspaceActiveWalletEntity({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
    required this.lastActivityAt,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;
  final DateTime lastActivityAt;

  @override
  List<Object?> get props => [walletId, provider, phoneNumber, lastActivityAt];
}

class WorkspaceTransactionsOverviewEntity extends Equatable {
  const WorkspaceTransactionsOverviewEntity({
    required this.todayCollected,
    required this.todaySent,
    required this.unpaidCount,
    required this.latestActiveWallets,
  });

  final double todayCollected;
  final double todaySent;
  final int unpaidCount;
  final List<WorkspaceActiveWalletEntity> latestActiveWallets;

  @override
  List<Object?> get props => [
    todayCollected,
    todaySent,
    unpaidCount,
    latestActiveWallets,
  ];
}

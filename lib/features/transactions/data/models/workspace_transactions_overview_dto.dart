import '../../domain/entities/workspace_transactions_overview_entity.dart';

final class WorkspaceActiveWalletDto extends WorkspaceActiveWalletEntity {
  const WorkspaceActiveWalletDto({
    required super.walletId,
    required super.provider,
    required super.phoneNumber,
    required super.lastActivityAt,
  });

  WorkspaceActiveWalletEntity toEntity() => WorkspaceActiveWalletEntity(
    walletId: walletId,
    provider: provider,
    phoneNumber: phoneNumber,
    lastActivityAt: lastActivityAt,
  );
}

final class WorkspaceTransactionsOverviewDto
    extends WorkspaceTransactionsOverviewEntity {
  const WorkspaceTransactionsOverviewDto({
    required super.todayCollected,
    required super.todaySent,
    required super.unpaidCount,
    required super.latestActiveWallets,
  });

  WorkspaceTransactionsOverviewEntity toEntity() =>
      WorkspaceTransactionsOverviewEntity(
        todayCollected: todayCollected,
        todaySent: todaySent,
        unpaidCount: unpaidCount,
        latestActiveWallets: latestActiveWallets
            .map(
              (wallet) => (wallet as WorkspaceActiveWalletDto).toEntity(),
            )
            .toList(),
      );
}

import 'package:equatable/equatable.dart';

/// Lightweight wallet metadata used to build workspace filter chips.
final class WalletFilterOption extends Equatable {
  const WalletFilterOption({required this.walletId, required this.walletLabel});

  final String walletId;
  final String walletLabel;

  @override
  List<Object?> get props => [walletId, walletLabel];
}

/// Route payload that drives the transactions screen source and available filters.
sealed class TransactionsRouteData extends Equatable {
  const TransactionsRouteData();
}

final class WalletTransactionsRouteData extends TransactionsRouteData {
  const WalletTransactionsRouteData({
    required this.walletId,
    required this.walletLabel,
  });

  final String walletId;
  final String walletLabel;

  @override
  List<Object?> get props => [walletId, walletLabel];
}

final class WorkspaceTransactionsRouteData extends TransactionsRouteData {
  const WorkspaceTransactionsRouteData({
    required this.workspaceId,
    required this.workspaceName,
    required this.wallets,
  });

  final String workspaceId;
  final String workspaceName;
  final List<WalletFilterOption> wallets;

  @override
  List<Object?> get props => [workspaceId, workspaceName, wallets];
}

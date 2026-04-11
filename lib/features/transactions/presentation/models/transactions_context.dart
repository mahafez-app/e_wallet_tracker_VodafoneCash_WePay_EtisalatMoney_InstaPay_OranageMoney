import 'package:equatable/equatable.dart';

/// UI navigation context for the transactions feature.
final class WalletRef extends Equatable {
  const WalletRef({required this.walletId, required this.walletLabel});

  final String walletId;
  final String walletLabel;

  @override
  List<Object?> get props => [walletId, walletLabel];
}

/// Drives the transactions screen title, source, and available filters.
sealed class TransactionsContext extends Equatable {
  const TransactionsContext();
}

final class WalletTransactionsContext extends TransactionsContext {
  const WalletTransactionsContext({
    required this.walletId,
    required this.walletLabel,
  });

  final String walletId;
  final String walletLabel;

  @override
  List<Object?> get props => [walletId, walletLabel];
}

final class WorkspaceTransactionsContext extends TransactionsContext {
  const WorkspaceTransactionsContext({
    required this.workspaceId,
    required this.workspaceName,
    required this.wallets,
  });

  final String workspaceId;
  final String workspaceName;
  final List<WalletRef> wallets;

  @override
  List<Object?> get props => [workspaceId, workspaceName, wallets];
}

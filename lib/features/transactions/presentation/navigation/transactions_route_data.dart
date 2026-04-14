import 'package:equatable/equatable.dart';
import '../../../../core/domain/enums/wallet_provider.dart';

/// Lightweight wallet metadata used to build workspace filter chips.
final class WalletFilterOption extends Equatable {
  const WalletFilterOption({
    required this.walletId,
    required this.walletLabel,
    required this.ownerUid,
    required this.ownerName,
  });

  final String walletId;
  final String walletLabel;
  final String ownerUid;
  final String ownerName;

  @override
  List<Object?> get props => [walletId, walletLabel, ownerUid, ownerName];
}

/// Route payload that drives the transactions screen source and available filters.
sealed class TransactionsRouteData extends Equatable {
  const TransactionsRouteData();
}

final class WalletTransactionsRouteData extends TransactionsRouteData {
  const WalletTransactionsRouteData({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;

  @override
  List<Object?> get props => [walletId, provider, phoneNumber];
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

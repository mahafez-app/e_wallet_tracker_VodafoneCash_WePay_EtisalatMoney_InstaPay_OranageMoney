import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/balance_card.dart';

class HomeGlobalStatsWidget extends StatelessWidget {
  const HomeGlobalStatsWidget({
    super.key,
    required this.totalBalance,
    required this.totalSent,
    required this.totalReceived,
    required this.walletCount,
  });

  final double totalBalance;
  final double totalSent;
  final double totalReceived;
  final int walletCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return BalanceCard(
      balance: totalBalance,
      sentAmount: totalSent,
      receivedAmount: totalReceived,
      label: l10n.totalBalance,
      icon: Icons.account_balance_wallet_outlined,
      subtitle: Text(
        l10n.activeWalletsHint(walletCount),
        style: theme.textTheme.labelMedium?.copyWith(
          color: colors.statsOnGradient.withAlpha(204), // 0.8
        ),
      ),
    );
  }
}

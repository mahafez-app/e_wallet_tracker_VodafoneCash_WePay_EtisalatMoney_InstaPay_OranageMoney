import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/widgets/balance_card.dart';
import '../../../../generated/l10n.dart';

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
    final s = S.of(context);
    final colors = context.appColors;
    final theme = Theme.of(context);

    return BalanceCard(
      balance: totalBalance,
      sentAmount: totalSent,
      receivedAmount: totalReceived,
      label: s.totalBalance,
      icon: Icons.account_balance_wallet_outlined,
      subtitle: Text(
        s.activeWalletsHint(walletCount),
        style: theme.textTheme.labelMedium?.copyWith(
          color: colors.statsOnGradient.withAlpha(204), // 0.8
        ),
      ),
    );
  }
}

// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/balance_card.dart';
import '../../../domain/entities/workspace_details_entity.dart';

class WorkspaceSummaryCard extends StatelessWidget {
  const WorkspaceSummaryCard({super.key, required this.details});

  final WorkspaceDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final latestActivityText =
        details.latestActivityAt?.toTimeAgo(context) ?? l10n.justNow;

    return BalanceCard(
      balance: details.totalBalance,
      sentAmount: details.totalSent,
      receivedAmount: details.totalReceived,
      label: l10n.totalBalance,
      icon: Icons.storefront_outlined,
      subtitle: Wrap(
        spacing: 8.responsiveWidth,
        runSpacing: 8.responsiveHeight,
        children: [
          _SummaryChip(
            icon: Icons.account_balance_wallet_outlined,
            label: l10n.workspaceWalletsCount(details.wallets.length),
          ),
          _SummaryChip(
            icon: Icons.group_outlined,
            label: l10n.workspaceMembersCount(details.members.length),
          ),
          _SummaryChip(
            icon: Icons.schedule_rounded,
            label: '${l10n.lastActivity}: $latestActivityText',
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: AppResponsive.symmetricPadding(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.statsOnGradient.withAlpha(25),
        borderRadius: BorderRadius.circular(999.responsiveRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.responsiveRadius, color: colors.statsOnGradient),
          SizedBox(width: 6.responsiveWidth),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.statsOnGradient,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

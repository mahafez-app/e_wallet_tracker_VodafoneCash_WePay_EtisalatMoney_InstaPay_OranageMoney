import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/amount_extension.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../domain/entities/workspace_transactions_overview_entity.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/workspace_transactions_overview_provider.dart';

class WorkspaceTransactionsOverviewSection extends ConsumerWidget {
  const WorkspaceTransactionsOverviewSection({
    super.key,
    required this.routeData,
  });

  final WorkspaceTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(
      workspaceTransactionsOverviewProvider(routeData),
    );

    return overviewState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Padding(
        padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.lg),
        child: AppErrorView(error: error),
      ),
      data: (overview) => Padding(
        padding: AppResponsive.onlyPadding(
          start: AppSpacing.lg,
          top: AppSpacing.sm,
          end: AppSpacing.lg,
          bottom: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.md.responsiveWidth,
              runSpacing: AppSpacing.md.responsiveHeight,
              children: [
                _MetricCard(
                  title: context.l10n.workspaceTransactionsTodayCollected,
                  value: overview.todayCollected.toCurrencyText(context),
                  icon: Icons.arrow_downward_rounded,
                ),
                _MetricCard(
                  title: context.l10n.workspaceTransactionsTodaySent,
                  value: overview.todaySent.toCurrencyText(context),
                  icon: Icons.arrow_upward_rounded,
                ),
                _MetricCard(
                  title: context.l10n.workspaceTransactionsUnpaidCount,
                  value: overview.unpaidCount.toString(),
                  icon: Icons.radio_button_unchecked_rounded,
                ),
              ],
            ),
            AppSpacing.md.verticalSpace,
            _LatestWalletsCard(overview: overview),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return SizedBox(
      width: 160.responsiveWidth,
      child: Container(
        padding: AppResponsive.allPadding(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            AppSpacing.sm.verticalSpace,
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestWalletsCard extends StatelessWidget {
  const _LatestWalletsCard({required this.overview});

  final WorkspaceTransactionsOverviewEntity overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallets = overview.latestActiveWallets;

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
        border: Border.all(color: context.appColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.workspaceTransactionsLatestWallets,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.sm.verticalSpace,
          if (wallets.isEmpty)
            Text(
              context.l10n.workspaceTransactionsLatestWalletsEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...wallets.map<Widget>(
              (wallet) => Padding(
                padding: AppResponsive.onlyPadding(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${wallet.provider.displayName(context)} · ${wallet.phoneNumber.formattedEgyptianPhoneNumber}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      wallet.lastActivityAt.toTimeAgo(context),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

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
import '../../../../../core/widgets/wallets/wallet_provider_icon.dart';
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
      data: (overview) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.lg),
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _MetricCard(
                  title: context.l10n.workspaceTransactionsTodayCollected,
                  value: overview.todayCollected.toCurrencyText(context),
                  icon: Icons.add_chart_rounded,
                  type: _MetricCardType.collected,
                ),
                AppSpacing.md.horizontalSpace,
                _MetricCard(
                  title: context.l10n.workspaceTransactionsTodaySent,
                  value: overview.todaySent.toCurrencyText(context),
                  icon: Icons.analytics_rounded,
                  type: _MetricCardType.sent,
                ),
                AppSpacing.md.horizontalSpace,
                _MetricCard(
                  title: context.l10n.workspaceTransactionsUnpaidCount,
                  value: overview.unpaidCount.toString(),
                  icon: Icons.pending_actions_rounded,
                  type: _MetricCardType.unpaid,
                ),
              ],
            ),
          ),
          AppSpacing.lg.verticalSpace,
          Padding(
            padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.lg),
            child: _LatestWalletsCard(overview: overview),
          ),
        ],
      ),
    );
  }
}

enum _MetricCardType { collected, sent, unpaid }

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.type,
  });

  final String title;
  final String value;
  final IconData icon;
  final _MetricCardType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    final (baseColor, gradientData) = switch (type) {
      _MetricCardType.collected => (
        colors.success,
        (colors.success.withAlpha(20), colors.success.withAlpha(5))
      ),
      _MetricCardType.sent => (
        colors.danger,
        (colors.danger.withAlpha(20), colors.danger.withAlpha(5))
      ),
      _MetricCardType.unpaid => (
        theme.colorScheme.primary,
        (
          theme.colorScheme.primary.withAlpha(20),
          theme.colorScheme.primary.withAlpha(5)
        )
      ),
    };

    return Container(
      width: 156.responsiveWidth,
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.cardBackground,
            gradientData.$1.withAlpha(5),
          ],
        ),
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: baseColor.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20.responsiveRadius,
            right: -20.responsiveRadius,
            child: Icon(
              icon,
              size: 80.responsiveRadius,
              color: baseColor.withAlpha(10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: AppResponsive.allPadding(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: baseColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12.responsiveRadius),
                ),
                child: Icon(icon, color: baseColor, size: 20.responsiveRadius),
              ),
              AppSpacing.md.verticalSpace,
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.xs.verticalSpace,
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 20.responsiveFont,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
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
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        border: Border.all(color: context.appColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppResponsive.allPadding(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: AppResponsive.allPadding(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: theme.colorScheme.primary,
                    size: 18.responsiveRadius,
                  ),
                ),
                AppSpacing.md.horizontalSpace,
                Text(
                  context.l10n.workspaceTransactionsLatestWallets,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (wallets.isEmpty)
            Padding(
              padding: AppResponsive.allPadding(AppSpacing.xl),
              child: Center(
                child: Text(
                  context.l10n.workspaceTransactionsLatestWalletsEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: AppResponsive.allPadding(AppSpacing.sm),
              itemCount: wallets.length,
              separatorBuilder: (_, _) => AppSpacing.xs.verticalSpace,
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                return Container(
                  padding: AppResponsive.allPadding(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withAlpha(50),
                    borderRadius: BorderRadius.circular(18.responsiveRadius),
                  ),
                  child: Row(
                    children: [
                      WalletProviderIcon(
                        provider: wallet.provider,
                        size: 25.responsiveRadius,
                      ),
                      AppSpacing.md.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallet.provider.displayName(context),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              wallet.phoneNumber.formattedEgyptianPhoneNumber,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            wallet.lastActivityAt.toTimeAgo(context),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppSpacing.xs.verticalSpace,
                          Container(
                            width: 6.responsiveRadius,
                            height: 6.responsiveRadius,
                            decoration: BoxDecoration(
                              color: context.appColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

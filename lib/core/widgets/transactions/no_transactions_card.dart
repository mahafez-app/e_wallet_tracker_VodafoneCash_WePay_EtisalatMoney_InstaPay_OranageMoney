import 'package:flutter/material.dart';

import '../../theme/app_color_extension.dart';
import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/theme/app_spacing.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

enum NoTransactionsCardVariant { preview, fullScreen }

class NoTransactionsCard extends StatelessWidget {
  const NoTransactionsCard({
    super.key,
    required this.title,
    required this.description,
    this.variant = NoTransactionsCardVariant.preview,
    this.footer,
  });

  final String title;
  final String description;
  final NoTransactionsCardVariant variant;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final isFullScreen = variant == NoTransactionsCardVariant.fullScreen;
    final iconSize = isFullScreen ? AppSpacing.xxxl : AppSpacing.xxl;
    final iconPadding = isFullScreen ? AppSpacing.xl : AppSpacing.lg;
    final titleStyle = isFullScreen
        ? theme.textTheme.headlineSmall
        : theme.textTheme.titleLarge;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.xxl.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: AppSpacing.lg.responsiveRadius,
            offset: Offset(0, AppSpacing.xs.responsiveHeight),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: AppResponsive.allPadding(iconPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surface,
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              borderRadius: BorderRadius.circular(
                (AppSpacing.xxl + AppSpacing.xs).responsiveRadius,
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: iconSize.responsiveRadius,
              color: theme.colorScheme.primary,
            ),
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle?.copyWith(fontWeight: FontWeight.w800),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (footer != null) ...[AppSpacing.xl.verticalSpace, footer!],
        ],
      ),
    );
  }
}

class TransactionsEmptyHintCard extends StatelessWidget {
  const TransactionsEmptyHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.infoContainer, theme.colorScheme.surface],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.xxl.responsiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: theme.colorScheme.onPrimary,
              size: 20.responsiveRadius,
            ),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.transactions_emptyHintTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.xs.verticalSpace,
                Text(
                  context.l10n.transactions_emptyHintDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

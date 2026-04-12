import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';

class InvitationsOverviewCard extends StatelessWidget {
  const InvitationsOverviewCard({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppResponsive.symmetricPadding(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.infoContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(999.responsiveRadius),
            ),
            child: Text(
              context.l10n.invitationsPendingStatus,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.info,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            context.l10n.invitationsPendingCount(count),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            context.l10n.invitationsListDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class InvitationsInfoCard extends StatelessWidget {
  const InvitationsInfoCard({super.key});

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
        borderRadius: BorderRadius.circular(28.responsiveRadius),
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
                  context.l10n.invitationsHowItWorksTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.xs.verticalSpace,
                Text(
                  context.l10n.invitationsHowItWorksDescription,
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

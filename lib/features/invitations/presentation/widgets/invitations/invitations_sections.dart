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
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(50),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: AppResponsive.symmetricPadding(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.info.withAlpha(30),
                  borderRadius: BorderRadius.circular(10.responsiveRadius),
                ),
                child: Text(
                  context.l10n.invitationsPendingStatus.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.info,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Icon(
                Icons.mark_email_unread_rounded,
                color: colors.info,
                size: 20.responsiveRadius,
              ),
            ],
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            context.l10n.invitationsPendingCount(count),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            context.l10n.invitationsListDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
              fontWeight: FontWeight.w500,
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
          colors: [
            colors.info.withAlpha(40),
            theme.colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        border: Border.all(
          color: colors.info.withAlpha(20),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.info, colors.info.withAlpha(150)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors.info.withAlpha(30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                AppSpacing.xxs.verticalSpace,
                Text(
                  context.l10n.invitationsHowItWorksDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                    height: 1.4,
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

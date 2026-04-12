import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import 'invitations_sections.dart';

class InvitationsEmptyContent extends StatelessWidget {
  const InvitationsEmptyContent({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.xxxl.verticalSpace,
        const _InvitationsEmptyState(),
        AppSpacing.xl.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: context.l10n.invitationsRefreshAction,
            trailingIcon: Icon(
              Icons.refresh_rounded,
              size: 18.responsiveRadius,
            ),
            onPressed: () => onRefresh(),
          ),
        ),
        AppSpacing.xl.verticalSpace,
        const InvitationsInfoCard(),
      ],
    );
  }
}

class _InvitationsEmptyState extends StatelessWidget {
  const _InvitationsEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32.responsiveRadius),
      ),
      child: Column(
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.xl),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28.responsiveRadius),
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              color: theme.colorScheme.primary,
              size: 52.responsiveRadius,
            ),
          ),
          AppSpacing.xl.verticalSpace,
          Text(
            context.l10n.invitationsEmptyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            context.l10n.invitationsEmptyDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/extensions/localization_extension.dart';
import 'invitations_sections.dart';

class InvitationsEmptyContent extends StatelessWidget {
  const InvitationsEmptyContent({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MahafezSpacing.xxxl.verticalSpace,
        const _InvitationsEmptyState(),
        MahafezSpacing.xl.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: MahafezButton(
            label: context.l10n.invitationsRefreshAction,
            trailingIcon: Icon(
              Icons.refresh_rounded,
              size: 18.responsiveRadius,
            ),
            onPressed: () => onRefresh(),
          ),
        ),
        MahafezSpacing.xl.verticalSpace,
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
      padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32.responsiveRadius),
      ),
      child: Column(
        children: [
          Container(
            padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
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
          MahafezSpacing.xl.verticalSpace,
          Text(
            context.l10n.invitationsEmptyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          MahafezSpacing.sm.verticalSpace,
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

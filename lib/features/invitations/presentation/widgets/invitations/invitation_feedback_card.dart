import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../providers/invitation_display_provider.dart';
import '../../providers/invitations_state.dart';

class InvitationFeedbackCard extends ConsumerWidget {
  const InvitationFeedbackCard({super.key, required this.feedback});

  final InvitationActionFeedback feedback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(invitationDisplayProvider(feedback.invitation));
    final resolvedWorkspaceName = display.asData?.value.workspaceName;
    final workspaceName = resolvedWorkspaceName?.trim().isNotEmpty == true
        ? resolvedWorkspaceName!
        : context.l10n.invitationsDeletedWorkspaceFallback;
    final style = _resolveStyle(context: context, workspaceName: workspaceName);

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(20.responsiveRadius),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4.responsiveWidth,
              decoration: BoxDecoration(
                color: style.accentColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20.responsiveRadius),
                  bottomStart: Radius.circular(20.responsiveRadius),
                ),
              ),
            ),
          ),
          Padding(
            padding: MahafezResponsive.onlyPadding(start: MahafezSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.responsiveWidth,
                  height: 44.responsiveWidth,
                  decoration: BoxDecoration(
                    color: style.iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    style.icon,
                    color: style.iconColor,
                    size: 22.responsiveRadius,
                  ),
                ),
                MahafezSpacing.md.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      MahafezSpacing.xs.verticalSpace,
                      Text(
                        style.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _InvitationFeedbackStyle _resolveStyle({
    required BuildContext context,
    required String workspaceName,
  }) {
    final colors = context.mahafezColors;
    final colorScheme = Theme.of(context).colorScheme;

    return switch (feedback.action) {
      InvitationActionType.accept => _InvitationFeedbackStyle(
        title: context.l10n.invitationAcceptSuccess(workspaceName),
        subtitle: context.l10n.invitationAcceptDetails,
        backgroundColor: colors.cardBackground,
        accentColor: colors.success,
        iconBackgroundColor: colors.successContainer,
        iconColor: colors.success,
        icon: Icons.check_circle_rounded,
      ),
      InvitationActionType.decline => _InvitationFeedbackStyle(
        title: context.l10n.invitationDeclineSuccess(workspaceName),
        subtitle: workspaceName,
        backgroundColor: colorScheme.surfaceContainerLow,
        accentColor: colorScheme.outline,
        iconBackgroundColor: colorScheme.surfaceContainerHigh,
        iconColor: colorScheme.onSurfaceVariant,
        icon: Icons.cancel_rounded,
      ),
    };
  }
}

final class _InvitationFeedbackStyle {
  const _InvitationFeedbackStyle({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.accentColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color accentColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData icon;
}

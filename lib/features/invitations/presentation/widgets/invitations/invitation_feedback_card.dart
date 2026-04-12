import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../providers/invitation_display_provider.dart';
import '../../providers/invitations_state.dart';

class InvitationFeedbackCard extends ConsumerWidget {
  const InvitationFeedbackCard({super.key, required this.feedback});

  final InvitationActionFeedback feedback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final display = ref.watch(invitationDisplayProvider(feedback.invitation));
    final resolvedWorkspaceName = display.asData?.value.workspaceName;
    final workspaceName = resolvedWorkspaceName?.trim().isNotEmpty == true
        ? resolvedWorkspaceName!
        : context.l10n.invitationsDeletedWorkspaceFallback;

    final title = switch (feedback.action) {
      InvitationActionType.accept => context.l10n.invitationAcceptSuccess(
        workspaceName,
      ),
      InvitationActionType.decline => context.l10n.invitationDeclineSuccess(
        workspaceName,
      ),
    };
    final subtitle = switch (feedback.action) {
      InvitationActionType.accept => context.l10n.invitationAcceptDetails,
      InvitationActionType.decline => workspaceName,
    };
    final accentColor = feedback.action == InvitationActionType.accept
        ? colors.success
        : theme.colorScheme.outline;
    final iconBackground = feedback.action == InvitationActionType.accept
        ? colors.successContainer
        : theme.colorScheme.surfaceContainerHigh;
    final iconColor = feedback.action == InvitationActionType.accept
        ? colors.success
        : theme.colorScheme.onSurfaceVariant;
    final icon = feedback.action == InvitationActionType.accept
        ? Icons.check_circle_rounded
        : Icons.cancel_rounded;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: feedback.action == InvitationActionType.accept
            ? colors.cardBackground
            : theme.colorScheme.surfaceContainerLow,
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
                color: accentColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20.responsiveRadius),
                  bottomStart: Radius.circular(20.responsiveRadius),
                ),
              ),
            ),
          ),
          Padding(
            padding: AppResponsive.onlyPadding(start: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.responsiveWidth,
                  height: 44.responsiveWidth,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22.responsiveRadius,
                  ),
                ),
                AppSpacing.md.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      AppSpacing.xs.verticalSpace,
                      Text(
                        subtitle,
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
}

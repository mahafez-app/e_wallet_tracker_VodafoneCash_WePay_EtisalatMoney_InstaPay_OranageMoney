import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import 'invitation_card_actions.dart';
import 'invitation_card_header.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.createdAt,
    required this.workspaceName,
    required this.inviterName,
    required this.isAccepting,
    required this.isDeclining,
    required this.isEnabled,
    required this.onAccept,
    required this.onDecline,
  });

  final DateTime createdAt;
  final String workspaceName;
  final String inviterName;
  final bool isAccepting;
  final bool isDeclining;
  final bool isEnabled;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 18.responsiveRadius,
            offset: Offset(0, 8.responsiveHeight),
          ),
        ],
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
                color: theme.colorScheme.primary,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(24.responsiveRadius),
                  bottomStart: Radius.circular(24.responsiveRadius),
                ),
              ),
            ),
          ),
          Padding(
            padding: AppResponsive.onlyPadding(
              start: AppSpacing.xl,
              top: AppSpacing.xl,
              end: AppSpacing.xl,
              bottom: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InvitationCardHeader(
                  workspaceName: workspaceName,
                  inviterName: inviterName,
                ),
                AppSpacing.lg.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 18.responsiveRadius,
                    ),
                    AppSpacing.sm.horizontalSpace,
                    Expanded(
                      child: Text(
                        createdAt.toTimeAgo(context),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.xl.verticalSpace,
                InvitationCardActions(
                  isAccepting: isAccepting,
                  isDeclining: isDeclining,
                  isEnabled: isEnabled,
                  onAccept: onAccept,
                  onDecline: onDecline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

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
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(50),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        child: Stack(
          children: [
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6.responsiveWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withAlpha(150),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InvitationCardHeader(
                    workspaceName: workspaceName,
                    inviterName: inviterName,
                  ),
                  MahafezSpacing.lg.verticalSpace,
                  Row(
                    children: [
                      Container(
                        padding: MahafezResponsive.allPadding(4.responsiveRadius),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant.withAlpha(15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_toggle_off_rounded,
                          color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                          size: 16.responsiveRadius,
                        ),
                      ),
                      MahafezSpacing.sm.horizontalSpace,
                      Expanded(
                        child: Text(
                          createdAt.toTimeAgo(context),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MahafezSpacing.xl.verticalSpace,
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
      ),
    );
  }
}

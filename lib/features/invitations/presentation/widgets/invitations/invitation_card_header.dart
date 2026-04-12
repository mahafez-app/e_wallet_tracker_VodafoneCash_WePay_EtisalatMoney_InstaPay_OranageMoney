import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';

class InvitationCardHeader extends StatelessWidget {
  const InvitationCardHeader({
    super.key,
    required this.workspaceName,
    required this.inviterName,
  });

  final String workspaceName;
  final String inviterName;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52.responsiveWidth,
          height: 52.responsiveWidth,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18.responsiveRadius),
          ),
          child: Icon(
            Icons.group_add_rounded,
            color: theme.colorScheme.primary,
            size: 24.responsiveRadius,
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workspaceName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppSpacing.xs.verticalSpace,
              Text(
                context.l10n.invitationSentBy(inviterName),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: AppResponsive.symmetricPadding(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.infoContainer.withAlpha(90),
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
      ],
    );
  }
}

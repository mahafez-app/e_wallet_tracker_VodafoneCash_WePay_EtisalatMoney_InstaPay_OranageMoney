import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../domain/entities/workspace_member_entity.dart';

class WorkspaceSettingsMemberTile extends StatelessWidget {
  const WorkspaceSettingsMemberTile({
    super.key,
    required this.member,
    required this.canRemove,
    required this.isRemoving,
    required this.onRemove,
  });

  final WorkspaceMemberEntity member;
  final bool canRemove;
  final bool isRemoving;
  final VoidCallback? onRemove;

  String get _fallbackEmail => member.email?.trim().isNotEmpty == true
      ? member.email!.trim()
      : member.uid;

  String get _initials {
    final segments = member.displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .take(2)
        .toList();
    if (segments.isEmpty) {
      return member.uid.substring(0, 1).toUpperCase();
    }

    return segments.map((item) => item.substring(0, 1).toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);
    final stripeColor = member.isOwner
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;
    final badgeBackground = member.isOwner
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHigh;
    final badgeForeground = member.isOwner
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;
    final avatarBackground = member.isOwner
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHigh;
    final avatarForeground = member.isOwner
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: context.mahafezColors.cardBackground,
        borderRadius: BorderRadius.circular(MahafezSpacing.lg.responsiveRadius),
        border: BorderDirectional(
          end: BorderSide(color: stripeColor, width: MahafezSpacing.xs),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: MahafezSpacing.md.responsiveRadius,
            offset: Offset(0, MahafezSpacing.xs.responsiveHeight),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.responsiveRadius,
            height: 40.responsiveRadius,
            decoration: BoxDecoration(
              color: avatarBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: theme.textTheme.labelMedium?.copyWith(
                color: avatarForeground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                FittedBox(
                  child: Text(
                    _fallbackEmail,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          MahafezSpacing.lg.horizontalSpace,
          if (member.isOwner)
            Container(
              padding: MahafezResponsive.symmetricPadding(
                horizontal: MahafezSpacing.md,
                vertical: MahafezSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: badgeBackground,
                borderRadius: BorderRadius.circular(
                  MahafezSpacing.xl.responsiveRadius,
                ),
              ),
              child: Text(
                context.l10n.workspaceOwnerBadge,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: badgeForeground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else if (canRemove)
            TextButton(
              onPressed: isRemoving ? null : onRemove,
              child: isRemoving
                  ? SizedBox.square(
                      dimension: MahafezSpacing.lg.responsiveWidth,
                      child: CircularProgressIndicator(
                        strokeWidth: MahafezSpacing.xxs.responsiveWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.error,
                        ),
                      ),
                    )
                  : Text(
                      context.l10n.workspaceSettingsRemoveMemberAction,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

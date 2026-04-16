// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../domain/entities/workspace_member_entity.dart';

class WorkspaceMembersSection extends StatelessWidget {
  const WorkspaceMembersSection({
    super.key,
    required this.members,
    this.onInviteMember,
  });

  final List<WorkspaceMemberEntity> members;
  final VoidCallback? onInviteMember;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.workspaceMembers,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (onInviteMember != null)
              TextButton.icon(
                onPressed: onInviteMember,
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text(l10n.workspaceInviteMemberAction),
              ),
          ],
        ),
        AppSpacing.md.verticalSpace,
        if (members.isEmpty)
          Text(
            l10n.workspaceMembersEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          SizedBox(
            height: 104.responsiveHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: members.length,
              separatorBuilder: (_, _) => AppSpacing.lg.horizontalSpace,
              itemBuilder: (context, index) =>
                  _WorkspaceMemberAvatar(member: members[index], index: index),
            ),
          ),
      ],
    );
  }
}

class _WorkspaceMemberAvatar extends StatelessWidget {
  const _WorkspaceMemberAvatar({
    super.key,
    required this.member,
    required this.index,
  });

  final WorkspaceMemberEntity member;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = switch (index % 4) {
      0 => colorScheme.primaryContainer,
      1 => colorScheme.secondary,
      2 => colorScheme.tertiary,
      _ => colorScheme.outline,
    };
    final foregroundColor = switch (index % 4) {
      0 => colorScheme.onPrimaryContainer,
      1 => colorScheme.onSecondary,
      2 => colorScheme.onTertiary,
      _ => colorScheme.onPrimary,
    };
    final fallbackSource = member.displayName.trim().isEmpty
        ? member.uid
        : member.displayName.trim();
    final initial = fallbackSource.substring(0, 1).toUpperCase();

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 60.responsiveRadius,
              height: 60.responsiveRadius,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    backgroundColor,
                    backgroundColor.withAlpha(180),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: backgroundColor.withAlpha(100),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withAlpha(40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (member.isOwner)
              PositionedDirectional(
                bottom: -2.responsiveHeight,
                end: -2.responsiveWidth,
                child: Container(
                  padding: AppResponsive.symmetricPadding(
                    horizontal: 8.responsiveRadius,
                    vertical: 3.responsiveRadius,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.tertiary, colorScheme.tertiary.withAlpha(200)],
                    ),
                    borderRadius: BorderRadius.circular(999.responsiveRadius),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.tertiary.withAlpha(100),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    context.l10n.workspaceOwnerBadge.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onTertiary,
                      fontWeight: FontWeight.w900,
                      fontSize: 8.responsiveFont,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        AppSpacing.sm.verticalSpace,
        Text(
          member.displayName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

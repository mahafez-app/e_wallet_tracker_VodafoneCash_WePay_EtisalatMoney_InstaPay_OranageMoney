// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../domain/entities/workspace_member_entity.dart';

class WorkspaceMembersSection extends StatelessWidget {
  const WorkspaceMembersSection({super.key, required this.members});

  final List<WorkspaceMemberEntity> members;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.workspaceMembers,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
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

    return SizedBox(
      width: 72.responsiveWidth,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56.responsiveRadius,
                height: 56.responsiveRadius,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (member.isOwner)
                PositionedDirectional(
                  bottom: -4.responsiveHeight,
                  start: -4.responsiveWidth,
                  child: Container(
                    padding: AppResponsive.symmetricPadding(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(999.responsiveRadius),
                    ),
                    child: Text(
                      context.l10n.workspaceOwnerBadge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onTertiary,
                        fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

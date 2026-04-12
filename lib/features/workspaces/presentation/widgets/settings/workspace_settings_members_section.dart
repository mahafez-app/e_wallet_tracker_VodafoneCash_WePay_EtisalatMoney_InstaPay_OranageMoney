// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../domain/entities/workspace_member_entity.dart';
import '../../providers/workspace_settings_state.dart';
import 'workspace_settings_member_tile.dart';
import 'workspace_settings_empty_state_card.dart';
import 'workspace_settings_section_title.dart';

class WorkspaceSettingsMembersSection extends StatelessWidget {
  const WorkspaceSettingsMembersSection({
    super.key,
    required this.members,
    required this.canManageWorkspace,
    required this.removingMemberId,
    required this.action,
    required this.onInviteMember,
    required this.onRemoveMember,
  });

  final List<WorkspaceMemberEntity> members;
  final bool canManageWorkspace;
  final String? removingMemberId;
  final WorkspaceSettingsAction action;
  final VoidCallback onInviteMember;
  final ValueChanged<WorkspaceMemberEntity> onRemoveMember;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: WorkspaceSettingsSectionTitle(
                title: context.l10n.workspaceMembers,
              ),
            ),
            if (canManageWorkspace)
              Padding(
                padding: AppResponsive.onlyPadding(start: AppSpacing.md),
                child: OutlinedButton.icon(
                  onPressed: onInviteMember,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 40.responsiveHeight),
                    padding: AppResponsive.symmetricPadding(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  icon: const Icon(Icons.mail_outline_rounded),
                  label: Text(
                    context.l10n.workspaceSettingsInviteByEmailAction,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        AppSpacing.md.verticalSpace,
        if (members.isEmpty)
          WorkspaceSettingsEmptyStateCard(
            message: context.l10n.workspaceMembersEmpty,
          )
        else
          Column(
            children: members
                .map(
                  (member) => Padding(
                    padding: AppResponsive.onlyPadding(bottom: AppSpacing.md),
                    child: WorkspaceSettingsMemberTile(
                      member: member,
                      canRemove: canManageWorkspace && !member.isOwner,
                      isRemoving:
                          action == WorkspaceSettingsAction.removingMember &&
                          removingMemberId == member.uid,
                      onRemove: canManageWorkspace && !member.isOwner
                          ? () => onRemoveMember(member)
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../auth/providers/auth_providers.dart';
import '../providers/workspace_settings_controller.dart';
import '../providers/workspace_settings_state.dart';
import '../widgets/settings/edit_workspace_name_bottom_sheet.dart';
import '../widgets/settings/workspace_settings_content.dart';
import 'workspace_settings_helpers.dart';
import 'workspace_unavailable_guard.dart';

class WorkspaceSettingsScreen extends StatelessWidget {
  const WorkspaceSettingsScreen({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.workspaceSettingsTitle)),
      body: SafeArea(child: _WorkspaceSettingsBody(workspaceId: workspaceId)),
    );
  }
}

class _WorkspaceSettingsBody extends ConsumerWidget {
  const _WorkspaceSettingsBody({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      workspaceSettingsControllerProvider(workspaceId).notifier,
    );

    ref.listen<AsyncValue<WorkspaceSettingsState>>(
      workspaceSettingsControllerProvider(workspaceId),
      (previous, next) {
        final feedback = next.asData?.value.feedback;
        if (feedback == null) {
          return;
        }

        handleWorkspaceSettingsFeedback(context, controller, feedback);
      },
    );

    final state = ref.watch(workspaceSettingsControllerProvider(workspaceId));
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    return WorkspaceUnavailableGuard<WorkspaceSettingsState>(
      state: state,
      currentUserId: currentUserId,
      detailsSelector: (settings) => settings.details,
      dataBuilder: (_, value) => WorkspaceSettingsContent(
        state: value,
        currentUserId: currentUserId,
        onEditWorkspaceName: () => EditWorkspaceNameBottomSheet.show(
          context,
          workspaceId: workspaceId,
          currentName: value.details.workspace.name,
        ),
        onInviteMember: () =>
            showInviteMemberSheet(context, controller, workspaceId),
        onRemoveMember: (member) =>
            showRemoveMemberDialog(context, controller, member),
        onRemoveWallet: (wallet) =>
            showRemoveWalletDialog(context, controller, wallet),
        onCancelInvitation: (invitation) =>
            showCancelInvitationDialog(context, controller, invitation),
        onLeaveWorkspace: () => showLeaveWorkspaceDialog(context, controller),
        onDeleteWorkspace: () => showDeleteWorkspaceDialog(context, controller),
      ),
    );
  }
}

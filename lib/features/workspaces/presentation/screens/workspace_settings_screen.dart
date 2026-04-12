import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../invitations/presentation/widgets/invitations/invite_member_bottom_sheet.dart';
import '../../domain/entities/workspace_member_entity.dart';
import '../providers/workspace_settings_controller.dart';
import '../widgets/settings/edit_workspace_name_bottom_sheet.dart';
import '../widgets/settings/workspace_settings_content.dart';

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

        _handleFeedback(context, controller, feedback);
      },
    );

    final state = ref.watch(workspaceSettingsControllerProvider(workspaceId));
    final currentUserId = ref.watch(currentUserProvider)?.uid;

    return switch (state) {
      AsyncLoading() => const AppLoader(),
      AsyncError(:final error) => AppErrorView(error: error),
      AsyncData(:final value) => WorkspaceSettingsContent(
        state: value,
        currentUserId: currentUserId,
        onEditWorkspaceName: () => EditWorkspaceNameBottomSheet.show(
          context,
          workspaceId: workspaceId,
          currentName: value.details.workspace.name,
        ),
        onInviteMember: () =>
            InviteMemberBottomSheet.show(context, workspaceId: workspaceId),
        onRemoveMember: (member) =>
            _showRemoveMemberDialog(context, controller, member),
        onCancelInvitation: (invitation) =>
            _showCancelInvitationDialog(context, controller, invitation),
        onDeleteWorkspace: () =>
            _showDeleteWorkspaceDialog(context, controller),
      ),
    };
  }

  void _handleFeedback(
    BuildContext context,
    WorkspaceSettingsController controller,
    WorkspaceSettingsFeedback feedback,
  ) {
    if (!context.mounted) {
      return;
    }

    switch (feedback.type) {
      case WorkspaceSettingsFeedbackType.workspaceNameUpdated:
        AppSnackbar.show(
          context,
          message: context.l10n.workspaceSettingsNameUpdatedSuccess,
          type: AppSnackbarType.success,
        );
        controller.clearFeedback();
        return;
      case WorkspaceSettingsFeedbackType.memberRemoved:
        AppSnackbar.show(
          context,
          message: context.l10n.workspaceSettingsMemberRemovedSuccess,
          type: AppSnackbarType.success,
        );
        controller.clearFeedback();
        return;
      case WorkspaceSettingsFeedbackType.invitationCancelled:
        AppSnackbar.show(
          context,
          message: context.l10n.workspaceSettingsInvitationCancelledSuccess,
          type: AppSnackbarType.success,
        );
        controller.clearFeedback();
        return;
      case WorkspaceSettingsFeedbackType.workspaceDeleted:
        context.go(AppRoutes.home);
        return;
      case WorkspaceSettingsFeedbackType.failure:
        final failure = feedback.failure;
        if (failure == null) {
          controller.clearFeedback();
          return;
        }

        AppSnackbar.show(
          context,
          message: failure.toLocalizedString(context),
          type: AppSnackbarType.error,
        );
        controller.clearFeedback();
        return;
    }
  }

  Future<void> _showRemoveMemberDialog(
    BuildContext context,
    WorkspaceSettingsController controller,
    WorkspaceMemberEntity member,
  ) {
    return AppDialog.show<void>(
      context,
      title: context.l10n.workspaceSettingsRemoveMemberConfirmTitle,
      message: context.l10n.workspaceSettingsRemoveMemberConfirmMessage(
        member.displayName,
      ),
      confirmLabel: context.l10n.workspaceSettingsRemoveMemberAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: AppDialogType.warning,
      onConfirm: () {
        Navigator.of(context).pop();
        controller.removeMember(member);
      },
    );
  }

  Future<void> _showCancelInvitationDialog(
    BuildContext context,
    WorkspaceSettingsController controller,
    WorkspacePendingInvitationEntity invitation,
  ) {
    return AppDialog.show<void>(
      context,
      title: context.l10n.workspaceSettingsCancelInvitationConfirmTitle,
      message: context.l10n.workspaceSettingsCancelInvitationConfirmMessage(
        invitation.email,
      ),
      confirmLabel: context.l10n.workspaceSettingsCancelInvitationAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: AppDialogType.warning,
      onConfirm: () {
        Navigator.of(context).pop();
        controller.cancelInvitation(invitation);
      },
    );
  }

  Future<void> _showDeleteWorkspaceDialog(
    BuildContext context,
    WorkspaceSettingsController controller,
  ) {
    return AppDialog.show<void>(
      context,
      title: context.l10n.workspaceSettingsDeleteWorkspaceConfirmTitle,
      message: context.l10n.workspaceSettingsDeleteWorkspaceConfirmMessage,
      confirmLabel: context.l10n.commonDeleteAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: AppDialogType.error,
      onConfirm: () {
        Navigator.of(context).pop();
        controller.deleteWorkspace();
      },
    );
  }
}

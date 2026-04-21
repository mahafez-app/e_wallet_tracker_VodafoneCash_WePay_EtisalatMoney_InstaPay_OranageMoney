import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../invitations/presentation/widgets/invitations/invite_member_bottom_sheet.dart';
import '../../domain/entities/workspace_member_entity.dart';
import '../providers/workspace_settings_controller.dart';
import '../providers/workspace_settings_state.dart';

void handleWorkspaceSettingsFeedback(
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
    case WorkspaceSettingsFeedbackType.walletRemoved:
      AppSnackbar.show(
        context,
        message: context.l10n.workspaceSettingsWalletRemovedSuccess,
        type: AppSnackbarType.success,
      );
      controller.clearFeedback();
      return;
    case WorkspaceSettingsFeedbackType.workspaceDeleted:
    case WorkspaceSettingsFeedbackType.workspaceLeft:
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

Future<void> showInviteMemberSheet(
  BuildContext context,
  WorkspaceSettingsController controller,
  String workspaceId,
) async {
  final wasInvited = await InviteMemberBottomSheet.show(
    context,
    workspaceId: workspaceId,
  );
  if (wasInvited == true) {
    controller.refresh();
  }
}

Future<void> showRemoveMemberDialog(
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
    type: AppDialogType.error,
    onConfirm: () {
      Navigator.of(context).pop();
      controller.removeMember(member);
    },
  );
}

Future<void> showCancelInvitationDialog(
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
    type: AppDialogType.error,
    onConfirm: () {
      Navigator.of(context).pop();
      controller.cancelInvitation(invitation);
    },
  );
}

Future<void> showRemoveWalletDialog(
  BuildContext context,
  WorkspaceSettingsController controller,
  WalletEntity wallet,
) {
  return AppDialog.show<void>(
    context,
    title: context.l10n.workspaceSettingsRemoveWalletConfirmTitle,
    message: context.l10n.workspaceSettingsRemoveWalletConfirmMessage(
      wallet.provider.displayName(context),
      wallet.phoneNumber.formattedEgyptianPhoneNumber,
    ),
    confirmLabel: context.l10n.workspaceSettingsRemoveWalletAction,
    cancelLabel: context.l10n.commonCancelAction,
    type: AppDialogType.error,
    onConfirm: () {
      Navigator.of(context).pop();
      controller.removeWallet(wallet);
    },
  );
}

Future<void> showLeaveWorkspaceDialog(
  BuildContext context,
  WorkspaceSettingsController controller,
) {
  return AppDialog.show<void>(
    context,
    title: context.l10n.workspaceSettingsLeaveWorkspaceConfirmTitle,
    message: context.l10n.workspaceSettingsLeaveWorkspaceConfirmMessage,
    confirmLabel: context.l10n.workspaceSettingsLeaveWorkspaceAction,
    cancelLabel: context.l10n.commonCancelAction,
    type: AppDialogType.error,
    onConfirm: () {
      Navigator.of(context).pop();
      controller.leaveWorkspace();
    },
  );
}

Future<void> showDeleteWorkspaceDialog(
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

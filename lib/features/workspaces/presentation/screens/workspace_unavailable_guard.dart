import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../domain/entities/workspace_details_entity.dart';

bool isWorkspaceUnavailableError(Object error) {
  return switch (error) {
    ServerFailure(:final code) => code == '404',
    PermissionFailure() => true,
    ValidationFailure(:final code) => code == 'workspace-member-not-found',
    _ => false,
  };
}

bool isWorkspaceAccessRevoked(
  WorkspaceDetailsEntity details,
  String? currentUserId,
) {
  if (currentUserId == null) {
    return false;
  }

  if (details.workspace.ownerUid == currentUserId) {
    return false;
  }

  return !details.members.any((member) => member.uid == currentUserId);
}

Future<void> showWorkspaceUnavailableDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AppDialog(
      title: context.l10n.workspaceUnavailableTitle,
      message: context.l10n.workspaceUnavailableMessage,
      confirmLabel: context.l10n.workspaceUnavailableAction,
      type: AppDialogType.info,
      onConfirm: () {
        Navigator.of(dialogContext).pop();
        if (!context.mounted) {
          return;
        }

        context.go(AppRoutes.home);
      },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
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
  if (currentUserId == null) return false;

  if (details.workspace.ownerUid == currentUserId) return false;

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
        if (!context.mounted) return;
        context.go(AppRoutes.home);
      },
    ),
  );
}

class WorkspaceUnavailableGuard<T> extends StatefulWidget {
  const WorkspaceUnavailableGuard({
    super.key,
    required this.state,
    required this.currentUserId,
    required this.detailsSelector,
    required this.dataBuilder,
  });

  final AsyncValue<T> state;
  final String? currentUserId;
  final WorkspaceDetailsEntity Function(T data) detailsSelector;
  final Widget Function(BuildContext context, T data) dataBuilder;

  @override
  State<WorkspaceUnavailableGuard<T>> createState() =>
      _WorkspaceUnavailableGuardState<T>();
}

class _WorkspaceUnavailableGuardState<T>
    extends State<WorkspaceUnavailableGuard<T>> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return switch (state) {
      AsyncLoading() => const AppLoader(),
      AsyncError(:final error) => _buildFromError(context, error),
      AsyncData(:final value) => _buildFromData(context, value),
    };
  }

  Widget _buildFromError(BuildContext context, Object error) {
    if (!isWorkspaceUnavailableError(error)) {
      _dialogShown = false;
      return AppErrorView(error: error);
    }

    _showDialogIfNeeded(context);
    return const SizedBox.shrink();
  }

  Widget _buildFromData(BuildContext context, T value) {
    final details = widget.detailsSelector(value);
    final isRevoked = isWorkspaceAccessRevoked(details, widget.currentUserId);
    if (!isRevoked) {
      _dialogShown = false;
      return widget.dataBuilder(context, value);
    }

    _showDialogIfNeeded(context);
    return const SizedBox.shrink();
  }

  void _showDialogIfNeeded(BuildContext context) {
    if (_dialogShown) return;

    _dialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      showWorkspaceUnavailableDialog(context);
    });
  }
}

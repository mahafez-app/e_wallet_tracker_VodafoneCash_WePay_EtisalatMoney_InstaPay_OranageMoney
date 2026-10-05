import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../widgets/details/workspace_details_loading_view.dart';

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
    builder: (dialogContext) => MahafezDialog(
      title: context.l10n.workspaceUnavailableTitle,
      message: context.l10n.workspaceUnavailableMessage,
      confirmLabel: context.l10n.workspaceUnavailableAction,
      type: MahafezDialogType.info,
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
    return switch (widget.state) {
      AsyncLoading() => const WorkspaceDetailsLoadingView(),
      AsyncError(:final error) when isWorkspaceUnavailableError(error) =>
        _WorkspaceUnavailablePlaceholder(onShowDialog: _showDialogIfNeeded),
      AsyncError(:final error) => _WorkspaceErrorView(
        error: error,
        onResolved: _resetDialogState,
      ),
      AsyncData(:final value)
          when isWorkspaceAccessRevoked(
            widget.detailsSelector(value),
            widget.currentUserId,
          ) =>
        _WorkspaceUnavailablePlaceholder(onShowDialog: _showDialogIfNeeded),
      AsyncData(:final value) => _WorkspaceAvailableContent<T>(
        value: value,
        dataBuilder: widget.dataBuilder,
        onResolved: _resetDialogState,
      ),
    };
  }

  void _resetDialogState() {
    _dialogShown = false;
  }

  void _showDialogIfNeeded(BuildContext context) {
    if (_dialogShown) return;
 
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
    if (!isCurrent) return;

    _dialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      showWorkspaceUnavailableDialog(context);
    });
  }
}

class _WorkspaceErrorView extends StatelessWidget {
  const _WorkspaceErrorView({required this.error, required this.onResolved});

  final Object error;
  final VoidCallback onResolved;

  @override
  Widget build(BuildContext context) {
    onResolved();
    return MahafezErrorView(error: error);
  }
}

class _WorkspaceAvailableContent<T> extends StatelessWidget {
  const _WorkspaceAvailableContent({
    required this.value,
    required this.dataBuilder,
    required this.onResolved,
  });

  final T value;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final VoidCallback onResolved;

  @override
  Widget build(BuildContext context) {
    onResolved();
    return dataBuilder(context, value);
  }
}

class _WorkspaceUnavailablePlaceholder extends StatelessWidget {
  const _WorkspaceUnavailablePlaceholder({required this.onShowDialog});

  final void Function(BuildContext context) onShowDialog;

  @override
  Widget build(BuildContext context) {
    onShowDialog(context);
    return const SizedBox.shrink();
  }
}

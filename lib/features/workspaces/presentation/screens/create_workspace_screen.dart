// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/providers/auth_providers.dart';
import '../providers/create_workspace_controller.dart';
import '../widgets/create_workspace/create_workspace_content.dart';

class CreateWorkspaceScreen extends StatelessWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createWorkspaceTitle)),
      body: const SafeArea(child: _CreateWorkspaceBody()),
    );
  }
}

class _CreateWorkspaceBody extends ConsumerWidget {
  const _CreateWorkspaceBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<CreateWorkspaceState>(
      createWorkspaceControllerProvider,
      (previous, next) => _handleStateChange(context, previous, next),
    );

    final state = ref.watch(createWorkspaceControllerProvider);
    final controller = ref.read(createWorkspaceControllerProvider.notifier);
    final ownerName = ref.watch(currentUserProvider)?.name ?? '';

    return CreateWorkspaceContent(
      state: state,
      ownerName: ownerName,
      onNameChanged: controller.updateName,
      onSubmit: controller.submit,
    );
  }

  void _handleStateChange(
    BuildContext context,
    CreateWorkspaceState? previous,
    CreateWorkspaceState next,
  ) {
    if (_hasNewFailure(previous, next)) {
      _showFailureSnackbar(context, next.submissionFailure!);
      return;
    }

    if (!_hasSuccessfulSubmission(previous, next)) return;

    final workspaceId = next.createdWorkspaceId;
    if (workspaceId == null || workspaceId.isEmpty) {
      context.go(AppRoutes.home);
      return;
    }
    context.pop();
    context.push(
      AppRoutes.workspaceWalletSelectionPath(workspaceId, fromCreation: true),
    );
  }

  bool _hasNewFailure(
    CreateWorkspaceState? previous,
    CreateWorkspaceState next,
  ) {
    return next.submissionStatus == CreateWorkspaceSubmissionStatus.failure &&
        previous?.submissionFailure != next.submissionFailure &&
        next.submissionFailure != null;
  }

  bool _hasSuccessfulSubmission(
    CreateWorkspaceState? previous,
    CreateWorkspaceState next,
  ) {
    return previous?.submissionStatus !=
            CreateWorkspaceSubmissionStatus.success &&
        next.submissionStatus == CreateWorkspaceSubmissionStatus.success;
  }

  void _showFailureSnackbar(BuildContext context, Failure failure) {
    AppSnackbar.showFailure(context, failure: failure);
  }
}

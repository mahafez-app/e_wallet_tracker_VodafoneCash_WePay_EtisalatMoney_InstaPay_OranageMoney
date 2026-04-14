import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/extensions/routes_extension.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../providers/workspace_wallet_selection_controller.dart';
import '../../providers/workspace_wallet_selection_state.dart';
import 'workspace_wallet_selection_content.dart';

class SelectWorkspaceWalletsBody extends ConsumerWidget {
  const SelectWorkspaceWalletsBody({
    super.key,
    required this.workspaceId,
    required this.isCreateFlow,
  });

  final String workspaceId;
  final bool isCreateFlow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = workspaceWalletSelectionControllerProvider(workspaceId);
    final controller = ref.read(provider.notifier);

    ref.listen<AsyncValue<WorkspaceWalletSelectionState>>(
      provider,
      (previous, next) => _handleStateChange(
        context,
        previous?.asData?.value,
        next.asData?.value,
      ),
    );

    final stateAsync = ref.watch(provider);

    return switch (stateAsync) {
      AsyncLoading() => const AppLoader(),
      AsyncError(:final error) => AppErrorView(
        error: error,
        onRetry: () => ref.invalidate(provider),
      ),
      AsyncData(:final value) => WorkspaceWalletSelectionContent(
        workspaceId: workspaceId,
        state: value,
        isCreateFlow: isCreateFlow,
        onToggleWallet: controller.toggleWallet,
        onSubmit: controller.submit,
      ),
    };
  }

  void _handleStateChange(
    BuildContext context,
    WorkspaceWalletSelectionState? previous,
    WorkspaceWalletSelectionState? next,
  ) {
    if (next == null) return;

    if (_hasNewFailure(previous, next)) {
      _showFailureSnackbar(context, next.submissionFailure!);
      return;
    }

    if (!_hasSuccessfulSubmission(previous, next)) return;

    if (isCreateFlow) {
      // Pop all left the home -> workspace details flow and push the workspace details to refresh it with the newly linked wallets
      context.popUntil((route) => route.settings.name == AppRoutes.home);
      context.push(AppRoutes.workspaceDetailsPath(workspaceId));
      return;
    }
    // When managing wallets for an existing workspace, just pop with the new linked count to update the previous screen
    if (Navigator.of(context).canPop()) {
      context.pop(next.linkedCount);
      return;
    }
    // If we can't pop, it means we came from an external deep link, so we just push the workspace details page
    context.popUntil((route) => route.settings.name == AppRoutes.home);
    context.push(AppRoutes.workspaceDetailsPath(workspaceId));
  }

  bool _hasNewFailure(
    WorkspaceWalletSelectionState? previous,
    WorkspaceWalletSelectionState next,
  ) {
    return next.submissionStatus ==
            WorkspaceWalletSelectionSubmissionStatus.failure &&
        previous?.submissionFailure != next.submissionFailure &&
        next.submissionFailure != null;
  }

  bool _hasSuccessfulSubmission(
    WorkspaceWalletSelectionState? previous,
    WorkspaceWalletSelectionState next,
  ) {
    return previous?.submissionStatus !=
            WorkspaceWalletSelectionSubmissionStatus.success &&
        next.submissionStatus ==
            WorkspaceWalletSelectionSubmissionStatus.success;
  }

  void _showFailureSnackbar(BuildContext context, Failure failure) {
    AppSnackbar.showFailure(context, failure: failure);
  }
}

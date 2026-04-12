import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/extensions/failure_extension.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../providers/invitations_controller.dart';
import '../../providers/invitations_state.dart';
import 'invitations_content.dart';

class InvitationsBody extends ConsumerWidget {
  const InvitationsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<InvitationsState>>(
      invitationsControllerProvider,
      (previous, next) => _handleStateChange(context, ref, previous, next),
    );

    final state = ref.watch(invitationsControllerProvider);
    return switch (state) {
      AsyncLoading() => const AppLoader(),
      AsyncError(:final error) => AppErrorView(
        error: error,
        onRetry: () => ref.invalidate(invitationsControllerProvider),
      ),
      AsyncData(:final value) => InvitationsContent(state: value),
    };
  }

  void _handleStateChange(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<InvitationsState>? previous,
    AsyncValue<InvitationsState> next,
  ) {
    final feedback = next.asData?.value.feedback;
    if (feedback == null || previous?.asData?.value.feedback == feedback) {
      return;
    }

    if (!feedback.isSuccess) {
      AppSnackbar.show(
        context,
        message: feedback.failure!.toLocalizedString(context),
        type: AppSnackbarType.error,
      );
      return;
    }

    if (feedback.action == InvitationActionType.accept) {
      unawaited(_navigateAfterAccept(context, feedback));
    }
  }

  Future<void> _navigateAfterAccept(
    BuildContext context,
    InvitationActionFeedback feedback,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!context.mounted) {
      return;
    }

    context.push(
      AppRoutes.workspaceDetailsPath(feedback.invitation.workspaceId),
    );
  }
}

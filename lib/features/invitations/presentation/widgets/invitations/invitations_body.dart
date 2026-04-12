// ignore_for_file: unused_element_parameter

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/failure_extension.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../domain/entities/invitation_entity.dart';
import '../../providers/invitation_display_provider.dart';
import '../../providers/invitations_controller.dart';
import 'invitation_card.dart';

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
      AsyncData(:final value) => _InvitationsContent(state: value),
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

    unawaited(_handleSuccessFeedback(context, ref, feedback));
  }

  Future<void> _handleSuccessFeedback(
    BuildContext context,
    WidgetRef ref,
    InvitationActionFeedback feedback,
  ) async {
    final display = await ref.read(
      invitationDisplayProvider(feedback.invitation).future,
    );
    if (!context.mounted) {
      return;
    }

    final message = switch (feedback.action) {
      InvitationActionType.accept => context.l10n.invitationAcceptSuccess(
        display.workspaceName,
      ),
      InvitationActionType.decline => context.l10n.invitationDeclineSuccess(
        display.workspaceName,
      ),
    };

    AppSnackbar.show(context, message: message, type: AppSnackbarType.success);
    if (feedback.action == InvitationActionType.accept) {
      context.go(
        AppRoutes.workspaceDetailsPath(feedback.invitation.workspaceId),
      );
    }
  }
}

class _InvitationsContent extends ConsumerWidget {
  const _InvitationsContent({super.key, required this.state});

  final InvitationsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(invitationsControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: state.invitations.isEmpty
          ? _InvitationsEmptyList(onRefresh: controller.refresh)
          : _InvitationsList(
              state: state,
              onAccept: controller.acceptInvitation,
              onDecline: (invitation) =>
                  _confirmDecline(context, ref, controller, invitation),
            ),
    );
  }

  Future<void> _confirmDecline(
    BuildContext context,
    WidgetRef ref,
    InvitationsController controller,
    InvitationEntity invitation,
  ) async {
    final display = await ref.read(
      invitationDisplayProvider(invitation).future,
    );
    if (!context.mounted) {
      return;
    }

    final didConfirm = await AppDialog.show<bool>(
      context,
      title: context.l10n.invitationDeclineConfirmTitle,
      message: context.l10n.invitationDeclineConfirmMessage(
        display.workspaceName,
      ),
      confirmLabel: context.l10n.invitationsDeclineAction,
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
      type: AppDialogType.warning,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    );

    if (didConfirm != true) {
      return;
    }

    controller.declineInvitation(invitation.id);
  }
}

class _InvitationsList extends StatelessWidget {
  const _InvitationsList({
    super.key,
    required this.state,
    required this.onAccept,
    required this.onDecline,
  });

  final InvitationsState state;
  final ValueChanged<String> onAccept;
  final Future<void> Function(InvitationEntity invitation) onDecline;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      children: [
        _InvitationsOverviewCard(count: state.invitations.length),
        AppSpacing.xl.verticalSpace,
        for (final invitation in state.invitations) ...[
          _InvitationCardItem(
            invitation: invitation,
            isAccepting: state.isAccepting(invitation.id),
            isDeclining: state.isDeclining(invitation.id),
            isEnabled: _isEnabled(invitation.id),
            onAccept: () => onAccept(invitation.id),
            onDecline: () => onDecline(invitation),
          ),
          AppSpacing.lg.verticalSpace,
        ],
        const _InvitationsInfoCard(),
      ],
    );
  }

  bool _isEnabled(String invitationId) {
    return state.processingInvitationId == null ||
        state.processingInvitationId == invitationId;
  }
}

class _InvitationCardItem extends ConsumerWidget {
  const _InvitationCardItem({
    super.key,
    required this.invitation,
    required this.isAccepting,
    required this.isDeclining,
    required this.isEnabled,
    required this.onAccept,
    required this.onDecline,
  });

  final InvitationEntity invitation;
  final bool isAccepting;
  final bool isDeclining;
  final bool isEnabled;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(invitationDisplayProvider(invitation));
    final workspaceName =
        display.asData?.value.workspaceName ?? invitation.workspaceId;
    final inviterName =
        display.asData?.value.inviterName ?? invitation.invitedByUid;

    return InvitationCard(
      createdAt: invitation.createdAt,
      workspaceName: workspaceName,
      inviterName: inviterName,
      isAccepting: isAccepting,
      isDeclining: isDeclining,
      isEnabled: isEnabled,
      onAccept: onAccept,
      onDecline: onDecline,
    );
  }
}

class _InvitationsOverviewCard extends StatelessWidget {
  const _InvitationsOverviewCard({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppResponsive.symmetricPadding(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.infoContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(999.responsiveRadius),
            ),
            child: Text(
              context.l10n.invitationsPendingStatus,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.info,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            context.l10n.invitationsPendingCount(count),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            context.l10n.invitationsListDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationsInfoCard extends StatelessWidget {
  const _InvitationsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.infoContainer, Theme.of(context).colorScheme.surface],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(28.responsiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20.responsiveRadius,
            ),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.invitationsHowItWorksTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.xs.verticalSpace,
                Text(
                  context.l10n.invitationsHowItWorksDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationsEmptyList extends StatelessWidget {
  const _InvitationsEmptyList({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      children: [
        AppSpacing.xxxl.verticalSpace,
        const _InvitationsEmptyState(),
        AppSpacing.xl.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: context.l10n.invitationsRefreshAction,
            trailingIcon: Icon(
              Icons.refresh_rounded,
              size: 18.responsiveRadius,
            ),
            onPressed: () => onRefresh(),
          ),
        ),
        AppSpacing.xl.verticalSpace,
        const _InvitationsInfoCard(),
      ],
    );
  }
}

class _InvitationsEmptyState extends StatelessWidget {
  const _InvitationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32.responsiveRadius),
      ),
      child: Column(
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28.responsiveRadius),
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 52.responsiveRadius,
            ),
          ),
          AppSpacing.xl.verticalSpace,
          Text(
            context.l10n.invitationsEmptyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            context.l10n.invitationsEmptyDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

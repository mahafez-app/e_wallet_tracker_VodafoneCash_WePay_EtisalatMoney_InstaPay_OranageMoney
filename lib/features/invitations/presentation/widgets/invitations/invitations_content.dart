import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../domain/entities/invitation_entity.dart';
import '../../providers/invitation_display_provider.dart';
import '../../providers/invitations_controller.dart';
import '../../providers/invitations_state.dart';
import 'invitations_empty_content.dart';
import 'invitation_list_item.dart';
import 'invitations_feedback_section.dart';
import 'invitations_sections.dart';

class InvitationsContent extends ConsumerWidget {
  const InvitationsContent({super.key, required this.state});

  final InvitationsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(invitationsControllerProvider.notifier);
    if (state.invitations.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            if (state.recentFeedbacks.isNotEmpty) ...[
              InvitationsFeedbackSection(feedbacks: state.recentFeedbacks),
              AppSpacing.xl.verticalSpace,
            ],
            InvitationsEmptyContent(onRefresh: controller.refresh),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.pagePadding,
        children: [
          if (state.recentFeedbacks.isNotEmpty) ...[
            InvitationsFeedbackSection(feedbacks: state.recentFeedbacks),
            AppSpacing.xl.verticalSpace,
          ],
          InvitationsOverviewCard(count: state.invitations.length),
          AppSpacing.xl.verticalSpace,
          for (final invitation in state.invitations) ...[
            InvitationListItem(
              invitation: invitation,
              isAccepting: state.isAccepting(invitation.id),
              isDeclining: state.isDeclining(invitation.id),
              isEnabled: _isEnabled(invitation.id),
              onAccept: () => controller.acceptInvitation(invitation.id),
              onDecline: () =>
                  _confirmDecline(context, ref, controller, invitation),
            ),
            AppSpacing.lg.verticalSpace,
          ],
          const InvitationsInfoCard(),
        ],
      ),
    );
  }

  bool _isEnabled(String invitationId) {
    return state.processingInvitationId == null ||
        state.processingInvitationId == invitationId;
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

    final workspaceName = display.workspaceName.trim().isNotEmpty
        ? display.workspaceName
        : context.l10n.invitationsDeletedWorkspaceFallback;

    final didConfirm = await AppDialog.show<bool>(
      context,
      title: context.l10n.invitationDeclineConfirmTitle,
      message: context.l10n.invitationDeclineConfirmMessage(workspaceName),
      confirmLabel: context.l10n.invitationsDeclineAction,
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
      type: AppDialogType.warning,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    );

    if (didConfirm == true) {
      controller.declineInvitation(invitation.id);
    }
  }
}

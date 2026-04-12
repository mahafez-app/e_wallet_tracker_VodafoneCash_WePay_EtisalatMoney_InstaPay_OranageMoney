import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../providers/invitations_state.dart';
import 'invitation_feedback_card.dart';

class InvitationsFeedbackSection extends StatelessWidget {
  const InvitationsFeedbackSection({super.key, required this.feedbacks});

  final List<InvitationActionFeedback> feedbacks;

  @override
  Widget build(BuildContext context) {
    if (feedbacks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.invitationsRecentResponsesTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        AppSpacing.md.verticalSpace,
        for (var index = 0; index < feedbacks.length; index++) ...[
          InvitationFeedbackCard(feedback: feedbacks[index]),
          if (index != feedbacks.length - 1) AppSpacing.md.verticalSpace,
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';

class InvitationCardActions extends StatelessWidget {
  const InvitationCardActions({
    super.key,
    required this.isAccepting,
    required this.isDeclining,
    required this.isEnabled,
    required this.onAccept,
    required this.onDecline,
  });

  final bool isAccepting;
  final bool isDeclining;
  final bool isEnabled;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final canTap = isEnabled && !isAccepting && !isDeclining;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: context.l10n.invitationsAcceptAction,
            isLoading: isAccepting,
            onPressed: canTap ? onAccept : null,
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: AppButton(
            label: context.l10n.invitationsDeclineAction,
            type: AppButtonType.secondary,
            isLoading: isDeclining,
            onPressed: canTap ? onDecline : null,
          ),
        ),
      ],
    );
  }
}

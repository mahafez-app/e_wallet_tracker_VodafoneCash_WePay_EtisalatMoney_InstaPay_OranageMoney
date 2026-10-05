import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/extensions/localization_extension.dart';
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
          child: MahafezButton(
            label: context.l10n.invitationsAcceptAction,
            isLoading: isAccepting,
            onPressed: canTap ? onAccept : null,
          ),
        ),
        MahafezSpacing.md.horizontalSpace,
        Expanded(
          child: MahafezButton(
            label: context.l10n.invitationsDeclineAction,
            type: MahafezButtonType.secondary,
            isLoading: isDeclining,
            onPressed: canTap ? onDecline : null,
          ),
        ),
      ],
    );
  }
}

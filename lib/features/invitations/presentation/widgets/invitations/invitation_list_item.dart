import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../domain/entities/invitation_entity.dart';
import '../../providers/invitation_display_provider.dart';
import 'invitation_card.dart';

class InvitationListItem extends ConsumerWidget {
  const InvitationListItem({
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
    final resolvedWorkspaceName = display.asData?.value.workspaceName;
    final workspaceName = resolvedWorkspaceName?.trim().isNotEmpty == true
        ? resolvedWorkspaceName!
        : context.l10n.invitationsDeletedWorkspaceFallback;
    final resolvedInviterName = display.asData?.value.inviterName;
    final inviterName = resolvedInviterName?.trim().isNotEmpty == true
        ? resolvedInviterName!
        : context.l10n.invitationsUnknownInviterFallback;

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

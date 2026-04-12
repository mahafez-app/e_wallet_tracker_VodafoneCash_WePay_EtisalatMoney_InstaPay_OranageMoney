import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/usecases/get_user_profile_usecase.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../workspaces/domain/usecases/get_workspace_details_usecase.dart';
import '../../../workspaces/providers/workspaces_providers.dart';
import '../../domain/entities/invitation_entity.dart';

class InvitationDisplayData {
  const InvitationDisplayData({
    required this.workspaceName,
    required this.inviterName,
    required this.isWorkspaceUnavailable,
  });

  final String workspaceName;
  final String inviterName;
  final bool isWorkspaceUnavailable;
}

final invitationDisplayProvider = FutureProvider.autoDispose
    .family<InvitationDisplayData, InvitationEntity>((ref, invitation) async {
      final cachedWorkspaceName = invitation.workspaceName?.trim();
      final cachedInviterName = invitation.inviterName?.trim();
      if (cachedWorkspaceName?.isNotEmpty == true &&
          cachedInviterName?.isNotEmpty == true) {
        return InvitationDisplayData(
          workspaceName: cachedWorkspaceName!,
          inviterName: cachedInviterName!,
          isWorkspaceUnavailable: false,
        );
      }

      final workspaceResult = await ref
          .read(getWorkspaceDetailsUseCaseProvider)
          .call(GetWorkspaceDetailsParams(workspaceId: invitation.workspaceId));
      final inviterResult = await ref
          .read(getUserProfileUseCaseProvider)
          .call(GetUserProfileParams(invitation.invitedByUid));
      final workspaceName = workspaceResult.dataOrNull?.workspace.name;
      final inviterName = inviterResult.dataOrNull?.name;

      return InvitationDisplayData(
        workspaceName: workspaceName ?? cachedWorkspaceName ?? '',
        inviterName:
            inviterName ?? cachedInviterName ?? invitation.invitedByUid,
        isWorkspaceUnavailable: workspaceName == null,
      );
    });

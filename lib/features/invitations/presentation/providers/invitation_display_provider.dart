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
  });

  final String workspaceName;
  final String inviterName;
}

final invitationDisplayProvider = FutureProvider.autoDispose
    .family<InvitationDisplayData, InvitationEntity>((ref, invitation) async {
      final workspaceResult = await ref
          .read(getWorkspaceDetailsUseCaseProvider)
          .call(GetWorkspaceDetailsParams(workspaceId: invitation.workspaceId));
      final inviterResult = await ref
          .read(getUserProfileUseCaseProvider)
          .call(GetUserProfileParams(invitation.invitedByUid));
      final workspaceName =
          workspaceResult.dataOrNull?.workspace.name ?? invitation.workspaceId;
      final inviterName =
          inviterResult.dataOrNull?.name ?? invitation.invitedByUid;

      return InvitationDisplayData(
        workspaceName: workspaceName,
        inviterName: inviterName,
      );
    });

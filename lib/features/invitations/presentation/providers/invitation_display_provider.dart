import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:identity_product/identity_product.dart';

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

      final workspaceFuture = ref
          .read(getWorkspaceDetailsUseCaseProvider)
          .call(GetWorkspaceDetailsParams(workspaceId: invitation.workspaceId));
      final inviterFuture = ref
          .read(identityServiceProvider)
          .getUserProfile(invitation.invitedByUid);
      final workspaceResult = await workspaceFuture;
      final inviterResult = await inviterFuture;
      final workspaceName = workspaceResult.dataOrNull?.workspace.name;
      final inviterName = inviterResult.dataOrNull?.name;

      return InvitationDisplayData(
        workspaceName: workspaceName ?? cachedWorkspaceName ?? '',
        inviterName: inviterName ?? cachedInviterName ?? '',
        isWorkspaceUnavailable: workspaceName == null,
      );
    });

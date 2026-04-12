import '../../domain/entities/workspace_pending_invitation_entity.dart';

final class WorkspacePendingInvitationDto
    extends WorkspacePendingInvitationEntity {
  const WorkspacePendingInvitationDto({
    required super.id,
    required super.workspaceId,
    required super.email,
    required super.createdAt,
  });

  WorkspacePendingInvitationEntity toEntity() {
    return WorkspacePendingInvitationEntity(
      id: id,
      workspaceId: workspaceId,
      email: email,
      createdAt: createdAt,
    );
  }
}

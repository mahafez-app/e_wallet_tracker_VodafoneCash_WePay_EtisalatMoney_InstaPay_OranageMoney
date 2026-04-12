import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/invitation_entity.dart';
import '../../domain/enums/invitation_status.dart';

final class InvitationDto extends InvitationEntity {
  const InvitationDto({
    required super.id,
    required super.workspaceId,
    required super.invitedUserId,
    required super.invitedByUid,
    required super.role,
    required super.status,
    required super.createdAt,
  });

  factory InvitationDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return InvitationDto(
      id: document.id,
      workspaceId: data['workspaceId'] as String? ?? '',
      invitedUserId: data['invitedUserId'] as String? ?? '',
      invitedByUid: data['invitedByUid'] as String? ?? '',
      role: data['role'] as String? ?? 'member',
      status: InvitationStatus.fromValue(data['status'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, Object?> toFirestore() => {
    'workspaceId': workspaceId,
    'invitedUserId': invitedUserId,
    'invitedByUid': invitedByUid,
    'role': role,
    'status': status.name,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  InvitationEntity toEntity() {
    return InvitationEntity(
      id: id,
      workspaceId: workspaceId,
      invitedUserId: invitedUserId,
      invitedByUid: invitedByUid,
      role: role,
      status: status,
      createdAt: createdAt,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/workspace_member_entity.dart';

final class WorkspaceMemberDto extends WorkspaceMemberEntity {
  const WorkspaceMemberDto({
    required super.uid,
    required super.displayName,
    required super.joinedAt,
    super.email,
    super.role,
  });

  factory WorkspaceMemberDto.fromFirestore(
    DocumentSnapshot membershipDoc, {
    Map<String, Object?>? userData,
  }) {
    final membership = membershipDoc.data() as Map<String, dynamic>;
    final uid = membership['uid'] as String? ?? membershipDoc.id;
    final rawName = (userData?['name'] as String?)?.trim();
    final rawEmail = userData?['email'] as String?;

    return WorkspaceMemberDto(
      uid: uid,
      displayName: rawName != null && rawName.isNotEmpty ? rawName : uid,
      joinedAt:
          (membership['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      email: rawEmail,
      role: membership['role'] as String?,
    );
  }

  WorkspaceMemberEntity toEntity() {
    return WorkspaceMemberEntity(
      uid: uid,
      displayName: displayName,
      joinedAt: joinedAt,
      email: email,
      role: role,
    );
  }
}

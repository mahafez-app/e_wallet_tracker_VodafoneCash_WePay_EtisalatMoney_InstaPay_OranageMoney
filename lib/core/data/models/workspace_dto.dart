import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/workspace_entity.dart';

final class WorkspaceDto extends WorkspaceEntity {
  const WorkspaceDto({
    required super.id,
    required super.name,
    required super.ownerUid,
    required super.createdAt,
    super.totalReceived = 0.0,
    super.totalSent = 0.0,
    super.walletsCount = 0,
    super.latestActivityAt,
  });

  factory WorkspaceDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkspaceDto(
      id: doc.id,
      name: data['name'] as String? ?? 'Workspace',
      ownerUid: data['ownerUid'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalReceived: (data['totalReceived'] as num?)?.toDouble() ?? 0.0,
      totalSent: (data['totalSent'] as num?)?.toDouble() ?? 0.0,
      walletsCount: (data['walletsCount'] as num?)?.toInt() ?? 0,
      latestActivityAt: (data['latestActivityAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'ownerUid': ownerUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalReceived': totalReceived,
      'totalSent': totalSent,
      'walletsCount': walletsCount,
      if (latestActivityAt != null)
        'latestActivityAt': Timestamp.fromDate(latestActivityAt!),
    };
  }

  WorkspaceEntity toEntity() {
    return WorkspaceEntity(
      id: id,
      name: name,
      ownerUid: ownerUid,
      walletsCount: walletsCount,
      totalReceived: totalReceived,
      totalSent: totalSent,
      createdAt: createdAt,
      latestActivityAt: latestActivityAt,
    );
  }
}

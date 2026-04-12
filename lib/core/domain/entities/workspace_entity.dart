import 'package:equatable/equatable.dart';

class WorkspaceEntity extends Equatable {
  const WorkspaceEntity({
    required this.id,
    required this.name,
    required this.ownerUid,
    required this.walletsCount,
    required this.totalReceived,
    required this.totalSent,
    required this.createdAt,
    this.latestActivityAt,
  });

  final String id;
  final String name;
  final String ownerUid;
  final int walletsCount;
  final double totalReceived;
  final double totalSent;
  final DateTime createdAt;
  final DateTime? latestActivityAt;

  WorkspaceEntity copyWith({
    String? id,
    String? name,
    String? ownerUid,
    int? walletsCount,
    double? totalReceived,
    double? totalSent,
    DateTime? createdAt,
    DateTime? latestActivityAt,
  }) {
    return WorkspaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerUid: ownerUid ?? this.ownerUid,
      walletsCount: walletsCount ?? this.walletsCount,
      totalReceived: totalReceived ?? this.totalReceived,
      totalSent: totalSent ?? this.totalSent,
      createdAt: createdAt ?? this.createdAt,
      latestActivityAt: latestActivityAt ?? this.latestActivityAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ownerUid,
    walletsCount,
    totalReceived,
    totalSent,
    createdAt,
    latestActivityAt,
  ];
}

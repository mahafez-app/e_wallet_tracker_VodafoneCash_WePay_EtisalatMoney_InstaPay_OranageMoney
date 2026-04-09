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

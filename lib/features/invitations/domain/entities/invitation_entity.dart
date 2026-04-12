import 'package:equatable/equatable.dart';

import '../enums/invitation_status.dart';

class InvitationEntity extends Equatable {
  const InvitationEntity({
    required this.id,
    required this.workspaceId,
    required this.invitedUserId,
    required this.invitedByUid,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String workspaceId;
  final String invitedUserId;
  final String invitedByUid;
  final String role;
  final InvitationStatus status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    workspaceId,
    invitedUserId,
    invitedByUid,
    role,
    status,
    createdAt,
  ];
}

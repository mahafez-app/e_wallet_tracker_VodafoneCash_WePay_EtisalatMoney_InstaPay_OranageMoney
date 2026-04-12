import 'package:equatable/equatable.dart';

class WorkspacePendingInvitationEntity extends Equatable {
  const WorkspacePendingInvitationEntity({
    required this.id,
    required this.workspaceId,
    required this.email,
    required this.createdAt,
  });

  final String id;
  final String workspaceId;
  final String email;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, workspaceId, email, createdAt];
}

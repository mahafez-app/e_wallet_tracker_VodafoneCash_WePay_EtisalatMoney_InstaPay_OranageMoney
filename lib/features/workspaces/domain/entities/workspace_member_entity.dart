import 'package:equatable/equatable.dart';

class WorkspaceMemberEntity extends Equatable {
  const WorkspaceMemberEntity({
    required this.uid,
    required this.displayName,
    required this.joinedAt,
    this.email,
    this.role,
  });

  final String uid;
  final String displayName;
  final DateTime joinedAt;
  final String? email;
  final String? role;

  bool get isOwner => role == 'owner';

  @override
  List<Object?> get props => [uid, displayName, joinedAt, email, role];
}

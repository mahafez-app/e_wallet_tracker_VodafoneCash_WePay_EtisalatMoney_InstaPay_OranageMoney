import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
/// Clean architecture: no Firebase types here.
class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.nameConfirmed = true,
  });

  final String uid;
  final String name;
  final String? email;
  final DateTime createdAt;
  final bool nameConfirmed;

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? createdAt,
    bool? nameConfirmed,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      nameConfirmed: nameConfirmed ?? this.nameConfirmed,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, createdAt, nameConfirmed];
}

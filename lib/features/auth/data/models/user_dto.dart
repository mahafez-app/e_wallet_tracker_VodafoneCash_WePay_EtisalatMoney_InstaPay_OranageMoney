import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserDto extends UserEntity {
  const UserDto({
    required super.uid,
    required super.name,
    required super.email,
    required super.createdAt,
    super.nameConfirmed = true,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    uid: json['uid'] as String,
    name: json['name'] as String,
    email: json['email'] as String?,
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    nameConfirmed: json['nameConfirmed'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'createdAt': createdAt,
    'nameConfirmed': nameConfirmed,
  };

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      createdAt: createdAt,
      nameConfirmed: nameConfirmed,
    );
  }

  factory UserDto.fromEntity(UserEntity user) {
    return UserDto(
      uid: user.uid,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
      nameConfirmed: user.nameConfirmed,
    );
  }

  factory UserDto.createNew({
    required String uid,
    required String name,
    required String? email,
    List<String>? walletNumbers,
    bool nameConfirmed = true,
  }) {
    return UserDto(
      uid: uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      nameConfirmed: nameConfirmed,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.nameConfirmed = true,
  });

  final String uid;
  final String name;
  final String? email;
  @TimestampConverter()
  final Timestamp createdAt;
  @JsonKey(defaultValue: true)
  final bool nameConfirmed;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  AppUser toEntity() {
    return AppUser(
      uid: uid,
      name: name,
      email: email,
      createdAt: createdAt.toDate(),
      nameConfirmed: nameConfirmed,
    );
  }

  factory UserDto.fromEntity(AppUser user) {
    return UserDto(
      uid: user.uid,
      name: user.name,
      email: user.email,
      createdAt: Timestamp.fromDate(user.createdAt),
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
      createdAt: Timestamp.now(),
      nameConfirmed: nameConfirmed,
    );
  }
}

class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  Timestamp fromJson(dynamic json) {
    if (json is Timestamp) return json;
    if (json is Map<String, dynamic>) {
      return Timestamp(json['_seconds'] as int, json['_nanoseconds'] as int);
    }
    throw ArgumentError('Cannot convert $json to Timestamp');
  }

  @override
  dynamic toJson(Timestamp object) => object;
}

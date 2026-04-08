import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.createdAt,
    this.walletNumbers = const [],
    this.nameConfirmed = true,
  });

  final String uid;
  final String displayName;
  final String? email;
  final List<String> walletNumbers;
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
      displayName: displayName,
      email: email,
      walletNumbers: walletNumbers,
      createdAt: createdAt.toDate(),
      nameConfirmed: nameConfirmed,
    );
  }

  factory UserDto.fromEntity(AppUser user) {
    return UserDto(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      walletNumbers: user.walletNumbers,
      createdAt: Timestamp.fromDate(user.createdAt),
      nameConfirmed: user.nameConfirmed,
    );
  }

  factory UserDto.createNew({
    required String uid,
    required String displayName,
    required String? email,
    List<String>? walletNumbers,
    bool nameConfirmed = true,
  }) {
    return UserDto(
      uid: uid,
      displayName: displayName,
      email: email,
      walletNumbers: walletNumbers ?? [],
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

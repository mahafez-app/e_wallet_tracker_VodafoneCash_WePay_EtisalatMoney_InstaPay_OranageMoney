import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_user.dart';

part 'user_dto.g.dart';

/// Data Transfer Object for user profile in Firestore.
/// Handles Firebase types (Timestamp) and JSON serialization.
@JsonSerializable()
class UserDto {
  const UserDto({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.isAndroid,
    required this.nameConfirmed,
    required this.preferredLocale,
    required this.preferredTheme,
    required this.createdAt,
    this.walletNumber,
    this.photoUrl,
  });

  final String uid;
  final String displayName;
  final String? email;
  final String? walletNumber;
  final bool isAndroid;
  final bool nameConfirmed;
  final String preferredLocale;
  final String preferredTheme;
  @TimestampConverter()
  final Timestamp createdAt;
  final String? photoUrl;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  /// Convert DTO to domain entity.
  AppUser toEntity() {
    return AppUser(
      uid: uid,
      displayName: displayName,
      email: email,
      walletNumber: walletNumber,
      isAndroid: isAndroid,
      nameConfirmed: nameConfirmed,
      preferredLocale: preferredLocale,
      preferredTheme: preferredTheme,
      createdAt: createdAt.toDate(),
      photoUrl: photoUrl,
    );
  }

  /// Create DTO from domain entity.
  factory UserDto.fromEntity(AppUser user) {
    return UserDto(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      walletNumber: user.walletNumber,
      isAndroid: user.isAndroid,
      nameConfirmed: user.nameConfirmed,
      preferredLocale: user.preferredLocale,
      preferredTheme: user.preferredTheme,
      createdAt: Timestamp.fromDate(user.createdAt),
      photoUrl: user.photoUrl,
    );
  }

  /// Create DTO for new user.
  factory UserDto.createNew({
    required String uid,
    required String displayName,
    required String? email,
    required bool isAndroid,
    String? walletNumber,
    String? photoUrl,
  }) {
    return UserDto(
      uid: uid,
      displayName: displayName,
      email: email,
      walletNumber: walletNumber,
      isAndroid: isAndroid,
      nameConfirmed: false,
      preferredLocale: 'system',
      preferredTheme: 'system',
      createdAt: Timestamp.now(),
      photoUrl: photoUrl,
    );
  }
}

/// Custom converter for Firestore Timestamp.
class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  Timestamp fromJson(dynamic json) {
    if (json is Timestamp) {
      return json;
    }
    if (json is Map<String, dynamic>) {
      return Timestamp(json['_seconds'] as int, json['_nanoseconds'] as int);
    }
    throw ArgumentError('Cannot convert $json to Timestamp');
  }

  @override
  dynamic toJson(Timestamp object) => object;
}

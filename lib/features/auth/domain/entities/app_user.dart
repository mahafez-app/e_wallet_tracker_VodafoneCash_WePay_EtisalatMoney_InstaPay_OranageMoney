import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
/// Clean architecture: no Firebase types here.
final class AppUser extends Equatable {
  const AppUser({
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
  final DateTime createdAt;
  final String? photoUrl;

  AppUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? walletNumber,
    bool? isAndroid,
    bool? nameConfirmed,
    String? preferredLocale,
    String? preferredTheme,
    DateTime? createdAt,
    String? photoUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      walletNumber: walletNumber ?? this.walletNumber,
      isAndroid: isAndroid ?? this.isAndroid,
      nameConfirmed: nameConfirmed ?? this.nameConfirmed,
      preferredLocale: preferredLocale ?? this.preferredLocale,
      preferredTheme: preferredTheme ?? this.preferredTheme,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    displayName,
    email,
    walletNumber,
    isAndroid,
    nameConfirmed,
    preferredLocale,
    preferredTheme,
    createdAt,
    photoUrl,
  ];
}

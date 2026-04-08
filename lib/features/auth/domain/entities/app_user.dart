import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
/// Clean architecture: no Firebase types here.
final class AppUser extends Equatable {
  const AppUser({
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
  final DateTime createdAt;
  final bool nameConfirmed;

  AppUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    List<String>? walletNumbers,
    DateTime? createdAt,
    bool? nameConfirmed,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      walletNumbers: walletNumbers ?? this.walletNumbers,
      createdAt: createdAt ?? this.createdAt,
      nameConfirmed: nameConfirmed ?? this.nameConfirmed,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    displayName,
    email,
    walletNumbers,
    createdAt,
    nameConfirmed,
  ];
}

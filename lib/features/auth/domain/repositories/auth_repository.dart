import '../entities/app_user.dart';
import '../../../../core/error/result.dart';

/// Repository interface for authentication operations.
/// Domain layer contract — data layer implements it.
abstract interface class AuthRepository {
  /// Stream of current authenticated user state.
  /// Returns null when user is signed out.
  Stream<AppUser?> get authStateChanges;

  /// Get current user synchronously (if available).
  /// Returns null if no user is signed in.
  AppUser? get currentUser;

  /// Sign in with Google OAuth.
  Future<Result<AppUser>> signInWithGoogle();

  /// Sign in with email and password.
  Future<Result<AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Create new account with email and password.
  Future<Result<AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Update user's display name in Firebase Auth and Firestore.
  Future<Result<void>> updateDisplayName({
    required String uid,
    required String displayName,
  });

  /// Mark user name as confirmed in Firestore.
  Future<Result<void>> confirmUserName({
    required String uid,
    required String displayName,
  });

  /// Update user preferences (locale, theme) in Firestore.
  Future<Result<void>> updateUserPreferences({
    required String uid,
    String? preferredLocale,
    String? preferredTheme,
  });

  /// Update wallet number (Android only).
  Future<Result<void>> updateWalletNumber({
    required String uid,
    required String walletNumber,
  });

  /// Sign out current user.
  Future<Result<void>> signOut();

  /// Get user profile from Firestore by UID.
  Future<Result<AppUser>> getUserProfile(String uid);
}

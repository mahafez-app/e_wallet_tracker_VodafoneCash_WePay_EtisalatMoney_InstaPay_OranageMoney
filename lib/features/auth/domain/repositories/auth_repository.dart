import '../../../../core/error/result.dart';
import '../entities/app_user.dart';

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

  /// Update wallet numbers (Android only).
  Future<Result<void>> updateWalletNumbers({
    required String uid,
    required List<String> walletNumbers,
  });

  /// Sign out current user.
  Future<Result<void>> signOut();

  /// Get user profile from Firestore by UID.
  Future<Result<AppUser>> getUserProfile(String uid);
}

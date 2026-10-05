import 'package:mahafez_core/mahafez_core.dart';
import '../entities/user_entity.dart';

/// Repository interface for authentication operations.
/// Domain layer contract — data layer implements it.
abstract interface class AuthRepository {
  /// Stream of current authenticated user state.
  /// Returns null when user is signed out.
  Stream<UserEntity?> get authStateChanges;

  /// Get current user synchronously (if available).
  /// Returns null if no user is signed in.
  UserEntity? get currentUser;

  /// Sign in with Google OAuth.
  Future<Result<UserEntity>> signInWithGoogle();

  /// Sign in with email and password.
  Future<Result<UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Create new account with email and password.
  Future<Result<UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Update user's display name in Firebase Auth and Firestore.
  Future<Result<void>> updateDisplayName({
    required String uid,
    required String displayName,
  });

  /// Sign out current user.
  Future<Result<void>> signOut();

  /// Get user profile from Firestore by UID.
  Future<Result<UserEntity>> getUserProfile(String uid);
}

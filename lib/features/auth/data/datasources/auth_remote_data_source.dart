import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_dto.dart';

/// Remote data source for authentication operations.
/// Handles Firebase Auth and Firestore operations.
abstract interface class AuthRemoteDataSource {
  Stream<UserDto?> get authStateChanges;
  UserDto? get currentUser;

  Future<UserDto> signInWithGoogle();
  Future<UserDto> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserDto> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });
  Future<void> updateDisplayName({
    required String uid,
    required String displayName,
  });
  Future<void> confirmUserName({
    required String uid,
    required String displayName,
  });
  Future<void> updateUserPreferences({
    required String uid,
    String? preferredLocale,
    String? preferredTheme,
  });
  Future<void> updateWalletNumber({
    required String uid,
    required String walletNumber,
  });
  Future<void> signOut();
  Future<UserDto> getUserProfile(String uid);
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  static const String _usersCollection = 'users';

  @override
  Stream<UserDto?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        return await getUserProfile(firebaseUser.uid);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  UserDto? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    // Note: This returns a synchronous snapshot. For full profile, use getUserProfile.
    return _mapFirebaseUserToDto(firebaseUser);
  }

  @override
  Future<UserDto> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In cancelled by user');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Failed to get user from Firebase Auth');
    }

    return await _createOrUpdateUserProfile(firebaseUser);
  }

  @override
  Future<UserDto> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw Exception('Failed to get user from Firebase Auth');
    }

    return await getUserProfile(firebaseUser.uid);
  }

  @override
  Future<UserDto> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw Exception('Failed to create user in Firebase Auth');
    }

    await firebaseUser.updateDisplayName(displayName);
    await firebaseUser.reload();

    return await _createOrUpdateUserProfile(firebaseUser);
  }

  @override
  Future<void> updateDisplayName({
    required String uid,
    required String displayName,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && firebaseUser.uid == uid) {
      await firebaseUser.updateDisplayName(displayName);
    }

    await _firestore.collection(_usersCollection).doc(uid).update({
      'displayName': displayName,
    });
  }

  @override
  Future<void> confirmUserName({
    required String uid,
    required String displayName,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && firebaseUser.uid == uid) {
      await firebaseUser.updateDisplayName(displayName);
    }

    await _firestore.collection(_usersCollection).doc(uid).update({
      'displayName': displayName,
      'nameConfirmed': true,
    });
  }

  @override
  Future<void> updateUserPreferences({
    required String uid,
    String? preferredLocale,
    String? preferredTheme,
  }) async {
    final updates = <String, dynamic>{};
    if (preferredLocale != null) updates['preferredLocale'] = preferredLocale;
    if (preferredTheme != null) updates['preferredTheme'] = preferredTheme;

    if (updates.isNotEmpty) {
      await _firestore.collection(_usersCollection).doc(uid).update(updates);
    }
  }

  @override
  Future<void> updateWalletNumber({
    required String uid,
    required String walletNumber,
  }) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'walletNumber': walletNumber,
    });
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Future<UserDto> getUserProfile(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('User profile not found');
    }

    return UserDto.fromJson({'uid': uid, ...doc.data()!});
  }

  /// Create or update user profile in Firestore from Firebase User.
  Future<UserDto> _createOrUpdateUserProfile(User firebaseUser) async {
    final userDoc = _firestore
        .collection(_usersCollection)
        .doc(firebaseUser.uid);
    final docSnapshot = await userDoc.get();

    final isAndroid = Platform.isAndroid;

    if (!docSnapshot.exists) {
      // Create new user profile
      final newUser = UserDto.createNew(
        uid: firebaseUser.uid,
        displayName: firebaseUser.displayName ?? '',
        email: firebaseUser.email,
        isAndroid: isAndroid,
        photoUrl: firebaseUser.photoURL,
      );

      await userDoc.set(newUser.toJson());
      return newUser;
    } else {
      // Update existing user if needed
      final updates = <String, dynamic>{};
      if (firebaseUser.displayName != null) {
        updates['displayName'] = firebaseUser.displayName;
      }
      if (firebaseUser.photoURL != null) {
        updates['photoUrl'] = firebaseUser.photoURL;
      }

      if (updates.isNotEmpty) {
        await userDoc.update(updates);
      }

      return await getUserProfile(firebaseUser.uid);
    }
  }

  /// Map Firebase User to UserDto (basic mapping without Firestore fetch).
  UserDto _mapFirebaseUserToDto(User firebaseUser) {
    return UserDto.createNew(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? '',
      email: firebaseUser.email,
      isAndroid: Platform.isAndroid,
      photoUrl: firebaseUser.photoURL,
    );
  }
}

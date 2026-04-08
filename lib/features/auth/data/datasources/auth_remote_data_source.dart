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
  Future<void> updateWalletNumbers({
    required String uid,
    required List<String> walletNumbers,
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
    return _firebaseAuth.authStateChanges().asyncExpand((firebaseUser) async* {
      if (firebaseUser == null) {
        yield null;
        return;
      }
      
      // Listen to Firestore document changes for realtime profile updates
      yield* _firestore
          .collection(_usersCollection)
          .doc(firebaseUser.uid)
          .snapshots()
          // Only emit when the profile has been successfully created
          .where((doc) => doc.exists && doc.data() != null)
          .map((doc) => UserDto.fromJson({'uid': firebaseUser.uid, ...doc.data()!}));
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

    return await _createOrUpdateUserProfile(
        _firebaseAuth.currentUser ?? firebaseUser,
        providedDisplayName: displayName);
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
      'nameConfirmed': true,
    });
  }

  @override
  Future<void> updateWalletNumbers({
    required String uid,
    required List<String> walletNumbers,
  }) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'walletNumbers': walletNumbers,
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
  Future<UserDto> _createOrUpdateUserProfile(
    User firebaseUser, {
    String? providedDisplayName,
  }) async {
    final userDoc = _firestore
        .collection(_usersCollection)
        .doc(firebaseUser.uid);
    final docSnapshot = await userDoc.get();

    final effDisplayName = providedDisplayName ?? firebaseUser.displayName ?? '';

    if (!docSnapshot.exists) {
      // Create new user profile
      // If providedDisplayName is null (Google sign-in), force them to confirm name.
      final newUser = UserDto.createNew(
        uid: firebaseUser.uid,
        name: effDisplayName,
        email: firebaseUser.email,
        nameConfirmed: providedDisplayName != null,
      );

      await userDoc.set(newUser.toJson());
      return newUser;
    } else {
      // Return the existing
      return await getUserProfile(firebaseUser.uid);
    }
  }

  /// Map Firebase User to UserDto (basic mapping without Firestore fetch).
  UserDto _mapFirebaseUserToDto(User firebaseUser) {
    return UserDto.createNew(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email,
    );
  }
}

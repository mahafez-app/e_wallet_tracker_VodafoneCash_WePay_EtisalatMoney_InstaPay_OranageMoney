import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/confirm_user_name_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/sign_in_with_email_password_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_password_usecase.dart';

/// Google Sign-In instance provider
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

/// Auth remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

// ========== Use Cases ==========

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>(
  (ref) => SignInWithGoogleUseCase(ref.watch(authRepositoryProvider)),
);

final signInWithEmailPasswordUseCaseProvider =
    Provider<SignInWithEmailPasswordUseCase>(
      (ref) =>
          SignInWithEmailPasswordUseCase(ref.watch(authRepositoryProvider)),
    );

final signUpWithEmailPasswordUseCaseProvider =
    Provider<SignUpWithEmailPasswordUseCase>(
      (ref) =>
          SignUpWithEmailPasswordUseCase(ref.watch(authRepositoryProvider)),
    );

final confirmUserNameUseCaseProvider = Provider<ConfirmUserNameUseCase>(
  (ref) => ConfirmUserNameUseCase(ref.watch(authRepositoryProvider)),
);

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>(
  (ref) => GetUserProfileUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

// ========== Auth State ==========

/// Stream of authenticated user state changes.
/// Returns null when signed out, AppUser when signed in.
final authStateChangesProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

/// Current authenticated user (synchronous).
/// Returns null if no user is signed in.
final currentUserProvider = Provider<AppUser?>((ref) {
  // Watch the stream to keep this provider reactive
  ref.watch(authStateChangesProvider);
  return ref.watch(authRepositoryProvider).currentUser;
});

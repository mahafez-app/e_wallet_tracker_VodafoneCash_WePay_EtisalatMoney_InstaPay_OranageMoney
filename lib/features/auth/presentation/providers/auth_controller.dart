import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_with_email_password_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_password_usecase.dart';
import '../../domain/usecases/update_display_name_usecase.dart';
import '../../providers/auth_providers.dart';

enum AuthLoadingMethod { none, email, google, confirmName }

final class AuthState {
  const AuthState({this.loadingMethod = AuthLoadingMethod.none, this.error});

  final AuthLoadingMethod loadingMethod;
  final Failure? error;

  bool get isLoading => loadingMethod != AuthLoadingMethod.none;

  AuthState copyWith({AuthLoadingMethod? loadingMethod, Failure? error}) {
    return AuthState(
      loadingMethod: loadingMethod ?? this.loadingMethod,
      error: error ?? this.error,
    );
  }

  AuthState clearError() {
    return AuthState(loadingMethod: loadingMethod, error: null);
  }
}

final class AuthController extends Notifier<AuthState> {
  AuthController();

  late final SignInWithGoogleUseCase _signInWithGoogle;
  late final SignInWithEmailPasswordUseCase _signInWithEmailPassword;
  late final SignUpWithEmailPasswordUseCase _signUpWithEmailPassword;
  late final UpdateDisplayNameUseCase _updateDisplayName;
  late final SignOutUseCase _signOut;

  @override
  AuthState build() {
    _signInWithGoogle = ref.read(signInWithGoogleUseCaseProvider);
    _signInWithEmailPassword = ref.read(signInWithEmailPasswordUseCaseProvider);
    _signUpWithEmailPassword = ref.read(signUpWithEmailPasswordUseCaseProvider);
    _updateDisplayName = ref.read(updateDisplayNameUseCaseProvider);
    _signOut = ref.read(signOutUseCaseProvider);

    return const AuthState();
  }

  void clearError() {
    state = state.clearError();
  }

  Future<Result<UserEntity>> signInWithGoogle() async {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.google,
      error: null,
    );

    final result = await _signInWithGoogle();

    result.fold(
      (failure) {
        state = state.copyWith(
          loadingMethod: AuthLoadingMethod.none,
          error: failure,
        );
      },
      (_) {
        state = state.copyWith(loadingMethod: AuthLoadingMethod.none);
      },
    );

    return result;
  }

  Future<Result<UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(loadingMethod: AuthLoadingMethod.email, error: null);

    final result = await _signInWithEmailPassword(
      SignInWithEmailPasswordParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          loadingMethod: AuthLoadingMethod.none,
          error: failure,
        );
      },
      (_) {
        state = state.copyWith(loadingMethod: AuthLoadingMethod.none);
      },
    );

    return result;
  }

  Future<Result<UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(loadingMethod: AuthLoadingMethod.email, error: null);

    final result = await _signUpWithEmailPassword(
      SignUpWithEmailPasswordParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          loadingMethod: AuthLoadingMethod.none,
          error: failure,
        );
      },
      (_) {
        state = state.copyWith(loadingMethod: AuthLoadingMethod.none);
      },
    );

    return result;
  }

  Future<Result<void>> updateDisplayName({
    required String uid,
    required String displayName,
  }) async {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.confirmName,
      error: null,
    );

    final result = await _updateDisplayName(
      UpdateDisplayNameParams(uid: uid, displayName: displayName),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          loadingMethod: AuthLoadingMethod.none,
          error: failure,
        );
      },
      (_) {
        state = state.copyWith(loadingMethod: AuthLoadingMethod.none);
      },
    );

    return result;
  }

  Future<Result<void>> signOut() async {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.none,
      error: null,
    ); // signOut handled locally without massive spinner on login screens normally

    final result = await _signOut();

    result.fold(
      (failure) {
        state = state.copyWith(
          loadingMethod: AuthLoadingMethod.none,
          error: failure,
        );
      },
      (_) {
        state = state.copyWith(loadingMethod: AuthLoadingMethod.none);
      },
    );

    return result;
  }
}

final authNotifierProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

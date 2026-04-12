import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/sign_in_with_email_password_usecase.dart';
import '../../domain/usecases/sign_up_with_email_password_usecase.dart';
import '../../domain/usecases/update_display_name_usecase.dart';
import '../../providers/auth_providers.dart';

enum AuthLoadingMethod { none, email, google, confirmName, signOut }

const _unsetFailure = Object();

final class AuthState {
  const AuthState({this.loadingMethod = AuthLoadingMethod.none, this.error});

  final AuthLoadingMethod loadingMethod;
  final Failure? error;

  bool get isLoading => loadingMethod != AuthLoadingMethod.none;

  AuthState copyWith({
    AuthLoadingMethod? loadingMethod,
    Object? error = _unsetFailure,
  }) {
    return AuthState(
      loadingMethod: loadingMethod ?? this.loadingMethod,
      error: identical(error, _unsetFailure) ? this.error : error as Failure?,
    );
  }

  AuthState clearError() => AuthState(loadingMethod: loadingMethod);
}

final authNotifierProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void clearError() {
    state = state.clearError();
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.google,
      error: null,
    );
    final result = await ref.read(signInWithGoogleUseCaseProvider)();
    result.fold(
      (failure) => state = state.copyWith(
        loadingMethod: AuthLoadingMethod.none,
        error: failure,
      ),
      (_) => state = state.copyWith(loadingMethod: AuthLoadingMethod.none),
    );
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(loadingMethod: AuthLoadingMethod.email, error: null);
    final result = await ref.read(signInWithEmailPasswordUseCaseProvider)(
      SignInWithEmailPasswordParams(email: email, password: password),
    );
    result.fold(
      (failure) => state = state.copyWith(
        loadingMethod: AuthLoadingMethod.none,
        error: failure,
      ),
      (_) => state = state.copyWith(loadingMethod: AuthLoadingMethod.none),
    );
  }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(loadingMethod: AuthLoadingMethod.email, error: null);
    final result = await ref.read(signUpWithEmailPasswordUseCaseProvider)(
      SignUpWithEmailPasswordParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
    result.fold(
      (failure) => state = state.copyWith(
        loadingMethod: AuthLoadingMethod.none,
        error: failure,
      ),
      (_) => state = state.copyWith(loadingMethod: AuthLoadingMethod.none),
    );
  }

  Future<void> updateDisplayName({
    required String uid,
    required String displayName,
  }) async {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.confirmName,
      error: null,
    );
    final result = await ref.read(updateDisplayNameUseCaseProvider)(
      UpdateDisplayNameParams(uid: uid, displayName: displayName),
    );
    result.fold(
      (failure) => state = state.copyWith(
        loadingMethod: AuthLoadingMethod.none,
        error: failure,
      ),
      (_) => state = state.copyWith(loadingMethod: AuthLoadingMethod.none),
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.signOut,
      error: null,
    );
    final result = await ref.read(signOutUseCaseProvider)();
    result.fold(
      (failure) => state = state.copyWith(
        loadingMethod: AuthLoadingMethod.none,
        error: failure,
      ),
      (_) => state = state.copyWith(loadingMethod: AuthLoadingMethod.none),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
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
    await _performAuthAction(
      loadingMethod: AuthLoadingMethod.google,
      operation: () => ref.read(signInWithGoogleUseCaseProvider)(),
    );
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _performAuthAction(
      loadingMethod: AuthLoadingMethod.email,
      operation: () => ref.read(signInWithEmailPasswordUseCaseProvider)(
        SignInWithEmailPasswordParams(email: email, password: password),
      ),
    );
  }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _performAuthAction(
      loadingMethod: AuthLoadingMethod.email,
      operation: () => ref.read(signUpWithEmailPasswordUseCaseProvider)(
        SignUpWithEmailPasswordParams(
          email: email,
          password: password,
          displayName: displayName,
        ),
      ),
    );
  }

  Future<void> updateDisplayName({
    required String uid,
    required String displayName,
  }) async {
    await _performAuthAction(
      loadingMethod: AuthLoadingMethod.confirmName,
      operation: () => ref.read(updateDisplayNameUseCaseProvider)(
        UpdateDisplayNameParams(uid: uid, displayName: displayName),
      ),
    );
  }

  Future<void> signOut() async {
    await _performAuthAction(
      loadingMethod: AuthLoadingMethod.signOut,
      operation: () => ref.read(signOutUseCaseProvider)(),
    );
  }

  Future<void> _performAuthAction<T>({
    required AuthLoadingMethod loadingMethod,
    required Future<Result<T>> Function() operation,
  }) async {
    state = state.copyWith(loadingMethod: loadingMethod, error: null);
    final result = await operation();
    result.fold(_finishWithFailure, (_) => _finishWithoutFailure());
  }

  void _finishWithFailure(Failure failure) {
    state = state.copyWith(
      loadingMethod: AuthLoadingMethod.none,
      error: failure,
    );
  }

  void _finishWithoutFailure() {
    state = state.copyWith(loadingMethod: AuthLoadingMethod.none);
  }
}

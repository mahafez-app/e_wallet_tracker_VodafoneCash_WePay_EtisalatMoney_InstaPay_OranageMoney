import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

final class SignInWithEmailPasswordParams {
  const SignInWithEmailPasswordParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

final class SignInWithEmailPasswordUseCase
    implements UseCase<AppUser, SignInWithEmailPasswordParams> {
  const SignInWithEmailPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call(SignInWithEmailPasswordParams params) {
    return _repository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

final class SignUpWithEmailPasswordParams {
  const SignUpWithEmailPasswordParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;
}

final class SignUpWithEmailPasswordUseCase
    implements UseCase<AppUser, SignUpWithEmailPasswordParams> {
  const SignUpWithEmailPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call(SignUpWithEmailPasswordParams params) {
    return _repository.signUpWithEmailPassword(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}

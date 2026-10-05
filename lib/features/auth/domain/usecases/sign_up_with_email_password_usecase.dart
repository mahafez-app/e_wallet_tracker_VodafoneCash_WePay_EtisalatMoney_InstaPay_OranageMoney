import 'package:mahafez_core/mahafez_core.dart';
import '../entities/user_entity.dart';
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
    implements UseCase<UserEntity, SignUpWithEmailPasswordParams> {
  const SignUpWithEmailPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(SignUpWithEmailPasswordParams params) {
    return _repository.signUpWithEmailPassword(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}

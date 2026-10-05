import 'package:mahafez_core/mahafez_core.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

final class SignInWithGoogleUseCase implements NoParamsUseCase<UserEntity> {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call() => _repository.signInWithGoogle();
}

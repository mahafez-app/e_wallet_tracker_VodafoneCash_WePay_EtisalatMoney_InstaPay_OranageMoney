import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

final class SignInWithGoogleUseCase implements NoParamsUseCase<AppUser> {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call() => _repository.signInWithGoogle();
}

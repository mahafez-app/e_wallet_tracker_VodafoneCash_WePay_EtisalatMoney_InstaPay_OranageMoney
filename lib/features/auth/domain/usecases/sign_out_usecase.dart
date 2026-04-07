import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

final class SignOutUseCase implements NoParamsUseCase<void> {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call() => _repository.signOut();
}

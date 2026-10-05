import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/auth_repository.dart';

final class SignOutUseCase implements NoParamsUseCase<void> {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call() => _repository.signOut();
}

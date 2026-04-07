import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

final class ConfirmUserNameParams {
  const ConfirmUserNameParams({required this.uid, required this.displayName});

  final String uid;
  final String displayName;
}

final class ConfirmUserNameUseCase
    implements UseCase<void, ConfirmUserNameParams> {
  const ConfirmUserNameUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ConfirmUserNameParams params) {
    return _repository.confirmUserName(
      uid: params.uid,
      displayName: params.displayName,
    );
  }
}

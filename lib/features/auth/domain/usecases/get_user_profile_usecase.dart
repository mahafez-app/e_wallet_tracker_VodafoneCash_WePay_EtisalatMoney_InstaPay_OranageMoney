import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

final class GetUserProfileParams {
  const GetUserProfileParams(this.uid);

  final String uid;
}

final class GetUserProfileUseCase
    implements UseCase<AppUser, GetUserProfileParams> {
  const GetUserProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call(GetUserProfileParams params) {
    return _repository.getUserProfile(params.uid);
  }
}

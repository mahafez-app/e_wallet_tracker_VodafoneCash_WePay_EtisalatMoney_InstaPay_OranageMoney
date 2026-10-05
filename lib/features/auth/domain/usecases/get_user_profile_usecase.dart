import 'package:mahafez_core/mahafez_core.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

final class GetUserProfileParams {
  const GetUserProfileParams(this.uid);

  final String uid;
}

final class GetUserProfileUseCase
    implements UseCase<UserEntity, GetUserProfileParams> {
  const GetUserProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(GetUserProfileParams params) {
    return _repository.getUserProfile(params.uid);
  }
}

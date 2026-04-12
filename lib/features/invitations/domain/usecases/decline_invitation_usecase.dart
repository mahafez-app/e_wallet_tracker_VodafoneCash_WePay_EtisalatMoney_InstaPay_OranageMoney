import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/invitations_repository.dart';

class DeclineInvitationUseCase implements UseCase<void, String> {
  const DeclineInvitationUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.declineInvitation(params);
  }
}

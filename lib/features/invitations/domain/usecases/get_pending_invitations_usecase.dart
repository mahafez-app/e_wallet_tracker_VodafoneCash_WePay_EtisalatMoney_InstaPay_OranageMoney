import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/invitation_entity.dart';
import '../repositories/invitations_repository.dart';

class GetPendingInvitationsUseCase
    implements NoParamsUseCase<List<InvitationEntity>> {
  const GetPendingInvitationsUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<List<InvitationEntity>>> call() {
    return _repository.getPendingInvitations();
  }
}

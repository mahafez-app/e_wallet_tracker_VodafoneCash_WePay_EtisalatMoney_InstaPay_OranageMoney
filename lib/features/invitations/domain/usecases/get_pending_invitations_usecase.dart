import 'package:mahafez_core/mahafez_core.dart';
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

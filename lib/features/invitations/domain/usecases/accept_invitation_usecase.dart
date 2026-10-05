import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/invitations_repository.dart';

class AcceptInvitationUseCase implements UseCase<void, String> {
  const AcceptInvitationUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.acceptInvitation(params);
  }
}

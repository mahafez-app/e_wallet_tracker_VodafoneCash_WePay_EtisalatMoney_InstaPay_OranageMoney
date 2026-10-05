import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/invitations_repository.dart';

class DeclineInvitationUseCase implements UseCase<void, String> {
  const DeclineInvitationUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.declineInvitation(params);
  }
}

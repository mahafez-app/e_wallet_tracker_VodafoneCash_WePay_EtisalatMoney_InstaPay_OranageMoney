import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/invitations_repository.dart';

class CancelInvitationUseCase implements UseCase<void, String> {
  const CancelInvitationUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.cancelInvitation(params);
  }
}

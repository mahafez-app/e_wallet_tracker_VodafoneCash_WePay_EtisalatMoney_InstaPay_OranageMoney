import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/invitations_repository.dart';

class CreateInvitationParams {
  const CreateInvitationParams({
    required this.workspaceId,
    required this.email,
  });

  final String workspaceId;
  final String email;
}

class CreateInvitationUseCase implements UseCase<void, CreateInvitationParams> {
  const CreateInvitationUseCase(this._repository);

  final InvitationsRepository _repository;

  @override
  Future<Result<void>> call(CreateInvitationParams params) {
    return _repository.createInvitation(
      workspaceId: params.workspaceId,
      email: params.email,
    );
  }
}

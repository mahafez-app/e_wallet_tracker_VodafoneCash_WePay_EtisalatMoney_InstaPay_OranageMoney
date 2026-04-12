import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/datasources/invitations_remote_data_source.dart';
import '../data/repositories/invitations_repository_impl.dart';
import '../domain/repositories/invitations_repository.dart';
import '../domain/usecases/accept_invitation_usecase.dart';
import '../domain/usecases/create_invitation_usecase.dart';
import '../domain/usecases/decline_invitation_usecase.dart';
import '../domain/usecases/get_pending_invitations_usecase.dart';
import '../domain/usecases/get_recent_responded_invitations_usecase.dart';

final invitationsRemoteDataSourceProvider =
    Provider<InvitationsRemoteDataSource>(
      (ref) => InvitationsRemoteDataSourceImpl(
        firestore: ref.watch(firestoreProvider),
        auth: ref.watch(firebaseAuthProvider),
      ),
    );

final invitationsRepositoryProvider = Provider<InvitationsRepository>(
  (ref) => InvitationsRepositoryImpl(
    remote: ref.watch(invitationsRemoteDataSourceProvider),
  ),
);

final createInvitationUseCaseProvider = Provider<CreateInvitationUseCase>(
  (ref) => CreateInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);

final getPendingInvitationsUseCaseProvider =
    Provider<GetPendingInvitationsUseCase>(
      (ref) => GetPendingInvitationsUseCase(
        ref.watch(invitationsRepositoryProvider),
      ),
    );

final getRecentRespondedInvitationsUseCaseProvider =
    Provider<GetRecentRespondedInvitationsUseCase>(
      (ref) => GetRecentRespondedInvitationsUseCase(
        ref.watch(invitationsRepositoryProvider),
      ),
    );

final acceptInvitationUseCaseProvider = Provider<AcceptInvitationUseCase>(
  (ref) => AcceptInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);

final declineInvitationUseCaseProvider = Provider<DeclineInvitationUseCase>(
  (ref) => DeclineInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);

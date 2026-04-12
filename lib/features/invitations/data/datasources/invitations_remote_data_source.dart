import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/invitation_dto.dart';
import 'invitation_remote_command_service.dart';
import 'invitation_remote_query_service.dart';

abstract interface class InvitationsRemoteDataSource {
  Future<void> createInvitation({
    required String workspaceId,
    required String email,
  });

  Future<List<InvitationDto>> getPendingInvitations();

  Future<List<InvitationDto>> getRecentRespondedInvitations();

  Future<void> acceptInvitation(String invitationId);

  Future<void> declineInvitation(String invitationId);
}

class InvitationsRemoteDataSourceImpl implements InvitationsRemoteDataSource {
  factory InvitationsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) {
    final queryService = InvitationRemoteQueryService(
      firestore: firestore,
      auth: auth,
    );
    return InvitationsRemoteDataSourceImpl._(
      queryService: queryService,
      commandService: InvitationRemoteCommandService(
        firestore: firestore,
        queryService: queryService,
      ),
    );
  }

  const InvitationsRemoteDataSourceImpl._({
    required InvitationRemoteQueryService queryService,
    required InvitationRemoteCommandService commandService,
  }) : _queryService = queryService,
       _commandService = commandService;

  final InvitationRemoteQueryService _queryService;
  final InvitationRemoteCommandService _commandService;

  @override
  Future<void> createInvitation({
    required String workspaceId,
    required String email,
  }) {
    return _commandService.createInvitation(
      workspaceId: workspaceId,
      email: email,
    );
  }

  @override
  Future<List<InvitationDto>> getPendingInvitations() {
    return _queryService.getPendingInvitations();
  }

  @override
  Future<List<InvitationDto>> getRecentRespondedInvitations() {
    return _queryService.getRecentRespondedInvitations();
  }

  @override
  Future<void> acceptInvitation(String invitationId) {
    return _commandService.respondToInvitation(
      invitationId: invitationId,
      accept: true,
    );
  }

  @override
  Future<void> declineInvitation(String invitationId) {
    return _commandService.respondToInvitation(
      invitationId: invitationId,
      accept: false,
    );
  }
}

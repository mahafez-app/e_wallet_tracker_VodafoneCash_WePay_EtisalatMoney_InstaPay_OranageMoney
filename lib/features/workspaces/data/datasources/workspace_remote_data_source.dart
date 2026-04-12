import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/models/workspace_dto.dart';
import '../../../../core/error/failures.dart';

abstract interface class WorkspaceRemoteDataSource {
  Future<WorkspaceDto> createWorkspace({required String name});
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  const WorkspaceRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<WorkspaceDto> createWorkspace({required String name}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in.');
    }

    final workspaceRef = _firestore.collection('workspaces').doc();
    final memberRef = workspaceRef.collection('members').doc(currentUser.uid);
    final batch = _firestore.batch();
    final now = DateTime.now();

    final workspaceDto = WorkspaceDto(
      id: workspaceRef.id,
      name: name.trim(),
      ownerUid: currentUser.uid,
      walletsCount: 0,
      totalReceived: 0,
      totalSent: 0,
      createdAt: now,
    );

    batch.set(workspaceRef, workspaceDto.toFirestore());
    batch.set(memberRef, {
      'uid': currentUser.uid,
      'displayName': currentUser.displayName?.trim() ?? '',
      'email': currentUser.email ?? '',
      'role': 'owner',
      'joinedAt': Timestamp.fromDate(now),
    });

    await batch.commit();
    return workspaceDto;
  }
}

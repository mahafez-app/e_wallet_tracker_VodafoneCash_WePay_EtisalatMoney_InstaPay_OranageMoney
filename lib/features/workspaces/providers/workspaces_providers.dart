import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/datasources/workspace_remote_data_source.dart';
import '../data/repositories/workspace_repository_impl.dart';
import '../domain/repositories/workspace_repository.dart';
import '../domain/usecases/create_workspace_usecase.dart';

final workspaceRemoteDataSourceProvider = Provider<WorkspaceRemoteDataSource>(
  (ref) => WorkspaceRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  ),
);

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) => WorkspaceRepositoryImpl(
    remote: ref.watch(workspaceRemoteDataSourceProvider),
  ),
);

final createWorkspaceUseCaseProvider = Provider<CreateWorkspaceUseCase>(
  (ref) => CreateWorkspaceUseCase(ref.watch(workspaceRepositoryProvider)),
);

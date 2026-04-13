import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/workspace_details_entity.dart';
import '../../domain/usecases/watch_workspace_details_usecase.dart';
import '../../providers/workspaces_providers.dart';

final workspaceDetailsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WorkspaceDetailsController, WorkspaceDetailsEntity, String>(
      WorkspaceDetailsController.new,
    );

class WorkspaceDetailsController extends AsyncNotifier<WorkspaceDetailsEntity> {
  WorkspaceDetailsController(this._workspaceId);

  final String _workspaceId;
  StreamSubscription<Object?>? _workspaceDetailsSubscription;

  @override
  Future<WorkspaceDetailsEntity> build() async {
    final stream = ref.read(watchWorkspaceDetailsUseCaseProvider)(
      WatchWorkspaceDetailsParams(workspaceId: _workspaceId),
    );
    final completer = Completer<WorkspaceDetailsEntity>();

    ref.onDispose(() => _workspaceDetailsSubscription?.cancel());

    _workspaceDetailsSubscription = stream.listen((next) {
      next.fold(
        (failure) {
          if (!completer.isCompleted) {
            completer.completeError(failure);
            return;
          }

          state = AsyncValue.error(failure, StackTrace.current);
        },
        (details) {
          state = AsyncValue.data(details);
          if (!completer.isCompleted) {
            completer.complete(details);
          }
        },
      );
    });

    return completer.future;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace_settings_controller_commands_mixin.dart';
import 'workspace_settings_controller_internal_mixin.dart';
import 'workspace_settings_controller_live_sync_mixin.dart';
import 'workspace_settings_state.dart';

final workspaceSettingsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WorkspaceSettingsController, WorkspaceSettingsState, String>(
      WorkspaceSettingsController.new,
    );

class WorkspaceSettingsController extends AsyncNotifier<WorkspaceSettingsState>
    with
        WorkspaceSettingsControllerCommandsMixin,
        WorkspaceSettingsControllerInternalMixin,
        WorkspaceSettingsControllerLiveSyncMixin {
  WorkspaceSettingsController(this.workspaceId);

  @override
  final String workspaceId;

  @override
  Future<WorkspaceSettingsState> build() {
    return _buildState();
  }

  Future<WorkspaceSettingsState> _buildState() async {
    final initialState = await loadState();
    bindLiveState(ownerUid: initialState.details.workspace.ownerUid);
    return initialState;
  }
}

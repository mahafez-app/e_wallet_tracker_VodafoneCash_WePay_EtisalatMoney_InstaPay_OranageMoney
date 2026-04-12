import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../widgets/select_wallets/select_workspace_wallets_body.dart';

enum WorkspaceWalletSelectionFlow { create, manage }

class SelectWorkspaceWalletsScreen extends StatelessWidget {
  const SelectWorkspaceWalletsScreen({
    super.key,
    required this.workspaceId,
    required this.flow,
  });

  final String workspaceId;
  final WorkspaceWalletSelectionFlow flow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.workspaceAddWalletsTitle)),
      body: SafeArea(
        child: SelectWorkspaceWalletsBody(
          workspaceId: workspaceId,
          isCreateFlow: flow == WorkspaceWalletSelectionFlow.create,
        ),
      ),
    );
  }
}

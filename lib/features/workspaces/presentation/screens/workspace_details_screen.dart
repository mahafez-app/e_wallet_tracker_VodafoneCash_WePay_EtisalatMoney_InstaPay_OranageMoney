// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../invitations/presentation/widgets/invitations/invite_member_bottom_sheet.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../providers/workspace_details_controller.dart';
import '../widgets/details/workspace_members_section.dart';
import '../widgets/details/workspace_summary_card.dart';
import '../widgets/details/workspace_transactions_section.dart';
import '../widgets/details/workspace_wallets_section.dart';

class WorkspaceDetailsScreen extends StatelessWidget {
  const WorkspaceDetailsScreen({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _WorkspaceDetailsTitle(workspaceId: workspaceId),
        actions: [_WorkspaceDetailsActions(workspaceId: workspaceId)],
      ),
      body: SafeArea(child: _WorkspaceDetailsBody(workspaceId: workspaceId)),
    );
  }
}

class _WorkspaceDetailsActions extends ConsumerWidget {
  const _WorkspaceDetailsActions({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () =>
          context.push(AppRoutes.workspaceSettingsPath(workspaceId)),
      icon: const Icon(Icons.settings_outlined),
    );
  }
}

class _WorkspaceDetailsTitle extends ConsumerWidget {
  const _WorkspaceDetailsTitle({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceDetailsControllerProvider(workspaceId));
    final title = state.asData?.value.workspace.name ?? '';

    return Text(title);
  }
}

class _WorkspaceDetailsBody extends ConsumerWidget {
  const _WorkspaceDetailsBody({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceDetailsControllerProvider(workspaceId));

    return switch (state) {
      AsyncLoading() => const AppLoader(),
      AsyncError(:final error) => AppErrorView(error: error),
      AsyncData(:final value) => _WorkspaceDetailsDataView(details: value),
    };
  }
}

class _WorkspaceDetailsDataView extends ConsumerWidget {
  const _WorkspaceDetailsDataView({super.key, required this.details});

  final WorkspaceDetailsEntity details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final canInviteMembers = currentUser?.uid == details.workspace.ownerUid;

    return SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkspaceSummaryCard(details: details),
          AppSpacing.lg.verticalSpace,
          WorkspaceWalletsSection(
            wallets: details.wallets,
            onAddWallets: () => context.push(
              AppRoutes.workspaceWalletSelectionPath(details.workspace.id),
            ),
          ),
          AppSpacing.xxl.verticalSpace,
          WorkspaceTransactionsSection(details: details),
          AppSpacing.xxl.verticalSpace,
          WorkspaceMembersSection(
            members: details.members,
            onInviteMember: canInviteMembers
                ? () => InviteMemberBottomSheet.show(
                    context,
                    workspaceId: details.workspace.id,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
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
    final state = ref.watch(workspaceDetailsControllerProvider(workspaceId));
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    final isOwner =
        currentUserId != null &&
        currentUserId == state.asData?.value.workspace.ownerUid;

    if (!isOwner) {
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
    final canManageAccess = currentUser != null && !canInviteMembers;

    return SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkspaceSummaryCard(details: details),
          if (canManageAccess) ...[
            AppSpacing.lg.verticalSpace,
            _WorkspaceAccessCard(workspaceId: details.workspace.id),
          ],
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

class _WorkspaceAccessCard extends StatelessWidget {
  const _WorkspaceAccessCard({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.workspaceSettingsAccessSection,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  context.l10n.workspaceSettingsMemberDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.push(AppRoutes.workspaceSettingsPath(workspaceId)),
              icon: const Icon(Icons.tune_rounded),
              label: Text(context.l10n.workspaceSettingsManageAccessAction),
            ),
          ),
        ],
      ),
    );
  }
}

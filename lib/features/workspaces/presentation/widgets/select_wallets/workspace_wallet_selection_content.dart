// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/info_card.dart';
import '../../providers/workspace_wallet_selection_state.dart';
import 'workspace_wallet_selection_card.dart';

class WorkspaceWalletSelectionContent extends StatelessWidget {
  const WorkspaceWalletSelectionContent({
    super.key,
    required this.workspaceId,
    required this.state,
    required this.isCreateFlow,
    required this.onToggleWallet,
    required this.onSubmit,
  });

  final String workspaceId;
  final WorkspaceWalletSelectionState state;
  final bool isCreateFlow;
  final ValueChanged<String> onToggleWallet;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  text: isCreateFlow
                      ? l10n.workspaceAddWalletsCreateDescription
                      : l10n.workspaceAddWalletsManageDescription,
                ),
                AppSpacing.lg.verticalSpace,
                Text(
                  state.workspaceName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.sm.verticalSpace,
                Text(
                  l10n.workspaceWalletSelectionSummary(
                    state.ownedWallets.length,
                    state.linkedWalletIds.length,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.lg.verticalSpace,
                if (state.ownedWallets.isEmpty)
                  const _WorkspaceWalletSelectionEmptyState(
                    titleKey: _WorkspaceWalletSelectionEmptyStateKey.noWallets,
                  )
                else if (!state.hasSelectableWallets)
                  const _WorkspaceWalletSelectionEmptyState(
                    titleKey: _WorkspaceWalletSelectionEmptyStateKey.allLinked,
                  )
                else
                  Column(
                    children: state.ownedWallets
                        .map(
                          (wallet) => Padding(
                            padding: AppResponsive.onlyPadding(
                              bottom: AppSpacing.md,
                            ),
                            child: WorkspaceWalletSelectionCard(
                              wallet: wallet,
                              isSelected: state.selectedWalletIds.contains(
                                wallet.id,
                              ),
                              isLinked: state.linkedWalletIds.contains(
                                wallet.id,
                              ),
                              onTap: () => onToggleWallet(wallet.id),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            children: [
              AppButton(
                label: state.hasSelectableWallets
                    ? l10n.workspaceAddSelectedWalletsAction
                    : l10n.workspaceContinueToDetailsAction,
                icon: Icon(
                  state.hasSelectableWallets
                      ? Icons.account_balance_wallet_outlined
                      : Icons.arrow_forward_rounded,
                ),
                isLoading: state.isSubmitting,
                onPressed: state.canSubmit ? onSubmit : null,
              ),
              if (isCreateFlow && state.hasSelectableWallets) ...[
                AppSpacing.sm.verticalSpace,
                AppButton(
                  label: l10n.workspaceSkipWalletsAction,
                  type: AppButtonType.tertiary,
                  onPressed: state.isSubmitting
                      ? null
                      : () => context.go(
                          AppRoutes.workspaceDetailsPath(workspaceId),
                        ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

enum _WorkspaceWalletSelectionEmptyStateKey { noWallets, allLinked }

class _WorkspaceWalletSelectionEmptyState extends StatelessWidget {
  const _WorkspaceWalletSelectionEmptyState({
    super.key,
    required this.titleKey,
  });

  final _WorkspaceWalletSelectionEmptyStateKey titleKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final title = titleKey == _WorkspaceWalletSelectionEmptyStateKey.noWallets
        ? l10n.workspaceNoOwnedWalletsTitle
        : l10n.workspaceAllOwnedWalletsLinkedTitle;
    final description =
        titleKey == _WorkspaceWalletSelectionEmptyStateKey.noWallets
        ? l10n.workspaceNoOwnedWalletsDescription
        : l10n.workspaceAllOwnedWalletsLinkedDescription;

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: theme.colorScheme.primary,
            size: 28.responsiveRadius,
          ),
          AppSpacing.md.verticalSpace,
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

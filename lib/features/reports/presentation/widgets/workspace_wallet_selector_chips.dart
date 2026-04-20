import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../generated/l10n.dart';
import '../../../workspaces/presentation/providers/workspace_details_controller.dart';
import '../providers/workspace_report_controller.dart';

class WorkspaceWalletSelectorChips extends ConsumerWidget {
  const WorkspaceWalletSelectorChips({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceState = ref.watch(
      workspaceDetailsControllerProvider(workspaceId),
    );
    final filter = ref.watch(workspaceReportFilterProvider(workspaceId));

    if (!workspaceState.hasValue) return const SizedBox.shrink();

    final wallets = workspaceState.value!.wallets;
    if (wallets.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final allSelected = filter.selectedWalletIds.isEmpty;

    return Padding(
      padding: AppSpacing.pagePadding.copyWith(
        top: 0,
        bottom: AppSpacing.sm.responsiveHeight,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm.responsiveWidth),
              child: FilterChip(
                label: Text(S.of(context)!.reports_all_wallets),
                selected: allSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(
                          workspaceReportFilterProvider(workspaceId).notifier,
                        )
                        .updateFilter(filter.copyWith(selectedWalletIds: []));
                  }
                },
                selectedColor: theme.colorScheme.primaryContainer,
              ),
            ),
            ...wallets.map((wallet) {
              final isSelected = filter.selectedWalletIds.contains(wallet.id);
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.sm.responsiveWidth),
                child: FilterChip(
                  label: Text(
                    '${wallet.provider.displayName(context)} ${wallet.phoneNumber.formattedEgyptianPhoneNumber}',
                  ),
                  selected: isSelected && !allSelected,
                  onSelected: (selected) {
                    final newSelected = List<String>.from(
                      filter.selectedWalletIds,
                    );
                    if (selected) {
                      newSelected.add(wallet.id);
                    } else {
                      newSelected.remove(wallet.id);
                    }

                    // If everything is selected, revert to all empty (meaning all)
                    if (newSelected.length == wallets.length) {
                      newSelected.clear();
                    }

                    ref
                        .read(
                          workspaceReportFilterProvider(workspaceId).notifier,
                        )
                        .updateFilter(
                          filter.copyWith(selectedWalletIds: newSelected),
                        );
                  },
                  selectedColor: theme.colorScheme.primaryContainer,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

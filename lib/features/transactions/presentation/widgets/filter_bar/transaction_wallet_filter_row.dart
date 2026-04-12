// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';

class TransactionWalletFilterRow extends ConsumerWidget {
  const TransactionWalletFilterRow({super.key, required this.routeData});

  final WorkspaceTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );

    return SizedBox(
      height: 40.responsiveHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppResponsive.symmetricPadding(
          horizontal: AppSpacing.lg,
        ).copyWith(top: AppSpacing.sm),
        children: [
          _WalletChip(
            label: context.l10n.transactions_filter_allWallets,
            isSelected: state.selectedWalletId == null,
            onTap: () => controller.setWalletFilter(null),
          ),
          ...routeData.wallets.map(
            (wallet) => Padding(
              padding: AppResponsive.onlyPadding(start: AppSpacing.sm),
              child: _WalletChip(
                label: wallet.walletLabel,
                isSelected: state.selectedWalletId == wallet.walletId,
                onTap: () => controller.setWalletFilter(wallet.walletId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletChip extends StatelessWidget {
  const _WalletChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(20)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withAlpha(120),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(20.responsiveRadius),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

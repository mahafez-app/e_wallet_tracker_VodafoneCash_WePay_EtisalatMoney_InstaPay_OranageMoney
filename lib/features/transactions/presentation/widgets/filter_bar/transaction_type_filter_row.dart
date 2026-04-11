// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';
import '../../providers/transactions_state.dart';

class TransactionTypeFilterRow extends ConsumerWidget {
  const TransactionTypeFilterRow({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _TypeChip(
            label: l10n.transactions_filter_all,
            isSelected: state.typeFilter == TransactionTypeFilter.all,
            onTap: () => controller.setTypeFilter(TransactionTypeFilter.all),
            theme: theme,
          ),
          AppSpacing.sm.horizontalSpace,
          _TypeChip(
            label: l10n.transactionTypeReceive,
            isSelected: state.typeFilter == TransactionTypeFilter.receive,
            onTap: () =>
                controller.setTypeFilter(TransactionTypeFilter.receive),
            theme: theme,
          ),
          AppSpacing.sm.horizontalSpace,
          _TypeChip(
            label: l10n.transactionTypeSend,
            isSelected: state.typeFilter == TransactionTypeFilter.send,
            onTap: () => controller.setTypeFilter(TransactionTypeFilter.send),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppResponsive.symmetricPadding(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(20.responsiveRadius),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

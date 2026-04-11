// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../generated/l10n.dart';
import '../../models/transactions_context.dart';
import '../../providers/transactions_controller.dart';
import '../../providers/transactions_state.dart';

class TransactionsFilterBar extends ConsumerWidget {
  const TransactionsFilterBar({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TypeFilterRow(context_: context_),
        _DateFilterRow(context_: context_),
        if (context_ is WorkspaceTransactionsContext)
          _WalletFilterRow(
            context_: context_ as WorkspaceTransactionsContext,
          ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
        ),
      ],
    );
  }
}

// ── Type filter ───────────────────────────────────────────────────────────────

class _TypeFilterRow extends ConsumerWidget {
  const _TypeFilterRow({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(context_));
    final controller = ref.read(
      transactionsControllerProvider(context_).notifier,
    );
    final theme = Theme.of(context);

    return Padding(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _TypeChip(
            label: S.of(context).transactions_filter_all,
            isSelected: state.typeFilter == TransactionTypeFilter.all,
            onTap: () => controller.setTypeFilter(TransactionTypeFilter.all),
            theme: theme,
          ),
          AppSpacing.sm.horizontalSpace,
          _TypeChip(
            label: S.of(context).transactionTypeReceive,
            isSelected: state.typeFilter == TransactionTypeFilter.receive,
            onTap: () =>
                controller.setTypeFilter(TransactionTypeFilter.receive),
            theme: theme,
          ),
          AppSpacing.sm.horizontalSpace,
          _TypeChip(
            label: S.of(context).transactionTypeSend,
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

// ── Date filter ───────────────────────────────────────────────────────────────

class _DateFilterRow extends ConsumerWidget {
  const _DateFilterRow({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(context_));
    final controller = ref.read(
      transactionsControllerProvider(context_).notifier,
    );

    return SizedBox(
      height: 40.responsiveHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.lg),
        children: [
          _DateChip(
            label: S.of(context).transactions_date_today,
            preset: DatePreset.today,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.today),
            context_: context_,
          ),
          AppSpacing.sm.horizontalSpace,
          _DateChip(
            label: S.of(context).transactions_date_yesterday,
            preset: DatePreset.yesterday,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.yesterday),
            context_: context_,
          ),
          AppSpacing.sm.horizontalSpace,
          _DateChip(
            label: S.of(context).transactions_date_week,
            preset: DatePreset.week,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.week),
            context_: context_,
          ),
          AppSpacing.sm.horizontalSpace,
          _DateChip(
            label: S.of(context).transactions_date_month,
            preset: DatePreset.month,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.month),
            context_: context_,
          ),
          AppSpacing.sm.horizontalSpace,
          _CustomDateChip(context_: context_),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    super.key,
    required this.label,
    required this.preset,
    required this.activePreset,
    required this.onTap,
    required this.context_,
  });

  final String label;
  final DatePreset preset;
  final DatePreset activePreset;
  final VoidCallback onTap;
  final TransactionsContext context_;

  bool get _isSelected => activePreset == preset;

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
          color: _isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          border: Border.all(
            color: _isSelected
                ? theme.colorScheme.primary.withAlpha(120)
                : theme.colorScheme.outlineVariant.withAlpha(120),
          ),
          borderRadius: BorderRadius.circular(20.responsiveRadius),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: _isSelected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CustomDateChip extends ConsumerWidget {
  const _CustomDateChip({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(context_));
    final controller = ref.read(
      transactionsControllerProvider(context_).notifier,
    );
    final theme = Theme.of(context);
    final isSelected = state.datePreset == DatePreset.custom;

    return GestureDetector(
      onTap: () => _pickRange(context, controller),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withAlpha(120)
                : theme.colorScheme.outlineVariant.withAlpha(120),
          ),
          borderRadius: BorderRadius.circular(20.responsiveRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 14.responsiveRadius,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.xs.horizontalSpace,
            Text(
              S.of(context).transactions_date_customRange,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickRange(
    BuildContext context,
    TransactionsController controller,
  ) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
    );
    if (range == null) return;
    await controller.setDatePreset(
      DatePreset.custom,
      start: range.start,
      end: range.end,
    );
  }
}

// ── Wallet filter (workspace only) ────────────────────────────────────────────

class _WalletFilterRow extends ConsumerWidget {
  const _WalletFilterRow({super.key, required this.context_});

  final WorkspaceTransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(context_));
    final controller = ref.read(
      transactionsControllerProvider(context_).notifier,
    );

    return SizedBox(
      height: 40.responsiveHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.lg),
        children: [
          _WalletChip(
            label: S.of(context).transactions_filter_allWallets,
            isSelected: state.selectedWalletId == null,
            onTap: () => controller.setWalletFilter(null),
          ),
          ...context_.wallets.map(
            (w) => Padding(
              padding: AppResponsive.onlyPadding(left: AppSpacing.sm),
              child: _WalletChip(
                label: w.walletLabel,
                isSelected: state.selectedWalletId == w.walletId,
                onTap: () => controller.setWalletFilter(w.walletId),
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

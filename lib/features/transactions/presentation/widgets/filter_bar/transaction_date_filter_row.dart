// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';
import '../../providers/transactions_state.dart';

class TransactionDateFilterRow extends ConsumerWidget {
  const TransactionDateFilterRow({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );
    final l10n = context.l10n;

    return SizedBox(
      height: 40.responsiveHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.lg),
        children: [
          _DateChip(
            label: l10n.transactions_date_today,
            preset: DatePreset.today,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.today),
          ),
          AppSpacing.sm.horizontalSpace,
          _DateChip(
            label: l10n.transactions_date_yesterday,
            preset: DatePreset.yesterday,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.yesterday),
          ),
          AppSpacing.sm.horizontalSpace,
          _DateChip(
            label: l10n.transactions_date_week,
            preset: DatePreset.week,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.week),
          ),
          AppSpacing.sm.horizontalSpace,
          _DateChip(
            label: l10n.transactions_date_month,
            preset: DatePreset.month,
            activePreset: state.datePreset,
            onTap: () => controller.setDatePreset(DatePreset.month),
          ),
          AppSpacing.sm.horizontalSpace,
          _CustomDateChip(routeData: routeData),
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
  });

  final String label;
  final DatePreset preset;
  final DatePreset activePreset;
  final VoidCallback onTap;

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
  const _CustomDateChip({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
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
              context.l10n.transactions_date_customRange,
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

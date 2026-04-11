// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/transactions/transaction_card.dart';

/// Groups transactions by calendar day and renders date headers.
class TransactionsDateGroupedList extends StatelessWidget {
  const TransactionsDateGroupedList({
    super.key,
    required this.groupedTransactions,
    required this.onTap,
    this.showProviderInfo = true,
    required this.footer,
  });

  final Map<DateTime, List<TransactionEntity>> groupedTransactions;
  final void Function(TransactionEntity) onTap;
  final bool showProviderInfo;

  /// Widget rendered at the very bottom (load more button / indicator).
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final days = groupedTransactions.keys.toList();

    return ListView.builder(
      padding: AppSpacing.pagePadding,
      itemCount: days.length + 1, // +1 for footer
      itemBuilder: (context, index) {
        if (index == days.length) return footer;
        final day = days[index];
        final dayTransactions = groupedTransactions[day]!;
        return _DayGroup(
          day: day,
          transactions: dayTransactions,
          onTap: onTap,
          showProviderInfo: showProviderInfo,
        );
      },
    );
  }
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({
    super.key,
    required this.day,
    required this.transactions,
    required this.onTap,
    required this.showProviderInfo,
  });

  final DateTime day;
  final List<TransactionEntity> transactions;
  final void Function(TransactionEntity) onTap;
  final bool showProviderInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DayHeader(day: day),
        AppSpacing.sm.verticalSpace,
        ...transactions.map(
          (tx) => GestureDetector(
            onTap: () => onTap(tx),
            child: TransactionCard(
              transaction: tx,
              showProviderInfo: showProviderInfo,
            ),
          ),
        ),
        AppSpacing.md.verticalSpace,
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final label = DateFormat.yMMMMEEEEd(locale).format(day);

    return Container(
      margin: AppResponsive.symmetricPadding(vertical: AppSpacing.xs),
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

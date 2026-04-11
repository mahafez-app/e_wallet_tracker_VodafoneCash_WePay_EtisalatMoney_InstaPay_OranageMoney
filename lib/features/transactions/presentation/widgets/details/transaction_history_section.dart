// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../domain/entities/transaction_history_entry_entity.dart';

/// Section 5: Timeline of paid/unpaid status changes.
class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key, required this.entries});

  final List<TransactionHistoryEntryEntity> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title: context.l10n.transaction_history),
        AppSpacing.md.verticalSpace,
        ...entries.asMap().entries.map(
          (entry) => _HistoryEntryTile(
            entry: entry.value,
            isFirst: entry.key == 0,
            isLast: entry.key == entries.length - 1,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
  );
}

class _HistoryEntryTile extends StatelessWidget {
  const _HistoryEntryTile({
    super.key,
    required this.entry,
    required this.isFirst,
    required this.isLast,
  });

  final TransactionHistoryEntryEntity entry;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final dateText = entry.occurredAt.toMonthDayLabel(context);
    final timeText = entry.occurredAt.toTimeLabel(context);

    // Active entry (most recent) has primary color, older ones are muted.
    final color = isFirst
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant.withAlpha(150);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: AppResponsive.onlyPadding(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.transaction_markedAs(
                      entry.isPaid
                          ? l10n.transactionStatusPaid
                          : l10n.transactionStatusUnpaid,
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xs.verticalSpace,
                  Text(
                    '${l10n.transaction_by(entry.actorName)} · $dateText · $timeText',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 32.responsiveWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Only show line if it's not the LAST item in the list
                if (!isLast)
                  Positioned(
                    top: 14.responsiveHeight,
                    bottom: -14.responsiveHeight,
                    child: Container(
                      width: 1,
                      color: theme.colorScheme.outlineVariant.withAlpha(80),
                    ),
                  ),
                Positioned(
                  top: 14.responsiveHeight,
                  child: Container(
                    width: 12.responsiveRadius,
                    height: 12.responsiveRadius,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

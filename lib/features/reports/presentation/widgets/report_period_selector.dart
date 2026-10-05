import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import '../../../../core/domain/enums/report_period.dart';
import '../../domain/entities/report_filter_entity.dart';
import '../../../../core/utils/extensions/localization_extension.dart';

class ReportPeriodSelector extends StatelessWidget {
  const ReportPeriodSelector({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  final ReportFilterEntity currentFilter;
  final ValueChanged<ReportFilterEntity> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MahafezSpacing.pagePadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ReportPeriod.values.map((period) {
            final isSelected = currentFilter.period == period;
            final theme = Theme.of(context);
            
            return Padding(
              padding: EdgeInsets.only(right: MahafezSpacing.sm.responsiveWidth),
              child: ChoiceChip(
                label: Text(
                  _getPeriodName(context, period),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (period == ReportPeriod.customRange) {
                    _selectCustomRange(context);
                  } else if (selected) {
                    onFilterChanged(currentFilter.copyWith(period: period));
                  }
                },
                selectedColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _selectCustomRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: currentFilter.customRange,
    );

    if (picked != null) {
      onFilterChanged(currentFilter.copyWith(
        period: ReportPeriod.customRange,
        customRange: picked,
      ));
    }
  }

  String _getPeriodName(BuildContext context, ReportPeriod period) {
    final l10n = context.l10n;
    switch (period) {
      case ReportPeriod.today:
        return l10n.reports_period_today;
      case ReportPeriod.yesterday:
        return l10n.reports_period_yesterday;
      case ReportPeriod.lastWeek:
        return l10n.reports_period_lastWeek;
      case ReportPeriod.lastMonth:
        return l10n.reports_period_lastMonth;
      case ReportPeriod.customRange:
        return l10n.reports_period_custom;
    }
  }
}

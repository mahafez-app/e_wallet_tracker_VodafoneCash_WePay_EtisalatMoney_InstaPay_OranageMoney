import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'app_filter_chip.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({super.key, required this.chips, this.label});

  final String? label;
  final List<FilterChipData> chips;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppResponsive.onlyPadding(top: AppSpacing.sm),
      child: SizedBox(
        height: _kChipRowHeight.responsiveHeight,
        child: Row(
          children: [
            if (label != null)
              Container(
                padding: AppResponsive.onlyPadding(start: AppSpacing.sm),
                width: _kLabelColumnWidth.responsiveWidth,
                alignment: AlignmentDirectional.centerStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label!,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: AppResponsive.onlyPadding(
                  start: AppSpacing.lg,
                  end: label != null ? 0 : AppSpacing.lg,
                ),
                itemCount: chips.length,
                separatorBuilder: (_, _) => AppSpacing.sm.horizontalSpace,
                itemBuilder: (_, i) {
                  final chip = chips[i];
                  return AppFilterChip(
                    label: chip.label,
                    isSelected: chip.isSelected,
                    onTap: chip.onTap,
                    icon: chip.icon,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipData {
  const FilterChipData({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
}

const double _kChipRowHeight = 35;

const double _kLabelColumnWidth = 60;

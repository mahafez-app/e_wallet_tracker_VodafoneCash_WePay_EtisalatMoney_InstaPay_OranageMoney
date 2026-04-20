import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../domain/value_objects/app_font_scale.dart';

class FontSizePreviewCard extends StatelessWidget {
  const FontSizePreviewCard({
    super.key,
    required this.previewScale,
    required this.appliedScale,
  });

  final double previewScale;
  final double appliedScale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(70),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(70),
          width: 1,
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(previewScale)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.userSettingsFontSizePreviewTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              context.l10n.userSettingsFontSizePreviewBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.md.verticalSpace,
            Text(
              fontScalePercent(previewScale),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            if (previewScale != appliedScale) ...[
              AppSpacing.xs.verticalSpace,
              Text(
                context.l10n.userSettingsFontSizeCurrentValue(
                  fontScalePercent(appliedScale),
                ),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FontSizeSliderControl extends StatelessWidget {
  const FontSizeSliderControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: AppFontScale.min,
      max: AppFontScale.max,
      divisions: AppFontScale.divisions,
      label: fontScalePercent(value),
      onChanged: onChanged,
    );
  }
}

class FontSizeSliderLabels extends StatelessWidget {
  const FontSizeSliderLabels({super.key, required this.selectedFontScale});

  final double selectedFontScale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.userSettingsFontSizeSmallLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          fontScalePercent(selectedFontScale),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Expanded(
          child: Text(
            context.l10n.userSettingsFontSizeLargeLabel,
            textAlign: TextAlign.end,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

String fontScalePercent(double value) {
  return '${(value * 100).round()}%';
}

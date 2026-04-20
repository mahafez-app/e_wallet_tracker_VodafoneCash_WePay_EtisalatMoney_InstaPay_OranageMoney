import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/app_preferences_entity.dart';
import '../providers/app_preferences_controller.dart';
import 'font_size_settings_content.dart';

class FontSizeSettingsBottomSheet extends ConsumerStatefulWidget {
  const FontSizeSettingsBottomSheet({
    super.key,
    required this.initialFontScale,
  });

  final double initialFontScale;

  static Future<void> show(
    BuildContext context, {
    required double initialFontScale,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) =>
          FontSizeSettingsBottomSheet(initialFontScale: initialFontScale),
    );
  }

  @override
  ConsumerState<FontSizeSettingsBottomSheet> createState() =>
      _FontSizeSettingsBottomSheetState();
}

class _FontSizeSettingsBottomSheetState
    extends ConsumerState<FontSizeSettingsBottomSheet> {
  late double _selectedFontScale;

  @override
  void initState() {
    super.initState();
    _selectedFontScale = AppPreferencesEntity.normalizeFontScale(
      widget.initialFontScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentScale = ref.watch(appTextScaleProvider);

    return SafeArea(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.userSettingsFontSizeTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              context.l10n.userSettingsFontSizeDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.lg.verticalSpace,
            FontSizePreviewCard(
              previewScale: _selectedFontScale,
              appliedScale: currentScale,
            ),
            AppSpacing.lg.verticalSpace,
            FontSizeSliderControl(
              value: _selectedFontScale,
              onChanged: (value) {
                setState(
                  () => _selectedFontScale =
                      AppPreferencesEntity.normalizeFontScale(value),
                );
              },
            ),
            AppSpacing.sm.verticalSpace,
            FontSizeSliderLabels(selectedFontScale: _selectedFontScale),
            AppSpacing.lg.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.l10n.commonCancelAction,
                    onPressed: () => Navigator.of(context).pop(),
                    type: AppButtonType.secondary,
                  ),
                ),
                AppSpacing.md.horizontalSpace,
                Expanded(
                  child: AppButton(
                    label: context.l10n.userSettingsFontSizeSaveAction,
                    onPressed: _selectedFontScale == currentScale
                        ? null
                        : () {
                            ref
                                .read(appPreferencesControllerProvider.notifier)
                                .setFontScale(_selectedFontScale);
                            Navigator.of(context).pop();
                          },
                  ),
                ),
              ],
            ),
            AppSpacing.sm.verticalSpace,
          ],
        ),
      ),
    );
  }
}

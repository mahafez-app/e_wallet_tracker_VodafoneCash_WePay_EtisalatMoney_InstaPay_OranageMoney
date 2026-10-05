import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class SettingsOption<T> {
  const SettingsOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;
  final String label;
  final IconData icon;
}

class SettingsOptionBottomSheet<T> extends StatelessWidget {
  const SettingsOptionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  final String title;
  final List<SettingsOption<T>> options;
  final T selectedValue;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<SettingsOption<T>> options,
    required T selectedValue,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (context) => SettingsOptionBottomSheet<T>(
        title: title,
        options: options,
        selectedValue: selectedValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: MahafezSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            MahafezSpacing.lg.verticalSpace,
            ...options.map(
              (option) => _SettingsOptionTile<T>(
                option: option,
                isSelected: option.value == selectedValue,
              ),
            ),
            MahafezSpacing.sm.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _SettingsOptionTile<T> extends StatelessWidget {
  const _SettingsOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
  });

  final SettingsOption<T> option;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => Navigator.of(context).pop(option.value),
      borderRadius: BorderRadius.circular(20.responsiveRadius),
      child: Padding(
        padding: MahafezResponsive.symmetricPadding(
          horizontal: MahafezSpacing.lg,
          vertical: MahafezSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14.responsiveRadius),
              ),
              child: Icon(
                option.icon,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.primary,
                size: 20.responsiveRadius,
              ),
            ),
            MahafezSpacing.md.horizontalSpace,
            Expanded(
              child: Text(
                option.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            MahafezSpacing.sm.horizontalSpace,
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

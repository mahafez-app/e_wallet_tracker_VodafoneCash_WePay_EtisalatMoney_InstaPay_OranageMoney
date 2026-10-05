import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/service_providers.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import 'settings_section_title.dart';

class BackgroundReliabilitySection extends ConsumerWidget {
  const BackgroundReliabilitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isXiaomi = ref.watch(isXiaomiDeviceProvider).value ?? false;
    final isIgnoringBattery = ref.watch(isIgnoringBatteryOptimizationsProvider).value ?? true;

    // If it's not a Xiaomi device and battery optimization is already ignored,
    // don't show the section at all.
    if (!isXiaomi && isIgnoringBattery) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(label: context.l10n.userSettingsBackgroundSection),
        MahafezSpacing.sm.verticalSpace,
        const _XiaomiAutostartWarning(),
        const _BatteryOptimizationWarning(),
      ],
    );
  }
}

class _XiaomiAutostartWarning extends ConsumerWidget {
  const _XiaomiAutostartWarning();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isXiaomi = ref.watch(isXiaomiDeviceProvider).value ?? false;
    if (!isXiaomi) return const SizedBox.shrink();

    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withAlpha(40),
        borderRadius: BorderRadius.circular(MahafezSpacing.md.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.error.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 20.responsiveRadius,
              ),
              MahafezSpacing.xs.horizontalSpace,
              Expanded(
                child: Text(
                  l10n.smsPermissionXiaomiTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          MahafezSpacing.sm.verticalSpace,
          Text(
            l10n.smsPermissionXiaomiDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          MahafezSpacing.md.verticalSpace,
          InkWell(
            onTap: () =>
                ref.read(powerManagerServiceProvider).openAutostartSettings(),
            child: Text(
              l10n.smsPermissionXiaomiAction,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BatteryOptimizationWarning extends ConsumerWidget {
  const _BatteryOptimizationWarning();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIgnoring =
        ref.watch(isIgnoringBatteryOptimizationsProvider).value ?? true;
    if (isIgnoring) return const SizedBox.shrink();

    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: MahafezSpacing.md.responsiveHeight),
      child: Container(
        padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer.withAlpha(40),
          borderRadius: BorderRadius.circular(MahafezSpacing.md.responsiveRadius),
          border: Border.all(
            color: theme.colorScheme.secondary.withAlpha(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.battery_alert_rounded,
                  color: theme.colorScheme.secondary,
                  size: 20.responsiveRadius,
                ),
                MahafezSpacing.xs.horizontalSpace,
                Expanded(
                  child: Text(
                    l10n.smsPermissionBatteryOptimizationTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            MahafezSpacing.sm.verticalSpace,
            Text(
              l10n.smsPermissionBatteryOptimizationDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            MahafezSpacing.md.verticalSpace,
            InkWell(
              onTap: () => ref
                  .read(powerManagerServiceProvider)
                  .requestIgnoreBatteryOptimizations()
                  .then((_) => ref.invalidate(isIgnoringBatteryOptimizationsProvider)),
              child: Text(
                l10n.smsPermissionBatteryOptimizationAction,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

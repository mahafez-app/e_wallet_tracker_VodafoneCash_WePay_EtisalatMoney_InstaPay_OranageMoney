import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../providers/sms_permission_controller.dart';
import 'settings_card.dart';

class SettingsSmsPermissionCard extends StatelessWidget {
  const SettingsSmsPermissionCard({
    super.key,
    required this.state,
    required this.onOpenSettings,
  });

  final SmsPermissionState state;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = context.mahafezColors;

    return SettingsCard(
      child: InkWell(
        onTap: state.isOpeningSettings ? null : onOpenSettings,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        child: Padding(
          padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14.responsiveRadius),
                ),
                child: Icon(
                  Icons.sms_outlined,
                  color: colorScheme.primary,
                  size: 22.responsiveRadius,
                ),
              ),
              MahafezSpacing.md.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.userSettingsSmsPermissionTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    MahafezSpacing.xs.verticalSpace,
                    Text(
                      _statusLabel(context),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _statusColor(colorScheme, colors),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              MahafezSpacing.sm.horizontalSpace,
              if (state.isOpeningSettings)
                SizedBox.square(
                  dimension: 20.responsiveWidth,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.responsiveWidth,
                  ),
                )
              else
                Icon(Icons.chevron_right_rounded, color: colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    if (state.isChecking) {
      return context.l10n.userSettingsSmsPermissionCheckingLabel;
    }

    return state.hasPermission
        ? context.l10n.userSettingsSmsPermissionEnabledLabel
        : context.l10n.userSettingsSmsPermissionDisabledLabel;
  }

  Color _statusColor(ColorScheme colorScheme, MahafezColorExtension colors) {
    if (state.isChecking) {
      return colorScheme.onSurfaceVariant;
    }

    return state.hasPermission ? colors.success : colorScheme.error;
  }
}

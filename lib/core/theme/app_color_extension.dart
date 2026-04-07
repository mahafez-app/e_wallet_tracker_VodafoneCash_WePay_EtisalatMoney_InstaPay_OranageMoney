import 'package:flutter/material.dart';

import 'app_colors.dart';

final class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.info,
    required this.infoContainer,
  });

  const AppColorExtension.light()
    : success = AppColors.success,
      successContainer = AppColors.secondaryContainer,
      warning = AppColors.warning,
      warningContainer = AppColors.tertiaryContainer,
      danger = AppColors.danger,
      dangerContainer = AppColors.errorContainer,
      info = AppColors.info,
      infoContainer = AppColors.primaryContainer;

  const AppColorExtension.dark()
    : success = AppColors.success,
      successContainer = AppColors.onSecondaryFixedVariant,
      warning = AppColors.warning,
      warningContainer = AppColors.onTertiaryFixedVariant,
      danger = AppColors.danger,
      dangerContainer = AppColors.onErrorContainer,
      info = AppColors.info,
      infoContainer = AppColors.onPrimaryFixedVariant;

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color danger;
  final Color dangerContainer;
  final Color info;
  final Color infoContainer;

  @override
  AppColorExtension copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? danger,
    Color? dangerContainer,
    Color? info,
    Color? infoContainer,
  }) => AppColorExtension(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    danger: danger ?? this.danger,
    dangerContainer: dangerContainer ?? this.dangerContainer,
    info: info ?? this.info,
    infoContainer: infoContainer ?? this.infoContainer,
  );

  @override
  AppColorExtension lerp(AppColorExtension? other, double t) {
    if (other == null) return this;
    return AppColorExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}

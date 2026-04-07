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
      successContainer = const Color(0xFFE6F4EA),
      warning = AppColors.warning,
      warningContainer = const Color(0xFFFEF7E0),
      danger = AppColors.danger,
      dangerContainer = const Color(0xFFFCE8E6),
      info = AppColors.info,
      infoContainer = const Color(0xFFE8F0FE);

  const AppColorExtension.dark()
    : success = const Color(0xFF81C995),
      successContainer = const Color(0xFF1E3A26),
      warning = const Color(0xFFFDD663),
      warningContainer = const Color(0xFF3A2E00),
      danger = const Color(0xFFF28B82),
      dangerContainer = const Color(0xFF3B1614),
      info = const Color(0xFF8AB4F8),
      infoContainer = const Color(0xFF0D2A6B);

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

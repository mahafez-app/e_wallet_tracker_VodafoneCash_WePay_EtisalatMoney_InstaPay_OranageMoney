import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Custom colors that don't have a direct [ColorScheme] slot.
///
/// Access via [context.appColors] — never check [isDark] in a widget again.
///
/// ```dart
/// // Instead of:
/// final isDark = Theme.of(context).brightness == Brightness.dark;
/// final bg = isDark ? colorScheme.surface : AppColors.white;
///
/// // Just write:
/// final bg = context.appColors.cardBackground;
/// ```
final class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    // ── Surfaces / cards ────────────────────────────────────────────────────
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    // ── Input fields ─────────────────────────────────────────────────────────
    required this.inputFill,
    required this.inputBorder,
    required this.inputHint,
    // ── "Add wallet" dashed card ─────────────────────────────────────────────
    required this.addWalletBackground,
    required this.addWalletBorderColor,
    // ── Workspace icon chip ──────────────────────────────────────────────────
    required this.workspaceIconBackground,
    required this.workspaceIconForeground,
    // ── Stats gradient card (intentionally always dark-blue) ─────────────────
    required this.statsGradientStart,
    required this.statsGradientEnd,
    required this.statsOnGradient,
    required this.statsSentColor,
    required this.statsReceivedColor,
    // ── Semantic ─────────────────────────────────────────────────────────────
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.info,
    required this.infoContainer,
  });

  // ── Surfaces / cards ──────────────────────────────────────────────────────
  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;

  // ── Input fields ──────────────────────────────────────────────────────────
  final Color inputFill;
  final Color inputBorder;
  final Color inputHint;

  // ── "Add wallet" dashed card ──────────────────────────────────────────────
  final Color addWalletBackground;
  final Color addWalletBorderColor;

  // ── Workspace icon chip ───────────────────────────────────────────────────
  final Color workspaceIconBackground;
  final Color workspaceIconForeground;

  // ── Stats gradient card ───────────────────────────────────────────────────
  final Color statsGradientStart;
  final Color statsGradientEnd;
  final Color statsOnGradient;
  final Color statsSentColor;
  final Color statsReceivedColor;

  // ── Semantic ──────────────────────────────────────────────────────────────
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color danger;
  final Color dangerContainer;
  final Color info;
  final Color infoContainer;

  // ── Named constructors ────────────────────────────────────────────────────

  const AppColorExtension.light()
    : cardBackground = AppColors.white,
      cardBorder = const Color(0x33D8E3FB),
      cardShadow = const Color(0x0C000000),
      inputFill = const Color(0xFFF0F3FF),
      inputBorder = const Color(0x7FC2C6D6),
      inputHint = const Color(0x7F727785),
      addWalletBackground = const Color(0xFFE7EEFF),
      addWalletBorderColor = const Color(0xFFC2C6D5),
      workspaceIconBackground = const Color(0xFF9AF2C5),
      workspaceIconForeground = AppColors.onSecondaryContainer,
      statsGradientStart = AppColors.primary,
      statsGradientEnd = AppColors.onPrimaryFixedVariant,
      statsOnGradient = AppColors.primaryContainer,
      statsSentColor = AppColors.errorContainer,
      statsReceivedColor = AppColors.secondaryFixedDim,
      success = AppColors.secondary,
      successContainer = AppColors.secondaryContainer,
      warning = AppColors.tertiary,
      warningContainer = AppColors.tertiaryContainer,
      danger = AppColors.error,
      dangerContainer = AppColors.errorContainer,
      info = AppColors.primary,
      infoContainer = AppColors.primaryContainer;

  const AppColorExtension.dark()
    : cardBackground = AppColors.darkSurfaceContainer,
      cardBorder = AppColors.darkSurfaceContainerHigh,
      cardShadow = const Color(0x40000000),
      inputFill = const Color(0x1AF0F3FF),
      inputBorder = const Color(0x4FCBD5E1),
      inputHint = const Color(0x7F94A3B8),
      addWalletBackground = AppColors.darkSurfaceContainer,
      addWalletBorderColor = AppColors.darkSurfaceContainerHigh,
      workspaceIconBackground = AppColors.onSecondaryFixedVariant,
      workspaceIconForeground = AppColors.secondaryFixedDim,
      statsGradientStart = AppColors.primary,
      statsGradientEnd = AppColors.onPrimaryFixedVariant,
      statsOnGradient = AppColors.primaryContainer,
      statsSentColor = AppColors.errorContainer,
      statsReceivedColor = AppColors.secondaryFixedDim,
      success = AppColors.secondaryFixedDim,
      successContainer = AppColors.onSecondaryFixedVariant,
      warning = AppColors.tertiaryFixedDim,
      warningContainer = AppColors.onTertiaryFixedVariant,
      danger = AppColors.error,
      dangerContainer = AppColors.onErrorContainer,
      info = AppColors.primaryFixedDim,
      infoContainer = AppColors.onPrimaryFixedVariant;

  // ── ThemeExtension boilerplate ────────────────────────────────────────────

  @override
  AppColorExtension copyWith({
    Color? cardBackground,
    Color? cardBorder,
    Color? cardShadow,
    Color? inputFill,
    Color? inputBorder,
    Color? inputHint,
    Color? addWalletBackground,
    Color? addWalletBorderColor,
    Color? workspaceIconBackground,
    Color? workspaceIconForeground,
    Color? statsGradientStart,
    Color? statsGradientEnd,
    Color? statsOnGradient,
    Color? statsSentColor,
    Color? statsReceivedColor,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? danger,
    Color? dangerContainer,
    Color? info,
    Color? infoContainer,
  }) => AppColorExtension(
    cardBackground: cardBackground ?? this.cardBackground,
    cardBorder: cardBorder ?? this.cardBorder,
    cardShadow: cardShadow ?? this.cardShadow,
    inputFill: inputFill ?? this.inputFill,
    inputBorder: inputBorder ?? this.inputBorder,
    inputHint: inputHint ?? this.inputHint,
    addWalletBackground: addWalletBackground ?? this.addWalletBackground,
    addWalletBorderColor: addWalletBorderColor ?? this.addWalletBorderColor,
    workspaceIconBackground:
        workspaceIconBackground ?? this.workspaceIconBackground,
    workspaceIconForeground:
        workspaceIconForeground ?? this.workspaceIconForeground,
    statsGradientStart: statsGradientStart ?? this.statsGradientStart,
    statsGradientEnd: statsGradientEnd ?? this.statsGradientEnd,
    statsOnGradient: statsOnGradient ?? this.statsOnGradient,
    statsSentColor: statsSentColor ?? this.statsSentColor,
    statsReceivedColor: statsReceivedColor ?? this.statsReceivedColor,
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
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputHint: Color.lerp(inputHint, other.inputHint, t)!,
      addWalletBackground:
          Color.lerp(addWalletBackground, other.addWalletBackground, t)!,
      addWalletBorderColor:
          Color.lerp(addWalletBorderColor, other.addWalletBorderColor, t)!,
      workspaceIconBackground: Color.lerp(
        workspaceIconBackground,
        other.workspaceIconBackground,
        t,
      )!,
      workspaceIconForeground: Color.lerp(
        workspaceIconForeground,
        other.workspaceIconForeground,
        t,
      )!,
      statsGradientStart:
          Color.lerp(statsGradientStart, other.statsGradientStart, t)!,
      statsGradientEnd:
          Color.lerp(statsGradientEnd, other.statsGradientEnd, t)!,
      statsOnGradient: Color.lerp(statsOnGradient, other.statsOnGradient, t)!,
      statsSentColor: Color.lerp(statsSentColor, other.statsSentColor, t)!,
      statsReceivedColor:
          Color.lerp(statsReceivedColor, other.statsReceivedColor, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}

/// Convenience extension — use [context.appColors] anywhere in the widget tree.
extension AppColorExtensionX on BuildContext {
  AppColorExtension get appColors =>
      Theme.of(this).extension<AppColorExtension>()!;
}

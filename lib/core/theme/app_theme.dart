import 'package:flutter/material.dart';

import 'app_color_extension.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: Color(0x1A111C2D),
      scrim: Color(0x66111C2D),
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.onInverseSurface,
      inversePrimary: AppColors.inversePrimary,
      surfaceTint: AppColors.surfaceTint,
    ),
    textTheme: _textTheme,
    extensions: const [AppColorExtension.light()],
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.surface,
    dividerColor: AppColors.outlineVariant,
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryFixedDim,
      onPrimary: AppColors.onPrimaryFixed,
      primaryContainer: AppColors.onPrimaryFixedVariant,
      onPrimaryContainer: AppColors.primaryFixed,
      secondary: AppColors.secondaryFixedDim,
      onSecondary: AppColors.onSecondaryFixed,
      secondaryContainer: AppColors.onSecondaryFixedVariant,
      onSecondaryContainer: AppColors.secondaryFixed,
      tertiary: AppColors.tertiaryFixedDim,
      onTertiary: AppColors.onTertiaryFixed,
      tertiaryContainer: AppColors.onTertiaryFixedVariant,
      onTertiaryContainer: AppColors.tertiaryFixed,
      error: AppColors.errorContainer,
      onError: AppColors.onErrorContainer,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.onError,
      surface: AppColors.inverseSurface,
      onSurface: AppColors.onInverseSurface,
      surfaceContainerHighest: AppColors.onPrimaryFixedVariant,
      onSurfaceVariant: AppColors.primaryFixed,
      outline: AppColors.outlineVariant,
      outlineVariant: AppColors.outline,
      shadow: Color(0xCC000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.surface,
      onInverseSurface: AppColors.onSurface,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primaryFixedDim,
    ),
    textTheme: _textTheme,
    extensions: const [AppColorExtension.dark()],
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      filled: true,
      fillColor: AppColors.onPrimaryFixedVariant,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: AppColors.onSecondaryFixedVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    scaffoldBackgroundColor: AppColors.inverseSurface,
    canvasColor: AppColors.inverseSurface,
    dividerColor: AppColors.outline,
  );

  // Shared text theme — same scale for both themes, color resolved by brightness
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      fontFamily: 'BeVietnamPro',
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      fontFamily: 'BeVietnamPro',
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      fontFamily: 'BeVietnamPro',
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      fontFamily: 'BeVietnamPro',
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      fontFamily: 'BeVietnamPro',
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: 'BeVietnamPro',
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      fontFamily: 'Inter',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Inter',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Inter',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Inter',
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      fontFamily: 'Inter',
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFamily: 'Inter',
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFamily: 'Inter',
    ),
  );
}

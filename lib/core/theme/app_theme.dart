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
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.primary),
    ),
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
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      filled: true,
      fillColor: AppColors.inputFill,
      hintStyle: const TextStyle(
        color: AppColors.inputHint,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
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
    scaffoldBackgroundColor: AppColors.inverseSurface,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.neutral,
      surfaceTintColor: AppColors.neutral,
      iconTheme: IconThemeData(color: AppColors.primaryFixedDim),
    ),
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
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.errorContainer, width: 1),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        borderSide: BorderSide(color: AppColors.errorContainer, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      filled: true,
      fillColor: AppColors.inputFill.withValues(
        alpha: 0.1,
      ), // Slightly different for dark mode
      hintStyle: const TextStyle(
        color: AppColors.inputHint,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: AppColors.onSecondaryFixedVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    canvasColor: AppColors.inverseSurface,
    dividerColor: AppColors.outline,
  );

  // Shared text theme — same scale for both themes, color resolved by brightness
  // Cairo font family for all text styles (RTL-optimized Arabic font)
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.25,
      fontFamily: 'Cairo',
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w800,
      fontFamily: 'Cairo',
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      fontFamily: 'Cairo',
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      fontFamily: 'Cairo',
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      fontFamily: 'Cairo',
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: 'Cairo',
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: 'Cairo',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Cairo',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Cairo',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Cairo',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Cairo',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Cairo',
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      fontFamily: 'Cairo',
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFamily: 'Cairo',
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFamily: 'Cairo',
    ),
  );
}

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Stitch design system: Family E-Wallet Tracker
  static const Color seedColor = Color(0xFF0058BE);

  // Core brand palette (Stitch Design System)
  static const Color primary = Color(0xFF0058BE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF002B5E);
  static const Color primaryFixed = Color(0xFFBFDBFE);
  static const Color primaryFixedDim = Color(0xFF93C5FD);
  static const Color onPrimaryFixed = Color(0xFF001A3B);
  static const Color onPrimaryFixedVariant = Color(0xFF003D85);

  static const Color secondary = Color(0xFF006C49);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD1FAE5);
  static const Color onSecondaryContainer = Color(0xFF003624);
  static const Color secondaryFixed = Color(0xFFA7F3D0);
  static const Color secondaryFixedDim = Color(0xFF6EE7B7);
  static const Color onSecondaryFixed = Color(0xFF002015);
  static const Color onSecondaryFixedVariant = Color(0xFF004D34);

  static const Color tertiary = Color(0xFF825100);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF422800);
  static const Color tertiaryFixed = Color(0xFFFDE68A);
  static const Color tertiaryFixedDim = Color(0xFFFCD34D);
  static const Color onTertiaryFixed = Color(0xFF211400);
  static const Color onTertiaryFixedVariant = Color(0xFF613C00);

  static const Color neutral = Color(0xFF1E293B);

  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  // Transaction semantics from Stitch brief
  static const Color success = Color(0xFF006C49); // Mapped to Secondary
  static const Color warning = Color(0xFF825100); // Mapped to Tertiary
  static const Color danger = Color(0xFFEF4444); // Fallback standard red
  static const Color info = Color(0xFF0058BE); // Mapped to Primary

  static const Color amountLow = Color(0xFF9CA3AF);
  static const Color amountMedium = Color(0xFF3B82F6);
  static const Color amountHigh = Color(0xFFFB923C);
  static const Color amountVeryHigh = Color(0xFFB91C1C);

  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFE2E8F0);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFE2E8F0);
  static const Color surfaceContainerHigh = Color(0xFFCBD5E1);
  static const Color surfaceContainerHighest = Color(0xFFBFCBDC);
  static const Color surfaceVariant = Color(0xFFE2E8F0);

  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color outline = Color(0xFF64748B);
  static const Color outlineVariant = Color(0xFFCBD5E1);

  static const Color inverseSurface = Color(0xFF1E293B);
  static const Color onInverseSurface = Color(0xFFE2E8F0);
  static const Color inversePrimary = Color(0xFF93C5FD);
  static const Color surfaceTint = Color(0xFF3B82F6);

  static const Color background = surface;
  static const Color onBackground = onSurface;

  static const Color black = Color(0xFF000000);
}

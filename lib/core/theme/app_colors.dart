import 'package:flutter/material.dart';

/// Static, mode-independent color constants.
/// ─────────────────────────────────────────
/// Rules:
///   • Never use these directly in widgets for anything that should adapt to
///     light/dark mode.  Use [AppColorExtension] via [context.appColors] or
///     [Theme.of(context).colorScheme] instead.
///   • These are source-of-truth for the palette that feeds both
///     [ColorScheme] and [AppColorExtension].
abstract final class AppColors {
  // ── Brand palette ────────────────────────────────────────────────────────
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

  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  // ── Light surface system ─────────────────────────────────────────────────
  static const Color surface = Color(0xFFF8FAFC);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color outline = Color(0xFF64748B);
  static const Color outlineVariant = Color(0xFFCBD5E1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFE2E8F0);
  static const Color surfaceContainerHigh = Color(0xFFCBD5E1);
  static const Color surfaceContainerHighest = Color(0xFFBFCBDC);

  // ── Dark surface system (Slate scale) ────────────────────────────────────
  static const Color darkSurface = Color(0xFF0F172A); // Slate-900
  static const Color darkSurfaceContainer = Color(0xFF1E293B); // Slate-800
  static const Color darkSurfaceContainerHigh = Color(0xFF334155); // Slate-700
  static const Color darkSurfaceContainerHighest = Color(
    0xFF475569,
  ); // Slate-600
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF64748B);
  static const Color darkOutlineVariant = Color(0xFF334155);

  // ── Inverse ──────────────────────────────────────────────────────────────
  static const Color inverseSurface = darkSurface;
  static const Color onInverseSurface = Color(0xFFE2E8F0);
  static const Color inversePrimary = primaryFixedDim;
  static const Color surfaceTint = Color(0xFF3B82F6);

  // ── Absolutes (always safe to use directly) ───────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ── Wallet provider brands (always fixed) ─────────────────────────────────
  static const Color vodafoneRed = Color(0xFFE60000);
  static const Color orangeMoney = Color(0xFFFF7900);
  static const Color etisalatGreen = Color(0xFF7CB342);
  static const Color instaPayNavy = Color(0xFF9b51e0);
  static const Color wePayPurple = Color(0xFF5D1D50);
  static const Color fawryYellow = Color(0xFFFACC15);
  static const Color bankSlate = Color(0xFF64748B);
  static const Color providerUnknownNeutral = Color(0xFF94A3B8);
}

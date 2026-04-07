import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Single seed for ColorScheme.fromSeed(). Update to match brand palette.
  static const Color seedColor = Color(0xFF1A73E8);

  // Semantic colors — access via Theme.of(context).extension<AppColorExtension>()!
  // Never use these constants directly in widget trees.
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC04);
  static const Color danger = Color(0xFFEA4335);
  static const Color info = Color(0xFF4285F4);

  // Neutrals (used in ThemeData component themes if needed)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey900 = Color(0xFF212121);
}

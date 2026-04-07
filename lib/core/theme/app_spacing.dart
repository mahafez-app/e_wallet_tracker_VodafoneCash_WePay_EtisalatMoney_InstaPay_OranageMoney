import 'package:flutter/material.dart';

import 'app_responsive.dart';

abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Common EdgeInsets
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xl,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static double adaptive(double value) => AppResponsive.width(value);
}

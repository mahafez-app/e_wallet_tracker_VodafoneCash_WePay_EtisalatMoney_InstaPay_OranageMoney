import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppResponsive {
  static double width(num value) => value.w;

  static double height(num value) => value.h;

  static double radius(num value) => value.r;

  static double font(num value) => value.sp;

  static EdgeInsets symmetricPadding({num horizontal = 0, num vertical = 0}) =>
      EdgeInsets.symmetric(
        horizontal: width(horizontal),
        vertical: height(vertical),
      );

  static EdgeInsets onlyPadding({
    num left = 0,
    num top = 0,
    num right = 0,
    num bottom = 0,
  }) => EdgeInsets.only(
    left: width(left),
    top: height(top),
    right: width(right),
    bottom: height(bottom),
  );

  static EdgeInsets horizontalPadding(num value) =>
      EdgeInsets.symmetric(horizontal: width(value));

  static EdgeInsets verticalPadding(num value) =>
      EdgeInsets.symmetric(vertical: height(value));

  static EdgeInsets allPadding(num value) => EdgeInsets.all(radius(value));
}

extension AppResponsiveNumExtension on num {
  double get responsiveWidth => AppResponsive.width(this);

  double get responsiveHeight => AppResponsive.height(this);

  double get responsiveRadius => AppResponsive.radius(this);

  double get responsiveFont => AppResponsive.font(this);

  Widget get verticalSpace => SizedBox(height: responsiveHeight);

  Widget get horizontalSpace => SizedBox(width: responsiveWidth);
}

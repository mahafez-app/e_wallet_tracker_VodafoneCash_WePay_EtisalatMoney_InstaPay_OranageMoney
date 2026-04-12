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

  static EdgeInsetsDirectional onlyPadding({
    num start = 0,
    num top = 0,
    num end = 0,
    num bottom = 0,
  }) => EdgeInsetsDirectional.only(
    start: width(start),
    top: height(top),
    end: width(end),
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

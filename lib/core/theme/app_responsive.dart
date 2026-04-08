import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppResponsive {
  static double width(num value) => value.w;

  static double height(num value) => value.h;

  static double radius(num value) => value.r;

  static double font(num value) => value.sp;

  static EdgeInsets symmetric({
    required num horizontal,
    required num vertical,
  }) => EdgeInsets.symmetric(
    horizontal: width(horizontal),
    vertical: height(vertical),
  );

  static EdgeInsets all(num value) => EdgeInsets.all(radius(value));
}

extension AppResponsiveNumExtension on num {
  double get responsiveWidth => AppResponsive.width(this);

  double get responsiveHeight => AppResponsive.height(this);

  double get responsiveRadius => AppResponsive.radius(this);

  double get responsiveFont => AppResponsive.font(this);

  Widget get verticalSpace => SizedBox(height: responsiveHeight);

  Widget get horizontalSpace => SizedBox(width: responsiveWidth);
}

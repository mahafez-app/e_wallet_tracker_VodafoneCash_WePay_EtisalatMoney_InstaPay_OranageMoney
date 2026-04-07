import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_responsive.dart';
import '../utils/app_assets.dart';

enum AppLogoShape { roundedRectangle, circle }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size,
    this.shape = AppLogoShape.roundedRectangle,
    this.roundedRectangleRadius,
  });

  final double? size;
  final AppLogoShape shape;
  final double? roundedRectangleRadius;

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 140.responsiveWidth;
    final logo = SvgPicture.asset(
      AppAssets.appLogo,
      width: logoSize,
      height: logoSize,
      fit: BoxFit.cover,
    );

    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: switch (shape) {
        AppLogoShape.circle => ClipOval(child: logo),
        AppLogoShape.roundedRectangle => ClipRRect(
          borderRadius: BorderRadius.circular(
            roundedRectangleRadius ?? AppResponsive.radius(24),
          ),
          child: logo,
        ),
      },
    );
  }
}

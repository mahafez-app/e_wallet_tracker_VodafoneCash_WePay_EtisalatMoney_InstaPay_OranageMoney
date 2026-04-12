// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/skeleton/app_skeleton_box.dart';

class InvitationCardSkeleton extends StatelessWidget {
  const InvitationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 18.responsiveRadius,
            offset: Offset(0, 8.responsiveHeight),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4.responsiveWidth,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(24.responsiveRadius),
                  bottomStart: Radius.circular(24.responsiveRadius),
                ),
              ),
            ),
          ),
          Padding(
            padding: AppResponsive.onlyPadding(
              start: AppSpacing.xl,
              top: AppSpacing.xl,
              end: AppSpacing.xl,
              bottom: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _InvitationHeaderSkeleton(),
                AppSpacing.lg.verticalSpace,
                AppSkeletonBox(
                  width: 140.responsiveWidth,
                  height: 14.responsiveHeight,
                  borderRadius: BorderRadius.circular(999.responsiveRadius),
                ),
                AppSpacing.xl.verticalSpace,
                const _InvitationActionsSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationHeaderSkeleton extends StatelessWidget {
  const _InvitationHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeletonBox(width: 180.responsiveWidth, height: 20.responsiveHeight),
        AppSpacing.sm.verticalSpace,
        AppSkeletonBox(
          width: 128.responsiveWidth,
          height: 14.responsiveHeight,
          borderRadius: BorderRadius.circular(999.responsiveRadius),
        ),
      ],
    );
  }
}

class _InvitationActionsSkeleton extends StatelessWidget {
  const _InvitationActionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSkeletonBox(
            height: 44.responsiveHeight,
            borderRadius: BorderRadius.circular(14.responsiveRadius),
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: AppSkeletonBox(
            height: 44.responsiveHeight,
            borderRadius: BorderRadius.circular(14.responsiveRadius),
          ),
        ),
      ],
    );
  }
}

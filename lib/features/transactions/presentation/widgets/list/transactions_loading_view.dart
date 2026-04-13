// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/skeleton/app_skeleton_box.dart';

class TransactionsLoadingView extends StatelessWidget {
  const TransactionsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.pagePadding,
      children: const [
        _TransactionsDateGroupSkeleton(),
        _TransactionsDateGroupSkeleton(),
      ],
    );
  }
}

class _TransactionsDateGroupSkeleton extends StatelessWidget {
  const _TransactionsDateGroupSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeletonBox(
          width: 140.responsiveWidth,
          height: 18.responsiveHeight,
          borderRadius: BorderRadius.circular(999.responsiveRadius),
        ),
        AppSpacing.md.verticalSpace,
        const _TransactionsCardSkeleton(),
        AppSpacing.md.verticalSpace,
        const _TransactionsCardSkeleton(),
        AppSpacing.lg.verticalSpace,
      ],
    );
  }
}

class _TransactionsCardSkeleton extends StatelessWidget {
  const _TransactionsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonBox(
      width: double.infinity,
      height: 164.responsiveHeight,
      borderRadius: BorderRadius.circular(20.responsiveRadius),
      child: Padding(
        padding: AppResponsive.allPadding(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeletonBox(
              width: 46.responsiveRadius,
              height: 46.responsiveRadius,
              borderRadius: BorderRadius.circular(14.responsiveRadius),
            ),
            AppSpacing.md.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppSkeletonBox(
                        width: 90.responsiveWidth,
                        height: 14.responsiveHeight,
                      ),
                      const Spacer(),
                      AppSkeletonBox(
                        width: 82.responsiveWidth,
                        height: 16.responsiveHeight,
                      ),
                    ],
                  ),
                  AppSpacing.sm.verticalSpace,
                  AppSkeletonBox(
                    width: 148.responsiveWidth,
                    height: 10.responsiveHeight,
                    borderRadius: BorderRadius.circular(999.responsiveRadius),
                  ),
                  AppSpacing.md.verticalSpace,
                  AppSkeletonBox(
                    width: double.infinity,
                    height: 30.responsiveHeight,
                    borderRadius: BorderRadius.circular(16.responsiveRadius),
                  ),
                  AppSpacing.xs.verticalSpace,
                  AppSkeletonBox(
                    width: 176.responsiveWidth,
                    height: 30.responsiveHeight,
                    borderRadius: BorderRadius.circular(16.responsiveRadius),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

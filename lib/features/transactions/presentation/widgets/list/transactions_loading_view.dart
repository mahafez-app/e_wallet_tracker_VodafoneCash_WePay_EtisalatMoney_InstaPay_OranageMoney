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
    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeletonBox(
            width: 48.responsiveRadius,
            height: 48.responsiveRadius,
            borderRadius: BorderRadius.circular(16.responsiveRadius),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppSkeletonBox(
                      width: 100.responsiveWidth,
                      height: 16.responsiveHeight,
                    ),
                    const Spacer(),
                    AppSkeletonBox(
                      width: 80.responsiveWidth,
                      height: 20.responsiveHeight,
                    ),
                  ],
                ),
                AppSpacing.sm.verticalSpace,
                AppSkeletonBox(
                  width: 160.responsiveWidth,
                  height: 12.responsiveHeight,
                  borderRadius: BorderRadius.circular(999.responsiveRadius),
                ),
                AppSpacing.lg.verticalSpace,
                AppSkeletonBox(
                  width: double.infinity,
                  height: 36.responsiveHeight,
                  borderRadius: BorderRadius.circular(16.responsiveRadius),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

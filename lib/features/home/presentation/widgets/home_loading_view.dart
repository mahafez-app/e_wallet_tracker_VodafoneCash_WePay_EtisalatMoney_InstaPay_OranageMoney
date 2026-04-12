// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton/app_skeleton_box.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [_HomeLoadingHeader(), _HomeLoadingContent()],
      ),
    );
  }
}

class _HomeLoadingHeader extends StatelessWidget {
  const _HomeLoadingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [_HomeLoadingIdentity(), _HomeLoadingActions()],
      ),
    );
  }
}

class _HomeLoadingIdentity extends StatelessWidget {
  const _HomeLoadingIdentity({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSkeletonBox(
          width: 48.responsiveRadius,
          height: 48.responsiveRadius,
          shape: BoxShape.circle,
        ),
        AppSpacing.md.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeletonBox(
              width: 72.responsiveWidth,
              height: 12.responsiveHeight,
              borderRadius: BorderRadius.circular(999.responsiveRadius),
            ),
            AppSpacing.sm.verticalSpace,
            AppSkeletonBox(
              width: 118.responsiveWidth,
              height: 20.responsiveHeight,
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeLoadingActions extends StatelessWidget {
  const _HomeLoadingActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSkeletonBox(
          width: 40.responsiveRadius,
          height: 40.responsiveRadius,
          shape: BoxShape.circle,
        ),
        AppSpacing.xs.horizontalSpace,
        AppSkeletonBox(
          width: 40.responsiveRadius,
          height: 40.responsiveRadius,
          shape: BoxShape.circle,
        ),
      ],
    );
  }
}

class _HomeLoadingContent extends StatelessWidget {
  const _HomeLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeletonBox(
            width: double.infinity,
            height: 212.responsiveHeight,
            borderRadius: BorderRadius.circular(32.responsiveRadius),
          ),
          AppSpacing.xxl.verticalSpace,
          const _HomeLoadingSectionHeader(),
          AppSpacing.md.verticalSpace,
          SizedBox(
            height: 151.responsiveHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, _) => AppSpacing.md.horizontalSpace,
              itemBuilder: (_, _) => AppSkeletonBox(
                width: 250.responsiveWidth,
                height: 151.responsiveHeight,
                borderRadius: BorderRadius.circular(24.responsiveRadius),
              ),
            ),
          ),
          AppSpacing.xxl.verticalSpace,
          const _HomeLoadingSectionHeader(),
          AppSpacing.md.verticalSpace,
          const _HomeLoadingWorkspaceCard(),
          AppSpacing.md.verticalSpace,
          const _HomeLoadingWorkspaceCard(),
        ],
      ),
    );
  }
}

class _HomeLoadingSectionHeader extends StatelessWidget {
  const _HomeLoadingSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppSkeletonBox(width: 132.responsiveWidth, height: 20.responsiveHeight),
        AppSkeletonBox(
          width: 92.responsiveWidth,
          height: 18.responsiveHeight,
          borderRadius: BorderRadius.circular(999.responsiveRadius),
        ),
      ],
    );
  }
}

class _HomeLoadingWorkspaceCard extends StatelessWidget {
  const _HomeLoadingWorkspaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonBox(
      width: double.infinity,
      height: 138.responsiveHeight,
      borderRadius: BorderRadius.circular(20.responsiveRadius),
    );
  }
}

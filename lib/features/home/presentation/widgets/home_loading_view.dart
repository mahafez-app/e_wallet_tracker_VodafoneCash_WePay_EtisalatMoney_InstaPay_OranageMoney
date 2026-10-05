// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

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
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.lg,
        vertical: MahafezSpacing.lg,
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
        MahafezSkeletonBox(
          width: 48.responsiveRadius,
          height: 48.responsiveRadius,
          shape: BoxShape.circle,
        ),
        MahafezSpacing.md.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MahafezSkeletonBox(
              width: 72.responsiveWidth,
              height: 12.responsiveHeight,
              borderRadius: BorderRadius.circular(999.responsiveRadius),
            ),
            MahafezSpacing.sm.verticalSpace,
            MahafezSkeletonBox(
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
        MahafezSkeletonBox(
          width: 40.responsiveRadius,
          height: 40.responsiveRadius,
          shape: BoxShape.circle,
        ),
        MahafezSpacing.xs.horizontalSpace,
        MahafezSkeletonBox(
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
      padding: MahafezSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MahafezSkeletonBox(
            width: double.infinity,
            height: 212.responsiveHeight,
            borderRadius: BorderRadius.circular(32.responsiveRadius),
          ),
          MahafezSpacing.xxl.verticalSpace,
          const _HomeLoadingSectionHeader(),
          MahafezSpacing.md.verticalSpace,
          SizedBox(
            height: 151.responsiveHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, _) => MahafezSpacing.md.horizontalSpace,
              itemBuilder: (_, _) => MahafezSkeletonBox(
                width: 250.responsiveWidth,
                height: 151.responsiveHeight,
                borderRadius: BorderRadius.circular(24.responsiveRadius),
              ),
            ),
          ),
          MahafezSpacing.xxl.verticalSpace,
          const _HomeLoadingSectionHeader(),
          MahafezSpacing.md.verticalSpace,
          const _HomeLoadingWorkspaceCard(),
          MahafezSpacing.md.verticalSpace,
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
        MahafezSkeletonBox(width: 132.responsiveWidth, height: 20.responsiveHeight),
        MahafezSkeletonBox(
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
    return MahafezSkeletonBox(
      width: double.infinity,
      height: 138.responsiveHeight,
      borderRadius: BorderRadius.circular(20.responsiveRadius),
    );
  }
}

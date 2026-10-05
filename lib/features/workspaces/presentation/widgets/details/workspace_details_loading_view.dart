// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class WorkspaceDetailsLoadingView extends StatelessWidget {
  const WorkspaceDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MahafezSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _WorkspaceSummarySkeleton(),
          _WorkspaceSectionSpacing(),
          _WorkspaceSectionSkeleton(),
          _WorkspaceSectionSpacing(),
          _WorkspaceTransactionsSkeleton(),
          _WorkspaceSectionSpacing(),
          _WorkspaceMembersSkeleton(),
        ],
      ),
    );
  }
}

class _WorkspaceSummarySkeleton extends StatelessWidget {
  const _WorkspaceSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MahafezSkeletonBox(
      width: double.infinity,
      height: 216.responsiveHeight,
      borderRadius: BorderRadius.circular(32.responsiveRadius),
    );
  }
}

class _WorkspaceSectionSpacing extends StatelessWidget {
  const _WorkspaceSectionSpacing({super.key});

  @override
  Widget build(BuildContext context) => MahafezSpacing.xxl.verticalSpace;
}

class _WorkspaceSectionSkeleton extends StatelessWidget {
  const _WorkspaceSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _WorkspaceSectionHeaderSkeleton(),
        MahafezSpacing.md.verticalSpace,
        SizedBox(
          height: 160.responsiveHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, _) => MahafezSpacing.md.horizontalSpace,
            itemBuilder: (_, _) => MahafezSkeletonBox(
              width: 252.responsiveWidth,
              height: 160.responsiveHeight,
              borderRadius: BorderRadius.circular(24.responsiveRadius),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkspaceTransactionsSkeleton extends StatelessWidget {
  const _WorkspaceTransactionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _WorkspaceSectionHeaderSkeleton(),
        MahafezSpacing.md.verticalSpace,
        MahafezSkeletonBox(
          width: double.infinity,
          height: 148.responsiveHeight,
          borderRadius: BorderRadius.circular(20.responsiveRadius),
        ),
      ],
    );
  }
}

class _WorkspaceMembersSkeleton extends StatelessWidget {
  const _WorkspaceMembersSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _WorkspaceSectionHeaderSkeleton(),
        MahafezSpacing.md.verticalSpace,
        SizedBox(
          height: 104.responsiveHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, _) => MahafezSpacing.lg.horizontalSpace,
            itemBuilder: (_, _) => const _WorkspaceMemberSkeleton(),
          ),
        ),
      ],
    );
  }
}

class _WorkspaceSectionHeaderSkeleton extends StatelessWidget {
  const _WorkspaceSectionHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MahafezSkeletonBox(width: 146.responsiveWidth, height: 20.responsiveHeight),
        MahafezSkeletonBox(
          width: 112.responsiveWidth,
          height: 18.responsiveHeight,
          borderRadius: BorderRadius.circular(999.responsiveRadius),
        ),
      ],
    );
  }
}

class _WorkspaceMemberSkeleton extends StatelessWidget {
  const _WorkspaceMemberSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.responsiveWidth,
      child: Column(
        children: [
          MahafezSkeletonBox(
            width: 56.responsiveRadius,
            height: 56.responsiveRadius,
            shape: BoxShape.circle,
          ),
          MahafezSpacing.sm.verticalSpace,
          MahafezSkeletonBox(
            width: 60.responsiveWidth,
            height: 12.responsiveHeight,
            borderRadius: BorderRadius.circular(999.responsiveRadius),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import 'invitation_card_skeleton.dart';

class InvitationsLoadingContent extends StatelessWidget {
  const InvitationsLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: MahafezSpacing.pagePadding,
      children: [
        const _InvitationsOverviewSkeleton(),
        MahafezSpacing.xl.verticalSpace,
        const InvitationCardSkeleton(),
        MahafezSpacing.lg.verticalSpace,
        const InvitationCardSkeleton(),
        MahafezSpacing.lg.verticalSpace,
        const InvitationCardSkeleton(),
      ],
    );
  }
}

class _InvitationsOverviewSkeleton extends StatelessWidget {
  const _InvitationsOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MahafezSkeletonBox(width: 170.responsiveWidth, height: 18.responsiveHeight),
        MahafezSpacing.md.verticalSpace,
        MahafezSkeletonBox(
          width: double.infinity,
          height: 96.responsiveHeight,
          borderRadius: BorderRadius.circular(24.responsiveRadius),
        ),
      ],
    );
  }
}

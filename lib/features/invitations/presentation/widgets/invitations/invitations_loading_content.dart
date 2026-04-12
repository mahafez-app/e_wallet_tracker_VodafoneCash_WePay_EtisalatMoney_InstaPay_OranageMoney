// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/skeleton/app_skeleton_box.dart';
import 'invitation_card_skeleton.dart';

class InvitationsLoadingContent extends StatelessWidget {
  const InvitationsLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      children: [
        const _InvitationsOverviewSkeleton(),
        AppSpacing.xl.verticalSpace,
        const InvitationCardSkeleton(),
        AppSpacing.lg.verticalSpace,
        const InvitationCardSkeleton(),
        AppSpacing.lg.verticalSpace,
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
        AppSkeletonBox(width: 170.responsiveWidth, height: 18.responsiveHeight),
        AppSpacing.md.verticalSpace,
        AppSkeletonBox(
          width: double.infinity,
          height: 96.responsiveHeight,
          borderRadius: BorderRadius.circular(24.responsiveRadius),
        ),
      ],
    );
  }
}

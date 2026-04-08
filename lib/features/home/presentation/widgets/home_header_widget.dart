import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class HomeHeaderWidget extends ConsumerWidget {
  const HomeHeaderWidget({super.key, required this.invitationsCount});

  final int invitationsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final user = ref.watch(currentUserProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.responsiveWidth,
        vertical: AppSpacing.lg.responsiveHeight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _UserAvatarAndName(userName: user?.name, s: s),
          _InvitationsIconBadge(count: invitationsCount),
        ],
      ),
    );
  }
}

class _UserAvatarAndName extends StatelessWidget {
  const _UserAvatarAndName({required this.userName, required this.s});

  final String? userName;
  final S s;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.responsiveRadius,
          height: 48.responsiveRadius,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            userName != null && userName!.isNotEmpty
                ? userName!.substring(0, 1).toUpperCase()
                : 'U',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md.responsiveWidth),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.homeWelcome,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.outline,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              userName ?? s.yourName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InvitationsIconBadge extends StatelessWidget {
  const _InvitationsIconBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {
            // Navigate to invitations
          },
          icon: const Icon(Icons.mail_outline, color: AppColors.onSurface),
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.responsiveWidth,
                vertical: 2.responsiveHeight,
              ),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.white,
                  fontSize: 10.responsiveFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

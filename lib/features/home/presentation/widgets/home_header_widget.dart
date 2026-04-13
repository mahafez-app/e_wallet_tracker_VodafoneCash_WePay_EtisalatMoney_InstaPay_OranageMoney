// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/utils/extensions/name_extension.dart';
import '../../../auth/providers/auth_providers.dart';

class HomeHeaderWidget extends ConsumerWidget {
  const HomeHeaderWidget({
    super.key,
    required this.invitationsCount,
    required this.onOpenInvitations,
    required this.onOpenSettings,
  });

  final int invitationsCount;
  final VoidCallback onOpenInvitations;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Padding(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _UserAvatarAndName(userName: (user?.name).firstNameOrNull),
          _HeaderActions(
            invitationsCount: invitationsCount,
            onOpenInvitations: onOpenInvitations,
            onOpenSettings: onOpenSettings,
          ),
        ],
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions({
    super.key,
    required this.invitationsCount,
    required this.onOpenInvitations,
    required this.onOpenSettings,
  });

  final int invitationsCount;
  final VoidCallback onOpenInvitations;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _InvitationsIconBadge(
          count: invitationsCount,
          onTap: onOpenInvitations,
        ),
        AppSpacing.xs.horizontalSpace,
        _HeaderIconButton(icon: Icons.settings_outlined, onTap: onOpenSettings),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}

class _UserAvatarAndName extends StatelessWidget {
  const _UserAvatarAndName({super.key, required this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final trimmedUserName = userName?.trim();
    final displayName = trimmedUserName?.isNotEmpty == true
        ? trimmedUserName!
        : l10n.yourName;
    final avatarLabel = displayName.substring(0, 1).toUpperCase();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.responsiveRadius,
          height: 48.responsiveRadius,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            avatarLabel,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.welcome,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              displayName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
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
  const _InvitationsIconBadge({
    super.key,
    required this.count,
    required this.onTap,
  });

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.mail_outline, color: colorScheme.onSurface),
        ),
        if (count > 0)
          Positioned(
            right: 4.responsiveWidth,
            top: 0,
            child: Container(
              padding: AppResponsive.symmetricPadding(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

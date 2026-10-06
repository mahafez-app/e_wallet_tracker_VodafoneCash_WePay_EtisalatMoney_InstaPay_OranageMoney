// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/utils/extensions/name_extension.dart';

import 'package:identity_product/identity_product.dart';

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
    final user = ref.watch(identityCurrentUserProvider);

    return Padding(
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.lg,
        vertical: MahafezSpacing.lg,
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
        MahafezSpacing.xs.horizontalSpace,
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.responsiveRadius,
        height: 44.responsiveRadius,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(14.responsiveRadius),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withAlpha(60),
          ),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onSurface,
          size: 22.responsiveRadius,
        ),
      ),
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
          width: 52.responsiveRadius,
          height: 52.responsiveRadius,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primary, colorScheme.primary.withAlpha(180)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha(40),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: colorScheme.onPrimary.withAlpha(40),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            avatarLabel,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
        MahafezSpacing.md.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.welcome,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(160),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              displayName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.7,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _HeaderIconButton(icon: Icons.mail_outline_rounded, onTap: onTap),
        if (count > 0)
          Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            child: GestureDetector(
              onTap: onTap,
              child: Center(
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onError,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.responsiveFont,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

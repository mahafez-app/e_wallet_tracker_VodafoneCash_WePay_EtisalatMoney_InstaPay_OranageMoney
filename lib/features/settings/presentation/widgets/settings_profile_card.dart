// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'settings_card.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({
    super.key,
    required this.user,
    required this.onEditName,
  });

  final UserEntity user;
  final VoidCallback onEditName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final emailLabel = _resolveEmailLabel(context);

    return SettingsCard(
      child: Padding(
        padding: AppResponsive.allPadding(AppSpacing.lg),
        child: Row(
          children: [
            _ProfileAvatar(name: user.name),
            AppSpacing.md.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.xs.verticalSpace,
                  Text(
                    emailLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.md.verticalSpace,
                  TextButton(
                    onPressed: onEditName,
                    style: TextButton.styleFrom(
                      padding: AppResponsive.onlyPadding(
                        end: AppSpacing.md,
                        bottom: AppSpacing.xs,
                      ),
                      overlayColor: Colors.transparent,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: AlignmentDirectional.centerStart,
                      foregroundColor: colorScheme.primary,
                    ),
                    child: Text(
                      context.l10n.userSettingsEditNameAction,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveEmailLabel(BuildContext context) {
    final email = user.email?.trim();
    if (email == null || email.isEmpty) {
      return context.l10n.userSettingsNoEmailLabel;
    }

    return email;
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 64.responsiveWidth,
      height: 64.responsiveHeight,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) {
      return '';
    }

    return parts.map((part) => part.characters.first).join(' ');
  }
}

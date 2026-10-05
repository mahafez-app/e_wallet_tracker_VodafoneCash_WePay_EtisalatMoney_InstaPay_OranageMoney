// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

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
    final colors = context.mahafezColors;

    return SettingsCard(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withAlpha(220),
              colors.cardBackground,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
          child: Row(
            children: [
              _ProfileAvatar(name: user.name),
              MahafezSpacing.md.horizontalSpace,
              Expanded(
                child: _ProfileDetails(
                  name: user.name,
                  emailLabel: _resolveEmailLabel(context),
                ),
              ),
              MahafezSpacing.lg.horizontalSpace,
              _EditNameButton(
                tooltip: context.l10n.userSettingsEditNameAction,
                onPressed: onEditName,
              ),
            ],
          ),
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

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({
    super.key,
    required this.name,
    required this.emailLabel,
  });

  final String name;
  final String emailLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        MahafezSpacing.xs.verticalSpace,
        FittedBox(
          child: Text(
            emailLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _EditNameButton extends StatelessWidget {
  const _EditNameButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: Size(40.responsiveWidth, 40.responsiveHeight),
        ),
        icon: Icon(Icons.edit_outlined, size: 18.responsiveRadius),
      ),
    );
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
      width: 50.responsiveRadius,
      height: 50.responsiveRadius,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(200),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
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

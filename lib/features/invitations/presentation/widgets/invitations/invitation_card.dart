// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.createdAt,
    required this.workspaceName,
    required this.inviterName,
    required this.isAccepting,
    required this.isDeclining,
    required this.isEnabled,
    required this.onAccept,
    required this.onDecline,
  });

  final DateTime createdAt;
  final String workspaceName;
  final String inviterName;
  final bool isAccepting;
  final bool isDeclining;
  final bool isEnabled;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: _cardDecoration(colors),
      child: Stack(
        children: [
          const _AccentBar(),
          Padding(
            padding: AppResponsive.onlyPadding(
              start: AppSpacing.xl,
              top: AppSpacing.xl,
              end: AppSpacing.xl,
              bottom: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InvitationHeader(
                  workspaceName: workspaceName,
                  inviterName: inviterName,
                ),
                AppSpacing.lg.verticalSpace,
                _InvitationMeta(createdAt: createdAt),
                AppSpacing.xl.verticalSpace,
                _InvitationActions(
                  isAccepting: isAccepting,
                  isDeclining: isDeclining,
                  isEnabled: isEnabled,
                  onAccept: onAccept,
                  onDecline: onDecline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(AppColorExtension colors) {
    return BoxDecoration(
      color: colors.cardBackground,
      borderRadius: BorderRadius.circular(24.responsiveRadius),
      border: Border.all(color: colors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: colors.cardShadow,
          blurRadius: 18.responsiveRadius,
          offset: Offset(0, 8.responsiveHeight),
        ),
      ],
    );
  }
}

class _AccentBar extends StatelessWidget {
  const _AccentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 4.responsiveWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(24.responsiveRadius),
            bottomStart: Radius.circular(24.responsiveRadius),
          ),
        ),
      ),
    );
  }
}

class _InvitationHeader extends StatelessWidget {
  const _InvitationHeader({
    super.key,
    required this.workspaceName,
    required this.inviterName,
  });

  final String workspaceName;
  final String inviterName;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52.responsiveWidth,
          height: 52.responsiveWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18.responsiveRadius),
          ),
          child: Icon(
            Icons.group_add_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24.responsiveRadius,
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workspaceName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppSpacing.xs.verticalSpace,
              Text(
                context.l10n.invitationSentBy(inviterName),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: AppResponsive.symmetricPadding(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.infoContainer.withAlpha(90),
            borderRadius: BorderRadius.circular(999.responsiveRadius),
          ),
          child: Text(
            context.l10n.invitationsPendingStatus,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.info,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvitationMeta extends StatelessWidget {
  const _InvitationMeta({super.key, required this.createdAt});

  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          color: theme.colorScheme.onSurfaceVariant,
          size: 18.responsiveRadius,
        ),
        AppSpacing.sm.horizontalSpace,
        Expanded(
          child: Text(
            createdAt.toTimeAgo(context),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvitationActions extends StatelessWidget {
  const _InvitationActions({
    super.key,
    required this.isAccepting,
    required this.isDeclining,
    required this.isEnabled,
    required this.onAccept,
    required this.onDecline,
  });

  final bool isAccepting;
  final bool isDeclining;
  final bool isEnabled;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final canTap = isEnabled && !isAccepting && !isDeclining;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: context.l10n.invitationsAcceptAction,
            isLoading: isAccepting,
            onPressed: canTap ? onAccept : null,
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: AppButton(
            label: context.l10n.invitationsDeclineAction,
            type: AppButtonType.secondary,
            isLoading: isDeclining,
            onPressed: canTap ? onDecline : null,
          ),
        ),
      ],
    );
  }
}

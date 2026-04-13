// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/sms_permission_controller.dart';
import 'sms_permission_feature_item.dart';

class SmsPermissionsBody extends ConsumerWidget {
  const SmsPermissionsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smsPermissionController = ref.read(
      smsPermissionControllerProvider.notifier,
    );
    ref.listen<SmsPermissionState>(smsPermissionControllerProvider, (
      previous,
      next,
    ) {
      if (next.error != null) {
        AppSnackbar.show(
          context,
          message: next.error!.toLocalizedString(context),
          type: AppSnackbarType.error,
        );
        smsPermissionController.clearError();
        return;
      }

      final hasCompletedRequest =
          previous?.isRequesting == true &&
          !next.isRequesting &&
          next.hasPermission;
      if (hasCompletedRequest && context.mounted) {
        context.go(AppRoutes.home);
      }
    });

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final state = ref.watch(smsPermissionControllerProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppResponsive.allPadding(AppSpacing.xl),
            child: Column(
              children: [
                AppSpacing.xxxl.verticalSpace,
                const _PermissionHeader(),
                AppSpacing.xxl.verticalSpace,
                Text(
                  l10n.smsPermissionTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.md.verticalSpace,
                Text(
                  l10n.smsPermissionDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.xxxl.verticalSpace,
                SmsPermissionFeatureItem(
                  icon: Icons.update,
                  title: l10n.smsPermissionAutoUpdateTitle,
                  description: l10n.smsPermissionAutoUpdateDesc,
                ),
                AppSpacing.lg.verticalSpace,
                SmsPermissionFeatureItem(
                  icon: Icons.shield_outlined,
                  title: l10n.smsPermissionPrivacyTitle,
                  description: l10n.smsPermissionPrivacyDesc,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppResponsive.allPadding(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: l10n.allowAndContinue,
                isLoading: state.isRequesting,
                onPressed: smsPermissionController.requestPermission,
              ),
              AppSpacing.md.verticalSpace,
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(
                  l10n.notNow,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PermissionHeader extends StatelessWidget {
  const _PermissionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Icon(
            Icons.chat_bubble_rounded,
            size: 64.responsiveRadius,
            color: theme.colorScheme.primary,
          ),
          Transform.translate(
            offset: Offset(12.responsiveWidth, -12.responsiveHeight),
            child: Container(
              padding: AppResponsive.allPadding(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.security,
                size: 20.responsiveRadius,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

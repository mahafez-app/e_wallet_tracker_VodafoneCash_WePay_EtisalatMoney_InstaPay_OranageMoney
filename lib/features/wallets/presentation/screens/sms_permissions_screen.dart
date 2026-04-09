import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../providers/wallets_providers.dart';

class SmsPermissionsScreen extends StatelessWidget {
  const SmsPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: _SmsPermissionsBody()));
  }
}

class _SmsPermissionsBody extends ConsumerWidget {
  const _SmsPermissionsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppResponsive.allPadding(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppSpacing.xxxl.verticalSpace,
                // Header Icon
                Container(
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
                        offset: Offset(
                          12.responsiveWidth,
                          -12.responsiveHeight,
                        ),
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
                ),
                AppSpacing.xxl.verticalSpace,
                Text(
                  s.smsPermissionTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.md.verticalSpace,
                Text(
                  s.smsPermissionDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.xxxl.verticalSpace,
                // Feature items
                _FeatureItem(
                  icon: Icons.update,
                  title: s.smsPermissionAutoUpdateTitle,
                  description: s.smsPermissionAutoUpdateDesc,
                ),
                AppSpacing.lg.verticalSpace,
                _FeatureItem(
                  icon: Icons.shield_outlined,
                  title: s.smsPermissionPrivacyTitle,
                  description: s.smsPermissionPrivacyDesc,
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
                label: s.allowAndContinue,
                onPressed: () async {
                  final requestPerm = ref.read(
                    requestSmsPermissionUseCaseProvider,
                  );
                  final result = await requestPerm();

                  if (context.mounted) {
                    result.fold(
                      (failure) => AppSnackbar.show(
                        context,
                        message: failure.toLocalizedString(context),
                        type: AppSnackbarType.error,
                      ),
                      (_) => context.go(AppRoutes.home),
                    );
                  }
                },
              ),
              AppSpacing.md.verticalSpace,
              TextButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                },
                child: Text(
                  s.notNow,
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

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12.responsiveRadius),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                4.responsiveHeight.verticalSpace,
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

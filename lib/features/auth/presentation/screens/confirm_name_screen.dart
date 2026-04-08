import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../generated/l10n.dart';
import '../providers/auth_notifier.dart';
import '../widgets/confirm_name/confirm_name_form.dart';

class ConfirmNameScreen extends StatelessWidget {
  const ConfirmNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(size: 32.responsiveRadius),
            AppSpacing.sm.horizontalSpace,
            Text(
              l10n.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 40.responsiveHeight,
          ),
          child: const _ConfirmNameBody(),
        ),
      ),
    );
  }
}

class _ConfirmNameBody extends ConsumerWidget {
  const _ConfirmNameBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!next.isLoading && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.failureMessage(next.error!)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    final l10n = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSpacing.xxl.verticalSpace,

        // Profile Avatar Icon
        Center(
          child: Container(
            width: 96.responsiveWidth,
            height: 96.responsiveHeight,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(24.responsiveRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 15.responsiveRadius,
                  offset: Offset(0, 10.responsiveHeight),
                  spreadRadius: (-3).responsiveRadius,
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: AppColors.white,
              size: 48.responsiveRadius,
            ),
          ),
        ),

        AppSpacing.xxl.verticalSpace,

        // Title
        Text(
          l10n.whatIsYourName,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        AppSpacing.md.verticalSpace,

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            l10n.nameWillBeDisplayed,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ),

        40.responsiveHeight.verticalSpace,

        // Form
        const ConfirmNameForm(),
      ],
    );
  }
}

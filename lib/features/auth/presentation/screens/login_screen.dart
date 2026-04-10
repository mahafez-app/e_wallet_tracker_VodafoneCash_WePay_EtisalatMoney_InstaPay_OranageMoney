import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../providers/auth_controller.dart';
import '../widgets/login/google_sign_in_button.dart';
import '../widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppResponsive.symmetricPadding(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: _LoginBody(),
        ),
      ),
    );
  }
}

class _LoginBody extends ConsumerWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!next.isLoading && next.error != null) {
        AppSnackbar.show(
          context,
          message: context.failureMessage(next.error!),
          type: AppSnackbarType.error,
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    final l10n = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.lg.verticalSpace,

          // Logo & Header
          Center(
            child: Container(
              padding: AppResponsive.allPadding(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: colorScheme.primary,
                size: 48.responsiveRadius,
              ),
            ),
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          AppSpacing.xxl.verticalSpace,

          // Google Button
          const GoogleSignInButton(),

          AppSpacing.xl.verticalSpace,

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: AppResponsive.horizontalPadding(AppSpacing.md),
                child: Text(
                  l10n.or,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          AppSpacing.xl.verticalSpace,

          const LoginForm(),

          AppSpacing.xxl.verticalSpace,

          const _SignUpPrompt(),
        ],
      ),
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt();

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.xs.horizontalSpace,
        InkWell(
          onTap: () => context.push(AppRoutes.register),
          borderRadius: BorderRadius.circular(AppSpacing.sm.responsiveRadius),
          child: Padding(
            padding: AppResponsive.symmetricPadding(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              l10n.signUpNow,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

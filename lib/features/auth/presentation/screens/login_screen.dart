// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
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
  const _LoginBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!next.isLoading && next.error != null) {
        AppSnackbar.showFailure(context, failure: next.error!);
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.lg.verticalSpace,

          // Logo & Header
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120.responsiveRadius,
                  height: 120.responsiveRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withAlpha(30),
                        colorScheme.primary.withAlpha(0),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: AppResponsive.allPadding(AppSpacing.lg),
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
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: colorScheme.onPrimary,
                    size: 48.responsiveRadius,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.xl.verticalSpace,
          Text(
            l10n.appName.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 32.responsiveFont,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withAlpha(180),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
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
  const _SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/l10n.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_notifier.dart';
import '../widgets/login/login_form.dart';
import '../widgets/login/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
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

    // Using layout from Figma constraints
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.responsiveHeight),

          // Logo & Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 32.responsiveHeight),

          // Google Button
          const GoogleSignInButton(),

          SizedBox(height: AppSpacing.xl),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  l10n.or,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          SizedBox(height: AppSpacing.xl),

          // Login Form
          const LoginForm(),

          SizedBox(height: 32.responsiveHeight),

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.dontHaveAccount,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              InkWell(
                onTap: () => context.push(AppRoutes.register),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
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
          ),
        ],
      ),
    );
  }
}

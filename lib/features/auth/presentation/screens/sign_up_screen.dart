// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_logo.dart';
import '../providers/auth_controller.dart';
import '../widgets/sign_up/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 32),
            MahafezSpacing.sm.horizontalSpace,
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
          padding: MahafezResponsive.symmetricPadding(
            horizontal: MahafezSpacing.lg,
            vertical: MahafezSpacing.xl,
          ),
          child: const _SignUpBody(),
        ),
      ),
    );
  }
}

class _SignUpBody extends ConsumerWidget {
  const _SignUpBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!next.isLoading && next.error != null) {
        MahafezSnackbar.showFailure(context, failure: next.error!);
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MahafezSpacing.lg.verticalSpace,

          // Titles
          Text(
            l10n.createAccount,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          MahafezSpacing.sm.verticalSpace,
          Text(
            l10n.signUpSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          MahafezSpacing.xxxl.verticalSpace,

          // Form
          const SignUpForm(),

          MahafezSpacing.xxl.verticalSpace,

          // Sign In Link
          const _SignInPrompt(),
        ],
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({super.key});

  void _navigateToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        MahafezSpacing.xs.horizontalSpace,
        InkWell(
          onTap: () => _navigateToLogin(context),
          borderRadius: BorderRadius.circular(MahafezSpacing.sm),
          child: Padding(
            padding: MahafezResponsive.symmetricPadding(
              horizontal: MahafezSpacing.xs,
              vertical: MahafezSpacing.xs,
            ),
            child: Text(
              l10n.signIn,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

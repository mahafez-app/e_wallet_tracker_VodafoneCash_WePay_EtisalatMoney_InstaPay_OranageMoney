import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../providers/auth_controller.dart';
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
          padding: AppResponsive.symmetricPadding(
            horizontal: AppSpacing.lg,
            vertical: 40,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSpacing.xxl.verticalSpace,

        Center(
          child: Container(
            width: 96.responsiveWidth,
            height: 96.responsiveHeight,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(24.responsiveRadius),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha(64),
                  blurRadius: 15.responsiveRadius,
                  offset: Offset(0, 10.responsiveHeight),
                  spreadRadius: (-3).responsiveRadius,
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: colorScheme.onPrimary,
              size: 48.responsiveRadius,
            ),
          ),
        ),

        AppSpacing.xxl.verticalSpace,

        Text(
          l10n.whatIsYourName,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        AppSpacing.md.verticalSpace,

        Padding(
          padding: AppResponsive.symmetricPadding(horizontal: AppSpacing.md),
          child: Text(
            l10n.nameWillBeDisplayed,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ),

        40.responsiveHeight.verticalSpace,

        const ConfirmNameForm(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_validators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../generated/l10n.dart';
import '../../providers/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      await ref
          .read(authNotifierProvider.notifier)
          .signInWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Navigation is handled via GoRouterRefreshStream listening to authStateProvider
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final authState = ref.watch(authNotifierProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: l10n.email,
            hintText: l10n.emailPlaceholder,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => AppValidators.email(context, value),
          ),
          AppSpacing.lg.verticalSpace,
          AppTextField(
            label: l10n.password,
            hintText: '••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _togglePasswordVisibility,
            ),
            validator: (value) => AppValidators.required(context, value),
          ),
          AppSpacing.sm.verticalSpace,
          // Align(
          //   alignment: AlignmentDirectional.centerEnd,
          //   child: TextButton(
          //     onPressed: () {
          //       // Implement forgot password functionality
          //     },
          //     child: Text(
          //       l10n.forgotPassword,
          //       style: theme.textTheme.labelLarge?.copyWith(
          //         color: theme.colorScheme.primary,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          AppSpacing.xl.verticalSpace,
          AppButton(
            label: l10n.signIn,
            onPressed: _submit,
            isLoading: authState.loadingMethod == AuthLoadingMethod.email,
          ),
        ],
      ),
    );
  }
}

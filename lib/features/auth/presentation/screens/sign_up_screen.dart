import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../generated/l10n.dart';
import '../providers/auth_notifier.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.responsiveWidth),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 448.responsiveWidth),
              child: const _SignUpScreenBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpScreenBody extends ConsumerStatefulWidget {
  const _SignUpScreenBody();

  @override
  ConsumerState<_SignUpScreenBody> createState() => __SignUpScreenBodyState();
}

class __SignUpScreenBodyState extends ConsumerState<_SignUpScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final result = await authNotifier.signUpWithEmailPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.toLocalizedString(context))),
        );
      },
      (_) {
        // Navigation handled by auth redirect
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            s.createAccount,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.responsiveHeight),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: s.displayName,
              hintText: s.displayNameHint,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return s.displayNameHint;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          SizedBox(height: 16.responsiveHeight),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: s.email,
              hintText: s.emailHint,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return s.emailHint;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          SizedBox(height: 16.responsiveHeight),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: s.password,
              hintText: s.passwordHint,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return s.passwordHint;
              }
              if (value.length < 6) {
                return s.errorAuthWeakPassword;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          SizedBox(height: 32.responsiveHeight),
          FilledButton(
            onPressed: isLoading ? null : _signUp,
            child: isLoading
                ? SizedBox(
                    height: 20.responsiveHeight,
                    width: 20.responsiveWidth,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(s.signUp),
          ),
          SizedBox(height: 32.responsiveHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(s.alreadyHaveAccount),
              TextButton(
                onPressed: isLoading ? null : () => context.pop(),
                child: Text(s.signIn),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../generated/l10n.dart';
import '../providers/auth_notifier.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/sign_in_background_decoration.dart';
import '../widgets/sign_in_button.dart';
import '../widgets/sign_in_divider.dart';
import '../widgets/sign_in_form_fields.dart';
import '../widgets/sign_in_header.dart';
import '../widgets/sign_up_footer.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.signInBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 884.responsiveHeight),
            child: Stack(
              children: [
                const SignInBackgroundDecoration(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.responsiveWidth,
                    vertical: 44.responsiveHeight,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 448.responsiveWidth,
                      ),
                      child: const _SignInScreenBody(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInScreenBody extends ConsumerStatefulWidget {
  const _SignInScreenBody();

  @override
  ConsumerState<_SignInScreenBody> createState() => __SignInScreenBodyState();
}

class __SignInScreenBodyState extends ConsumerState<_SignInScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final result = await authNotifier.signInWithGoogle();

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

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final result = await authNotifier.signInWithEmailPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SignInHeader(appName: s.appName, tagline: s.appTagline),
          SizedBox(height: 32.responsiveHeight),
          GoogleSignInButton(
            onPressed: isLoading ? null : _signInWithGoogle,
            label: s.continueWithGoogle,
          ),
          SizedBox(height: 16.responsiveHeight),
          SignInDivider(label: s.or),
          SizedBox(height: 16.responsiveHeight),
          SignInFormFields(
            emailController: _emailController,
            passwordController: _passwordController,
            formKey: _formKey,
            enabled: !isLoading,
            getLabelEmail: (context) => S.of(context).email,
            getLabelPassword: (context) => S.of(context).password,
            getPlaceholderEmail: (context) => S.of(context).emailPlaceholder,
            getForgotPasswordText: (context) => S.of(context).forgotPassword,
            emailValidator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).emailHint;
              }
              return null;
            },
            passwordValidator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).passwordHint;
              }
              return null;
            },
          ),
          SizedBox(height: 8.responsiveHeight),
          SignInButton(
            onPressed: isLoading ? null : _signInWithEmail,
            label: s.signIn,
            isLoading: isLoading,
          ),
          SizedBox(height: 48.responsiveHeight),
          SignUpFooter(
            enabled: !isLoading,
            dontHaveAccount: s.dontHaveAccount,
            signUpNow: s.signUpNow,
          ),
        ],
      ),
    );
  }
}

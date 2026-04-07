import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../generated/l10n.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_providers.dart';

class ConfirmNameScreen extends StatelessWidget {
  const ConfirmNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.responsiveWidth),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 448.responsiveWidth),
              child: const _ConfirmNameScreenBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmNameScreenBody extends ConsumerStatefulWidget {
  const _ConfirmNameScreenBody();

  @override
  ConsumerState<_ConfirmNameScreenBody> createState() =>
      __ConfirmNameScreenBodyState();
}

class __ConfirmNameScreenBodyState
    extends ConsumerState<_ConfirmNameScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _confirmName() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final result = await authNotifier.confirmUserName(
      uid: user.uid,
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
        context.go(AppRoutes.home);
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
            s.appName,
            style: theme.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 48.responsiveHeight),
          Text(
            s.confirmName,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.responsiveHeight),
          Text(
            s.confirmNameMessage,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.responsiveHeight),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: s.yourName,
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
          SizedBox(height: 32.responsiveHeight),
          FilledButton(
            onPressed: isLoading ? null : _confirmName,
            child: isLoading
                ? SizedBox(
                    height: 20.responsiveHeight,
                    width: 20.responsiveWidth,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(s.confirm),
          ),
        ],
      ),
    );
  }
}

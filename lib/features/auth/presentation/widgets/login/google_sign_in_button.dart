import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../generated/l10n.dart';
import '../../providers/auth_controller.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return AppButton(
      type: AppButtonType.secondary,
      label: l10n.continueWithGoogle,
      onPressed: () {
        ref.read(authNotifierProvider.notifier).signInWithGoogle();
      },
      isLoading: authState.loadingMethod == AuthLoadingMethod.google,
      foregroundColor: theme.colorScheme.onSurface,
      icon: SvgPicture.asset(AppAssets.iconGoogle, width: 24, height: 24),
    );
  }
}

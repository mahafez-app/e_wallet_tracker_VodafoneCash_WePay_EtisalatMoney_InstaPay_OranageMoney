import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../providers/auth_controller.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return MahafezButton(
      type: MahafezButtonType.secondary,
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

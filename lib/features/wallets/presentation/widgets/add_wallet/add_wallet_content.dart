import 'package:flutter/material.dart';

import '../../../../../core/domain/enums/wallet_provider.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/info_card.dart';
import '../../../../../generated/l10n.dart';
import '../../providers/add_wallet_controller.dart';
import 'add_wallet_phone_number_section.dart';
import 'add_wallet_provider_grid.dart';

class AddWalletContent extends StatelessWidget {
  const AddWalletContent({
    super.key,
    required this.state,
    required this.onPhoneNumberChanged,
    required this.onProviderToggled,
    required this.onSubmit,
  });

  final AddWalletState state;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<WalletProvider> onProviderToggled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppResponsive.allPadding(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoCard(text: s.addWalletDescription),
                AppSpacing.lg.verticalSpace,
                AddWalletPhoneNumberSection(
                  state: state,
                  onPhoneNumberChanged: onPhoneNumberChanged,
                ),
                AppSpacing.lg.verticalSpace,
                Text(s.chooseProvider, style: theme.textTheme.titleMedium),
                AppSpacing.md.verticalSpace,
                AddWalletProviderGrid(
                  state: state,
                  onProviderToggled: onProviderToggled,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppResponsive.allPadding(AppSpacing.md),
          child: AppButton(
            label: s.addWalletAction,
            icon: const Icon(Icons.add_circle_outline),
            isLoading: state.isSubmitting,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}

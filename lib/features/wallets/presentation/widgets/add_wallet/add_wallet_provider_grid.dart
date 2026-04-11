import 'package:flutter/material.dart';

import '../../../../../core/domain/enums/wallet_provider.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../providers/add_wallet_controller.dart';

class AddWalletProviderGrid extends StatelessWidget {
  const AddWalletProviderGrid({
    super.key,
    required this.state,
    required this.onProviderToggled,
  });

  final AddWalletState state;
  final ValueChanged<WalletProvider> onProviderToggled;

  @override
  Widget build(BuildContext context) {
    final providers = WalletProvider.values
        .where((provider) => provider != WalletProvider.unknown)
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm.responsiveWidth,
        mainAxisSpacing: AppSpacing.sm.responsiveHeight,
        childAspectRatio: 1.7,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        return _ProviderCard(
          key: ValueKey('_ProviderCard_${provider.name}'),
          provider: provider,
          isSelected: state.selectedProviders.contains(provider),
          onTap: () => onProviderToggled(provider),
        );
      },
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  final WalletProvider provider;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.responsiveRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withAlpha(30)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.responsiveRadius),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2.responsiveWidth : 1.responsiveWidth,
            ),
          ),
          child: Padding(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: AppResponsive.allPadding(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: provider.brandColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(provider.icon, color: provider.brandColor),
                ),
                AppSpacing.xs.verticalSpace,
                Text(
                  provider.displayName(context),
                  style: isSelected
                      ? theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        )
                      : theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

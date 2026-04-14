import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/enums/wallet_provider.dart';
import '../../utils/extensions/wallet_provider_ext.dart';

class WalletProviderIcon extends StatelessWidget {
  const WalletProviderIcon({
    super.key,
    required this.provider,
    required this.size,
    this.fallbackColor,
  });

  final WalletProvider provider;
  final double size;
  final Color? fallbackColor;

  @override
  Widget build(BuildContext context) {
    final assetPath = provider.iconAssetPath;
    final isSvg = assetPath?.toLowerCase().endsWith('.svg') ?? false;

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: assetPath == null
            ? Icon(
                Icons.account_balance_wallet_outlined,
                size: size,
                color: fallbackColor,
              )
            : isSvg
            ? SvgPicture.asset(
                assetPath,
                width: size,
                height: size,
                colorFilter: fallbackColor != null
                    ? ColorFilter.mode(fallbackColor!, BlendMode.srcIn)
                    : null,
              )
            : Image.asset(
                assetPath,
                width: size,
                height: size,
                color: fallbackColor,
                colorBlendMode: fallbackColor != null ? BlendMode.srcIn : null,
              ),
      ),
    );
  }
}

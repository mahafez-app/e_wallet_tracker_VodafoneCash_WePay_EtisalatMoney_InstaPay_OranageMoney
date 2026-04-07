import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_logo_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: _SplashBody()),
    );
  }
}

class _SplashBody extends ConsumerWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(size: 128.responsiveWidth),
          SizedBox(height: 40.responsiveHeight),
          const AppLogoName(),
        ],
      ),
    );
  }
}

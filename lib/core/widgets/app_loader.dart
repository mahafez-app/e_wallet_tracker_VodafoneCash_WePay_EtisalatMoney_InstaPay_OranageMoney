import 'package:flutter/material.dart';

import '../../core/theme/app_responsive.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 56.responsiveRadius,
            height: 56.responsiveRadius,
            child: CircularProgressIndicator(
              strokeWidth: 3.responsiveWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.primary.withAlpha(30),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_controller.value * 0.3),
                child: Container(
                  width: 14.responsiveRadius,
                  height: 14.responsiveRadius,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withAlpha(100),
                        blurRadius: 12 * _controller.value,
                        spreadRadius: 4 * _controller.value,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: 56.responsiveRadius,
            height: 56.responsiveRadius,
            child: CircularProgressIndicator(
              strokeWidth: 3.responsiveWidth,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

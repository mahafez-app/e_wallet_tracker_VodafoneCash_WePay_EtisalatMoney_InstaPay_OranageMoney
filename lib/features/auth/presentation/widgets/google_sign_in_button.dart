import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56.responsiveHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E2A3F),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.responsiveRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.g_mobiledata,
              size: 20.responsiveFont,
              color: Colors.white,
            ),
            SizedBox(width: 12.responsiveWidth),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

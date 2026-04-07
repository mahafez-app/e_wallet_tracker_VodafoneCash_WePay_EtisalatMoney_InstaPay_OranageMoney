import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final user = ref.watch(currentUserProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(s.appName)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, ${user?.displayName ?? 'User'}!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Email: ${user?.email ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'UID: ${user?.uid ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppSpacing.xl),
              const Divider(),
              SizedBox(height: AppSpacing.md),
              const Text('Home Screen - To be implemented in Phase 4'),
              SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => authNotifier.signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/not_found_screen.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Screen - To be implemented')),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings Screen - To be implemented')),
        ),
      ),
    ],
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
// import '../../features/auth/presentation/screens/confirm_name_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/not_found_screen.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    errorBuilder: (context, state) => const NotFoundScreen(),
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateChangesProvider.future).asStream(),
    ),
    redirect: (context, state) {
      final isInitializing = authState.isLoading;
      final user = authState.value;
      final isAuthenticated = user != null;
      final nameConfirmed = user?.nameConfirmed ?? false;

      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isLogin = state.matchedLocation == AppRoutes.login;
      final isRegister = state.matchedLocation == AppRoutes.register;
      final isConfirmName = state.matchedLocation == AppRoutes.confirmName;

      // Still loading auth state, stay on splash
      if (isInitializing && !isSplash) {
        return AppRoutes.splash;
      }

      // Not authenticated, redirect to login (except if already on auth pages)
      if (!isAuthenticated && !isLogin && !isRegister && !isSplash) {
        return AppRoutes.login;
      }

      // Authenticated but name not confirmed, redirect to confirm name
      if (isAuthenticated && !nameConfirmed && !isConfirmName) {
        return AppRoutes.confirmName;
      }

      // Authenticated with confirmed name, redirect from auth pages to home
      if (isAuthenticated && nameConfirmed) {
        if (isLogin || isRegister || isConfirmName || isSplash) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const SignUpScreen(),
      ),
      // GoRoute(
      //   path: AppRoutes.confirmName,
      //   builder: (context, state) => const ConfirmNameScreen(),
      // ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/confirm_name_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/invitations/presentation/screens/invitations_screen.dart';
import '../../features/settings/presentation/screens/sms_permissions_screen.dart';
import '../../features/settings/presentation/screens/user_settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/transactions/presentation/navigation/transactions_route_data.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/wallets/presentation/screens/add_wallet_screen.dart';
import '../../features/wallets/presentation/screens/wallet_details_screen.dart';
import '../../features/reports/presentation/screens/wallet_report_screen.dart';
import '../../features/reports/presentation/screens/workspace_report_screen.dart';
import '../../features/workspaces/presentation/screens/create_workspace_screen.dart';
import '../../features/workspaces/presentation/screens/select_workspace_wallets_screen.dart';
import '../../features/workspaces/presentation/screens/workspace_details_screen.dart';
import '../../features/workspaces/presentation/screens/workspace_settings_screen.dart';
import '../widgets/not_found_screen.dart';
import 'app_routes.dart';

// ---------------------------------------------------------------------------
// RouterNotifier
// ---------------------------------------------------------------------------
// Extends AsyncNotifier<void> so it can watch async providers.
// Implements Listenable so GoRouter can subscribe to it via refreshListenable.
// When either authStateChangesProvider or firestoreUserProfileProvider emits,
// GoRouter re-runs redirect() without recreating the router instance.
// ---------------------------------------------------------------------------

final routerNotifierProvider = AsyncNotifierProvider<RouterNotifier, void>(
  RouterNotifier.new,
);

class RouterNotifier extends AsyncNotifier<void> implements Listenable {
  VoidCallback? _routerListener;

  @override
  Future<void> build() async {
    // Any auth change (sign in / sign out) triggers redirect re-evaluation.
    ref.listen(authStateChangesProvider, (_, _) => _notify());
  }

  void _notify() => _routerListener?.call();

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;

  String? redirect(BuildContext context, GoRouterState state) {
    // Use ref.read — not ref.watch — inside redirect to avoid
    // accidentally creating subscriptions during redirect evaluation.
    final authAsync = ref.read(authStateChangesProvider);

    final location = state.matchedLocation;
    final isSplash = location == AppRoutes.splash;
    final isLogin = location == AppRoutes.login;
    final isRegister = location == AppRoutes.register;
    final isConfirmName = location == AppRoutes.confirmName;
    final isAuthPage = isLogin || isRegister || isConfirmName;

    if (authAsync.isLoading) return null;

    final appUser = authAsync.value;
    final isAuthenticated = appUser != null;

    if (isSplash) return null;

    if (!isAuthenticated) {
      if (isSplash || isAuthPage) return null;
      return AppRoutes.login;
    }

    final isNameConfirmed = appUser.nameConfirmed;

    if (!isNameConfirmed && !isConfirmName) {
      return AppRoutes.confirmName;
    }

    if (isNameConfirmed && (isSplash || isAuthPage)) {
      return AppRoutes.home;
    }

    return null;
  }
}

// ---------------------------------------------------------------------------
// Router Provider
// ---------------------------------------------------------------------------
// GoRouter instance is created once and never recreated.
// refreshListenable = RouterNotifier → redirect re-runs on any notify().
// ---------------------------------------------------------------------------

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    errorBuilder: (context, state) => const NotFoundScreen(),
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
      GoRoute(
        path: AppRoutes.confirmName,
        builder: (context, state) => const ConfirmNameScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.invitations,
        builder: (context, state) => const InvitationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const UserSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.addWallet,
        builder: (context, state) => const AddWalletScreen(),
      ),
      GoRoute(
        path: AppRoutes.addWorkspace,
        builder: (context, state) => const CreateWorkspaceScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceDetails,
        builder: (context, state) {
          final workspaceId = state.pathParameters['workspaceId']!;
          return WorkspaceDetailsScreen(workspaceId: workspaceId);
        },
      ),
      GoRoute(
        path: AppRoutes.workspaceSettings,
        builder: (context, state) {
          final workspaceId = state.pathParameters['workspaceId']!;
          return WorkspaceSettingsScreen(workspaceId: workspaceId);
        },
      ),
      GoRoute(
        path: AppRoutes.workspaceWalletSelection,
        builder: (context, state) {
          final workspaceId = state.pathParameters['workspaceId']!;
          final flow = state.uri.queryParameters['flow'] == 'create'
              ? WorkspaceWalletSelectionFlow.create
              : WorkspaceWalletSelectionFlow.manage;
          return SelectWorkspaceWalletsScreen(
            workspaceId: workspaceId,
            flow: flow,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.smsPermissions,
        builder: (context, state) => const SmsPermissionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.walletDetails,
        builder: (context, state) {
          final walletId = state.pathParameters['walletId']!;
          return WalletDetailsScreen(walletId: walletId);
        },
      ),
      GoRoute(
        path: AppRoutes.transactions,
        builder: (context, state) {
          final transactionsContext = state.extra;
          if (transactionsContext is! TransactionsRouteData) {
            return const NotFoundScreen();
          }
          return TransactionsScreen(transactionsContext: transactionsContext);
        },
      ),
      GoRoute(
        path: AppRoutes.workspaceReports,
        builder: (context, state) {
          final workspaceId = state.pathParameters['workspaceId']!;
          return WorkspaceReportScreen(workspaceId: workspaceId);
        },
      ),
      GoRoute(
        path: AppRoutes.walletReports,
        builder: (context, state) {
          final walletId = state.pathParameters['walletId']!;
          return WalletReportScreen(walletId: walletId);
        },
      ),
    ],
  );
});

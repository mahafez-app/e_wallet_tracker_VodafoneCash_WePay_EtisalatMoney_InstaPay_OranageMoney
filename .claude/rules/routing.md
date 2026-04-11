# Routing — go_router

---

## Core Rules

- **Package:** `go_router` only. No `Navigator.push` for named routes.
  `Navigator` is reserved for transient overlays (dialogs, bottom sheets) that
  do not need deep linking or auth guarding.
- **Location:** Router lives in `core/router/app_router.dart`. Routing logic
  is never defined in `main.dart` or inside feature folders.
- **Route Constants:** All route paths are constants in
  `core/router/app_routes.dart`. Never hardcode path strings inline.
- **Shell Routes:** Use `ShellRoute` for persistent navigation UI (bottom nav,
  drawer). Never wrap each screen individually.
- **Path Parameters:** Never use `!` on path parameters. Use a null-safe
  fallback or redirect to an error route.
- **Error Route:** Always define `errorBuilder` for unknown routes.
- **Provider Access:** Read auth state through the Riverpod `authStateProvider`.
  Never read global singletons or `FirebaseAuth.instance` inside the router.

---

## Route Constants (`core/router/app_routes.dart`)

```dart
abstract final class AppRoutes {
  // Root
  static const String splash  = '/';
  static const String home    = '/home';
  static const String login   = '/login';
  static const String register = '/register';

  // Nested
  static const String profile     = '/profile/:userId';
  static const String postDetail  = '/posts/:postId';
  static const String settings    = '/settings';

  // Path builders — always use these for navigation, never interpolate inline
  static String profilePath(String userId) => '/profile/$userId';
  static String postDetailPath(String postId) => '/posts/$postId';
}
```

---

## Auth State Provider (`core/providers/auth_state_provider.dart`)

App-lifetime stream — no `autoDispose`. This is the single source of truth
for authentication state consumed by both the router and any UI provider.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../error/failures.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/domain/entities/user_entity.dart';

/// App-lifetime auth stream. No autoDispose — router must never lose this.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(watchAuthStateUseCaseProvider)().map(
    (result) => result.fold(
      (failure) => throw failure,
      (user) => user,
    ),
  );
});
```

---

## Router Definition (`core/router/app_router.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_state_provider.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/app_shell.dart';
import '../widgets/not_found_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateProvider.stream);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authValue = ref.read(authStateProvider);

      // Still loading — no redirect yet
      if (authValue.isLoading || authValue.hasError) return null;

      final isAuthenticated = authValue.valueOrNull != null;
      final location = state.matchedLocation;

      final isOnAuthRoute = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.splash;

      if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;
      if (isAuthenticated && isOnAuthRoute) return AppRoutes.home;
      return null;
    },
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) {
              final userId = state.pathParameters['userId'] ?? '';
              if (userId.isEmpty) return const NotFoundScreen();
              return ProfileScreen(userId: userId);
            },
          ),
          GoRoute(
            path: AppRoutes.postDetail,
            builder: (context, state) {
              final postId = state.pathParameters['postId'] ?? '';
              if (postId.isEmpty) return const NotFoundScreen();
              return PostDetailScreen(postId: postId);
            },
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
```

---

## App Entry Point (`core/widgets/app.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../theme/providers/theme_notifier.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
```

---

## Navigation Patterns

```dart
// Declarative navigation — preferred for all primary routes
context.go(AppRoutes.home);
context.go(AppRoutes.profilePath(user.id));

// Push onto stack — for secondary flows where back is meaningful
context.push(AppRoutes.postDetailPath(post.id));

// Replace current route (e.g. after login, remove login from stack)
context.replace(AppRoutes.home);

// Pop with result
context.pop(result);

// Named extra data (avoid for deep-linkable routes — use path/query params)
context.push(AppRoutes.modal, extra: {'data': payload});

// Dialogs and bottom sheets — Navigator directly, not go_router
showModalBottomSheet(context: context, builder: (_) => const MySheet());
showDialog(context: context, builder: (_) => const MyDialog());
```

---

## Deep Links & Query Parameters

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    return SearchScreen(query: query);
  },
),
```

```dart
// Navigate with query params
context.go('/search?q=flutter');

// Navigate with extra (not deep-linkable — use sparingly)
context.push('/preview', extra: previewData);
```

---

## ShellRoute — Persistent Bottom Navigation (`core/widgets/app_shell.dart`)

```dart
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.explore,
    AppRoutes.settings,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _tabs.indexWhere(
      (path) => location.startsWith(path),
    );

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (index) => context.go(_tabs[index]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
```

---

## Anti-Patterns

```dart
// ❌ Hardcoded path strings
context.go('/home/profile/123');

// ✅ Always use route builders
context.go(AppRoutes.profilePath('123'));

// ❌ Navigator.pushNamed for named routes
Navigator.pushNamed(context, '/profile');

// ✅ go_router always
context.go(AppRoutes.profile);

// ❌ ! on path parameters
final id = state.pathParameters['userId']!;

// ✅ Null-safe fallback
final id = state.pathParameters['userId'] ?? '';
if (id.isEmpty) return const NotFoundScreen();

// ❌ Routing logic in main.dart or feature folders
// main.dart
GoRouter(routes: [ GoRoute(path: '/login', ...) ])

// ✅ Router defined in core/router/app_router.dart only
```

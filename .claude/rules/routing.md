# Routing

- **Package:** Use `go_router` for all navigation.
- **Location:** The router lives in `core/router/app_router.dart`. Never
  define routing logic in `main.dart` or inside feature folders.
- **Route Constants:** All route paths are defined as constants in
  `core/router/app_routes.dart`. Never hardcode path strings inline.
- **Auth Redirects:** Use `go_router`'s `redirect` with `refreshListenable`
  wired to a `GoRouterRefreshStream` so auth guards re-evaluate on state
  changes — not only on navigation events.
- **Provider Access in Router:** Read app-level auth state through Riverpod
  providers passed into router construction. Do not depend on global singletons.
- **Bottom Navigation:** Use `ShellRoute` for persistent UI across routes.
  Never wrap each screen individually.
- **Dialogs / Bottom Sheets:** Use `Navigator` directly only for transient
  overlays that do not need deep linking or auth guarding.
- **Error Route:** Always define an `errorBuilder` for unknown routes.
- **Path Parameters:** Never use `!` on path parameters. Use a null-safe
  fallback or redirect to an error route.

## Route Constants (`core/router/app_routes.dart`)

```dart
abstract final class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile/:id';

  static String profilePath(String id) => '/profile/$id';
}
```

## Router Refresh Stream (`core/router/go_router_refresh_stream.dart`)

```dart
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

## Router Definition (`core/router/app_router.dart`)

```dart
GoRouter buildAppRouter({
  required Stream<AsyncValue<User?>> authStream,
  required AsyncValue<User?> initialAuthState,
}) {
  var currentAuthState = initialAuthState;

  authStream.listen((next) {
    currentAuthState = next;
  });

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) {
      final isAuthenticated =
          currentAuthState is AsyncData<User?> &&
          currentAuthState.valueOrNull != null;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isOnLogin) return AppRoutes.login;
      if (isAuthenticated && isOnLogin) return AppRoutes.home;
      return null;
    },
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
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
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return ProfileScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );
}
```

## Navigating to Routes

```dart
context.go(AppRoutes.home);
context.go(AppRoutes.profilePath(user.id));
context.push(AppRoutes.profilePath(user.id));
```

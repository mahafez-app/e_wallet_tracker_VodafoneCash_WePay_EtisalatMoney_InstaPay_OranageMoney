abstract final class AppRoutes {
  // Root
  static const String splash = '/';
  static const String home = '/home';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String confirmName = '/confirm-name';

  // Settings
  static const String settings = '/settings';

  // Path builders — always use these for navigation, never interpolate inline
  static String profilePath(String userId) => '/profile/$userId';
}

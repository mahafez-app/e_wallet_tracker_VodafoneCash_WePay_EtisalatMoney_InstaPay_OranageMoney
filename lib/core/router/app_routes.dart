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

  // Wallets
  static const String addWallet = '/add-wallet';
  static const String smsPermissions = '/sms-permissions';
  static const String walletDetails = '/wallet/:walletId';
  static const String transactions = '/transactions';

  // Path builders — always use these for navigation, never interpolate inline
  static String profilePath(String userId) => '/profile/$userId';
  static String walletDetailsPath(String walletId) => '/wallet/$walletId';
  static String transactionsPath({String? walletId}) =>
      walletId == null ? '/transactions' : '/transactions?walletId=$walletId';
}

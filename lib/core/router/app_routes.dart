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
  static const String invitations = '/invitations';

  // Wallets
  static const String addWallet = '/add-wallet';
  static const String addWorkspace = '/add-workspace';
  static const String workspaceDetails = '/workspace/:workspaceId';
  static const String workspaceSettings = '/workspace/:workspaceId/settings';
  static const String workspaceWalletSelection =
      '/workspace/:workspaceId/wallets';
  static const String smsPermissions = '/sms-permissions';
  static const String walletDetails = '/wallet/:walletId';
  static const String transactions = '/transactions';
  static const String workspaceReports = '/workspace/:workspaceId/reports';

  // Path builders — always use these for navigation, never interpolate inline
  static String profilePath(String userId) => '/profile/$userId';
  static String workspaceDetailsPath(String workspaceId) =>
      '/workspace/$workspaceId';
  static String workspaceSettingsPath(String workspaceId) =>
      '/workspace/$workspaceId/settings';
  static String workspaceWalletSelectionPath(
    String workspaceId, {
    bool fromCreation = false,
  }) => fromCreation
      ? '/workspace/$workspaceId/wallets?flow=create'
      : '/workspace/$workspaceId/wallets';
  static String walletDetailsPath(String walletId) => '/wallet/$walletId';
  static String transactionsPath() => '/transactions';
  static String workspaceReportsPath(String workspaceId) =>
      '/workspace/$workspaceId/reports';
}

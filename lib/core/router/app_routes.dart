import 'package:workspace_product/workspace_product.dart';

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
  static const String invitations = WorkspaceRoutes.invitations;

  // Wallets
  static const String addWallet = '/add-wallet';
  static const String addWorkspace = '/add-workspace';
  static const String workspaceDetails = WorkspaceRoutes.details;
  static const String workspaceSettings = WorkspaceRoutes.settings;
  static const String workspaceWalletSelection =
      WorkspaceRoutes.walletSelection;
  static const String smsPermissions = '/sms-permissions';
  static const String walletDetails = '/wallet/:walletId';
  static const String transactions = '/transactions';
  static const String workspaceReports = WorkspaceRoutes.reports;
  static const String walletReports = '/wallet/:walletId/reports';

  // Path builders — always use these for navigation, never interpolate inline
  static String profilePath(String userId) => '/profile/$userId';
  static String workspaceDetailsPath(String workspaceId) =>
      WorkspaceRoutes.workspaceDetailsPath(workspaceId);
  static String workspaceWalletSelectionPath(
    String workspaceId, {
    bool fromCreation = false,
  }) => WorkspaceRoutes.workspaceWalletSelectionPath(
    workspaceId,
    fromCreation: fromCreation,
  );
  static String walletDetailsPath(String walletId) => '/wallet/$walletId';
  static String transactionsPath() => '/transactions';
  static String workspaceReportsPath(String workspaceId) =>
      WorkspaceRoutes.workspaceReportsPath(workspaceId);
  static String workspaceSettingsPath(String workspaceId) =>
      WorkspaceRoutes.workspaceSettingsPath(workspaceId);
  static String walletReportsPath(String walletId) =>
      '/wallet/$walletId/reports';
}

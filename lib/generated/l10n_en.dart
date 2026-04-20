// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get errorNetwork => 'No internet connection. Please check your network.';

  @override
  String get errorAuthUserNotFound => 'User not found. Please check your credentials.';

  @override
  String get errorAuthWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get errorAuthEmailInUse => 'This email is already registered.';

  @override
  String get errorAuthTooManyRequests => 'Too many attempts. Please try again later.';

  @override
  String get errorAuthUserDisabled => 'This account has been disabled.';

  @override
  String get errorAuthWeakPassword => 'Password is too weak. Please choose a stronger password.';

  @override
  String get errorAuthInvalidEmail => 'Invalid email address.';

  @override
  String get errorUnauthorized => 'Unauthorized access. Please log in again.';

  @override
  String get errorAuthGeneric => 'Authentication failed. Please try again.';

  @override
  String get errorForbidden => 'Access forbidden.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorConflict => 'Resource conflict. Please try again.';

  @override
  String get errorUnprocessable => 'Unable to process your request.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorServerGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorPermissionDenied => 'Permission denied.';

  @override
  String get errorCache => 'Local storage error. Please try again.';

  @override
  String get errorStorage => 'File storage error.';

  @override
  String get errorValidation => 'Validation failed.';

  @override
  String errorValidationWithCode(String code) {
    return 'Validation failed: $code';
  }

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get startupFallbackTitle => 'Just a moment';

  @override
  String get startupFallbackMessage => 'Please try opening Mahafez again.';

  @override
  String get startupFallbackRetryAction => 'Try again';

  @override
  String get notFoundStatusCode => '404';

  @override
  String get notFoundPageTitle => 'Page Not Found';

  @override
  String get appName => 'Mahafez';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Name';

  @override
  String get yourName => 'Your Name';

  @override
  String get confirm => 'Confirm';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithEmail => 'Sign in with Email';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get displayNameHint => 'Enter your name';

  @override
  String get confirmName => 'Confirm Name';

  @override
  String get confirmNameMessage => 'Please confirm your name to continue';

  @override
  String get or => 'OR';

  @override
  String get appTagline => 'Manage your business wallets with ease';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signUpNow => 'Sign Up Now';

  @override
  String get emailPlaceholder => 'example@email.com';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNamePlaceholder => 'e.g. John Doe';

  @override
  String get signUpSubtitle => 'Create an account and start tracking your business';

  @override
  String get whatIsYourName => 'What is your name?';

  @override
  String get nameWillBeDisplayed => 'This name appears when payment status is updated, making transactions easier to track.';

  @override
  String get welcome => 'Welcome';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get currency => 'EGP';

  @override
  String get totalOut => 'Total Out';

  @override
  String get totalIn => 'Total In';

  @override
  String get yourWallets => 'Your Wallets';

  @override
  String get viewAll => 'View All';

  @override
  String get workspaces => 'Workspaces';

  @override
  String get addWorkspace => 'Add Workspace';

  @override
  String get addWallet => 'Add Wallet';

  @override
  String get walletStatusActive => 'Active';

  @override
  String activeWalletsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active wallets',
      few: '$count active wallets',
      one: '1 active wallet',
      zero: 'No active wallets',
    );
    return '$_temp0';
  }

  @override
  String activeWalletsHint(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total balance across your $count wallets',
      one: 'Total balance across your wallet',
      zero: 'You haven\'t added any wallets yet',
    );
    return '$_temp0';
  }

  @override
  String get lastActivity => 'Last Activity';

  @override
  String get justNow => 'Just Now';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes mins ago';
  }

  @override
  String get egp => 'EGP';

  @override
  String get addWalletTitle => 'Add Wallet';

  @override
  String get addWalletDescription => 'This wallet must be on this device. The app reads new SMS messages from this phone only.';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get chooseProvider => 'Choose a provider';

  @override
  String get allowAndContinue => 'Allow and Continue';

  @override
  String get notNow => 'Not Now';

  @override
  String get providerOrange => 'Orange Cash';

  @override
  String get providerVodafone => 'Vodafone Cash';

  @override
  String get providerInstapay => 'InstaPay';

  @override
  String get providerEtisalat => 'Etisalat Cash';

  @override
  String get providerWePay => 'WE Pay';

  @override
  String get providerUnknown => 'Wallet';

  @override
  String get smsPermissionTitle => 'Allow Message and Phone Access';

  @override
  String get smsPermissionDescription => 'The app needs access to messages and phone information to find wallet numbers on this device and sync transactions automatically.';

  @override
  String get smsPermissionAutoUpdateTitle => 'Automatic Update';

  @override
  String get smsPermissionAutoUpdateDesc => 'Track payments and expenses as soon as the SMS arrives.';

  @override
  String get smsPermissionPrivacyTitle => 'Your privacy matters';

  @override
  String get smsPermissionPrivacyDesc => 'We only read financial messages and device phone numbers required for wallet setup; your data is encrypted and never shared.';

  @override
  String get smsPermissionXiaomiTitle => 'Xiaomi/Redmi Detected';

  @override
  String get smsPermissionXiaomiDescription => 'To receive transactions when the app is closed, you must enable \'Autostart\' and set Battery Saver to \'No Restrictions\' in app settings.';

  @override
  String get smsPermissionXiaomiAction => 'Fix in Settings';

  @override
  String get smsPermissionBatteryOptimizationTitle => 'Battery Optimization Active';

  @override
  String get smsPermissionBatteryOptimizationDescription => 'Android may kill the app in the background to save power. To ensure accuracy, please allow the app to run without battery restrictions.';

  @override
  String get smsPermissionBatteryOptimizationAction => 'Allow Background Activity';

  @override
  String get addWalletAction => 'Add Wallet';

  @override
  String get createWorkspaceTitle => 'Create Workspace';

  @override
  String get createWorkspaceDescription => 'Workspaces help you organize your business wallets and share access with trusted members in one place.';

  @override
  String get workspaceNameLabel => 'Workspace Name';

  @override
  String get workspaceNameHint => 'e.g. Mobile Store';

  @override
  String get createWorkspacePreviewLabel => 'Workspace Preview';

  @override
  String get createWorkspacePreviewFallback => 'New Workspace';

  @override
  String get createWorkspacePreviewDescription => 'After you create the workspace, you can add wallets and invite members.';

  @override
  String get workspaceOwner => 'Owner';

  @override
  String get workspaceOwnerBadge => 'Owner';

  @override
  String workspaceMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'No members',
    );
    return '$_temp0';
  }

  @override
  String workspaceWalletsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wallets',
      one: '1 wallet',
      zero: 'No wallets',
    );
    return '$_temp0';
  }

  @override
  String get createWorkspaceAction => 'Create Workspace';

  @override
  String get createWorkspaceEmptyTitle => 'Create your first workspace';

  @override
  String get createWorkspaceEmptyDescription => 'Bring your wallets together, track activity, and work with your team from one place.';

  @override
  String get createWalletEmptyTitle => 'Add your first wallet';

  @override
  String get createWalletEmptyDescription => 'Connect a wallet on this device to start tracking balances and transactions automatically.';

  @override
  String get workspaceWallets => 'Wallets';

  @override
  String get workspaceMembers => 'Members';

  @override
  String get workspaceInviteMemberAction => 'Invite member';

  @override
  String get workspaceSettingsTitle => 'Workspace Settings';

  @override
  String get workspaceSettingsInfoSection => 'Workspace Info';

  @override
  String get workspaceSettingsInviteByEmailAction => 'Invite member';

  @override
  String get workspaceSettingsPendingInvitationsSection => 'Pending Invitations';

  @override
  String get workspaceSettingsPendingInvitationsEmpty => 'There are no pending invitations for this workspace right now.';

  @override
  String get workspaceSettingsAccessSection => 'Your access';

  @override
  String get workspaceSettingsMemberDescription => 'Review the shared members and linked wallets, remove your own wallets when needed, or leave the workspace.';

  @override
  String get workspaceSettingsManageAccessAction => 'Manage access';

  @override
  String get workspaceSettingsWalletsOwnerDescription => 'Review every linked wallet in this workspace and remove any wallet that should no longer be shared.';

  @override
  String get workspaceSettingsWalletsMemberDescription => 'You can review every linked wallet here, but you can remove only the wallets you added.';

  @override
  String get workspaceSettingsWalletsEmptyOwner => 'There are no linked wallets in this workspace yet.';

  @override
  String get workspaceSettingsWalletsEmptyMember => 'There are no linked wallets in this workspace yet.';

  @override
  String workspaceSettingsWalletOwner(Object ownerName) {
    return 'Owner: $ownerName';
  }

  @override
  String get workspaceUnknownMember => 'Unknown member';

  @override
  String get workspaceSettingsWalletReadOnlyTooltip => 'Only the wallet owner can remove this wallet';

  @override
  String get workspaceSettingsDangerZone => 'Sensitive actions';

  @override
  String get workspaceSettingsEditNameTitle => 'Edit workspace name';

  @override
  String get workspaceSettingsEditNameDescription => 'Update the visible name used across the workspace and shared views.';

  @override
  String get workspaceSettingsEditNameAction => 'Save changes';

  @override
  String get workspaceSettingsRemoveMemberAction => 'Remove';

  @override
  String get workspaceSettingsRemoveWalletAction => 'Unlink wallet';

  @override
  String get workspaceSettingsCancelInvitationAction => 'Cancel';

  @override
  String get workspaceSettingsLeaveWorkspaceAction => 'Leave workspace';

  @override
  String get workspaceSettingsLeaveWorkspaceDescription => 'Your membership and your linked wallets will be removed from this workspace.';

  @override
  String get workspaceSettingsDeleteWorkspaceAction => 'Delete workspace';

  @override
  String get workspaceSettingsDeleteWorkspaceDescription => 'All linked data and access records will be removed permanently.';

  @override
  String get workspaceSettingsNameUpdatedSuccess => 'Workspace name updated successfully.';

  @override
  String get workspaceSettingsMemberRemovedSuccess => 'Member removed successfully.';

  @override
  String get workspaceSettingsWalletRemovedSuccess => 'Wallet unlinked from the workspace successfully.';

  @override
  String get workspaceSettingsInvitationCancelledSuccess => 'Invitation cancelled successfully.';

  @override
  String get workspaceSettingsRemoveMemberConfirmTitle => 'Remove member?';

  @override
  String workspaceSettingsRemoveMemberConfirmMessage(Object memberName) {
    return 'You will remove $memberName from this workspace, and any wallets they linked here will be removed too. They can be invited again later.';
  }

  @override
  String get workspaceSettingsRemoveWalletConfirmTitle => 'Unlink wallet?';

  @override
  String workspaceSettingsRemoveWalletConfirmMessage(Object providerName, Object phoneNumber) {
    return 'The $providerName wallet linked to $phoneNumber will be unlinked from this workspace. The wallet itself and its transactions will NOT be deleted.';
  }

  @override
  String get workspaceSettingsCancelInvitationConfirmTitle => 'Cancel invitation?';

  @override
  String workspaceSettingsCancelInvitationConfirmMessage(Object email) {
    return 'The invitation sent to $email will be removed immediately.';
  }

  @override
  String get workspaceSettingsLeaveWorkspaceConfirmTitle => 'Leave workspace?';

  @override
  String get workspaceSettingsLeaveWorkspaceConfirmMessage => 'You will lose access to this workspace, and the wallets you linked here will be removed from it.';

  @override
  String get workspaceSettingsDeleteWorkspaceConfirmTitle => 'Delete workspace?';

  @override
  String get workspaceSettingsDeleteWorkspaceConfirmMessage => 'This will permanently delete the workspace, its member access, wallet links, and pending invitations.';

  @override
  String get workspaceUnavailableTitle => 'Workspace is no longer available';

  @override
  String get workspaceUnavailableMessage => 'It looks like this workspace was deleted or your access was removed. We’ll take you back home.';

  @override
  String get workspaceUnavailableAction => 'Back to home';

  @override
  String get userSettingsTitle => 'Settings';

  @override
  String get userSettingsAppSection => 'App';

  @override
  String get userSettingsBackgroundSection => 'Background Reliability';

  @override
  String get userSettingsAccountSection => 'Account';

  @override
  String get userSettingsAboutSection => 'About';

  @override
  String get userSettingsNoEmailLabel => 'No email linked to this account';

  @override
  String get userSettingsEditNameAction => 'Edit name';

  @override
  String get userSettingsEditNameTitle => 'Edit name';

  @override
  String get userSettingsEditNameDescription => 'Update the name shown across the app and activity history.';

  @override
  String get userSettingsEditNameSaveAction => 'Save changes';

  @override
  String get userSettingsNameUpdatedSuccess => 'Name updated successfully.';

  @override
  String get userSettingsThemeTitle => 'Theme';

  @override
  String get userSettingsThemeSystemOption => 'System';

  @override
  String get userSettingsThemeLightOption => 'Light';

  @override
  String get userSettingsThemeDarkOption => 'Dark';

  @override
  String get userSettingsLanguageTitle => 'Language';

  @override
  String get userSettingsLanguageSystemOption => 'System default';

  @override
  String get userSettingsLanguageEnglishOption => 'English';

  @override
  String get userSettingsLanguageArabicOption => 'Arabic';

  @override
  String get userSettingsFontSizeTitle => 'Font size';

  @override
  String get userSettingsFontSizeDescription => 'Adjust the reading scale used across the entire app.';

  @override
  String get userSettingsFontSizeSaveAction => 'Apply';

  @override
  String get userSettingsFontSizePreviewTitle => 'Preview';

  @override
  String get userSettingsFontSizePreviewBody => 'Use the slider to make text smaller or larger across Mahafez.';

  @override
  String userSettingsFontSizeCurrentValue(String value) {
    return 'Current app size: $value';
  }

  @override
  String get userSettingsFontSizeSmallLabel => 'Smaller';

  @override
  String get userSettingsFontSizeLargeLabel => 'Larger';

  @override
  String get userSettingsSmsPermissionTitle => 'SMS read permission';

  @override
  String get userSettingsSmsPermissionCheckingLabel => 'Checking permission status...';

  @override
  String get userSettingsSmsPermissionEnabledLabel => 'Enabled';

  @override
  String get userSettingsSmsPermissionDisabledLabel => 'Disabled, and the app cannot work without it.';

  @override
  String get userSettingsOpenSystemSettingsAction => 'Open settings';

  @override
  String get userSettingsSignOutAction => 'Sign out';

  @override
  String get userSettingsSignOutConfirmTitle => 'Sign out?';

  @override
  String get userSettingsSignOutConfirmMessage => 'This will end your current session on this device. You can sign in again at any time.';

  @override
  String get userSettingsDeleteAccountAction => 'Delete account';

  @override
  String get userSettingsDeleteAccountConfirmTitle => 'Delete account?';

  @override
  String get userSettingsDeleteAccountConfirmMessage => 'This is a sensitive action and, once fully implemented, will permanently remove data linked to your account.';

  @override
  String get userSettingsDeleteAccountUnavailableTitle => 'Delete account is not available yet';

  @override
  String get userSettingsDeleteAccountUnavailableMessage => 'A partial delete would leave linked wallets, workspaces, and invitations behind. This action will be enabled after we add a safe full-data cleanup flow.';

  @override
  String get userSettingsAppVersionLabel => 'App version';

  @override
  String get userSettingsWalletsSection => 'Your Wallets';

  @override
  String get userSettingsWalletsDescription => 'Manage the wallets you\'ve added to Mahafez. Deleting a wallet will remove it and all its transactions permanently from all workspaces.';

  @override
  String get userSettingsDeleteWalletAction => 'Delete Wallet';

  @override
  String get userSettingsDeleteWalletConfirmTitle => 'Delete Wallet?';

  @override
  String userSettingsDeleteWalletConfirmMessage(Object phoneNumber, Object providerName) {
    return 'Are you sure you want to delete this $providerName wallet ($phoneNumber)? This will permanently remove its transactions and notes, and unlink it from all workspaces. This action cannot be undone.';
  }

  @override
  String get userSettingsWalletDeletedSuccess => 'Wallet deleted successfully.';

  @override
  String get commonDeleteAction => 'Delete';

  @override
  String get commonCancelAction => 'Cancel';

  @override
  String get workspaceAddWalletsTitle => 'Add Wallets';

  @override
  String get workspaceAddWalletsAction => 'Add Wallets';

  @override
  String get workspaceAddWalletsCreateDescription => 'Choose which of your wallets should appear in this workspace now. You can add more later.';

  @override
  String get workspaceAddWalletsManageDescription => 'Share your own wallets with this workspace. Linked wallets become visible to all workspace members.';

  @override
  String get workspaceAddSelectedWalletsAction => 'Add Selected Wallets';

  @override
  String get workspaceContinueToDetailsAction => 'Continue to Workspace';

  @override
  String get workspaceSkipWalletsAction => 'Skip for now';

  @override
  String get workspaceWalletAvailable => 'Available';

  @override
  String get workspaceWalletSelected => 'Selected';

  @override
  String get workspaceWalletAlreadyAdded => 'Already Added';

  @override
  String get workspaceNoOwnedWalletsTitle => 'You do not have any wallets yet';

  @override
  String get workspaceNoOwnedWalletsDescription => 'Add a wallet first, then you can share it with this workspace.';

  @override
  String get workspaceAllOwnedWalletsLinkedTitle => 'All of your wallets are already linked';

  @override
  String get workspaceAllOwnedWalletsLinkedDescription => 'You can continue to the workspace or add a new wallet later.';

  @override
  String workspaceWalletSelectionSummary(int ownedCount, int linkedCount) {
    return 'You own $ownedCount wallets, and $linkedCount are already linked to this workspace.';
  }

  @override
  String get workspaceWalletsEmptyTitle => 'No wallets linked yet';

  @override
  String get workspaceWalletsEmptyDescription => 'This workspace will show shared wallets here once they are linked.';

  @override
  String get workspaceMembersEmpty => 'No members have joined this workspace yet.';

  @override
  String get invitationsTitle => 'Invitations';

  @override
  String get invitationsEmptyTitle => 'No pending invitations';

  @override
  String get invitationsEmptyDescription => 'You do not have any pending workspace invitations right now.';

  @override
  String get invitationsListDescription => 'Review your workspace invitations and choose what to do.';

  @override
  String invitationsPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invitations waiting',
      one: '1 invitation waiting',
      zero: 'No invitations waiting',
    );
    return '$_temp0';
  }

  @override
  String get invitationsPendingStatus => 'Pending';

  @override
  String get invitationsDeletedWorkspaceFallback => 'Deleted workspace';

  @override
  String get invitationsUnknownInviterFallback => 'Unknown sender';

  @override
  String get invitationsAcceptAction => 'Accept';

  @override
  String get invitationsDeclineAction => 'Decline';

  @override
  String get invitationsRefreshAction => 'Refresh list';

  @override
  String get invitationsHowItWorksTitle => 'How invitations work';

  @override
  String get invitationsHowItWorksDescription => 'Workspace invitations can only be sent to an existing Mahafez account using the email linked to that account.';

  @override
  String get invitationsRecentResponsesTitle => 'Recent responses';

  @override
  String invitationSentBy(Object name) {
    return 'Invited by $name';
  }

  @override
  String invitationAcceptSuccess(Object workspaceName) {
    return 'You joined $workspaceName successfully.';
  }

  @override
  String get invitationAcceptDetails => 'You can start working in this workspace now.';

  @override
  String invitationDeclineSuccess(Object workspaceName) {
    return 'You declined the invitation to $workspaceName.';
  }

  @override
  String get invitationDeclineConfirmTitle => 'Decline invitation?';

  @override
  String invitationDeclineConfirmMessage(Object workspaceName) {
    return 'You will remove the invitation to join $workspaceName. You can ask the workspace owner to send a new invitation later.';
  }

  @override
  String get invitationSentSuccess => 'Invitation sent successfully.';

  @override
  String get inviteMemberTitle => 'Invite a member';

  @override
  String get inviteMemberDescription => 'Send a workspace invitation to an existing Mahafez account by email. The invited user will see it in their invitations inbox.';

  @override
  String get inviteMemberEmailLabel => 'Member email';

  @override
  String get inviteMemberEmailHint => 'name@example.com';

  @override
  String get inviteMemberSendAction => 'Send invitation';

  @override
  String get errorWalletPhoneNumberRequired => 'Please enter a phone number';

  @override
  String get errorWalletPhoneNumberInvalid => 'Please enter a valid Egyptian mobile number.';

  @override
  String get errorWalletProviderRequired => 'Please select at least one provider';

  @override
  String get errorWalletProviderMismatch => 'This phone number only supports its matching mobile wallet provider and InstaPay.';

  @override
  String get errorWalletAlreadyExists => 'This wallet is already added.';

  @override
  String get errorWalletAllExists => 'All selected wallets are already added for this phone number.';

  @override
  String get errorManualTransactionMessageRequired => 'Paste the SMS text first.';

  @override
  String get errorManualTransactionUnrecognized => 'This text does not match the selected wallet\'s SMS format.';

  @override
  String get errorManualTransactionWalletMismatch => 'This SMS points to a different wallet than the one currently open.';

  @override
  String get errorWorkspaceNameRequired => 'Please enter a workspace name';

  @override
  String get errorWorkspaceWalletSelectionRequired => 'Please select at least one wallet';

  @override
  String get errorWorkspaceOwnerRemovalNotAllowed => 'The workspace owner cannot be removed.';

  @override
  String get errorWorkspaceMemberNotFound => 'This member is no longer available in the workspace.';

  @override
  String get errorInvitationSelfNotAllowed => 'You cannot invite yourself to this workspace.';

  @override
  String get errorInvitationAlreadyPending => 'A pending invitation already exists for this email.';

  @override
  String get errorInvitationUserNotFound => 'This email is not linked to any Mahafez account.';

  @override
  String get errorInvitationUserAlreadyMember => 'This user is already a member of the workspace.';

  @override
  String get errorInvitationNotPending => 'This invitation is no longer pending.';

  @override
  String get transactionTypeReceive => 'Receive';

  @override
  String get transactionTypeSend => 'Send';

  @override
  String get reportSummaryReceivedTransactionsTitle => 'Received transactions';

  @override
  String get reportSummaryReceivedTransactionsDescription => 'Number of transactions received during this period.';

  @override
  String get reportSummarySentTransactionsTitle => 'Sent transactions';

  @override
  String get reportSummarySentTransactionsDescription => 'Number of transactions sent during this period.';

  @override
  String get transactionStatusPaid => 'Paid';

  @override
  String get transactionStatusUnpaid => 'Unpaid';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get transactions_emptyTitle => 'No transactions yet';

  @override
  String get transactions_emptyWalletDescription => 'This wallet has no transactions yet. New messages will appear here automatically.';

  @override
  String get transactions_emptyWorkspaceDescription => 'This workspace has no transactions yet. Activity from any linked wallet will appear here automatically.';

  @override
  String get workspaceTransactionsCtaDescription => 'Open the full transaction history for this workspace to see all transactions from linked wallets in one place.';

  @override
  String get workspaceTransactionsCtaDescriptionWithActivity => 'Open the full transaction history for this workspace to see all transactions from linked wallets in one place.';

  @override
  String get transactions_emptyHintTitle => 'Automatic tracking';

  @override
  String get transactions_emptyHintDescription => 'When activity is detected on a connected wallet, we sync it here for you automatically.';

  @override
  String get noTransactionsTitle => 'No transactions yet. New messages will appear here automatically.';

  @override
  String get deleteWallet => 'Delete Wallet';

  @override
  String get deleteWalletConfirmTitle => 'Delete Wallet';

  @override
  String get deleteWalletConfirmMessage => 'Are you sure you want to delete this wallet? This action cannot be undone.';

  @override
  String get allTransactions => 'All Transactions';

  @override
  String get viewAllTransactions => 'View All Transactions';

  @override
  String get walletTransactions => 'Wallet Transactions';

  @override
  String get walletDetails => 'Wallet Details';

  @override
  String get transactionsHistory => 'Transaction History';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String transactionMessageReceive(Object amount) {
    return 'Received $amount EGP';
  }

  @override
  String transactionMessageSend(Object amount) {
    return 'Sent $amount EGP';
  }

  @override
  String get walletLabel => 'Your wallet';

  @override
  String get fromLabel => 'From';

  @override
  String get toLabel => 'To';

  @override
  String get viaLabel => 'Via';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get transactions_filter_all => 'All';

  @override
  String get transactions_filter_allWallets => 'All Wallets';

  @override
  String get transactions_filter_allMembers => 'All Members';

  @override
  String get transactions_paymentStatusAll => 'All Statuses';

  @override
  String get transactions_searchHint => 'Search by last 2+ digits';

  @override
  String get transactions_date_today => 'Today';

  @override
  String get transactions_date_yesterday => 'Yesterday';

  @override
  String get transactions_date_week => 'This Week';

  @override
  String get transactions_date_month => 'This Month';

  @override
  String get transactions_date_customRange => 'Custom Range';

  @override
  String get transactions_loadMore => 'Load More';

  @override
  String transactions_viewingCountOfTotal(int count, int total) {
    return 'Viewing $count of $total transactions';
  }

  @override
  String get transaction_shareReceipt => 'Share Receipt';

  @override
  String transaction_receiptHeader(String type) {
    return 'Transaction Receipt — $type';
  }

  @override
  String get transaction_amount => 'Amount';

  @override
  String get transaction_wallet => 'Wallet';

  @override
  String get transaction_receivedFrom => 'Received From';

  @override
  String get transaction_sentTo => 'Sent To';

  @override
  String get transaction_date => 'Date';

  @override
  String get transaction_dateTime => 'Date & Time';

  @override
  String get transaction_referenceNumber => 'Reference Number';

  @override
  String get transaction_history => 'Change History';

  @override
  String transaction_markedAs(String status) {
    return 'Marked as $status';
  }

  @override
  String transaction_by(String name) {
    return 'By $name';
  }

  @override
  String get transaction_notes => 'Notes';

  @override
  String get transaction_addNote => 'Add Note';

  @override
  String get transaction_noteHint => 'Write your note here…';

  @override
  String get transaction_deleteAction => 'Delete';

  @override
  String get transaction_deleteTitle => 'Delete Transaction';

  @override
  String get transaction_deleteMessage => 'Are you sure you want to delete this transaction? This action cannot be undone.';

  @override
  String get transaction_deletedSuccess => 'Transaction deleted';

  @override
  String get transaction_deleteNoteTitle => 'Delete Note';

  @override
  String get transaction_deleteNoteMessage => 'Are you sure you want to delete this note? This action cannot be undone.';

  @override
  String get transaction_noteDeleted => 'Note deleted';

  @override
  String get transaction_undo => 'Undo';

  @override
  String get transaction_edited => 'Edited';

  @override
  String get transaction_cancel => 'Cancel';

  @override
  String get transaction_save => 'Save';

  @override
  String get transaction_smsText => 'SMS Text';

  @override
  String get transaction_typeReceiveLabel => 'Receive Transaction';

  @override
  String get transaction_typeSendLabel => 'Send Transaction';

  @override
  String get transaction_errorGeneric => 'An error occurred';

  @override
  String get transactions_emptyWithFilter => 'No transactions match the selected filter';

  @override
  String get transactions_emptyWithFilterTitle => 'No matching transactions';

  @override
  String get transactions_emptyWithFilterDescription => 'Try clearing one or more filters to see more activity.';

  @override
  String get transactions_clearFilters => 'Clear Filters';

  @override
  String transactions_title_wallet(String name) {
    return 'Transactions: $name';
  }

  @override
  String transactions_title_workspace(String name) {
    return 'Workspace: $name';
  }

  @override
  String get workspaceTransactionsTodayCollected => 'Collected Today';

  @override
  String get workspaceTransactionsTodaySent => 'Sent Today';

  @override
  String get workspaceTransactionsUnpaidCount => 'Unpaid Count';

  @override
  String get workspaceTransactionsLatestWallets => 'Latest Active Wallets';

  @override
  String get workspaceTransactionsLatestWalletsEmpty => 'No wallet activity yet.';

  @override
  String get errorTransactionNotFound => 'This transaction is no longer available.';

  @override
  String get errorTransactionAlreadyExists => 'This transaction has already been tracked.';

  @override
  String get fullNameValidationEmpty => 'Please enter your name';

  @override
  String get transactions_filterTitle => 'Filters';

  @override
  String get transactions_filterApply => 'Apply Filters';

  @override
  String get transactions_filterReset => 'Reset';

  @override
  String transactions_filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'filters',
      one: 'filter',
    );
    return '$count active $_temp0';
  }

  @override
  String get transactions_filterType => 'Type';

  @override
  String get transactions_filterPaidStatus => 'Status';

  @override
  String get transactions_filterDate => 'Date';

  @override
  String get transactions_filterMember => 'Member';

  @override
  String get transactions_filterWallet => 'Wallet';

  @override
  String get reports_total_transactions => 'Transactions Count';

  @override
  String get reports_all_wallets => 'All Wallets';

  @override
  String get reports_period_today => 'Today';

  @override
  String get reports_period_yesterday => 'Yesterday';

  @override
  String get reports_period_lastWeek => 'Last Week';

  @override
  String get reports_period_lastMonth => 'Last Month';

  @override
  String get reports_period_custom => 'Custom Range';

  @override
  String get reports_stat_average => 'Daily Average';

  @override
  String get reports_balance_label => 'Net Cash Flow';

  @override
  String get reports_performance_label => 'Financial Performance';

  @override
  String get reports_wallet_title => 'Wallet Reports';

  @override
  String get reports_workspace_title => 'Workspace Reports';

  @override
  String wallet_statsFrom(Object date) {
    return 'Stats from $date';
  }

  @override
  String get wallet_resetStats => 'Reset Tracked Metrics';

  @override
  String get wallet_resetStatsDescription => 'Are you sure you want to reset the tracked metrics for this wallet? This will zero out your total incoming and outgoing amounts since the last reset. Your current balance will be preserved.';

  @override
  String get wallet_resetStatsAction => 'Reset Stats';

  @override
  String get walletBalanceEditTitle => 'Update Current Balance';

  @override
  String get walletBalanceEditDescription => 'Use this if a historical SMS was missed or your tracked balance needs to be corrected manually.';

  @override
  String get walletBalanceEditAction => 'Update Balance';

  @override
  String get walletBalanceEditHint => 'Enter the latest balance';

  @override
  String get walletBalanceEditInvalid => 'Enter a valid balance amount.';

  @override
  String get walletBalanceEditSuccess => 'Current balance updated.';

  @override
  String walletBalanceEditSuggested(Object amount) {
    return 'Latest detected balance: $amount';
  }

  @override
  String get walletManualTransactionEntryAction => 'Paste SMS Transaction';

  @override
  String get walletManualTransactionTitle => 'Add Transaction From SMS';

  @override
  String get walletManualTransactionDescription => 'Paste the original transaction SMS here. We will parse it with the same wallet matching and transaction rules used by the automatic SMS flow.';

  @override
  String get walletManualTransactionFieldLabel => 'SMS text';

  @override
  String get walletManualTransactionFieldHint => 'Paste the full transaction message';

  @override
  String get walletManualTransactionPasteAction => 'Paste from clipboard';

  @override
  String get walletManualTransactionAnalyzeAction => 'Process SMS';

  @override
  String get walletManualTransactionSaveAction => 'Save Transaction';

  @override
  String get walletManualTransactionConfirmAction => 'Save to this wallet';

  @override
  String get walletManualTransactionForceAction => 'Save Anyway';

  @override
  String get walletManualTransactionBlockedAction => 'Belongs to another wallet';

  @override
  String get walletManualTransactionSaved => 'Transaction added successfully.';

  @override
  String get walletManualTransactionReviewTitle => 'Review before saving';

  @override
  String get walletManualTransactionReviewDescription => 'The SMS was parsed successfully, but the wallet could not be confirmed with full confidence. Review the details before continuing.';

  @override
  String get walletManualTransactionExplicitMismatchTitle => 'This SMS belongs to another wallet';

  @override
  String get walletManualTransactionExplicitMismatchDescription => 'The message explicitly mentions a wallet phone number that does not match the wallet you opened.';

  @override
  String get walletManualTransactionInferredMismatchTitle => 'Another wallet looks more likely';

  @override
  String get walletManualTransactionInferredMismatchDescription => 'The balance and matching rules suggest a different wallet. Save here only if you are sure this SMS should stay under the current wallet.';

  @override
  String get walletManualTransactionSuggestedWalletLabel => 'Suggested wallet';

  @override
  String walletManualTransactionBalanceChip(Object amount) {
    return 'Balance after SMS: $amount';
  }

  @override
  String walletManualTransactionPhoneChip(Object phoneNumber) {
    return 'Mentioned wallet: $phoneNumber';
  }

  @override
  String get walletSyncTransactionsTitle => 'Sync missed transactions';

  @override
  String get walletSyncTransactionsDescription => 'Check recent SMS messages for transactions that arrived after your latest saved wallet activity.';

  @override
  String get walletSyncTransactionsAction => 'Sync transactions';

  @override
  String get walletSyncTransactionsReviewTitle => 'Review missing transactions';

  @override
  String walletSyncTransactionsFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missing transactions found',
      one: '1 missing transaction found',
      zero: 'No missing transactions found',
    );
    return '$_temp0';
  }

  @override
  String walletSyncTransactionsFromDate(String date) {
    return 'Checking messages after $date';
  }

  @override
  String walletSyncTransactionsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions selected',
      one: '1 transaction selected',
      zero: 'No transactions selected',
    );
    return '$_temp0';
  }

  @override
  String get walletSyncTransactionsSaveAction => 'Add selected';

  @override
  String get walletSyncTransactionsEmptyTitle => 'No missing transactions found';

  @override
  String get walletSyncTransactionsEmptyDescription => 'We did not find any unsaved SMS transactions for this wallet in the recent inbox history.';

  @override
  String walletSyncTransactionsEmptySinceDescription(String date) {
    return 'We did not find any unsaved SMS transactions after $date.';
  }

  @override
  String walletSyncTransactionsSavedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions added successfully.',
      one: '1 transaction added successfully.',
    );
    return '$_temp0';
  }
}

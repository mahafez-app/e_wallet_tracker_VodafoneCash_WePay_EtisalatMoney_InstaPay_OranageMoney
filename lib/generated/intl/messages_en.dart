// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, zero: 'No active wallets', one: '1 active wallet', few: '${count} active wallets', other: '${count} active wallets')}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'You haven\'t added any wallets yet', one: 'Total balance across your wallet', other: 'Total balance across your ${count} wallets')}";

  static String m2(code) => "Validation failed: ${code}";

  static String m3(workspaceName) =>
      "You joined ${workspaceName} successfully.";

  static String m4(workspaceName) =>
      "You will remove the invitation to join ${workspaceName}. You can ask the workspace owner to send a new invitation later.";

  static String m5(workspaceName) =>
      "You declined the invitation to ${workspaceName}.";

  static String m6(name) => "Invited by ${name}";

  static String m7(count) =>
      "${Intl.plural(count, zero: 'No invitations waiting', one: '1 invitation waiting', other: '${count} invitations waiting')}";

  static String m8(minutes) => "${minutes} mins ago";

  static String m9(amount) => "Received ${amount} EGP";

  static String m10(amount) => "Sent ${amount} EGP";

  static String m11(name) => "By ${name}";

  static String m12(status) => "Marked as ${status}";

  static String m13(type) => "Transaction Receipt — ${type}";

  static String m14(name) => "Transactions: ${name}";

  static String m15(name) => "Workspace: ${name}";

  static String m16(count, total) =>
      "Viewing ${count} of ${total} transactions";

  static String m17(count) =>
      "${Intl.plural(count, zero: 'No members', one: '1 member', other: '${count} members')}";

  static String m18(email) =>
      "The invitation sent to ${email} will be removed immediately.";

  static String m19(memberName) =>
      "You will remove ${memberName} from this workspace, and any wallets they linked here will be removed too. They can be invited again later.";

  static String m20(providerName, phoneNumber) =>
      "The ${providerName} wallet linked to ${phoneNumber} will be removed from this workspace.";

  static String m21(ownerName) => "Owner: ${ownerName}";

  static String m22(ownedCount, linkedCount) =>
      "You own ${ownedCount} wallets, and ${linkedCount} are already linked to this workspace.";

  static String m23(count) =>
      "${Intl.plural(count, zero: 'No wallets', one: '1 wallet', other: '${count} wallets')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activeWalletsCount": m0,
    "activeWalletsHint": m1,
    "addWallet": MessageLookupByLibrary.simpleMessage("Add Wallet"),
    "addWalletAction": MessageLookupByLibrary.simpleMessage("Add Wallet"),
    "addWalletDescription": MessageLookupByLibrary.simpleMessage(
      "This wallet must be on this device. The app reads new SMS messages from this phone only.",
    ),
    "addWalletTitle": MessageLookupByLibrary.simpleMessage("Add Wallet"),
    "addWorkspace": MessageLookupByLibrary.simpleMessage("Add Workspace"),
    "allTransactions": MessageLookupByLibrary.simpleMessage("All Transactions"),
    "allowAndContinue": MessageLookupByLibrary.simpleMessage(
      "Allow and Continue",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Mahafez"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "Manage your business wallets with ease",
    ),
    "chooseProvider": MessageLookupByLibrary.simpleMessage("Choose a provider"),
    "commonCancelAction": MessageLookupByLibrary.simpleMessage("Cancel"),
    "commonDeleteAction": MessageLookupByLibrary.simpleMessage("Delete"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmName": MessageLookupByLibrary.simpleMessage("Confirm Name"),
    "confirmNameMessage": MessageLookupByLibrary.simpleMessage(
      "Please confirm your name to continue",
    ),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createWalletEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Connect a wallet on this device to start tracking balances and transactions automatically.",
    ),
    "createWalletEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Add your first wallet",
    ),
    "createWorkspaceAction": MessageLookupByLibrary.simpleMessage(
      "Create Workspace",
    ),
    "createWorkspaceDescription": MessageLookupByLibrary.simpleMessage(
      "Workspaces help you organize your business wallets and share access with trusted members in one place.",
    ),
    "createWorkspaceEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Bring your wallets together, track activity, and work with your team from one place.",
    ),
    "createWorkspaceEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Create your first workspace",
    ),
    "createWorkspacePreviewDescription": MessageLookupByLibrary.simpleMessage(
      "After you create the workspace, you can add wallets and invite members.",
    ),
    "createWorkspacePreviewFallback": MessageLookupByLibrary.simpleMessage(
      "New Workspace",
    ),
    "createWorkspacePreviewLabel": MessageLookupByLibrary.simpleMessage(
      "Workspace Preview",
    ),
    "createWorkspaceTitle": MessageLookupByLibrary.simpleMessage(
      "Create Workspace",
    ),
    "currency": MessageLookupByLibrary.simpleMessage("EGP"),
    "currentBalance": MessageLookupByLibrary.simpleMessage("Current Balance"),
    "deleteWallet": MessageLookupByLibrary.simpleMessage("Delete Wallet"),
    "deleteWalletConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this wallet? This action cannot be undone.",
    ),
    "deleteWalletConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Delete Wallet",
    ),
    "displayName": MessageLookupByLibrary.simpleMessage("Name"),
    "displayNameHint": MessageLookupByLibrary.simpleMessage("Enter your name"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "egp": MessageLookupByLibrary.simpleMessage("EGP"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailHint": MessageLookupByLibrary.simpleMessage("Enter your email"),
    "emailPlaceholder": MessageLookupByLibrary.simpleMessage(
      "example@email.com",
    ),
    "errorAuthEmailInUse": MessageLookupByLibrary.simpleMessage(
      "This email is already registered.",
    ),
    "errorAuthGeneric": MessageLookupByLibrary.simpleMessage(
      "Authentication failed. Please try again.",
    ),
    "errorAuthInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "Invalid email address.",
    ),
    "errorAuthTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Please try again later.",
    ),
    "errorAuthUserDisabled": MessageLookupByLibrary.simpleMessage(
      "This account has been disabled.",
    ),
    "errorAuthUserNotFound": MessageLookupByLibrary.simpleMessage(
      "User not found. Please check your credentials.",
    ),
    "errorAuthWeakPassword": MessageLookupByLibrary.simpleMessage(
      "Password is too weak. Please choose a stronger password.",
    ),
    "errorAuthWrongPassword": MessageLookupByLibrary.simpleMessage(
      "Incorrect password. Please try again.",
    ),
    "errorCache": MessageLookupByLibrary.simpleMessage(
      "Local storage error. Please try again.",
    ),
    "errorConflict": MessageLookupByLibrary.simpleMessage(
      "Resource conflict. Please try again.",
    ),
    "errorForbidden": MessageLookupByLibrary.simpleMessage("Access forbidden."),
    "errorInvitationAlreadyPending": MessageLookupByLibrary.simpleMessage(
      "A pending invitation already exists for this email.",
    ),
    "errorInvitationNotPending": MessageLookupByLibrary.simpleMessage(
      "This invitation is no longer pending.",
    ),
    "errorInvitationSelfNotAllowed": MessageLookupByLibrary.simpleMessage(
      "You cannot invite yourself to this workspace.",
    ),
    "errorInvitationUserAlreadyMember": MessageLookupByLibrary.simpleMessage(
      "This user is already a member of the workspace.",
    ),
    "errorInvitationUserNotFound": MessageLookupByLibrary.simpleMessage(
      "This email is not linked to any Mahafez account.",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Please check your network.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage(
      "Resource not found.",
    ),
    "errorPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Permission denied.",
    ),
    "errorServer": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later.",
    ),
    "errorServerGeneric": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "errorStorage": MessageLookupByLibrary.simpleMessage("File storage error."),
    "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Unauthorized access. Please log in again.",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.",
    ),
    "errorUnprocessable": MessageLookupByLibrary.simpleMessage(
      "Unable to process your request.",
    ),
    "errorValidation": MessageLookupByLibrary.simpleMessage(
      "Validation failed.",
    ),
    "errorValidationWithCode": m2,
    "errorWalletAllExists": MessageLookupByLibrary.simpleMessage(
      "All selected wallets are already added for this phone number.",
    ),
    "errorWalletAlreadyExists": MessageLookupByLibrary.simpleMessage(
      "This wallet is already added.",
    ),
    "errorWalletPhoneNumberInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid Egyptian mobile number.",
    ),
    "errorWalletPhoneNumberRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a phone number",
    ),
    "errorWalletProviderMismatch": MessageLookupByLibrary.simpleMessage(
      "This phone number only supports its matching mobile wallet provider and InstaPay.",
    ),
    "errorWalletProviderRequired": MessageLookupByLibrary.simpleMessage(
      "Please select at least one provider",
    ),
    "errorWorkspaceMemberNotFound": MessageLookupByLibrary.simpleMessage(
      "This member is no longer available in the workspace.",
    ),
    "errorWorkspaceNameRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a workspace name",
    ),
    "errorWorkspaceOwnerRemovalNotAllowed":
        MessageLookupByLibrary.simpleMessage(
          "The workspace owner cannot be removed.",
        ),
    "errorWorkspaceWalletSelectionRequired":
        MessageLookupByLibrary.simpleMessage(
          "Please select at least one wallet",
        ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "fromLabel": MessageLookupByLibrary.simpleMessage("From"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "fullNamePlaceholder": MessageLookupByLibrary.simpleMessage(
      "e.g. John Doe",
    ),
    "fullNameValidationEmpty": MessageLookupByLibrary.simpleMessage(
      "Please enter your name",
    ),
    "invitationAcceptDetails": MessageLookupByLibrary.simpleMessage(
      "You can start working in this workspace now.",
    ),
    "invitationAcceptSuccess": m3,
    "invitationDeclineConfirmMessage": m4,
    "invitationDeclineConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Decline invitation?",
    ),
    "invitationDeclineSuccess": m5,
    "invitationSentBy": m6,
    "invitationSentSuccess": MessageLookupByLibrary.simpleMessage(
      "Invitation sent successfully.",
    ),
    "invitationsAcceptAction": MessageLookupByLibrary.simpleMessage("Accept"),
    "invitationsDeclineAction": MessageLookupByLibrary.simpleMessage("Decline"),
    "invitationsDeletedWorkspaceFallback": MessageLookupByLibrary.simpleMessage(
      "Deleted workspace",
    ),
    "invitationsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "You do not have any pending workspace invitations right now.",
    ),
    "invitationsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No pending invitations",
    ),
    "invitationsHowItWorksDescription": MessageLookupByLibrary.simpleMessage(
      "Workspace invitations can only be sent to an existing Mahafez account using the email linked to that account.",
    ),
    "invitationsHowItWorksTitle": MessageLookupByLibrary.simpleMessage(
      "How invitations work",
    ),
    "invitationsListDescription": MessageLookupByLibrary.simpleMessage(
      "Review your workspace invitations and choose what to do.",
    ),
    "invitationsPendingCount": m7,
    "invitationsPendingStatus": MessageLookupByLibrary.simpleMessage("Pending"),
    "invitationsRecentResponsesTitle": MessageLookupByLibrary.simpleMessage(
      "Recent responses",
    ),
    "invitationsRefreshAction": MessageLookupByLibrary.simpleMessage(
      "Refresh list",
    ),
    "invitationsTitle": MessageLookupByLibrary.simpleMessage("Invitations"),
    "invitationsUnknownInviterFallback": MessageLookupByLibrary.simpleMessage(
      "Unknown sender",
    ),
    "inviteMemberDescription": MessageLookupByLibrary.simpleMessage(
      "Send a workspace invitation to an existing Mahafez account by email. The invited user will see it in their invitations inbox.",
    ),
    "inviteMemberEmailHint": MessageLookupByLibrary.simpleMessage(
      "name@example.com",
    ),
    "inviteMemberEmailLabel": MessageLookupByLibrary.simpleMessage(
      "Member email",
    ),
    "inviteMemberSendAction": MessageLookupByLibrary.simpleMessage(
      "Send invitation",
    ),
    "inviteMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Invite a member",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("Just Now"),
    "lastActivity": MessageLookupByLibrary.simpleMessage("Last Activity"),
    "minutesAgo": m8,
    "nameWillBeDisplayed": MessageLookupByLibrary.simpleMessage(
      "This name appears when payment status is updated, making transactions easier to track.",
    ),
    "noTransactionsTitle": MessageLookupByLibrary.simpleMessage(
      "No transactions yet. New messages will appear here automatically.",
    ),
    "notFoundPageTitle": MessageLookupByLibrary.simpleMessage("Page Not Found"),
    "notFoundStatusCode": MessageLookupByLibrary.simpleMessage("404"),
    "notNow": MessageLookupByLibrary.simpleMessage("Not Now"),
    "or": MessageLookupByLibrary.simpleMessage("OR"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("Enter your password"),
    "passwordPlaceholder": MessageLookupByLibrary.simpleMessage("••••••••"),
    "paymentStatus": MessageLookupByLibrary.simpleMessage("Payment Status"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "providerEtisalat": MessageLookupByLibrary.simpleMessage("Etisalat Cash"),
    "providerInstapay": MessageLookupByLibrary.simpleMessage("InstaPay"),
    "providerOrange": MessageLookupByLibrary.simpleMessage("Orange Cash"),
    "providerUnknown": MessageLookupByLibrary.simpleMessage("Wallet"),
    "providerVodafone": MessageLookupByLibrary.simpleMessage("Vodafone Cash"),
    "providerWePay": MessageLookupByLibrary.simpleMessage("WE Pay"),
    "recentTransactions": MessageLookupByLibrary.simpleMessage(
      "Recent Transactions",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "signInWithEmail": MessageLookupByLibrary.simpleMessage(
      "Sign in with Email",
    ),
    "signInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Sign in with Google",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signUpNow": MessageLookupByLibrary.simpleMessage("Sign Up Now"),
    "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
      "Create an account and start tracking your business",
    ),
    "smsPermissionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Track payments and expenses as soon as the SMS arrives.",
    ),
    "smsPermissionAutoUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "Automatic Update",
    ),
    "smsPermissionDescription": MessageLookupByLibrary.simpleMessage(
      "The app needs access to messages and phone information to find wallet numbers on this device and sync transactions automatically.",
    ),
    "smsPermissionPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "We only read financial messages and device phone numbers required for wallet setup; your data is encrypted and never shared.",
    ),
    "smsPermissionPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Your privacy matters",
    ),
    "smsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Allow Message and Phone Access",
    ),
    "toLabel": MessageLookupByLibrary.simpleMessage("To"),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
    "totalIn": MessageLookupByLibrary.simpleMessage("Total In"),
    "totalOut": MessageLookupByLibrary.simpleMessage("Total Out"),
    "transactionDetails": MessageLookupByLibrary.simpleMessage(
      "Transaction Details",
    ),
    "transactionMessageReceive": m9,
    "transactionMessageSend": m10,
    "transactionStatusPaid": MessageLookupByLibrary.simpleMessage("Paid"),
    "transactionStatusUnpaid": MessageLookupByLibrary.simpleMessage("Unpaid"),
    "transactionTypeReceive": MessageLookupByLibrary.simpleMessage("Receive"),
    "transactionTypeSend": MessageLookupByLibrary.simpleMessage("Send"),
    "transaction_addNote": MessageLookupByLibrary.simpleMessage("Add Note"),
    "transaction_amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "transaction_by": m11,
    "transaction_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "transaction_date": MessageLookupByLibrary.simpleMessage("Date"),
    "transaction_dateTime": MessageLookupByLibrary.simpleMessage("Date & Time"),
    "transaction_deleteAction": MessageLookupByLibrary.simpleMessage("Delete"),
    "transaction_deleteNoteMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this note? This action cannot be undone.",
    ),
    "transaction_deleteNoteTitle": MessageLookupByLibrary.simpleMessage(
      "Delete Note",
    ),
    "transaction_edited": MessageLookupByLibrary.simpleMessage("Edited"),
    "transaction_errorGeneric": MessageLookupByLibrary.simpleMessage(
      "An error occurred",
    ),
    "transaction_history": MessageLookupByLibrary.simpleMessage(
      "Change History",
    ),
    "transaction_markedAs": m12,
    "transaction_noteDeleted": MessageLookupByLibrary.simpleMessage(
      "Note deleted",
    ),
    "transaction_noteHint": MessageLookupByLibrary.simpleMessage(
      "Write your note here…",
    ),
    "transaction_notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "transaction_receiptHeader": m13,
    "transaction_receivedFrom": MessageLookupByLibrary.simpleMessage(
      "Received From",
    ),
    "transaction_referenceNumber": MessageLookupByLibrary.simpleMessage(
      "Reference Number",
    ),
    "transaction_save": MessageLookupByLibrary.simpleMessage("Save"),
    "transaction_sentTo": MessageLookupByLibrary.simpleMessage("Sent To"),
    "transaction_shareReceipt": MessageLookupByLibrary.simpleMessage(
      "Share Receipt",
    ),
    "transaction_smsText": MessageLookupByLibrary.simpleMessage("SMS Text"),
    "transaction_typeReceiveLabel": MessageLookupByLibrary.simpleMessage(
      "Receive Transaction",
    ),
    "transaction_typeSendLabel": MessageLookupByLibrary.simpleMessage(
      "Send Transaction",
    ),
    "transaction_undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "transaction_wallet": MessageLookupByLibrary.simpleMessage("Wallet"),
    "transactionsHistory": MessageLookupByLibrary.simpleMessage(
      "Transaction History",
    ),
    "transactions_clearFilters": MessageLookupByLibrary.simpleMessage(
      "Clear Filters",
    ),
    "transactions_date_customRange": MessageLookupByLibrary.simpleMessage(
      "Custom Range",
    ),
    "transactions_date_month": MessageLookupByLibrary.simpleMessage(
      "This Month",
    ),
    "transactions_date_today": MessageLookupByLibrary.simpleMessage("Today"),
    "transactions_date_week": MessageLookupByLibrary.simpleMessage("This Week"),
    "transactions_date_yesterday": MessageLookupByLibrary.simpleMessage(
      "Yesterday",
    ),
    "transactions_emptyHintDescription": MessageLookupByLibrary.simpleMessage(
      "When activity is detected on a connected wallet, we sync it here for you automatically.",
    ),
    "transactions_emptyHintTitle": MessageLookupByLibrary.simpleMessage(
      "Automatic tracking",
    ),
    "transactions_emptyTitle": MessageLookupByLibrary.simpleMessage(
      "No transactions yet",
    ),
    "transactions_emptyWalletDescription": MessageLookupByLibrary.simpleMessage(
      "This wallet has no transactions yet. New messages will appear here automatically.",
    ),
    "transactions_emptyWithFilter": MessageLookupByLibrary.simpleMessage(
      "No transactions match the selected filter",
    ),
    "transactions_emptyWithFilterDescription":
        MessageLookupByLibrary.simpleMessage(
          "Try clearing one or more filters to see more activity.",
        ),
    "transactions_emptyWithFilterTitle": MessageLookupByLibrary.simpleMessage(
      "No matching transactions",
    ),
    "transactions_emptyWorkspaceDescription": MessageLookupByLibrary.simpleMessage(
      "This workspace has no transactions yet. Activity from any linked wallet will appear here automatically.",
    ),
    "transactions_filter_all": MessageLookupByLibrary.simpleMessage("All"),
    "transactions_filter_allWallets": MessageLookupByLibrary.simpleMessage(
      "All Wallets",
    ),
    "transactions_loadMore": MessageLookupByLibrary.simpleMessage("Load More"),
    "transactions_title_wallet": m14,
    "transactions_title_workspace": m15,
    "transactions_viewingCountOfTotal": m16,
    "userSettingsAboutSection": MessageLookupByLibrary.simpleMessage("About"),
    "userSettingsAccountSection": MessageLookupByLibrary.simpleMessage(
      "Account",
    ),
    "userSettingsAppSection": MessageLookupByLibrary.simpleMessage("App"),
    "userSettingsAppVersionLabel": MessageLookupByLibrary.simpleMessage(
      "App version",
    ),
    "userSettingsDeleteAccountAction": MessageLookupByLibrary.simpleMessage(
      "Delete account",
    ),
    "userSettingsDeleteAccountConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "This is a sensitive action and, once fully implemented, will permanently remove data linked to your account.",
    ),
    "userSettingsDeleteAccountConfirmTitle":
        MessageLookupByLibrary.simpleMessage("Delete account?"),
    "userSettingsDeleteAccountUnavailableMessage":
        MessageLookupByLibrary.simpleMessage(
          "A partial delete would leave linked wallets, workspaces, and invitations behind. This action will be enabled after we add a safe full-data cleanup flow.",
        ),
    "userSettingsDeleteAccountUnavailableTitle":
        MessageLookupByLibrary.simpleMessage(
          "Delete account is not available yet",
        ),
    "userSettingsEditNameAction": MessageLookupByLibrary.simpleMessage(
      "Edit name",
    ),
    "userSettingsEditNameDescription": MessageLookupByLibrary.simpleMessage(
      "Update the name shown across the app and activity history.",
    ),
    "userSettingsEditNameSaveAction": MessageLookupByLibrary.simpleMessage(
      "Save changes",
    ),
    "userSettingsEditNameTitle": MessageLookupByLibrary.simpleMessage(
      "Edit name",
    ),
    "userSettingsNameUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Name updated successfully.",
    ),
    "userSettingsNoEmailLabel": MessageLookupByLibrary.simpleMessage(
      "No email linked to this account",
    ),
    "userSettingsOpenSystemSettingsAction":
        MessageLookupByLibrary.simpleMessage("Open settings"),
    "userSettingsSignOutAction": MessageLookupByLibrary.simpleMessage(
      "Sign out",
    ),
    "userSettingsSignOutConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "This will end your current session on this device. You can sign in again at any time.",
    ),
    "userSettingsSignOutConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Sign out?",
    ),
    "userSettingsSmsPermissionCheckingLabel":
        MessageLookupByLibrary.simpleMessage("Checking permission status..."),
    "userSettingsSmsPermissionDisabledLabel":
        MessageLookupByLibrary.simpleMessage(
          "Disabled, and the app cannot work without it.",
        ),
    "userSettingsSmsPermissionEnabledLabel":
        MessageLookupByLibrary.simpleMessage("Enabled"),
    "userSettingsSmsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "SMS read permission",
    ),
    "userSettingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
    "viaLabel": MessageLookupByLibrary.simpleMessage("Via"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View All"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("Wallet Details"),
    "walletLabel": MessageLookupByLibrary.simpleMessage("Your wallet"),
    "walletStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "walletTransactions": MessageLookupByLibrary.simpleMessage(
      "Wallet Transactions",
    ),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "whatIsYourName": MessageLookupByLibrary.simpleMessage(
      "What is your name?",
    ),
    "workspaceAddSelectedWalletsAction": MessageLookupByLibrary.simpleMessage(
      "Add Selected Wallets",
    ),
    "workspaceAddWalletsAction": MessageLookupByLibrary.simpleMessage(
      "Add Wallets",
    ),
    "workspaceAddWalletsCreateDescription": MessageLookupByLibrary.simpleMessage(
      "Choose which of your wallets should appear in this workspace now. You can add more later.",
    ),
    "workspaceAddWalletsManageDescription": MessageLookupByLibrary.simpleMessage(
      "Share your own wallets with this workspace. Linked wallets become visible to all workspace members.",
    ),
    "workspaceAddWalletsTitle": MessageLookupByLibrary.simpleMessage(
      "Add Wallets",
    ),
    "workspaceAllOwnedWalletsLinkedDescription":
        MessageLookupByLibrary.simpleMessage(
          "You can continue to the workspace or add a new wallet later.",
        ),
    "workspaceAllOwnedWalletsLinkedTitle": MessageLookupByLibrary.simpleMessage(
      "All of your wallets are already linked",
    ),
    "workspaceContinueToDetailsAction": MessageLookupByLibrary.simpleMessage(
      "Continue to Workspace",
    ),
    "workspaceInviteMemberAction": MessageLookupByLibrary.simpleMessage(
      "Invite member",
    ),
    "workspaceMembers": MessageLookupByLibrary.simpleMessage("Members"),
    "workspaceMembersCount": m17,
    "workspaceMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "No members have joined this workspace yet.",
    ),
    "workspaceNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Mobile Store",
    ),
    "workspaceNameLabel": MessageLookupByLibrary.simpleMessage(
      "Workspace Name",
    ),
    "workspaceNoOwnedWalletsDescription": MessageLookupByLibrary.simpleMessage(
      "Add a wallet first, then you can share it with this workspace.",
    ),
    "workspaceNoOwnedWalletsTitle": MessageLookupByLibrary.simpleMessage(
      "You do not have any wallets yet",
    ),
    "workspaceOwner": MessageLookupByLibrary.simpleMessage("Owner"),
    "workspaceOwnerBadge": MessageLookupByLibrary.simpleMessage("Owner"),
    "workspaceSettingsAccessSection": MessageLookupByLibrary.simpleMessage(
      "Your access",
    ),
    "workspaceSettingsCancelInvitationAction":
        MessageLookupByLibrary.simpleMessage("Cancel"),
    "workspaceSettingsCancelInvitationConfirmMessage": m18,
    "workspaceSettingsCancelInvitationConfirmTitle":
        MessageLookupByLibrary.simpleMessage("Cancel invitation?"),
    "workspaceSettingsDangerZone": MessageLookupByLibrary.simpleMessage(
      "Sensitive actions",
    ),
    "workspaceSettingsDeleteWorkspaceAction":
        MessageLookupByLibrary.simpleMessage("Delete workspace"),
    "workspaceSettingsDeleteWorkspaceConfirmMessage":
        MessageLookupByLibrary.simpleMessage(
          "This will permanently delete the workspace, its member access, wallet links, and pending invitations.",
        ),
    "workspaceSettingsDeleteWorkspaceConfirmTitle":
        MessageLookupByLibrary.simpleMessage("Delete workspace?"),
    "workspaceSettingsDeleteWorkspaceDescription":
        MessageLookupByLibrary.simpleMessage(
          "All linked data and access records will be removed permanently.",
        ),
    "workspaceSettingsEditNameAction": MessageLookupByLibrary.simpleMessage(
      "Save changes",
    ),
    "workspaceSettingsEditNameDescription":
        MessageLookupByLibrary.simpleMessage(
          "Update the visible name used across the workspace and shared views.",
        ),
    "workspaceSettingsEditNameTitle": MessageLookupByLibrary.simpleMessage(
      "Edit workspace name",
    ),
    "workspaceSettingsInfoSection": MessageLookupByLibrary.simpleMessage(
      "Workspace Info",
    ),
    "workspaceSettingsInvitationCancelledSuccess":
        MessageLookupByLibrary.simpleMessage(
          "Invitation cancelled successfully.",
        ),
    "workspaceSettingsInviteByEmailAction":
        MessageLookupByLibrary.simpleMessage("Invite member"),
    "workspaceSettingsLeaveWorkspaceAction":
        MessageLookupByLibrary.simpleMessage("Leave workspace"),
    "workspaceSettingsLeaveWorkspaceConfirmMessage":
        MessageLookupByLibrary.simpleMessage(
          "You will lose access to this workspace, and the wallets you linked here will be removed from it.",
        ),
    "workspaceSettingsLeaveWorkspaceConfirmTitle":
        MessageLookupByLibrary.simpleMessage("Leave workspace?"),
    "workspaceSettingsLeaveWorkspaceDescription":
        MessageLookupByLibrary.simpleMessage(
          "Your membership and your linked wallets will be removed from this workspace.",
        ),
    "workspaceSettingsManageAccessAction": MessageLookupByLibrary.simpleMessage(
      "Manage access",
    ),
    "workspaceSettingsMemberDescription": MessageLookupByLibrary.simpleMessage(
      "Review the shared members and linked wallets, remove your own wallets when needed, or leave the workspace.",
    ),
    "workspaceSettingsMemberRemovedSuccess":
        MessageLookupByLibrary.simpleMessage("Member removed successfully."),
    "workspaceSettingsNameUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Workspace name updated successfully.",
    ),
    "workspaceSettingsPendingInvitationsEmpty":
        MessageLookupByLibrary.simpleMessage(
          "There are no pending invitations for this workspace right now.",
        ),
    "workspaceSettingsPendingInvitationsSection":
        MessageLookupByLibrary.simpleMessage("Pending Invitations"),
    "workspaceSettingsRemoveMemberAction": MessageLookupByLibrary.simpleMessage(
      "Remove",
    ),
    "workspaceSettingsRemoveMemberConfirmMessage": m19,
    "workspaceSettingsRemoveMemberConfirmTitle":
        MessageLookupByLibrary.simpleMessage("Remove member?"),
    "workspaceSettingsRemoveWalletAction": MessageLookupByLibrary.simpleMessage(
      "Remove wallet",
    ),
    "workspaceSettingsRemoveWalletConfirmMessage": m20,
    "workspaceSettingsRemoveWalletConfirmTitle":
        MessageLookupByLibrary.simpleMessage("Remove wallet?"),
    "workspaceSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Workspace Settings",
    ),
    "workspaceSettingsWalletOwner": m21,
    "workspaceSettingsWalletReadOnlyTooltip":
        MessageLookupByLibrary.simpleMessage(
          "Only the wallet owner can remove this wallet",
        ),
    "workspaceSettingsWalletRemovedSuccess":
        MessageLookupByLibrary.simpleMessage(
          "Wallet removed from the workspace successfully.",
        ),
    "workspaceSettingsWalletsEmptyMember": MessageLookupByLibrary.simpleMessage(
      "There are no linked wallets in this workspace yet.",
    ),
    "workspaceSettingsWalletsEmptyOwner": MessageLookupByLibrary.simpleMessage(
      "There are no linked wallets in this workspace yet.",
    ),
    "workspaceSettingsWalletsMemberDescription":
        MessageLookupByLibrary.simpleMessage(
          "You can review every linked wallet here, but you can remove only the wallets you added.",
        ),
    "workspaceSettingsWalletsOwnerDescription":
        MessageLookupByLibrary.simpleMessage(
          "Review every linked wallet in this workspace and remove any wallet that should no longer be shared.",
        ),
    "workspaceSkipWalletsAction": MessageLookupByLibrary.simpleMessage(
      "Skip for now",
    ),
    "workspaceUnavailableAction": MessageLookupByLibrary.simpleMessage(
      "Back to home",
    ),
    "workspaceUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "It looks like this workspace was deleted or your access was removed. We’ll take you back home.",
    ),
    "workspaceUnavailableTitle": MessageLookupByLibrary.simpleMessage(
      "Workspace is no longer available",
    ),
    "workspaceUnknownMember": MessageLookupByLibrary.simpleMessage(
      "Unknown member",
    ),
    "workspaceWalletAlreadyAdded": MessageLookupByLibrary.simpleMessage(
      "Already Added",
    ),
    "workspaceWalletAvailable": MessageLookupByLibrary.simpleMessage(
      "Available",
    ),
    "workspaceWalletSelected": MessageLookupByLibrary.simpleMessage("Selected"),
    "workspaceWalletSelectionSummary": m22,
    "workspaceWallets": MessageLookupByLibrary.simpleMessage("Wallets"),
    "workspaceWalletsCount": m23,
    "workspaceWalletsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "This workspace will show shared wallets here once they are linked.",
    ),
    "workspaceWalletsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No wallets linked yet",
    ),
    "workspaces": MessageLookupByLibrary.simpleMessage("Workspaces"),
    "yourName": MessageLookupByLibrary.simpleMessage("Your Name"),
    "yourWallets": MessageLookupByLibrary.simpleMessage("Your Wallets"),
  };
}

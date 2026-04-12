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

  static String m18(ownedCount, linkedCount) =>
      "You own ${ownedCount} wallets, and ${linkedCount} are already linked to this workspace.";

  static String m19(count) =>
      "${Intl.plural(count, zero: 'No wallets', one: '1 wallet', other: '${count} wallets')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activeWalletsCount": m0,
    "activeWalletsHint": m1,
    "addWallet": MessageLookupByLibrary.simpleMessage("Add Wallet"),
    "addWalletAction": MessageLookupByLibrary.simpleMessage("Add Wallet"),
    "addWalletDescription": MessageLookupByLibrary.simpleMessage(
      "This wallet must be available on this device. The app reads new SMS messages from this phone only.",
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
      "Manage your business wallets easily",
    ),
    "chooseProvider": MessageLookupByLibrary.simpleMessage(
      "Choose Service Provider",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmName": MessageLookupByLibrary.simpleMessage("Confirm Name"),
    "confirmNameMessage": MessageLookupByLibrary.simpleMessage(
      "Please confirm your name to continue",
    ),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createWorkspaceAction": MessageLookupByLibrary.simpleMessage(
      "Create Workspace",
    ),
    "createWorkspaceDescription": MessageLookupByLibrary.simpleMessage(
      "Workspaces help you organize business wallets and collaborate with trusted members in one place.",
    ),
    "createWorkspaceEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Group business wallets, track activity, and bring your team into one shared space.",
    ),
    "createWorkspaceEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Create your first workspace",
    ),
    "createWorkspacePreviewDescription": MessageLookupByLibrary.simpleMessage(
      "You can add wallets and invite members after creating this workspace.",
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
    "errorWalletPhoneNumberRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a phone number",
    ),
    "errorWalletProviderRequired": MessageLookupByLibrary.simpleMessage(
      "Please select at least one provider",
    ),
    "errorWorkspaceNameRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a workspace name",
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
      "Your access to this workspace is ready.",
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
      "Review incoming workspace invitations and respond when you are ready.",
    ),
    "invitationsPendingCount": m7,
    "invitationsPendingStatus": MessageLookupByLibrary.simpleMessage(
      "Awaiting response",
    ),
    "invitationsRecentResponsesTitle": MessageLookupByLibrary.simpleMessage(
      "Recent responses",
    ),
    "invitationsRefreshAction": MessageLookupByLibrary.simpleMessage(
      "Refresh list",
    ),
    "invitationsTitle": MessageLookupByLibrary.simpleMessage("Invitations"),
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
      "Your name will be displayed when updating payment status to facilitate tracking financial transactions",
    ),
    "noTransactionsTitle": MessageLookupByLibrary.simpleMessage(
      "No transactions yet, they will appear here when new messages arrive",
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
      "Create a new account to start managing your business",
    ),
    "smsPermissionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Instant tracking of expenses and payments upon arrival of bank message.",
    ),
    "smsPermissionAutoUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "Automatic Update",
    ),
    "smsPermissionDescription": MessageLookupByLibrary.simpleMessage(
      "The app needs message and phone access to detect this device\'s wallet numbers and automatically sync wallet transactions.",
    ),
    "smsPermissionPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "We only read financial messages and device phone numbers required for wallet setup; your data is encrypted and never shared.",
    ),
    "smsPermissionPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Complete Privacy",
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
      "Transactions History",
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
    "transactions_emptyWithFilter": MessageLookupByLibrary.simpleMessage(
      "No transactions match the selected filter",
    ),
    "transactions_filter_all": MessageLookupByLibrary.simpleMessage("All"),
    "transactions_filter_allWallets": MessageLookupByLibrary.simpleMessage(
      "All Wallets",
    ),
    "transactions_loadMore": MessageLookupByLibrary.simpleMessage("Load More"),
    "transactions_title_wallet": m14,
    "transactions_title_workspace": m15,
    "transactions_viewingCountOfTotal": m16,
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
    "workspaceSkipWalletsAction": MessageLookupByLibrary.simpleMessage(
      "Skip for now",
    ),
    "workspaceWalletAlreadyAdded": MessageLookupByLibrary.simpleMessage(
      "Already Added",
    ),
    "workspaceWalletAvailable": MessageLookupByLibrary.simpleMessage(
      "Available",
    ),
    "workspaceWalletSelected": MessageLookupByLibrary.simpleMessage("Selected"),
    "workspaceWalletSelectionSummary": m18,
    "workspaceWallets": MessageLookupByLibrary.simpleMessage("Wallets"),
    "workspaceWalletsCount": m19,
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

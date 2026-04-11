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

  static String m3(minutes) => "${minutes} mins ago";

  static String m4(amount) => "Received ${amount} EGP";

  static String m5(amount) => "Sent ${amount} EGP";

  static String m6(name) => "By ${name}";

  static String m7(status) => "Marked as ${status}";

  static String m8(type) => "Transaction Receipt — ${type}";

  static String m9(name) => "Transactions: ${name}";

  static String m10(name) => "Workspace: ${name}";

  static String m11(count, total) =>
      "Viewing ${count} of ${total} transactions";

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
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "fromLabel": MessageLookupByLibrary.simpleMessage("From"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "fullNamePlaceholder": MessageLookupByLibrary.simpleMessage(
      "e.g. John Doe",
    ),
    "fullNameValidationEmpty": MessageLookupByLibrary.simpleMessage(
      "Please enter your name",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("Just Now"),
    "lastActivity": MessageLookupByLibrary.simpleMessage("Last Activity"),
    "minutesAgo": m3,
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
    "transactionMessageReceive": m4,
    "transactionMessageSend": m5,
    "transactionStatusPaid": MessageLookupByLibrary.simpleMessage("Paid"),
    "transactionStatusUnpaid": MessageLookupByLibrary.simpleMessage("Unpaid"),
    "transactionTypeReceive": MessageLookupByLibrary.simpleMessage("Receive"),
    "transactionTypeSend": MessageLookupByLibrary.simpleMessage("Send"),
    "transaction_addNote": MessageLookupByLibrary.simpleMessage("Add Note"),
    "transaction_amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "transaction_by": m6,
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
    "transaction_markedAs": m7,
    "transaction_noteDeleted": MessageLookupByLibrary.simpleMessage(
      "Note deleted",
    ),
    "transaction_noteHint": MessageLookupByLibrary.simpleMessage(
      "Write your note here…",
    ),
    "transaction_notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "transaction_receiptHeader": m8,
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
    "transactions_title_wallet": m9,
    "transactions_title_workspace": m10,
    "transactions_viewingCountOfTotal": m11,
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
    "workspaces": MessageLookupByLibrary.simpleMessage("Workspaces"),
    "yourName": MessageLookupByLibrary.simpleMessage("Your Name"),
    "yourWallets": MessageLookupByLibrary.simpleMessage("Your Wallets"),
  };
}

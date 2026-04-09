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
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "fullNamePlaceholder": MessageLookupByLibrary.simpleMessage(
      "e.g. John Doe",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("Just Now"),
    "lastActivity": MessageLookupByLibrary.simpleMessage("Last Activity"),
    "minutesAgo": m3,
    "nameWillBeDisplayed": MessageLookupByLibrary.simpleMessage(
      "Your name will be displayed when updating payment status to facilitate tracking financial transactions",
    ),
    "notFoundPageTitle": MessageLookupByLibrary.simpleMessage("Page Not Found"),
    "notFoundStatusCode": MessageLookupByLibrary.simpleMessage("404"),
    "notNow": MessageLookupByLibrary.simpleMessage("Not Now"),
    "or": MessageLookupByLibrary.simpleMessage("OR"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("Enter your password"),
    "passwordPlaceholder": MessageLookupByLibrary.simpleMessage("••••••••"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "providerEtisalat": MessageLookupByLibrary.simpleMessage("Etisalat Cash"),
    "providerInstapay": MessageLookupByLibrary.simpleMessage("InstaPay"),
    "providerOrange": MessageLookupByLibrary.simpleMessage("Orange Cash"),
    "providerUnknown": MessageLookupByLibrary.simpleMessage("Wallet"),
    "providerVodafone": MessageLookupByLibrary.simpleMessage("Vodafone Cash"),
    "providerWePay": MessageLookupByLibrary.simpleMessage("WE Pay"),
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
      "The app needs access to messages to automatically sync transactions from your wallet.",
    ),
    "smsPermissionPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "We only read financial messages; your data is encrypted and never shared.",
    ),
    "smsPermissionPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Complete Privacy",
    ),
    "smsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Allow Access to Messages",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
    "totalIn": MessageLookupByLibrary.simpleMessage("Total In"),
    "totalOut": MessageLookupByLibrary.simpleMessage("Total Out"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View All"),
    "walletStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "whatIsYourName": MessageLookupByLibrary.simpleMessage(
      "What is your name?",
    ),
    "workspaces": MessageLookupByLibrary.simpleMessage("Workspaces"),
    "yourName": MessageLookupByLibrary.simpleMessage("Your Name"),
    "yourWallets": MessageLookupByLibrary.simpleMessage("Your Wallets"),
  };
}

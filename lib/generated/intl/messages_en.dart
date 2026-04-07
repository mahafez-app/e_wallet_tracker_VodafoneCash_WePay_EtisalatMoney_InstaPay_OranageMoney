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

  static String m0(code) => "Validation failed: ${code}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("Mahafez"),
        "errorAuthEmailInUse": MessageLookupByLibrary.simpleMessage(
            "This email is already registered."),
        "errorAuthGeneric": MessageLookupByLibrary.simpleMessage(
            "Authentication failed. Please try again."),
        "errorAuthInvalidEmail":
            MessageLookupByLibrary.simpleMessage("Invalid email address."),
        "errorAuthTooManyRequests": MessageLookupByLibrary.simpleMessage(
            "Too many attempts. Please try again later."),
        "errorAuthUserDisabled": MessageLookupByLibrary.simpleMessage(
            "This account has been disabled."),
        "errorAuthUserNotFound": MessageLookupByLibrary.simpleMessage(
            "User not found. Please check your credentials."),
        "errorAuthWeakPassword": MessageLookupByLibrary.simpleMessage(
            "Password is too weak. Please choose a stronger password."),
        "errorAuthWrongPassword": MessageLookupByLibrary.simpleMessage(
            "Incorrect password. Please try again."),
        "errorCache": MessageLookupByLibrary.simpleMessage(
            "Local storage error. Please try again."),
        "errorConflict": MessageLookupByLibrary.simpleMessage(
            "Resource conflict. Please try again."),
        "errorForbidden":
            MessageLookupByLibrary.simpleMessage("Access forbidden."),
        "errorNetwork": MessageLookupByLibrary.simpleMessage(
            "No internet connection. Please check your network."),
        "errorNotFound":
            MessageLookupByLibrary.simpleMessage("Resource not found."),
        "errorPermissionDenied":
            MessageLookupByLibrary.simpleMessage("Permission denied."),
        "errorServer": MessageLookupByLibrary.simpleMessage(
            "Server error. Please try again later."),
        "errorServerGeneric": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Please try again."),
        "errorStorage":
            MessageLookupByLibrary.simpleMessage("File storage error."),
        "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
            "Unauthorized access. Please log in again."),
        "errorUnknown": MessageLookupByLibrary.simpleMessage(
            "An unexpected error occurred."),
        "errorUnprocessable": MessageLookupByLibrary.simpleMessage(
            "Unable to process your request."),
        "errorValidation":
            MessageLookupByLibrary.simpleMessage("Validation failed."),
        "errorValidationWithCode": m0,
        "notFoundPageTitle":
            MessageLookupByLibrary.simpleMessage("Page Not Found"),
        "notFoundStatusCode": MessageLookupByLibrary.simpleMessage("404")
      };
}

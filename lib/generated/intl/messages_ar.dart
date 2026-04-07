// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(code) => "فشل التحقق: ${code}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "errorAuthEmailInUse": MessageLookupByLibrary.simpleMessage(
      "هذا البريد الإلكتروني مسجل بالفعل.",
    ),
    "errorAuthGeneric": MessageLookupByLibrary.simpleMessage(
      "فشل المصادقة. يرجى المحاولة مرة أخرى.",
    ),
    "errorAuthInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "عنوان البريد الإلكتروني غير صحيح.",
    ),
    "errorAuthTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "عدد محاولات كبير جداً. يرجى المحاولة لاحقاً.",
    ),
    "errorAuthUserDisabled": MessageLookupByLibrary.simpleMessage(
      "تم تعطيل هذا الحساب.",
    ),
    "errorAuthUserNotFound": MessageLookupByLibrary.simpleMessage(
      "المستخدم غير موجود. يرجى التحقق من بيانات الاعتماد الخاصة بك.",
    ),
    "errorAuthWeakPassword": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور ضعيفة جداً. يرجى اختيار كلمة مرور أقوى.",
    ),
    "errorAuthWrongPassword": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.",
    ),
    "errorCache": MessageLookupByLibrary.simpleMessage(
      "خطأ في التخزين المحلي. يرجى المحاولة مرة أخرى.",
    ),
    "errorConflict": MessageLookupByLibrary.simpleMessage(
      "تضارب المورد. يرجى المحاولة مرة أخرى.",
    ),
    "errorForbidden": MessageLookupByLibrary.simpleMessage("الوصول ممنوع."),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "لا توجد اتصالات إنترنت. يرجى التحقق من شبكتك.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("المورد غير موجود."),
    "errorPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "تم رفض الإذن.",
    ),
    "errorServer": MessageLookupByLibrary.simpleMessage(
      "خطأ في الخادم. يرجى المحاولة لاحقاً.",
    ),
    "errorServerGeneric": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
    ),
    "errorStorage": MessageLookupByLibrary.simpleMessage(
      "خطأ في تخزين الملفات.",
    ),
    "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "وصول غير مصرح. يرجى تسجيل الدخول مرة أخرى.",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage("حدث خطأ غير متوقع."),
    "errorUnprocessable": MessageLookupByLibrary.simpleMessage(
      "تعذر معالجة طلبك.",
    ),
    "errorValidation": MessageLookupByLibrary.simpleMessage("فشل التحقق."),
    "errorValidationWithCode": m0,
  };
}

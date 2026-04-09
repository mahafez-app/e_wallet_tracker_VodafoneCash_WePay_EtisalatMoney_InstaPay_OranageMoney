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

  static String m0(count) =>
      "${Intl.plural(count, zero: 'لا توجد محافظ نشطة', one: 'محفظة واحدة نشطة', two: 'محفظتان نشطتان', few: '${count} محافظ نشطة', many: '${count} محفظة نشطة', other: '${count} محفظة نشطة')}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'لم تقم بإضافة أي محافظ بعد', one: 'إجمالي الرصيد لمحفظتك', two: 'إجمالي الرصيد لمحفظتيك', few: 'إجمالي الرصيد لـ ${count} من محافظك', many: 'إجمالي الرصيد لـ ${count} من محافظك', other: 'إجمالي الرصيد لـ ${count} من محافظك')}";

  static String m2(code) => "فشل التحقق: ${code}";

  static String m3(minutes) => "منذ ${minutes} دقيقة";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activeWalletsCount": m0,
    "activeWalletsHint": m1,
    "addWallet": MessageLookupByLibrary.simpleMessage("إضافة محفظة"),
    "addWalletAction": MessageLookupByLibrary.simpleMessage("إضافة المحفظة"),
    "addWalletDescription": MessageLookupByLibrary.simpleMessage(
      "يجب أن تكون هذه المحفظة متاحة على هذا الجهاز. التطبيق يقرأ رسائل SMS الجديدة من هذا الهاتف فقط.",
    ),
    "addWalletTitle": MessageLookupByLibrary.simpleMessage("إضافة محفظة"),
    "allowAndContinue": MessageLookupByLibrary.simpleMessage("سماح ومتابعة"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("محافظ"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "إدارة محافظك الخاصة بالأعمال بسهولة",
    ),
    "chooseProvider": MessageLookupByLibrary.simpleMessage("اختر مزود الخدمة"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmName": MessageLookupByLibrary.simpleMessage("تأكيد الاسم"),
    "confirmNameMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى تأكيد اسمك للمتابعة",
    ),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "المتابعة باستخدام جوجل",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "currency": MessageLookupByLibrary.simpleMessage("ج.م"),
    "currentBalance": MessageLookupByLibrary.simpleMessage("الرصيد الحالي"),
    "displayName": MessageLookupByLibrary.simpleMessage("الاسم"),
    "displayNameHint": MessageLookupByLibrary.simpleMessage("أدخل اسمك"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "egp": MessageLookupByLibrary.simpleMessage("EGP"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailHint": MessageLookupByLibrary.simpleMessage("أدخل بريدك الإلكتروني"),
    "emailPlaceholder": MessageLookupByLibrary.simpleMessage(
      "example@email.com",
    ),
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
    "errorValidationWithCode": m2,
    "errorWalletAllExists": MessageLookupByLibrary.simpleMessage(
      "جميع المحافظ المختارة مضافة بالفعل لهذا الرقم.",
    ),
    "errorWalletPhoneNumberRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم الهاتف",
    ),
    "errorWalletProviderRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار مزود خدمة واحد على الأقل",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "fullNamePlaceholder": MessageLookupByLibrary.simpleMessage(
      "مثلاً: أحمد محمود",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("الآن"),
    "lastActivity": MessageLookupByLibrary.simpleMessage("آخر نشاط"),
    "minutesAgo": m3,
    "nameWillBeDisplayed": MessageLookupByLibrary.simpleMessage(
      "سيظهر اسمك عند تحديث حالة الدفع لتسهيل تتبع العمليات المالية",
    ),
    "notFoundPageTitle": MessageLookupByLibrary.simpleMessage(
      "الصفحة غير موجودة",
    ),
    "notFoundStatusCode": MessageLookupByLibrary.simpleMessage("404"),
    "notNow": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "or": MessageLookupByLibrary.simpleMessage("أو"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
    "passwordPlaceholder": MessageLookupByLibrary.simpleMessage("••••••••"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "providerEtisalat": MessageLookupByLibrary.simpleMessage("اتصالات كاش"),
    "providerInstapay": MessageLookupByLibrary.simpleMessage("إنستا باي"),
    "providerOrange": MessageLookupByLibrary.simpleMessage("أورانج كاش"),
    "providerUnknown": MessageLookupByLibrary.simpleMessage("محفظة"),
    "providerVodafone": MessageLookupByLibrary.simpleMessage("فودافون كاش"),
    "providerWePay": MessageLookupByLibrary.simpleMessage("وي باي"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInWithEmail": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول بالبريد الإلكتروني",
    ),
    "signInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول بواسطة جوجل",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "signUpNow": MessageLookupByLibrary.simpleMessage("اشترك الآن"),
    "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء حساب جديد للبدء في إدارة أعمالك",
    ),
    "smsPermissionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "رصد فوري للمصروفات والمدفوعات فور وصول رسالة البنك.",
    ),
    "smsPermissionAutoUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "تحديث تلقائي",
    ),
    "smsPermissionDescription": MessageLookupByLibrary.simpleMessage(
      "يحتاج التطبيق إلى الوصول للرسائل لمزامنة المعاملات تلقائياً من محفظتك.",
    ),
    "smsPermissionPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "نقرأ فقط الرسائل المالية؛ بياناتك مشفرة ولا يتم مشاركتها أبدا.",
    ),
    "smsPermissionPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "خصوصية تامة",
    ),
    "smsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "السماح بالوصول إلى الرسائل",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("إجمالي الرصيد"),
    "totalIn": MessageLookupByLibrary.simpleMessage("إجمالي الوارد"),
    "totalOut": MessageLookupByLibrary.simpleMessage("إجمالي الصادر"),
    "viewAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
    "walletStatusActive": MessageLookupByLibrary.simpleMessage("نشط"),
    "welcome": MessageLookupByLibrary.simpleMessage("مرحباً بك"),
    "whatIsYourName": MessageLookupByLibrary.simpleMessage("ما اسمك؟"),
    "workspaces": MessageLookupByLibrary.simpleMessage("مساحات العمل"),
    "yourName": MessageLookupByLibrary.simpleMessage("اسمك"),
    "yourWallets": MessageLookupByLibrary.simpleMessage("محافظك"),
  };
}

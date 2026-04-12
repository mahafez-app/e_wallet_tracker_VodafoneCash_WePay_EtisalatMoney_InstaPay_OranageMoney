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

  static String m3(workspaceName) =>
      "تم انضمامك إلى مساحة العمل ${workspaceName} بنجاح.";

  static String m4(workspaceName) =>
      "سيتم حذف دعوتك للانضمام إلى مساحة العمل ${workspaceName}. يمكنك طلب إعادة إرسال الدعوة لاحقًا.";

  static String m5(workspaceName) =>
      "تم رفض دعوتك إلى مساحة العمل ${workspaceName}.";

  static String m6(name) => "دعوة من ${name}";

  static String m7(count) =>
      "${Intl.plural(count, zero: 'لا توجد دعوات بانتظار الرد', one: 'دعوة واحدة بانتظار الرد', two: 'دعوتان بانتظار الرد', few: '${count} دعوات بانتظار الرد', many: '${count} دعوة بانتظار الرد', other: '${count} دعوة بانتظار الرد')}";

  static String m8(minutes) => "منذ ${minutes} دقيقة";

  static String m9(amount) => "تم استلام ${amount} ج.م";

  static String m10(amount) => "تم إرسال ${amount} ج.م";

  static String m11(name) => "بواسطة ${name}";

  static String m12(status) => "تم التحديد كـ ${status}";

  static String m13(type) => "إيصال معاملة — ${type}";

  static String m14(name) => "معاملات ${name}";

  static String m15(name) => "معاملات ${name}";

  static String m16(count, total) => "عرض ${count} من أصل ${total} معاملة";

  static String m17(count) =>
      "${Intl.plural(count, zero: 'لا يوجد أعضاء', one: 'عضو واحد', two: 'عضوان', few: '${count} أعضاء', many: '${count} عضوًا', other: '${count} عضو')}";

  static String m18(email) => "سيتم حذف الدعوة المرسلة إلى ${email} فورًا.";

  static String m19(memberName) =>
      "سيتم حذف ${memberName} من مساحة العمل. يمكنك دعوته مرة أخرى لاحقًا.";

  static String m20(ownedCount, linkedCount) =>
      "أنت تملك ${ownedCount} محافظ، و${linkedCount} منها مرتبطة بالفعل بهذه المساحة.";

  static String m21(count) =>
      "${Intl.plural(count, zero: 'لا توجد محافظ', one: 'محفظة واحدة', two: 'محفظتان', few: '${count} محافظ', many: '${count} محفظة', other: '${count} محفظة')}";

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
    "addWorkspace": MessageLookupByLibrary.simpleMessage("إضافة مساحة عمل"),
    "allTransactions": MessageLookupByLibrary.simpleMessage("جميع المعاملات"),
    "allowAndContinue": MessageLookupByLibrary.simpleMessage("سماح ومتابعة"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("محافظ"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "إدارة محافظك الخاصة بالأعمال بسهولة",
    ),
    "chooseProvider": MessageLookupByLibrary.simpleMessage("اختر مزود الخدمة"),
    "commonCancelAction": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "commonDeleteAction": MessageLookupByLibrary.simpleMessage("حذف"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmName": MessageLookupByLibrary.simpleMessage("تأكيد الاسم"),
    "confirmNameMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى تأكيد اسمك للمتابعة",
    ),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "المتابعة باستخدام جوجل",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "createWorkspaceAction": MessageLookupByLibrary.simpleMessage(
      "إنشاء مساحة العمل",
    ),
    "createWorkspaceDescription": MessageLookupByLibrary.simpleMessage(
      "مساحات العمل تساعدك على تنظيم محافظ النشاط التجاري والتعاون مع الأعضاء الموثوقين من مكان واحد.",
    ),
    "createWorkspaceEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "اجمع محافظ النشاط، وتابع الحركة، وأضف فريقك داخل مساحة مشتركة واحدة.",
    ),
    "createWorkspaceEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "أنشئ أول مساحة عمل",
    ),
    "createWorkspacePreviewDescription": MessageLookupByLibrary.simpleMessage(
      "يمكنك إضافة المحافظ ودعوة الأعضاء بعد إنشاء مساحة العمل.",
    ),
    "createWorkspacePreviewFallback": MessageLookupByLibrary.simpleMessage(
      "مساحة عمل جديدة",
    ),
    "createWorkspacePreviewLabel": MessageLookupByLibrary.simpleMessage(
      "معاينة مساحة العمل",
    ),
    "createWorkspaceTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء مساحة عمل",
    ),
    "currency": MessageLookupByLibrary.simpleMessage("ج.م"),
    "currentBalance": MessageLookupByLibrary.simpleMessage("الرصيد الحالي"),
    "deleteWallet": MessageLookupByLibrary.simpleMessage("حذف المحفظة"),
    "deleteWalletConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من رغبتك في حذف هذه المحفظة؟ لا يمكنك التراجع عن هذا الإجراء.",
    ),
    "deleteWalletConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "حذف المحفظة",
    ),
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
    "errorInvitationAlreadyPending": MessageLookupByLibrary.simpleMessage(
      "توجد دعوة معلقة بالفعل لهذا البريد الإلكتروني.",
    ),
    "errorInvitationNotPending": MessageLookupByLibrary.simpleMessage(
      "هذه الدعوة لم تعد معلقة.",
    ),
    "errorInvitationSelfNotAllowed": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك دعوة نفسك إلى مساحة العمل.",
    ),
    "errorInvitationUserAlreadyMember": MessageLookupByLibrary.simpleMessage(
      "هذا المستخدم عضو بالفعل في مساحة العمل.",
    ),
    "errorInvitationUserNotFound": MessageLookupByLibrary.simpleMessage(
      "هذا البريد الإلكتروني غير مرتبط بأي حساب محافظ.",
    ),
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
    "errorWorkspaceMemberNotFound": MessageLookupByLibrary.simpleMessage(
      "هذا العضو غير موجود داخل مساحة العمل الآن.",
    ),
    "errorWorkspaceNameRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم مساحة العمل",
    ),
    "errorWorkspaceOwnerRemovalNotAllowed":
        MessageLookupByLibrary.simpleMessage("لا يمكن حذف مالك مساحة العمل."),
    "errorWorkspaceWalletSelectionRequired":
        MessageLookupByLibrary.simpleMessage(
          "يرجى اختيار محفظة واحدة على الأقل",
        ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "fromLabel": MessageLookupByLibrary.simpleMessage("من"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "fullNamePlaceholder": MessageLookupByLibrary.simpleMessage(
      "مثلاً: أحمد محمود",
    ),
    "fullNameValidationEmpty": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسمك",
    ),
    "invitationAcceptDetails": MessageLookupByLibrary.simpleMessage(
      "أصبح بإمكانك العمل داخل مساحة العمل الآن.",
    ),
    "invitationAcceptSuccess": m3,
    "invitationDeclineConfirmMessage": m4,
    "invitationDeclineConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "رفض الدعوة؟",
    ),
    "invitationDeclineSuccess": m5,
    "invitationSentBy": m6,
    "invitationSentSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الدعوة بنجاح.",
    ),
    "invitationsAcceptAction": MessageLookupByLibrary.simpleMessage("قبول"),
    "invitationsDeclineAction": MessageLookupByLibrary.simpleMessage("رفض"),
    "invitationsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "لا توجد لديك دعوات معلقة لمساحات العمل الآن.",
    ),
    "invitationsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد دعوات معلقة",
    ),
    "invitationsHowItWorksDescription": MessageLookupByLibrary.simpleMessage(
      "لا يمكن إرسال دعوة مساحة العمل إلا إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المرتبط بالحساب.",
    ),
    "invitationsHowItWorksTitle": MessageLookupByLibrary.simpleMessage(
      "كيف تعمل الدعوات",
    ),
    "invitationsListDescription": MessageLookupByLibrary.simpleMessage(
      "راجع دعوات مساحات العمل الواردة وحدد قرارك في الوقت المناسب.",
    ),
    "invitationsPendingCount": m7,
    "invitationsPendingStatus": MessageLookupByLibrary.simpleMessage(
      "بانتظار الرد",
    ),
    "invitationsRecentResponsesTitle": MessageLookupByLibrary.simpleMessage(
      "أحدث الردود",
    ),
    "invitationsRefreshAction": MessageLookupByLibrary.simpleMessage(
      "تحديث القائمة",
    ),
    "invitationsTitle": MessageLookupByLibrary.simpleMessage("الدعوات"),
    "inviteMemberDescription": MessageLookupByLibrary.simpleMessage(
      "أرسل دعوة إلى مساحة العمل عبر البريد الإلكتروني لحساب محافظ موجود بالفعل. سيجدها المستخدم المدعو في شاشة الدعوات.",
    ),
    "inviteMemberEmailHint": MessageLookupByLibrary.simpleMessage(
      "name@example.com",
    ),
    "inviteMemberEmailLabel": MessageLookupByLibrary.simpleMessage(
      "بريد العضو الإلكتروني",
    ),
    "inviteMemberSendAction": MessageLookupByLibrary.simpleMessage(
      "إرسال الدعوة",
    ),
    "inviteMemberTitle": MessageLookupByLibrary.simpleMessage("دعوة عضو"),
    "justNow": MessageLookupByLibrary.simpleMessage("الآن"),
    "lastActivity": MessageLookupByLibrary.simpleMessage("آخر نشاط"),
    "minutesAgo": m8,
    "nameWillBeDisplayed": MessageLookupByLibrary.simpleMessage(
      "سيظهر اسمك عند تحديث حالة الدفع لتسهيل تتبع العمليات المالية",
    ),
    "noTransactionsTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد معاملات حتى الآن، ستظهر هنا عند وصول رسائل جديدة",
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
    "paymentStatus": MessageLookupByLibrary.simpleMessage("حالة الدفع"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "providerEtisalat": MessageLookupByLibrary.simpleMessage("اتصالات كاش"),
    "providerInstapay": MessageLookupByLibrary.simpleMessage("إنستا باي"),
    "providerOrange": MessageLookupByLibrary.simpleMessage("أورانج كاش"),
    "providerUnknown": MessageLookupByLibrary.simpleMessage("محفظة"),
    "providerVodafone": MessageLookupByLibrary.simpleMessage("فودافون كاش"),
    "providerWePay": MessageLookupByLibrary.simpleMessage("وي باي"),
    "recentTransactions": MessageLookupByLibrary.simpleMessage("آخر المعاملات"),
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
      "يحتاج التطبيق إلى صلاحية الرسائل والهاتف لاكتشاف أرقام المحافظ على هذا الجهاز ومزامنة المعاملات تلقائياً.",
    ),
    "smsPermissionPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "نقرأ فقط الرسائل المالية وأرقام الهاتف اللازمة لإعداد المحافظ؛ بياناتك مشفرة ولا يتم مشاركتها أبدا.",
    ),
    "smsPermissionPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "خصوصية تامة",
    ),
    "smsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "السماح بالوصول إلى الرسائل والهاتف",
    ),
    "toLabel": MessageLookupByLibrary.simpleMessage("إلى"),
    "totalBalance": MessageLookupByLibrary.simpleMessage("إجمالي الرصيد"),
    "totalIn": MessageLookupByLibrary.simpleMessage("إجمالي الوارد"),
    "totalOut": MessageLookupByLibrary.simpleMessage("إجمالي الصادر"),
    "transactionDetails": MessageLookupByLibrary.simpleMessage(
      "تفاصيل المعاملة",
    ),
    "transactionMessageReceive": m9,
    "transactionMessageSend": m10,
    "transactionStatusPaid": MessageLookupByLibrary.simpleMessage("مدفوع"),
    "transactionStatusUnpaid": MessageLookupByLibrary.simpleMessage(
      "غير مدفوع",
    ),
    "transactionTypeReceive": MessageLookupByLibrary.simpleMessage("استلام"),
    "transactionTypeSend": MessageLookupByLibrary.simpleMessage("إرسال"),
    "transaction_addNote": MessageLookupByLibrary.simpleMessage("إضافة ملاحظة"),
    "transaction_amount": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "transaction_by": m11,
    "transaction_cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "transaction_date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "transaction_dateTime": MessageLookupByLibrary.simpleMessage(
      "التاريخ والوقت",
    ),
    "transaction_deleteAction": MessageLookupByLibrary.simpleMessage("حذف"),
    "transaction_deleteNoteMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.",
    ),
    "transaction_deleteNoteTitle": MessageLookupByLibrary.simpleMessage(
      "حذف الملاحظة",
    ),
    "transaction_edited": MessageLookupByLibrary.simpleMessage("تم التعديل"),
    "transaction_errorGeneric": MessageLookupByLibrary.simpleMessage("حدث خطأ"),
    "transaction_history": MessageLookupByLibrary.simpleMessage(
      "سجل التغييرات",
    ),
    "transaction_markedAs": m12,
    "transaction_noteDeleted": MessageLookupByLibrary.simpleMessage(
      "تم حذف الملاحظة",
    ),
    "transaction_noteHint": MessageLookupByLibrary.simpleMessage(
      "اكتب ملاحظتك هنا…",
    ),
    "transaction_notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "transaction_receiptHeader": m13,
    "transaction_receivedFrom": MessageLookupByLibrary.simpleMessage(
      "مُستلَم من",
    ),
    "transaction_referenceNumber": MessageLookupByLibrary.simpleMessage(
      "رقم العملية",
    ),
    "transaction_save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "transaction_sentTo": MessageLookupByLibrary.simpleMessage("مُرسَل إلى"),
    "transaction_shareReceipt": MessageLookupByLibrary.simpleMessage(
      "مشاركة إيصال العملية",
    ),
    "transaction_smsText": MessageLookupByLibrary.simpleMessage("نص الرسالة"),
    "transaction_typeReceiveLabel": MessageLookupByLibrary.simpleMessage(
      "معاملة استلام",
    ),
    "transaction_typeSendLabel": MessageLookupByLibrary.simpleMessage(
      "معاملة إرسال",
    ),
    "transaction_undo": MessageLookupByLibrary.simpleMessage("تراجع"),
    "transaction_wallet": MessageLookupByLibrary.simpleMessage("المحفظة"),
    "transactionsHistory": MessageLookupByLibrary.simpleMessage(
      "تاريخ المعاملات",
    ),
    "transactions_clearFilters": MessageLookupByLibrary.simpleMessage(
      "مسح الفلاتر",
    ),
    "transactions_date_customRange": MessageLookupByLibrary.simpleMessage(
      "نطاق مخصص",
    ),
    "transactions_date_month": MessageLookupByLibrary.simpleMessage("الشهر"),
    "transactions_date_today": MessageLookupByLibrary.simpleMessage("اليوم"),
    "transactions_date_week": MessageLookupByLibrary.simpleMessage("الأسبوع"),
    "transactions_date_yesterday": MessageLookupByLibrary.simpleMessage("أمس"),
    "transactions_emptyWithFilter": MessageLookupByLibrary.simpleMessage(
      "لا توجد معاملات تطابق الفلتر المحدد",
    ),
    "transactions_filter_all": MessageLookupByLibrary.simpleMessage("الكل"),
    "transactions_filter_allWallets": MessageLookupByLibrary.simpleMessage(
      "كل المحافظ",
    ),
    "transactions_loadMore": MessageLookupByLibrary.simpleMessage(
      "تحميل المزيد",
    ),
    "transactions_title_wallet": m14,
    "transactions_title_workspace": m15,
    "transactions_viewingCountOfTotal": m16,
    "viaLabel": MessageLookupByLibrary.simpleMessage("عبر"),
    "viewAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("تفاصيل المحفظة"),
    "walletLabel": MessageLookupByLibrary.simpleMessage("محفظتك"),
    "walletStatusActive": MessageLookupByLibrary.simpleMessage("نشط"),
    "walletTransactions": MessageLookupByLibrary.simpleMessage(
      "معاملات المحفظة",
    ),
    "welcome": MessageLookupByLibrary.simpleMessage("مرحباً بك"),
    "whatIsYourName": MessageLookupByLibrary.simpleMessage("ما اسمك؟"),
    "workspaceAddSelectedWalletsAction": MessageLookupByLibrary.simpleMessage(
      "إضافة المحافظ المحددة",
    ),
    "workspaceAddWalletsAction": MessageLookupByLibrary.simpleMessage(
      "إضافة محافظ",
    ),
    "workspaceAddWalletsCreateDescription": MessageLookupByLibrary.simpleMessage(
      "اختر المحافظ التي تريد إظهارها في مساحة العمل الآن. يمكنك إضافة المزيد لاحقًا.",
    ),
    "workspaceAddWalletsManageDescription": MessageLookupByLibrary.simpleMessage(
      "شارك محافظك الخاصة مع مساحة العمل. المحافظ المرتبطة تصبح مرئية لكل أعضاء مساحة العمل.",
    ),
    "workspaceAddWalletsTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة محافظ",
    ),
    "workspaceAllOwnedWalletsLinkedDescription":
        MessageLookupByLibrary.simpleMessage(
          "يمكنك المتابعة إلى مساحة العمل أو إضافة محفظة جديدة لاحقًا.",
        ),
    "workspaceAllOwnedWalletsLinkedTitle": MessageLookupByLibrary.simpleMessage(
      "كل محافظك مرتبطة بالفعل",
    ),
    "workspaceContinueToDetailsAction": MessageLookupByLibrary.simpleMessage(
      "المتابعة إلى مساحة العمل",
    ),
    "workspaceInviteMemberAction": MessageLookupByLibrary.simpleMessage(
      "دعوة عضو",
    ),
    "workspaceMembers": MessageLookupByLibrary.simpleMessage("الأعضاء"),
    "workspaceMembersCount": m17,
    "workspaceMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لم ينضم أي أعضاء إلى مساحة العمل بعد.",
    ),
    "workspaceNameHint": MessageLookupByLibrary.simpleMessage(
      "مثلاً: محل موبايلات",
    ),
    "workspaceNameLabel": MessageLookupByLibrary.simpleMessage(
      "اسم مساحة العمل",
    ),
    "workspaceNoOwnedWalletsDescription": MessageLookupByLibrary.simpleMessage(
      "أضف محفظة أولاً ثم يمكنك مشاركتها مع مساحة العمل.",
    ),
    "workspaceNoOwnedWalletsTitle": MessageLookupByLibrary.simpleMessage(
      "لا تملك أي محافظ بعد",
    ),
    "workspaceOwner": MessageLookupByLibrary.simpleMessage("المالك"),
    "workspaceOwnerBadge": MessageLookupByLibrary.simpleMessage("مالك"),
    "workspaceSettingsCancelInvitationAction":
        MessageLookupByLibrary.simpleMessage("إلغاء"),
    "workspaceSettingsCancelInvitationConfirmMessage": m18,
    "workspaceSettingsCancelInvitationConfirmTitle":
        MessageLookupByLibrary.simpleMessage("إلغاء الدعوة؟"),
    "workspaceSettingsDangerZone": MessageLookupByLibrary.simpleMessage(
      "منطقة الخطر",
    ),
    "workspaceSettingsDeleteWorkspaceAction":
        MessageLookupByLibrary.simpleMessage("حذف مساحة العمل"),
    "workspaceSettingsDeleteWorkspaceConfirmMessage":
        MessageLookupByLibrary.simpleMessage(
          "سيؤدي هذا إلى حذف مساحة العمل وأذونات الأعضاء وروابط المحافظ والدعوات المعلقة نهائيًا.",
        ),
    "workspaceSettingsDeleteWorkspaceConfirmTitle":
        MessageLookupByLibrary.simpleMessage("حذف مساحة العمل؟"),
    "workspaceSettingsDeleteWorkspaceDescription":
        MessageLookupByLibrary.simpleMessage(
          "سيتم حذف جميع البيانات المرتبطة وسجلات الوصول نهائيًا.",
        ),
    "workspaceSettingsEditNameAction": MessageLookupByLibrary.simpleMessage(
      "حفظ التعديلات",
    ),
    "workspaceSettingsEditNameDescription":
        MessageLookupByLibrary.simpleMessage(
          "حدّث الاسم الظاهر للمساحة في كل الشاشات المشتركة.",
        ),
    "workspaceSettingsEditNameTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل اسم المساحة",
    ),
    "workspaceSettingsInfoSection": MessageLookupByLibrary.simpleMessage(
      "معلومات المساحة",
    ),
    "workspaceSettingsInvitationCancelledSuccess":
        MessageLookupByLibrary.simpleMessage("تم إلغاء الدعوة بنجاح."),
    "workspaceSettingsInviteByEmailAction":
        MessageLookupByLibrary.simpleMessage("دعوة عضو"),
    "workspaceSettingsMemberRemovedSuccess":
        MessageLookupByLibrary.simpleMessage("تم حذف العضو بنجاح."),
    "workspaceSettingsNameUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث اسم مساحة العمل بنجاح.",
    ),
    "workspaceSettingsPendingInvitationsEmpty":
        MessageLookupByLibrary.simpleMessage(
          "لا توجد دعوات معلقة لهذه المساحة الآن.",
        ),
    "workspaceSettingsPendingInvitationsSection":
        MessageLookupByLibrary.simpleMessage("الدعوات المعلقة"),
    "workspaceSettingsRemoveMemberAction": MessageLookupByLibrary.simpleMessage(
      "حذف",
    ),
    "workspaceSettingsRemoveMemberConfirmMessage": m19,
    "workspaceSettingsRemoveMemberConfirmTitle":
        MessageLookupByLibrary.simpleMessage("حذف العضو؟"),
    "workspaceSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "إعدادات المساحة",
    ),
    "workspaceSkipWalletsAction": MessageLookupByLibrary.simpleMessage(
      "تخطي الآن",
    ),
    "workspaceWalletAlreadyAdded": MessageLookupByLibrary.simpleMessage(
      "مضافة بالفعل",
    ),
    "workspaceWalletAvailable": MessageLookupByLibrary.simpleMessage("متاحة"),
    "workspaceWalletSelected": MessageLookupByLibrary.simpleMessage("محددة"),
    "workspaceWalletSelectionSummary": m20,
    "workspaceWallets": MessageLookupByLibrary.simpleMessage("المحافظ"),
    "workspaceWalletsCount": m21,
    "workspaceWalletsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "ستظهر المحافظ المشتركة هنا بعد ربطها بمساحة العمل.",
    ),
    "workspaceWalletsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد محافظ مرتبطة بعد",
    ),
    "workspaces": MessageLookupByLibrary.simpleMessage("مساحات العمل"),
    "yourName": MessageLookupByLibrary.simpleMessage("اسمك"),
    "yourWallets": MessageLookupByLibrary.simpleMessage("محافظك"),
  };
}

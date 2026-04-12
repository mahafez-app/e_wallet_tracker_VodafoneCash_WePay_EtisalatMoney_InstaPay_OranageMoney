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

  static String m2(code) => "راجع البيانات المدخلة: ${code}";

  static String m3(workspaceName) =>
      "تم انضمامك إلى مساحة العمل ${workspaceName} بنجاح.";

  static String m4(workspaceName) =>
      "سيتم حذف الدعوة للانضمام إلى مساحة العمل ${workspaceName}. تقدر تطلب من مالك المساحة يبعتها لك مرة تانية لاحقاً.";

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

  static String m18(email) => "سيتم إلغاء الدعوة المرسلة إلى ${email} فوراً.";

  static String m19(memberName) =>
      "سيتم حذف ${memberName} من مساحة العمل. تقدر تبعت له دعوة مرة تانية لاحقاً.";

  static String m20(ownedCount, linkedCount) =>
      "عندك ${ownedCount} محافظ، و${linkedCount} منها مضافين بالفعل في مساحة العمل.";

  static String m21(count) =>
      "${Intl.plural(count, zero: 'لا توجد محافظ', one: 'محفظة واحدة', two: 'محفظتان', few: '${count} محافظ', many: '${count} محفظة', other: '${count} محفظة')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activeWalletsCount": m0,
    "activeWalletsHint": m1,
    "addWallet": MessageLookupByLibrary.simpleMessage("إضافة محفظة"),
    "addWalletAction": MessageLookupByLibrary.simpleMessage("أضف المحفظة"),
    "addWalletDescription": MessageLookupByLibrary.simpleMessage(
      "لازم تكون المحفظة دي موجودة على الموبايل ده، لأن التطبيق بيقرأ رسائل الـSMS الجديدة من هنا فقط.",
    ),
    "addWalletTitle": MessageLookupByLibrary.simpleMessage("إضافة محفظة"),
    "addWorkspace": MessageLookupByLibrary.simpleMessage("إضافة مساحة عمل"),
    "allTransactions": MessageLookupByLibrary.simpleMessage("جميع المعاملات"),
    "allowAndContinue": MessageLookupByLibrary.simpleMessage("اسمح وكمل"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("محافظ"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "تابع محافظ شغلك بسهولة ومن مكان واحد",
    ),
    "chooseProvider": MessageLookupByLibrary.simpleMessage("اختر الشركة"),
    "commonCancelAction": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "commonDeleteAction": MessageLookupByLibrary.simpleMessage("حذف"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmName": MessageLookupByLibrary.simpleMessage("تأكيد الاسم"),
    "confirmNameMessage": MessageLookupByLibrary.simpleMessage(
      "أكد اسمك عشان نكمل",
    ),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "كمل باستخدام جوجل",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "createWorkspaceAction": MessageLookupByLibrary.simpleMessage(
      "إنشاء مساحة العمل",
    ),
    "createWorkspaceDescription": MessageLookupByLibrary.simpleMessage(
      "مساحة العمل بتساعدك تجمع محافظ شغلك وتشاركها مع الناس الموثوق فيهم من مكان واحد.",
    ),
    "createWorkspaceEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "اجمع محافظ شغلك، تابع الحركة، وخلي فريقك يشتغل معاك من مكان واحد.",
    ),
    "createWorkspaceEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "ابدأ بأول مساحة عمل",
    ),
    "createWorkspacePreviewDescription": MessageLookupByLibrary.simpleMessage(
      "بعد إنشاء مساحة العمل، تقدر تضيف محافظ وتبعت دعوات للأعضاء.",
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
      "هل تريد حذف هذه المحفظة؟ لا يمكن التراجع بعد الحذف.",
    ),
    "deleteWalletConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "حذف المحفظة",
    ),
    "displayName": MessageLookupByLibrary.simpleMessage("الاسم"),
    "displayNameHint": MessageLookupByLibrary.simpleMessage("أدخل اسمك"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "egp": MessageLookupByLibrary.simpleMessage("ج.م"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailHint": MessageLookupByLibrary.simpleMessage("أدخل بريدك الإلكتروني"),
    "emailPlaceholder": MessageLookupByLibrary.simpleMessage(
      "example@email.com",
    ),
    "errorAuthEmailInUse": MessageLookupByLibrary.simpleMessage(
      "هذا البريد الإلكتروني مسجل بالفعل.",
    ),
    "errorAuthGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذر تسجيل الدخول الآن. حاول مرة تانية.",
    ),
    "errorAuthInvalidEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني غير صحيح.",
    ),
    "errorAuthTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "عدد المحاولات كبير جداً. حاول مرة تانية بعد شوية.",
    ),
    "errorAuthUserDisabled": MessageLookupByLibrary.simpleMessage(
      "تم تعطيل هذا الحساب.",
    ),
    "errorAuthUserNotFound": MessageLookupByLibrary.simpleMessage(
      "الحساب غير موجود. اتأكد من بيانات الدخول.",
    ),
    "errorAuthWeakPassword": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور ضعيفة. اختر كلمة مرور أقوى.",
    ),
    "errorAuthWrongPassword": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور غير صحيحة. حاول مرة تانية.",
    ),
    "errorCache": MessageLookupByLibrary.simpleMessage(
      "حصلت مشكلة في حفظ البيانات على الجهاز. حاول مرة تانية.",
    ),
    "errorConflict": MessageLookupByLibrary.simpleMessage(
      "في تعارض في البيانات. حاول مرة تانية.",
    ),
    "errorForbidden": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك تنفيذ هذا الإجراء.",
    ),
    "errorInvitationAlreadyPending": MessageLookupByLibrary.simpleMessage(
      "في دعوة معلقة بالفعل لهذا البريد الإلكتروني.",
    ),
    "errorInvitationNotPending": MessageLookupByLibrary.simpleMessage(
      "الدعوة دي لم تعد معلقة.",
    ),
    "errorInvitationSelfNotAllowed": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك دعوة نفسك إلى مساحة العمل.",
    ),
    "errorInvitationUserAlreadyMember": MessageLookupByLibrary.simpleMessage(
      "هذا المستخدم عضو بالفعل في مساحة العمل.",
    ),
    "errorInvitationUserNotFound": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني ده غير مرتبط بحساب محافظ.",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت. اتأكد من الشبكة وحاول مرة تانية.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("المطلوب غير موجود."),
    "errorPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "الصلاحية غير متاحة.",
    ),
    "errorServer": MessageLookupByLibrary.simpleMessage(
      "في مشكلة في الخدمة حالياً. حاول بعد شوية.",
    ),
    "errorServerGeneric": MessageLookupByLibrary.simpleMessage(
      "حصلت مشكلة. حاول مرة تانية.",
    ),
    "errorStorage": MessageLookupByLibrary.simpleMessage(
      "حصلت مشكلة في حفظ الملف.",
    ),
    "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "انتهت الجلسة. سجل دخولك مرة تانية.",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage(
      "حصلت مشكلة غير متوقعة.",
    ),
    "errorUnprocessable": MessageLookupByLibrary.simpleMessage(
      "تعذر تنفيذ طلبك. راجع البيانات وحاول تاني.",
    ),
    "errorValidation": MessageLookupByLibrary.simpleMessage(
      "راجع البيانات المدخلة.",
    ),
    "errorValidationWithCode": m2,
    "errorWalletAllExists": MessageLookupByLibrary.simpleMessage(
      "كل المحافظ المختارة مضافة بالفعل لهذا الرقم.",
    ),
    "errorWalletPhoneNumberRequired": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم الموبايل",
    ),
    "errorWalletProviderRequired": MessageLookupByLibrary.simpleMessage(
      "اختر شركة واحدة على الأقل",
    ),
    "errorWorkspaceMemberNotFound": MessageLookupByLibrary.simpleMessage(
      "العضو ده مش موجود في مساحة العمل حالياً.",
    ),
    "errorWorkspaceNameRequired": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم مساحة العمل",
    ),
    "errorWorkspaceOwnerRemovalNotAllowed":
        MessageLookupByLibrary.simpleMessage("لا يمكن حذف مالك مساحة العمل."),
    "errorWorkspaceWalletSelectionRequired":
        MessageLookupByLibrary.simpleMessage("اختر محفظة واحدة على الأقل"),
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
      "تقدر تبدأ الشغل داخل مساحة العمل الآن.",
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
      "لا توجد عندك دعوات معلقة حالياً.",
    ),
    "invitationsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد دعوات معلقة",
    ),
    "invitationsHowItWorksDescription": MessageLookupByLibrary.simpleMessage(
      "يمكن إرسال الدعوة فقط إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المسجل به.",
    ),
    "invitationsHowItWorksTitle": MessageLookupByLibrary.simpleMessage(
      "كيف تعمل الدعوات",
    ),
    "invitationsListDescription": MessageLookupByLibrary.simpleMessage(
      "راجع الدعوات اللي وصلتك واختر إذا كنت هتقبل أو ترفض.",
    ),
    "invitationsPendingCount": m7,
    "invitationsPendingStatus": MessageLookupByLibrary.simpleMessage(
      "بانتظارك",
    ),
    "invitationsRecentResponsesTitle": MessageLookupByLibrary.simpleMessage(
      "أحدث الردود",
    ),
    "invitationsRefreshAction": MessageLookupByLibrary.simpleMessage(
      "تحديث القائمة",
    ),
    "invitationsTitle": MessageLookupByLibrary.simpleMessage("الدعوات"),
    "inviteMemberDescription": MessageLookupByLibrary.simpleMessage(
      "ابعت دعوة لمساحة العمل على البريد الإلكتروني لحساب محافظ موجود بالفعل. الشخص المدعو هيلاقيها في شاشة الدعوات.",
    ),
    "inviteMemberEmailHint": MessageLookupByLibrary.simpleMessage(
      "name@example.com",
    ),
    "inviteMemberEmailLabel": MessageLookupByLibrary.simpleMessage(
      "بريد العضو",
    ),
    "inviteMemberSendAction": MessageLookupByLibrary.simpleMessage(
      "إرسال الدعوة",
    ),
    "inviteMemberTitle": MessageLookupByLibrary.simpleMessage("دعوة عضو"),
    "justNow": MessageLookupByLibrary.simpleMessage("الآن"),
    "lastActivity": MessageLookupByLibrary.simpleMessage("آخر نشاط"),
    "minutesAgo": m8,
    "nameWillBeDisplayed": MessageLookupByLibrary.simpleMessage(
      "الاسم ده هيظهر وقت تحديث حالة الدفع عشان متابعة العمليات تبقى أسهل.",
    ),
    "noTransactionsTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد معاملات حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا.",
    ),
    "notFoundPageTitle": MessageLookupByLibrary.simpleMessage(
      "الصفحة غير موجودة",
    ),
    "notFoundStatusCode": MessageLookupByLibrary.simpleMessage("404"),
    "notNow": MessageLookupByLibrary.simpleMessage("لاحقاً"),
    "or": MessageLookupByLibrary.simpleMessage("أو"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
    "passwordPlaceholder": MessageLookupByLibrary.simpleMessage("••••••••"),
    "paymentStatus": MessageLookupByLibrary.simpleMessage("حالة السداد"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الموبايل"),
    "providerEtisalat": MessageLookupByLibrary.simpleMessage("اتصالات كاش"),
    "providerInstapay": MessageLookupByLibrary.simpleMessage("إنستا باي"),
    "providerOrange": MessageLookupByLibrary.simpleMessage("أورانج كاش"),
    "providerUnknown": MessageLookupByLibrary.simpleMessage("محفظة أخرى"),
    "providerVodafone": MessageLookupByLibrary.simpleMessage("فودافون كاش"),
    "providerWePay": MessageLookupByLibrary.simpleMessage("وي باي"),
    "recentTransactions": MessageLookupByLibrary.simpleMessage("آخر المعاملات"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInWithEmail": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول بالبريد الإلكتروني",
    ),
    "signInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول بجوجل",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "signUpNow": MessageLookupByLibrary.simpleMessage("أنشئ حسابك"),
    "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
      "أنشئ حساب جديد وابدأ تتابع شغلك بسهولة",
    ),
    "smsPermissionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "أي حركة جديدة بتتسجل أول ما رسالة العملية توصل.",
    ),
    "smsPermissionAutoUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "تحديث تلقائي",
    ),
    "smsPermissionDescription": MessageLookupByLibrary.simpleMessage(
      "التطبيق محتاج صلاحية الرسائل والموبايل عشان يتعرف على أرقام المحافظ الموجودة على الجهاز ويضيف الحركات الجديدة تلقائياً.",
    ),
    "smsPermissionPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "بنقرأ فقط الرسائل الخاصة بالمعاملات وأرقام الموبايل اللازمة لإعداد المحافظ. بياناتك مشفرة ومش بنشاركها مع أي حد.",
    ),
    "smsPermissionPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "خصوصيتك محفوظة",
    ),
    "smsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "اسمح بالوصول للرسائل والموبايل",
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
      "سجل التعديلات",
    ),
    "transaction_markedAs": m12,
    "transaction_noteDeleted": MessageLookupByLibrary.simpleMessage(
      "تم حذف الملاحظة",
    ),
    "transaction_noteHint": MessageLookupByLibrary.simpleMessage(
      "اكتب ملاحظتك هنا",
    ),
    "transaction_notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "transaction_receiptHeader": m13,
    "transaction_receivedFrom": MessageLookupByLibrary.simpleMessage(
      "تم الاستلام من",
    ),
    "transaction_referenceNumber": MessageLookupByLibrary.simpleMessage(
      "رقم العملية",
    ),
    "transaction_save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "transaction_sentTo": MessageLookupByLibrary.simpleMessage(
      "تم الإرسال إلى",
    ),
    "transaction_shareReceipt": MessageLookupByLibrary.simpleMessage(
      "مشاركة إيصال العملية",
    ),
    "transaction_smsText": MessageLookupByLibrary.simpleMessage("نص الرسالة"),
    "transaction_typeReceiveLabel": MessageLookupByLibrary.simpleMessage(
      "عملية استلام",
    ),
    "transaction_typeSendLabel": MessageLookupByLibrary.simpleMessage(
      "عملية إرسال",
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
      "لا توجد معاملات مطابقة للفلاتر المحددة",
    ),
    "transactions_filter_all": MessageLookupByLibrary.simpleMessage("الكل"),
    "transactions_filter_allWallets": MessageLookupByLibrary.simpleMessage(
      "كل المحافظ",
    ),
    "transactions_loadMore": MessageLookupByLibrary.simpleMessage("عرض المزيد"),
    "transactions_title_wallet": m14,
    "transactions_title_workspace": m15,
    "transactions_viewingCountOfTotal": m16,
    "userSettingsAboutSection": MessageLookupByLibrary.simpleMessage(
      "عن التطبيق",
    ),
    "userSettingsAccountSection": MessageLookupByLibrary.simpleMessage(
      "الحساب",
    ),
    "userSettingsAppSection": MessageLookupByLibrary.simpleMessage("التطبيق"),
    "userSettingsAppVersionLabel": MessageLookupByLibrary.simpleMessage(
      "إصدار التطبيق",
    ),
    "userSettingsDeleteAccountAction": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "userSettingsDeleteAccountConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "هذا الإجراء حساس وقد يؤدي إلى حذف البيانات المرتبطة بحسابك نهائياً بعد تفعيله بالكامل.",
    ),
    "userSettingsDeleteAccountConfirmTitle":
        MessageLookupByLibrary.simpleMessage("حذف الحساب؟"),
    "userSettingsDeleteAccountUnavailableMessage":
        MessageLookupByLibrary.simpleMessage(
          "إخفاء الحساب فقط لا يكفي هنا، لأننا نحتاج أولاً إلى تنظيف المحافظ ومساحات العمل والدعوات المرتبطة به بشكل آمن. سنفعل هذا الإجراء بعد إضافة مسار حذف كامل للبيانات.",
        ),
    "userSettingsDeleteAccountUnavailableTitle":
        MessageLookupByLibrary.simpleMessage("حذف الحساب غير متاح حالياً"),
    "userSettingsEditNameAction": MessageLookupByLibrary.simpleMessage(
      "تعديل الاسم",
    ),
    "userSettingsEditNameDescription": MessageLookupByLibrary.simpleMessage(
      "غيّر الاسم الظاهر في التطبيق وسجل النشاط.",
    ),
    "userSettingsEditNameSaveAction": MessageLookupByLibrary.simpleMessage(
      "حفظ التعديلات",
    ),
    "userSettingsEditNameTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل الاسم",
    ),
    "userSettingsNameUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الاسم بنجاح.",
    ),
    "userSettingsNoEmailLabel": MessageLookupByLibrary.simpleMessage(
      "لا يوجد بريد إلكتروني مرتبط",
    ),
    "userSettingsOpenSystemSettingsAction":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "userSettingsSignOutAction": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج",
    ),
    "userSettingsSignOutConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم إنهاء جلستك الحالية على هذا الجهاز، ويمكنك تسجيل الدخول مرة أخرى في أي وقت.",
    ),
    "userSettingsSignOutConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج؟",
    ),
    "userSettingsSmsPermissionCheckingLabel":
        MessageLookupByLibrary.simpleMessage("جاري التحقق من حالة الإذن..."),
    "userSettingsSmsPermissionDisabledLabel":
        MessageLookupByLibrary.simpleMessage(
          "غير مفعّل، والتطبيق لن يعمل بدونه.",
        ),
    "userSettingsSmsPermissionEnabledLabel":
        MessageLookupByLibrary.simpleMessage("مفعّل"),
    "userSettingsSmsPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "إذن قراءة الرسائل",
    ),
    "userSettingsTitle": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "viaLabel": MessageLookupByLibrary.simpleMessage("عبر"),
    "viewAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("تفاصيل المحفظة"),
    "walletLabel": MessageLookupByLibrary.simpleMessage("محفظتك"),
    "walletStatusActive": MessageLookupByLibrary.simpleMessage("نشط"),
    "walletTransactions": MessageLookupByLibrary.simpleMessage(
      "معاملات المحفظة",
    ),
    "welcome": MessageLookupByLibrary.simpleMessage("أهلاً بيك"),
    "whatIsYourName": MessageLookupByLibrary.simpleMessage("اسمك إيه؟"),
    "workspaceAddSelectedWalletsAction": MessageLookupByLibrary.simpleMessage(
      "إضافة المحافظ المحددة",
    ),
    "workspaceAddWalletsAction": MessageLookupByLibrary.simpleMessage(
      "إضافة محافظ",
    ),
    "workspaceAddWalletsCreateDescription": MessageLookupByLibrary.simpleMessage(
      "اختر المحافظ التي تريد تظهر في مساحة العمل الآن. وتقدر تضيف المزيد لاحقاً.",
    ),
    "workspaceAddWalletsManageDescription": MessageLookupByLibrary.simpleMessage(
      "شارك محافظك مع مساحة العمل. أي محفظة تضيفها هنا هتظهر لكل أعضاء المساحة.",
    ),
    "workspaceAddWalletsTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة محافظ",
    ),
    "workspaceAllOwnedWalletsLinkedDescription":
        MessageLookupByLibrary.simpleMessage(
          "تقدر تدخل على مساحة العمل أو تضيف محفظة جديدة لاحقاً.",
        ),
    "workspaceAllOwnedWalletsLinkedTitle": MessageLookupByLibrary.simpleMessage(
      "كل محافظك مرتبطة بالفعل",
    ),
    "workspaceContinueToDetailsAction": MessageLookupByLibrary.simpleMessage(
      "ادخل على مساحة العمل",
    ),
    "workspaceInviteMemberAction": MessageLookupByLibrary.simpleMessage(
      "دعوة عضو",
    ),
    "workspaceMembers": MessageLookupByLibrary.simpleMessage("الأعضاء"),
    "workspaceMembersCount": m17,
    "workspaceMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء في مساحة العمل حتى الآن.",
    ),
    "workspaceNameHint": MessageLookupByLibrary.simpleMessage(
      "مثلاً: محل موبايلات",
    ),
    "workspaceNameLabel": MessageLookupByLibrary.simpleMessage(
      "اسم مساحة العمل",
    ),
    "workspaceNoOwnedWalletsDescription": MessageLookupByLibrary.simpleMessage(
      "أضف محفظة أولاً، وبعدها تقدر تشاركها مع مساحة العمل.",
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
      "إجراءات حساسة",
    ),
    "workspaceSettingsDeleteWorkspaceAction":
        MessageLookupByLibrary.simpleMessage("حذف مساحة العمل"),
    "workspaceSettingsDeleteWorkspaceConfirmMessage":
        MessageLookupByLibrary.simpleMessage(
          "سيتم حذف مساحة العمل وأذونات الأعضاء وربط المحافظ والدعوات المعلقة نهائياً.",
        ),
    "workspaceSettingsDeleteWorkspaceConfirmTitle":
        MessageLookupByLibrary.simpleMessage("حذف مساحة العمل؟"),
    "workspaceSettingsDeleteWorkspaceDescription":
        MessageLookupByLibrary.simpleMessage(
          "سيتم حذف كل البيانات المرتبطة بالمساحة نهائياً.",
        ),
    "workspaceSettingsEditNameAction": MessageLookupByLibrary.simpleMessage(
      "حفظ التعديلات",
    ),
    "workspaceSettingsEditNameDescription":
        MessageLookupByLibrary.simpleMessage(
          "غيّر الاسم الظاهر للمساحة في كل الشاشات المشتركة.",
        ),
    "workspaceSettingsEditNameTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل اسم المساحة",
    ),
    "workspaceSettingsInfoSection": MessageLookupByLibrary.simpleMessage(
      "بيانات المساحة",
    ),
    "workspaceSettingsInvitationCancelledSuccess":
        MessageLookupByLibrary.simpleMessage("تم إلغاء الدعوة."),
    "workspaceSettingsInviteByEmailAction":
        MessageLookupByLibrary.simpleMessage("دعوة عضو"),
    "workspaceSettingsMemberRemovedSuccess":
        MessageLookupByLibrary.simpleMessage("تم حذف العضو."),
    "workspaceSettingsNameUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تغيير اسم مساحة العمل.",
    ),
    "workspaceSettingsPendingInvitationsEmpty":
        MessageLookupByLibrary.simpleMessage(
          "لا توجد دعوات معلقة لهذه المساحة حالياً.",
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
      "تخطي حالياً",
    ),
    "workspaceWalletAlreadyAdded": MessageLookupByLibrary.simpleMessage(
      "مضافة",
    ),
    "workspaceWalletAvailable": MessageLookupByLibrary.simpleMessage("متاحة"),
    "workspaceWalletSelected": MessageLookupByLibrary.simpleMessage("محددة"),
    "workspaceWalletSelectionSummary": m20,
    "workspaceWallets": MessageLookupByLibrary.simpleMessage("المحافظ"),
    "workspaceWalletsCount": m21,
    "workspaceWalletsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "المحافظ المشتركة هتظهر هنا بعد ربطها بمساحة العمل.",
    ),
    "workspaceWalletsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد محافظ مرتبطة بعد",
    ),
    "workspaces": MessageLookupByLibrary.simpleMessage("مساحات العمل"),
    "yourName": MessageLookupByLibrary.simpleMessage("اسمك"),
    "yourWallets": MessageLookupByLibrary.simpleMessage("محافظك"),
  };
}

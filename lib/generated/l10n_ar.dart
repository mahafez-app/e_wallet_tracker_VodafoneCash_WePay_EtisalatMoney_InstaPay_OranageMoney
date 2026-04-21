// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت. اتأكد من الشبكة وحاول مرة تانية.';

  @override
  String get errorAuthUserNotFound => 'الحساب غير موجود. اتأكد من بيانات الدخول.';

  @override
  String get errorAuthWrongPassword => 'كلمة المرور غير صحيحة. حاول مرة تانية.';

  @override
  String get errorAuthEmailInUse => 'هذا البريد الإلكتروني مسجل بالفعل.';

  @override
  String get errorAuthTooManyRequests => 'عدد المحاولات كبير جداً. حاول مرة تانية بعد شوية.';

  @override
  String get errorAuthUserDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get errorAuthWeakPassword => 'كلمة المرور ضعيفة. اختر كلمة مرور أقوى.';

  @override
  String get errorAuthInvalidEmail => 'البريد الإلكتروني غير صحيح.';

  @override
  String get errorUnauthorized => 'انتهت الجلسة. سجل دخولك مرة تانية.';

  @override
  String get errorAuthGeneric => 'تعذر تسجيل الدخول الآن. حاول مرة تانية.';

  @override
  String get errorForbidden => 'لا يمكنك تنفيذ هذا الإجراء.';

  @override
  String get errorNotFound => 'المطلوب غير موجود.';

  @override
  String get errorConflict => 'في تعارض في البيانات. حاول مرة تانية.';

  @override
  String get errorUnprocessable => 'تعذر تنفيذ طلبك. راجع البيانات وحاول تاني.';

  @override
  String get errorServer => 'في مشكلة في الخدمة حالياً. حاول بعد شوية.';

  @override
  String get errorServerGeneric => 'حصلت مشكلة. حاول مرة تانية.';

  @override
  String get errorPermissionDenied => 'الصلاحية غير متاحة.';

  @override
  String get errorCache => 'حصلت مشكلة في حفظ البيانات على الجهاز. حاول مرة تانية.';

  @override
  String get errorStorage => 'حصلت مشكلة في حفظ الملف.';

  @override
  String get errorValidation => 'راجع البيانات المدخلة.';

  @override
  String errorValidationWithCode(String code) {
    return 'راجع البيانات المدخلة: $code';
  }

  @override
  String get errorUnknown => 'حصلت مشكلة غير متوقعة.';

  @override
  String get startupFallbackTitle => 'لحظة من فضلك';

  @override
  String get startupFallbackMessage => 'حاول فتح محافظ مرة أخرى.';

  @override
  String get startupFallbackRetryAction => 'حاول مرة أخرى';

  @override
  String get notFoundStatusCode => '404';

  @override
  String get notFoundPageTitle => 'الصفحة غير موجودة';

  @override
  String get appName => 'محافظ';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get displayName => 'الاسم';

  @override
  String get yourName => 'اسمك';

  @override
  String get confirm => 'تأكيد';

  @override
  String get signInWithGoogle => 'تسجيل الدخول بجوجل';

  @override
  String get signInWithEmail => 'تسجيل الدخول بالبريد الإلكتروني';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get displayNameHint => 'أدخل اسمك';

  @override
  String get confirmName => 'تأكيد الاسم';

  @override
  String get confirmNameMessage => 'أكد اسمك عشان نكمل';

  @override
  String get or => 'أو';

  @override
  String get appTagline => 'تابع محافظ شغلك بسهولة ومن مكان واحد';

  @override
  String get continueWithGoogle => 'كمل باستخدام جوجل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signUpNow => 'أنشئ حسابك';

  @override
  String get emailPlaceholder => 'example@email.com';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNamePlaceholder => 'مثلاً: أحمد محمود';

  @override
  String get signUpSubtitle => 'أنشئ حساب جديد وابدأ تتابع شغلك بسهولة';

  @override
  String get whatIsYourName => 'اسمك إيه؟';

  @override
  String get nameWillBeDisplayed => 'الاسم ده هيظهر وقت تحديث حالة الدفع عشان متابعة العمليات تبقى أسهل.';

  @override
  String get welcome => 'أهلاً بيك';

  @override
  String get totalBalance => 'إجمالي الرصيد';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get currency => 'ج.م';

  @override
  String get totalOut => 'إجمالي الصادر';

  @override
  String get totalIn => 'إجمالي الوارد';

  @override
  String get yourWallets => 'محافظك';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get workspaces => 'مساحات العمل';

  @override
  String get addWorkspace => 'إضافة مساحة عمل';

  @override
  String get addWallet => 'إضافة محفظة';

  @override
  String get walletStatusActive => 'نشط';

  @override
  String activeWalletsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count محفظة نشطة',
      many: '$count محفظة نشطة',
      few: '$count محافظ نشطة',
      two: 'محفظتان نشطتان',
      one: 'محفظة واحدة نشطة',
      zero: 'لا توجد محافظ نشطة',
    );
    return '$_temp0';
  }

  @override
  String activeWalletsHint(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إجمالي الرصيد لـ $count من محافظك',
      many: 'إجمالي الرصيد لـ $count من محافظك',
      few: 'إجمالي الرصيد لـ $count من محافظك',
      two: 'إجمالي الرصيد لمحفظتيك',
      one: 'إجمالي الرصيد لمحفظتك',
      zero: 'لم تقم بإضافة أي محافظ بعد',
    );
    return '$_temp0';
  }

  @override
  String get lastActivity => 'آخر نشاط';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String get egp => 'ج.م';

  @override
  String get addWalletTitle => 'إضافة محفظة';

  @override
  String get addWalletDescription => 'لازم تكون المحفظة دي موجودة على الموبايل ده، لأن التطبيق بيقرأ رسائل الـSMS الجديدة من هنا فقط.';

  @override
  String get phoneNumber => 'رقم الموبايل';

  @override
  String get chooseProvider => 'اختر الشركة';

  @override
  String get allowAndContinue => 'اسمح وكمل';

  @override
  String get notNow => 'لاحقاً';

  @override
  String get providerOrange => 'أورانج كاش';

  @override
  String get providerVodafone => 'فودافون كاش';

  @override
  String get providerInstapay => 'إنستا باي';

  @override
  String get providerEtisalat => 'اتصالات كاش';

  @override
  String get providerWePay => 'وي باي';

  @override
  String get providerUnknown => 'محفظة أخرى';

  @override
  String get smsPermissionTitle => 'اسمح بالوصول للرسائل والموبايل';

  @override
  String get smsPermissionDescription => 'التطبيق محتاج صلاحية الرسائل والموبايل عشان يتعرف على أرقام المحافظ الموجودة على الجهاز ويضيف الحركات الجديدة تلقائياً.';

  @override
  String get smsPermissionAutoUpdateTitle => 'تحديث تلقائي';

  @override
  String get smsPermissionAutoUpdateDesc => 'أي حركة جديدة بتتسجل أول ما رسالة العملية توصل.';

  @override
  String get smsPermissionPrivacyTitle => 'خصوصيتك محفوظة';

  @override
  String get smsPermissionPrivacyDesc => 'بنقرأ فقط الرسائل الخاصة بالمعاملات وأرقام الموبايل اللازمة لإعداد المحافظ. بياناتك مشفرة ومش بنشاركها مع أي حد.';

  @override
  String get smsPermissionXiaomiTitle => 'تم اكتشاف جهاز Xiaomi/Redmi';

  @override
  String get smsPermissionXiaomiDescription => 'عشان المعاملات توصلك والتطبيق مقفول، لازم تفعل خاصية \'التشغيل التلقائي\' وتخلي موفر البطارية \'بدون قيود\' في إعدادات النظام.';

  @override
  String get smsPermissionXiaomiAction => 'ضبط الإعدادات';

  @override
  String get smsPermissionBatteryOptimizationTitle => 'تحسين البطارية نشط';

  @override
  String get smsPermissionBatteryOptimizationDescription => 'نظام أندرويد ممكن يقفل التطبيق في الخلفية لتوفير الطاقة. عشان نضمن دقة التسجيل، يفضل تسمح للتطبيق بالشغل بدون قيود البطارية.';

  @override
  String get smsPermissionBatteryOptimizationAction => 'السماح بالعمل في الخلفية';

  @override
  String get addWalletAction => 'أضف المحفظة';

  @override
  String get createWorkspaceTitle => 'إنشاء مساحة عمل';

  @override
  String get createWorkspaceDescription => 'مساحة العمل بتساعدك تجمع محافظ شغلك وتشاركها مع الناس الموثوق فيهم من مكان واحد.';

  @override
  String get workspaceNameLabel => 'اسم مساحة العمل';

  @override
  String get workspaceNameHint => 'مثلاً: محل موبايلات';

  @override
  String get createWorkspacePreviewLabel => 'معاينة مساحة العمل';

  @override
  String get createWorkspacePreviewFallback => 'مساحة عمل جديدة';

  @override
  String get createWorkspacePreviewDescription => 'بعد إنشاء مساحة العمل، تقدر تضيف محافظ وتبعت دعوات للأعضاء.';

  @override
  String get workspaceOwner => 'المالك';

  @override
  String get workspaceOwnerBadge => 'مالك';

  @override
  String workspaceMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عضو',
      many: '$count عضوًا',
      few: '$count أعضاء',
      two: 'عضوان',
      one: 'عضو واحد',
      zero: 'لا يوجد أعضاء',
    );
    return '$_temp0';
  }

  @override
  String workspaceWalletsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count محفظة',
      many: '$count محفظة',
      few: '$count محافظ',
      two: 'محفظتان',
      one: 'محفظة واحدة',
      zero: 'لا توجد محافظ',
    );
    return '$_temp0';
  }

  @override
  String get createWorkspaceAction => 'إنشاء مساحة العمل';

  @override
  String get createWorkspaceEmptyTitle => 'ابدأ بأول مساحة عمل';

  @override
  String get createWorkspaceEmptyDescription => 'اجمع محافظ شغلك، تابع الحركة، وخلي فريقك يشتغل معاك من مكان واحد.';

  @override
  String get createWalletEmptyTitle => 'أضف أول محفظة';

  @override
  String get createWalletEmptyDescription => 'اربط محفظة موجودة على هذا الجهاز علشان تبدأ تتابع الرصيد والمعاملات تلقائياً.';

  @override
  String get workspaceWallets => 'المحافظ';

  @override
  String get workspaceMembers => 'الأعضاء';

  @override
  String get workspaceInviteMemberAction => 'دعوة عضو';

  @override
  String get workspaceSettingsTitle => 'إعدادات المساحة';

  @override
  String get workspaceSettingsInfoSection => 'بيانات المساحة';

  @override
  String get workspaceSettingsInviteByEmailAction => 'دعوة عضو';

  @override
  String get workspaceSettingsPendingInvitationsSection => 'الدعوات المعلقة';

  @override
  String get workspaceSettingsPendingInvitationsEmpty => 'لا توجد دعوات معلقة لهذه المساحة حالياً.';

  @override
  String get workspaceSettingsAccessSection => 'وصولك للمساحة';

  @override
  String get workspaceSettingsMemberDescription => 'راجع الأعضاء والمحافظ المرتبطة، واحذف محافظك عند الحاجة أو غادر المساحة.';

  @override
  String get workspaceSettingsManageAccessAction => 'إدارة الوصول';

  @override
  String get workspaceSettingsWalletsOwnerDescription => 'راجع كل المحافظ المرتبطة بهذه المساحة، واحذف أي محفظة لا يجب أن تبقى مشتركة.';

  @override
  String get workspaceSettingsWalletsMemberDescription => 'تقدر تشوف كل المحافظ المرتبطة هنا، لكن تحذف فقط المحافظ التي أضفتها أنت.';

  @override
  String get workspaceSettingsWalletsEmptyOwner => 'لا توجد محافظ مرتبطة بهذه المساحة حتى الآن.';

  @override
  String get workspaceSettingsWalletsEmptyMember => 'لا توجد محافظ مرتبطة بهذه المساحة حتى الآن.';

  @override
  String workspaceSettingsWalletOwner(Object ownerName) {
    return 'المالك: $ownerName';
  }

  @override
  String get workspaceUnknownMember => 'عضو غير معروف';

  @override
  String get workspaceSettingsWalletReadOnlyTooltip => 'فقط مالك المحفظة يمكنه حذفها';

  @override
  String get workspaceSettingsDangerZone => 'إجراءات حساسة';

  @override
  String get workspaceSettingsEditNameTitle => 'تعديل اسم المساحة';

  @override
  String get workspaceSettingsEditNameDescription => 'غيّر الاسم الظاهر للمساحة في كل الشاشات المشتركة.';

  @override
  String get workspaceSettingsEditNameAction => 'حفظ التعديلات';

  @override
  String get workspaceSettingsRemoveMemberAction => 'حذف';

  @override
  String get workspaceSettingsRemoveWalletAction => 'إلغاء ربط المحفظة';

  @override
  String get workspaceSettingsCancelInvitationAction => 'إلغاء';

  @override
  String get workspaceSettingsLeaveWorkspaceAction => 'مغادرة المساحة';

  @override
  String get workspaceSettingsLeaveWorkspaceDescription => 'سيتم حذف عضويتك والمحافظ التي ربطتها بهذه المساحة.';

  @override
  String get workspaceSettingsDeleteWorkspaceAction => 'حذف مساحة العمل';

  @override
  String get workspaceSettingsDeleteWorkspaceDescription => 'سيتم حذف كل البيانات المرتبطة بالمساحة نهائياً.';

  @override
  String get workspaceSettingsNameUpdatedSuccess => 'تم تغيير اسم مساحة العمل.';

  @override
  String get workspaceSettingsMemberRemovedSuccess => 'تم حذف العضو.';

  @override
  String get workspaceSettingsWalletRemovedSuccess => 'تم إلغاء ربط المحفظة من مساحة العمل بنجاح.';

  @override
  String get workspaceSettingsInvitationCancelledSuccess => 'تم إلغاء الدعوة.';

  @override
  String get workspaceSettingsRemoveMemberConfirmTitle => 'حذف العضو؟';

  @override
  String workspaceSettingsRemoveMemberConfirmMessage(Object memberName) {
    return 'سيتم حذف $memberName من مساحة العمل، وسيتم أيضاً حذف أي محافظ ربطها بهذه المساحة. تقدر تبعت له دعوة مرة تانية لاحقاً.';
  }

  @override
  String get workspaceSettingsRemoveWalletConfirmTitle => 'إلغاء ربط المحفظة؟';

  @override
  String workspaceSettingsRemoveWalletConfirmMessage(Object providerName, Object phoneNumber) {
    return 'سيتم إلغاء ربط محفظة $providerName المرتبطة بالرقم $phoneNumber من مساحة العمل دي. المحفظة وباقي بياناتها مش هيتم حذفهم.';
  }

  @override
  String get workspaceSettingsCancelInvitationConfirmTitle => 'إلغاء الدعوة؟';

  @override
  String workspaceSettingsCancelInvitationConfirmMessage(Object email) {
    return 'سيتم إلغاء الدعوة المرسلة إلى $email فوراً.';
  }

  @override
  String get workspaceSettingsLeaveWorkspaceConfirmTitle => 'مغادرة مساحة العمل؟';

  @override
  String get workspaceSettingsLeaveWorkspaceConfirmMessage => 'ستفقد الوصول إلى هذه المساحة، وسيتم حذف المحافظ التي ربطتها بها.';

  @override
  String get workspaceSettingsDeleteWorkspaceConfirmTitle => 'حذف مساحة العمل؟';

  @override
  String get workspaceSettingsDeleteWorkspaceConfirmMessage => 'سيتم حذف مساحة العمل وأذونات الأعضاء وربط المحافظ والدعوات المعلقة نهائياً.';

  @override
  String get workspaceUnavailableTitle => 'مساحة العمل لم تعد متاحة';

  @override
  String get workspaceUnavailableMessage => 'يبدو أن مساحة العمل دي تم حذفها أو تم إلغاء وصولك لها. هنرجعك للرئيسية.';

  @override
  String get workspaceUnavailableAction => 'العودة للرئيسية';

  @override
  String get userSettingsTitle => 'الإعدادات';

  @override
  String get userSettingsAppSection => 'التطبيق';

  @override
  String get userSettingsBackgroundSection => 'استقرار العمل في الخلفية';

  @override
  String get userSettingsAccountSection => 'الحساب';

  @override
  String get userSettingsAboutSection => 'عن التطبيق';

  @override
  String get userSettingsNoEmailLabel => 'لا يوجد بريد إلكتروني مرتبط';

  @override
  String get userSettingsEditNameAction => 'تعديل الاسم';

  @override
  String get userSettingsEditNameTitle => 'تعديل الاسم';

  @override
  String get userSettingsEditNameDescription => 'غيّر الاسم الظاهر في التطبيق وسجل النشاط.';

  @override
  String get userSettingsEditNameSaveAction => 'حفظ التعديلات';

  @override
  String get userSettingsNameUpdatedSuccess => 'تم تحديث الاسم بنجاح.';

  @override
  String get userSettingsThemeTitle => 'المظهر';

  @override
  String get userSettingsThemeSystemOption => 'تلقائي حسب الجهاز';

  @override
  String get userSettingsThemeLightOption => 'فاتح';

  @override
  String get userSettingsThemeDarkOption => 'داكن';

  @override
  String get userSettingsLanguageTitle => 'اللغة';

  @override
  String get userSettingsLanguageSystemOption => 'لغة الجهاز';

  @override
  String get userSettingsLanguageEnglishOption => 'English';

  @override
  String get userSettingsLanguageArabicOption => 'العربية';

  @override
  String get userSettingsFontSizeTitle => 'حجم الخط';

  @override
  String get userSettingsFontSizeDescription => 'تحكم في مقياس القراءة المستخدم في التطبيق كله.';

  @override
  String get userSettingsFontSizeSaveAction => 'تطبيق';

  @override
  String get userSettingsFontSizePreviewTitle => 'معاينة';

  @override
  String get userSettingsFontSizePreviewBody => 'استخدم شريط التمرير لتصغير أو تكبير النص في محافظ كله.';

  @override
  String userSettingsFontSizeCurrentValue(String value) {
    return 'الحجم الحالي في التطبيق: $value';
  }

  @override
  String get userSettingsFontSizeSmallLabel => 'أصغر';

  @override
  String get userSettingsFontSizeLargeLabel => 'أكبر';

  @override
  String get userSettingsSmsPermissionTitle => 'إذن قراءة الرسائل';

  @override
  String get userSettingsSmsPermissionCheckingLabel => 'جاري التحقق من حالة الإذن...';

  @override
  String get userSettingsSmsPermissionEnabledLabel => 'مفعّل';

  @override
  String get userSettingsSmsPermissionDisabledLabel => 'غير مفعّل، والتطبيق لن يعمل بدونه.';

  @override
  String get userSettingsOpenSystemSettingsAction => 'فتح الإعدادات';

  @override
  String get userSettingsSignOutAction => 'تسجيل الخروج';

  @override
  String get userSettingsSignOutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get userSettingsSignOutConfirmMessage => 'سيتم إنهاء جلستك الحالية على هذا الجهاز، ويمكنك تسجيل الدخول مرة أخرى في أي وقت.';

  @override
  String get userSettingsDeleteAccountAction => 'حذف الحساب';

  @override
  String get userSettingsDeleteAccountConfirmTitle => 'حذف الحساب؟';

  @override
  String get userSettingsDeleteAccountConfirmMessage => 'هذا الإجراء حساس وقد يؤدي إلى حذف البيانات المرتبطة بحسابك نهائياً بعد تفعيله بالكامل.';

  @override
  String get userSettingsDeleteAccountUnavailableTitle => 'حذف الحساب غير متاح حالياً';

  @override
  String get userSettingsDeleteAccountUnavailableMessage => 'إخفاء الحساب فقط لا يكفي هنا، لأننا نحتاج أولاً إلى تنظيف المحافظ ومساحات العمل والدعوات المرتبطة به بشكل آمن. سنفعل هذا الإجراء بعد إضافة مسار حذف كامل للبيانات.';

  @override
  String get userSettingsAppVersionLabel => 'إصدار التطبيق';

  @override
  String get userSettingsWalletsSection => 'محافظك';

  @override
  String get userSettingsWalletsDescription => 'إدارة المحافظ اللي أضفتها لمحافظ. حذف المحفظة هيشيلها هي وكل معاملاتها نهائياً من كل مساحات العمل.';

  @override
  String get userSettingsDeleteWalletAction => 'حذف المحفظة';

  @override
  String get userSettingsDeleteWalletConfirmTitle => 'حذف المحفظة؟';

  @override
  String userSettingsDeleteWalletConfirmMessage(Object phoneNumber, Object providerName) {
    return 'هل أنت متأكد أنك عايز تحذف محفظة $providerName ($phoneNumber)؟ ده هيحذف كل معاملاتها وملاحظاتها نهائياً، وهيلغي ربطها من كل مساحات العمل. الإجراء ده لا يمكن التراجع عنه.';
  }

  @override
  String get userSettingsWalletDeletedSuccess => 'تم حذف المحفظة بنجاح.';

  @override
  String get commonDeleteAction => 'حذف';

  @override
  String get commonCancelAction => 'إلغاء';

  @override
  String get workspaceAddWalletsTitle => 'إضافة محافظ';

  @override
  String get workspaceAddWalletsAction => 'إضافة محافظ';

  @override
  String get workspaceAddWalletsCreateDescription => 'اختر المحافظ التي تريد تظهر في مساحة العمل الآن. وتقدر تضيف المزيد لاحقاً.';

  @override
  String get workspaceAddWalletsManageDescription => 'شارك محافظك مع مساحة العمل. أي محفظة تضيفها هنا هتظهر لكل أعضاء المساحة.';

  @override
  String get workspaceAddSelectedWalletsAction => 'إضافة المحافظ المحددة';

  @override
  String get workspaceContinueToDetailsAction => 'ادخل على مساحة العمل';

  @override
  String get workspaceSkipWalletsAction => 'تخطي حالياً';

  @override
  String get workspaceWalletAvailable => 'متاحة';

  @override
  String get workspaceWalletSelected => 'محددة';

  @override
  String get workspaceWalletAlreadyAdded => 'مضافة';

  @override
  String get workspaceNoOwnedWalletsTitle => 'لا تملك أي محافظ بعد';

  @override
  String get workspaceNoOwnedWalletsDescription => 'أضف محفظة أولاً، وبعدها تقدر تشاركها مع مساحة العمل.';

  @override
  String get workspaceAllOwnedWalletsLinkedTitle => 'كل محافظك مرتبطة بالفعل';

  @override
  String get workspaceAllOwnedWalletsLinkedDescription => 'تقدر تدخل على مساحة العمل أو تضيف محفظة جديدة لاحقاً.';

  @override
  String workspaceWalletSelectionSummary(int ownedCount, int linkedCount) {
    return 'عندك $ownedCount محافظ، و$linkedCount منها مضافين بالفعل في مساحة العمل.';
  }

  @override
  String get workspaceWalletsEmptyTitle => 'لا توجد محافظ مرتبطة بعد';

  @override
  String get workspaceWalletsEmptyDescription => 'المحافظ المشتركة هتظهر هنا بعد ربطها بمساحة العمل.';

  @override
  String get workspaceMembersEmpty => 'لا يوجد أعضاء في مساحة العمل حتى الآن.';

  @override
  String get invitationsTitle => 'الدعوات';

  @override
  String get invitationsEmptyTitle => 'لا توجد دعوات معلقة';

  @override
  String get invitationsEmptyDescription => 'لا توجد عندك دعوات معلقة حالياً.';

  @override
  String get invitationsListDescription => 'راجع الدعوات اللي وصلتك واختر إذا كنت هتقبل أو ترفض.';

  @override
  String invitationsPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دعوة بانتظار الرد',
      many: '$count دعوة بانتظار الرد',
      few: '$count دعوات بانتظار الرد',
      two: 'دعوتان بانتظار الرد',
      one: 'دعوة واحدة بانتظار الرد',
      zero: 'لا توجد دعوات بانتظار الرد',
    );
    return '$_temp0';
  }

  @override
  String get invitationsPendingStatus => 'معلقة';

  @override
  String get invitationsDeletedWorkspaceFallback => 'مساحة عمل محذوفة';

  @override
  String get invitationsUnknownInviterFallback => 'مرسل غير معروف';

  @override
  String get invitationsAcceptAction => 'قبول';

  @override
  String get invitationsDeclineAction => 'رفض';

  @override
  String get invitationsRefreshAction => 'تحديث القائمة';

  @override
  String get invitationsHowItWorksTitle => 'كيف تعمل الدعوات';

  @override
  String get invitationsHowItWorksDescription => 'يمكن إرسال الدعوة فقط إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المسجل به.';

  @override
  String get invitationsRecentResponsesTitle => 'أحدث الردود';

  @override
  String invitationSentBy(Object name) {
    return 'دعوة من $name';
  }

  @override
  String invitationAcceptSuccess(Object workspaceName) {
    return 'تم انضمامك إلى مساحة العمل $workspaceName بنجاح.';
  }

  @override
  String get invitationAcceptDetails => 'تقدر تبدأ الشغل داخل مساحة العمل الآن.';

  @override
  String invitationDeclineSuccess(Object workspaceName) {
    return 'تم رفض دعوتك إلى مساحة العمل $workspaceName.';
  }

  @override
  String get invitationDeclineConfirmTitle => 'رفض الدعوة؟';

  @override
  String invitationDeclineConfirmMessage(Object workspaceName) {
    return 'سيتم حذف الدعوة للانضمام إلى مساحة العمل $workspaceName. تقدر تطلب من مالك المساحة يبعتها لك مرة تانية لاحقاً.';
  }

  @override
  String get invitationSentSuccess => 'تم إرسال الدعوة بنجاح.';

  @override
  String get inviteMemberTitle => 'دعوة عضو';

  @override
  String get inviteMemberDescription => 'ابعت دعوة لمساحة العمل على البريد الإلكتروني لحساب محافظ موجود بالفعل. الشخص المدعو هيلاقيها في شاشة الدعوات.';

  @override
  String get inviteMemberEmailLabel => 'بريد العضو';

  @override
  String get inviteMemberEmailHint => 'name@example.com';

  @override
  String get inviteMemberSendAction => 'إرسال الدعوة';

  @override
  String get errorWalletPhoneNumberRequired => 'أدخل رقم الموبايل';

  @override
  String get errorWalletPhoneNumberInvalid => 'أدخل رقم موبايل مصري صحيح.';

  @override
  String get errorWalletProviderRequired => 'اختر شركة واحدة على الأقل';

  @override
  String get errorWalletProviderMismatch => 'رقم الموبايل ده يدعم فقط شركة المحفظة المطابقة له وإنستاباي.';

  @override
  String get errorWalletAlreadyExists => 'هذه المحفظة مضافة بالفعل.';

  @override
  String get errorWalletAllExists => 'كل المحافظ المختارة مضافة بالفعل لهذا الرقم.';

  @override
  String get errorManualTransactionMessageRequired => 'الصق نص الرسالة أولاً.';

  @override
  String get errorManualTransactionUnrecognized => 'هذا النص لا يطابق صيغة رسائل هذه المحفظة.';

  @override
  String get errorManualTransactionWalletMismatch => 'الرسالة تشير إلى محفظة مختلفة عن المحفظة المفتوحة حالياً.';

  @override
  String get errorWorkspaceNameRequired => 'أدخل اسم مساحة العمل';

  @override
  String get errorWorkspaceWalletSelectionRequired => 'اختر محفظة واحدة على الأقل';

  @override
  String get errorWorkspaceOwnerRemovalNotAllowed => 'لا يمكن حذف مالك مساحة العمل.';

  @override
  String get errorWorkspaceMemberNotFound => 'العضو ده مش موجود في مساحة العمل حالياً.';

  @override
  String get errorInvitationSelfNotAllowed => 'لا يمكنك دعوة نفسك إلى مساحة العمل.';

  @override
  String get errorInvitationAlreadyPending => 'في دعوة معلقة بالفعل لهذا البريد الإلكتروني.';

  @override
  String get errorInvitationUserNotFound => 'البريد الإلكتروني ده غير مرتبط بحساب محافظ.';

  @override
  String get errorInvitationUserAlreadyMember => 'هذا المستخدم عضو بالفعل في مساحة العمل.';

  @override
  String get errorInvitationNotPending => 'الدعوة دي لم تعد معلقة.';

  @override
  String get transactionTypeReceive => 'استلام';

  @override
  String get transactionTypeSend => 'إرسال';

  @override
  String get reportSummaryReceivedTransactionsTitle => 'المعاملات المستلمة';

  @override
  String get reportSummaryReceivedTransactionsDescription => 'عدد المعاملات التي تم استلامها خلال هذه الفترة.';

  @override
  String get reportSummarySentTransactionsTitle => 'المعاملات المرسلة';

  @override
  String get reportSummarySentTransactionsDescription => 'عدد المعاملات التي تم إرسالها خلال هذه الفترة.';

  @override
  String get transactionStatusPaid => 'مدفوع';

  @override
  String get transactionStatusUnpaid => 'غير مدفوع';

  @override
  String get recentTransactions => 'آخر المعاملات';

  @override
  String get transactions_emptyTitle => 'لا توجد معاملات بعد';

  @override
  String get transactions_emptyWalletDescription => 'لا توجد معاملات على هذه المحفظة حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا تلقائياً.';

  @override
  String get transactions_emptyWorkspaceDescription => 'لا توجد معاملات داخل مساحة العمل دي حتى الآن. أي نشاط من المحافظ المرتبطة هيظهر هنا تلقائياً.';

  @override
  String get workspaceTransactionsCtaDescription => 'افتح كل معاملات مساحة العمل دي علشان تشوف كل معاملات المحافظ المرتبطة في مكان واحد.';

  @override
  String get workspaceTransactionsCtaDescriptionWithActivity => 'افتح كل معاملات مساحة العمل دي علشان تشوف كل معاملات المحافظ المرتبطة في مكان واحد.';

  @override
  String get transactions_emptyHintTitle => 'متابعة تلقائية';

  @override
  String get transactions_emptyHintDescription => 'أول ما نرصد نشاط على محفظة مرتبطة، هنضيفه هنا تلقائياً.';

  @override
  String get noTransactionsTitle => 'لا توجد معاملات حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا.';

  @override
  String get deleteWallet => 'حذف المحفظة';

  @override
  String get deleteWalletConfirmTitle => 'حذف المحفظة';

  @override
  String get deleteWalletConfirmMessage => 'هل تريد حذف هذه المحفظة؟ لا يمكن التراجع بعد الحذف.';

  @override
  String get allTransactions => 'جميع المعاملات';

  @override
  String get viewAllTransactions => 'عرض كل المعاملات';

  @override
  String get walletTransactions => 'معاملات المحفظة';

  @override
  String get walletDetails => 'تفاصيل المحفظة';

  @override
  String get transactionsHistory => 'تاريخ المعاملات';

  @override
  String get transactionDetails => 'تفاصيل المعاملة';

  @override
  String transactionMessageReceive(Object amount) {
    return 'تم استلام $amount ج.م';
  }

  @override
  String transactionMessageSend(Object amount) {
    return 'تم إرسال $amount ج.م';
  }

  @override
  String get walletLabel => 'محفظتك';

  @override
  String get fromLabel => 'من';

  @override
  String get toLabel => 'إلى';

  @override
  String get viaLabel => 'عبر';

  @override
  String get paymentStatus => 'حالة السداد';

  @override
  String get transactions_filter_all => 'الكل';

  @override
  String get transactions_filter_allWallets => 'كل المحافظ';

  @override
  String get transactions_filter_allMembers => 'كل الأعضاء';

  @override
  String get transactions_paymentStatusAll => 'كل الحالات';

  @override
  String get transactions_searchHint => 'ابحث بآخر 2 أرقام أو أكثر';

  @override
  String get transactions_date_today => 'اليوم';

  @override
  String get transactions_date_yesterday => 'أمس';

  @override
  String get transactions_date_week => 'الأسبوع';

  @override
  String get transactions_date_month => 'الشهر';

  @override
  String get transactions_date_customRange => 'نطاق مخصص';

  @override
  String get transactions_loadMore => 'عرض المزيد';

  @override
  String transactions_viewingCountOfTotal(int count, int total) {
    return 'عرض $count من أصل $total معاملة';
  }

  @override
  String get transaction_shareReceipt => 'مشاركة إيصال العملية';

  @override
  String transaction_receiptHeader(String type) {
    return 'إيصال معاملة — $type';
  }

  @override
  String get transaction_amount => 'المبلغ';

  @override
  String get transaction_wallet => 'المحفظة';

  @override
  String get transaction_receivedFrom => 'تم الاستلام من';

  @override
  String get transaction_sentTo => 'تم الإرسال إلى';

  @override
  String get transaction_date => 'التاريخ';

  @override
  String get transaction_dateTime => 'التاريخ والوقت';

  @override
  String get transaction_referenceNumber => 'رقم العملية';

  @override
  String get transaction_history => 'سجل التعديلات';

  @override
  String transaction_markedAs(String status) {
    return 'تم التحديد كـ $status';
  }

  @override
  String transaction_by(String name) {
    return 'بواسطة $name';
  }

  @override
  String get transaction_notes => 'ملاحظات';

  @override
  String get transaction_addNote => 'إضافة ملاحظة';

  @override
  String get transaction_noteHint => 'اكتب ملاحظتك هنا';

  @override
  String get transaction_deleteAction => 'حذف';

  @override
  String get transaction_deleteTitle => 'حذف المعاملة';

  @override
  String get transaction_deleteMessage => 'هل أنت متأكد أنك تريد حذف هذه المعاملة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get transaction_deletedSuccess => 'تم حذف المعاملة';

  @override
  String get transaction_deleteNoteTitle => 'حذف الملاحظة';

  @override
  String get transaction_deleteNoteMessage => 'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get transaction_noteDeleted => 'تم حذف الملاحظة';

  @override
  String get transaction_undo => 'تراجع';

  @override
  String get transaction_edited => 'تم التعديل';

  @override
  String get transaction_cancel => 'إلغاء';

  @override
  String get transaction_save => 'حفظ';

  @override
  String get transaction_smsText => 'نص الرسالة';

  @override
  String get transaction_typeReceiveLabel => 'عملية استلام';

  @override
  String get transaction_typeSendLabel => 'عملية إرسال';

  @override
  String get transaction_errorGeneric => 'حدث خطأ';

  @override
  String get transactions_emptyWithFilter => 'لا توجد معاملات مطابقة للفلاتر المحددة';

  @override
  String get transactions_emptyWithFilterTitle => 'لا توجد معاملات مطابقة';

  @override
  String get transactions_emptyWithFilterDescription => 'جرّب مسح فلتر أو أكثر لعرض معاملات إضافية.';

  @override
  String get transactions_clearFilters => 'مسح الفلاتر';

  @override
  String transactions_title_wallet(String name) {
    return 'معاملات $name';
  }

  @override
  String transactions_title_workspace(String name) {
    return 'معاملات $name';
  }

  @override
  String get workspaceTransactionsTodayCollected => 'المحصّل اليوم';

  @override
  String get workspaceTransactionsTodaySent => 'المرسَل اليوم';

  @override
  String get workspaceTransactionsUnpaidCount => 'عدد غير المدفوع';

  @override
  String get workspaceTransactionsLatestWallets => 'أحدث المحافظ نشاطاً';

  @override
  String get workspaceTransactionsLatestWalletsEmpty => 'لا يوجد نشاط على المحافظ بعد.';

  @override
  String get errorTransactionNotFound => 'هذه المعاملة لم تعد متاحة.';

  @override
  String get errorTransactionAlreadyExists => 'هذه المعاملة مسجلة بالفعل.';

  @override
  String get fullNameValidationEmpty => 'يرجى إدخال اسمك';

  @override
  String get transactions_filterTitle => 'الفلاتر';

  @override
  String get transactions_filterApply => 'تطبيق الفلاتر';

  @override
  String get transactions_filterReset => 'إعادة ضبط';

  @override
  String transactions_filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نشط',
      one: 'نشط',
    );
    return '$count فلتر $_temp0';
  }

  @override
  String get transactions_filterType => 'النوع';

  @override
  String get transactions_filterPaidStatus => 'الحالة';

  @override
  String get transactions_filterDate => 'التاريخ';

  @override
  String get transactions_filterMember => 'العضو';

  @override
  String get transactions_filterWallet => 'المحفظة';

  @override
  String get reports_total_transactions => 'عدد المعاملات';

  @override
  String get reports_all_wallets => 'كافة المحافظ';

  @override
  String get reports_period_today => 'اليوم';

  @override
  String get reports_period_yesterday => 'أمس';

  @override
  String get reports_period_lastWeek => 'الأسبوع الماضي';

  @override
  String get reports_period_lastMonth => 'الشهر الماضي';

  @override
  String get reports_period_custom => 'نطاق مخصص';

  @override
  String get reports_stat_average => 'المتوسط اليومي';

  @override
  String get reports_balance_label => 'صافي التدفق النقدي';

  @override
  String get reports_performance_label => 'الأداء المالي';

  @override
  String get reports_wallet_title => 'تقارير الـمحفظة';

  @override
  String get reports_workspace_title => 'تقارير مـساحة العمل';

  @override
  String wallet_statsFrom(Object date) {
    return 'الإحصائيات من $date';
  }

  @override
  String get wallet_resetStats => 'تصفير المؤشرات';

  @override
  String get wallet_resetStatsDescription => 'متأكد إنك عايز تصفر مؤشرات الوارد والصادر للمحفظة دي؟ ده هيخلي إجمالي المبالغ صفر من بداية النهاردة، لكن رصيدك الحالي مش هيتأثر.';

  @override
  String get wallet_resetStatsAction => 'تصفير';

  @override
  String get walletBalanceEditTitle => 'تحديث الرصيد الحالي';

  @override
  String get walletBalanceEditDescription => 'استخدم ده لو في رسالة قديمة فاتت التطبيق أو لو محتاج تصحح الرصيد يدويًا.';

  @override
  String get walletBalanceEditAction => 'تحديث الرصيد';

  @override
  String get walletBalanceEditHint => 'اكتب آخر رصيد عندك';

  @override
  String get walletBalanceEditInvalid => 'أدخل قيمة رصيد صحيحة.';

  @override
  String get walletBalanceEditSuccess => 'تم تحديث الرصيد الحالي.';

  @override
  String walletBalanceEditSuggested(Object amount) {
    return 'آخر رصيد تم اكتشافه: $amount';
  }

  @override
  String get walletManualTransactionEntryAction => 'إضافة معاملة من رسالة';

  @override
  String get walletManualTransactionTitle => 'إضافة معاملة من SMS';

  @override
  String get walletManualTransactionDescription => 'الصق رسالة العملية الأصلية هنا، وسنطبق عليها نفس منطق التحليل والمطابقة المستخدم في القراءة التلقائية للرسائل.';

  @override
  String get walletManualTransactionFieldLabel => 'نص الرسالة';

  @override
  String get walletManualTransactionFieldHint => 'الصق الرسالة كاملة كما وصلتك';

  @override
  String get walletManualTransactionPasteAction => 'لصق من الحافظة';

  @override
  String get walletManualTransactionAnalyzeAction => 'تحليل الرسالة';

  @override
  String get walletManualTransactionSaveAction => 'حفظ العملية';

  @override
  String get walletManualTransactionConfirmAction => 'حفظ على هذه المحفظة';

  @override
  String get walletManualTransactionForceAction => 'حفظ رغم ذلك';

  @override
  String get walletManualTransactionBlockedAction => 'الرسالة تخص محفظة أخرى';

  @override
  String get walletManualTransactionSaved => 'تمت إضافة المعاملة بنجاح.';

  @override
  String get walletManualTransactionReviewTitle => 'راجع المعاملة قبل الحفظ';

  @override
  String get walletManualTransactionReviewDescription => 'تم تحليل الرسالة بنجاح، لكن لم نتمكن من تأكيد المحفظة بنسبة كاملة. راجع التفاصيل قبل المتابعة.';

  @override
  String get walletManualTransactionExplicitMismatchTitle => 'الرسالة تخص محفظة أخرى';

  @override
  String get walletManualTransactionExplicitMismatchDescription => 'الرسالة تذكر رقم محفظة واضح لا يطابق المحفظة التي فتحتها الآن.';

  @override
  String get walletManualTransactionInferredMismatchTitle => 'محفظة أخرى تبدو أقرب';

  @override
  String get walletManualTransactionInferredMismatchDescription => 'الرصيد الحالي وقواعد المطابقة تشير إلى محفظة مختلفة. احفظ هنا فقط لو أنت متأكد أن العملية يجب أن تُسجل على المحفظة الحالية.';

  @override
  String get walletManualTransactionSuggestedWalletLabel => 'المحفظة المقترحة';

  @override
  String walletManualTransactionBalanceChip(Object amount) {
    return 'الرصيد بعد الرسالة: $amount';
  }

  @override
  String walletManualTransactionPhoneChip(Object phoneNumber) {
    return 'رقم المحفظة المذكور: $phoneNumber';
  }

  @override
  String get walletSyncTransactionsTitle => 'مزامنة المعاملات الفائتة';

  @override
  String get walletSyncTransactionsDescription => 'افحص رسائل الـ SMS الأخيرة للبحث عن معاملات وصلت بعد آخر نشاط محفوظ على هذه المحفظة.';

  @override
  String get walletSyncTransactionsAction => 'مزامنة المعاملات';

  @override
  String get walletSyncTransactionsReviewTitle => 'راجع المعاملات غير المحفوظة';

  @override
  String walletSyncTransactionsFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count معاملات فائتة',
      one: 'تم العثور على معاملة فائتة واحدة',
      zero: 'لم نجد معاملات فائتة',
    );
    return '$_temp0';
  }

  @override
  String walletSyncTransactionsFromDate(String date) {
    return 'نفحص الرسائل بعد $date';
  }

  @override
  String walletSyncTransactionsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات محددة',
      one: 'معاملة واحدة محددة',
      zero: 'لا توجد معاملات محددة',
    );
    return '$_temp0';
  }

  @override
  String get walletSyncTransactionsSaveAction => 'إضافة المحدد';

  @override
  String get walletSyncTransactionsEmptyTitle => 'لا توجد معاملات فائتة';

  @override
  String get walletSyncTransactionsEmptyDescription => 'لم نجد أي معاملات SMS غير محفوظة لهذه المحفظة في سجل الرسائل الأخير.';

  @override
  String walletSyncTransactionsEmptySinceDescription(String date) {
    return 'لم نجد أي معاملات SMS غير محفوظة بعد $date.';
  }

  @override
  String walletSyncTransactionsSavedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إضافة $count معاملات بنجاح.',
      one: 'تمت إضافة معاملة واحدة بنجاح.',
    );
    return '$_temp0';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `لا يوجد اتصال بالإنترنت. اتأكد من الشبكة وحاول مرة تانية.`
  String get errorNetwork {
    return Intl.message(
      'لا يوجد اتصال بالإنترنت. اتأكد من الشبكة وحاول مرة تانية.',
      name: 'errorNetwork',
      desc: '',
      args: [],
    );
  }

  /// `الحساب غير موجود. اتأكد من بيانات الدخول.`
  String get errorAuthUserNotFound {
    return Intl.message(
      'الحساب غير موجود. اتأكد من بيانات الدخول.',
      name: 'errorAuthUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور غير صحيحة. حاول مرة تانية.`
  String get errorAuthWrongPassword {
    return Intl.message(
      'كلمة المرور غير صحيحة. حاول مرة تانية.',
      name: 'errorAuthWrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `هذا البريد الإلكتروني مسجل بالفعل.`
  String get errorAuthEmailInUse {
    return Intl.message(
      'هذا البريد الإلكتروني مسجل بالفعل.',
      name: 'errorAuthEmailInUse',
      desc: '',
      args: [],
    );
  }

  /// `عدد المحاولات كبير جداً. حاول مرة تانية بعد شوية.`
  String get errorAuthTooManyRequests {
    return Intl.message(
      'عدد المحاولات كبير جداً. حاول مرة تانية بعد شوية.',
      name: 'errorAuthTooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `تم تعطيل هذا الحساب.`
  String get errorAuthUserDisabled {
    return Intl.message(
      'تم تعطيل هذا الحساب.',
      name: 'errorAuthUserDisabled',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور ضعيفة. اختر كلمة مرور أقوى.`
  String get errorAuthWeakPassword {
    return Intl.message(
      'كلمة المرور ضعيفة. اختر كلمة مرور أقوى.',
      name: 'errorAuthWeakPassword',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني غير صحيح.`
  String get errorAuthInvalidEmail {
    return Intl.message(
      'البريد الإلكتروني غير صحيح.',
      name: 'errorAuthInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `انتهت الجلسة. سجل دخولك مرة تانية.`
  String get errorUnauthorized {
    return Intl.message(
      'انتهت الجلسة. سجل دخولك مرة تانية.',
      name: 'errorUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `تعذر تسجيل الدخول الآن. حاول مرة تانية.`
  String get errorAuthGeneric {
    return Intl.message(
      'تعذر تسجيل الدخول الآن. حاول مرة تانية.',
      name: 'errorAuthGeneric',
      desc: '',
      args: [],
    );
  }

  /// `لا يمكنك تنفيذ هذا الإجراء.`
  String get errorForbidden {
    return Intl.message(
      'لا يمكنك تنفيذ هذا الإجراء.',
      name: 'errorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `المطلوب غير موجود.`
  String get errorNotFound {
    return Intl.message(
      'المطلوب غير موجود.',
      name: 'errorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `في تعارض في البيانات. حاول مرة تانية.`
  String get errorConflict {
    return Intl.message(
      'في تعارض في البيانات. حاول مرة تانية.',
      name: 'errorConflict',
      desc: '',
      args: [],
    );
  }

  /// `تعذر تنفيذ طلبك. راجع البيانات وحاول تاني.`
  String get errorUnprocessable {
    return Intl.message(
      'تعذر تنفيذ طلبك. راجع البيانات وحاول تاني.',
      name: 'errorUnprocessable',
      desc: '',
      args: [],
    );
  }

  /// `في مشكلة في الخدمة حالياً. حاول بعد شوية.`
  String get errorServer {
    return Intl.message(
      'في مشكلة في الخدمة حالياً. حاول بعد شوية.',
      name: 'errorServer',
      desc: '',
      args: [],
    );
  }

  /// `حصلت مشكلة. حاول مرة تانية.`
  String get errorServerGeneric {
    return Intl.message(
      'حصلت مشكلة. حاول مرة تانية.',
      name: 'errorServerGeneric',
      desc: '',
      args: [],
    );
  }

  /// `الصلاحية غير متاحة.`
  String get errorPermissionDenied {
    return Intl.message(
      'الصلاحية غير متاحة.',
      name: 'errorPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `حصلت مشكلة في حفظ البيانات على الجهاز. حاول مرة تانية.`
  String get errorCache {
    return Intl.message(
      'حصلت مشكلة في حفظ البيانات على الجهاز. حاول مرة تانية.',
      name: 'errorCache',
      desc: '',
      args: [],
    );
  }

  /// `حصلت مشكلة في حفظ الملف.`
  String get errorStorage {
    return Intl.message(
      'حصلت مشكلة في حفظ الملف.',
      name: 'errorStorage',
      desc: '',
      args: [],
    );
  }

  /// `راجع البيانات المدخلة.`
  String get errorValidation {
    return Intl.message(
      'راجع البيانات المدخلة.',
      name: 'errorValidation',
      desc: '',
      args: [],
    );
  }

  /// `راجع البيانات المدخلة: {code}`
  String errorValidationWithCode(String code) {
    return Intl.message(
      'راجع البيانات المدخلة: $code',
      name: 'errorValidationWithCode',
      desc: '',
      args: [code],
    );
  }

  /// `حصلت مشكلة غير متوقعة.`
  String get errorUnknown {
    return Intl.message(
      'حصلت مشكلة غير متوقعة.',
      name: 'errorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `404`
  String get notFoundStatusCode {
    return Intl.message('404', name: 'notFoundStatusCode', desc: '', args: []);
  }

  /// `الصفحة غير موجودة`
  String get notFoundPageTitle {
    return Intl.message(
      'الصفحة غير موجودة',
      name: 'notFoundPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `محافظ`
  String get appName {
    return Intl.message('محافظ', name: 'appName', desc: '', args: []);
  }

  /// `تسجيل الدخول`
  String get signIn {
    return Intl.message('تسجيل الدخول', name: 'signIn', desc: '', args: []);
  }

  /// `إنشاء حساب`
  String get signUp {
    return Intl.message('إنشاء حساب', name: 'signUp', desc: '', args: []);
  }

  /// `البريد الإلكتروني`
  String get email {
    return Intl.message('البريد الإلكتروني', name: 'email', desc: '', args: []);
  }

  /// `كلمة المرور`
  String get password {
    return Intl.message('كلمة المرور', name: 'password', desc: '', args: []);
  }

  /// `الاسم`
  String get displayName {
    return Intl.message('الاسم', name: 'displayName', desc: '', args: []);
  }

  /// `اسمك`
  String get yourName {
    return Intl.message('اسمك', name: 'yourName', desc: '', args: []);
  }

  /// `تأكيد`
  String get confirm {
    return Intl.message('تأكيد', name: 'confirm', desc: '', args: []);
  }

  /// `تسجيل الدخول بجوجل`
  String get signInWithGoogle {
    return Intl.message(
      'تسجيل الدخول بجوجل',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول بالبريد الإلكتروني`
  String get signInWithEmail {
    return Intl.message(
      'تسجيل الدخول بالبريد الإلكتروني',
      name: 'signInWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب؟`
  String get dontHaveAccount {
    return Intl.message(
      'ليس لديك حساب؟',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `لديك حساب بالفعل؟`
  String get alreadyHaveAccount {
    return Intl.message(
      'لديك حساب بالفعل؟',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء حساب`
  String get createAccount {
    return Intl.message(
      'إنشاء حساب',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `أدخل بريدك الإلكتروني`
  String get emailHint {
    return Intl.message(
      'أدخل بريدك الإلكتروني',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `أدخل كلمة المرور`
  String get passwordHint {
    return Intl.message(
      'أدخل كلمة المرور',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسمك`
  String get displayNameHint {
    return Intl.message(
      'أدخل اسمك',
      name: 'displayNameHint',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد الاسم`
  String get confirmName {
    return Intl.message('تأكيد الاسم', name: 'confirmName', desc: '', args: []);
  }

  /// `أكد اسمك عشان نكمل`
  String get confirmNameMessage {
    return Intl.message(
      'أكد اسمك عشان نكمل',
      name: 'confirmNameMessage',
      desc: '',
      args: [],
    );
  }

  /// `أو`
  String get or {
    return Intl.message('أو', name: 'or', desc: '', args: []);
  }

  /// `تابع محافظ شغلك بسهولة ومن مكان واحد`
  String get appTagline {
    return Intl.message(
      'تابع محافظ شغلك بسهولة ومن مكان واحد',
      name: 'appTagline',
      desc: '',
      args: [],
    );
  }

  /// `كمل باستخدام جوجل`
  String get continueWithGoogle {
    return Intl.message(
      'كمل باستخدام جوجل',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `نسيت كلمة المرور؟`
  String get forgotPassword {
    return Intl.message(
      'نسيت كلمة المرور؟',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ حسابك`
  String get signUpNow {
    return Intl.message('أنشئ حسابك', name: 'signUpNow', desc: '', args: []);
  }

  /// `example@email.com`
  String get emailPlaceholder {
    return Intl.message(
      'example@email.com',
      name: 'emailPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `••••••••`
  String get passwordPlaceholder {
    return Intl.message(
      '••••••••',
      name: 'passwordPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `الاسم الكامل`
  String get fullName {
    return Intl.message('الاسم الكامل', name: 'fullName', desc: '', args: []);
  }

  /// `مثلاً: أحمد محمود`
  String get fullNamePlaceholder {
    return Intl.message(
      'مثلاً: أحمد محمود',
      name: 'fullNamePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ حساب جديد وابدأ تتابع شغلك بسهولة`
  String get signUpSubtitle {
    return Intl.message(
      'أنشئ حساب جديد وابدأ تتابع شغلك بسهولة',
      name: 'signUpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `اسمك إيه؟`
  String get whatIsYourName {
    return Intl.message(
      'اسمك إيه؟',
      name: 'whatIsYourName',
      desc: '',
      args: [],
    );
  }

  /// `الاسم ده هيظهر وقت تحديث حالة الدفع عشان متابعة العمليات تبقى أسهل.`
  String get nameWillBeDisplayed {
    return Intl.message(
      'الاسم ده هيظهر وقت تحديث حالة الدفع عشان متابعة العمليات تبقى أسهل.',
      name: 'nameWillBeDisplayed',
      desc: '',
      args: [],
    );
  }

  /// `أهلاً بيك`
  String get welcome {
    return Intl.message('أهلاً بيك', name: 'welcome', desc: '', args: []);
  }

  /// `إجمالي الرصيد`
  String get totalBalance {
    return Intl.message(
      'إجمالي الرصيد',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `الرصيد الحالي`
  String get currentBalance {
    return Intl.message(
      'الرصيد الحالي',
      name: 'currentBalance',
      desc: '',
      args: [],
    );
  }

  /// `ج.م`
  String get currency {
    return Intl.message('ج.م', name: 'currency', desc: '', args: []);
  }

  /// `إجمالي الصادر`
  String get totalOut {
    return Intl.message('إجمالي الصادر', name: 'totalOut', desc: '', args: []);
  }

  /// `إجمالي الوارد`
  String get totalIn {
    return Intl.message('إجمالي الوارد', name: 'totalIn', desc: '', args: []);
  }

  /// `محافظك`
  String get yourWallets {
    return Intl.message('محافظك', name: 'yourWallets', desc: '', args: []);
  }

  /// `عرض الكل`
  String get viewAll {
    return Intl.message('عرض الكل', name: 'viewAll', desc: '', args: []);
  }

  /// `مساحات العمل`
  String get workspaces {
    return Intl.message('مساحات العمل', name: 'workspaces', desc: '', args: []);
  }

  /// `إضافة مساحة عمل`
  String get addWorkspace {
    return Intl.message(
      'إضافة مساحة عمل',
      name: 'addWorkspace',
      desc: '',
      args: [],
    );
  }

  /// `إضافة محفظة`
  String get addWallet {
    return Intl.message('إضافة محفظة', name: 'addWallet', desc: '', args: []);
  }

  /// `نشط`
  String get walletStatusActive {
    return Intl.message('نشط', name: 'walletStatusActive', desc: '', args: []);
  }

  /// `{count, plural, =0{لا توجد محافظ نشطة} =1{محفظة واحدة نشطة} =2{محفظتان نشطتان} few{{count} محافظ نشطة} many{{count} محفظة نشطة} other{{count} محفظة نشطة}}`
  String activeWalletsCount(num count) {
    return Intl.plural(
      count,
      zero: 'لا توجد محافظ نشطة',
      one: 'محفظة واحدة نشطة',
      two: 'محفظتان نشطتان',
      few: '$count محافظ نشطة',
      many: '$count محفظة نشطة',
      other: '$count محفظة نشطة',
      name: 'activeWalletsCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =0{لم تقم بإضافة أي محافظ بعد} =1{إجمالي الرصيد لمحفظتك} =2{إجمالي الرصيد لمحفظتيك} few{إجمالي الرصيد لـ {count} من محافظك} many{إجمالي الرصيد لـ {count} من محافظك} other{إجمالي الرصيد لـ {count} من محافظك}}`
  String activeWalletsHint(num count) {
    return Intl.plural(
      count,
      zero: 'لم تقم بإضافة أي محافظ بعد',
      one: 'إجمالي الرصيد لمحفظتك',
      two: 'إجمالي الرصيد لمحفظتيك',
      few: 'إجمالي الرصيد لـ $count من محافظك',
      many: 'إجمالي الرصيد لـ $count من محافظك',
      other: 'إجمالي الرصيد لـ $count من محافظك',
      name: 'activeWalletsHint',
      desc: '',
      args: [count],
    );
  }

  /// `آخر نشاط`
  String get lastActivity {
    return Intl.message('آخر نشاط', name: 'lastActivity', desc: '', args: []);
  }

  /// `الآن`
  String get justNow {
    return Intl.message('الآن', name: 'justNow', desc: '', args: []);
  }

  /// `منذ {minutes} دقيقة`
  String minutesAgo(Object minutes) {
    return Intl.message(
      'منذ $minutes دقيقة',
      name: 'minutesAgo',
      desc: '',
      args: [minutes],
    );
  }

  /// `ج.م`
  String get egp {
    return Intl.message('ج.م', name: 'egp', desc: '', args: []);
  }

  /// `إضافة محفظة`
  String get addWalletTitle {
    return Intl.message(
      'إضافة محفظة',
      name: 'addWalletTitle',
      desc: '',
      args: [],
    );
  }

  /// `لازم تكون المحفظة دي موجودة على الموبايل ده، لأن التطبيق بيقرأ رسائل الـSMS الجديدة من هنا فقط.`
  String get addWalletDescription {
    return Intl.message(
      'لازم تكون المحفظة دي موجودة على الموبايل ده، لأن التطبيق بيقرأ رسائل الـSMS الجديدة من هنا فقط.',
      name: 'addWalletDescription',
      desc: '',
      args: [],
    );
  }

  /// `رقم الموبايل`
  String get phoneNumber {
    return Intl.message(
      'رقم الموبايل',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `اختر الشركة`
  String get chooseProvider {
    return Intl.message(
      'اختر الشركة',
      name: 'chooseProvider',
      desc: '',
      args: [],
    );
  }

  /// `اسمح وكمل`
  String get allowAndContinue {
    return Intl.message(
      'اسمح وكمل',
      name: 'allowAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `لاحقاً`
  String get notNow {
    return Intl.message('لاحقاً', name: 'notNow', desc: '', args: []);
  }

  /// `أورانج كاش`
  String get providerOrange {
    return Intl.message(
      'أورانج كاش',
      name: 'providerOrange',
      desc: '',
      args: [],
    );
  }

  /// `فودافون كاش`
  String get providerVodafone {
    return Intl.message(
      'فودافون كاش',
      name: 'providerVodafone',
      desc: '',
      args: [],
    );
  }

  /// `إنستا باي`
  String get providerInstapay {
    return Intl.message(
      'إنستا باي',
      name: 'providerInstapay',
      desc: '',
      args: [],
    );
  }

  /// `اتصالات كاش`
  String get providerEtisalat {
    return Intl.message(
      'اتصالات كاش',
      name: 'providerEtisalat',
      desc: '',
      args: [],
    );
  }

  /// `وي باي`
  String get providerWePay {
    return Intl.message('وي باي', name: 'providerWePay', desc: '', args: []);
  }

  /// `محفظة أخرى`
  String get providerUnknown {
    return Intl.message(
      'محفظة أخرى',
      name: 'providerUnknown',
      desc: '',
      args: [],
    );
  }

  /// `اسمح بالوصول للرسائل والموبايل`
  String get smsPermissionTitle {
    return Intl.message(
      'اسمح بالوصول للرسائل والموبايل',
      name: 'smsPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `التطبيق محتاج صلاحية الرسائل والموبايل عشان يتعرف على أرقام المحافظ الموجودة على الجهاز ويضيف الحركات الجديدة تلقائياً.`
  String get smsPermissionDescription {
    return Intl.message(
      'التطبيق محتاج صلاحية الرسائل والموبايل عشان يتعرف على أرقام المحافظ الموجودة على الجهاز ويضيف الحركات الجديدة تلقائياً.',
      name: 'smsPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `تحديث تلقائي`
  String get smsPermissionAutoUpdateTitle {
    return Intl.message(
      'تحديث تلقائي',
      name: 'smsPermissionAutoUpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `أي حركة جديدة بتتسجل أول ما رسالة العملية توصل.`
  String get smsPermissionAutoUpdateDesc {
    return Intl.message(
      'أي حركة جديدة بتتسجل أول ما رسالة العملية توصل.',
      name: 'smsPermissionAutoUpdateDesc',
      desc: '',
      args: [],
    );
  }

  /// `خصوصيتك محفوظة`
  String get smsPermissionPrivacyTitle {
    return Intl.message(
      'خصوصيتك محفوظة',
      name: 'smsPermissionPrivacyTitle',
      desc: '',
      args: [],
    );
  }

  /// `بنقرأ فقط الرسائل الخاصة بالمعاملات وأرقام الموبايل اللازمة لإعداد المحافظ. بياناتك مشفرة ومش بنشاركها مع أي حد.`
  String get smsPermissionPrivacyDesc {
    return Intl.message(
      'بنقرأ فقط الرسائل الخاصة بالمعاملات وأرقام الموبايل اللازمة لإعداد المحافظ. بياناتك مشفرة ومش بنشاركها مع أي حد.',
      name: 'smsPermissionPrivacyDesc',
      desc: '',
      args: [],
    );
  }

  /// `أضف المحفظة`
  String get addWalletAction {
    return Intl.message(
      'أضف المحفظة',
      name: 'addWalletAction',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء مساحة عمل`
  String get createWorkspaceTitle {
    return Intl.message(
      'إنشاء مساحة عمل',
      name: 'createWorkspaceTitle',
      desc: '',
      args: [],
    );
  }

  /// `مساحة العمل بتساعدك تجمع محافظ شغلك وتشاركها مع الناس الموثوق فيهم من مكان واحد.`
  String get createWorkspaceDescription {
    return Intl.message(
      'مساحة العمل بتساعدك تجمع محافظ شغلك وتشاركها مع الناس الموثوق فيهم من مكان واحد.',
      name: 'createWorkspaceDescription',
      desc: '',
      args: [],
    );
  }

  /// `اسم مساحة العمل`
  String get workspaceNameLabel {
    return Intl.message(
      'اسم مساحة العمل',
      name: 'workspaceNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `مثلاً: محل موبايلات`
  String get workspaceNameHint {
    return Intl.message(
      'مثلاً: محل موبايلات',
      name: 'workspaceNameHint',
      desc: '',
      args: [],
    );
  }

  /// `معاينة مساحة العمل`
  String get createWorkspacePreviewLabel {
    return Intl.message(
      'معاينة مساحة العمل',
      name: 'createWorkspacePreviewLabel',
      desc: '',
      args: [],
    );
  }

  /// `مساحة عمل جديدة`
  String get createWorkspacePreviewFallback {
    return Intl.message(
      'مساحة عمل جديدة',
      name: 'createWorkspacePreviewFallback',
      desc: '',
      args: [],
    );
  }

  /// `بعد إنشاء مساحة العمل، تقدر تضيف محافظ وتبعت دعوات للأعضاء.`
  String get createWorkspacePreviewDescription {
    return Intl.message(
      'بعد إنشاء مساحة العمل، تقدر تضيف محافظ وتبعت دعوات للأعضاء.',
      name: 'createWorkspacePreviewDescription',
      desc: '',
      args: [],
    );
  }

  /// `المالك`
  String get workspaceOwner {
    return Intl.message('المالك', name: 'workspaceOwner', desc: '', args: []);
  }

  /// `مالك`
  String get workspaceOwnerBadge {
    return Intl.message(
      'مالك',
      name: 'workspaceOwnerBadge',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{لا يوجد أعضاء} =1{عضو واحد} =2{عضوان} few{{count} أعضاء} many{{count} عضوًا} other{{count} عضو}}`
  String workspaceMembersCount(int count) {
    return Intl.plural(
      count,
      zero: 'لا يوجد أعضاء',
      one: 'عضو واحد',
      two: 'عضوان',
      few: '$count أعضاء',
      many: '$count عضوًا',
      other: '$count عضو',
      name: 'workspaceMembersCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =0{لا توجد محافظ} =1{محفظة واحدة} =2{محفظتان} few{{count} محافظ} many{{count} محفظة} other{{count} محفظة}}`
  String workspaceWalletsCount(int count) {
    return Intl.plural(
      count,
      zero: 'لا توجد محافظ',
      one: 'محفظة واحدة',
      two: 'محفظتان',
      few: '$count محافظ',
      many: '$count محفظة',
      other: '$count محفظة',
      name: 'workspaceWalletsCount',
      desc: '',
      args: [count],
    );
  }

  /// `إنشاء مساحة العمل`
  String get createWorkspaceAction {
    return Intl.message(
      'إنشاء مساحة العمل',
      name: 'createWorkspaceAction',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ بأول مساحة عمل`
  String get createWorkspaceEmptyTitle {
    return Intl.message(
      'ابدأ بأول مساحة عمل',
      name: 'createWorkspaceEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `اجمع محافظ شغلك، تابع الحركة، وخلي فريقك يشتغل معاك من مكان واحد.`
  String get createWorkspaceEmptyDescription {
    return Intl.message(
      'اجمع محافظ شغلك، تابع الحركة، وخلي فريقك يشتغل معاك من مكان واحد.',
      name: 'createWorkspaceEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `المحافظ`
  String get workspaceWallets {
    return Intl.message(
      'المحافظ',
      name: 'workspaceWallets',
      desc: '',
      args: [],
    );
  }

  /// `الأعضاء`
  String get workspaceMembers {
    return Intl.message(
      'الأعضاء',
      name: 'workspaceMembers',
      desc: '',
      args: [],
    );
  }

  /// `دعوة عضو`
  String get workspaceInviteMemberAction {
    return Intl.message(
      'دعوة عضو',
      name: 'workspaceInviteMemberAction',
      desc: '',
      args: [],
    );
  }

  /// `إعدادات المساحة`
  String get workspaceSettingsTitle {
    return Intl.message(
      'إعدادات المساحة',
      name: 'workspaceSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `بيانات المساحة`
  String get workspaceSettingsInfoSection {
    return Intl.message(
      'بيانات المساحة',
      name: 'workspaceSettingsInfoSection',
      desc: '',
      args: [],
    );
  }

  /// `دعوة عضو`
  String get workspaceSettingsInviteByEmailAction {
    return Intl.message(
      'دعوة عضو',
      name: 'workspaceSettingsInviteByEmailAction',
      desc: '',
      args: [],
    );
  }

  /// `الدعوات المعلقة`
  String get workspaceSettingsPendingInvitationsSection {
    return Intl.message(
      'الدعوات المعلقة',
      name: 'workspaceSettingsPendingInvitationsSection',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد دعوات معلقة لهذه المساحة حالياً.`
  String get workspaceSettingsPendingInvitationsEmpty {
    return Intl.message(
      'لا توجد دعوات معلقة لهذه المساحة حالياً.',
      name: 'workspaceSettingsPendingInvitationsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `إجراءات حساسة`
  String get workspaceSettingsDangerZone {
    return Intl.message(
      'إجراءات حساسة',
      name: 'workspaceSettingsDangerZone',
      desc: '',
      args: [],
    );
  }

  /// `تعديل اسم المساحة`
  String get workspaceSettingsEditNameTitle {
    return Intl.message(
      'تعديل اسم المساحة',
      name: 'workspaceSettingsEditNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `غيّر الاسم الظاهر للمساحة في كل الشاشات المشتركة.`
  String get workspaceSettingsEditNameDescription {
    return Intl.message(
      'غيّر الاسم الظاهر للمساحة في كل الشاشات المشتركة.',
      name: 'workspaceSettingsEditNameDescription',
      desc: '',
      args: [],
    );
  }

  /// `حفظ التعديلات`
  String get workspaceSettingsEditNameAction {
    return Intl.message(
      'حفظ التعديلات',
      name: 'workspaceSettingsEditNameAction',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get workspaceSettingsRemoveMemberAction {
    return Intl.message(
      'حذف',
      name: 'workspaceSettingsRemoveMemberAction',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get workspaceSettingsCancelInvitationAction {
    return Intl.message(
      'إلغاء',
      name: 'workspaceSettingsCancelInvitationAction',
      desc: '',
      args: [],
    );
  }

  /// `حذف مساحة العمل`
  String get workspaceSettingsDeleteWorkspaceAction {
    return Intl.message(
      'حذف مساحة العمل',
      name: 'workspaceSettingsDeleteWorkspaceAction',
      desc: '',
      args: [],
    );
  }

  /// `سيتم حذف كل البيانات المرتبطة بالمساحة نهائياً.`
  String get workspaceSettingsDeleteWorkspaceDescription {
    return Intl.message(
      'سيتم حذف كل البيانات المرتبطة بالمساحة نهائياً.',
      name: 'workspaceSettingsDeleteWorkspaceDescription',
      desc: '',
      args: [],
    );
  }

  /// `تم تغيير اسم مساحة العمل.`
  String get workspaceSettingsNameUpdatedSuccess {
    return Intl.message(
      'تم تغيير اسم مساحة العمل.',
      name: 'workspaceSettingsNameUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `تم حذف العضو.`
  String get workspaceSettingsMemberRemovedSuccess {
    return Intl.message(
      'تم حذف العضو.',
      name: 'workspaceSettingsMemberRemovedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `تم إلغاء الدعوة.`
  String get workspaceSettingsInvitationCancelledSuccess {
    return Intl.message(
      'تم إلغاء الدعوة.',
      name: 'workspaceSettingsInvitationCancelledSuccess',
      desc: '',
      args: [],
    );
  }

  /// `حذف العضو؟`
  String get workspaceSettingsRemoveMemberConfirmTitle {
    return Intl.message(
      'حذف العضو؟',
      name: 'workspaceSettingsRemoveMemberConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `سيتم حذف {memberName} من مساحة العمل. تقدر تبعت له دعوة مرة تانية لاحقاً.`
  String workspaceSettingsRemoveMemberConfirmMessage(Object memberName) {
    return Intl.message(
      'سيتم حذف $memberName من مساحة العمل. تقدر تبعت له دعوة مرة تانية لاحقاً.',
      name: 'workspaceSettingsRemoveMemberConfirmMessage',
      desc: '',
      args: [memberName],
    );
  }

  /// `إلغاء الدعوة؟`
  String get workspaceSettingsCancelInvitationConfirmTitle {
    return Intl.message(
      'إلغاء الدعوة؟',
      name: 'workspaceSettingsCancelInvitationConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `سيتم إلغاء الدعوة المرسلة إلى {email} فوراً.`
  String workspaceSettingsCancelInvitationConfirmMessage(Object email) {
    return Intl.message(
      'سيتم إلغاء الدعوة المرسلة إلى $email فوراً.',
      name: 'workspaceSettingsCancelInvitationConfirmMessage',
      desc: '',
      args: [email],
    );
  }

  /// `حذف مساحة العمل؟`
  String get workspaceSettingsDeleteWorkspaceConfirmTitle {
    return Intl.message(
      'حذف مساحة العمل؟',
      name: 'workspaceSettingsDeleteWorkspaceConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `سيتم حذف مساحة العمل وأذونات الأعضاء وربط المحافظ والدعوات المعلقة نهائياً.`
  String get workspaceSettingsDeleteWorkspaceConfirmMessage {
    return Intl.message(
      'سيتم حذف مساحة العمل وأذونات الأعضاء وربط المحافظ والدعوات المعلقة نهائياً.',
      name: 'workspaceSettingsDeleteWorkspaceConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get commonDeleteAction {
    return Intl.message('حذف', name: 'commonDeleteAction', desc: '', args: []);
  }

  /// `إلغاء`
  String get commonCancelAction {
    return Intl.message(
      'إلغاء',
      name: 'commonCancelAction',
      desc: '',
      args: [],
    );
  }

  /// `إضافة محافظ`
  String get workspaceAddWalletsTitle {
    return Intl.message(
      'إضافة محافظ',
      name: 'workspaceAddWalletsTitle',
      desc: '',
      args: [],
    );
  }

  /// `إضافة محافظ`
  String get workspaceAddWalletsAction {
    return Intl.message(
      'إضافة محافظ',
      name: 'workspaceAddWalletsAction',
      desc: '',
      args: [],
    );
  }

  /// `اختر المحافظ التي تريد تظهر في مساحة العمل الآن. وتقدر تضيف المزيد لاحقاً.`
  String get workspaceAddWalletsCreateDescription {
    return Intl.message(
      'اختر المحافظ التي تريد تظهر في مساحة العمل الآن. وتقدر تضيف المزيد لاحقاً.',
      name: 'workspaceAddWalletsCreateDescription',
      desc: '',
      args: [],
    );
  }

  /// `شارك محافظك مع مساحة العمل. أي محفظة تضيفها هنا هتظهر لكل أعضاء المساحة.`
  String get workspaceAddWalletsManageDescription {
    return Intl.message(
      'شارك محافظك مع مساحة العمل. أي محفظة تضيفها هنا هتظهر لكل أعضاء المساحة.',
      name: 'workspaceAddWalletsManageDescription',
      desc: '',
      args: [],
    );
  }

  /// `إضافة المحافظ المحددة`
  String get workspaceAddSelectedWalletsAction {
    return Intl.message(
      'إضافة المحافظ المحددة',
      name: 'workspaceAddSelectedWalletsAction',
      desc: '',
      args: [],
    );
  }

  /// `ادخل على مساحة العمل`
  String get workspaceContinueToDetailsAction {
    return Intl.message(
      'ادخل على مساحة العمل',
      name: 'workspaceContinueToDetailsAction',
      desc: '',
      args: [],
    );
  }

  /// `تخطي حالياً`
  String get workspaceSkipWalletsAction {
    return Intl.message(
      'تخطي حالياً',
      name: 'workspaceSkipWalletsAction',
      desc: '',
      args: [],
    );
  }

  /// `متاحة`
  String get workspaceWalletAvailable {
    return Intl.message(
      'متاحة',
      name: 'workspaceWalletAvailable',
      desc: '',
      args: [],
    );
  }

  /// `محددة`
  String get workspaceWalletSelected {
    return Intl.message(
      'محددة',
      name: 'workspaceWalletSelected',
      desc: '',
      args: [],
    );
  }

  /// `مضافة`
  String get workspaceWalletAlreadyAdded {
    return Intl.message(
      'مضافة',
      name: 'workspaceWalletAlreadyAdded',
      desc: '',
      args: [],
    );
  }

  /// `لا تملك أي محافظ بعد`
  String get workspaceNoOwnedWalletsTitle {
    return Intl.message(
      'لا تملك أي محافظ بعد',
      name: 'workspaceNoOwnedWalletsTitle',
      desc: '',
      args: [],
    );
  }

  /// `أضف محفظة أولاً، وبعدها تقدر تشاركها مع مساحة العمل.`
  String get workspaceNoOwnedWalletsDescription {
    return Intl.message(
      'أضف محفظة أولاً، وبعدها تقدر تشاركها مع مساحة العمل.',
      name: 'workspaceNoOwnedWalletsDescription',
      desc: '',
      args: [],
    );
  }

  /// `كل محافظك مرتبطة بالفعل`
  String get workspaceAllOwnedWalletsLinkedTitle {
    return Intl.message(
      'كل محافظك مرتبطة بالفعل',
      name: 'workspaceAllOwnedWalletsLinkedTitle',
      desc: '',
      args: [],
    );
  }

  /// `تقدر تدخل على مساحة العمل أو تضيف محفظة جديدة لاحقاً.`
  String get workspaceAllOwnedWalletsLinkedDescription {
    return Intl.message(
      'تقدر تدخل على مساحة العمل أو تضيف محفظة جديدة لاحقاً.',
      name: 'workspaceAllOwnedWalletsLinkedDescription',
      desc: '',
      args: [],
    );
  }

  /// `عندك {ownedCount} محافظ، و{linkedCount} منها مضافين بالفعل في مساحة العمل.`
  String workspaceWalletSelectionSummary(int ownedCount, int linkedCount) {
    return Intl.message(
      'عندك $ownedCount محافظ، و$linkedCount منها مضافين بالفعل في مساحة العمل.',
      name: 'workspaceWalletSelectionSummary',
      desc: '',
      args: [ownedCount, linkedCount],
    );
  }

  /// `لا توجد محافظ مرتبطة بعد`
  String get workspaceWalletsEmptyTitle {
    return Intl.message(
      'لا توجد محافظ مرتبطة بعد',
      name: 'workspaceWalletsEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `المحافظ المشتركة هتظهر هنا بعد ربطها بمساحة العمل.`
  String get workspaceWalletsEmptyDescription {
    return Intl.message(
      'المحافظ المشتركة هتظهر هنا بعد ربطها بمساحة العمل.',
      name: 'workspaceWalletsEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد أعضاء في مساحة العمل حتى الآن.`
  String get workspaceMembersEmpty {
    return Intl.message(
      'لا يوجد أعضاء في مساحة العمل حتى الآن.',
      name: 'workspaceMembersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `الدعوات`
  String get invitationsTitle {
    return Intl.message(
      'الدعوات',
      name: 'invitationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد دعوات معلقة`
  String get invitationsEmptyTitle {
    return Intl.message(
      'لا توجد دعوات معلقة',
      name: 'invitationsEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد عندك دعوات معلقة حالياً.`
  String get invitationsEmptyDescription {
    return Intl.message(
      'لا توجد عندك دعوات معلقة حالياً.',
      name: 'invitationsEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `راجع الدعوات اللي وصلتك واختر إذا كنت هتقبل أو ترفض.`
  String get invitationsListDescription {
    return Intl.message(
      'راجع الدعوات اللي وصلتك واختر إذا كنت هتقبل أو ترفض.',
      name: 'invitationsListDescription',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{لا توجد دعوات بانتظار الرد} =1{دعوة واحدة بانتظار الرد} =2{دعوتان بانتظار الرد} few{{count} دعوات بانتظار الرد} many{{count} دعوة بانتظار الرد} other{{count} دعوة بانتظار الرد}}`
  String invitationsPendingCount(int count) {
    return Intl.plural(
      count,
      zero: 'لا توجد دعوات بانتظار الرد',
      one: 'دعوة واحدة بانتظار الرد',
      two: 'دعوتان بانتظار الرد',
      few: '$count دعوات بانتظار الرد',
      many: '$count دعوة بانتظار الرد',
      other: '$count دعوة بانتظار الرد',
      name: 'invitationsPendingCount',
      desc: '',
      args: [count],
    );
  }

  /// `بانتظارك`
  String get invitationsPendingStatus {
    return Intl.message(
      'بانتظارك',
      name: 'invitationsPendingStatus',
      desc: '',
      args: [],
    );
  }

  /// `قبول`
  String get invitationsAcceptAction {
    return Intl.message(
      'قبول',
      name: 'invitationsAcceptAction',
      desc: '',
      args: [],
    );
  }

  /// `رفض`
  String get invitationsDeclineAction {
    return Intl.message(
      'رفض',
      name: 'invitationsDeclineAction',
      desc: '',
      args: [],
    );
  }

  /// `تحديث القائمة`
  String get invitationsRefreshAction {
    return Intl.message(
      'تحديث القائمة',
      name: 'invitationsRefreshAction',
      desc: '',
      args: [],
    );
  }

  /// `كيف تعمل الدعوات`
  String get invitationsHowItWorksTitle {
    return Intl.message(
      'كيف تعمل الدعوات',
      name: 'invitationsHowItWorksTitle',
      desc: '',
      args: [],
    );
  }

  /// `يمكن إرسال الدعوة فقط إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المسجل به.`
  String get invitationsHowItWorksDescription {
    return Intl.message(
      'يمكن إرسال الدعوة فقط إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المسجل به.',
      name: 'invitationsHowItWorksDescription',
      desc: '',
      args: [],
    );
  }

  /// `أحدث الردود`
  String get invitationsRecentResponsesTitle {
    return Intl.message(
      'أحدث الردود',
      name: 'invitationsRecentResponsesTitle',
      desc: '',
      args: [],
    );
  }

  /// `دعوة من {name}`
  String invitationSentBy(Object name) {
    return Intl.message(
      'دعوة من $name',
      name: 'invitationSentBy',
      desc: '',
      args: [name],
    );
  }

  /// `تم انضمامك إلى مساحة العمل {workspaceName} بنجاح.`
  String invitationAcceptSuccess(Object workspaceName) {
    return Intl.message(
      'تم انضمامك إلى مساحة العمل $workspaceName بنجاح.',
      name: 'invitationAcceptSuccess',
      desc: '',
      args: [workspaceName],
    );
  }

  /// `تقدر تبدأ الشغل داخل مساحة العمل الآن.`
  String get invitationAcceptDetails {
    return Intl.message(
      'تقدر تبدأ الشغل داخل مساحة العمل الآن.',
      name: 'invitationAcceptDetails',
      desc: '',
      args: [],
    );
  }

  /// `تم رفض دعوتك إلى مساحة العمل {workspaceName}.`
  String invitationDeclineSuccess(Object workspaceName) {
    return Intl.message(
      'تم رفض دعوتك إلى مساحة العمل $workspaceName.',
      name: 'invitationDeclineSuccess',
      desc: '',
      args: [workspaceName],
    );
  }

  /// `رفض الدعوة؟`
  String get invitationDeclineConfirmTitle {
    return Intl.message(
      'رفض الدعوة؟',
      name: 'invitationDeclineConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `سيتم حذف الدعوة للانضمام إلى مساحة العمل {workspaceName}. تقدر تطلب من مالك المساحة يبعتها لك مرة تانية لاحقاً.`
  String invitationDeclineConfirmMessage(Object workspaceName) {
    return Intl.message(
      'سيتم حذف الدعوة للانضمام إلى مساحة العمل $workspaceName. تقدر تطلب من مالك المساحة يبعتها لك مرة تانية لاحقاً.',
      name: 'invitationDeclineConfirmMessage',
      desc: '',
      args: [workspaceName],
    );
  }

  /// `تم إرسال الدعوة بنجاح.`
  String get invitationSentSuccess {
    return Intl.message(
      'تم إرسال الدعوة بنجاح.',
      name: 'invitationSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `دعوة عضو`
  String get inviteMemberTitle {
    return Intl.message(
      'دعوة عضو',
      name: 'inviteMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `ابعت دعوة لمساحة العمل على البريد الإلكتروني لحساب محافظ موجود بالفعل. الشخص المدعو هيلاقيها في شاشة الدعوات.`
  String get inviteMemberDescription {
    return Intl.message(
      'ابعت دعوة لمساحة العمل على البريد الإلكتروني لحساب محافظ موجود بالفعل. الشخص المدعو هيلاقيها في شاشة الدعوات.',
      name: 'inviteMemberDescription',
      desc: '',
      args: [],
    );
  }

  /// `بريد العضو`
  String get inviteMemberEmailLabel {
    return Intl.message(
      'بريد العضو',
      name: 'inviteMemberEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `name@example.com`
  String get inviteMemberEmailHint {
    return Intl.message(
      'name@example.com',
      name: 'inviteMemberEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `إرسال الدعوة`
  String get inviteMemberSendAction {
    return Intl.message(
      'إرسال الدعوة',
      name: 'inviteMemberSendAction',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رقم الموبايل`
  String get errorWalletPhoneNumberRequired {
    return Intl.message(
      'أدخل رقم الموبايل',
      name: 'errorWalletPhoneNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `اختر شركة واحدة على الأقل`
  String get errorWalletProviderRequired {
    return Intl.message(
      'اختر شركة واحدة على الأقل',
      name: 'errorWalletProviderRequired',
      desc: '',
      args: [],
    );
  }

  /// `كل المحافظ المختارة مضافة بالفعل لهذا الرقم.`
  String get errorWalletAllExists {
    return Intl.message(
      'كل المحافظ المختارة مضافة بالفعل لهذا الرقم.',
      name: 'errorWalletAllExists',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم مساحة العمل`
  String get errorWorkspaceNameRequired {
    return Intl.message(
      'أدخل اسم مساحة العمل',
      name: 'errorWorkspaceNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `اختر محفظة واحدة على الأقل`
  String get errorWorkspaceWalletSelectionRequired {
    return Intl.message(
      'اختر محفظة واحدة على الأقل',
      name: 'errorWorkspaceWalletSelectionRequired',
      desc: '',
      args: [],
    );
  }

  /// `لا يمكن حذف مالك مساحة العمل.`
  String get errorWorkspaceOwnerRemovalNotAllowed {
    return Intl.message(
      'لا يمكن حذف مالك مساحة العمل.',
      name: 'errorWorkspaceOwnerRemovalNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `العضو ده مش موجود في مساحة العمل حالياً.`
  String get errorWorkspaceMemberNotFound {
    return Intl.message(
      'العضو ده مش موجود في مساحة العمل حالياً.',
      name: 'errorWorkspaceMemberNotFound',
      desc: '',
      args: [],
    );
  }

  /// `لا يمكنك دعوة نفسك إلى مساحة العمل.`
  String get errorInvitationSelfNotAllowed {
    return Intl.message(
      'لا يمكنك دعوة نفسك إلى مساحة العمل.',
      name: 'errorInvitationSelfNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `في دعوة معلقة بالفعل لهذا البريد الإلكتروني.`
  String get errorInvitationAlreadyPending {
    return Intl.message(
      'في دعوة معلقة بالفعل لهذا البريد الإلكتروني.',
      name: 'errorInvitationAlreadyPending',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني ده غير مرتبط بحساب محافظ.`
  String get errorInvitationUserNotFound {
    return Intl.message(
      'البريد الإلكتروني ده غير مرتبط بحساب محافظ.',
      name: 'errorInvitationUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `هذا المستخدم عضو بالفعل في مساحة العمل.`
  String get errorInvitationUserAlreadyMember {
    return Intl.message(
      'هذا المستخدم عضو بالفعل في مساحة العمل.',
      name: 'errorInvitationUserAlreadyMember',
      desc: '',
      args: [],
    );
  }

  /// `الدعوة دي لم تعد معلقة.`
  String get errorInvitationNotPending {
    return Intl.message(
      'الدعوة دي لم تعد معلقة.',
      name: 'errorInvitationNotPending',
      desc: '',
      args: [],
    );
  }

  /// `استلام`
  String get transactionTypeReceive {
    return Intl.message(
      'استلام',
      name: 'transactionTypeReceive',
      desc: '',
      args: [],
    );
  }

  /// `إرسال`
  String get transactionTypeSend {
    return Intl.message(
      'إرسال',
      name: 'transactionTypeSend',
      desc: '',
      args: [],
    );
  }

  /// `مدفوع`
  String get transactionStatusPaid {
    return Intl.message(
      'مدفوع',
      name: 'transactionStatusPaid',
      desc: '',
      args: [],
    );
  }

  /// `غير مدفوع`
  String get transactionStatusUnpaid {
    return Intl.message(
      'غير مدفوع',
      name: 'transactionStatusUnpaid',
      desc: '',
      args: [],
    );
  }

  /// `آخر المعاملات`
  String get recentTransactions {
    return Intl.message(
      'آخر المعاملات',
      name: 'recentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد معاملات حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا.`
  String get noTransactionsTitle {
    return Intl.message(
      'لا توجد معاملات حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا.',
      name: 'noTransactionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `حذف المحفظة`
  String get deleteWallet {
    return Intl.message(
      'حذف المحفظة',
      name: 'deleteWallet',
      desc: '',
      args: [],
    );
  }

  /// `حذف المحفظة`
  String get deleteWalletConfirmTitle {
    return Intl.message(
      'حذف المحفظة',
      name: 'deleteWalletConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `هل تريد حذف هذه المحفظة؟ لا يمكن التراجع بعد الحذف.`
  String get deleteWalletConfirmMessage {
    return Intl.message(
      'هل تريد حذف هذه المحفظة؟ لا يمكن التراجع بعد الحذف.',
      name: 'deleteWalletConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `جميع المعاملات`
  String get allTransactions {
    return Intl.message(
      'جميع المعاملات',
      name: 'allTransactions',
      desc: '',
      args: [],
    );
  }

  /// `معاملات المحفظة`
  String get walletTransactions {
    return Intl.message(
      'معاملات المحفظة',
      name: 'walletTransactions',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل المحفظة`
  String get walletDetails {
    return Intl.message(
      'تفاصيل المحفظة',
      name: 'walletDetails',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ المعاملات`
  String get transactionsHistory {
    return Intl.message(
      'تاريخ المعاملات',
      name: 'transactionsHistory',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل المعاملة`
  String get transactionDetails {
    return Intl.message(
      'تفاصيل المعاملة',
      name: 'transactionDetails',
      desc: '',
      args: [],
    );
  }

  /// `تم استلام {amount} ج.م`
  String transactionMessageReceive(Object amount) {
    return Intl.message(
      'تم استلام $amount ج.م',
      name: 'transactionMessageReceive',
      desc: '',
      args: [amount],
    );
  }

  /// `تم إرسال {amount} ج.م`
  String transactionMessageSend(Object amount) {
    return Intl.message(
      'تم إرسال $amount ج.م',
      name: 'transactionMessageSend',
      desc: '',
      args: [amount],
    );
  }

  /// `محفظتك`
  String get walletLabel {
    return Intl.message('محفظتك', name: 'walletLabel', desc: '', args: []);
  }

  /// `من`
  String get fromLabel {
    return Intl.message('من', name: 'fromLabel', desc: '', args: []);
  }

  /// `إلى`
  String get toLabel {
    return Intl.message('إلى', name: 'toLabel', desc: '', args: []);
  }

  /// `عبر`
  String get viaLabel {
    return Intl.message('عبر', name: 'viaLabel', desc: '', args: []);
  }

  /// `حالة السداد`
  String get paymentStatus {
    return Intl.message(
      'حالة السداد',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `الكل`
  String get transactions_filter_all {
    return Intl.message(
      'الكل',
      name: 'transactions_filter_all',
      desc: '',
      args: [],
    );
  }

  /// `كل المحافظ`
  String get transactions_filter_allWallets {
    return Intl.message(
      'كل المحافظ',
      name: 'transactions_filter_allWallets',
      desc: '',
      args: [],
    );
  }

  /// `اليوم`
  String get transactions_date_today {
    return Intl.message(
      'اليوم',
      name: 'transactions_date_today',
      desc: '',
      args: [],
    );
  }

  /// `أمس`
  String get transactions_date_yesterday {
    return Intl.message(
      'أمس',
      name: 'transactions_date_yesterday',
      desc: '',
      args: [],
    );
  }

  /// `الأسبوع`
  String get transactions_date_week {
    return Intl.message(
      'الأسبوع',
      name: 'transactions_date_week',
      desc: '',
      args: [],
    );
  }

  /// `الشهر`
  String get transactions_date_month {
    return Intl.message(
      'الشهر',
      name: 'transactions_date_month',
      desc: '',
      args: [],
    );
  }

  /// `نطاق مخصص`
  String get transactions_date_customRange {
    return Intl.message(
      'نطاق مخصص',
      name: 'transactions_date_customRange',
      desc: '',
      args: [],
    );
  }

  /// `عرض المزيد`
  String get transactions_loadMore {
    return Intl.message(
      'عرض المزيد',
      name: 'transactions_loadMore',
      desc: '',
      args: [],
    );
  }

  /// `عرض {count} من أصل {total} معاملة`
  String transactions_viewingCountOfTotal(int count, int total) {
    return Intl.message(
      'عرض $count من أصل $total معاملة',
      name: 'transactions_viewingCountOfTotal',
      desc: '',
      args: [count, total],
    );
  }

  /// `مشاركة إيصال العملية`
  String get transaction_shareReceipt {
    return Intl.message(
      'مشاركة إيصال العملية',
      name: 'transaction_shareReceipt',
      desc: '',
      args: [],
    );
  }

  /// `إيصال معاملة — {type}`
  String transaction_receiptHeader(String type) {
    return Intl.message(
      'إيصال معاملة — $type',
      name: 'transaction_receiptHeader',
      desc: '',
      args: [type],
    );
  }

  /// `المبلغ`
  String get transaction_amount {
    return Intl.message(
      'المبلغ',
      name: 'transaction_amount',
      desc: '',
      args: [],
    );
  }

  /// `المحفظة`
  String get transaction_wallet {
    return Intl.message(
      'المحفظة',
      name: 'transaction_wallet',
      desc: '',
      args: [],
    );
  }

  /// `تم الاستلام من`
  String get transaction_receivedFrom {
    return Intl.message(
      'تم الاستلام من',
      name: 'transaction_receivedFrom',
      desc: '',
      args: [],
    );
  }

  /// `تم الإرسال إلى`
  String get transaction_sentTo {
    return Intl.message(
      'تم الإرسال إلى',
      name: 'transaction_sentTo',
      desc: '',
      args: [],
    );
  }

  /// `التاريخ`
  String get transaction_date {
    return Intl.message(
      'التاريخ',
      name: 'transaction_date',
      desc: '',
      args: [],
    );
  }

  /// `التاريخ والوقت`
  String get transaction_dateTime {
    return Intl.message(
      'التاريخ والوقت',
      name: 'transaction_dateTime',
      desc: '',
      args: [],
    );
  }

  /// `رقم العملية`
  String get transaction_referenceNumber {
    return Intl.message(
      'رقم العملية',
      name: 'transaction_referenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `سجل التعديلات`
  String get transaction_history {
    return Intl.message(
      'سجل التعديلات',
      name: 'transaction_history',
      desc: '',
      args: [],
    );
  }

  /// `تم التحديد كـ {status}`
  String transaction_markedAs(String status) {
    return Intl.message(
      'تم التحديد كـ $status',
      name: 'transaction_markedAs',
      desc: '',
      args: [status],
    );
  }

  /// `بواسطة {name}`
  String transaction_by(String name) {
    return Intl.message(
      'بواسطة $name',
      name: 'transaction_by',
      desc: '',
      args: [name],
    );
  }

  /// `ملاحظات`
  String get transaction_notes {
    return Intl.message(
      'ملاحظات',
      name: 'transaction_notes',
      desc: '',
      args: [],
    );
  }

  /// `إضافة ملاحظة`
  String get transaction_addNote {
    return Intl.message(
      'إضافة ملاحظة',
      name: 'transaction_addNote',
      desc: '',
      args: [],
    );
  }

  /// `اكتب ملاحظتك هنا`
  String get transaction_noteHint {
    return Intl.message(
      'اكتب ملاحظتك هنا',
      name: 'transaction_noteHint',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get transaction_deleteAction {
    return Intl.message(
      'حذف',
      name: 'transaction_deleteAction',
      desc: '',
      args: [],
    );
  }

  /// `حذف الملاحظة`
  String get transaction_deleteNoteTitle {
    return Intl.message(
      'حذف الملاحظة',
      name: 'transaction_deleteNoteTitle',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد أنك تريد حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.`
  String get transaction_deleteNoteMessage {
    return Intl.message(
      'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.',
      name: 'transaction_deleteNoteMessage',
      desc: '',
      args: [],
    );
  }

  /// `تم حذف الملاحظة`
  String get transaction_noteDeleted {
    return Intl.message(
      'تم حذف الملاحظة',
      name: 'transaction_noteDeleted',
      desc: '',
      args: [],
    );
  }

  /// `تراجع`
  String get transaction_undo {
    return Intl.message('تراجع', name: 'transaction_undo', desc: '', args: []);
  }

  /// `تم التعديل`
  String get transaction_edited {
    return Intl.message(
      'تم التعديل',
      name: 'transaction_edited',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get transaction_cancel {
    return Intl.message(
      'إلغاء',
      name: 'transaction_cancel',
      desc: '',
      args: [],
    );
  }

  /// `حفظ`
  String get transaction_save {
    return Intl.message('حفظ', name: 'transaction_save', desc: '', args: []);
  }

  /// `نص الرسالة`
  String get transaction_smsText {
    return Intl.message(
      'نص الرسالة',
      name: 'transaction_smsText',
      desc: '',
      args: [],
    );
  }

  /// `عملية استلام`
  String get transaction_typeReceiveLabel {
    return Intl.message(
      'عملية استلام',
      name: 'transaction_typeReceiveLabel',
      desc: '',
      args: [],
    );
  }

  /// `عملية إرسال`
  String get transaction_typeSendLabel {
    return Intl.message(
      'عملية إرسال',
      name: 'transaction_typeSendLabel',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ`
  String get transaction_errorGeneric {
    return Intl.message(
      'حدث خطأ',
      name: 'transaction_errorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد معاملات مطابقة للفلاتر المحددة`
  String get transactions_emptyWithFilter {
    return Intl.message(
      'لا توجد معاملات مطابقة للفلاتر المحددة',
      name: 'transactions_emptyWithFilter',
      desc: '',
      args: [],
    );
  }

  /// `مسح الفلاتر`
  String get transactions_clearFilters {
    return Intl.message(
      'مسح الفلاتر',
      name: 'transactions_clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `معاملات {name}`
  String transactions_title_wallet(String name) {
    return Intl.message(
      'معاملات $name',
      name: 'transactions_title_wallet',
      desc: '',
      args: [name],
    );
  }

  /// `معاملات {name}`
  String transactions_title_workspace(String name) {
    return Intl.message(
      'معاملات $name',
      name: 'transactions_title_workspace',
      desc: '',
      args: [name],
    );
  }

  /// `يرجى إدخال اسمك`
  String get fullNameValidationEmpty {
    return Intl.message(
      'يرجى إدخال اسمك',
      name: 'fullNameValidationEmpty',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

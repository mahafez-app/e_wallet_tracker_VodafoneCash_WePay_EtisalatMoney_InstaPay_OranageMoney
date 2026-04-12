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

  /// `لا توجد اتصالات إنترنت. يرجى التحقق من شبكتك.`
  String get errorNetwork {
    return Intl.message(
      'لا توجد اتصالات إنترنت. يرجى التحقق من شبكتك.',
      name: 'errorNetwork',
      desc: '',
      args: [],
    );
  }

  /// `المستخدم غير موجود. يرجى التحقق من بيانات الاعتماد الخاصة بك.`
  String get errorAuthUserNotFound {
    return Intl.message(
      'المستخدم غير موجود. يرجى التحقق من بيانات الاعتماد الخاصة بك.',
      name: 'errorAuthUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.`
  String get errorAuthWrongPassword {
    return Intl.message(
      'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.',
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

  /// `عدد محاولات كبير جداً. يرجى المحاولة لاحقاً.`
  String get errorAuthTooManyRequests {
    return Intl.message(
      'عدد محاولات كبير جداً. يرجى المحاولة لاحقاً.',
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

  /// `كلمة المرور ضعيفة جداً. يرجى اختيار كلمة مرور أقوى.`
  String get errorAuthWeakPassword {
    return Intl.message(
      'كلمة المرور ضعيفة جداً. يرجى اختيار كلمة مرور أقوى.',
      name: 'errorAuthWeakPassword',
      desc: '',
      args: [],
    );
  }

  /// `عنوان البريد الإلكتروني غير صحيح.`
  String get errorAuthInvalidEmail {
    return Intl.message(
      'عنوان البريد الإلكتروني غير صحيح.',
      name: 'errorAuthInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `وصول غير مصرح. يرجى تسجيل الدخول مرة أخرى.`
  String get errorUnauthorized {
    return Intl.message(
      'وصول غير مصرح. يرجى تسجيل الدخول مرة أخرى.',
      name: 'errorUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `فشل المصادقة. يرجى المحاولة مرة أخرى.`
  String get errorAuthGeneric {
    return Intl.message(
      'فشل المصادقة. يرجى المحاولة مرة أخرى.',
      name: 'errorAuthGeneric',
      desc: '',
      args: [],
    );
  }

  /// `الوصول ممنوع.`
  String get errorForbidden {
    return Intl.message(
      'الوصول ممنوع.',
      name: 'errorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `المورد غير موجود.`
  String get errorNotFound {
    return Intl.message(
      'المورد غير موجود.',
      name: 'errorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `تضارب المورد. يرجى المحاولة مرة أخرى.`
  String get errorConflict {
    return Intl.message(
      'تضارب المورد. يرجى المحاولة مرة أخرى.',
      name: 'errorConflict',
      desc: '',
      args: [],
    );
  }

  /// `تعذر معالجة طلبك.`
  String get errorUnprocessable {
    return Intl.message(
      'تعذر معالجة طلبك.',
      name: 'errorUnprocessable',
      desc: '',
      args: [],
    );
  }

  /// `خطأ في الخادم. يرجى المحاولة لاحقاً.`
  String get errorServer {
    return Intl.message(
      'خطأ في الخادم. يرجى المحاولة لاحقاً.',
      name: 'errorServer',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ ما. يرجى المحاولة مرة أخرى.`
  String get errorServerGeneric {
    return Intl.message(
      'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
      name: 'errorServerGeneric',
      desc: '',
      args: [],
    );
  }

  /// `تم رفض الإذن.`
  String get errorPermissionDenied {
    return Intl.message(
      'تم رفض الإذن.',
      name: 'errorPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `خطأ في التخزين المحلي. يرجى المحاولة مرة أخرى.`
  String get errorCache {
    return Intl.message(
      'خطأ في التخزين المحلي. يرجى المحاولة مرة أخرى.',
      name: 'errorCache',
      desc: '',
      args: [],
    );
  }

  /// `خطأ في تخزين الملفات.`
  String get errorStorage {
    return Intl.message(
      'خطأ في تخزين الملفات.',
      name: 'errorStorage',
      desc: '',
      args: [],
    );
  }

  /// `فشل التحقق.`
  String get errorValidation {
    return Intl.message(
      'فشل التحقق.',
      name: 'errorValidation',
      desc: '',
      args: [],
    );
  }

  /// `فشل التحقق: {code}`
  String errorValidationWithCode(String code) {
    return Intl.message(
      'فشل التحقق: $code',
      name: 'errorValidationWithCode',
      desc: '',
      args: [code],
    );
  }

  /// `حدث خطأ غير متوقع.`
  String get errorUnknown {
    return Intl.message(
      'حدث خطأ غير متوقع.',
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

  /// `تسجيل الدخول بواسطة جوجل`
  String get signInWithGoogle {
    return Intl.message(
      'تسجيل الدخول بواسطة جوجل',
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

  /// `يرجى تأكيد اسمك للمتابعة`
  String get confirmNameMessage {
    return Intl.message(
      'يرجى تأكيد اسمك للمتابعة',
      name: 'confirmNameMessage',
      desc: '',
      args: [],
    );
  }

  /// `أو`
  String get or {
    return Intl.message('أو', name: 'or', desc: '', args: []);
  }

  /// `إدارة محافظك الخاصة بالأعمال بسهولة`
  String get appTagline {
    return Intl.message(
      'إدارة محافظك الخاصة بالأعمال بسهولة',
      name: 'appTagline',
      desc: '',
      args: [],
    );
  }

  /// `المتابعة باستخدام جوجل`
  String get continueWithGoogle {
    return Intl.message(
      'المتابعة باستخدام جوجل',
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

  /// `اشترك الآن`
  String get signUpNow {
    return Intl.message('اشترك الآن', name: 'signUpNow', desc: '', args: []);
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

  /// `إنشاء حساب جديد للبدء في إدارة أعمالك`
  String get signUpSubtitle {
    return Intl.message(
      'إنشاء حساب جديد للبدء في إدارة أعمالك',
      name: 'signUpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `ما اسمك؟`
  String get whatIsYourName {
    return Intl.message('ما اسمك؟', name: 'whatIsYourName', desc: '', args: []);
  }

  /// `سيظهر اسمك عند تحديث حالة الدفع لتسهيل تتبع العمليات المالية`
  String get nameWillBeDisplayed {
    return Intl.message(
      'سيظهر اسمك عند تحديث حالة الدفع لتسهيل تتبع العمليات المالية',
      name: 'nameWillBeDisplayed',
      desc: '',
      args: [],
    );
  }

  /// `مرحباً بك`
  String get welcome {
    return Intl.message('مرحباً بك', name: 'welcome', desc: '', args: []);
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

  /// `EGP`
  String get egp {
    return Intl.message('EGP', name: 'egp', desc: '', args: []);
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

  /// `يجب أن تكون هذه المحفظة متاحة على هذا الجهاز. التطبيق يقرأ رسائل SMS الجديدة من هذا الهاتف فقط.`
  String get addWalletDescription {
    return Intl.message(
      'يجب أن تكون هذه المحفظة متاحة على هذا الجهاز. التطبيق يقرأ رسائل SMS الجديدة من هذا الهاتف فقط.',
      name: 'addWalletDescription',
      desc: '',
      args: [],
    );
  }

  /// `رقم الهاتف`
  String get phoneNumber {
    return Intl.message('رقم الهاتف', name: 'phoneNumber', desc: '', args: []);
  }

  /// `اختر مزود الخدمة`
  String get chooseProvider {
    return Intl.message(
      'اختر مزود الخدمة',
      name: 'chooseProvider',
      desc: '',
      args: [],
    );
  }

  /// `سماح ومتابعة`
  String get allowAndContinue {
    return Intl.message(
      'سماح ومتابعة',
      name: 'allowAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `ليس الآن`
  String get notNow {
    return Intl.message('ليس الآن', name: 'notNow', desc: '', args: []);
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

  /// `محفظة`
  String get providerUnknown {
    return Intl.message('محفظة', name: 'providerUnknown', desc: '', args: []);
  }

  /// `السماح بالوصول إلى الرسائل والهاتف`
  String get smsPermissionTitle {
    return Intl.message(
      'السماح بالوصول إلى الرسائل والهاتف',
      name: 'smsPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `يحتاج التطبيق إلى صلاحية الرسائل والهاتف لاكتشاف أرقام المحافظ على هذا الجهاز ومزامنة المعاملات تلقائياً.`
  String get smsPermissionDescription {
    return Intl.message(
      'يحتاج التطبيق إلى صلاحية الرسائل والهاتف لاكتشاف أرقام المحافظ على هذا الجهاز ومزامنة المعاملات تلقائياً.',
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

  /// `رصد فوري للمصروفات والمدفوعات فور وصول رسالة البنك.`
  String get smsPermissionAutoUpdateDesc {
    return Intl.message(
      'رصد فوري للمصروفات والمدفوعات فور وصول رسالة البنك.',
      name: 'smsPermissionAutoUpdateDesc',
      desc: '',
      args: [],
    );
  }

  /// `خصوصية تامة`
  String get smsPermissionPrivacyTitle {
    return Intl.message(
      'خصوصية تامة',
      name: 'smsPermissionPrivacyTitle',
      desc: '',
      args: [],
    );
  }

  /// `نقرأ فقط الرسائل المالية وأرقام الهاتف اللازمة لإعداد المحافظ؛ بياناتك مشفرة ولا يتم مشاركتها أبدا.`
  String get smsPermissionPrivacyDesc {
    return Intl.message(
      'نقرأ فقط الرسائل المالية وأرقام الهاتف اللازمة لإعداد المحافظ؛ بياناتك مشفرة ولا يتم مشاركتها أبدا.',
      name: 'smsPermissionPrivacyDesc',
      desc: '',
      args: [],
    );
  }

  /// `إضافة المحفظة`
  String get addWalletAction {
    return Intl.message(
      'إضافة المحفظة',
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

  /// `مساحات العمل تساعدك على تنظيم محافظ النشاط التجاري والتعاون مع الأعضاء الموثوقين من مكان واحد.`
  String get createWorkspaceDescription {
    return Intl.message(
      'مساحات العمل تساعدك على تنظيم محافظ النشاط التجاري والتعاون مع الأعضاء الموثوقين من مكان واحد.',
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

  /// `يمكنك إضافة المحافظ ودعوة الأعضاء بعد إنشاء مساحة العمل.`
  String get createWorkspacePreviewDescription {
    return Intl.message(
      'يمكنك إضافة المحافظ ودعوة الأعضاء بعد إنشاء مساحة العمل.',
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

  /// `أنشئ أول مساحة عمل`
  String get createWorkspaceEmptyTitle {
    return Intl.message(
      'أنشئ أول مساحة عمل',
      name: 'createWorkspaceEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `اجمع محافظ النشاط، وتابع الحركة، وأضف فريقك داخل مساحة مشتركة واحدة.`
  String get createWorkspaceEmptyDescription {
    return Intl.message(
      'اجمع محافظ النشاط، وتابع الحركة، وأضف فريقك داخل مساحة مشتركة واحدة.',
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

  /// `معلومات المساحة`
  String get workspaceSettingsInfoSection {
    return Intl.message(
      'معلومات المساحة',
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

  /// `لا توجد دعوات معلقة لهذه المساحة الآن.`
  String get workspaceSettingsPendingInvitationsEmpty {
    return Intl.message(
      'لا توجد دعوات معلقة لهذه المساحة الآن.',
      name: 'workspaceSettingsPendingInvitationsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `منطقة الخطر`
  String get workspaceSettingsDangerZone {
    return Intl.message(
      'منطقة الخطر',
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

  /// `حدّث الاسم الظاهر للمساحة في كل الشاشات المشتركة.`
  String get workspaceSettingsEditNameDescription {
    return Intl.message(
      'حدّث الاسم الظاهر للمساحة في كل الشاشات المشتركة.',
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

  /// `سيتم حذف جميع البيانات المرتبطة وسجلات الوصول نهائيًا.`
  String get workspaceSettingsDeleteWorkspaceDescription {
    return Intl.message(
      'سيتم حذف جميع البيانات المرتبطة وسجلات الوصول نهائيًا.',
      name: 'workspaceSettingsDeleteWorkspaceDescription',
      desc: '',
      args: [],
    );
  }

  /// `تم تحديث اسم مساحة العمل بنجاح.`
  String get workspaceSettingsNameUpdatedSuccess {
    return Intl.message(
      'تم تحديث اسم مساحة العمل بنجاح.',
      name: 'workspaceSettingsNameUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `تم حذف العضو بنجاح.`
  String get workspaceSettingsMemberRemovedSuccess {
    return Intl.message(
      'تم حذف العضو بنجاح.',
      name: 'workspaceSettingsMemberRemovedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `تم إلغاء الدعوة بنجاح.`
  String get workspaceSettingsInvitationCancelledSuccess {
    return Intl.message(
      'تم إلغاء الدعوة بنجاح.',
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

  /// `سيتم حذف {memberName} من مساحة العمل. يمكنك دعوته مرة أخرى لاحقًا.`
  String workspaceSettingsRemoveMemberConfirmMessage(Object memberName) {
    return Intl.message(
      'سيتم حذف $memberName من مساحة العمل. يمكنك دعوته مرة أخرى لاحقًا.',
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

  /// `سيتم حذف الدعوة المرسلة إلى {email} فورًا.`
  String workspaceSettingsCancelInvitationConfirmMessage(Object email) {
    return Intl.message(
      'سيتم حذف الدعوة المرسلة إلى $email فورًا.',
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

  /// `سيؤدي هذا إلى حذف مساحة العمل وأذونات الأعضاء وروابط المحافظ والدعوات المعلقة نهائيًا.`
  String get workspaceSettingsDeleteWorkspaceConfirmMessage {
    return Intl.message(
      'سيؤدي هذا إلى حذف مساحة العمل وأذونات الأعضاء وروابط المحافظ والدعوات المعلقة نهائيًا.',
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

  /// `اختر المحافظ التي تريد إظهارها في مساحة العمل الآن. يمكنك إضافة المزيد لاحقًا.`
  String get workspaceAddWalletsCreateDescription {
    return Intl.message(
      'اختر المحافظ التي تريد إظهارها في مساحة العمل الآن. يمكنك إضافة المزيد لاحقًا.',
      name: 'workspaceAddWalletsCreateDescription',
      desc: '',
      args: [],
    );
  }

  /// `شارك محافظك الخاصة مع مساحة العمل. المحافظ المرتبطة تصبح مرئية لكل أعضاء مساحة العمل.`
  String get workspaceAddWalletsManageDescription {
    return Intl.message(
      'شارك محافظك الخاصة مع مساحة العمل. المحافظ المرتبطة تصبح مرئية لكل أعضاء مساحة العمل.',
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

  /// `المتابعة إلى مساحة العمل`
  String get workspaceContinueToDetailsAction {
    return Intl.message(
      'المتابعة إلى مساحة العمل',
      name: 'workspaceContinueToDetailsAction',
      desc: '',
      args: [],
    );
  }

  /// `تخطي الآن`
  String get workspaceSkipWalletsAction {
    return Intl.message(
      'تخطي الآن',
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

  /// `مضافة بالفعل`
  String get workspaceWalletAlreadyAdded {
    return Intl.message(
      'مضافة بالفعل',
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

  /// `أضف محفظة أولاً ثم يمكنك مشاركتها مع مساحة العمل.`
  String get workspaceNoOwnedWalletsDescription {
    return Intl.message(
      'أضف محفظة أولاً ثم يمكنك مشاركتها مع مساحة العمل.',
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

  /// `يمكنك المتابعة إلى مساحة العمل أو إضافة محفظة جديدة لاحقًا.`
  String get workspaceAllOwnedWalletsLinkedDescription {
    return Intl.message(
      'يمكنك المتابعة إلى مساحة العمل أو إضافة محفظة جديدة لاحقًا.',
      name: 'workspaceAllOwnedWalletsLinkedDescription',
      desc: '',
      args: [],
    );
  }

  /// `أنت تملك {ownedCount} محافظ، و{linkedCount} منها مرتبطة بالفعل بهذه المساحة.`
  String workspaceWalletSelectionSummary(int ownedCount, int linkedCount) {
    return Intl.message(
      'أنت تملك $ownedCount محافظ، و$linkedCount منها مرتبطة بالفعل بهذه المساحة.',
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

  /// `ستظهر المحافظ المشتركة هنا بعد ربطها بمساحة العمل.`
  String get workspaceWalletsEmptyDescription {
    return Intl.message(
      'ستظهر المحافظ المشتركة هنا بعد ربطها بمساحة العمل.',
      name: 'workspaceWalletsEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `لم ينضم أي أعضاء إلى مساحة العمل بعد.`
  String get workspaceMembersEmpty {
    return Intl.message(
      'لم ينضم أي أعضاء إلى مساحة العمل بعد.',
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

  /// `لا توجد لديك دعوات معلقة لمساحات العمل الآن.`
  String get invitationsEmptyDescription {
    return Intl.message(
      'لا توجد لديك دعوات معلقة لمساحات العمل الآن.',
      name: 'invitationsEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `راجع دعوات مساحات العمل الواردة وحدد قرارك في الوقت المناسب.`
  String get invitationsListDescription {
    return Intl.message(
      'راجع دعوات مساحات العمل الواردة وحدد قرارك في الوقت المناسب.',
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

  /// `بانتظار الرد`
  String get invitationsPendingStatus {
    return Intl.message(
      'بانتظار الرد',
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

  /// `لا يمكن إرسال دعوة مساحة العمل إلا إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المرتبط بالحساب.`
  String get invitationsHowItWorksDescription {
    return Intl.message(
      'لا يمكن إرسال دعوة مساحة العمل إلا إلى حساب محافظ موجود بالفعل باستخدام البريد الإلكتروني المرتبط بالحساب.',
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

  /// `أصبح بإمكانك العمل داخل مساحة العمل الآن.`
  String get invitationAcceptDetails {
    return Intl.message(
      'أصبح بإمكانك العمل داخل مساحة العمل الآن.',
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

  /// `سيتم حذف دعوتك للانضمام إلى مساحة العمل {workspaceName}. يمكنك طلب إعادة إرسال الدعوة لاحقًا.`
  String invitationDeclineConfirmMessage(Object workspaceName) {
    return Intl.message(
      'سيتم حذف دعوتك للانضمام إلى مساحة العمل $workspaceName. يمكنك طلب إعادة إرسال الدعوة لاحقًا.',
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

  /// `أرسل دعوة إلى مساحة العمل عبر البريد الإلكتروني لحساب محافظ موجود بالفعل. سيجدها المستخدم المدعو في شاشة الدعوات.`
  String get inviteMemberDescription {
    return Intl.message(
      'أرسل دعوة إلى مساحة العمل عبر البريد الإلكتروني لحساب محافظ موجود بالفعل. سيجدها المستخدم المدعو في شاشة الدعوات.',
      name: 'inviteMemberDescription',
      desc: '',
      args: [],
    );
  }

  /// `بريد العضو الإلكتروني`
  String get inviteMemberEmailLabel {
    return Intl.message(
      'بريد العضو الإلكتروني',
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

  /// `يرجى إدخال رقم الهاتف`
  String get errorWalletPhoneNumberRequired {
    return Intl.message(
      'يرجى إدخال رقم الهاتف',
      name: 'errorWalletPhoneNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `يرجى اختيار مزود خدمة واحد على الأقل`
  String get errorWalletProviderRequired {
    return Intl.message(
      'يرجى اختيار مزود خدمة واحد على الأقل',
      name: 'errorWalletProviderRequired',
      desc: '',
      args: [],
    );
  }

  /// `جميع المحافظ المختارة مضافة بالفعل لهذا الرقم.`
  String get errorWalletAllExists {
    return Intl.message(
      'جميع المحافظ المختارة مضافة بالفعل لهذا الرقم.',
      name: 'errorWalletAllExists',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال اسم مساحة العمل`
  String get errorWorkspaceNameRequired {
    return Intl.message(
      'يرجى إدخال اسم مساحة العمل',
      name: 'errorWorkspaceNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `يرجى اختيار محفظة واحدة على الأقل`
  String get errorWorkspaceWalletSelectionRequired {
    return Intl.message(
      'يرجى اختيار محفظة واحدة على الأقل',
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

  /// `هذا العضو غير موجود داخل مساحة العمل الآن.`
  String get errorWorkspaceMemberNotFound {
    return Intl.message(
      'هذا العضو غير موجود داخل مساحة العمل الآن.',
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

  /// `توجد دعوة معلقة بالفعل لهذا البريد الإلكتروني.`
  String get errorInvitationAlreadyPending {
    return Intl.message(
      'توجد دعوة معلقة بالفعل لهذا البريد الإلكتروني.',
      name: 'errorInvitationAlreadyPending',
      desc: '',
      args: [],
    );
  }

  /// `هذا البريد الإلكتروني غير مرتبط بأي حساب محافظ.`
  String get errorInvitationUserNotFound {
    return Intl.message(
      'هذا البريد الإلكتروني غير مرتبط بأي حساب محافظ.',
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

  /// `هذه الدعوة لم تعد معلقة.`
  String get errorInvitationNotPending {
    return Intl.message(
      'هذه الدعوة لم تعد معلقة.',
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

  /// `لا توجد معاملات حتى الآن، ستظهر هنا عند وصول رسائل جديدة`
  String get noTransactionsTitle {
    return Intl.message(
      'لا توجد معاملات حتى الآن، ستظهر هنا عند وصول رسائل جديدة',
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

  /// `هل أنت متأكد من رغبتك في حذف هذه المحفظة؟ لا يمكنك التراجع عن هذا الإجراء.`
  String get deleteWalletConfirmMessage {
    return Intl.message(
      'هل أنت متأكد من رغبتك في حذف هذه المحفظة؟ لا يمكنك التراجع عن هذا الإجراء.',
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

  /// `حالة الدفع`
  String get paymentStatus {
    return Intl.message(
      'حالة الدفع',
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

  /// `تحميل المزيد`
  String get transactions_loadMore {
    return Intl.message(
      'تحميل المزيد',
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

  /// `مُستلَم من`
  String get transaction_receivedFrom {
    return Intl.message(
      'مُستلَم من',
      name: 'transaction_receivedFrom',
      desc: '',
      args: [],
    );
  }

  /// `مُرسَل إلى`
  String get transaction_sentTo {
    return Intl.message(
      'مُرسَل إلى',
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

  /// `سجل التغييرات`
  String get transaction_history {
    return Intl.message(
      'سجل التغييرات',
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

  /// `اكتب ملاحظتك هنا…`
  String get transaction_noteHint {
    return Intl.message(
      'اكتب ملاحظتك هنا…',
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

  /// `معاملة استلام`
  String get transaction_typeReceiveLabel {
    return Intl.message(
      'معاملة استلام',
      name: 'transaction_typeReceiveLabel',
      desc: '',
      args: [],
    );
  }

  /// `معاملة إرسال`
  String get transaction_typeSendLabel {
    return Intl.message(
      'معاملة إرسال',
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

  /// `لا توجد معاملات تطابق الفلتر المحدد`
  String get transactions_emptyWithFilter {
    return Intl.message(
      'لا توجد معاملات تطابق الفلتر المحدد',
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

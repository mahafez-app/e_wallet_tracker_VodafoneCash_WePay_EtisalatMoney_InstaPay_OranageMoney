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

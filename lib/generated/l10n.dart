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

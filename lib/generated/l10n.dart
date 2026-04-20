import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// No description provided for @errorAuthUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please check your credentials.'**
  String get errorAuthUserNotFound;

  /// No description provided for @errorAuthWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get errorAuthWrongPassword;

  /// No description provided for @errorAuthEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorAuthEmailInUse;

  /// No description provided for @errorAuthTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get errorAuthTooManyRequests;

  /// No description provided for @errorAuthUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get errorAuthUserDisabled;

  /// No description provided for @errorAuthWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please choose a stronger password.'**
  String get errorAuthWeakPassword;

  /// No description provided for @errorAuthInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get errorAuthInvalidEmail;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access. Please log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorAuthGeneric.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errorAuthGeneric;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'Resource conflict. Please try again.'**
  String get errorConflict;

  /// No description provided for @errorUnprocessable.
  ///
  /// In en, this message translates to:
  /// **'Unable to process your request.'**
  String get errorUnprocessable;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorServerGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorServerGeneric;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied.'**
  String get errorPermissionDenied;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Local storage error. Please try again.'**
  String get errorCache;

  /// No description provided for @errorStorage.
  ///
  /// In en, this message translates to:
  /// **'File storage error.'**
  String get errorStorage;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Validation failed.'**
  String get errorValidation;

  /// No description provided for @errorValidationWithCode.
  ///
  /// In en, this message translates to:
  /// **'Validation failed: {code}'**
  String errorValidationWithCode(String code);

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnknown;

  /// No description provided for @startupFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Just a moment'**
  String get startupFallbackTitle;

  /// No description provided for @startupFallbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try opening Mahafez again.'**
  String get startupFallbackMessage;

  /// No description provided for @startupFallbackRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get startupFallbackRetryAction;

  /// No description provided for @notFoundStatusCode.
  ///
  /// In en, this message translates to:
  /// **'404'**
  String get notFoundStatusCode;

  /// No description provided for @notFoundPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get notFoundPageTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mahafez'**
  String get appName;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get displayName;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get displayNameHint;

  /// No description provided for @confirmName.
  ///
  /// In en, this message translates to:
  /// **'Confirm Name'**
  String get confirmName;

  /// No description provided for @confirmNameMessage.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your name to continue'**
  String get confirmNameMessage;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Manage your business wallets with ease'**
  String get appTagline;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Now'**
  String get signUpNow;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordPlaceholder;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Doe'**
  String get fullNamePlaceholder;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account and start tracking your business'**
  String get signUpSubtitle;

  /// No description provided for @whatIsYourName.
  ///
  /// In en, this message translates to:
  /// **'What is your name?'**
  String get whatIsYourName;

  /// No description provided for @nameWillBeDisplayed.
  ///
  /// In en, this message translates to:
  /// **'This name appears when payment status is updated, making transactions easier to track.'**
  String get nameWillBeDisplayed;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currency;

  /// No description provided for @totalOut.
  ///
  /// In en, this message translates to:
  /// **'Total Out'**
  String get totalOut;

  /// No description provided for @totalIn.
  ///
  /// In en, this message translates to:
  /// **'Total In'**
  String get totalIn;

  /// No description provided for @yourWallets.
  ///
  /// In en, this message translates to:
  /// **'Your Wallets'**
  String get yourWallets;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @workspaces.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get workspaces;

  /// No description provided for @addWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Add Workspace'**
  String get addWorkspace;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWallet;

  /// No description provided for @walletStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get walletStatusActive;

  /// No description provided for @activeWalletsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No active wallets} =1{1 active wallet} few{{count} active wallets} other{{count} active wallets}}'**
  String activeWalletsCount(num count);

  /// No description provided for @activeWalletsHint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{You haven\'t added any wallets yet} =1{Total balance across your wallet} other{Total balance across your {count} wallets}}'**
  String activeWalletsHint(num count);

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just Now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @addWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWalletTitle;

  /// No description provided for @addWalletDescription.
  ///
  /// In en, this message translates to:
  /// **'This wallet must be on this device. The app reads new SMS messages from this phone only.'**
  String get addWalletDescription;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @chooseProvider.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider'**
  String get chooseProvider;

  /// No description provided for @allowAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Allow and Continue'**
  String get allowAndContinue;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @providerOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange Cash'**
  String get providerOrange;

  /// No description provided for @providerVodafone.
  ///
  /// In en, this message translates to:
  /// **'Vodafone Cash'**
  String get providerVodafone;

  /// No description provided for @providerInstapay.
  ///
  /// In en, this message translates to:
  /// **'InstaPay'**
  String get providerInstapay;

  /// No description provided for @providerEtisalat.
  ///
  /// In en, this message translates to:
  /// **'Etisalat Cash'**
  String get providerEtisalat;

  /// No description provided for @providerWePay.
  ///
  /// In en, this message translates to:
  /// **'WE Pay'**
  String get providerWePay;

  /// No description provided for @providerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get providerUnknown;

  /// No description provided for @smsPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Message and Phone Access'**
  String get smsPermissionTitle;

  /// No description provided for @smsPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'The app needs access to messages and phone information to find wallet numbers on this device and sync transactions automatically.'**
  String get smsPermissionDescription;

  /// No description provided for @smsPermissionAutoUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic Update'**
  String get smsPermissionAutoUpdateTitle;

  /// No description provided for @smsPermissionAutoUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Track payments and expenses as soon as the SMS arrives.'**
  String get smsPermissionAutoUpdateDesc;

  /// No description provided for @smsPermissionPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters'**
  String get smsPermissionPrivacyTitle;

  /// No description provided for @smsPermissionPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'We only read financial messages and device phone numbers required for wallet setup; your data is encrypted and never shared.'**
  String get smsPermissionPrivacyDesc;

  /// No description provided for @smsPermissionXiaomiTitle.
  ///
  /// In en, this message translates to:
  /// **'Xiaomi/Redmi Detected'**
  String get smsPermissionXiaomiTitle;

  /// No description provided for @smsPermissionXiaomiDescription.
  ///
  /// In en, this message translates to:
  /// **'To receive transactions when the app is closed, you must enable \'Autostart\' and set Battery Saver to \'No Restrictions\' in app settings.'**
  String get smsPermissionXiaomiDescription;

  /// No description provided for @smsPermissionXiaomiAction.
  ///
  /// In en, this message translates to:
  /// **'Fix in Settings'**
  String get smsPermissionXiaomiAction;

  /// No description provided for @smsPermissionBatteryOptimizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery Optimization Active'**
  String get smsPermissionBatteryOptimizationTitle;

  /// No description provided for @smsPermissionBatteryOptimizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Android may kill the app in the background to save power. To ensure accuracy, please allow the app to run without battery restrictions.'**
  String get smsPermissionBatteryOptimizationDescription;

  /// No description provided for @smsPermissionBatteryOptimizationAction.
  ///
  /// In en, this message translates to:
  /// **'Allow Background Activity'**
  String get smsPermissionBatteryOptimizationAction;

  /// No description provided for @addWalletAction.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWalletAction;

  /// No description provided for @createWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Workspace'**
  String get createWorkspaceTitle;

  /// No description provided for @createWorkspaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Workspaces help you organize your business wallets and share access with trusted members in one place.'**
  String get createWorkspaceDescription;

  /// No description provided for @workspaceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace Name'**
  String get workspaceNameLabel;

  /// No description provided for @workspaceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mobile Store'**
  String get workspaceNameHint;

  /// No description provided for @createWorkspacePreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace Preview'**
  String get createWorkspacePreviewLabel;

  /// No description provided for @createWorkspacePreviewFallback.
  ///
  /// In en, this message translates to:
  /// **'New Workspace'**
  String get createWorkspacePreviewFallback;

  /// No description provided for @createWorkspacePreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'After you create the workspace, you can add wallets and invite members.'**
  String get createWorkspacePreviewDescription;

  /// No description provided for @workspaceOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get workspaceOwner;

  /// No description provided for @workspaceOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get workspaceOwnerBadge;

  /// No description provided for @workspaceMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No members} =1{1 member} other{{count} members}}'**
  String workspaceMembersCount(int count);

  /// No description provided for @workspaceWalletsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No wallets} =1{1 wallet} other{{count} wallets}}'**
  String workspaceWalletsCount(int count);

  /// No description provided for @createWorkspaceAction.
  ///
  /// In en, this message translates to:
  /// **'Create Workspace'**
  String get createWorkspaceAction;

  /// No description provided for @createWorkspaceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first workspace'**
  String get createWorkspaceEmptyTitle;

  /// No description provided for @createWorkspaceEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Bring your wallets together, track activity, and work with your team from one place.'**
  String get createWorkspaceEmptyDescription;

  /// No description provided for @createWalletEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first wallet'**
  String get createWalletEmptyTitle;

  /// No description provided for @createWalletEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect a wallet on this device to start tracking balances and transactions automatically.'**
  String get createWalletEmptyDescription;

  /// No description provided for @workspaceWallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get workspaceWallets;

  /// No description provided for @workspaceMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get workspaceMembers;

  /// No description provided for @workspaceInviteMemberAction.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get workspaceInviteMemberAction;

  /// No description provided for @workspaceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace Settings'**
  String get workspaceSettingsTitle;

  /// No description provided for @workspaceSettingsInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Workspace Info'**
  String get workspaceSettingsInfoSection;

  /// No description provided for @workspaceSettingsInviteByEmailAction.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get workspaceSettingsInviteByEmailAction;

  /// No description provided for @workspaceSettingsPendingInvitationsSection.
  ///
  /// In en, this message translates to:
  /// **'Pending Invitations'**
  String get workspaceSettingsPendingInvitationsSection;

  /// No description provided for @workspaceSettingsPendingInvitationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no pending invitations for this workspace right now.'**
  String get workspaceSettingsPendingInvitationsEmpty;

  /// No description provided for @workspaceSettingsAccessSection.
  ///
  /// In en, this message translates to:
  /// **'Your access'**
  String get workspaceSettingsAccessSection;

  /// No description provided for @workspaceSettingsMemberDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the shared members and linked wallets, remove your own wallets when needed, or leave the workspace.'**
  String get workspaceSettingsMemberDescription;

  /// No description provided for @workspaceSettingsManageAccessAction.
  ///
  /// In en, this message translates to:
  /// **'Manage access'**
  String get workspaceSettingsManageAccessAction;

  /// No description provided for @workspaceSettingsWalletsOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Review every linked wallet in this workspace and remove any wallet that should no longer be shared.'**
  String get workspaceSettingsWalletsOwnerDescription;

  /// No description provided for @workspaceSettingsWalletsMemberDescription.
  ///
  /// In en, this message translates to:
  /// **'You can review every linked wallet here, but you can remove only the wallets you added.'**
  String get workspaceSettingsWalletsMemberDescription;

  /// No description provided for @workspaceSettingsWalletsEmptyOwner.
  ///
  /// In en, this message translates to:
  /// **'There are no linked wallets in this workspace yet.'**
  String get workspaceSettingsWalletsEmptyOwner;

  /// No description provided for @workspaceSettingsWalletsEmptyMember.
  ///
  /// In en, this message translates to:
  /// **'There are no linked wallets in this workspace yet.'**
  String get workspaceSettingsWalletsEmptyMember;

  /// No description provided for @workspaceSettingsWalletOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner: {ownerName}'**
  String workspaceSettingsWalletOwner(Object ownerName);

  /// No description provided for @workspaceUnknownMember.
  ///
  /// In en, this message translates to:
  /// **'Unknown member'**
  String get workspaceUnknownMember;

  /// No description provided for @workspaceSettingsWalletReadOnlyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Only the wallet owner can remove this wallet'**
  String get workspaceSettingsWalletReadOnlyTooltip;

  /// No description provided for @workspaceSettingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Sensitive actions'**
  String get workspaceSettingsDangerZone;

  /// No description provided for @workspaceSettingsEditNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit workspace name'**
  String get workspaceSettingsEditNameTitle;

  /// No description provided for @workspaceSettingsEditNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Update the visible name used across the workspace and shared views.'**
  String get workspaceSettingsEditNameDescription;

  /// No description provided for @workspaceSettingsEditNameAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get workspaceSettingsEditNameAction;

  /// No description provided for @workspaceSettingsRemoveMemberAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get workspaceSettingsRemoveMemberAction;

  /// No description provided for @workspaceSettingsRemoveWalletAction.
  ///
  /// In en, this message translates to:
  /// **'Unlink wallet'**
  String get workspaceSettingsRemoveWalletAction;

  /// No description provided for @workspaceSettingsCancelInvitationAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workspaceSettingsCancelInvitationAction;

  /// No description provided for @workspaceSettingsLeaveWorkspaceAction.
  ///
  /// In en, this message translates to:
  /// **'Leave workspace'**
  String get workspaceSettingsLeaveWorkspaceAction;

  /// No description provided for @workspaceSettingsLeaveWorkspaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Your membership and your linked wallets will be removed from this workspace.'**
  String get workspaceSettingsLeaveWorkspaceDescription;

  /// No description provided for @workspaceSettingsDeleteWorkspaceAction.
  ///
  /// In en, this message translates to:
  /// **'Delete workspace'**
  String get workspaceSettingsDeleteWorkspaceAction;

  /// No description provided for @workspaceSettingsDeleteWorkspaceDescription.
  ///
  /// In en, this message translates to:
  /// **'All linked data and access records will be removed permanently.'**
  String get workspaceSettingsDeleteWorkspaceDescription;

  /// No description provided for @workspaceSettingsNameUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Workspace name updated successfully.'**
  String get workspaceSettingsNameUpdatedSuccess;

  /// No description provided for @workspaceSettingsMemberRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Member removed successfully.'**
  String get workspaceSettingsMemberRemovedSuccess;

  /// No description provided for @workspaceSettingsWalletRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wallet unlinked from the workspace successfully.'**
  String get workspaceSettingsWalletRemovedSuccess;

  /// No description provided for @workspaceSettingsInvitationCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Invitation cancelled successfully.'**
  String get workspaceSettingsInvitationCancelledSuccess;

  /// No description provided for @workspaceSettingsRemoveMemberConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get workspaceSettingsRemoveMemberConfirmTitle;

  /// No description provided for @workspaceSettingsRemoveMemberConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will remove {memberName} from this workspace, and any wallets they linked here will be removed too. They can be invited again later.'**
  String workspaceSettingsRemoveMemberConfirmMessage(Object memberName);

  /// No description provided for @workspaceSettingsRemoveWalletConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlink wallet?'**
  String get workspaceSettingsRemoveWalletConfirmTitle;

  /// No description provided for @workspaceSettingsRemoveWalletConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'The {providerName} wallet linked to {phoneNumber} will be unlinked from this workspace. The wallet itself and its transactions will NOT be deleted.'**
  String workspaceSettingsRemoveWalletConfirmMessage(Object providerName, Object phoneNumber);

  /// No description provided for @workspaceSettingsCancelInvitationConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel invitation?'**
  String get workspaceSettingsCancelInvitationConfirmTitle;

  /// No description provided for @workspaceSettingsCancelInvitationConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'The invitation sent to {email} will be removed immediately.'**
  String workspaceSettingsCancelInvitationConfirmMessage(Object email);

  /// No description provided for @workspaceSettingsLeaveWorkspaceConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave workspace?'**
  String get workspaceSettingsLeaveWorkspaceConfirmTitle;

  /// No description provided for @workspaceSettingsLeaveWorkspaceConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will lose access to this workspace, and the wallets you linked here will be removed from it.'**
  String get workspaceSettingsLeaveWorkspaceConfirmMessage;

  /// No description provided for @workspaceSettingsDeleteWorkspaceConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete workspace?'**
  String get workspaceSettingsDeleteWorkspaceConfirmTitle;

  /// No description provided for @workspaceSettingsDeleteWorkspaceConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the workspace, its member access, wallet links, and pending invitations.'**
  String get workspaceSettingsDeleteWorkspaceConfirmMessage;

  /// No description provided for @workspaceUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace is no longer available'**
  String get workspaceUnavailableTitle;

  /// No description provided for @workspaceUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'It looks like this workspace was deleted or your access was removed. We’ll take you back home.'**
  String get workspaceUnavailableMessage;

  /// No description provided for @workspaceUnavailableAction.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get workspaceUnavailableAction;

  /// No description provided for @userSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get userSettingsTitle;

  /// No description provided for @userSettingsAppSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get userSettingsAppSection;

  /// No description provided for @userSettingsBackgroundSection.
  ///
  /// In en, this message translates to:
  /// **'Background Reliability'**
  String get userSettingsBackgroundSection;

  /// No description provided for @userSettingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get userSettingsAccountSection;

  /// No description provided for @userSettingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get userSettingsAboutSection;

  /// No description provided for @userSettingsNoEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'No email linked to this account'**
  String get userSettingsNoEmailLabel;

  /// No description provided for @userSettingsEditNameAction.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get userSettingsEditNameAction;

  /// No description provided for @userSettingsEditNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get userSettingsEditNameTitle;

  /// No description provided for @userSettingsEditNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Update the name shown across the app and activity history.'**
  String get userSettingsEditNameDescription;

  /// No description provided for @userSettingsEditNameSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get userSettingsEditNameSaveAction;

  /// No description provided for @userSettingsNameUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Name updated successfully.'**
  String get userSettingsNameUpdatedSuccess;

  /// No description provided for @userSettingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get userSettingsThemeTitle;

  /// No description provided for @userSettingsThemeSystemOption.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get userSettingsThemeSystemOption;

  /// No description provided for @userSettingsThemeLightOption.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get userSettingsThemeLightOption;

  /// No description provided for @userSettingsThemeDarkOption.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get userSettingsThemeDarkOption;

  /// No description provided for @userSettingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get userSettingsLanguageTitle;

  /// No description provided for @userSettingsLanguageSystemOption.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get userSettingsLanguageSystemOption;

  /// No description provided for @userSettingsLanguageEnglishOption.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get userSettingsLanguageEnglishOption;

  /// No description provided for @userSettingsLanguageArabicOption.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get userSettingsLanguageArabicOption;

  /// No description provided for @userSettingsFontSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get userSettingsFontSizeTitle;

  /// No description provided for @userSettingsFontSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust the reading scale used across the entire app.'**
  String get userSettingsFontSizeDescription;

  /// No description provided for @userSettingsFontSizeSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get userSettingsFontSizeSaveAction;

  /// No description provided for @userSettingsFontSizePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get userSettingsFontSizePreviewTitle;

  /// No description provided for @userSettingsFontSizePreviewBody.
  ///
  /// In en, this message translates to:
  /// **'Use the slider to make text smaller or larger across Mahafez.'**
  String get userSettingsFontSizePreviewBody;

  /// No description provided for @userSettingsFontSizeCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'Current app size: {value}'**
  String userSettingsFontSizeCurrentValue(String value);

  /// No description provided for @userSettingsFontSizeSmallLabel.
  ///
  /// In en, this message translates to:
  /// **'Smaller'**
  String get userSettingsFontSizeSmallLabel;

  /// No description provided for @userSettingsFontSizeLargeLabel.
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get userSettingsFontSizeLargeLabel;

  /// No description provided for @userSettingsSmsPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS read permission'**
  String get userSettingsSmsPermissionTitle;

  /// No description provided for @userSettingsSmsPermissionCheckingLabel.
  ///
  /// In en, this message translates to:
  /// **'Checking permission status...'**
  String get userSettingsSmsPermissionCheckingLabel;

  /// No description provided for @userSettingsSmsPermissionEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get userSettingsSmsPermissionEnabledLabel;

  /// No description provided for @userSettingsSmsPermissionDisabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Disabled, and the app cannot work without it.'**
  String get userSettingsSmsPermissionDisabledLabel;

  /// No description provided for @userSettingsOpenSystemSettingsAction.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get userSettingsOpenSystemSettingsAction;

  /// No description provided for @userSettingsSignOutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get userSettingsSignOutAction;

  /// No description provided for @userSettingsSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get userSettingsSignOutConfirmTitle;

  /// No description provided for @userSettingsSignOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will end your current session on this device. You can sign in again at any time.'**
  String get userSettingsSignOutConfirmMessage;

  /// No description provided for @userSettingsDeleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get userSettingsDeleteAccountAction;

  /// No description provided for @userSettingsDeleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get userSettingsDeleteAccountConfirmTitle;

  /// No description provided for @userSettingsDeleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a sensitive action and, once fully implemented, will permanently remove data linked to your account.'**
  String get userSettingsDeleteAccountConfirmMessage;

  /// No description provided for @userSettingsDeleteAccountUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account is not available yet'**
  String get userSettingsDeleteAccountUnavailableTitle;

  /// No description provided for @userSettingsDeleteAccountUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'A partial delete would leave linked wallets, workspaces, and invitations behind. This action will be enabled after we add a safe full-data cleanup flow.'**
  String get userSettingsDeleteAccountUnavailableMessage;

  /// No description provided for @userSettingsAppVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get userSettingsAppVersionLabel;

  /// No description provided for @userSettingsWalletsSection.
  ///
  /// In en, this message translates to:
  /// **'Your Wallets'**
  String get userSettingsWalletsSection;

  /// No description provided for @userSettingsWalletsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage the wallets you\'ve added to Mahafez. Deleting a wallet will remove it and all its transactions permanently from all workspaces.'**
  String get userSettingsWalletsDescription;

  /// No description provided for @userSettingsDeleteWalletAction.
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet'**
  String get userSettingsDeleteWalletAction;

  /// No description provided for @userSettingsDeleteWalletConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet?'**
  String get userSettingsDeleteWalletConfirmTitle;

  /// No description provided for @userSettingsDeleteWalletConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this {providerName} wallet ({phoneNumber})? This will permanently remove its transactions and notes, and unlink it from all workspaces. This action cannot be undone.'**
  String userSettingsDeleteWalletConfirmMessage(Object phoneNumber, Object providerName);

  /// No description provided for @userSettingsWalletDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wallet deleted successfully.'**
  String get userSettingsWalletDeletedSuccess;

  /// No description provided for @commonDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDeleteAction;

  /// No description provided for @commonCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancelAction;

  /// No description provided for @workspaceAddWalletsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Wallets'**
  String get workspaceAddWalletsTitle;

  /// No description provided for @workspaceAddWalletsAction.
  ///
  /// In en, this message translates to:
  /// **'Add Wallets'**
  String get workspaceAddWalletsAction;

  /// No description provided for @workspaceAddWalletsCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which of your wallets should appear in this workspace now. You can add more later.'**
  String get workspaceAddWalletsCreateDescription;

  /// No description provided for @workspaceAddWalletsManageDescription.
  ///
  /// In en, this message translates to:
  /// **'Share your own wallets with this workspace. Linked wallets become visible to all workspace members.'**
  String get workspaceAddWalletsManageDescription;

  /// No description provided for @workspaceAddSelectedWalletsAction.
  ///
  /// In en, this message translates to:
  /// **'Add Selected Wallets'**
  String get workspaceAddSelectedWalletsAction;

  /// No description provided for @workspaceContinueToDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'Continue to Workspace'**
  String get workspaceContinueToDetailsAction;

  /// No description provided for @workspaceSkipWalletsAction.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get workspaceSkipWalletsAction;

  /// No description provided for @workspaceWalletAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get workspaceWalletAvailable;

  /// No description provided for @workspaceWalletSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get workspaceWalletSelected;

  /// No description provided for @workspaceWalletAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'Already Added'**
  String get workspaceWalletAlreadyAdded;

  /// No description provided for @workspaceNoOwnedWalletsTitle.
  ///
  /// In en, this message translates to:
  /// **'You do not have any wallets yet'**
  String get workspaceNoOwnedWalletsTitle;

  /// No description provided for @workspaceNoOwnedWalletsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a wallet first, then you can share it with this workspace.'**
  String get workspaceNoOwnedWalletsDescription;

  /// No description provided for @workspaceAllOwnedWalletsLinkedTitle.
  ///
  /// In en, this message translates to:
  /// **'All of your wallets are already linked'**
  String get workspaceAllOwnedWalletsLinkedTitle;

  /// No description provided for @workspaceAllOwnedWalletsLinkedDescription.
  ///
  /// In en, this message translates to:
  /// **'You can continue to the workspace or add a new wallet later.'**
  String get workspaceAllOwnedWalletsLinkedDescription;

  /// No description provided for @workspaceWalletSelectionSummary.
  ///
  /// In en, this message translates to:
  /// **'You own {ownedCount} wallets, and {linkedCount} are already linked to this workspace.'**
  String workspaceWalletSelectionSummary(int ownedCount, int linkedCount);

  /// No description provided for @workspaceWalletsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No wallets linked yet'**
  String get workspaceWalletsEmptyTitle;

  /// No description provided for @workspaceWalletsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This workspace will show shared wallets here once they are linked.'**
  String get workspaceWalletsEmptyDescription;

  /// No description provided for @workspaceMembersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No members have joined this workspace yet.'**
  String get workspaceMembersEmpty;

  /// No description provided for @invitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get invitationsTitle;

  /// No description provided for @invitationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending invitations'**
  String get invitationsEmptyTitle;

  /// No description provided for @invitationsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'You do not have any pending workspace invitations right now.'**
  String get invitationsEmptyDescription;

  /// No description provided for @invitationsListDescription.
  ///
  /// In en, this message translates to:
  /// **'Review your workspace invitations and choose what to do.'**
  String get invitationsListDescription;

  /// No description provided for @invitationsPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No invitations waiting} =1{1 invitation waiting} other{{count} invitations waiting}}'**
  String invitationsPendingCount(int count);

  /// No description provided for @invitationsPendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get invitationsPendingStatus;

  /// No description provided for @invitationsDeletedWorkspaceFallback.
  ///
  /// In en, this message translates to:
  /// **'Deleted workspace'**
  String get invitationsDeletedWorkspaceFallback;

  /// No description provided for @invitationsUnknownInviterFallback.
  ///
  /// In en, this message translates to:
  /// **'Unknown sender'**
  String get invitationsUnknownInviterFallback;

  /// No description provided for @invitationsAcceptAction.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get invitationsAcceptAction;

  /// No description provided for @invitationsDeclineAction.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get invitationsDeclineAction;

  /// No description provided for @invitationsRefreshAction.
  ///
  /// In en, this message translates to:
  /// **'Refresh list'**
  String get invitationsRefreshAction;

  /// No description provided for @invitationsHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How invitations work'**
  String get invitationsHowItWorksTitle;

  /// No description provided for @invitationsHowItWorksDescription.
  ///
  /// In en, this message translates to:
  /// **'Workspace invitations can only be sent to an existing Mahafez account using the email linked to that account.'**
  String get invitationsHowItWorksDescription;

  /// No description provided for @invitationsRecentResponsesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent responses'**
  String get invitationsRecentResponsesTitle;

  /// No description provided for @invitationSentBy.
  ///
  /// In en, this message translates to:
  /// **'Invited by {name}'**
  String invitationSentBy(Object name);

  /// No description provided for @invitationAcceptSuccess.
  ///
  /// In en, this message translates to:
  /// **'You joined {workspaceName} successfully.'**
  String invitationAcceptSuccess(Object workspaceName);

  /// No description provided for @invitationAcceptDetails.
  ///
  /// In en, this message translates to:
  /// **'You can start working in this workspace now.'**
  String get invitationAcceptDetails;

  /// No description provided for @invitationDeclineSuccess.
  ///
  /// In en, this message translates to:
  /// **'You declined the invitation to {workspaceName}.'**
  String invitationDeclineSuccess(Object workspaceName);

  /// No description provided for @invitationDeclineConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline invitation?'**
  String get invitationDeclineConfirmTitle;

  /// No description provided for @invitationDeclineConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will remove the invitation to join {workspaceName}. You can ask the workspace owner to send a new invitation later.'**
  String invitationDeclineConfirmMessage(Object workspaceName);

  /// No description provided for @invitationSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent successfully.'**
  String get invitationSentSuccess;

  /// No description provided for @inviteMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a member'**
  String get inviteMemberTitle;

  /// No description provided for @inviteMemberDescription.
  ///
  /// In en, this message translates to:
  /// **'Send a workspace invitation to an existing Mahafez account by email. The invited user will see it in their invitations inbox.'**
  String get inviteMemberDescription;

  /// No description provided for @inviteMemberEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Member email'**
  String get inviteMemberEmailLabel;

  /// No description provided for @inviteMemberEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get inviteMemberEmailHint;

  /// No description provided for @inviteMemberSendAction.
  ///
  /// In en, this message translates to:
  /// **'Send invitation'**
  String get inviteMemberSendAction;

  /// No description provided for @errorWalletPhoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get errorWalletPhoneNumberRequired;

  /// No description provided for @errorWalletPhoneNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Egyptian mobile number.'**
  String get errorWalletPhoneNumberInvalid;

  /// No description provided for @errorWalletProviderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one provider'**
  String get errorWalletProviderRequired;

  /// No description provided for @errorWalletProviderMismatch.
  ///
  /// In en, this message translates to:
  /// **'This phone number only supports its matching mobile wallet provider and InstaPay.'**
  String get errorWalletProviderMismatch;

  /// No description provided for @errorWalletAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This wallet is already added.'**
  String get errorWalletAlreadyExists;

  /// No description provided for @errorWalletAllExists.
  ///
  /// In en, this message translates to:
  /// **'All selected wallets are already added for this phone number.'**
  String get errorWalletAllExists;

  /// No description provided for @errorManualTransactionMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Paste the SMS text first.'**
  String get errorManualTransactionMessageRequired;

  /// No description provided for @errorManualTransactionUnrecognized.
  ///
  /// In en, this message translates to:
  /// **'This text does not match the selected wallet\'s SMS format.'**
  String get errorManualTransactionUnrecognized;

  /// No description provided for @errorManualTransactionWalletMismatch.
  ///
  /// In en, this message translates to:
  /// **'This SMS points to a different wallet than the one currently open.'**
  String get errorManualTransactionWalletMismatch;

  /// No description provided for @errorWorkspaceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a workspace name'**
  String get errorWorkspaceNameRequired;

  /// No description provided for @errorWorkspaceWalletSelectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one wallet'**
  String get errorWorkspaceWalletSelectionRequired;

  /// No description provided for @errorWorkspaceOwnerRemovalNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'The workspace owner cannot be removed.'**
  String get errorWorkspaceOwnerRemovalNotAllowed;

  /// No description provided for @errorWorkspaceMemberNotFound.
  ///
  /// In en, this message translates to:
  /// **'This member is no longer available in the workspace.'**
  String get errorWorkspaceMemberNotFound;

  /// No description provided for @errorInvitationSelfNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You cannot invite yourself to this workspace.'**
  String get errorInvitationSelfNotAllowed;

  /// No description provided for @errorInvitationAlreadyPending.
  ///
  /// In en, this message translates to:
  /// **'A pending invitation already exists for this email.'**
  String get errorInvitationAlreadyPending;

  /// No description provided for @errorInvitationUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'This email is not linked to any Mahafez account.'**
  String get errorInvitationUserNotFound;

  /// No description provided for @errorInvitationUserAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'This user is already a member of the workspace.'**
  String get errorInvitationUserAlreadyMember;

  /// No description provided for @errorInvitationNotPending.
  ///
  /// In en, this message translates to:
  /// **'This invitation is no longer pending.'**
  String get errorInvitationNotPending;

  /// No description provided for @transactionTypeReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get transactionTypeReceive;

  /// No description provided for @transactionTypeSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get transactionTypeSend;

  /// No description provided for @reportSummaryReceivedTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Received transactions'**
  String get reportSummaryReceivedTransactionsTitle;

  /// No description provided for @reportSummaryReceivedTransactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Number of transactions received during this period.'**
  String get reportSummaryReceivedTransactionsDescription;

  /// No description provided for @reportSummarySentTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sent transactions'**
  String get reportSummarySentTransactionsTitle;

  /// No description provided for @reportSummarySentTransactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Number of transactions sent during this period.'**
  String get reportSummarySentTransactionsDescription;

  /// No description provided for @transactionStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get transactionStatusPaid;

  /// No description provided for @transactionStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get transactionStatusUnpaid;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @transactions_emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactions_emptyTitle;

  /// No description provided for @transactions_emptyWalletDescription.
  ///
  /// In en, this message translates to:
  /// **'This wallet has no transactions yet. New messages will appear here automatically.'**
  String get transactions_emptyWalletDescription;

  /// No description provided for @transactions_emptyWorkspaceDescription.
  ///
  /// In en, this message translates to:
  /// **'This workspace has no transactions yet. Activity from any linked wallet will appear here automatically.'**
  String get transactions_emptyWorkspaceDescription;

  /// No description provided for @workspaceTransactionsCtaDescription.
  ///
  /// In en, this message translates to:
  /// **'Open the full transaction history for this workspace to see all transactions from linked wallets in one place.'**
  String get workspaceTransactionsCtaDescription;

  /// No description provided for @workspaceTransactionsCtaDescriptionWithActivity.
  ///
  /// In en, this message translates to:
  /// **'Open the full transaction history for this workspace to see all transactions from linked wallets in one place.'**
  String get workspaceTransactionsCtaDescriptionWithActivity;

  /// No description provided for @transactions_emptyHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic tracking'**
  String get transactions_emptyHintTitle;

  /// No description provided for @transactions_emptyHintDescription.
  ///
  /// In en, this message translates to:
  /// **'When activity is detected on a connected wallet, we sync it here for you automatically.'**
  String get transactions_emptyHintDescription;

  /// No description provided for @noTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet. New messages will appear here automatically.'**
  String get noTransactionsTitle;

  /// No description provided for @deleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet'**
  String get deleteWallet;

  /// No description provided for @deleteWalletConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet'**
  String get deleteWalletConfirmTitle;

  /// No description provided for @deleteWalletConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this wallet? This action cannot be undone.'**
  String get deleteWalletConfirmMessage;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get allTransactions;

  /// No description provided for @viewAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'View All Transactions'**
  String get viewAllTransactions;

  /// No description provided for @walletTransactions.
  ///
  /// In en, this message translates to:
  /// **'Wallet Transactions'**
  String get walletTransactions;

  /// No description provided for @walletDetails.
  ///
  /// In en, this message translates to:
  /// **'Wallet Details'**
  String get walletDetails;

  /// No description provided for @transactionsHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionsHistory;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @transactionMessageReceive.
  ///
  /// In en, this message translates to:
  /// **'Received {amount} EGP'**
  String transactionMessageReceive(Object amount);

  /// No description provided for @transactionMessageSend.
  ///
  /// In en, this message translates to:
  /// **'Sent {amount} EGP'**
  String transactionMessageSend(Object amount);

  /// No description provided for @walletLabel.
  ///
  /// In en, this message translates to:
  /// **'Your wallet'**
  String get walletLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @viaLabel.
  ///
  /// In en, this message translates to:
  /// **'Via'**
  String get viaLabel;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @transactions_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get transactions_filter_all;

  /// No description provided for @transactions_filter_allWallets.
  ///
  /// In en, this message translates to:
  /// **'All Wallets'**
  String get transactions_filter_allWallets;

  /// No description provided for @transactions_filter_allMembers.
  ///
  /// In en, this message translates to:
  /// **'All Members'**
  String get transactions_filter_allMembers;

  /// No description provided for @transactions_paymentStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get transactions_paymentStatusAll;

  /// No description provided for @transactions_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by last 2+ digits'**
  String get transactions_searchHint;

  /// No description provided for @transactions_date_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get transactions_date_today;

  /// No description provided for @transactions_date_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get transactions_date_yesterday;

  /// No description provided for @transactions_date_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get transactions_date_week;

  /// No description provided for @transactions_date_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get transactions_date_month;

  /// No description provided for @transactions_date_customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get transactions_date_customRange;

  /// No description provided for @transactions_loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get transactions_loadMore;

  /// No description provided for @transactions_viewingCountOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Viewing {count} of {total} transactions'**
  String transactions_viewingCountOfTotal(int count, int total);

  /// No description provided for @transaction_shareReceipt.
  ///
  /// In en, this message translates to:
  /// **'Share Receipt'**
  String get transaction_shareReceipt;

  /// No description provided for @transaction_receiptHeader.
  ///
  /// In en, this message translates to:
  /// **'Transaction Receipt — {type}'**
  String transaction_receiptHeader(String type);

  /// No description provided for @transaction_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transaction_amount;

  /// No description provided for @transaction_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get transaction_wallet;

  /// No description provided for @transaction_receivedFrom.
  ///
  /// In en, this message translates to:
  /// **'Received From'**
  String get transaction_receivedFrom;

  /// No description provided for @transaction_sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent To'**
  String get transaction_sentTo;

  /// No description provided for @transaction_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transaction_date;

  /// No description provided for @transaction_dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get transaction_dateTime;

  /// No description provided for @transaction_referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get transaction_referenceNumber;

  /// No description provided for @transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Change History'**
  String get transaction_history;

  /// No description provided for @transaction_markedAs.
  ///
  /// In en, this message translates to:
  /// **'Marked as {status}'**
  String transaction_markedAs(String status);

  /// No description provided for @transaction_by.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String transaction_by(String name);

  /// No description provided for @transaction_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get transaction_notes;

  /// No description provided for @transaction_addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get transaction_addNote;

  /// No description provided for @transaction_noteHint.
  ///
  /// In en, this message translates to:
  /// **'Write your note here…'**
  String get transaction_noteHint;

  /// No description provided for @transaction_deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get transaction_deleteAction;

  /// No description provided for @transaction_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get transaction_deleteTitle;

  /// No description provided for @transaction_deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction? This action cannot be undone.'**
  String get transaction_deleteMessage;

  /// No description provided for @transaction_deletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transaction_deletedSuccess;

  /// No description provided for @transaction_deleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get transaction_deleteNoteTitle;

  /// No description provided for @transaction_deleteNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this note? This action cannot be undone.'**
  String get transaction_deleteNoteMessage;

  /// No description provided for @transaction_noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get transaction_noteDeleted;

  /// No description provided for @transaction_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get transaction_undo;

  /// No description provided for @transaction_edited.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get transaction_edited;

  /// No description provided for @transaction_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transaction_cancel;

  /// No description provided for @transaction_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get transaction_save;

  /// No description provided for @transaction_smsText.
  ///
  /// In en, this message translates to:
  /// **'SMS Text'**
  String get transaction_smsText;

  /// No description provided for @transaction_typeReceiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Receive Transaction'**
  String get transaction_typeReceiveLabel;

  /// No description provided for @transaction_typeSendLabel.
  ///
  /// In en, this message translates to:
  /// **'Send Transaction'**
  String get transaction_typeSendLabel;

  /// No description provided for @transaction_errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get transaction_errorGeneric;

  /// No description provided for @transactions_emptyWithFilter.
  ///
  /// In en, this message translates to:
  /// **'No transactions match the selected filter'**
  String get transactions_emptyWithFilter;

  /// No description provided for @transactions_emptyWithFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions'**
  String get transactions_emptyWithFilterTitle;

  /// No description provided for @transactions_emptyWithFilterDescription.
  ///
  /// In en, this message translates to:
  /// **'Try clearing one or more filters to see more activity.'**
  String get transactions_emptyWithFilterDescription;

  /// No description provided for @transactions_clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get transactions_clearFilters;

  /// No description provided for @transactions_title_wallet.
  ///
  /// In en, this message translates to:
  /// **'Transactions: {name}'**
  String transactions_title_wallet(String name);

  /// No description provided for @transactions_title_workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace: {name}'**
  String transactions_title_workspace(String name);

  /// No description provided for @workspaceTransactionsTodayCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected Today'**
  String get workspaceTransactionsTodayCollected;

  /// No description provided for @workspaceTransactionsTodaySent.
  ///
  /// In en, this message translates to:
  /// **'Sent Today'**
  String get workspaceTransactionsTodaySent;

  /// No description provided for @workspaceTransactionsUnpaidCount.
  ///
  /// In en, this message translates to:
  /// **'Unpaid Count'**
  String get workspaceTransactionsUnpaidCount;

  /// No description provided for @workspaceTransactionsLatestWallets.
  ///
  /// In en, this message translates to:
  /// **'Latest Active Wallets'**
  String get workspaceTransactionsLatestWallets;

  /// No description provided for @workspaceTransactionsLatestWalletsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No wallet activity yet.'**
  String get workspaceTransactionsLatestWalletsEmpty;

  /// No description provided for @errorTransactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'This transaction is no longer available.'**
  String get errorTransactionNotFound;

  /// No description provided for @errorTransactionAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This transaction has already been tracked.'**
  String get errorTransactionAlreadyExists;

  /// No description provided for @fullNameValidationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get fullNameValidationEmpty;

  /// No description provided for @transactions_filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get transactions_filterTitle;

  /// No description provided for @transactions_filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get transactions_filterApply;

  /// No description provided for @transactions_filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get transactions_filterReset;

  /// No description provided for @transactions_filterActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active {count, plural, =1{filter} other{filters}}'**
  String transactions_filterActiveCount(int count);

  /// No description provided for @transactions_filterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactions_filterType;

  /// No description provided for @transactions_filterPaidStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get transactions_filterPaidStatus;

  /// No description provided for @transactions_filterDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactions_filterDate;

  /// No description provided for @transactions_filterMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get transactions_filterMember;

  /// No description provided for @transactions_filterWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get transactions_filterWallet;

  /// No description provided for @reports_total_transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions Count'**
  String get reports_total_transactions;

  /// No description provided for @reports_all_wallets.
  ///
  /// In en, this message translates to:
  /// **'All Wallets'**
  String get reports_all_wallets;

  /// No description provided for @reports_period_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reports_period_today;

  /// No description provided for @reports_period_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get reports_period_yesterday;

  /// No description provided for @reports_period_lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get reports_period_lastWeek;

  /// No description provided for @reports_period_lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get reports_period_lastMonth;

  /// No description provided for @reports_period_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get reports_period_custom;

  /// No description provided for @reports_stat_average.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get reports_stat_average;

  /// No description provided for @reports_balance_label.
  ///
  /// In en, this message translates to:
  /// **'Net Cash Flow'**
  String get reports_balance_label;

  /// No description provided for @reports_performance_label.
  ///
  /// In en, this message translates to:
  /// **'Financial Performance'**
  String get reports_performance_label;

  /// No description provided for @reports_wallet_title.
  ///
  /// In en, this message translates to:
  /// **'Wallet Reports'**
  String get reports_wallet_title;

  /// No description provided for @reports_workspace_title.
  ///
  /// In en, this message translates to:
  /// **'Workspace Reports'**
  String get reports_workspace_title;

  /// No description provided for @wallet_statsFrom.
  ///
  /// In en, this message translates to:
  /// **'Stats from {date}'**
  String wallet_statsFrom(Object date);

  /// No description provided for @wallet_resetStats.
  ///
  /// In en, this message translates to:
  /// **'Reset Tracked Metrics'**
  String get wallet_resetStats;

  /// No description provided for @wallet_resetStatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the tracked metrics for this wallet? This will zero out your total incoming and outgoing amounts since the last reset. Your current balance will be preserved.'**
  String get wallet_resetStatsDescription;

  /// No description provided for @wallet_resetStatsAction.
  ///
  /// In en, this message translates to:
  /// **'Reset Stats'**
  String get wallet_resetStatsAction;

  /// No description provided for @walletBalanceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Current Balance'**
  String get walletBalanceEditTitle;

  /// No description provided for @walletBalanceEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this if a historical SMS was missed or your tracked balance needs to be corrected manually.'**
  String get walletBalanceEditDescription;

  /// No description provided for @walletBalanceEditAction.
  ///
  /// In en, this message translates to:
  /// **'Update Balance'**
  String get walletBalanceEditAction;

  /// No description provided for @walletBalanceEditHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the latest balance'**
  String get walletBalanceEditHint;

  /// No description provided for @walletBalanceEditInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid balance amount.'**
  String get walletBalanceEditInvalid;

  /// No description provided for @walletBalanceEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Current balance updated.'**
  String get walletBalanceEditSuccess;

  /// No description provided for @walletBalanceEditSuggested.
  ///
  /// In en, this message translates to:
  /// **'Latest detected balance: {amount}'**
  String walletBalanceEditSuggested(Object amount);

  /// No description provided for @walletManualTransactionEntryAction.
  ///
  /// In en, this message translates to:
  /// **'Paste SMS Transaction'**
  String get walletManualTransactionEntryAction;

  /// No description provided for @walletManualTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction From SMS'**
  String get walletManualTransactionTitle;

  /// No description provided for @walletManualTransactionDescription.
  ///
  /// In en, this message translates to:
  /// **'Paste the original transaction SMS here. We will parse it with the same wallet matching and transaction rules used by the automatic SMS flow.'**
  String get walletManualTransactionDescription;

  /// No description provided for @walletManualTransactionFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'SMS text'**
  String get walletManualTransactionFieldLabel;

  /// No description provided for @walletManualTransactionFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the full transaction message'**
  String get walletManualTransactionFieldHint;

  /// No description provided for @walletManualTransactionPasteAction.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get walletManualTransactionPasteAction;

  /// No description provided for @walletManualTransactionAnalyzeAction.
  ///
  /// In en, this message translates to:
  /// **'Process SMS'**
  String get walletManualTransactionAnalyzeAction;

  /// No description provided for @walletManualTransactionSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get walletManualTransactionSaveAction;

  /// No description provided for @walletManualTransactionConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Save to this wallet'**
  String get walletManualTransactionConfirmAction;

  /// No description provided for @walletManualTransactionForceAction.
  ///
  /// In en, this message translates to:
  /// **'Save Anyway'**
  String get walletManualTransactionForceAction;

  /// No description provided for @walletManualTransactionBlockedAction.
  ///
  /// In en, this message translates to:
  /// **'Belongs to another wallet'**
  String get walletManualTransactionBlockedAction;

  /// No description provided for @walletManualTransactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully.'**
  String get walletManualTransactionSaved;

  /// No description provided for @walletManualTransactionReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review before saving'**
  String get walletManualTransactionReviewTitle;

  /// No description provided for @walletManualTransactionReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'The SMS was parsed successfully, but the wallet could not be confirmed with full confidence. Review the details before continuing.'**
  String get walletManualTransactionReviewDescription;

  /// No description provided for @walletManualTransactionExplicitMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'This SMS belongs to another wallet'**
  String get walletManualTransactionExplicitMismatchTitle;

  /// No description provided for @walletManualTransactionExplicitMismatchDescription.
  ///
  /// In en, this message translates to:
  /// **'The message explicitly mentions a wallet phone number that does not match the wallet you opened.'**
  String get walletManualTransactionExplicitMismatchDescription;

  /// No description provided for @walletManualTransactionInferredMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Another wallet looks more likely'**
  String get walletManualTransactionInferredMismatchTitle;

  /// No description provided for @walletManualTransactionInferredMismatchDescription.
  ///
  /// In en, this message translates to:
  /// **'The balance and matching rules suggest a different wallet. Save here only if you are sure this SMS should stay under the current wallet.'**
  String get walletManualTransactionInferredMismatchDescription;

  /// No description provided for @walletManualTransactionSuggestedWalletLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested wallet'**
  String get walletManualTransactionSuggestedWalletLabel;

  /// No description provided for @walletManualTransactionBalanceChip.
  ///
  /// In en, this message translates to:
  /// **'Balance after SMS: {amount}'**
  String walletManualTransactionBalanceChip(Object amount);

  /// No description provided for @walletManualTransactionPhoneChip.
  ///
  /// In en, this message translates to:
  /// **'Mentioned wallet: {phoneNumber}'**
  String walletManualTransactionPhoneChip(Object phoneNumber);

  /// No description provided for @walletSyncTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync missed transactions'**
  String get walletSyncTransactionsTitle;

  /// No description provided for @walletSyncTransactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Check recent SMS messages for transactions that arrived after your latest saved wallet activity.'**
  String get walletSyncTransactionsDescription;

  /// No description provided for @walletSyncTransactionsAction.
  ///
  /// In en, this message translates to:
  /// **'Sync transactions'**
  String get walletSyncTransactionsAction;

  /// No description provided for @walletSyncTransactionsReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review missing transactions'**
  String get walletSyncTransactionsReviewTitle;

  /// No description provided for @walletSyncTransactionsFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No missing transactions found} =1{1 missing transaction found} other{{count} missing transactions found}}'**
  String walletSyncTransactionsFoundCount(int count);

  /// No description provided for @walletSyncTransactionsFromDate.
  ///
  /// In en, this message translates to:
  /// **'Checking messages after {date}'**
  String walletSyncTransactionsFromDate(String date);

  /// No description provided for @walletSyncTransactionsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions selected} =1{1 transaction selected} other{{count} transactions selected}}'**
  String walletSyncTransactionsSelectedCount(int count);

  /// No description provided for @walletSyncTransactionsSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Add selected'**
  String get walletSyncTransactionsSaveAction;

  /// No description provided for @walletSyncTransactionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No missing transactions found'**
  String get walletSyncTransactionsEmptyTitle;

  /// No description provided for @walletSyncTransactionsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'We did not find any unsaved SMS transactions for this wallet in the recent inbox history.'**
  String get walletSyncTransactionsEmptyDescription;

  /// No description provided for @walletSyncTransactionsEmptySinceDescription.
  ///
  /// In en, this message translates to:
  /// **'We did not find any unsaved SMS transactions after {date}.'**
  String walletSyncTransactionsEmptySinceDescription(String date);

  /// No description provided for @walletSyncTransactionsSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction added successfully.} other{{count} transactions added successfully.}}'**
  String walletSyncTransactionsSavedSuccess(int count);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return SAr();
    case 'en': return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

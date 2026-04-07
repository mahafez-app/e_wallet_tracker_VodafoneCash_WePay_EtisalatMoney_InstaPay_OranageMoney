# Phase 1 Implementation — Authentication & User Profile

## ✅ Implementation Complete

This document describes the completed Phase 1 implementation for the Mahafez (محافظ) wallet tracker app.

## 🎯 Phase 1 Goals (All Achieved)

✅ Google Sign-In integration  
✅ Email/Password Sign-In + Sign-Up  
✅ Name confirmation step (`nameConfirmed` flow)  
✅ User profile persistence in `users/{uid}` Firestore collection  
✅ Auth session persistence across app restarts  
✅ First login always completes name confirmation  
✅ `users/{uid}` document creation/update working correctly  

---

## 📁 Architecture Overview

### Domain Layer (`lib/features/auth/domain/`)

**Entities:**
- `AppUser` - Clean domain entity with no Firebase dependencies

**Repositories:**
- `AuthRepository` - Interface defining all auth operations

**Use Cases:**
- `SignInWithGoogleUseCase`
- `SignInWithEmailPasswordUseCase`
- `SignUpWithEmailPasswordUseCase`
- `ConfirmUserNameUseCase`
- `SignOutUseCase`
- `GetUserProfileUseCase`

### Data Layer (`lib/features/auth/data/`)

**Models:**
- `UserDto` - JSON serializable DTO with Firebase Timestamp handling

**Data Sources:**
- `AuthRemoteDataSource` - Handles Firebase Auth + Firestore operations

**Repositories:**
- `AuthRepositoryImpl` - Implements `AuthRepository` interface with error handling

### Presentation Layer (`lib/features/auth/presentation/`)

**Providers:**
- `authStateChangesProvider` - Stream of auth state changes
- `currentUserProvider` - Current user snapshot
- `authNotifierProvider` - State management for auth operations

**Screens:**
- `SignInScreen` - Email/password + Google sign-in
- `SignUpScreen` - New account creation
- `ConfirmNameScreen` - Name confirmation after first login
- `HomeScreen` - Post-auth home with sign-out

---

## 🔐 Authentication Flow

### First Time User (Google)
1. User taps "Sign in with Google"
2. Google OAuth flow completes
3. `users/{uid}` document created with `nameConfirmed: false`
4. Router redirects to `/confirm-name`
5. User confirms/edits display name
6. `nameConfirmed` set to `true` in Firestore
7. Router redirects to `/home`

### First Time User (Email/Password)
1. User navigates to Sign Up screen
2. Enters name, email, password
3. Account created in Firebase Auth
4. `users/{uid}` document created with `nameConfirmed: false`
5. Router redirects to `/confirm-name`
6. User confirms name
7. Router redirects to `/home`

### Returning User
1. App boots → Splash screen shows
2. Firebase Auth session restored automatically
3. `authStateChanges` stream emits user
4. Router checks `nameConfirmed`:
   - If `true` → redirect to `/home`
   - If `false` → redirect to `/confirm-name`

---

## 🗄️ Firestore Schema

### `users/{uid}`
```javascript
{
  "uid": "string",              // Firebase Auth UID
  "displayName": "string",       // User's display name
  "email": "string?",            // Email (null for some OAuth providers)
  "walletNumber": "string?",     // Android phone number (null on iOS)
  "isAndroid": "boolean",        // Device platform
  "nameConfirmed": "boolean",    // Has user completed name confirmation
  "preferredLocale": "string",   // 'system' | 'ar' | 'en'
  "preferredTheme": "string",    // 'system' | 'light' | 'dark'
  "createdAt": "Timestamp",      // Account creation timestamp
  "photoUrl": "string?"          // Profile photo URL (from OAuth)
}
```

---

## 🧪 Testing Instructions

### Manual Testing Checklist

#### ✅ Google Sign-In
1. Run app on device/emulator with Google Play Services
2. Tap "Sign in with Google"
3. Complete Google OAuth flow
4. Verify redirect to Name Confirmation screen
5. Confirm name → verify redirect to Home
6. Close app completely
7. Reopen → verify automatic sign-in to Home (no name confirmation)

#### ✅ Email/Password Sign-Up
1. Tap "Sign Up" from Sign-In screen
2. Enter name, email, password
3. Tap "Create Account"
4. Verify redirect to Name Confirmation screen
5. Confirm name → verify redirect to Home
6. Sign out
7. Sign in with same email/password
8. Verify redirect directly to Home (no name confirmation)

#### ✅ Name Confirmation Flow
1. Create new account (Google or Email)
2. On Name Confirmation screen:
   - Verify pre-filled name from auth provider
   - Edit name if desired
   - Tap "Confirm"
3. Verify Firestore update:
   ```
   users/{uid}.nameConfirmed == true
   users/{uid}.displayName == <confirmed name>
   ```

#### ✅ Session Persistence
1. Sign in with any method
2. Complete name confirmation
3. Navigate to Home
4. Force close app (swipe from recent apps)
5. Reopen app
6. **Expected:** Immediate redirect to Home (no sign-in screen)

#### ✅ Firestore Document Verification
Use Firebase Console → Firestore Database:
1. Sign up new user
2. Check `users/{uid}` document exists
3. Verify all fields populated correctly
4. Confirm name
5. Refresh Firestore → verify `nameConfirmed: true`

---

## 🚀 Running the App

### Prerequisites
- Flutter SDK 3.11.4+
- Firebase project configured (see `firebase_options.dart`)
- Google Sign-In configured for Android/iOS

### Commands
```bash
# Get dependencies
flutter pub get

# Generate code (JSON serialization + localization)
dart run build_runner build -d

# Run app
flutter run

# Analyze code
flutter analyze
```

---

## 🌍 Localization

All user-facing strings support **Arabic (RTL)** and **English (LTR)**:
- Sign In / تسجيل الدخول
- Sign Up / إنشاء حساب
- Confirm Name / تأكيد الاسم
- All error messages localized

Files:
- `lib/l10n/intl_ar.arb`
- `lib/l10n/intl_en.arb`
- Generated: `lib/generated/l10n.dart`

---

## 🔒 Security Rules (Firestore)

**Important:** Ensure your `firestore.rules` allows:
- Users can **read/write their own** `users/{uid}` document
- Users **cannot** modify other users' documents

Example rule:
```javascript
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

---

## 📝 Next Steps (Phase 2)

With authentication complete, the next phase will implement:
- SMS ingestion pipeline (Android)
- Transaction parsing
- Real-time sync to Firestore

---

## 🐛 Known Issues / Limitations

- Google Sign-In requires Google Play Services (Android) / proper iOS setup
- Name confirmation is **mandatory** for all users on first login
- Session expires based on Firebase Auth default settings (can be configured)

---

## 📚 Key Files Reference

| File | Purpose |
|------|---------|
| `lib/features/auth/domain/entities/app_user.dart` | User domain entity |
| `lib/features/auth/data/models/user_dto.dart` | Firestore DTO with serialization |
| `lib/features/auth/data/datasources/auth_remote_data_source.dart` | Firebase operations |
| `lib/features/auth/presentation/providers/auth_providers.dart` | Riverpod providers |
| `lib/features/auth/presentation/providers/auth_notifier.dart` | Auth state management |
| `lib/core/router/app_router.dart` | Auth redirect logic |
| `lib/features/auth/presentation/screens/` | UI screens |

---

**Phase 1 Status:** ✅ **COMPLETE**  
**All exit criteria met.**

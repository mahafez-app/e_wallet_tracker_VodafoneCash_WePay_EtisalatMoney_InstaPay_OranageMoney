# Flutter Wrapper & Engine Utilities
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugins.firebase.core.** { *; }

# Attribute Preservation
-keepattributes Signature,Exceptions,*Annotation*

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Hive
-keep class io.hive.** { *; }
-keep class com.esotericsoftware.** { *; }
-keep class objenesis.** { *; }
-dontwarn io.hive.**

# Telephony Plugin (Background SMS)
-keep class com.shounakmulay.telephony.** { *; }

# Plugin Method Channels
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }

# Google Play Core (Fixes R8 build failure for missing deferred components sub-dependency)
-dontwarn com.google.android.play.core.**

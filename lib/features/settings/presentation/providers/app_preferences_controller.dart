import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_preferences_entity.dart';
import '../../domain/enums/app_language_preference.dart';
import '../../domain/enums/app_theme_preference.dart';
import '../../providers/settings_providers.dart';
import 'app_preferences_state.dart';

final appPreferencesControllerProvider =
    NotifierProvider<AppPreferencesController, AppPreferencesState>(
      AppPreferencesController.new,
    );

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final preference = ref.watch(
    appPreferencesControllerProvider.select(
      (state) => state.preferences.themePreference,
    ),
  );

  return switch (preference) {
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
    AppThemePreference.system => ThemeMode.system,
  };
});

final appLocaleProvider = Provider<Locale?>((ref) {
  final preference = ref.watch(
    appPreferencesControllerProvider.select(
      (state) => state.preferences.languagePreference,
    ),
  );

  return switch (preference) {
    AppLanguagePreference.english => const Locale('en'),
    AppLanguagePreference.arabic => const Locale('ar'),
    AppLanguagePreference.system => null,
  };
});

final class AppPreferencesController extends Notifier<AppPreferencesState> {
  @override
  AppPreferencesState build() {
    unawaited(_loadPreferences());
    return const AppPreferencesState.initial();
  }

  void clearError() {
    state = state.copyWith(failure: null);
  }

  void setThemePreference(AppThemePreference preference) {
    if (state.preferences.themePreference == preference) {
      return;
    }

    final previousPreferences = state.preferences;
    state = state.copyWith(
      preferences: previousPreferences.copyWith(themePreference: preference),
      failure: null,
    );
    unawaited(
      _saveThemePreference(
        preference: preference,
        previousPreferences: previousPreferences,
      ),
    );
  }

  void setLanguagePreference(AppLanguagePreference preference) {
    if (state.preferences.languagePreference == preference) {
      return;
    }

    final previousPreferences = state.preferences;
    state = state.copyWith(
      preferences: previousPreferences.copyWith(languagePreference: preference),
      failure: null,
    );
    unawaited(
      _saveLanguagePreference(
        preference: preference,
        previousPreferences: previousPreferences,
      ),
    );
  }

  Future<void> _loadPreferences() async {
    final result = await ref.read(getAppPreferencesUseCaseProvider)();
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (preferences) => state = state.copyWith(
        preferences: preferences,
        isLoading: false,
        failure: null,
      ),
    );
  }

  Future<void> _saveThemePreference({
    required AppThemePreference preference,
    required AppPreferencesEntity previousPreferences,
  }) async {
    final result = await ref.read(saveThemePreferenceUseCaseProvider)(
      preference,
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => state = state.copyWith(
        preferences: previousPreferences,
        failure: failure,
      ),
      (_) => state = state.copyWith(failure: null),
    );
  }

  Future<void> _saveLanguagePreference({
    required AppLanguagePreference preference,
    required AppPreferencesEntity previousPreferences,
  }) async {
    final result = await ref.read(saveLanguagePreferenceUseCaseProvider)(
      preference,
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => state = state.copyWith(
        preferences: previousPreferences,
        failure: failure,
      ),
      (_) => state = state.copyWith(failure: null),
    );
  }
}

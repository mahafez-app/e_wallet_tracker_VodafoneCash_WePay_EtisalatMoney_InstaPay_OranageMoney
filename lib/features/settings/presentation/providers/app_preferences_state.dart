import '../../../../core/error/failures.dart';
import '../../domain/entities/app_preferences_entity.dart';

const _unsetFailure = Object();

final class AppPreferencesState {
  const AppPreferencesState({
    required this.preferences,
    required this.isLoading,
    required this.failure,
  });

  const AppPreferencesState.initial()
    : preferences = const AppPreferencesEntity.initial(),
      isLoading = true,
      failure = null;

  final AppPreferencesEntity preferences;
  final bool isLoading;
  final Failure? failure;

  AppPreferencesState copyWith({
    AppPreferencesEntity? preferences,
    bool? isLoading,
    Object? failure = _unsetFailure,
  }) {
    return AppPreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      failure: identical(failure, _unsetFailure)
          ? this.failure
          : failure as Failure?,
    );
  }
}

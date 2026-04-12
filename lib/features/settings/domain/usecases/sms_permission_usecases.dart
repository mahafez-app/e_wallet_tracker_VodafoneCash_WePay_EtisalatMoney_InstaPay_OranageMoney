import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

final class RequestSmsPermissionUseCase implements NoParamsUseCase<bool> {
  const RequestSmsPermissionUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<bool>> call() => _repository.requestSmsPermission();
}

final class CheckSmsPermissionUseCase implements NoParamsUseCase<bool> {
  const CheckSmsPermissionUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<bool>> call() => _repository.checkSmsPermission();
}

final class OpenSmsPermissionSettingsUseCase implements NoParamsUseCase<void> {
  const OpenSmsPermissionSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call() => _repository.openSmsPermissionSettings();
}

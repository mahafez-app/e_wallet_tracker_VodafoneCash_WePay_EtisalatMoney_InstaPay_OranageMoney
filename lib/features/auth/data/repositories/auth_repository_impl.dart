import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map(
      (userDto) => userDto?.toEntity(),
    );
  }

  @override
  AppUser? get currentUser {
    final userDto = _remoteDataSource.currentUser;
    return userDto?.toEntity();
  }

  @override
  Future<Result<AppUser>> signInWithGoogle() {
    return executeAndHandleErrors(() async {
      final userDto = await _remoteDataSource.signInWithGoogle();
      return userDto.toEntity();
    }, tag: 'signInWithGoogle');
  }

  @override
  Future<Result<AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return executeAndHandleErrors(() async {
      final userDto = await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return userDto.toEntity();
    }, tag: 'signInWithEmailPassword');
  }

  @override
  Future<Result<AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) {
    return executeAndHandleErrors(() async {
      final userDto = await _remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      return userDto.toEntity();
    }, tag: 'signUpWithEmailPassword');
  }

  @override
  Future<Result<void>> updateDisplayName({
    required String uid,
    required String displayName,
  }) {
    return executeAndHandleErrors(() async {
      await _remoteDataSource.updateDisplayName(
        uid: uid,
        displayName: displayName,
      );
    }, tag: 'updateDisplayName');
  }

  @override
  Future<Result<void>> updateWalletNumbers({
    required String uid,
    required List<String> walletNumbers,
  }) {
    return executeAndHandleErrors(() async {
      await _remoteDataSource.updateWalletNumbers(
        uid: uid,
        walletNumbers: walletNumbers,
      );
    }, tag: 'updateWalletNumbers');
  }

  @override
  Future<Result<void>> signOut() {
    return executeAndHandleErrors(() async {
      await _remoteDataSource.signOut();
    }, tag: 'signOut');
  }

  @override
  Future<Result<AppUser>> getUserProfile(String uid) {
    return executeAndHandleErrors(() async {
      final userDto = await _remoteDataSource.getUserProfile(uid);
      return userDto.toEntity();
    }, tag: 'getUserProfile');
  }
}

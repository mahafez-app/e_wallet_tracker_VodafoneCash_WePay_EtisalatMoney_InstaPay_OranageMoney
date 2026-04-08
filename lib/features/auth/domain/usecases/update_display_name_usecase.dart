import 'package:equatable/equatable.dart';

import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

final class UpdateDisplayNameParams extends Equatable {
  const UpdateDisplayNameParams({required this.uid, required this.displayName});

  final String uid;
  final String displayName;

  @override
  List<Object?> get props => [uid, displayName];
}

class UpdateDisplayNameUseCase
    implements UseCase<void, UpdateDisplayNameParams> {
  const UpdateDisplayNameUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(UpdateDisplayNameParams params) {
    return _repository.updateDisplayName(
      uid: params.uid,
      displayName: params.displayName,
    );
  }
}

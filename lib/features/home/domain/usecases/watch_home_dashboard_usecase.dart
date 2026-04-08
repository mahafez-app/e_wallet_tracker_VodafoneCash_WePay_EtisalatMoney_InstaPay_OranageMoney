import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/home_dashboard_entity.dart';
import '../repositories/home_repository.dart';

class WatchHomeDashboardUseCase
    implements NoParamsStreamUseCase<HomeDashboardEntity> {
  const WatchHomeDashboardUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Stream<Result<HomeDashboardEntity>> call() =>
      _repository.watchHomeDashboard();
}

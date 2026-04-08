import '../../../../core/error/result.dart';
import '../entities/home_dashboard_entity.dart';

abstract interface class HomeRepository {
  Stream<Result<HomeDashboardEntity>> watchHomeDashboard();
}

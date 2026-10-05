import 'package:mahafez_core/mahafez_core.dart';
import '../entities/home_dashboard_entity.dart';

abstract interface class HomeRepository {
  Stream<Result<HomeDashboardEntity>> watchHomeDashboard();
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/home_dashboard_entity.dart';
import '../../providers/home_providers.dart';

final homeDashboardProvider = StreamProvider.autoDispose<HomeDashboardEntity>((
  ref,
) {
  return ref
      .watch(watchHomeDashboardUseCaseProvider)()
      .map(
        (result) =>
            result.fold((failure) => throw failure, (dashboard) => dashboard),
      );
});

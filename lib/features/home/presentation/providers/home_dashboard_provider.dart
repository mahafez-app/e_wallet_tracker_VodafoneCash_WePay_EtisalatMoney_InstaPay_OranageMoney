import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/providers/auth_providers.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../../providers/home_providers.dart';

final homeDashboardProvider = StreamProvider.autoDispose<HomeDashboardEntity>((
  ref,
) {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) {
    return const Stream<HomeDashboardEntity>.empty();
  }

  return ref.watch(watchHomeDashboardUseCaseProvider).call().map((result) {
    return result.fold((failure) => throw failure, (dashboard) => dashboard);
  });
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../events/data/models/event_dto.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Aggregated "Pour vous" feed — spec §11.
///
/// Returns an empty list (no fetch) for unauthenticated users — the strata
/// are derived from the user's bookings/follows/favorites/memberships, so
/// there's nothing to compute server-side without a session.
final personalizedFeedProvider =
    FutureProvider<List<EventDto>>((ref) async {
  final isAuthenticated = ref.watch(
    authProvider.select((s) => s.isAuthenticated),
  );
  if (!isAuthenticated) return const [];
  return ref
      .watch(membershipsRepositoryProvider)
      .getPersonalizedFeed(limit: 8);
});

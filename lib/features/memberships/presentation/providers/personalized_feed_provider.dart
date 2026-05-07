import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/personalized_feed_dto.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Aggregated "Pour vous" feed — spec
/// `docs/PERSONALIZED_FEED_MOBILE_SPEC.md` §3.1 / §4.1.
///
/// Returns [PersonalizedFeedView.empty] (no fetch) for unauthenticated
/// users — the strata are derived from the user's
/// bookings/follows/favorites/memberships, so there's nothing to compute
/// server-side without a session.
///
/// The view exposes both the raw grouped DTO and the deduped,
/// priority-ordered carousel projection ([PersonalizedFeedView.ordered]).
/// Section attribution per entry is the source of truth for badging —
/// see [EventWithSections] and the spec §3.3 / §4.3 caveats on
/// per-event flag reliability.
final personalizedFeedProvider =
    FutureProvider<PersonalizedFeedView>((ref) async {
  final isAuthenticated = ref.watch(
    authProvider.select((s) => s.isAuthenticated),
  );
  if (!isAuthenticated) return PersonalizedFeedView.empty();

  final dto = await ref
      .watch(membershipsRepositoryProvider)
      .getPersonalizedFeed(limit: 8);

  return PersonalizedFeedView(raw: dto, ordered: buildOrdered(dto));
});

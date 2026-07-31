import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
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
abstract class PersonalizedFeedStateController
    extends StateNotifier<AsyncValue<PersonalizedFeedView>> {
  PersonalizedFeedStateController(super.state);

  Future<void> waitForInitialLoad();

  Future<void> refresh();
}

class _PersonalizedFeedController extends PersonalizedFeedStateController {
  _PersonalizedFeedController(
    this._repository, {
    required this.ownerSession,
  }) : super(
          ownerSession.accountId == null
              ? AsyncData(PersonalizedFeedView.empty())
              : const AsyncLoading(),
        ) {
    _initialLoad = ownerSession.accountId == null
        ? Future<void>.value()
        : _load(preservePrevious: false);
    unawaited(_initialLoad);
  }

  final MembershipsRepository _repository;
  final AuthSessionKey ownerSession;
  late final Future<void> _initialLoad;
  Future<void>? _refreshInFlight;
  int _requestGeneration = 0;

  @override
  Future<void> waitForInitialLoad() => _initialLoad;

  Future<void> _load({
    required bool preservePrevious,
    bool rethrowFailure = false,
  }) async {
    if (!mounted || ownerSession.accountId == null) return;
    final generation = ++_requestGeneration;
    final previous = state;
    state = preservePrevious
        ? const AsyncLoading<PersonalizedFeedView>().copyWithPrevious(previous)
        : const AsyncLoading<PersonalizedFeedView>();
    try {
      final dto = await _repository.getPersonalizedFeed(limit: 8);
      if (!mounted || generation != _requestGeneration) return;
      state = AsyncData(
        PersonalizedFeedView(raw: dto, ordered: buildOrdered(dto)),
      );
    } catch (error, stackTrace) {
      if (!mounted || generation != _requestGeneration) return;
      state = preservePrevious
          ? AsyncError<PersonalizedFeedView>(
              error,
              stackTrace,
            ).copyWithPrevious(previous)
          : AsyncError<PersonalizedFeedView>(error, stackTrace);
      if (rethrowFailure) {
        Error.throwWithStackTrace(error, stackTrace);
      }
    }
  }

  @override
  Future<void> refresh() {
    if (ownerSession.accountId == null) return Future<void>.value();
    return _refreshInFlight ??= _load(
      preservePrevious: true,
      rethrowFailure: true,
    ).whenComplete(() {
      _refreshInFlight = null;
    });
  }

  @override
  void dispose() {
    _requestGeneration++;
    super.dispose();
  }
}

final personalizedFeedProvider = StateNotifierProvider.autoDispose<
    PersonalizedFeedStateController, AsyncValue<PersonalizedFeedView>>((ref) {
  final owner = ref.watch(authSessionKeyProvider);
  return _PersonalizedFeedController(
    ref.watch(membershipsRepositoryProvider),
    ownerSession: owner,
  );
});

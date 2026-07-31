import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/organizer_profile_dto.dart';
import '../../domain/repositories/organizer_repository.dart';
import '../../../events/data/models/event_dto.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import 'followed_organizers_providers.dart';

/// Profile fetch keyed by slug-or-uuid and the exact active account.
///
/// Organizer profiles are public, so anonymous users still fetch them. The
/// account boundary matters because `isFollowed` is personalized by the API.
/// Recreating the notifier prevents account A's personalized response from
/// remaining visible while account B's request is in flight.
class OrganizerProfileController
    extends StateNotifier<AsyncValue<OrganizerProfileDto>> {
  OrganizerProfileController(
    this._repository, {
    required this.identifier,
  }) : super(const AsyncValue.loading()) {
    unawaited(_load());
  }

  final OrganizerRepository _repository;
  final String identifier;
  int _requestGeneration = 0;

  Future<void> _load({bool rethrowFailure = false}) async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile(identifier);
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.error(error, stackTrace);
      if (rethrowFailure) Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> refresh() => _load(rethrowFailure: true);
}

final organizerProfileFutureProvider = StateNotifierProvider.autoDispose.family<
    OrganizerProfileController,
    AsyncValue<OrganizerProfileDto>,
    String>((ref, identifier) {
  // `isFollowed` is personalized. The opaque key also catches A -> B -> A.
  ref.watch(authSessionKeyProvider);
  final repository = ref.watch(organizerRepositoryProvider);
  return OrganizerProfileController(
    repository,
    identifier: identifier,
  );
});

// ─── Activities (paginated events) ──────────────────────────────────────────

class OrganizerEventsState {
  final List<EventDto> events;
  final int page;
  final int lastPage;
  final bool isLoadingMore;
  final bool hasLoadMoreError;

  const OrganizerEventsState({
    required this.events,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
    this.hasLoadMoreError = false,
  });

  bool get hasMore => page < lastPage;

  OrganizerEventsState copyWith({
    List<EventDto>? events,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) =>
      OrganizerEventsState(
        events: events ?? this.events,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
      );
}

class OrganizerEventsController
    extends StateNotifier<AsyncValue<OrganizerEventsState>> {
  static const _perPage = 12;

  OrganizerEventsController(
    this._repository, {
    required this.identifier,
    required this.ownerSession,
  }) : super(const AsyncValue.loading()) {
    _initialLoad = _loadFirstPage();
    unawaited(_initialLoad);
  }

  final OrganizerRepository _repository;
  final String identifier;
  final AuthSessionKey ownerSession;
  late final Future<void> _initialLoad;
  int _requestGeneration = 0;

  Future<void> waitForInitialLoad() => _initialLoad;

  Future<void> _loadFirstPage() async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    state = const AsyncLoading();
    try {
      final page = await _repository.getEvents(
        identifier,
        page: 1,
        perPage: _perPage,
      );
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncData(
        OrganizerEventsState(
          events: page.events,
          page: page.page,
          lastPage: page.lastPage,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadMore() => _loadMore();

  Future<void> retryLoadMore() => _loadMore(allowAfterError: true);

  Future<void> _loadMore({bool allowAfterError = false}) async {
    if (!mounted) return;
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        (current.hasLoadMoreError && !allowAfterError)) {
      return;
    }

    final requestGeneration = ++_requestGeneration;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, hasLoadMoreError: false),
    );

    try {
      final next = await _repository.getEvents(
        identifier,
        page: current.page + 1,
        perPage: _perPage,
      );
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncData(
        current.copyWith(
          events: [...current.events, ...next.events],
          page: next.page,
          lastPage: next.lastPage,
          isLoadingMore: false,
          hasLoadMoreError: false,
        ),
      );
    } catch (e, st) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      // Roll back the loading flag but keep the already-loaded events visible.
      state = AsyncData(
        current.copyWith(isLoadingMore: false, hasLoadMoreError: true),
      );
      if (kDebugMode) {
        debugPrint('OrganizerEventsController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> refresh() => _loadFirstPage();
}

final organizerEventsControllerProvider = StateNotifierProvider.autoDispose
    .family<OrganizerEventsController, AsyncValue<OrganizerEventsState>,
        String>((ref, identifier) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repository = ref.watch(organizerRepositoryProvider);
  return OrganizerEventsController(
    repository,
    identifier: identifier,
    ownerSession: ownerSession,
  );
});

// ─── Follow state (optimistic toggle) ───────────────────────────────────────

class FollowState {
  /// `null` while the user is unauthenticated (matches spec §3.3 — `is_followed`
  /// is `null` rather than `false` when there's no token). Treat null as
  /// "show the Follow button as logged-out → tap triggers AuthRequired".
  final bool? isFollowed;
  final int followersCount;
  final bool isInFlight;

  const FollowState({
    required this.isFollowed,
    required this.followersCount,
    this.isInFlight = false,
  });

  FollowState copyWith({
    Object? isFollowed = _unset,
    int? followersCount,
    bool? isInFlight,
  }) =>
      FollowState(
        isFollowed: identical(isFollowed, _unset)
            ? this.isFollowed
            : isFollowed as bool?,
        followersCount: followersCount ?? this.followersCount,
        isInFlight: isInFlight ?? this.isInFlight,
      );

  static const _unset = Object();
}

/// Seeds the follow state from a freshly-loaded account-scoped profile.
class FollowStateController extends StateNotifier<AsyncValue<FollowState>> {
  FollowStateController(
    this._repository,
    this._ref, {
    required this.identifier,
    required AuthSessionKey ownerSession,
    required AuthSessionKey Function() currentSession,
    required AsyncValue<OrganizerProfileDto> profile,
  })  : _ownerSession = ownerSession,
        _currentSession = currentSession,
        super(
          profile.when(
            data: (value) => AsyncValue.data(
              FollowState(
                isFollowed: value.isFollowed,
                followersCount: value.followersCount,
              ),
            ),
            error: AsyncValue.error,
            loading: AsyncValue.loading,
          ),
        );

  final OrganizerRepository _repository;
  final Ref _ref;
  final String identifier;
  final AuthSessionKey _ownerSession;
  final AuthSessionKey Function() _currentSession;
  int _mutationGeneration = 0;
  int _stateRevision = 0;

  bool get _ownsActiveAccount {
    if (!mounted || _ownerSession.accountId == null) return false;
    try {
      return identical(_currentSession(), _ownerSession);
    } catch (_) {
      return false;
    }
  }

  void _publish(AsyncValue<FollowState> next) {
    if (!mounted) return;
    state = next;
    _stateRevision++;
  }

  /// Optimistically toggle follow. The button flips immediately and rolls
  /// back if the API rejects the change.
  ///
  /// Race-condition policy: **ignore taps while a request is in flight**.
  /// The button shows a spinner during this window, so users get visual
  /// feedback that their tap was registered. Queueing felt overkill given
  /// the ~200ms typical roundtrip; cancel-and-replace would create the
  /// possibility of a "successful" intermediate state being lost.
  ///
  /// Error policy: restore the valid snapshot, then rethrow so the initiating
  /// widget can explain which action failed without replacing the profile
  /// state with an error screen.
  Future<void> toggle() async {
    if (!_ownsActiveAccount) {
      throw StateError('The authenticated account changed. Please try again.');
    }
    final snapshot = state.valueOrNull;
    if (snapshot == null) return; // still loading the initial fetch
    if (snapshot.isInFlight) return; // race guard

    // Null `isFollowed` means unauthenticated — callers should have auth-
    // gated already, but treating null as "not yet following" makes the
    // first tap after an inline guest login does the right thing: POST a
    // follow.
    final wasFollowing = snapshot.isFollowed ?? false;
    final mutationGeneration = ++_mutationGeneration;

    // Optimistic flip.
    _publish(AsyncData(snapshot.copyWith(
      isFollowed: !wasFollowing,
      followersCount:
          (snapshot.followersCount + (wasFollowing ? -1 : 1)).clamp(0, 1 << 30),
      isInFlight: true,
    )));
    final optimisticRevision = _stateRevision;

    try {
      final result = wasFollowing
          ? await _repository.unfollow(identifier)
          : await _repository.follow(identifier);
      if (!_ownsActiveAccount || mutationGeneration != _mutationGeneration) {
        return;
      }

      // Reconcile from the server — it's the source of truth, especially
      // for `followersCount` which may have shifted due to other users.
      _publish(AsyncData(FollowState(
        isFollowed: result.isFollowed,
        followersCount: result.followersCount,
        isInFlight: false,
      )));

      // The user's followed-organizers list just changed shape: a new
      // follow adds an item, an unfollow removes one. Invalidate so the
      // next visit to "Organisateurs suivis" refetches from `/me/organizers/following`.
      // Lazy invalidation — costs nothing if the list isn't currently mounted.
      _ref.invalidate(followedOrganizersControllerProvider);
      // Follow signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
    } catch (e, st) {
      if (!_ownsActiveAccount || mutationGeneration != _mutationGeneration) {
        return;
      }
      if (_ownsActiveAccount &&
          mutationGeneration == _mutationGeneration &&
          _stateRevision == optimisticRevision) {
        _publish(AsyncData(snapshot));
      }
      if (kDebugMode) {
        debugPrint('FollowStateController.toggle failed: $e\n$st');
      }
      Error.throwWithStackTrace(e, st);
    }
  }
}

final followStateControllerProvider = StateNotifierProvider.autoDispose
    .family<FollowStateController, AsyncValue<FollowState>, String>(
        (ref, identifier) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repository = ref.watch(organizerRepositoryProvider);
  final profile = ref.watch(organizerProfileFutureProvider(identifier));
  return FollowStateController(
    repository,
    ref,
    identifier: identifier,
    ownerSession: ownerSession,
    currentSession: () => ref.read(authSessionKeyProvider),
    profile: profile,
  );
});

// ─── Auth-gated actions ─────────────────────────────────────────────────────

/// Actions exposed by the organizer profile. Guest flows await their own
/// authentication dialog locally, keyed to the rendered organizer, rather
/// than sharing a replay slot across multiple mounted profiles.
enum PendingOrganizerAction { follow, contact, coordinates, join }

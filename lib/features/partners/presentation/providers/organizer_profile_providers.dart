import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/organizer_profile_dto.dart';
import '../../domain/repositories/organizer_repository.dart';
import '../../../events/data/models/event_dto.dart';
import 'followed_organizers_providers.dart';

/// Profile fetch — `FutureProvider.family` keyed by slug-or-uuid.
///
/// Re-reading the same identifier returns the cached value; call
/// `ref.invalidate(organizerProfileFutureProvider(id))` for pull-to-refresh.
final organizerProfileFutureProvider =
    FutureProvider.family<OrganizerProfileDto, String>(
  (ref, identifier) async {
    return ref.watch(organizerRepositoryProvider).getProfile(identifier);
  },
);

// ─── Activities (paginated events) ──────────────────────────────────────────

class OrganizerEventsState {
  final List<EventDto> events;
  final int page;
  final int lastPage;
  final bool isLoadingMore;

  const OrganizerEventsState({
    required this.events,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
  });

  bool get hasMore => page < lastPage;

  OrganizerEventsState copyWith({
    List<EventDto>? events,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
  }) =>
      OrganizerEventsState(
        events: events ?? this.events,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class OrganizerEventsController
    extends FamilyAsyncNotifier<OrganizerEventsState, String> {
  static const _perPage = 12;

  @override
  Future<OrganizerEventsState> build(String identifier) async {
    final page = await ref
        .watch(organizerRepositoryProvider)
        .getEvents(identifier, page: 1, perPage: _perPage);
    return OrganizerEventsState(
      events: page.events,
      page: page.page,
      lastPage: page.lastPage,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final next = await ref.read(organizerRepositoryProvider).getEvents(
            arg,
            page: current.page + 1,
            perPage: _perPage,
          );
      state = AsyncData(
        current.copyWith(
          events: [...current.events, ...next.events],
          page: next.page,
          lastPage: next.lastPage,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      // Roll back the loading flag but keep the already-loaded events visible.
      state = AsyncData(current.copyWith(isLoadingMore: false));
      if (kDebugMode) {
        debugPrint('OrganizerEventsController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}

final organizerEventsControllerProvider = AsyncNotifierProvider.family<
    OrganizerEventsController, OrganizerEventsState, String>(
  OrganizerEventsController.new,
);

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
        isFollowed:
            identical(isFollowed, _unset) ? this.isFollowed : isFollowed as bool?,
        followersCount: followersCount ?? this.followersCount,
        isInFlight: isInFlight ?? this.isInFlight,
      );

  static const _unset = Object();
}

/// Seeds the follow state from a freshly-loaded profile.
class FollowStateController
    extends FamilyAsyncNotifier<FollowState, String> {
  @override
  Future<FollowState> build(String identifier) async {
    final profile =
        await ref.watch(organizerProfileFutureProvider(identifier).future);
    return FollowState(
      isFollowed: profile.isFollowed,
      followersCount: profile.followersCount,
      isInFlight: false,
    );
  }

  /// Optimistically toggle follow. The button flips immediately, the API
  /// call fires in the background, and on failure we silently roll back.
  ///
  /// Race-condition policy: **ignore taps while a request is in flight**.
  /// The button shows a spinner during this window, so users get visual
  /// feedback that their tap was registered. Queueing felt overkill given
  /// the ~200ms typical roundtrip; cancel-and-replace would create the
  /// possibility of a "successful" intermediate state being lost.
  ///
  /// Error policy: rollback to the pre-toggle snapshot and log in debug.
  /// We deliberately don't rethrow or push the controller into an error
  /// state — the data is still valid (the snapshot), and a transient
  /// network blip shouldn't make the rest of the screen disappear. The
  /// visible "bounce-back" of the button is enough signal for the user to
  /// retry; if they keep failing, that's a real issue worth surfacing
  /// elsewhere (e.g. the global Dio error interceptor handles 401s).
  Future<void> toggle() async {
    final snapshot = state.valueOrNull;
    if (snapshot == null) return; // still loading the initial fetch
    if (snapshot.isInFlight) return; // race guard

    // Null `isFollowed` means unauthenticated — callers should have auth-
    // gated already, but treating null as "not yet following" makes the
    // first-tap-after-login replay (via pendingOrganizerActionProvider)
    // do the right thing: POST a follow.
    final wasFollowing = snapshot.isFollowed ?? false;

    // Optimistic flip.
    state = AsyncData(snapshot.copyWith(
      isFollowed: !wasFollowing,
      followersCount: (snapshot.followersCount + (wasFollowing ? -1 : 1))
          .clamp(0, 1 << 30),
      isInFlight: true,
    ));

    try {
      final repo = ref.read(organizerRepositoryProvider);
      final result = wasFollowing
          ? await repo.unfollow(arg)
          : await repo.follow(arg);

      // Reconcile from the server — it's the source of truth, especially
      // for `followersCount` which may have shifted due to other users.
      state = AsyncData(FollowState(
        isFollowed: result.isFollowed,
        followersCount: result.followersCount,
        isInFlight: false,
      ));

      // The user's followed-organizers list just changed shape: a new
      // follow adds an item, an unfollow removes one. Invalidate so the
      // next visit to "Organisateurs suivis" refetches from `/me/organizers/following`.
      // Lazy invalidation — costs nothing if the list isn't currently mounted.
      ref.invalidate(followedOrganizersControllerProvider);
    } catch (e, st) {
      state = AsyncData(snapshot);
      if (kDebugMode) {
        debugPrint('FollowStateController.toggle failed: $e\n$st');
      }
    }
  }
}

final followStateControllerProvider =
    AsyncNotifierProvider.family<FollowStateController, FollowState, String>(
  FollowStateController.new,
);

// ─── Pending auth-gated action ──────────────────────────────────────────────

/// Which action the user attempted before the auth dialog showed up.
/// After successful login, the screen replays it and clears the state.
enum PendingOrganizerAction { follow, contact, coordinates }

final pendingOrganizerActionProvider =
    StateProvider<PendingOrganizerAction?>((ref) => null);

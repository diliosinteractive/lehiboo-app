import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../partners/presentation/providers/organizer_profile_providers.dart';
import '../../data/models/membership_dto.dart';
import '../../domain/repositories/memberships_repository.dart';
import '../utils/membership_error_mapper.dart';
import 'personalized_feed_provider.dart';
import 'private_events_provider.dart';

/// One fetch of `/me/memberships` covering all statuses; downstream selectors
/// derive everything (per-org lookup, tab counters) from this single source
/// to honor spec §15.4 ("don't make 4 separate calls").
///
/// Returns an empty page for unauthenticated users without hitting the API
/// (the endpoint requires auth and would 401).
class MyMembershipsListController
    extends StateNotifier<AsyncValue<MembershipsPage>> {
  static const _perPage = 50;

  MyMembershipsListController(
    this._repository,
    this._ref, {
    required AuthSessionKey ownerSession,
  })  : _ownerSession = ownerSession,
        super(
          ownerSession.accountId == null
              ? const AsyncValue.data(MembershipsPage(data: []))
              : const AsyncValue.loading(),
        ) {
    if (ownerSession.accountId != null) unawaited(_load());
  }

  final MembershipsRepository _repository;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;
  Future<void>? _currentLoad;

  bool get _ownsActiveSession {
    if (!mounted || _ownerSession.accountId == null) return false;
    try {
      return identical(
        _ref.read(authSessionKeyProvider),
        _ownerSession,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> _load({bool preservePrevious = false}) {
    final load = _performLoad(preservePrevious: preservePrevious);
    _currentLoad = load;
    return load;
  }

  Future<void> _performLoad({required bool preservePrevious}) async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsActiveSession) return;

    final previous = state;
    state = preservePrevious
        ? const AsyncLoading<MembershipsPage>().copyWithPrevious(previous)
        : const AsyncLoading<MembershipsPage>();
    try {
      final memberships = await _repository.getMyMemberships(
        page: 1,
        perPage: _perPage,
      );
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(memberships);
    } catch (error, stackTrace) {
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = preservePrevious
          ? AsyncError<MembershipsPage>(error, stackTrace)
              .copyWithPrevious(previous)
          : AsyncError<MembershipsPage>(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();

  /// Reconciles a server-side membership transition without clearing the
  /// currently rendered status while the request is in flight.
  ///
  /// If a load that predates the reconciliation is already running, wait for
  /// it and then issue a trailing request. Its response may have been captured
  /// before the server-side transition even if it arrives after the signal.
  Future<void> refreshSilently() async {
    if (state.isLoading && !state.hasValue) {
      await waitForCurrentLoad();
      if (!_ownsActiveSession) return;
    }
    await _load(preservePrevious: true);
  }

  Future<void> waitForCurrentLoad() => _currentLoad ?? Future<void>.value();
}

final myMembershipsListProvider = StateNotifierProvider<
    MyMembershipsListController, AsyncValue<MembershipsPage>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repository = ref.watch(membershipsRepositoryProvider);
  return MyMembershipsListController(
    repository,
    ref,
    ownerSession: ownerSession,
  );
});

const Set<String> _membershipStateNotificationTypes = {
  'organization_join_approved',
  'organization_join_rejected',
};

@visibleForTesting
bool isMembershipStateNotificationType(String? type) =>
    type != null &&
    _membershipStateNotificationTypes.contains(type.trim().toLowerCase());

/// Reconciles externally-triggered membership changes (vendor approval or
/// rejection) with the API, which remains the source of truth.
///
/// OneSignal and the realtime notification channel can both report the same
/// transition. [_inFlight] coalesces those signals into a single request.
class MembershipStateSyncCoordinator {
  MembershipStateSyncCoordinator(
    this._ref, {
    required AuthSessionKey ownerSession,
  }) : _ownerSession = ownerSession;

  final Ref _ref;
  final AuthSessionKey _ownerSession;
  Future<void>? _inFlight;

  bool get _ownsActiveSession =>
      _ownerSession.accountId != null &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession);

  Future<void> reconcileFromNotification(String? type) {
    if (!isMembershipStateNotificationType(type)) {
      return Future<void>.value();
    }
    return reconcile();
  }

  Future<void> reconcile() {
    if (!_ownsActiveSession) return Future<void>.value();
    final current = _inFlight;
    if (current != null) return current;

    late final Future<void> task;
    task = _performReconciliation().whenComplete(() {
      if (identical(_inFlight, task)) _inFlight = null;
    });
    _inFlight = task;
    return task;
  }

  Future<void> _performReconciliation() async {
    // Membership changes alter access to private events everywhere they are
    // surfaced, as well as the join-status button.
    _ref.invalidate(personalizedFeedProvider);
    _ref.invalidate(privateEventsControllerProvider);
    _ref.invalidate(organizerEventsControllerProvider);
    await _ref.read(myMembershipsListProvider.notifier).refreshSilently();
  }
}

final membershipStateSyncProvider = Provider<MembershipStateSyncCoordinator>(
  (ref) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    return MembershipStateSyncCoordinator(
      ref,
      ownerSession: ownerSession,
    );
  },
);

/// Lookup of "my membership row for org X" derived from the cached list.
///
/// Returns `null` when there's no membership record (user can request to
/// join), or when the list is still loading.
final myMembershipForOrgProvider =
    Provider.family<MembershipDto?, String>((ref, orgUuid) {
  final list = ref.watch(myMembershipsListProvider).valueOrNull;
  if (list == null) return null;
  for (final m in list.data) {
    if (m.organization?.uuid == orgUuid) return m;
  }
  return null;
});

/// In-flight indicator for join/cancel/leave on a single org. Lets the button
/// show a spinner without flashing the whole list.
class MembershipAction {
  final bool isInFlight;
  final String? error;

  const MembershipAction({this.isInFlight = false, this.error});
}

class MembershipActionController
    extends StateNotifier<AsyncValue<MembershipAction>> {
  MembershipActionController(
    this._repository,
    this._ref, {
    required String organizationUuid,
    required AuthSessionKey ownerSession,
  })  : _organizationUuid = organizationUuid,
        _ownerSession = ownerSession,
        super(const AsyncValue.data(MembershipAction()));

  final MembershipsRepository _repository;
  final Ref _ref;
  final String _organizationUuid;
  final AuthSessionKey _ownerSession;

  bool get _ownsActiveSession {
    if (!mounted || _ownerSession.accountId == null) return false;
    try {
      return identical(
        _ref.read(authSessionKeyProvider),
        _ownerSession,
      );
    } catch (_) {
      return false;
    }
  }

  /// `POST /organizations/{uuid}/membership-request` — used for both initial
  /// join requests and re-applications after rejection.
  Future<bool> requestJoin({required String fallbackMessage}) async {
    if (!_ownsActiveSession) return false;
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return false;
    state = const AsyncData(MembershipAction(isInFlight: true));

    _ref.read(analyticsServiceProvider).logEvent(
      AnalyticsEvent.membershipJoinStarted,
      params: {AnalyticsParam.organizationId: _organizationUuid},
    );

    try {
      await _repository.requestMembership(_organizationUuid);
      if (!_ownsActiveSession) return false;
      _ref.invalidate(myMembershipsListProvider);
      // Membership signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
      state = const AsyncData(MembershipAction());
      _ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.membershipJoinCompleted,
        params: {AnalyticsParam.organizationId: _organizationUuid},
      );
      return true;
    } catch (e, st) {
      if (!_ownsActiveSession) return false;
      state = AsyncData(
        MembershipAction(
          error: MembershipErrorMapper.actionMessage(
            e,
            fallback: fallbackMessage,
          ),
        ),
      );
      if (kDebugMode) {
        debugPrint('MembershipActionController.requestJoin failed: $e\n$st');
      }
      // 422 = "already pending or active" → we re-fetch so the UI reflects
      // the actual server state instead of showing a stale error.
      _ref.invalidate(myMembershipsListProvider);
      return false;
    }
  }

  /// `DELETE /organizations/{uuid}/membership-request` — covers cancel
  /// (when pending) and leave (when active). The server picks the right
  /// transition based on the current row state.
  Future<bool> cancelOrLeave({required String fallbackMessage}) async {
    if (!_ownsActiveSession) return false;
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return false;
    state = const AsyncData(MembershipAction(isInFlight: true));

    try {
      await _repository.cancelOrLeaveMembership(_organizationUuid);
      if (!_ownsActiveSession) return false;
      _ref.invalidate(myMembershipsListProvider);
      // Membership signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
      state = const AsyncData(MembershipAction());
      return true;
    } catch (e, st) {
      if (!_ownsActiveSession) return false;
      state = AsyncData(
        MembershipAction(
          error: MembershipErrorMapper.actionMessage(
            e,
            fallback: fallbackMessage,
          ),
        ),
      );
      if (kDebugMode) {
        debugPrint('MembershipActionController.cancelOrLeave failed: $e\n$st');
      }
      return false;
    }
  }
}

final membershipActionControllerProvider = StateNotifierProvider.family<
    MembershipActionController, AsyncValue<MembershipAction>, String>(
  (ref, organizationUuid) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    final repository = ref.watch(membershipsRepositoryProvider);
    return MembershipActionController(
      repository,
      ref,
      organizationUuid: organizationUuid,
      ownerSession: ownerSession,
    );
  },
);

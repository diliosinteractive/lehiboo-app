import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/membership_dto.dart';
import '../../domain/repositories/memberships_repository.dart';
import '../utils/membership_error_mapper.dart';
import 'membership_content_revision_provider.dart';
import 'personalized_feed_provider.dart';

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
  'organization_membership_revoked',
};

@visibleForTesting
bool isMembershipStateNotificationType(String? type) =>
    _normalizedMembershipStateNotificationType(type) != null;

String? _normalizedMembershipStateNotificationType(String? type) {
  if (type == null) return null;
  final normalized = type.trim().toLowerCase();
  return _membershipStateNotificationTypes.contains(normalized)
      ? normalized
      : null;
}

String? _membershipOrganizationIdentity(Map<String, dynamic> data) {
  for (final field in const [
    'organization_id',
    'organization_uuid',
    'organization_slug',
  ]) {
    final value = data[field]?.toString().trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return null;
}

@immutable
class _MembershipTransitionKey {
  const _MembershipTransitionKey({
    required this.type,
    required this.organizationIdentity,
  });

  final String type;
  final String organizationIdentity;

  @override
  bool operator ==(Object other) =>
      other is _MembershipTransitionKey &&
      other.type == type &&
      other.organizationIdentity == organizationIdentity;

  @override
  int get hashCode => Object.hash(type, organizationIdentity);
}

/// Reconciles externally-triggered membership changes (approval, rejection,
/// or revocation) with the API, which remains the source of truth.
///
/// OneSignal and the realtime notification channel can both report the same
/// transition. Duplicate type/organization pairs share the active request,
/// while a distinct transition received in flight schedules one trailing
/// reconciliation so its server state cannot be missed.
///
/// [reconcile] is the foreground check: it reports no transition, so the
/// membership-gated content is only refreshed when the memberships differ
/// from the ones it was built with.
class MembershipStateSyncCoordinator {
  MembershipStateSyncCoordinator(
    this._ref, {
    required AuthSessionKey ownerSession,
  }) : _ownerSession = ownerSession;

  final Ref _ref;
  final AuthSessionKey _ownerSession;
  Future<void>? _inFlight;
  final Set<_MembershipTransitionKey> _activeTransitions = {};
  final Set<_MembershipTransitionKey> _pendingTransitions = {};
  bool _pendingUnidentifiedTransition = false;
  bool _pendingCheck = false;

  /// The memberships the membership-gated content was built with, as of the
  /// last reconciliation. Null until the first one of this session.
  Set<String>? _contentMemberships;

  bool get _ownsActiveSession =>
      _ownerSession.accountId != null &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession);

  Future<void> reconcileFromNotification(
    String? type, {
    Map<String, dynamic> data = const {},
  }) {
    final normalizedType = _normalizedMembershipStateNotificationType(type);
    if (normalizedType == null) {
      return Future<void>.value();
    }
    final organizationIdentity = _membershipOrganizationIdentity(data);
    return _requestReconciliation(
      organizationIdentity == null
          ? null
          : _MembershipTransitionKey(
              type: normalizedType,
              organizationIdentity: organizationIdentity,
            ),
    );
  }

  /// Looks for membership changes made while the app was in the background
  /// (realtime disconnected, push not opened), on return to the foreground.
  Future<void> reconcile() {
    if (!_ownsActiveSession) return Future<void>.value();
    // A reconciliation in flight already fetches and compares the memberships.
    final current = _inFlight;
    if (current != null) return current;
    _pendingCheck = true;
    return _startReconciliations();
  }

  Future<void> _requestReconciliation(
    _MembershipTransitionKey? transition,
  ) {
    if (!_ownsActiveSession) return Future<void>.value();
    // Membership changes alter access to private events everywhere they are
    // surfaced, as well as the join-status button. A notification reports
    // one, so the cached content goes at once, even while a foreground check
    // is still in flight. A duplicate of a transition in hand shares it.
    if (_queueTransition(transition)) {
      _ref.read(membershipContentRevisionProvider.notifier).advance();
    }
    return _inFlight ?? _startReconciliations();
  }

  Future<void> _startReconciliations() {
    late final Future<void> task;
    task = _drainReconciliations().whenComplete(() {
      if (!identical(_inFlight, task)) return;
      _inFlight = null;
      _activeTransitions.clear();
      _pendingTransitions.clear();
      _pendingUnidentifiedTransition = false;
      _pendingCheck = false;
    });
    _inFlight = task;
    return task;
  }

  /// Queues [transition] for a reconciliation; false for a duplicate of one
  /// already active or pending.
  bool _queueTransition(_MembershipTransitionKey? transition) {
    if (transition == null) {
      // Without an organization identity we cannot prove two signals describe
      // the same transition, so conservatively schedule trailing work.
      _pendingUnidentifiedTransition = true;
      return true;
    }
    if (_activeTransitions.contains(transition)) return false;
    return _pendingTransitions.add(transition);
  }

  Future<void> _drainReconciliations() async {
    while (_ownsActiveSession &&
        (_pendingCheck ||
            _pendingUnidentifiedTransition ||
            _pendingTransitions.isNotEmpty)) {
      final signalled =
          _pendingUnidentifiedTransition || _pendingTransitions.isNotEmpty;
      _activeTransitions
        ..clear()
        ..addAll(_pendingTransitions);
      _pendingTransitions.clear();
      _pendingUnidentifiedTransition = false;
      _pendingCheck = false;
      await _performReconciliation(signalled: signalled);
    }
  }

  Future<void> _performReconciliation({required bool signalled}) async {
    // What the content was built with: the memberships of the last
    // reconciliation, else those already cached before this refresh.
    final cached = _ref.read(myMembershipsListProvider).valueOrNull;
    final builtWith = _contentMemberships ??
        (cached == null ? null : _accessFingerprint(cached));

    await _ref.read(myMembershipsListProvider.notifier).refreshSilently();
    if (!_ownsActiveSession) return;

    final fetched = _ref.read(myMembershipsListProvider);
    if (fetched.hasError || fetched.isLoading || !fetched.hasValue) return;
    final page = fetched.requireValue;
    final memberships = _accessFingerprint(page);
    _contentMemberships = memberships;
    // A notification already moved the revision when it came in.
    if (signalled) return;

    // Every membership-gated list watches the revision and reloads when it
    // moves, so a foreground check only moves it on a real change. With
    // nothing to compare with (the list was never loaded this session), the
    // check only records the memberships. Past the first page, a status
    // change at a constant count would go unseen: a partial list cannot prove
    // nothing changed.
    final partial = (page.meta?.total ?? page.data.length) > page.data.length;
    final changed = builtWith != null && !setEquals(builtWith, memberships);
    if (partial || changed) {
      _ref.read(membershipContentRevisionProvider.notifier).advance();
    }
  }
}

/// What gives access to member content: the organizations of the account,
/// with status and role. Display fields (names, logos, dates) are left out, so
/// a fresh copy of the same memberships compares equal.
Set<String> _accessFingerprint(MembershipsPage page) => {
      for (final membership in page.data)
        [
          membership.id,
          membership.organization?.uuid ??
              membership.organization?.id ??
              membership.organization?.slug,
          membership.status.name,
          membership.role?.name,
          membership.isActive,
        ].join('|'),
      'total:${page.meta?.total}',
    };

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

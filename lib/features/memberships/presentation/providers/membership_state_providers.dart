import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/membership_dto.dart';
import '../../domain/repositories/memberships_repository.dart';
import '../utils/membership_error_mapper.dart';
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

  Future<void> _load() {
    final load = _performLoad();
    _currentLoad = load;
    return load;
  }

  Future<void> _performLoad() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsActiveSession) return;

    state = const AsyncLoading();
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
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();

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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../checkin/presentation/providers/managed_organizations_provider.dart';
import '../../../profile/data/datasources/profile_api_datasource.dart';
import '../../data/models/invitation_dto.dart';
import '../../domain/repositories/memberships_repository.dart';
import '../utils/membership_error_mapper.dart';
import 'membership_state_providers.dart';
import 'personalized_feed_provider.dart';

/// User's pending invitations — `GET /me/invitations` (spec §6).
///
/// Not paginated. Returns an empty list when unauthenticated to avoid a
/// useless 401 round-trip.
final myInvitationsProvider = StateNotifierProvider<MyInvitationsController,
    AsyncValue<List<InvitationDto>>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repository = ref.watch(membershipsRepositoryProvider);
  return MyInvitationsController(
    repository,
    ref,
    ownerSession: ownerSession,
  );
});

class MyInvitationsController
    extends StateNotifier<AsyncValue<List<InvitationDto>>> {
  MyInvitationsController(
    this._repository,
    this._ref, {
    required AuthSessionKey ownerSession,
  })  : _ownerSession = ownerSession,
        super(
          ownerSession.accountId == null
              ? const AsyncValue.data([])
              : const AsyncValue.loading(),
        ) {
    if (ownerSession.accountId != null) unawaited(_load());
  }

  final MembershipsRepository _repository;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;

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

  Future<void> _load() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsActiveSession) return;

    state = const AsyncValue.loading();
    try {
      final invitations = await _repository.getMyInvitations();
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(invitations);
    } catch (error, stackTrace) {
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();
}

/// Search query bound to the screen's inline search bar. Empty = no filter.
/// Filtering happens client-side over [myMembershipsListProvider]'s cached
/// data — see spec §5 / §15.4 ("counters from the same response").
final membershipsSearchProvider = StateProvider<String>((ref) {
  ref.watch(authSessionKeyProvider);
  return '';
});

/// In-flight indicator for accept/decline on a single invitation token.
/// Lets the card show a spinner without flashing the whole list.
class InvitationAction {
  final bool isInFlight;
  final String? error;

  const InvitationAction({this.isInFlight = false, this.error});
}

class InvitationActionController
    extends StateNotifier<AsyncValue<InvitationAction>> {
  InvitationActionController(
    this._repository,
    this._ref, {
    required String token,
    required AuthSessionKey ownerSession,
  })  : _token = token,
        _ownerSession = ownerSession,
        super(const AsyncValue.data(InvitationAction()));

  final MembershipsRepository _repository;
  final Ref _ref;
  final String _token;
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

  /// Accept — spec §8.
  ///
  /// Viewer invitations reconcile the customer membership source. Staff
  /// invitations reconcile auth plus the managed-organization source instead;
  /// they must never be inserted into `/me/memberships`.
  Future<bool> accept({
    required String fallbackMessage,
    InvitationAccessKind accessKind = InvitationAccessKind.adherence,
  }) async {
    if (!_ownsActiveSession) return false;
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return false;
    state = const AsyncData(InvitationAction(isInFlight: true));

    try {
      await _repository.acceptInvitation(_token);
      if (!_ownsActiveSession) return false;

      if (accessKind == InvitationAccessKind.management) {
        // A staff invitation creates an OrganizationMember, not a customer
        // adherence. Refresh the authoritative user role/capabilities before
        // the UI chooses its post-accept destination, and ensure the new
        // organization is fetched the next time a vendor surface opens.
        await _reconcileManagementAccess();
        if (!_ownsActiveSession) return false;
        _ref.invalidate(managedOrganizationsProvider(_ownerSession));
      } else {
        _ref.invalidate(myMembershipsListProvider);
        // Customer membership signal changed — drop the personalized feed.
        _ref.invalidate(personalizedFeedProvider);
      }

      _ref.invalidate(myInvitationsProvider);
      state = const AsyncData(InvitationAction());
      _ref.read(analyticsServiceProvider).logEvent(
            AnalyticsEvent.membershipInviteAccepted,
          );
      return true;
    } catch (e, st) {
      if (!_ownsActiveSession) return false;
      state = AsyncData(
        InvitationAction(
          error: MembershipErrorMapper.actionMessage(
            e,
            fallback: fallbackMessage,
          ),
        ),
      );
      if (kDebugMode) {
        debugPrint('InvitationActionController.accept failed: $e\n$st');
      }
      return false;
    }
  }

  Future<void> _reconcileManagementAccess() async {
    try {
      final updatedUser =
          await _ref.read(profileApiDataSourceProvider).getProfile();
      if (!_ownsActiveSession) return;
      _ref.read(authProvider.notifier).updateUser(updatedUser);
    } catch (error, stackTrace) {
      // The invitation has already been accepted server-side. A follow-up
      // profile failure must not turn that success into a misleading retry;
      // the role will reconcile on the next successful profile fetch/sign-in.
      if (kDebugMode) {
        debugPrint(
          'InvitationActionController auth reconciliation failed: '
          '$error\n$stackTrace',
        );
      }
    }
  }

  /// Decline — spec §9. Silent operation; vendor is notified separately.
  Future<bool> decline({required String fallbackMessage}) async {
    if (!_ownsActiveSession) return false;
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return false;
    state = const AsyncData(InvitationAction(isInFlight: true));

    try {
      await _repository.declineInvitation(_token);
      if (!_ownsActiveSession) return false;
      _ref.invalidate(myInvitationsProvider);
      // Membership signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
      state = const AsyncData(InvitationAction());
      return true;
    } catch (e, st) {
      if (!_ownsActiveSession) return false;
      state = AsyncData(
        InvitationAction(
          error: MembershipErrorMapper.actionMessage(
            e,
            fallback: fallbackMessage,
          ),
        ),
      );
      if (kDebugMode) {
        debugPrint('InvitationActionController.decline failed: $e\n$st');
      }
      return false;
    }
  }
}

final invitationActionControllerProvider = StateNotifierProvider.family<
    InvitationActionController, AsyncValue<InvitationAction>, String>(
  (ref, token) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    final repository = ref.watch(membershipsRepositoryProvider);
    return InvitationActionController(
      repository,
      ref,
      token: token,
      ownerSession: ownerSession,
    );
  },
);

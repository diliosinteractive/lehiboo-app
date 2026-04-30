import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/invitation_dto.dart';
import '../../domain/repositories/memberships_repository.dart';
import 'membership_state_providers.dart';

/// User's pending invitations — `GET /me/invitations` (spec §6).
///
/// Not paginated. Returns an empty list when unauthenticated to avoid a
/// useless 401 round-trip.
final myInvitationsProvider =
    FutureProvider<List<InvitationDto>>((ref) async {
  final isAuthenticated = ref.watch(
    authProvider.select((s) => s.isAuthenticated),
  );
  if (!isAuthenticated) return const [];
  return ref.watch(membershipsRepositoryProvider).getMyInvitations();
});

/// Search query bound to the screen's inline search bar. Empty = no filter.
/// Filtering happens client-side over [myMembershipsListProvider]'s cached
/// data — see spec §5 / §15.4 ("counters from the same response").
final membershipsSearchProvider = StateProvider<String>((ref) => '');

/// In-flight indicator for accept/decline on a single invitation token.
/// Lets the card show a spinner without flashing the whole list.
class InvitationAction {
  final bool isInFlight;
  final String? error;

  const InvitationAction({this.isInFlight = false, this.error});
}

class InvitationActionController
    extends FamilyAsyncNotifier<InvitationAction, String> {
  @override
  Future<InvitationAction> build(String token) async => const InvitationAction();

  /// Accept — spec §8.
  ///
  /// On success the row is gone from `/me/invitations` and a new active
  /// membership exists. Per spec §8.1 the response shape doesn't match
  /// `MembershipDto` — invalidate both lists and let the next fetch
  /// reconcile from the server.
  Future<bool> accept() async {
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return false;
    state = const AsyncData(InvitationAction(isInFlight: true));

    try {
      await ref.read(membershipsRepositoryProvider).acceptInvitation(arg);
      ref.invalidate(myInvitationsProvider);
      ref.invalidate(myMembershipsListProvider);
      state = const AsyncData(InvitationAction());
      return true;
    } catch (e, st) {
      state = AsyncData(InvitationAction(error: _humanReadable(e)));
      if (kDebugMode) {
        debugPrint('InvitationActionController.accept failed: $e\n$st');
      }
      return false;
    }
  }

  /// Decline — spec §9. Silent operation; vendor is notified separately.
  Future<bool> decline() async {
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return false;
    state = const AsyncData(InvitationAction(isInFlight: true));

    try {
      await ref.read(membershipsRepositoryProvider).declineInvitation(arg);
      ref.invalidate(myInvitationsProvider);
      state = const AsyncData(InvitationAction());
      return true;
    } catch (e, st) {
      state = AsyncData(InvitationAction(error: _humanReadable(e)));
      if (kDebugMode) {
        debugPrint('InvitationActionController.decline failed: $e\n$st');
      }
      return false;
    }
  }

  String _humanReadable(Object e) {
    final message = e.toString();
    return message.length > 200 ? message.substring(0, 200) : message;
  }
}

final invitationActionControllerProvider =
    AsyncNotifierProvider.family<InvitationActionController, InvitationAction,
        String>(
  InvitationActionController.new,
);

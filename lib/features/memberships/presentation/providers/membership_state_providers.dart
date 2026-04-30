import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/membership_dto.dart';
import '../../domain/repositories/memberships_repository.dart';

/// One fetch of `/me/memberships` covering all statuses; downstream selectors
/// derive everything (per-org lookup, tab counters) from this single source
/// to honor spec §15.4 ("don't make 4 separate calls").
///
/// Returns an empty page for unauthenticated users without hitting the API
/// (the endpoint requires auth and would 401).
class MyMembershipsListController extends AsyncNotifier<MembershipsPage> {
  static const _perPage = 50;

  @override
  Future<MembershipsPage> build() async {
    final isAuthenticated = ref.watch(
      authProvider.select((s) => s.isAuthenticated),
    );
    if (!isAuthenticated) {
      return const MembershipsPage(data: []);
    }
    return ref
        .watch(membershipsRepositoryProvider)
        .getMyMemberships(page: 1, perPage: _perPage);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final myMembershipsListProvider =
    AsyncNotifierProvider<MyMembershipsListController, MembershipsPage>(
  MyMembershipsListController.new,
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
    extends FamilyAsyncNotifier<MembershipAction, String> {
  @override
  Future<MembershipAction> build(String orgUuid) async =>
      const MembershipAction();

  /// `POST /organizations/{uuid}/membership-request` — used for both initial
  /// join requests and re-applications after rejection.
  Future<void> requestJoin() async {
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return;
    state = const AsyncData(MembershipAction(isInFlight: true));

    try {
      await ref.read(membershipsRepositoryProvider).requestMembership(arg);
      ref.invalidate(myMembershipsListProvider);
      state = const AsyncData(MembershipAction());
    } catch (e, st) {
      state = AsyncData(MembershipAction(error: _humanReadable(e)));
      if (kDebugMode) {
        debugPrint('MembershipActionController.requestJoin failed: $e\n$st');
      }
      // 422 = "already pending or active" → we re-fetch so the UI reflects
      // the actual server state instead of showing a stale error.
      ref.invalidate(myMembershipsListProvider);
    }
  }

  /// `DELETE /organizations/{uuid}/membership-request` — covers cancel
  /// (when pending) and leave (when active). The server picks the right
  /// transition based on the current row state.
  Future<void> cancelOrLeave() async {
    final current = state.valueOrNull;
    if (current == null || current.isInFlight) return;
    state = const AsyncData(MembershipAction(isInFlight: true));

    try {
      await ref.read(membershipsRepositoryProvider).cancelOrLeaveMembership(arg);
      ref.invalidate(myMembershipsListProvider);
      state = const AsyncData(MembershipAction());
    } catch (e, st) {
      state = AsyncData(MembershipAction(error: _humanReadable(e)));
      if (kDebugMode) {
        debugPrint('MembershipActionController.cancelOrLeave failed: $e\n$st');
      }
    }
  }

  String _humanReadable(Object e) {
    final message = e.toString();
    return message.length > 200 ? message.substring(0, 200) : message;
  }
}

final membershipActionControllerProvider = AsyncNotifierProvider.family<
    MembershipActionController, MembershipAction, String>(
  MembershipActionController.new,
);

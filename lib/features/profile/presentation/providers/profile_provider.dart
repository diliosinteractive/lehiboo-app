import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/datasources/profile_api_datasource.dart';

/// User stats state
class UserStats {
  final int bookingsCount;
  final int favoritesCount;
  final int reviewsCount;
  final int upcomingEventsCount;

  const UserStats({
    this.bookingsCount = 0,
    this.favoritesCount = 0,
    this.reviewsCount = 0,
    this.upcomingEventsCount = 0,
  });

  factory UserStats.fromDto(UserStatsDto dto) {
    return UserStats(
      bookingsCount: dto.bookingsCount,
      favoritesCount: dto.favoritesCount,
      reviewsCount: dto.reviewsCount,
      upcomingEventsCount: dto.upcomingEventsCount,
    );
  }
}

/// Account-scoped profile statistics.
///
/// A new notifier is created for every exact authenticated user id. This is
/// intentionally stronger than checking a boolean authentication flag: it
/// prevents account A's completed request from becoming visible after a
/// direct A -> B account switch.
final userStatsProvider =
    StateNotifierProvider.autoDispose<UserStatsNotifier, AsyncValue<UserStats>>(
        (ref) {
  // The opaque session key changes for every account transition, including a
  // rapid A -> B -> A cycle where the final string id equals the initial one.
  final ownerSession = ref.watch(authSessionKeyProvider);
  final profileApi = ref.watch(profileApiDataSourceProvider);
  return UserStatsNotifier(
    profileApi,
    accountId: ownerSession.accountId,
  );
});

class UserStatsNotifier extends StateNotifier<AsyncValue<UserStats>> {
  UserStatsNotifier(
    this._profileApi, {
    required String? accountId,
  })  : _accountId = accountId,
        super(
          accountId == null
              ? const AsyncValue.data(UserStats())
              : const AsyncValue.loading(),
        ) {
    if (accountId != null) _load();
  }

  final ProfileApiDataSource _profileApi;
  final String? _accountId;
  int _requestGeneration = 0;

  Future<void> _load() async {
    final requestGeneration = ++_requestGeneration;
    if (_accountId == null) return;

    try {
      final statsDto = await _profileApi.getStats();
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.data(UserStats.fromDto(statsDto));
    } catch (_) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      // Keep the existing profile UX: unavailable stats are shown as zeroes.
      state = const AsyncValue.data(UserStats());
    }
  }
}

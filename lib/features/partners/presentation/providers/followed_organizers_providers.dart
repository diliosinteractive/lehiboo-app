import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/organizer_profile_dto.dart';
import '../../domain/repositories/organizer_repository.dart';
import 'organizer_profile_providers.dart';

/// State for the "Organisateurs suivis" screen.
///
/// `items` is the cumulative list across paginated fetches. `page` is the
/// last page successfully loaded; `lastPage` is the server-reported total
/// pages; `hasMore` derives from those two.
class FollowedOrganizersState {
  final List<OrganizerProfileDto> items;
  final int page;
  final int lastPage;
  final bool isLoadingMore;

  const FollowedOrganizersState({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
  });

  bool get hasMore => page < lastPage;

  FollowedOrganizersState copyWith({
    List<OrganizerProfileDto>? items,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
  }) =>
      FollowedOrganizersState(
        items: items ?? this.items,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class FollowedOrganizersController
    extends AsyncNotifier<FollowedOrganizersState> {
  static const _perPage = 20;

  /// Current search query — empty means "show everything". Survives
  /// rebuilds so loadMore() keeps filtering the same set.
  String _searchQuery = '';

  @override
  Future<FollowedOrganizersState> build() async {
    final page =
        await ref.watch(organizerRepositoryProvider).getFollowing(
              search: _searchQuery.isEmpty ? null : _searchQuery,
              page: 1,
              perPage: _perPage,
            );
    return FollowedOrganizersState(
      items: page.items,
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
      final next = await ref.read(organizerRepositoryProvider).getFollowing(
            search: _searchQuery.isEmpty ? null : _searchQuery,
            page: current.page + 1,
            perPage: _perPage,
          );
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          page: next.page,
          lastPage: next.lastPage,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      if (kDebugMode) {
        debugPrint('FollowedOrganizersController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// Update the current search filter and reload from page 1. Callers
  /// should debounce keystrokes — see `FollowedOrganizersScreen`.
  Future<void> setSearch(String query) async {
    final normalized = query.trim();
    if (normalized == _searchQuery) return;
    _searchQuery = normalized;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// Optimistic unfollow — removes the item from the list immediately and
  /// fires DELETE in the background. Restores at the original index on
  /// failure (spec §6bis.7).
  ///
  /// Also invalidates [organizerProfileFutureProvider] / [followStateControllerProvider]
  /// for the same UUID so any open profile screen reflects the change next
  /// time it's read.
  Future<void> unfollow(String uuid) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final index = current.items.indexWhere((o) => o.uuid == uuid);
    if (index == -1) return;
    final removed = current.items[index];

    final optimistic = [...current.items]..removeAt(index);
    state = AsyncData(current.copyWith(items: optimistic));

    try {
      await ref.read(organizerRepositoryProvider).unfollow(uuid);
      // Cross-screen consistency: any cached profile / follow state for
      // this UUID is now stale. Invalidate so a navigation refetches.
      ref.invalidate(organizerProfileFutureProvider(uuid));
      ref.invalidate(followStateControllerProvider(uuid));
    } catch (e, st) {
      // Rollback at the original position so the list order stays stable.
      final restored = [...state.valueOrNull?.items ?? optimistic]
        ..insert(index.clamp(0, state.valueOrNull?.items.length ?? 0), removed);
      state = AsyncData(current.copyWith(items: restored));
      if (kDebugMode) {
        debugPrint('FollowedOrganizersController.unfollow failed: $e\n$st');
      }
    }
  }
}

final followedOrganizersControllerProvider =
    AsyncNotifierProvider<FollowedOrganizersController,
        FollowedOrganizersState>(
  FollowedOrganizersController.new,
);

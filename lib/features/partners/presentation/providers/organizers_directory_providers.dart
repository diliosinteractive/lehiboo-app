import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/organizer_profile_dto.dart';
import '../../domain/repositories/organizer_repository.dart';

/// Sort options exposed by the organizers directory. `apiValue` is the
/// `sort_by` sent to `GET /organizers`; `sort_order` is derived server-side
/// (asc for name, desc otherwise) so the client only picks the field.
enum OrganizersSort {
  name('name'),
  eventsCount('events_count'),
  followersCount('followers_count');

  const OrganizersSort(this.apiValue);
  final String apiValue;
}

/// State for the public organizers directory screen.
///
/// `items` is the cumulative list across paginated fetches. `page` is the
/// last page successfully loaded; `lastPage` is the server-reported total
/// pages; `hasMore` derives from those two.
class OrganizersDirectoryState {
  final List<OrganizerProfileDto> items;
  final int page;
  final int lastPage;
  final int total;
  final bool isLoadingMore;

  const OrganizersDirectoryState({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.isLoadingMore,
  });

  bool get hasMore => page < lastPage;

  OrganizersDirectoryState copyWith({
    List<OrganizerProfileDto>? items,
    int? page,
    int? lastPage,
    int? total,
    bool? isLoadingMore,
  }) =>
      OrganizersDirectoryState(
        items: items ?? this.items,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        total: total ?? this.total,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class OrganizersDirectoryController
    extends AsyncNotifier<OrganizersDirectoryState> {
  static const _perPage = 20;

  /// Current search query — empty means "show everything". Survives
  /// rebuilds so loadMore() keeps filtering the same set.
  String _searchQuery = '';

  /// Current sort field. Defaults to alphabetical (spec default).
  OrganizersSort _sort = OrganizersSort.name;

  OrganizersSort get sort => _sort;

  @override
  Future<OrganizersDirectoryState> build() async {
    final page = await ref.watch(organizerRepositoryProvider).getOrganizers(
          search: _searchQuery.isEmpty ? null : _searchQuery,
          sortBy: _sort.apiValue,
          page: 1,
          perPage: _perPage,
        );
    return OrganizersDirectoryState(
      items: page.items,
      page: page.page,
      lastPage: page.lastPage,
      total: page.total,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final next = await ref.read(organizerRepositoryProvider).getOrganizers(
            search: _searchQuery.isEmpty ? null : _searchQuery,
            sortBy: _sort.apiValue,
            page: current.page + 1,
            perPage: _perPage,
          );
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          page: next.page,
          lastPage: next.lastPage,
          total: next.total,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      if (kDebugMode) {
        debugPrint('OrganizersDirectoryController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// Update the current search filter and reload from page 1. Callers
  /// should debounce keystrokes — see `OrganizersDirectoryScreen`.
  Future<void> setSearch(String query) async {
    final normalized = query.trim();
    if (normalized == _searchQuery) return;
    _searchQuery = normalized;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// Change the sort field and reload from page 1.
  Future<void> setSort(OrganizersSort sort) async {
    if (sort == _sort) return;
    _sort = sort;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final organizersDirectoryControllerProvider = AsyncNotifierProvider<
    OrganizersDirectoryController, OrganizersDirectoryState>(
  OrganizersDirectoryController.new,
);

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/models/event_dto.dart';
import '../../data/datasources/memberships_api_datasource.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Search filter for the private-events screen. Empty = no filter.
final privateEventsSearchProvider = StateProvider<String>((ref) => '');

/// Selected organization filter. Null = all active orgs.
final privateEventsOrgFilterProvider = StateProvider<String?>((ref) => null);

const Object _privateEventsLoadMoreErrorUnset = Object();

class PrivateEventsState {
  final List<EventDto> events;
  final int page;
  final int lastPage;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const PrivateEventsState({
    required this.events,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
    this.loadMoreError,
  });

  bool get hasMore => page < lastPage;

  PrivateEventsState copyWith({
    List<EventDto>? events,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
    Object? loadMoreError = _privateEventsLoadMoreErrorUnset,
  }) =>
      PrivateEventsState(
        events: events ?? this.events,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError:
            identical(loadMoreError, _privateEventsLoadMoreErrorUnset)
                ? this.loadMoreError
                : loadMoreError,
      );
}

/// Paginated controller for `/me/private-events`. Re-fetches when search or
/// org-filter providers change.
class PrivateEventsController extends AsyncNotifier<PrivateEventsState> {
  static const _perPage = 15;

  @override
  Future<PrivateEventsState> build() async {
    final search = ref.watch(privateEventsSearchProvider);
    final orgId = ref.watch(privateEventsOrgFilterProvider);

    final page = await _fetch(search: search, orgId: orgId, page: 1);
    return PrivateEventsState(
      events: page.events,
      page: page.page,
      lastPage: page.lastPage,
      isLoadingMore: false,
    );
  }

  Future<PrivateEventsPage> _fetch({
    String? search,
    String? orgId,
    required int page,
  }) =>
      ref.read(membershipsRepositoryProvider).getPrivateEvents(
            search: search,
            organizationId: orgId,
            page: page,
            perPage: _perPage,
          );

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.loadMoreError != null) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    try {
      final next = await _fetch(
        search: ref.read(privateEventsSearchProvider),
        orgId: ref.read(privateEventsOrgFilterProvider),
        page: current.page + 1,
      );
      state = AsyncData(
        current.copyWith(
          events: [...current.events, ...next.events],
          page: next.page,
          lastPage: next.lastPage,
          isLoadingMore: false,
          loadMoreError: null,
        ),
      );
    } catch (e, st) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
      if (kDebugMode) {
        debugPrint('PrivateEventsController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> retryLoadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(loadMoreError: null));
    await loadMore();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final privateEventsControllerProvider =
    AsyncNotifierProvider<PrivateEventsController, PrivateEventsState>(
  PrivateEventsController.new,
);

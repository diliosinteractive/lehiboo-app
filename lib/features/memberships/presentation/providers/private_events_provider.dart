import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/models/event_dto.dart';
import '../../data/datasources/memberships_api_datasource.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Search filter for the private-events screen. Empty = no filter.
final privateEventsSearchProvider = StateProvider<String>((ref) => '');

/// Selected organization filter. Null = all active orgs.
final privateEventsOrgFilterProvider = StateProvider<String?>((ref) => null);

class PrivateEventsState {
  final List<EventDto> events;
  final int page;
  final int lastPage;
  final bool isLoadingMore;

  const PrivateEventsState({
    required this.events,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
  });

  bool get hasMore => page < lastPage;

  PrivateEventsState copyWith({
    List<EventDto>? events,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
  }) =>
      PrivateEventsState(
        events: events ?? this.events,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

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
        ),
      );
    } catch (e, st) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      if (kDebugMode) {
        debugPrint('PrivateEventsController.loadMore failed: $e\n$st');
      }
    }
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

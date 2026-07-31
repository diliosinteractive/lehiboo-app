import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/models/event_dto.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/datasources/memberships_api_datasource.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Search filter for the private-events screen. Empty = no filter.
final privateEventsSearchProvider = StateProvider<String>((ref) {
  // Reset this user-owned UI state for logout and direct A -> B switches.
  ref.watch(authSessionKeyProvider);
  return '';
});

/// Selected organization filter. Null = all active orgs.
final privateEventsOrgFilterProvider = StateProvider<String?>((ref) {
  ref.watch(authSessionKeyProvider);
  return null;
});

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
class PrivateEventsController
    extends StateNotifier<AsyncValue<PrivateEventsState>> {
  static const _perPage = 15;

  static const _emptyState = PrivateEventsState(
    events: [],
    page: 1,
    lastPage: 1,
    isLoadingMore: false,
  );

  PrivateEventsController(
    this._repository, {
    required String? accountId,
    required String search,
    required String? orgId,
  })  : _accountId = accountId,
        _search = search,
        _orgId = orgId,
        super(
          accountId == null
              ? const AsyncValue.data(_emptyState)
              : const AsyncValue.loading(),
        ) {
    if (accountId != null) unawaited(_loadFirstPage());
  }

  final MembershipsRepository _repository;
  final String? _accountId;
  final String _search;
  final String? _orgId;
  int _requestGeneration = 0;

  Future<void> _loadFirstPage() async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    if (_accountId == null) {
      state = const AsyncValue.data(_emptyState);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final page = await _fetch(search: _search, orgId: _orgId, page: 1);
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.data(
        PrivateEventsState(
          events: page.events,
          page: page.page,
          lastPage: page.lastPage,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<PrivateEventsPage> _fetch({
    String? search,
    String? orgId,
    required int page,
  }) =>
      _repository.getPrivateEvents(
        search: search,
        organizationId: orgId,
        page: page,
        perPage: _perPage,
      );

  Future<void> loadMore() async {
    if (!mounted || _accountId == null) return;
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.loadMoreError != null) {
      return;
    }

    final requestGeneration = ++_requestGeneration;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    try {
      final next = await _fetch(
        search: _search,
        orgId: _orgId,
        page: current.page + 1,
      );
      if (!mounted || requestGeneration != _requestGeneration) return;
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
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
      if (kDebugMode) {
        debugPrint('PrivateEventsController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> retryLoadMore() async {
    if (!mounted || _accountId == null) return;
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(loadMoreError: null));
    await loadMore();
  }

  Future<void> refresh() => _loadFirstPage();
}

final privateEventsControllerProvider = StateNotifierProvider<
    PrivateEventsController, AsyncValue<PrivateEventsState>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ownerSession.accountId;
  final search = ref.watch(privateEventsSearchProvider);
  final orgId = ref.watch(privateEventsOrgFilterProvider);
  final repository = ref.watch(membershipsRepositoryProvider);
  return PrivateEventsController(
    repository,
    accountId: accountId,
    search: search,
    orgId: orgId,
  );
});

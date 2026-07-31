import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/organizer_profile_dto.dart';
import '../../domain/repositories/organizer_repository.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
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
  final bool hasLoadMoreError;

  const FollowedOrganizersState({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
    this.hasLoadMoreError = false,
  });

  bool get hasMore => page < lastPage;

  FollowedOrganizersState copyWith({
    List<OrganizerProfileDto>? items,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) =>
      FollowedOrganizersState(
        items: items ?? this.items,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
      );
}

class FollowedOrganizersController
    extends StateNotifier<AsyncValue<FollowedOrganizersState>> {
  static const _perPage = 20;

  static const _emptyState = FollowedOrganizersState(
    items: [],
    page: 1,
    lastPage: 1,
    isLoadingMore: false,
  );

  FollowedOrganizersController(
    this._repository,
    this._ref, {
    required AuthSessionKey ownerSession,
  })  : _ownerSession = ownerSession,
        super(
          ownerSession.accountId == null
              ? const AsyncValue.data(_emptyState)
              : const AsyncValue.loading(),
        ) {
    if (ownerSession.accountId != null) unawaited(_loadFirstPage());
  }

  final OrganizerRepository _repository;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;
  int _stateRevision = 0;

  bool get _ownsActiveAccount {
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

  /// Current search query — empty means "show everything". Survives
  /// rebuilds so loadMore() keeps filtering the same set.
  String _searchQuery = '';

  void _publish(AsyncValue<FollowedOrganizersState> next) {
    if (!mounted) return;
    state = next;
    _stateRevision++;
  }

  Future<void> _loadFirstPage() async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    if (_ownerSession.accountId == null) {
      _publish(const AsyncValue.data(_emptyState));
      return;
    }
    if (!_ownsActiveAccount) return;

    final search = _searchQuery;
    _publish(const AsyncValue.loading());
    try {
      final page = await _repository.getFollowing(
        search: search.isEmpty ? null : search,
        page: 1,
        perPage: _perPage,
      );
      if (!_ownsActiveAccount || requestGeneration != _requestGeneration) {
        return;
      }
      _publish(
        AsyncValue.data(
          FollowedOrganizersState(
            items: page.items,
            page: page.page,
            lastPage: page.lastPage,
            isLoadingMore: false,
            hasLoadMoreError: false,
          ),
        ),
      );
    } catch (error, stackTrace) {
      if (!_ownsActiveAccount || requestGeneration != _requestGeneration) {
        return;
      }
      _publish(AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> loadMore() => _loadMore();

  Future<void> retryLoadMore() => _loadMore(allowAfterError: true);

  Future<void> _loadMore({bool allowAfterError = false}) async {
    if (!_ownsActiveAccount) return;
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        (current.hasLoadMoreError && !allowAfterError)) {
      return;
    }

    final requestGeneration = ++_requestGeneration;
    final search = _searchQuery;
    _publish(AsyncData(
      current.copyWith(isLoadingMore: true, hasLoadMoreError: false),
    ));

    try {
      final next = await _repository.getFollowing(
        search: search.isEmpty ? null : search,
        page: current.page + 1,
        perPage: _perPage,
      );
      if (!_ownsActiveAccount || requestGeneration != _requestGeneration) {
        return;
      }
      _publish(AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          page: next.page,
          lastPage: next.lastPage,
          isLoadingMore: false,
          hasLoadMoreError: false,
        ),
      ));
    } catch (e, st) {
      if (!_ownsActiveAccount || requestGeneration != _requestGeneration) {
        return;
      }
      _publish(AsyncData(
        current.copyWith(isLoadingMore: false, hasLoadMoreError: true),
      ));
      if (kDebugMode) {
        debugPrint('FollowedOrganizersController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> refresh() => _loadFirstPage();

  /// Update the current search filter and reload from page 1. Callers
  /// should debounce keystrokes — see `FollowedOrganizersScreen`.
  Future<void> setSearch(String query) async {
    final normalized = query.trim();
    if (normalized == _searchQuery) return;
    _searchQuery = normalized;
    await _loadFirstPage();
  }

  /// Optimistic unfollow — removes the item from the list immediately and
  /// fires DELETE in the background. Restores at the original index on
  /// failure (spec §6bis.7).
  ///
  /// Also invalidates [organizerProfileFutureProvider] / [followStateControllerProvider]
  /// for the same UUID so any open profile screen reflects the change next
  /// time it's read.
  Future<void> unfollow(String uuid) async {
    if (!_ownsActiveAccount) return;
    final current = state.valueOrNull;
    if (current == null) return;

    final index = current.items.indexWhere((o) => o.uuid == uuid);
    if (index == -1) return;
    final removed = current.items[index];

    _requestGeneration++;
    final optimistic = [...current.items]..removeAt(index);
    _publish(AsyncData(current.copyWith(items: optimistic)));
    final optimisticRevision = _stateRevision;

    try {
      await _repository.unfollow(uuid);
      if (!_ownsActiveAccount) return;
      // Cross-screen consistency: any cached profile / follow state for
      // this UUID is now stale. Invalidate so a navigation refetches.
      _ref.invalidate(organizerProfileFutureProvider(uuid));
      _ref.invalidate(followStateControllerProvider(uuid));
      // Follow signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
    } catch (e, st) {
      if (!_ownsActiveAccount) return;
      // Roll back only while this exact optimistic snapshot still owns the
      // notifier. A disposed notifier belongs to an earlier account.
      if (mounted && _stateRevision == optimisticRevision) {
        final visibleItems = state.valueOrNull?.items ?? optimistic;
        final restored = [...visibleItems]
          ..insert(index.clamp(0, visibleItems.length), removed);
        _publish(AsyncData(current.copyWith(items: restored)));
      }
      if (kDebugMode) {
        debugPrint('FollowedOrganizersController.unfollow failed: $e\n$st');
      }
      Error.throwWithStackTrace(e, st);
    }
  }
}

final followedOrganizersControllerProvider = StateNotifierProvider<
    FollowedOrganizersController, AsyncValue<FollowedOrganizersState>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repository = ref.watch(organizerRepositoryProvider);
  return FollowedOrganizersController(
    repository,
    ref,
    ownerSession: ownerSession,
  );
});

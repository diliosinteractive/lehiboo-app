import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/broadcast.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import 'account_scoped_message_request_guard.dart';
import 'messages_realtime_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class VendorBroadcastsState {
  final AsyncValue<List<Broadcast>> broadcasts;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final String? searchQuery;
  final String? period;

  const VendorBroadcastsState({
    this.broadcasts = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.searchQuery,
    this.period,
  });

  VendorBroadcastsState copyWith({
    AsyncValue<List<Broadcast>>? broadcasts,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? period,
    bool clearPeriod = false,
  }) {
    return VendorBroadcastsState(
      broadcasts: broadcasts ?? this.broadcasts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      period: clearPeriod ? null : (period ?? this.period),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class VendorBroadcastsNotifier extends StateNotifier<VendorBroadcastsState>
    with AccountScopedMessageRequestGuard<VendorBroadcastsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  final String? _accountId;
  @override
  final AuthSessionKey requestOwnerSession;
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  VendorBroadcastsNotifier(
    this._repo,
    this._ref,
    this._accountId,
    this.requestOwnerSession,
  ) : super(
          VendorBroadcastsState(
            broadcasts: _accountId == null
                ? const AsyncValue.data(<Broadcast>[])
                : const AsyncValue.loading(),
          ),
        ) {
    if (_accountId == null) return;
    load();
    _subscribeToRealtime();
  }

  @override
  Ref get requestRef => _ref;

  @override
  String? get requestAccountId => _accountId;

  void _subscribeToRealtime() {
    _realtimeSub =
        _ref.read(messagesRealtimeProvider.notifier).events.listen((event) {
      if (!hasActiveRequestAccount) return;
      if (event.type != RealtimeEventType.broadcastSent) return;

      final broadcastUuid = event.conversationUuid;
      dev.log('[VendorBroadcasts] broadcast.sent uuid=$broadcastUuid');

      if (broadcastUuid != null) {
        _applyBroadcastSent(broadcastUuid);
      } else {
        refresh();
      }
    });
  }

  void _applyBroadcastSent(String broadcastUuid) {
    final current = state.broadcasts.valueOrNull;
    if (current == null) {
      _silentRefresh();
      return;
    }
    final idx = current.indexWhere((b) => b.uuid == broadcastUuid);
    if (idx == -1) {
      _silentRefresh();
      return;
    }
    final updated = [...current];
    updated[idx] = current[idx].copyWith(isSent: true);
    state = state.copyWith(broadcasts: AsyncValue.data(updated));
  }

  Future<void> load() async {
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final searchQuery = state.searchQuery;
    final period = state.period;
    state = state.copyWith(
      broadcasts: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
      isLoadingMore: false,
      clearLoadMoreError: true,
    );
    try {
      final result = await _repo.getBroadcasts(
        search: searchQuery,
        period: period,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        broadcasts: AsyncValue.data(result.broadcasts),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } catch (e, st) {
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(broadcasts: AsyncValue.error(e, st));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.loadMoreError != null) {
      return;
    }
    final current = state.broadcasts.valueOrNull;
    if (current == null) return;
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final nextPage = state.currentPage + 1;
    final searchQuery = state.searchQuery;
    final period = state.period;
    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);
    try {
      final result = await _repo.getBroadcasts(
        search: searchQuery,
        period: period,
        page: nextPage,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        broadcasts: AsyncValue.data([...current, ...result.broadcasts]),
        currentPage: nextPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } catch (error) {
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: error,
      );
    }
  }

  Future<void> retryLoadMore() async {
    if (state.isLoadingMore) return;
    state = state.copyWith(clearLoadMoreError: true);
    await loadMore();
  }

  Future<void> refresh() async => load();

  Future<void> _silentRefresh() async {
    if (state.broadcasts.isLoading || state.isLoadingMore) return;
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final searchQuery = state.searchQuery;
    final period = state.period;
    try {
      final result = await _repo.getBroadcasts(
        search: searchQuery,
        period: period,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        broadcasts: AsyncValue.data(result.broadcasts),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } catch (_) {}
  }

  void setSearchQuery(String? query) {
    if (!hasActiveRequestAccount) return;
    final trimmed = query?.trim();
    state = state.copyWith(
      searchQuery: trimmed,
      clearSearchQuery: trimmed == null || trimmed.isEmpty,
      currentPage: 1,
    );
    load();
  }

  void setPeriod(String? period) {
    if (!hasActiveRequestAccount) return;
    state = state.copyWith(
      period: period,
      clearPeriod: period == null,
      currentPage: 1,
    );
    load();
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

final vendorBroadcastsProvider =
    StateNotifierProvider<VendorBroadcastsNotifier, VendorBroadcastsState>(
        (ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  return VendorBroadcastsNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
    accountId,
    ownerSession,
  );
});

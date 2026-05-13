import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/broadcast.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import 'messages_realtime_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class VendorBroadcastsState {
  final AsyncValue<List<Broadcast>> broadcasts;
  final int currentPage;
  final bool hasMore;
  final String? searchQuery;
  final String? period;

  const VendorBroadcastsState({
    this.broadcasts = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.searchQuery,
    this.period,
  });

  VendorBroadcastsState copyWith({
    AsyncValue<List<Broadcast>>? broadcasts,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? period,
    bool clearPeriod = false,
  }) {
    return VendorBroadcastsState(
      broadcasts: broadcasts ?? this.broadcasts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      period: clearPeriod ? null : (period ?? this.period),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class VendorBroadcastsNotifier extends StateNotifier<VendorBroadcastsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  VendorBroadcastsNotifier(this._repo, this._ref)
      : super(const VendorBroadcastsState()) {
    load();
    _subscribeToRealtime();
  }

  void _subscribeToRealtime() {
    _realtimeSub = _ref
        .read(messagesRealtimeProvider.notifier)
        .events
        .listen((event) {
      if (!mounted) return;
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
    state = state.copyWith(
      broadcasts: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
    );
    try {
      final result = await _repo.getBroadcasts(
        search: state.searchQuery,
        period: state.period,
        page: 1,
      );
      if (!mounted) return;
      state = state.copyWith(
        broadcasts: AsyncValue.data(result.broadcasts),
        currentPage: 1,
        hasMore: result.hasMore,
      );
    } catch (e, st) {
      if (!mounted) return;
      state = state.copyWith(broadcasts: AsyncValue.error(e, st));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore) return;
    final current = state.broadcasts.valueOrNull;
    if (current == null) return;
    try {
      final nextPage = state.currentPage + 1;
      final result = await _repo.getBroadcasts(
        search: state.searchQuery,
        period: state.period,
        page: nextPage,
      );
      if (!mounted) return;
      state = state.copyWith(
        broadcasts: AsyncValue.data([...current, ...result.broadcasts]),
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  Future<void> refresh() async => load();

  Future<void> _silentRefresh() async {
    try {
      final result = await _repo.getBroadcasts(
        search: state.searchQuery,
        period: state.period,
        page: 1,
      );
      if (!mounted) return;
      state = state.copyWith(
        broadcasts: AsyncValue.data(result.broadcasts),
        currentPage: 1,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  void setSearchQuery(String? query) {
    final trimmed = query?.trim();
    state = state.copyWith(
      searchQuery: trimmed,
      clearSearchQuery: trimmed == null || trimmed.isEmpty,
      currentPage: 1,
    );
    load();
  }

  void setPeriod(String? period) {
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

final vendorBroadcastsProvider = StateNotifierProvider<VendorBroadcastsNotifier,
    VendorBroadcastsState>((ref) {
  return VendorBroadcastsNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
  );
});

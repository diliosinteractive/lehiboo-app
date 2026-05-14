import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../data/datasources/messages_polling_datasource.dart';
import 'unread_count_provider.dart';
import 'messages_realtime_provider.dart';

class ConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final String? statusFilter;   // null = all, 'open', 'closed'
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;          // null = all, 'today', 'week', 'month', 'older'

  const ConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.statusFilter,
    this.unreadOnly = false,
    this.searchQuery,
    this.period,
  });

  ConversationsState copyWith({
    AsyncValue<List<Conversation>>? conversations,
    int? currentPage,
    bool? hasMore,
    String? statusFilter,
    bool clearStatusFilter = false,
    bool? unreadOnly,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? period,
    bool clearPeriod = false,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      unreadOnly: unreadOnly ?? this.unreadOnly,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      period: clearPeriod ? null : (period ?? this.period),
    );
  }
}

class ConversationsNotifier extends StateNotifier<ConversationsState> {
  final MessagesRepository _repo;
  final MessagesPollingDatasource _polling;
  final Ref _ref;
  Timer? _pollTimer;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  final Set<String> _readUuids = {};

  ConversationsNotifier(this._repo, this._polling, this._ref)
      : super(const ConversationsState()) {
    load();
    _startUnreadPolling();
    _subscribeToRealtime();
  }

  void _startUnreadPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      // Skip when WebSocket is connected — WS events keep data current
      if (_ref.read(messagesRealtimeProvider)) return;
      // Refresh list + badge (mirrors support conversations polling behaviour)
      await _silentRefresh();
      await _refreshUnreadCount();
    });
  }

  void _subscribeToRealtime() {
    dev.log('[ParticipantConv] Subscribed to realtime events');
    _realtimeSub = _ref
        .read(messagesRealtimeProvider.notifier)
        .events
        .listen((event) {
      if (!mounted) return;
      final type = event.conversationType;
      dev.log(
        '[ParticipantConv] event received: type=${event.type.name} conv=${event.conversationUuid} convType=$type',
      );
      // messageReceived: validate by UUID in _applyNewMessage — not by type.
      if (event.type == RealtimeEventType.messageReceived) {
        _applyNewMessage(event);
        return;
      }
      // For all other events keep the type guard.
      if (type != null && type != 'participant_vendor') {
        dev.log(
          '[ParticipantConv] skipping — convType=$type is not participant_vendor',
        );
        return;
      }
      switch (event.type) {
        case RealtimeEventType.conversationCreated:
          refresh();
          _refreshUnreadCount();
        case RealtimeEventType.conversationClosed:
          if (event.conversationUuid != null) {
            _applyConversationStatus(event.conversationUuid!, 'closed');
          }
        case RealtimeEventType.conversationReopened:
          if (event.conversationUuid != null) {
            _applyConversationStatus(event.conversationUuid!, 'open');
          }
        default:
          break;
      }
    });
  }

  void _applyConversationStatus(String convUuid, String status) {
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final updated = current
        .map((c) => c.uuid == convUuid ? c.copyWith(status: status) : c)
        .toList();
    state = state.copyWith(conversations: AsyncValue.data(updated));
  }

  void _applyNewMessage(RealtimeEvent event) {
    final uuid = event.conversationUuid;
    if (uuid == null) return;
    final current = state.conversations.valueOrNull;
    if (current == null) {
      dev.log('[ParticipantConv] applyNewMessage: no list loaded, refreshing');
      _silentRefresh();
      return;
    }
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1) {
      dev.log('[ParticipantConv] applyNewMessage: conv=$uuid not in list — refreshing');
      _silentRefresh();
      return;
    }
    dev.log('[ParticipantConv] applyNewMessage: conv=$uuid found at idx=$idx, unread=${current[idx].unreadCount}→${current[idx].unreadCount + 1}');
    final updated = current[idx].copyWith(
      unreadCount: current[idx].unreadCount + 1,
    );
    final list = [...current];
    list.removeAt(idx);
    list.insert(0, updated);
    state = state.copyWith(conversations: AsyncValue.data(list));
    _silentRefresh();
  }

  Future<void> load() async {
    state = state.copyWith(
      conversations: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
    );
    try {
      final result = await _repo.getConversations(
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
        page: 1,
      );
      if (!mounted) return;
      var conversations = result.conversations;
      if (_readUuids.isNotEmpty) {
        conversations = conversations.map((c) {
          if (_readUuids.contains(c.uuid) && c.unreadCount > 0) {
            return c.copyWith(unreadCount: 0);
          }
          return c;
        }).toList();
      }
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
        currentPage: 1,
        hasMore: result.hasMore,
      );
      // Refresh global unread count
      _refreshUnreadCount();
    } catch (e, st) {
      if (!mounted) return;
      state = state.copyWith(conversations: AsyncValue.error(e, st));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore) return;
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    try {
      final nextPage = state.currentPage + 1;
      final result = await _repo.getConversations(
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
        page: nextPage,
      );
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data([...current, ...result.conversations]),
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (_) {
      // Keep existing list on loadMore failure
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> _silentRefresh() async {
    try {
      final result = await _repo.getConversations(
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
        page: 1,
      );
      if (!mounted) return;
      var conversations = result.conversations;
      if (_readUuids.isNotEmpty) {
        conversations = conversations.map((c) {
          if (_readUuids.contains(c.uuid) && c.unreadCount > 0) {
            return c.copyWith(unreadCount: 0);
          }
          return c;
        }).toList();
      }
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
        currentPage: 1,
        hasMore: result.hasMore,
      );
      _refreshUnreadCount();
    } catch (_) {}
  }

  void applyRead(String uuid) {
    _readUuids.add(uuid);
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1 || current[idx].unreadCount == 0) return;
    final updated = [...current];
    updated[idx] = current[idx].copyWith(unreadCount: 0);
    state = state.copyWith(conversations: AsyncValue.data(updated));
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(
      statusFilter: status,
      clearStatusFilter: status == null,
      currentPage: 1,
    );
    load();
  }

  void setUnreadOnly(bool value) {
    state = state.copyWith(unreadOnly: value, currentPage: 1);
    load();
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

  Future<void> _refreshUnreadCount() async {
    try {
      final count = await _polling.getTotalUnreadCount();
      _ref.read(unreadCountProvider.notifier).state = count;
    } catch (_) {}
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }
}

final conversationsProvider =
    StateNotifierProvider<ConversationsNotifier, ConversationsState>((ref) {
  return ConversationsNotifier(
    ref.read(messagesRepositoryProvider),
    ref.read(messagesPollingDatasourceProvider),
    ref,
  );
});

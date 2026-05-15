import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import 'messages_realtime_provider.dart';

class SupportConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final String? statusFilter;
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;

  const SupportConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.statusFilter,
    this.unreadOnly = false,
    this.searchQuery,
    this.period,
  });

  SupportConversationsState copyWith({
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
    return SupportConversationsState(
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

class SupportConversationsNotifier
    extends StateNotifier<SupportConversationsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  Timer? _pollTimer;
  final Set<String> _readUuids = {};
  final Map<String, int> _realtimeUnreadByUuid = {};

  SupportConversationsNotifier(this._repo, this._ref)
      : super(const SupportConversationsState()) {
    load();
    _subscribeToRealtime();
    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      if (_ref.read(messagesRealtimeProvider)) return;
      await _silentRefresh();
    });
  }

  void _subscribeToRealtime() {
    dev.log('[SupportConv] Subscribed to realtime events');
    _realtimeSub = _ref
        .read(messagesRealtimeProvider.notifier)
        .events
        .listen((event) {
      if (!mounted) return;
      final type = event.conversationType;
      dev.log(
        '[SupportConv] event received: type=${event.type.name} conv=${event.conversationUuid} convType=$type',
      );
      if (event.type == RealtimeEventType.messageReceived) {
        if (type != null && type != 'user_support') {
          dev.log('[SupportConv] skipping messageReceived: convType=$type is not user_support');
          return;
        }
        _applyNewMessage(event);
        return;
      }
      if (type != null && type != 'user_support') {
        dev.log('[SupportConv] skipping — convType=$type is not user_support');
        return;
      }
      switch (event.type) {
        case RealtimeEventType.conversationCreated:
          refresh();
        case RealtimeEventType.conversationClosed:
          if (event.conversationUuid != null) {
            _applyStatus(event.conversationUuid!, 'closed');
          }
        case RealtimeEventType.conversationReopened:
          if (event.conversationUuid != null) {
            _applyStatus(event.conversationUuid!, 'open');
          }
        default:
          break;
      }
    });
  }

  void _applyNewMessage(RealtimeEvent event) {
    final uuid = event.conversationUuid;
    if (uuid == null) return;
    _readUuids.remove(uuid);
    _realtimeUnreadByUuid[uuid] = (_realtimeUnreadByUuid[uuid] ?? 0) + 1;
    final current = state.conversations.valueOrNull;
    if (current == null) {
      _silentRefresh();
      return;
    }
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1) {
      _silentRefresh();
      return;
    }
    dev.log('[SupportConv] applyNewMessage: conv=$uuid unread ${current[idx].unreadCount}→${current[idx].unreadCount + 1}');
    final updated = current[idx].copyWith(
      unreadCount: current[idx].unreadCount + 1,
    );
    final list = [...current];
    list.removeAt(idx);
    list.insert(0, updated);
    state = state.copyWith(conversations: AsyncValue.data(list));
    _silentRefresh();
  }

  void _applyStatus(String convUuid, String status) {
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    state = state.copyWith(
      conversations: AsyncValue.data(
        current.map((c) => c.uuid == convUuid ? c.copyWith(status: status) : c).toList(),
      ),
    );
  }

  Future<void> load() async {
    state = state.copyWith(
      conversations: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
    );
    try {
      final result = await _repo.getSupportConversations(
        page: 1,
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
      );
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data(_mergeUnreadState(result.conversations)),
        currentPage: 1,
        hasMore: result.hasMore,
      );
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
      final result = await _repo.getSupportConversations(
        page: nextPage,
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
      );
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data([...current, ...result.conversations]),
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> _silentRefresh() async {
    try {
      final result = await _repo.getSupportConversations(
        page: 1,
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
      );
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data(_mergeUnreadState(result.conversations)),
        currentPage: 1,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  void applyRead(String uuid) {
    _readUuids.add(uuid);
    _realtimeUnreadByUuid.remove(uuid);
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1 || current[idx].unreadCount == 0) return;
    final updated = [...current];
    updated[idx] = current[idx].copyWith(unreadCount: 0);
    state = state.copyWith(conversations: AsyncValue.data(updated));
  }

  List<Conversation> _mergeUnreadState(List<Conversation> incoming) {
    final current = state.conversations.valueOrNull;
    final localUnreadByUuid = {
      for (final conversation in current ?? const <Conversation>[])
        conversation.uuid: conversation.unreadCount,
    };

    return incoming.map((conversation) {
      if (_readUuids.contains(conversation.uuid)) {
        return conversation.unreadCount == 0
            ? conversation
            : conversation.copyWith(unreadCount: 0);
      }

      final localUnread = localUnreadByUuid[conversation.uuid] ?? 0;
      final realtimeUnread = _realtimeUnreadByUuid[conversation.uuid] ?? 0;
      final unread = [
        conversation.unreadCount,
        localUnread,
        realtimeUnread,
      ].reduce((a, b) => a > b ? a : b);

      return unread == conversation.unreadCount
          ? conversation
          : conversation.copyWith(unreadCount: unread);
    }).toList();
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

  @override
  void dispose() {
    _realtimeSub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }
}

final supportConversationsProvider = StateNotifierProvider<
    SupportConversationsNotifier, SupportConversationsState>((ref) {
  return SupportConversationsNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
  );
});

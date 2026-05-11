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

  const SupportConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
  });

  SupportConversationsState copyWith({
    AsyncValue<List<Conversation>>? conversations,
    int? currentPage,
    bool? hasMore,
  }) {
    return SupportConversationsState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class SupportConversationsNotifier
    extends StateNotifier<SupportConversationsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  Timer? _pollTimer;

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
      // messageReceived: validate by UUID in _applyNewMessage — not by type,
      // because the backend may send a different convType string.
      if (event.type == RealtimeEventType.messageReceived) {
        _applyNewMessage(event);
        return;
      }
      // For all other events keep the type guard.
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
    final current = state.conversations.valueOrNull;
    if (current == null) {
      _silentRefresh();
      return;
    }
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1) return; // not in this list — another provider handles it
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
      final result = await _repo.getSupportConversations(page: 1);
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data(result.conversations),
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
      final result = await _repo.getSupportConversations(page: nextPage);
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
      final result = await _repo.getSupportConversations(page: 1);
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data(result.conversations),
        currentPage: 1,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  void applyRead(String uuid) {
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1 || current[idx].unreadCount == 0) return;
    final updated = [...current];
    updated[idx] = current[idx].copyWith(unreadCount: 0);
    state = state.copyWith(conversations: AsyncValue.data(updated));
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

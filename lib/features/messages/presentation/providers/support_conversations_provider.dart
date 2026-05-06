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

  SupportConversationsNotifier(this._repo, this._ref)
      : super(const SupportConversationsState()) {
    load();
    _subscribeToRealtime();
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
      // Only handle user_support conversations (or null type as fallback).
      if (type != null && type != 'user_support') {
        dev.log('[SupportConv] skipping — convType=$type is not user_support');
        return;
      }
      switch (event.type) {
        case RealtimeEventType.messageReceived:
          _applyNewMessage(event);
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
    final current = state.conversations.valueOrNull;
    if (current == null || uuid == null) {
      refresh();
      return;
    }
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1) {
      refresh();
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

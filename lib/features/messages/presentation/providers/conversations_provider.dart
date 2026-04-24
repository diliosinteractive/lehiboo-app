import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../data/datasources/messages_polling_datasource.dart';
import 'unread_count_provider.dart';

class ConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final String? statusFilter;   // null = all, 'open', 'closed'
  final bool unreadOnly;
  final String? searchQuery;

  const ConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.statusFilter,
    this.unreadOnly = false,
    this.searchQuery,
  });

  ConversationsState copyWith({
    AsyncValue<List<Conversation>>? conversations,
    int? currentPage,
    bool? hasMore,
    String? statusFilter,       // pass null to clear filter
    bool clearStatusFilter = false,
    bool? unreadOnly,
    String? searchQuery,
    bool clearSearchQuery = false,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      unreadOnly: unreadOnly ?? this.unreadOnly,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

class ConversationsNotifier extends StateNotifier<ConversationsState> {
  final MessagesRepository _repo;
  final MessagesPollingDatasource _polling;
  final Ref _ref;
  Timer? _pollTimer;

  ConversationsNotifier(this._repo, this._polling, this._ref)
      : super(const ConversationsState()) {
    load();
    _startUnreadPolling();
  }

  void _startUnreadPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      try {
        final count = await _polling.getTotalUnreadCount();
        _ref.read(unreadCountProvider.notifier).state = count;
      } catch (_) {
        // Ignore polling errors silently
      }
    });
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
        page: 1,
      );
      state = state.copyWith(
        conversations: AsyncValue.data(result.conversations),
        currentPage: 1,
        hasMore: result.hasMore,
      );
      // Refresh global unread count
      _refreshUnreadCount();
    } catch (e, st) {
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
        page: nextPage,
      );
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

  Future<void> _refreshUnreadCount() async {
    try {
      final count = await _polling.getTotalUnreadCount();
      _ref.read(unreadCountProvider.notifier).state = count;
    } catch (_) {}
  }

  @override
  void dispose() {
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

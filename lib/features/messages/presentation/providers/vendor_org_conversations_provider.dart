import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import 'account_scoped_message_request_guard.dart';
import 'messages_realtime_provider.dart';

class VendorOrgConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final String? statusFilter;
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;

  const VendorOrgConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.statusFilter,
    this.unreadOnly = false,
    this.searchQuery,
    this.period,
  });

  VendorOrgConversationsState copyWith({
    AsyncValue<List<Conversation>>? conversations,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
    String? statusFilter,
    bool clearStatusFilter = false,
    bool? unreadOnly,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? period,
    bool clearPeriod = false,
  }) {
    return VendorOrgConversationsState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      statusFilter:
          clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      unreadOnly: unreadOnly ?? this.unreadOnly,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      period: clearPeriod ? null : (period ?? this.period),
    );
  }
}

class VendorOrgConversationsNotifier
    extends StateNotifier<VendorOrgConversationsState>
    with AccountScopedMessageRequestGuard<VendorOrgConversationsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  final String? _accountId;
  @override
  final AuthSessionKey requestOwnerSession;
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  VendorOrgConversationsNotifier(
    this._repo,
    this._ref,
    this._accountId,
    this.requestOwnerSession,
  ) : super(
          VendorOrgConversationsState(
            conversations: _accountId == null
                ? const AsyncValue.data(<Conversation>[])
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
      final type = event.conversationType;
      // messageReceived: validate by UUID in _applyNewMessage — not by type.
      if (event.type == RealtimeEventType.messageReceived) {
        _applyNewMessage(event);
        return;
      }
      // For all other events keep the type guard.
      if (type != null && type != 'organization_organization') {
        dev.log(
          '[VendorOrg] skipping event type=${event.type.name} convType=$type (not organization_organization)',
        );
        return;
      }
      dev.log(
        '[VendorOrg] handling event type=${event.type.name} conv=${event.conversationUuid} convType=$type',
      );
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
    if (idx == -1) return; // not in this list — skip silently
    dev.log(
        '[VendorOrg] applyNewMessage: conv=$uuid unread ${current[idx].unreadCount}→${current[idx].unreadCount + 1}');
    final updated =
        current[idx].copyWith(unreadCount: current[idx].unreadCount + 1);
    final list = [...current];
    list.removeAt(idx);
    list.insert(0, updated);
    state = state.copyWith(conversations: AsyncValue.data(list));
    _silentRefresh();
  }

  Future<void> _silentRefresh() async {
    if (state.conversations.isLoading || state.isLoadingMore) return;
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final statusFilter = state.statusFilter;
    final unreadOnly = state.unreadOnly;
    final searchQuery = state.searchQuery;
    final period = state.period;
    try {
      final result = await _repo.getOrgConversations(
        status: statusFilter,
        unreadOnly: unreadOnly ? true : null,
        search: searchQuery,
        period: period,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        conversations: AsyncValue.data(result.conversations),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } catch (_) {}
  }

  void _applyStatus(String convUuid, String status) {
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    state = state.copyWith(
      conversations: AsyncValue.data(
        current
            .map((c) => c.uuid == convUuid ? c.copyWith(status: status) : c)
            .toList(),
      ),
    );
  }

  Future<void> load() async {
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final statusFilter = state.statusFilter;
    final unreadOnly = state.unreadOnly;
    final searchQuery = state.searchQuery;
    final period = state.period;
    state = state.copyWith(
      conversations: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
      isLoadingMore: false,
      clearLoadMoreError: true,
    );
    try {
      final result = await _repo.getOrgConversations(
        status: statusFilter,
        unreadOnly: unreadOnly ? true : null,
        search: searchQuery,
        period: period,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      final conversations = result.conversations;
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
      // Ensure org channel subscription even if vendorConversationsProvider
      // hasn't loaded yet (e.g. vendor opens org tab first).
      final orgId = conversations
          .map((c) => c.organization?.id)
          .firstWhere((id) => id != null && id > 0, orElse: () => null);
      if (orgId != null) {
        _ref
            .read(messagesRealtimeProvider.notifier)
            .subscribeToOrganization(orgId, forUserId: _accountId);
      }
    } catch (e, st) {
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(conversations: AsyncValue.error(e, st));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.loadMoreError != null) {
      return;
    }
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final nextPage = state.currentPage + 1;
    final statusFilter = state.statusFilter;
    final unreadOnly = state.unreadOnly;
    final searchQuery = state.searchQuery;
    final period = state.period;
    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);
    try {
      final result = await _repo.getOrgConversations(
        status: statusFilter,
        unreadOnly: unreadOnly ? true : null,
        search: searchQuery,
        period: period,
        page: nextPage,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        conversations: AsyncValue.data([...current, ...result.conversations]),
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

  void applyRead(String uuid) {
    if (!hasActiveRequestAccount) return;
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1 || current[idx].unreadCount == 0) return;
    final updated = [...current];
    updated[idx] = current[idx].copyWith(unreadCount: 0);
    state = state.copyWith(conversations: AsyncValue.data(updated));
  }

  void applyReported(String uuid) {
    if (!hasActiveRequestAccount) return;
    final current = state.conversations.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1 || current[idx].userHasReported) return;
    final updated = [...current];
    updated[idx] = current[idx].copyWith(userHasReported: true);
    state = state.copyWith(conversations: AsyncValue.data(updated));
  }

  void setStatusFilter(String? status) {
    if (!hasActiveRequestAccount) return;
    state = state.copyWith(
      statusFilter: status,
      clearStatusFilter: status == null,
      currentPage: 1,
    );
    load();
  }

  void setUnreadOnly(bool value) {
    if (!hasActiveRequestAccount) return;
    state = state.copyWith(unreadOnly: value, currentPage: 1);
    load();
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

final vendorOrgConversationsProvider = StateNotifierProvider<
    VendorOrgConversationsNotifier, VendorOrgConversationsState>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  return VendorOrgConversationsNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
    accountId,
    ownerSession,
  );
});

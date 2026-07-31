import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/conversation.dart';
import '../../domain/entities/vendor_stats.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import 'account_scoped_message_request_guard.dart';
import 'unread_count_provider.dart';
import 'messages_realtime_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class VendorConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final String? statusFilter;
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;

  const VendorConversationsState({
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

  VendorConversationsState copyWith({
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
    return VendorConversationsState(
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

class VendorSupportState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const VendorSupportState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  VendorSupportState copyWith({
    AsyncValue<List<Conversation>>? conversations,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return VendorSupportState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VendorConversationsNotifier — onglet Clients (participant_vendor)
// Handles polling for vendor unread count (covers both tabs).
// ─────────────────────────────────────────────────────────────────────────────

class VendorConversationsNotifier
    extends StateNotifier<VendorConversationsState>
    with AccountScopedMessageRequestGuard<VendorConversationsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  final String? _accountId;
  @override
  final AuthSessionKey requestOwnerSession;
  Timer? _pollTimer;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  final Set<String> _readUuids = {};
  final Map<String, int> _realtimeUnreadByUuid = {};

  VendorConversationsNotifier(
    this._repo,
    this._ref,
    this._accountId,
    this.requestOwnerSession,
  ) : super(
          VendorConversationsState(
            conversations: _accountId == null
                ? const AsyncValue.data(<Conversation>[])
                : const AsyncValue.loading(),
          ),
        ) {
    if (_accountId == null) return;
    load();
    _startUnreadPolling();
    _subscribeToRealtime();
  }

  @override
  Ref get requestRef => _ref;

  @override
  String? get requestAccountId => _accountId;

  void _startUnreadPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (!hasActiveRequestAccount) return;
      if (_ref.read(messagesRealtimeProvider)) return;
      try {
        await _ref.read(unreadCountProvider.notifier).refresh();
      } catch (_) {}
    });
  }

  void _subscribeToRealtime() {
    _realtimeSub =
        _ref.read(messagesRealtimeProvider.notifier).events.listen((event) {
      if (!hasActiveRequestAccount) return;
      final type = event.conversationType;
      // messageReceived: validate by UUID in _applyNewMessage — not by type.
      if (event.type == RealtimeEventType.messageReceived) {
        if (type != null && type != 'participant_vendor') {
          if (type == 'vendor_admin') _refreshUnreadCount();
          dev.log(
            '[VendorConv] skipping messageReceived convType=$type (not participant_vendor)',
          );
          return;
        }
        _applyNewMessage(event);
        return;
      }
      // For all other events keep the type guard.
      if (type != null && type != 'participant_vendor') {
        dev.log(
          '[VendorConv] skipping event type=${event.type.name} convType=$type (not participant_vendor)',
        );
        return;
      }
      dev.log(
        '[VendorConv] handling event type=${event.type.name} conv=${event.conversationUuid} convType=$type',
      );
      switch (event.type) {
        case RealtimeEventType.conversationCreated:
          refresh();
          _refreshUnreadCount();
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

  void _applyNewMessage(RealtimeEvent event) {
    final uuid = event.conversationUuid;
    if (uuid == null) return;
    // New message invalidates the "already read" marker so _silentRefresh
    // doesn't zero out the unread indicator for this conversation.
    _readUuids.remove(uuid);
    _realtimeUnreadByUuid[uuid] = (_realtimeUnreadByUuid[uuid] ?? 0) + 1;
    final current = state.conversations.valueOrNull;
    if (current == null) {
      _silentRefresh();
      return;
    }
    final idx = current.indexWhere((c) => c.uuid == uuid);
    if (idx == -1) {
      // Not in this list (e.g. vendor_admin message) — still refresh badge.
      _silentRefresh();
      return;
    }
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
      final result = await _repo.getVendorConversations(
        conversationType: 'participant_vendor',
        status: statusFilter,
        unreadOnly: unreadOnly ? true : null,
        search: searchQuery,
        period: period,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      final conversations = _mergeUnreadState(result.conversations);
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
      _refreshUnreadCount();
      // Subscribe to the vendor's org channel for real-time updates.
      // The org ID is available from any conversation's organization field.
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
      final result = await _repo.getVendorConversations(
        conversationType: 'participant_vendor',
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

  Future<void> _silentRefresh() async {
    if (state.conversations.isLoading || state.isLoadingMore) return;
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final statusFilter = state.statusFilter;
    final unreadOnly = state.unreadOnly;
    final searchQuery = state.searchQuery;
    final period = state.period;
    try {
      final result = await _repo.getVendorConversations(
        conversationType: 'participant_vendor',
        status: statusFilter,
        unreadOnly: unreadOnly ? true : null,
        search: searchQuery,
        period: period,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      final conversations = _mergeUnreadState(result.conversations);
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
      _refreshUnreadCount();
    } catch (_) {}
  }

  void applyRead(String uuid) {
    if (!hasActiveRequestAccount) return;
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

  Future<void> _refreshUnreadCount() async {
    if (!hasActiveRequestAccount) return;
    try {
      await _ref.read(unreadCountProvider.notifier).refresh();
    } catch (_) {}
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

  @override
  void dispose() {
    _realtimeSub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VendorSupportNotifier — onglet Support LeHiboo (vendor_admin)
// No polling — VendorConversationsNotifier covers global vendor unread.
// ─────────────────────────────────────────────────────────────────────────────

class VendorSupportNotifier extends StateNotifier<VendorSupportState>
    with AccountScopedMessageRequestGuard<VendorSupportState> {
  final MessagesRepository _repo;
  final Ref _ref;
  final String? _accountId;
  @override
  final AuthSessionKey requestOwnerSession;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  final Set<String> _readUuids = {};
  final Map<String, int> _realtimeUnreadByUuid = {};

  VendorSupportNotifier(
    this._repo,
    this._ref,
    this._accountId,
    this.requestOwnerSession,
  ) : super(
          VendorSupportState(
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
        if (type != null && type != 'vendor_admin') {
          dev.log(
            '[VendorSupport] skipping messageReceived convType=$type (not vendor_admin)',
          );
          return;
        }
        _applyNewMessage(event);
        return;
      }
      // For all other events keep the type guard.
      if (type != null && type != 'vendor_admin') {
        dev.log(
          '[VendorSupport] skipping event type=${event.type.name} convType=$type (not vendor_admin)',
        );
        return;
      }
      dev.log(
        '[VendorSupport] handling event type=${event.type.name} conv=${event.conversationUuid} convType=$type',
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
    final updated = current[idx].copyWith(
      unreadCount: current[idx].unreadCount + 1,
    );
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
    try {
      final result = await _repo.getVendorConversations(
        conversationType: 'vendor_admin',
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      final conversations = _mergeUnreadState(result.conversations);
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
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
    state = state.copyWith(
      conversations: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
      isLoadingMore: false,
      clearLoadMoreError: true,
    );
    try {
      final result = await _repo.getVendorConversations(
        conversationType: 'vendor_admin',
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      final conversations = _mergeUnreadState(result.conversations);
      state = state.copyWith(
        conversations: AsyncValue.data(conversations),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
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
    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);
    try {
      final result = await _repo.getVendorConversations(
        conversationType: 'vendor_admin',
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

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final vendorConversationsProvider = StateNotifierProvider<
    VendorConversationsNotifier, VendorConversationsState>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  return VendorConversationsNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
    accountId,
    ownerSession,
  );
});

final vendorSupportProvider =
    StateNotifierProvider<VendorSupportNotifier, VendorSupportState>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  return VendorSupportNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
    accountId,
    ownerSession,
  );
});

const _emptyVendorStats = VendorStats(
  clientTotal: 0,
  clientUnread: 0,
  supportTotal: 0,
  supportUnread: 0,
);

final _vendorStatsForSessionProvider = FutureProvider.autoDispose
    .family<VendorStats, AuthSessionKey>((ref, ownerSession) async {
  if (ownerSession.accountId == null ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return _emptyVendorStats;
  }
  final stats = await ref.read(messagesRepositoryProvider).getVendorStats();
  if (!identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return _emptyVendorStats;
  }
  return stats;
});

/// Exact-session wrapper that clears the previous value synchronously.
///
/// The opaque key also prevents an A -> B -> A cycle in one disposal grace
/// period from reviving the first A session's cached stats.
final vendorStatsProvider =
    Provider.autoDispose<AsyncValue<VendorStats>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  if (ownerSession.accountId == null) {
    return const AsyncValue.data(_emptyVendorStats);
  }
  return ref.watch(_vendorStatsForSessionProvider(ownerSession));
});

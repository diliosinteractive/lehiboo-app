import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_report_stats.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/conversation_report.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import 'account_scoped_message_request_guard.dart';
import 'unread_count_provider.dart';
import 'messages_realtime_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminConversationsNotifier — family by conversationType
// Only the 'user_support' instance runs the 30s unread poll.
// ─────────────────────────────────────────────────────────────────────────────

class AdminConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final String? statusFilter;
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;

  const AdminConversationsState({
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

  AdminConversationsState copyWith({
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
    return AdminConversationsState(
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

class AdminConversationsNotifier extends StateNotifier<AdminConversationsState>
    with AccountScopedMessageRequestGuard<AdminConversationsState> {
  final String _conversationType;
  final MessagesRepository _repo;
  final Ref _ref;
  final String? _accountId;
  @override
  final AuthSessionKey requestOwnerSession;
  Timer? _pollTimer;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  final Set<String> _readUuids = {};
  final Map<String, int> _realtimeUnreadByUuid = {};

  AdminConversationsNotifier(
    this._conversationType,
    this._repo,
    this._ref,
    this._accountId,
    this.requestOwnerSession,
  ) : super(
          AdminConversationsState(
            conversations: _accountId == null
                ? const AsyncValue.data(<Conversation>[])
                : const AsyncValue.loading(),
          ),
        ) {
    if (_accountId == null) return;
    load();
    // Only one instance polls to avoid duplicate unread requests
    if (_conversationType == 'user_support') {
      _startUnreadPolling();
    }
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
      // messageReceived: validate by UUID in _applyNewMessage — not by type.
      if (event.type == RealtimeEventType.messageReceived) {
        if (event.conversationType != null &&
            event.conversationType != _conversationType) {
          return;
        }
        _applyNewMessage(event);
        return;
      }
      // For all other events keep the type guard.
      if (event.conversationType != null &&
          event.conversationType != _conversationType) {
        return;
      }
      switch (event.type) {
        case RealtimeEventType.conversationCreated:
          refresh();
          if (_conversationType == 'user_support') _refreshUnreadCount();
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
      if (_conversationType == 'user_support') _refreshUnreadCount();
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
    final statusFilter = state.statusFilter;
    final unreadOnly = state.unreadOnly;
    final searchQuery = state.searchQuery;
    final period = state.period;
    try {
      final result = await _repo.getAdminConversations(
        conversationType: _conversationType,
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
    } catch (_) {}
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
      final result = await _repo.getAdminConversations(
        conversationType: _conversationType,
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
      if (_conversationType == 'user_support') _refreshUnreadCount();
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
      final result = await _repo.getAdminConversations(
        conversationType: _conversationType,
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
// AdminReportsNotifier
// ─────────────────────────────────────────────────────────────────────────────

class AdminReportsState {
  final AsyncValue<List<ConversationReport>> reports;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final String? searchQuery;
  final String?
      reasonFilter; // null=all, 'inappropriate','harassment','spam','other'

  const AdminReportsState({
    this.reports = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.searchQuery,
    this.reasonFilter,
  });

  AdminReportsState copyWith({
    AsyncValue<List<ConversationReport>>? reports,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? reasonFilter,
    bool clearReasonFilter = false,
  }) {
    return AdminReportsState(
      reports: reports ?? this.reports,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      reasonFilter:
          clearReasonFilter ? null : (reasonFilter ?? this.reasonFilter),
    );
  }
}

class AdminReportsNotifier extends StateNotifier<AdminReportsState>
    with AccountScopedMessageRequestGuard<AdminReportsState> {
  final MessagesRepository _repo;
  final Ref _ref;
  final String? _accountId;
  @override
  final AuthSessionKey requestOwnerSession;

  AdminReportsNotifier(
    this._repo,
    this._ref,
    this._accountId,
    this.requestOwnerSession,
  ) : super(
          AdminReportsState(
            reports: _accountId == null
                ? const AsyncValue.data(<ConversationReport>[])
                : const AsyncValue.loading(),
          ),
        ) {
    if (_accountId == null) return;
    load();
  }

  @override
  Ref get requestRef => _ref;

  @override
  String? get requestAccountId => _accountId;

  Future<void> load() async {
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final searchQuery = state.searchQuery;
    final reasonFilter = state.reasonFilter;
    state = state.copyWith(
      reports: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
      isLoadingMore: false,
      clearLoadMoreError: true,
    );
    try {
      final result = await _repo.getAdminConversationReports(
        search: searchQuery,
        reason: reasonFilter,
        page: 1,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        reports: AsyncValue.data(result.reports),
        currentPage: 1,
        hasMore: result.hasMore,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } catch (e, st) {
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(reports: AsyncValue.error(e, st));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.loadMoreError != null) {
      return;
    }
    final current = state.reports.valueOrNull;
    if (current == null) return;
    final requestGeneration = beginMessageListRequest();
    if (requestGeneration == null) return;
    final nextPage = state.currentPage + 1;
    final searchQuery = state.searchQuery;
    final reasonFilter = state.reasonFilter;
    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);
    try {
      final result = await _repo.getAdminConversationReports(
        search: searchQuery,
        reason: reasonFilter,
        page: nextPage,
      );
      if (!canPublishMessageListRequest(requestGeneration)) return;
      state = state.copyWith(
        reports: AsyncValue.data([...current, ...result.reports]),
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

  void setSearch(String? query) {
    if (!hasActiveRequestAccount) return;
    final trimmed = query?.trim();
    state = state.copyWith(
      searchQuery: trimmed,
      clearSearchQuery: trimmed == null || trimmed.isEmpty,
      currentPage: 1,
    );
    load();
  }

  void setReasonFilter(String? reason) {
    if (!hasActiveRequestAccount) return;
    state = state.copyWith(
      reasonFilter: reason,
      clearReasonFilter: reason == null,
      currentPage: 1,
    );
    load();
  }

  Future<void> reviewReport(
    String reportUuid,
    String action, {
    String? adminNote,
  }) async {
    if (!hasActiveRequestAccount) return;
    await _repo.reviewAdminConversationReport(
      reportUuid: reportUuid,
      action: action,
      adminNote: adminNote,
    );
    if (!hasActiveRequestAccount) return;
    _updateReportLocally(
        reportUuid,
        (r) => ConversationReport(
              uuid: r.uuid,
              reason: r.reason,
              comment: r.comment,
              status: action == 'dismiss' ? 'dismissed' : 'reviewed',
              createdAt: r.createdAt,
              reviewedAt: DateTime.now(),
              adminNote: adminNote ?? r.adminNote,
              conversationUuid: r.conversationUuid,
              conversationSubject: r.conversationSubject,
              reporter: r.reporter,
              againstWhom: r.againstWhom,
              againstWhomType: r.againstWhomType,
              reviewedByName: r.reviewedByName,
            ));
  }

  Future<void> updateNote(String reportUuid, String? note) async {
    if (!hasActiveRequestAccount) return;
    await _repo.updateAdminConversationReportNote(
      reportUuid: reportUuid,
      adminNote: note,
    );
    if (!hasActiveRequestAccount) return;
    _updateReportLocally(
        reportUuid,
        (r) => ConversationReport(
              uuid: r.uuid,
              reason: r.reason,
              comment: r.comment,
              status: r.status,
              createdAt: r.createdAt,
              reviewedAt: r.reviewedAt,
              adminNote: note,
              conversationUuid: r.conversationUuid,
              conversationSubject: r.conversationSubject,
              reporter: r.reporter,
              againstWhom: r.againstWhom,
              againstWhomType: r.againstWhomType,
              reviewedByName: r.reviewedByName,
            ));
  }

  void _updateReportLocally(
      String uuid, ConversationReport Function(ConversationReport) updater) {
    if (!hasActiveRequestAccount) return;
    final current = state.reports.valueOrNull;
    if (current == null) return;
    state = state.copyWith(
      reports: AsyncValue.data(
        current.map((r) => r.uuid == uuid ? updater(r) : r).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final adminConversationsProvider = StateNotifierProvider.family<
    AdminConversationsNotifier, AdminConversationsState, String>(
  (ref, conversationType) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    return AdminConversationsNotifier(
      conversationType,
      ref.read(messagesRepositoryProvider),
      ref,
      ref.watch(authSessionUserIdProvider),
      ownerSession,
    );
  },
);

final adminReportsProvider =
    StateNotifierProvider<AdminReportsNotifier, AdminReportsState>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  return AdminReportsNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
    accountId,
    ownerSession,
  );
});

const _emptyAdminReportStats = AdminReportStats(
  pending: 0,
  reviewed: 0,
  dismissed: 0,
  total: 0,
);

final _adminReportStatsForSessionProvider = FutureProvider.autoDispose
    .family<AdminReportStats, AuthSessionKey>((ref, ownerSession) async {
  if (ownerSession.accountId == null ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return _emptyAdminReportStats;
  }
  final stats = await ref
      .read(messagesRepositoryProvider)
      .getAdminConversationReportStats();
  if (!identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return _emptyAdminReportStats;
  }
  return stats;
});

/// Exact-session wrapper that never carries account A's completed stats into
/// B or a replacement A session's loading state.
final adminReportStatsProvider =
    Provider.autoDispose<AsyncValue<AdminReportStats>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  if (ownerSession.accountId == null) {
    return const AsyncValue.data(_emptyAdminReportStats);
  }
  return ref.watch(_adminReportStatsForSessionProvider(ownerSession));
});

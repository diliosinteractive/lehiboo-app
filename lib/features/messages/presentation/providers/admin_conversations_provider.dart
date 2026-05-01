import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_report_stats.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/conversation_report.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../data/datasources/messages_polling_datasource.dart';
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
  final String? statusFilter;
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;

  const AdminConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.statusFilter,
    this.unreadOnly = false,
    this.searchQuery,
    this.period,
  });

  AdminConversationsState copyWith({
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
    return AdminConversationsState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      statusFilter:
          clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      unreadOnly: unreadOnly ?? this.unreadOnly,
      searchQuery:
          clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      period: clearPeriod ? null : (period ?? this.period),
    );
  }
}

class AdminConversationsNotifier
    extends StateNotifier<AdminConversationsState> {
  final String _conversationType;
  final MessagesRepository _repo;
  final MessagesPollingDatasource _polling;
  final Ref _ref;
  Timer? _pollTimer;
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  AdminConversationsNotifier(
    this._conversationType,
    this._repo,
    this._polling,
    this._ref,
  ) : super(const AdminConversationsState()) {
    load();
    // Only one instance polls to avoid duplicate unread requests
    if (_conversationType == 'user_support') {
      _startUnreadPolling();
    }
    _subscribeToRealtime();
  }

  void _startUnreadPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (_ref.read(messagesRealtimeProvider)) return;
      try {
        final count = await _polling.getAdminUnreadCount();
        _ref.read(unreadCountProvider.notifier).state = count;
      } catch (_) {}
    });
  }

  void _subscribeToRealtime() {
    _realtimeSub = _ref
        .read(messagesRealtimeProvider.notifier)
        .events
        .listen((event) {
      if (!mounted) return;
      if (event.conversationType != null &&
          event.conversationType != _conversationType) {
        return;
      }
      switch (event.type) {
        case RealtimeEventType.messageReceived:
          _applyNewMessage(event);
          if (_conversationType == 'user_support') _refreshUnreadCount();
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
    final updated = current[idx].copyWith(
      unreadCount: current[idx].unreadCount + 1,
    );
    final list = [...current];
    list.removeAt(idx);
    list.insert(0, updated);
    state = state.copyWith(conversations: AsyncValue.data(list));
  }

  Future<void> load() async {
    state = state.copyWith(
      conversations: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
    );
    try {
      final result = await _repo.getAdminConversations(
        conversationType: _conversationType,
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
        page: 1,
      );
      state = state.copyWith(
        conversations: AsyncValue.data(result.conversations),
        currentPage: 1,
        hasMore: result.hasMore,
      );
      if (_conversationType == 'user_support') _refreshUnreadCount();
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
      final result = await _repo.getAdminConversations(
        conversationType: _conversationType,
        status: state.statusFilter,
        unreadOnly: state.unreadOnly ? true : null,
        search: state.searchQuery,
        period: state.period,
        page: nextPage,
      );
      state = state.copyWith(
        conversations: AsyncValue.data([...current, ...result.conversations]),
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  Future<void> refresh() async => load();

  void applyRead(String uuid) {
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
      final count = await _polling.getAdminUnreadCount();
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

// ─────────────────────────────────────────────────────────────────────────────
// AdminReportsNotifier
// ─────────────────────────────────────────────────────────────────────────────

class AdminReportsState {
  final AsyncValue<List<ConversationReport>> reports;
  final int currentPage;
  final bool hasMore;
  final String? searchQuery;
  final String? reasonFilter; // null=all, 'inappropriate','harassment','spam','other'

  const AdminReportsState({
    this.reports = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.searchQuery,
    this.reasonFilter,
  });

  AdminReportsState copyWith({
    AsyncValue<List<ConversationReport>>? reports,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? reasonFilter,
    bool clearReasonFilter = false,
  }) {
    return AdminReportsState(
      reports: reports ?? this.reports,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery:
          clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      reasonFilter:
          clearReasonFilter ? null : (reasonFilter ?? this.reasonFilter),
    );
  }
}

class AdminReportsNotifier extends StateNotifier<AdminReportsState> {
  final MessagesRepository _repo;

  AdminReportsNotifier(this._repo) : super(const AdminReportsState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(
      reports: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
    );
    try {
      final result = await _repo.getAdminConversationReports(
        search: state.searchQuery,
        reason: state.reasonFilter,
        page: 1,
      );
      state = state.copyWith(
        reports: AsyncValue.data(result.reports),
        currentPage: 1,
        hasMore: result.hasMore,
      );
    } catch (e, st) {
      state = state.copyWith(reports: AsyncValue.error(e, st));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore) return;
    final current = state.reports.valueOrNull;
    if (current == null) return;
    try {
      final nextPage = state.currentPage + 1;
      final result = await _repo.getAdminConversationReports(
        search: state.searchQuery,
        reason: state.reasonFilter,
        page: nextPage,
      );
      state = state.copyWith(
        reports: AsyncValue.data([...current, ...result.reports]),
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  Future<void> refresh() async => load();

  void setSearch(String? query) {
    final trimmed = query?.trim();
    state = state.copyWith(
      searchQuery: trimmed,
      clearSearchQuery: trimmed == null || trimmed.isEmpty,
      currentPage: 1,
    );
    load();
  }

  void setReasonFilter(String? reason) {
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
    await _repo.reviewAdminConversationReport(
      reportUuid: reportUuid,
      action: action,
      adminNote: adminNote,
    );
    _updateReportLocally(reportUuid, (r) => ConversationReport(
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
    await _repo.updateAdminConversationReportNote(
      reportUuid: reportUuid,
      adminNote: note,
    );
    _updateReportLocally(reportUuid, (r) => ConversationReport(
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
  (ref, conversationType) => AdminConversationsNotifier(
    conversationType,
    ref.read(messagesRepositoryProvider),
    ref.read(messagesPollingDatasourceProvider),
    ref,
  ),
);

final adminReportsProvider =
    StateNotifierProvider<AdminReportsNotifier, AdminReportsState>((ref) {
  return AdminReportsNotifier(ref.read(messagesRepositoryProvider));
});

final adminReportStatsProvider = FutureProvider<AdminReportStats>((ref) async {
  return ref.read(messagesRepositoryProvider).getAdminConversationReportStats();
});

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import '../../domain/entities/conversation.dart';
import '../../domain/entities/vendor_stats.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../data/datasources/messages_polling_datasource.dart';
import 'unread_count_provider.dart';
import 'messages_realtime_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class VendorConversationsState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;
  final String? statusFilter;
  final bool unreadOnly;
  final String? searchQuery;
  final String? period;

  const VendorConversationsState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.statusFilter,
    this.unreadOnly = false,
    this.searchQuery,
    this.period,
  });

  VendorConversationsState copyWith({
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
    return VendorConversationsState(
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

class VendorSupportState {
  final AsyncValue<List<Conversation>> conversations;
  final int currentPage;
  final bool hasMore;

  const VendorSupportState({
    this.conversations = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
  });

  VendorSupportState copyWith({
    AsyncValue<List<Conversation>>? conversations,
    int? currentPage,
    bool? hasMore,
  }) {
    return VendorSupportState(
      conversations: conversations ?? this.conversations,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VendorConversationsNotifier — onglet Clients (participant_vendor)
// Handles polling for vendor unread count (covers both tabs).
// ─────────────────────────────────────────────────────────────────────────────

class VendorConversationsNotifier
    extends StateNotifier<VendorConversationsState> {
  final MessagesRepository _repo;
  final MessagesPollingDatasource _polling;
  final Ref _ref;
  Timer? _pollTimer;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  final Set<String> _readUuids = {};

  VendorConversationsNotifier(this._repo, this._polling, this._ref)
      : super(const VendorConversationsState()) {
    load();
    _startUnreadPolling();
    _subscribeToRealtime();
  }

  void _startUnreadPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (_ref.read(messagesRealtimeProvider)) return;
      try {
        final count = await _polling.getVendorUnreadCount();
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
      // Accept events that explicitly match OR have no type (backend may omit it)
      final type = event.conversationType;
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
        case RealtimeEventType.messageReceived:
          _applyNewMessage(event);
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
        current.map((c) => c.uuid == convUuid ? c.copyWith(status: status) : c).toList(),
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
      final result = await _repo.getVendorConversations(
        conversationType: 'participant_vendor',
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
      // Subscribe to the vendor's org channel for real-time updates.
      // The org ID is available from any conversation's organization field.
      final orgId = conversations
          .map((c) => c.organization?.id)
          .firstWhere((id) => id != null && id > 0, orElse: () => null);
      if (orgId != null) {
        _ref.read(messagesRealtimeProvider.notifier).subscribeToOrganization(orgId);
      }
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
      final result = await _repo.getVendorConversations(
        conversationType: 'participant_vendor',
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
    } catch (_) {}
  }

  Future<void> refresh() async => load();

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
      final count = await _polling.getVendorUnreadCount();
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
// VendorSupportNotifier — onglet Support LeHiboo (vendor_admin)
// No polling — VendorConversationsNotifier covers global vendor unread.
// ─────────────────────────────────────────────────────────────────────────────

class VendorSupportNotifier extends StateNotifier<VendorSupportState> {
  final MessagesRepository _repo;
  final Ref _ref;
  StreamSubscription<RealtimeEvent>? _realtimeSub;
  final Set<String> _readUuids = {};

  VendorSupportNotifier(this._repo, this._ref)
      : super(const VendorSupportState()) {
    load();
    _subscribeToRealtime();
  }

  void _subscribeToRealtime() {
    _realtimeSub = _ref
        .read(messagesRealtimeProvider.notifier)
        .events
        .listen((event) {
      if (!mounted) return;
      final type = event.conversationType;
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
        case RealtimeEventType.messageReceived:
          _applyNewMessage(event);
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
      final result = await _repo.getVendorConversations(
        conversationType: 'vendor_admin',
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
      final result = await _repo.getVendorConversations(
        conversationType: 'vendor_admin',
        page: nextPage,
      );
      if (!mounted) return;
      state = state.copyWith(
        conversations: AsyncValue.data([...current, ...result.conversations]),
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (_) {}
  }

  Future<void> refresh() async => load();

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
  return VendorConversationsNotifier(
    ref.read(messagesRepositoryProvider),
    ref.read(messagesPollingDatasourceProvider),
    ref,
  );
});

final vendorSupportProvider =
    StateNotifierProvider<VendorSupportNotifier, VendorSupportState>((ref) {
  return VendorSupportNotifier(
    ref.read(messagesRepositoryProvider),
    ref,
  );
});

final vendorStatsProvider = FutureProvider<VendorStats>((ref) async {
  return ref.read(messagesRepositoryProvider).getVendorStats();
});

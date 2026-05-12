import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/in_app_notifications_repository_impl.dart';
import '../../domain/entities/in_app_notification.dart';
import '../../domain/repositories/in_app_notifications_repository.dart';

final inAppNotificationsProvider =
    StateNotifierProvider<InAppNotificationsNotifier, InAppNotificationsState>(
        (ref) {
  return InAppNotificationsNotifier(
    repository: ref.watch(inAppNotificationsRepositoryImplProvider),
    ref: ref,
  );
});

class InAppNotificationsState {
  final AsyncValue<List<InAppNotification>> notifications;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool unreadOnly;
  final int unreadCount;
  final bool hasLoadedInbox;
  final String context;
  final String? organizationId;

  const InAppNotificationsState({
    this.notifications = const AsyncValue.data([]),
    this.currentPage = AppConstants.initialPage,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.unreadOnly = false,
    this.unreadCount = 0,
    this.hasLoadedInbox = false,
    this.context = 'participant',
    this.organizationId,
  });

  InAppNotificationsState copyWith({
    AsyncValue<List<InAppNotification>>? notifications,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? unreadOnly,
    int? unreadCount,
    bool? hasLoadedInbox,
    String? context,
    String? organizationId,
    bool clearOrganizationId = false,
  }) {
    return InAppNotificationsState(
      notifications: notifications ?? this.notifications,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      unreadCount: unreadCount ?? this.unreadCount,
      hasLoadedInbox: hasLoadedInbox ?? this.hasLoadedInbox,
      context: context ?? this.context,
      organizationId:
          clearOrganizationId ? null : (organizationId ?? this.organizationId),
    );
  }
}

class InAppNotificationsNotifier extends StateNotifier<InAppNotificationsState>
    with WidgetsBindingObserver {
  final InAppNotificationsRepository _repository;
  final Ref _ref;

  InAppNotificationsNotifier({
    required InAppNotificationsRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const InAppNotificationsState()) {
    WidgetsBinding.instance.addObserver(this);
    _bootstrapAuthListener();
  }

  void _bootstrapAuthListener() {
    final authState = _ref.read(authProvider);
    if (authState.isAuthenticated) {
      refreshUnreadCount();
    }

    _ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        refreshUnreadCount();
        if (state.hasLoadedInbox) {
          load(refresh: true);
        }
      } else if (next.status == AuthStatus.unauthenticated) {
        state = const InAppNotificationsState();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!_ref.read(authProvider).isAuthenticated) return;

    refreshUnreadCount();
    if (this.state.hasLoadedInbox) {
      load(refresh: true);
    }
  }

  Future<void> refreshUnreadCount() async {
    if (!_ref.read(authProvider).isAuthenticated) {
      state = state.copyWith(unreadCount: 0);
      return;
    }

    try {
      final count = await _repository.getUnreadCount(
        context: state.context,
        organizationId: state.organizationId,
      );
      if (!mounted) return;
      state = state.copyWith(unreadCount: count);
    } catch (_) {
      // Badge refresh is best-effort; list screens surface explicit errors.
    }
  }

  Future<void> load({
    bool refresh = false,
    bool? unreadOnly,
  }) async {
    final nextUnreadOnly = unreadOnly ?? state.unreadOnly;
    final current = state.notifications.valueOrNull;

    if (refresh || current == null || !state.hasLoadedInbox) {
      final shouldShowLoading = current == null ||
          !state.hasLoadedInbox ||
          nextUnreadOnly != state.unreadOnly;
      state = state.copyWith(
        notifications: shouldShowLoading
            ? const AsyncValue.loading()
            : state.notifications,
        unreadOnly: nextUnreadOnly,
        currentPage: AppConstants.initialPage,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    try {
      final page = await _repository.getNotifications(
        page: AppConstants.initialPage,
        perPage: AppConstants.itemsPerPage,
        unreadOnly: nextUnreadOnly,
        context: state.context,
        organizationId: state.organizationId,
      );
      final unreadCount = await _repository.getUnreadCount(
        context: state.context,
        organizationId: state.organizationId,
      );
      if (!mounted) return;
      state = state.copyWith(
        notifications: AsyncValue.data(_sort(page.notifications)),
        currentPage: page.currentPage,
        hasMore: page.hasMore,
        unreadOnly: nextUnreadOnly,
        unreadCount: unreadCount,
        hasLoadedInbox: true,
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      state = state.copyWith(
        notifications: AsyncValue.error(error, stackTrace),
        unreadOnly: nextUnreadOnly,
        hasLoadedInbox: true,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    final current = state.notifications.valueOrNull;
    if (current == null) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await _repository.getNotifications(
        page: state.currentPage + 1,
        perPage: AppConstants.itemsPerPage,
        unreadOnly: state.unreadOnly,
        context: state.context,
        organizationId: state.organizationId,
      );
      if (!mounted) return;
      state = state.copyWith(
        notifications:
            AsyncValue.data(_sort([...current, ...page.notifications])),
        currentPage: page.currentPage,
        hasMore: page.hasMore,
        isLoadingMore: false,
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> setUnreadOnly(bool value) async {
    if (state.unreadOnly == value && state.hasLoadedInbox) return;
    await load(refresh: true, unreadOnly: value);
  }

  Future<void> refresh() async {
    await load(refresh: true);
  }

  void handleRealtimeNotification(
    InAppNotification notification, {
    int? unreadCount,
  }) {
    if (!_matchesCurrentContext(notification)) {
      refreshUnreadCount();
      return;
    }

    final current = state.notifications.valueOrNull;
    final nextUnreadCount = unreadCount ?? state.unreadCount + 1;

    if (current == null || !state.hasLoadedInbox) {
      state = state.copyWith(unreadCount: nextUnreadCount);
      return;
    }

    final filteredCurrent = current
        .where((item) => item.id != notification.id)
        .where((item) => !state.unreadOnly || !item.isRead)
        .toList();

    final shouldInsert = !state.unreadOnly || !notification.isRead;
    final next = shouldInsert
        ? _sort([notification, ...filteredCurrent])
        : _sort(filteredCurrent);

    state = state.copyWith(
      notifications: AsyncValue.data(next),
      unreadCount: nextUnreadCount,
    );
  }

  Future<void> markAsRead(String id) async {
    final current = state.notifications.valueOrNull;
    if (current == null) return;
    final index = current.indexWhere((item) => item.id == id);
    if (index == -1 || current[index].isRead) return;

    final previous = state;
    final updated = [...current];
    updated[index] = current[index].copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );

    state = state.copyWith(
      notifications: AsyncValue.data(
        state.unreadOnly
            ? updated.where((item) => !item.isRead).toList()
            : updated,
      ),
      unreadCount: _decrementUnreadCount(),
    );

    try {
      await _repository.markAsRead(id);
    } catch (_) {
      if (mounted) state = previous;
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    final current =
        state.notifications.valueOrNull ?? const <InAppNotification>[];
    final previous = state;

    state = state.copyWith(
      notifications: AsyncValue.data(
        state.unreadOnly
            ? const <InAppNotification>[]
            : current
                .map((item) => item.isRead
                    ? item
                    : item.copyWith(isRead: true, readAt: DateTime.now()))
                .toList(),
      ),
      unreadCount: 0,
    );

    try {
      await _repository.markAllAsRead(
        context: state.context,
        organizationId: state.organizationId,
      );
      await refresh();
    } catch (_) {
      if (mounted) state = previous;
      rethrow;
    }
  }

  Future<void> deleteNotification(String id) async {
    final current = state.notifications.valueOrNull;
    if (current == null) return;
    final target = current.where((item) => item.id == id).firstOrNull;
    if (target == null) return;

    final previous = state;
    state = state.copyWith(
      notifications: AsyncValue.data(
        current.where((item) => item.id != id).toList(),
      ),
      unreadCount: target.isRead ? state.unreadCount : _decrementUnreadCount(),
    );

    try {
      await _repository.deleteNotification(id);
    } catch (_) {
      if (mounted) state = previous;
      rethrow;
    }
  }

  int _decrementUnreadCount() {
    return state.unreadCount > 0 ? state.unreadCount - 1 : 0;
  }

  List<InAppNotification> _sort(List<InAppNotification> notifications) {
    final deduped = <String, InAppNotification>{};
    for (final notification in notifications) {
      deduped[notification.id] = notification;
    }
    final result = deduped.values.toList();
    result.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return result;
  }

  bool _matchesCurrentContext(InAppNotification notification) {
    final payloadContext = notification.data['context']?.toString();
    if (payloadContext != null && payloadContext.isNotEmpty) {
      return payloadContext == state.context;
    }

    if (state.context != 'participant') return true;

    final type = notification.type.toLowerCase();
    if (type.startsWith('vendor_') ||
        type.startsWith('document_') ||
        type.startsWith('payout_') ||
        type == 'new_booking' ||
        type == 'organization_join_requested') {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

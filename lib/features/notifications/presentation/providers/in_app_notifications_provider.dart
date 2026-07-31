import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/in_app_notification.dart';
import '../../domain/repositories/in_app_notifications_repository.dart';

const _notificationStateNotProvided = Object();

final inAppNotificationsProvider =
    StateNotifierProvider<InAppNotificationsNotifier, InAppNotificationsState>(
        (ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  return InAppNotificationsNotifier(
    repository: ref.watch(inAppNotificationsRepositoryProvider),
    ref: ref,
    accountId: accountId,
    ownerSession: ownerSession,
  );
});

class InAppNotificationsState {
  final AsyncValue<List<InAppNotification>> notifications;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
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
    this.loadMoreError,
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
    Object? loadMoreError = _notificationStateNotProvided,
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
      loadMoreError: identical(
        loadMoreError,
        _notificationStateNotProvided,
      )
          ? this.loadMoreError
          : loadMoreError,
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
  final String? _accountId;
  final AuthSessionKey _ownerSession;

  int _inboxRequestGeneration = 0;
  int _unreadRequestGeneration = 0;
  int _mutationGeneration = 0;

  InAppNotificationsNotifier({
    required InAppNotificationsRepository repository,
    required Ref ref,
    required String? accountId,
    required AuthSessionKey ownerSession,
  })  : _repository = repository,
        _ref = ref,
        _accountId = accountId,
        _ownerSession = ownerSession,
        super(const InAppNotificationsState()) {
    WidgetsBinding.instance.addObserver(this);
    _bootstrapAuthListener();
  }

  void _bootstrapAuthListener() {
    final authState = _ref.read(authProvider);
    if (_isCurrentAccount) {
      state = state.copyWith(context: _contextFor(authState));
      refreshUnreadCount();
    }

    _ref.listen<AuthState>(authProvider, (previous, next) {
      // Account changes recreate this provider because its factory watches
      // authSessionUserIdProvider. This listener only handles a role/context
      // change for the same authenticated account.
      final previousAccountId =
          previous?.isAuthenticated == true ? previous?.user?.id.trim() : null;
      final nextAccountId = next.isAuthenticated ? next.user?.id.trim() : null;
      final isSameAccountUpdate =
          previousAccountId == _accountId && nextAccountId == _accountId;
      if (_isCurrentAccount && isSameAccountUpdate) {
        final nextContext = _contextFor(next);
        final contextChanged = state.context != nextContext;
        if (contextChanged) {
          _invalidateRequests();
          state = state.copyWith(
            context: nextContext,
            notifications: const AsyncValue.data([]),
            hasLoadedInbox: false,
            currentPage: AppConstants.initialPage,
            hasMore: false,
            clearOrganizationId: true,
          );
        }
        refreshUnreadCount();
        if (state.hasLoadedInbox && !contextChanged) {
          load(refresh: true);
        }
      }
    });
  }

  bool get _isCurrentAccount {
    if (!mounted || _accountId == null) return false;
    return identical(_ref.read(authSessionKeyProvider), _ownerSession) &&
        _ref.read(authSessionUserIdProvider) == _accountId;
  }

  bool _isCurrentInboxRequest({
    required int generation,
    required String context,
    required String? organizationId,
    required bool unreadOnly,
  }) {
    return _isCurrentAccount &&
        generation == _inboxRequestGeneration &&
        state.context == context &&
        state.organizationId == organizationId &&
        state.unreadOnly == unreadOnly;
  }

  bool _isCurrentUnreadRequest({
    required int generation,
    required String context,
    required String? organizationId,
  }) {
    return _isCurrentAccount &&
        generation == _unreadRequestGeneration &&
        state.context == context &&
        state.organizationId == organizationId;
  }

  void _invalidateRequests() {
    _inboxRequestGeneration++;
    _unreadRequestGeneration++;
    _mutationGeneration++;
  }

  String _contextFor(AuthState authState) {
    return switch (authState.user?.role) {
      UserRole.partner => 'vendor',
      UserRole.admin => 'admin',
      _ => 'participant',
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!_isCurrentAccount) return;

    refreshUnreadCount();
    if (this.state.hasLoadedInbox) {
      load(refresh: true);
    }
  }

  Future<void> refreshUnreadCount() async {
    if (!_isCurrentAccount) return;

    final generation = ++_unreadRequestGeneration;
    final requestContext = state.context;
    final requestOrganizationId = state.organizationId;

    try {
      final count = await _repository.getUnreadCount(
        context: requestContext,
        organizationId: requestOrganizationId,
      );
      if (!_isCurrentUnreadRequest(
        generation: generation,
        context: requestContext,
        organizationId: requestOrganizationId,
      )) {
        return;
      }
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
    if (!_isCurrentAccount) return;

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
        loadMoreError: null,
      );
    }

    final generation = ++_inboxRequestGeneration;
    final unreadGeneration = ++_unreadRequestGeneration;
    final requestContext = state.context;
    final requestOrganizationId = state.organizationId;

    try {
      final page = await _repository.getNotifications(
        page: AppConstants.initialPage,
        perPage: AppConstants.itemsPerPage,
        unreadOnly: nextUnreadOnly,
        context: requestContext,
        organizationId: requestOrganizationId,
      );
      if (!_isCurrentInboxRequest(
        generation: generation,
        context: requestContext,
        organizationId: requestOrganizationId,
        unreadOnly: nextUnreadOnly,
      )) {
        return;
      }
      final unreadCount = await _repository.getUnreadCount(
        context: requestContext,
        organizationId: requestOrganizationId,
      );
      if (!_isCurrentInboxRequest(
        generation: generation,
        context: requestContext,
        organizationId: requestOrganizationId,
        unreadOnly: nextUnreadOnly,
      )) {
        return;
      }
      final canApplyUnreadCount = _isCurrentUnreadRequest(
        generation: unreadGeneration,
        context: requestContext,
        organizationId: requestOrganizationId,
      );
      state = state.copyWith(
        notifications: AsyncValue.data(_sort(page.notifications)),
        currentPage: page.currentPage,
        hasMore: page.hasMore,
        unreadOnly: nextUnreadOnly,
        unreadCount: canApplyUnreadCount ? unreadCount : state.unreadCount,
        hasLoadedInbox: true,
      );
    } catch (error, stackTrace) {
      if (!_isCurrentInboxRequest(
        generation: generation,
        context: requestContext,
        organizationId: requestOrganizationId,
        unreadOnly: nextUnreadOnly,
      )) {
        return;
      }
      state = state.copyWith(
        notifications: AsyncValue.error(error, stackTrace),
        unreadOnly: nextUnreadOnly,
        hasLoadedInbox: true,
      );
    }
  }

  Future<void> loadMore() async {
    if (!_isCurrentAccount) return;
    if (state.isLoadingMore || !state.hasMore || state.loadMoreError != null) {
      return;
    }
    final current = state.notifications.valueOrNull;
    if (current == null) return;

    final generation = ++_inboxRequestGeneration;
    final requestPage = state.currentPage + 1;
    final requestUnreadOnly = state.unreadOnly;
    final requestContext = state.context;
    final requestOrganizationId = state.organizationId;
    state = state.copyWith(isLoadingMore: true, loadMoreError: null);
    try {
      final page = await _repository.getNotifications(
        page: requestPage,
        perPage: AppConstants.itemsPerPage,
        unreadOnly: requestUnreadOnly,
        context: requestContext,
        organizationId: requestOrganizationId,
      );
      if (!_isCurrentInboxRequest(
        generation: generation,
        context: requestContext,
        organizationId: requestOrganizationId,
        unreadOnly: requestUnreadOnly,
      )) {
        return;
      }
      final latest = state.notifications.valueOrNull ?? current;
      state = state.copyWith(
        notifications:
            AsyncValue.data(_sort([...latest, ...page.notifications])),
        currentPage: page.currentPage,
        hasMore: page.hasMore,
        isLoadingMore: false,
        loadMoreError: null,
      );
    } catch (error) {
      if (!_isCurrentInboxRequest(
        generation: generation,
        context: requestContext,
        organizationId: requestOrganizationId,
        unreadOnly: requestUnreadOnly,
      )) {
        return;
      }
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: error,
      );
    }
  }

  Future<void> retryLoadMore() async {
    if (state.loadMoreError == null) return;
    state = state.copyWith(loadMoreError: null);
    await loadMore();
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
    if (!_isCurrentAccount) return;
    if (!_matchesCurrentContext(notification)) {
      refreshUnreadCount();
      return;
    }

    final current = state.notifications.valueOrNull;
    final nextUnreadCount = unreadCount ?? state.unreadCount + 1;
    _unreadRequestGeneration++;

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
    if (!_isCurrentAccount) return;
    final current = state.notifications.valueOrNull;
    if (current == null) return;
    final index = current.indexWhere((item) => item.id == id);
    if (index == -1 || current[index].isRead) return;

    final previous = state;
    final generation = ++_mutationGeneration;
    _unreadRequestGeneration++;
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
      if (_isCurrentAccount && generation == _mutationGeneration) {
        state = previous;
      }
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    if (!_isCurrentAccount) return;
    final current =
        state.notifications.valueOrNull ?? const <InAppNotification>[];
    final previous = state;
    final generation = ++_mutationGeneration;
    final requestContext = state.context;
    final requestOrganizationId = state.organizationId;
    _unreadRequestGeneration++;

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
        context: requestContext,
        organizationId: requestOrganizationId,
      );
      if (!_isCurrentAccount || generation != _mutationGeneration) return;
      await refresh();
    } catch (_) {
      if (_isCurrentAccount && generation == _mutationGeneration) {
        state = previous;
      }
      rethrow;
    }
  }

  Future<void> deleteNotification(String id) async {
    if (!_isCurrentAccount) return;
    final current = state.notifications.valueOrNull;
    if (current == null) return;
    final target = current.where((item) => item.id == id).firstOrNull;
    if (target == null) return;

    final previous = state;
    final generation = ++_mutationGeneration;
    _unreadRequestGeneration++;
    state = state.copyWith(
      notifications: AsyncValue.data(
        current.where((item) => item.id != id).toList(),
      ),
      unreadCount: target.isRead ? state.unreadCount : _decrementUnreadCount(),
    );

    try {
      await _repository.deleteNotification(id);
    } catch (_) {
      if (_isCurrentAccount && generation == _mutationGeneration) {
        state = previous;
      }
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
    _invalidateRequests();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

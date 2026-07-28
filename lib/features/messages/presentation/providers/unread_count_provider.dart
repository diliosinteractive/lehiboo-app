import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/messages_polling_datasource.dart';

typedef _UnreadSession = ({String userId, UserRole role});

final _unreadSessionProvider = Provider<_UnreadSession?>((ref) {
  return ref.watch(
    authProvider.select((state) {
      final user = state.user;
      if (!state.isAuthenticated || user == null) return null;
      return (userId: user.id, role: user.role);
    }),
  );
});

/// Account-scoped source of truth for the global messages unread badge.
///
/// It fetches the authoritative role-specific count on cold start and account
/// changes. Identity changes synchronously reset the count to zero, while a
/// request generation prevents a late response from a previous account from
/// leaking into the current session.
final unreadCountProvider =
    NotifierProvider<UnreadCountNotifier, int>(UnreadCountNotifier.new);

class UnreadCountNotifier extends Notifier<int> {
  int _requestGeneration = 0;
  Future<void>? _refreshInFlight;
  _UnreadSession? _refreshSession;
  bool _isDisposed = false;

  @override
  int build() {
    final session = ref.watch(_unreadSessionProvider);
    _isDisposed = false;

    // Invalidate any request started for the previous identity before exposing
    // the reset value.
    _requestGeneration++;
    _refreshInFlight = null;
    _refreshSession = null;
    ref.onDispose(() {
      _isDisposed = true;
      _requestGeneration++;
    });

    if (session != null) {
      unawaited(_bootstrap());
    }

    return 0;
  }

  /// Refreshes the authoritative count for the active account.
  ///
  /// Concurrent callers for the same account await the same request. Failures
  /// are rethrown so pull-to-refresh can report them while preserving the last
  /// good count.
  Future<void> refresh() {
    final session = ref.read(_unreadSessionProvider);
    if (session == null) {
      _requestGeneration++;
      state = 0;
      return Future.value();
    }

    final inFlight = _refreshInFlight;
    if (inFlight != null && _refreshSession == session) return inFlight;

    final generation = ++_requestGeneration;
    _refreshSession = session;
    late final Future<void> refresh;
    refresh = _load(session, generation).whenComplete(() {
      if (identical(_refreshInFlight, refresh)) {
        _refreshInFlight = null;
        _refreshSession = null;
      }
    });
    _refreshInFlight = refresh;
    return refresh;
  }

  /// Applies an authenticated real-time message event optimistically.
  void increment({required String forUserId}) {
    final session = ref.read(_unreadSessionProvider);
    if (session == null) {
      state = 0;
      return;
    }
    if (session.userId != forUserId) return;
    state++;
  }

  /// Removes locally-read messages without allowing a negative badge.
  void decrementBy(int count, {required String? forUserId}) {
    final session = ref.read(_unreadSessionProvider);
    if (session == null) {
      state = 0;
      return;
    }
    if (session.userId != forUserId) return;
    state = (state - count).clamp(0, state);
  }

  void reset() {
    state = 0;
  }

  Future<void> _bootstrap() async {
    try {
      await refresh();
    } catch (_) {
      // Cold-start failures stay unobtrusive. The messages screen or Home
      // pull-to-refresh can retry through [refresh].
    }
  }

  Future<void> _load(
    _UnreadSession session,
    int generation,
  ) async {
    try {
      final polling = ref.read(messagesPollingDatasourceProvider);
      final count = switch (session.role) {
        UserRole.subscriber => await polling.getTotalUnreadCount(),
        UserRole.partner => await polling.getVendorUnreadCount(),
        UserRole.admin => await polling.getAdminUnreadCount(),
      };

      if (_isCurrent(session, generation)) {
        state = count < 0 ? 0 : count;
      }
    } catch (error, stackTrace) {
      if (_isCurrent(session, generation)) {
        Error.throwWithStackTrace(error, stackTrace);
      }
    }
  }

  bool _isCurrent(_UnreadSession session, int generation) {
    if (_isDisposed || generation != _requestGeneration) return false;
    return ref.read(_unreadSessionProvider) == session;
  }
}

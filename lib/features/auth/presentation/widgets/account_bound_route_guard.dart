import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/auth_session_key_provider.dart';

/// Hides and closes a modal route as soon as it no longer belongs to the
/// account that opened it.
///
/// This is intentionally based on the exact user id, rather than the boolean
/// authentication status: a direct account A -> account B transition must be
/// treated the same way as logout.
class AccountBoundRouteGuard<T> extends ConsumerStatefulWidget {
  const AccountBoundRouteGuard({
    super.key,
    required this.ownerAccountId,
    required this.builder,
    this.invalidResult,
    this.ownerSession,
  });

  /// Exact session identity that opened this route. `null` deliberately
  /// represents the guest session, so a guest-owned modal also closes when a
  /// user signs in underneath it.
  final String? ownerAccountId;

  /// Optional opaque boundary for callers that must also reject an
  /// A -> B -> A cycle or another replacement of the same account session.
  final AuthSessionKey? ownerSession;
  final WidgetBuilder builder;
  final T? invalidResult;

  @override
  ConsumerState<AccountBoundRouteGuard<T>> createState() =>
      _AccountBoundRouteGuardState<T>();
}

class _AccountBoundRouteGuardState<T>
    extends ConsumerState<AccountBoundRouteGuard<T>> {
  ProviderSubscription<String?>? _sessionSubscription;
  ProviderSubscription<AuthSessionKey>? _opaqueSessionSubscription;
  bool _invalidated = false;
  bool _popScheduled = false;

  @override
  void initState() {
    super.initState();
    _sessionSubscription = ref.listenManual<String?>(
      authSessionUserIdProvider,
      (_, next) {
        if (next != widget.ownerAccountId) _invalidate();
      },
    );
    final ownerSession = widget.ownerSession;
    if (ownerSession != null) {
      _opaqueSessionSubscription = ref.listenManual<AuthSessionKey>(
        authSessionKeyProvider,
        (_, next) {
          if (!identical(next, ownerSession)) _invalidate();
        },
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_ownsCurrentSession()) {
        _invalidate();
      }
    });
  }

  bool _ownsCurrentSession() {
    if (ref.read(authSessionUserIdProvider) != widget.ownerAccountId) {
      return false;
    }
    final ownerSession = widget.ownerSession;
    return ownerSession == null ||
        identical(ref.read(authSessionKeyProvider), ownerSession);
  }

  void _invalidate() {
    if (_invalidated) return;
    _invalidated = true;
    _schedulePop();
  }

  void _schedulePop() {
    if (_popScheduled) return;
    _popScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final guardedRoute = ModalRoute.of(context);
      if (guardedRoute == null || !guardedRoute.isActive) return;
      final navigator = Navigator.of(context);

      // A guarded sheet can have a confirmation or picker above it. Close
      // those descendants first, then close the guarded route itself; simply
      // checking isCurrent once would leave the account-A modal alive forever.
      // A route that was already popped can remain mounted during its reverse
      // transition. Never search for that stale route with popUntil: it is no
      // longer in Navigator history, so the search would pop every live page.
      navigator.popUntil((route) => identical(route, guardedRoute));
      if (guardedRoute.isCurrent) {
        navigator.pop<T>(widget.invalidResult);
      }
    });
  }

  @override
  void dispose() {
    _sessionSubscription?.close();
    _opaqueSessionSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    final ownerSession = widget.ownerSession;
    final currentSession =
        ownerSession == null ? null : ref.watch(authSessionKeyProvider);
    if (currentAccountId != widget.ownerAccountId ||
        (ownerSession != null && !identical(currentSession, ownerSession))) {
      _invalidate();
      return const SizedBox.shrink();
    }
    if (_invalidated) return const SizedBox.shrink();
    return widget.builder(context);
  }
}

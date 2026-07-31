import 'package:dio/dio.dart';

/// Opaque identity for one exact authentication epoch.
///
/// Equality is intentionally object identity. A request created by account A
/// therefore stays stale after an A -> B -> A cycle even though the final
/// account id is the same string again.
class AuthRequestSession {
  AuthRequestSession({required this.accountId});

  final String? accountId;

  bool get isAuthenticated => accountId != null;
}

/// Synchronous source used by Dio before any asynchronous token lookup.
abstract interface class AuthSessionOwnership {
  AuthRequestSession capture();

  bool isCurrent(AuthRequestSession session);
}

/// Optional capability for synchronously mirroring the current epoch into a
/// transport's invocation-time options.
abstract interface class AuthSessionInvocationStampSource {
  AuthSessionInvocationStampBinding bindInvocationStampSink(
    void Function(AuthRequestSession session) sink,
  );
}

class AuthSessionInvocationStampBinding {
  AuthSessionInvocationStampBinding(this._onClose);

  final void Function() _onClose;
  bool _closed = false;

  void close() {
    if (_closed) return;
    _closed = true;
    _onClose();
  }
}

abstract interface class _RetiringAuthSessionOwnership {
  AuthRequestSession captureForPath(String path);

  bool isAuthorizedForPath(AuthRequestSession session, String path);
}

AuthRequestSession captureAuthSessionForPath(
  AuthSessionOwnership sessions,
  String path,
) {
  if (sessions case final _RetiringAuthSessionOwnership retiring) {
    return retiring.captureForPath(path);
  }
  return sessions.capture();
}

bool isAuthSessionAuthorizedForPath(
  AuthSessionOwnership sessions,
  AuthRequestSession session,
  String path,
) {
  if (sessions case final _RetiringAuthSessionOwnership retiring) {
    return retiring.isAuthorizedForPath(session, path);
  }
  return sessions.isCurrent(session);
}

/// Process-wide auth epoch registry used by the app's singleton Dio client.
///
/// [AuthSessionTransportBinding] rotates it synchronously for every auth-state
/// transition. Keeping this class independent from Riverpod avoids a circular
/// dependency between the auth provider and Dio configuration.
class AuthSessionOwnershipRegistry
    implements
        AuthSessionOwnership,
        AuthSessionInvocationStampSource,
        _RetiringAuthSessionOwnership {
  AuthSessionOwnershipRegistry._();

  static final AuthSessionOwnershipRegistry instance =
      AuthSessionOwnershipRegistry._();

  AuthRequestSession _current = AuthRequestSession(accountId: null);
  AuthRequestSession? _retiring;
  int _retirementGeneration = 0;
  final Set<void Function(AuthRequestSession)> _invocationStampSinks = {};

  static const _retirementPaths = {
    '/auth/device-tokens/all',
    '/auth/logout',
  };

  @override
  AuthRequestSession capture() => _current;

  @override
  bool isCurrent(AuthRequestSession session) => identical(_current, session);

  @override
  AuthSessionInvocationStampBinding bindInvocationStampSink(
    void Function(AuthRequestSession session) sink,
  ) {
    _invocationStampSinks.add(sink);
    sink(_current);
    return AuthSessionInvocationStampBinding(
      () => _invocationStampSinks.remove(sink),
    );
  }

  @override
  AuthRequestSession captureForPath(String path) {
    final retiring = _retiring;
    if (!_current.isAuthenticated &&
        retiring != null &&
        _retirementPaths.contains(path)) {
      return retiring;
    }
    return capture();
  }

  @override
  bool isAuthorizedForPath(AuthRequestSession session, String path) {
    return isCurrent(session) ||
        (!_current.isAuthenticated &&
            _retirementPaths.contains(path) &&
            identical(_retiring, session));
  }

  void rotate({required String? accountId}) {
    final normalized = _normalizeAccountId(accountId);
    if (normalized != null && normalized.isNotEmpty && _retiring != null) {
      // A newer authenticated identity always revokes the retiring permit
      // before any queued cleanup request can read that identity's token.
      clearRetirement();
    }
    _current = AuthRequestSession(
      accountId: normalized,
    );
    for (final sink in List.of(_invocationStampSinks)) {
      sink(_current);
    }
  }

  /// Rotates only when the effective account boundary changes.
  ///
  /// Profile/avatar/error publications for the same authenticated account do
  /// not invalidate transport requests. Real A -> B -> A transitions still
  /// create two new opaque epochs because each adjacent id differs.
  bool rotateIfAccountChanged({required String? accountId}) {
    final normalized = _normalizeAccountId(accountId);
    if (_current.accountId == normalized) return false;
    rotate(accountId: normalized);
    return true;
  }

  static String? _normalizeAccountId(String? accountId) {
    final normalized = accountId?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  /// Keeps the old bearer usable only for the two server-side logout cleanup
  /// calls after UI auth state has already been hidden synchronously.
  AuthSessionRetirement? beginRetirement() {
    final session = _current;
    if (!session.isAuthenticated) return null;
    final generation = ++_retirementGeneration;
    _retiring = session;
    return AuthSessionRetirement._(this, generation);
  }

  void clearRetirement() {
    _retirementGeneration++;
    _retiring = null;
  }

  void _endRetirement(int generation) {
    if (generation != _retirementGeneration) return;
    _retiring = null;
  }
}

class AuthSessionRetirement {
  AuthSessionRetirement._(this._registry, this._generation);

  final AuthSessionOwnershipRegistry _registry;
  final int _generation;
  bool _closed = false;

  void close() {
    if (_closed) return;
    _closed = true;
    _registry._endRetirement(_generation);
  }
}

/// Stamps request ownership before it can queue behind the asynchronous JWT
/// interceptor. Retries preserve the original stamp.
class AuthSessionOwnershipInterceptor extends Interceptor {
  AuthSessionOwnershipInterceptor({AuthSessionOwnership? sessions})
      : _sessions = sessions ?? AuthSessionOwnershipRegistry.instance;

  static const requestSessionExtraKey = 'auth_request_session';
  static const invocationSessionExtraKey = 'auth_invocation_session';

  final AuthSessionOwnership _sessions;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    ensureAuthRequestSession(_sessions, options);
    handler.next(options);
  }
}

/// Mirrors the live epoch into [Dio.options]. Dio copies `BaseOptions.extra`
/// synchronously while composing each request, before interceptor futures are
/// scheduled, making that copied object the true invocation-time stamp.
AuthSessionInvocationStampBinding bindAuthSessionInvocationStamp(
  Dio dio, {
  AuthSessionOwnership? sessions,
}) {
  final source = sessions ?? AuthSessionOwnershipRegistry.instance;

  void stamp(AuthRequestSession session) {
    dio.options
            .extra[AuthSessionOwnershipInterceptor.invocationSessionExtraKey] =
        session;
  }

  if (source is AuthSessionInvocationStampSource) {
    return (source as AuthSessionInvocationStampSource)
        .bindInvocationStampSink(stamp);
  }
  stamp(source.capture());
  return AuthSessionInvocationStampBinding(() {});
}

AuthRequestSession? authInvocationSessionOf(RequestOptions options) {
  final value =
      options.extra[AuthSessionOwnershipInterceptor.invocationSessionExtraKey];
  return value is AuthRequestSession ? value : null;
}

/// Resolves and persists the request owner without ever promoting a stale
/// invocation to the current account.
///
/// A still-current guest invocation may intentionally borrow the retiring
/// account only for the two logout cleanup paths. A stale guest/account stamp
/// is preserved, allowing the normal authorization check to reject it.
AuthRequestSession ensureAuthRequestSession(
  AuthSessionOwnership sessions,
  RequestOptions options,
) {
  final existing = authRequestSessionOf(options);
  if (existing != null) return existing;

  final invocation = authInvocationSessionOf(options);
  final resolved = invocation == null
      ? captureAuthSessionForPath(sessions, options.path)
      : sessions.isCurrent(invocation)
          ? captureAuthSessionForPath(sessions, options.path)
          : invocation;
  options.extra[AuthSessionOwnershipInterceptor.requestSessionExtraKey] =
      resolved;
  return resolved;
}

class AuthSessionChangedException implements Exception {
  const AuthSessionChangedException();

  @override
  String toString() => 'The authentication session changed during the request.';
}

AuthRequestSession? authRequestSessionOf(RequestOptions options) {
  final value =
      options.extra[AuthSessionOwnershipInterceptor.requestSessionExtraKey];
  return value is AuthRequestSession ? value : null;
}

DioException staleAuthSessionException(
  RequestOptions options, {
  Response<dynamic>? response,
}) {
  return DioException(
    requestOptions: options,
    response: response,
    type: DioExceptionType.cancel,
    error: const AuthSessionChangedException(),
    message: 'Authentication changed while the request was in progress.',
  );
}

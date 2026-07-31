import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:lehiboo/core/constants/app_constants.dart';
import 'package:lehiboo/core/network/auth_credential_mutation_coordinator.dart';
import 'package:lehiboo/core/network/auth_session_ownership.dart';

void main() {
  dotenv.testLoad();

  test('same account keeps its epoch while A to B to A rotates it', () {
    final sessions = AuthSessionOwnershipRegistry.instance;
    sessions.clearRetirement();
    sessions.rotate(accountId: null);
    addTearDown(() {
      sessions.clearRetirement();
      sessions.rotate(accountId: null);
    });

    expect(sessions.rotateIfAccountChanged(accountId: 'account-a'), isTrue);
    final firstA = sessions.capture();
    expect(sessions.rotateIfAccountChanged(accountId: ' account-a '), isFalse);
    expect(identical(sessions.capture(), firstA), isTrue);

    expect(sessions.rotateIfAccountChanged(accountId: 'account-b'), isTrue);
    expect(sessions.rotateIfAccountChanged(accountId: 'account-a'), isTrue);
    expect(identical(sessions.capture(), firstA), isFalse);
  });

  test('queued account-A requests never acquire account-B bearer token',
      () async {
    final sessions = _MutableAuthSessions('account-a');
    final storage = _ControlledTokenStorage('token-a')..blockFirstRead();
    final adapter = _RecordingAdapter();
    final dio = _dio(sessions, storage, adapter);
    addTearDown(() => dio.close(force: true));

    final first = dio.get<void>('/me/first');
    await storage.firstReadStarted.future;
    final second = dio.get<void>('/me/second');
    await _pumpUntil(() => sessions.captureCount >= 2);

    sessions.rotate('account-b');
    storage.accessToken = 'token-b';
    storage.releaseFirstRead('token-b');

    await expectLater(first, throwsA(_isStaleSessionCancellation));
    await expectLater(second, throwsA(_isStaleSessionCancellation));
    expect(adapter.requests, isEmpty);
    expect(storage.accessTokenReads, 1);

    final response = await dio.get<void>('/me/current');
    expect(response.statusCode, 200);
    expect(adapter.requests, hasLength(1));
    expect(
      adapter.requests.single.headers['Authorization'],
      'Bearer token-b',
    );
  });

  test('request invocation under A cannot be stamped as B later', () async {
    final sessions = _MutableAuthSessions('account-a');
    final storage = _ControlledTokenStorage('token-a');
    final adapter = _RecordingAdapter();
    final dio = _dio(sessions, storage, adapter);
    addTearDown(() => dio.close(force: true));

    // No pump/await between invocation and rotation: Dio has composed the
    // RequestOptions but has not run its first interceptor callback yet.
    final request = dio.get<void>('/me/account-a-payload');
    sessions.rotate('account-b');
    storage.accessToken = 'token-b';

    await expectLater(request, throwsA(_isStaleSessionCancellation));
    expect(storage.accessTokenReads, 0);
    expect(adapter.requests, isEmpty);
  });

  test('late response is rejected after an A to B to A cycle', () async {
    final sessions = _MutableAuthSessions('account-a');
    final storage = _ControlledTokenStorage('token-a');
    final responseGate = Completer<void>();
    final adapter = _RecordingAdapter(responseGate: responseGate);
    final dio = _dio(sessions, storage, adapter);
    addTearDown(() => dio.close(force: true));

    final request = dio.get<Map<String, dynamic>>('/me/private');
    await adapter.requestStarted.future;

    sessions.rotate('account-b');
    sessions.rotate('account-a');
    responseGate.complete();

    await expectLater(request, throwsA(_isStaleSessionCancellation));
    expect(adapter.requests, hasLength(1));
  });

  test('retiring account bearer is limited to explicit logout cleanup paths',
      () async {
    final sessions = AuthSessionOwnershipRegistry.instance;
    sessions.rotate(accountId: 'account-a');
    final retirement = sessions.beginRetirement();
    sessions.rotate(accountId: null);
    addTearDown(() {
      retirement?.close();
      sessions.clearRetirement();
      sessions.rotate(accountId: null);
    });
    final storage = _ControlledTokenStorage('token-a');
    final adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    final invocationBinding = bindAuthSessionInvocationStamp(dio);
    dio.httpClientAdapter = adapter;
    dio.interceptors.addAll([
      AuthSessionOwnershipInterceptor(sessions: sessions),
      JwtAuthInterceptor.withTokenStorage(
        storage,
        authSessions: sessions,
      ),
    ]);
    addTearDown(() => dio.close(force: true));
    addTearDown(invocationBinding.close);

    await dio.delete<void>('/auth/device-tokens/all');
    await dio.get<void>('/me/private');
    retirement?.close();
    await dio.post<void>('/auth/logout');

    expect(adapter.requests, hasLength(3));
    expect(adapter.requests[0].headers['Authorization'], 'Bearer token-a');
    expect(adapter.requests[1].headers['Authorization'], isNull);
    expect(adapter.requests[2].headers['Authorization'], isNull);
  });

  test('new authenticated identity revokes a blocked retirement request',
      () async {
    final sessions = AuthSessionOwnershipRegistry.instance;
    sessions.rotate(accountId: 'account-a');
    final retirement = sessions.beginRetirement();
    sessions.rotate(accountId: null);
    addTearDown(() {
      retirement?.close();
      sessions.clearRetirement();
      sessions.rotate(accountId: null);
    });
    final storage = _ControlledTokenStorage('token-a')..blockFirstRead();
    final adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    final invocationBinding = bindAuthSessionInvocationStamp(dio);
    dio.httpClientAdapter = adapter;
    dio.interceptors.addAll([
      AuthSessionOwnershipInterceptor(sessions: sessions),
      JwtAuthInterceptor.withTokenStorage(
        storage,
        authSessions: sessions,
      ),
    ]);
    addTearDown(() => dio.close(force: true));
    addTearDown(invocationBinding.close);

    final request = dio.post<void>('/auth/logout');
    await storage.firstReadStarted.future;
    sessions.rotate(accountId: 'account-b');
    storage.accessToken = 'token-b';
    storage.releaseFirstRead('token-b');

    await expectLater(request, throwsA(_isStaleSessionCancellation));
    expect(adapter.requests, isEmpty);
  });

  test(
      'stale refresh write cannot complete after a newer login credential pair',
      () async {
    final sessions = _MutableAuthSessions('account-a');
    final storage = _ControlledTokenStorage('access-a')
      ..refreshToken = 'refresh-a'
      ..blockFirstAccessWrite();
    final credentialMutations = AuthCredentialMutationCoordinator();
    final adapter = _RecordingAdapter(statusCode: 401);
    final dio = _dio(
      sessions,
      storage,
      adapter,
      credentialMutations: credentialMutations,
      refreshTokenRequest: (refreshToken) async {
        expect(refreshToken, 'refresh-a');
        return {
          'data': {
            'tokens': {
              'access_token': 'refreshed-access-a',
              'refresh_token': 'refreshed-refresh-a',
            },
          },
        };
      },
    );
    addTearDown(() => dio.close(force: true));

    final requestExpectation = expectLater(
      dio.get<void>('/me/private'),
      throwsA(_isStaleSessionCancellation),
    );
    await storage.firstAccessWriteStarted.future;

    // Production login rotates A to an unauthenticated loading epoch before
    // its repository persists B. B's pair mutation must wait for the refresh
    // lease, then deterministically be the final writer.
    sessions.rotate(null);
    var loginMutationStarted = false;
    final loginMutation = credentialMutations.run(() async {
      loginMutationStarted = true;
      await storage.write(AppConstants.keyAuthToken, 'access-b');
      await storage.write(AppConstants.keyRefreshToken, 'refresh-b');
      sessions.rotate('account-b');
    });
    await Future<void>.delayed(Duration.zero);
    expect(loginMutationStarted, isFalse);

    storage.releaseFirstAccessWrite();
    await loginMutation;
    await requestExpectation;

    expect(storage.accessToken, 'access-b');
    expect(storage.refreshToken, 'refresh-b');
  });
}

final Matcher _isStaleSessionCancellation = isA<DioException>()
    .having((error) => error.type, 'type', DioExceptionType.cancel)
    .having(
      (error) => error.error,
      'error',
      isA<AuthSessionChangedException>(),
    );

Dio _dio(
  _MutableAuthSessions sessions,
  _ControlledTokenStorage storage,
  _RecordingAdapter adapter, {
  AuthCredentialMutationCoordinator? credentialMutations,
  RefreshTokenRequest? refreshTokenRequest,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  bindAuthSessionInvocationStamp(dio, sessions: sessions);
  dio.httpClientAdapter = adapter;
  dio.interceptors.addAll([
    AuthSessionOwnershipInterceptor(sessions: sessions),
    JwtAuthInterceptor.withTokenStorage(
      storage,
      authSessions: sessions,
      credentialMutations: credentialMutations,
      refreshTokenRequest: refreshTokenRequest,
    ),
  ]);
  return dio;
}

Future<void> _pumpUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100 && !predicate(); attempt++) {
    await Future<void>.delayed(Duration.zero);
  }
  expect(predicate(), isTrue);
}

class _MutableAuthSessions
    implements AuthSessionOwnership, AuthSessionInvocationStampSource {
  _MutableAuthSessions(String? accountId) {
    rotate(accountId);
  }

  late AuthRequestSession _current;
  int captureCount = 0;
  final Set<void Function(AuthRequestSession)> _stampSinks = {};

  void rotate(String? accountId) {
    _current = AuthRequestSession(accountId: accountId);
    for (final sink in List.of(_stampSinks)) {
      sink(_current);
    }
  }

  @override
  AuthRequestSession capture() {
    captureCount++;
    return _current;
  }

  @override
  bool isCurrent(AuthRequestSession session) => identical(session, _current);

  @override
  AuthSessionInvocationStampBinding bindInvocationStampSink(
    void Function(AuthRequestSession session) sink,
  ) {
    _stampSinks.add(sink);
    sink(_current);
    return AuthSessionInvocationStampBinding(() => _stampSinks.remove(sink));
  }
}

class _ControlledTokenStorage implements AuthTokenStorage {
  _ControlledTokenStorage(this.accessToken);

  String? accessToken;
  String? refreshToken;
  int accessTokenReads = 0;
  int accessTokenWrites = 0;
  final firstReadStarted = Completer<void>();
  final firstAccessWriteStarted = Completer<void>();
  Completer<String?>? _firstReadGate;
  Completer<void>? _firstAccessWriteGate;

  void blockFirstRead() {
    _firstReadGate = Completer<String?>();
  }

  void releaseFirstRead(String? value) {
    _firstReadGate?.complete(value);
  }

  void blockFirstAccessWrite() {
    _firstAccessWriteGate = Completer<void>();
  }

  void releaseFirstAccessWrite() {
    _firstAccessWriteGate?.complete();
  }

  @override
  Future<String?> read(String key) {
    if (key == AppConstants.keyAuthToken) {
      accessTokenReads++;
      final gate = _firstReadGate;
      if (accessTokenReads == 1 && gate != null) {
        if (!firstReadStarted.isCompleted) firstReadStarted.complete();
        return gate.future;
      }
      if (!firstReadStarted.isCompleted) firstReadStarted.complete();
      return Future<String?>.value(accessToken);
    }
    return Future<String?>.value(refreshToken);
  }

  @override
  Future<void> write(String key, String value) async {
    if (key == AppConstants.keyAuthToken) {
      accessTokenWrites++;
      final gate = _firstAccessWriteGate;
      if (accessTokenWrites == 1 && gate != null) {
        if (!firstAccessWriteStarted.isCompleted) {
          firstAccessWriteStarted.complete();
        }
        await gate.future;
      }
      accessToken = value;
    } else {
      refreshToken = value;
    }
  }

  @override
  Future<void> delete(String key) async {
    if (key == AppConstants.keyAuthToken) {
      accessToken = null;
    } else {
      refreshToken = null;
    }
  }
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({
    this.responseGate,
    this.statusCode = 200,
  });

  final Completer<void>? responseGate;
  final int statusCode;
  final requestStarted = Completer<void>();
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (!requestStarted.isCompleted) requestStarted.complete();
    await responseGate?.future;
    return ResponseBody.fromString(
      '{"ok":true}',
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

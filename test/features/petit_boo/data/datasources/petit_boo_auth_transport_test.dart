import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lehiboo/core/constants/app_constants.dart';
import 'package:lehiboo/core/network/auth_session_ownership.dart';
import 'package:lehiboo/features/petit_boo/data/datasources/petit_boo_api_datasource.dart';
import 'package:lehiboo/features/petit_boo/data/datasources/petit_boo_sse_datasource.dart';

void main() {
  test('Petit Boo invocation under A cannot be stamped as B later', () async {
    final sessions = _MutableAuthSessions('account-a');
    var tokenReads = 0;
    final adapter = _RecordingAdapter();
    final dio = _dio(
      sessions,
      adapter,
      readToken: () async {
        tokenReads++;
        return 'account-b-token';
      },
    );
    addTearDown(() => dio.close(force: true));

    final request = dio.post<void>('/api/v1/actions/private/confirm');
    sessions.rotate('account-b');

    await expectLater(request, throwsA(_isStaleSessionCancellation));
    expect(tokenReads, 0);
    expect(adapter.requests, isEmpty);
  });

  test('Petit Boo REST request cannot acquire a later account bearer',
      () async {
    final sessions = _MutableAuthSessions('account-a');
    final tokenRead = Completer<String?>();
    final tokenReadStarted = Completer<void>();
    final adapter = _RecordingAdapter();
    final dio = _dio(
      sessions,
      adapter,
      readToken: () {
        tokenReadStarted.complete();
        return tokenRead.future;
      },
    );
    addTearDown(() => dio.close(force: true));

    final request = dio.post<void>(
      '/api/v1/actions/private-action/confirm',
    );
    await tokenReadStarted.future;

    sessions.rotate('account-b');
    sessions.rotate('account-a');
    tokenRead.complete('new-account-a-token');

    await expectLater(request, throwsA(_isStaleSessionCancellation));
    expect(adapter.requests, isEmpty);
  });

  test('Petit Boo REST never exposes a late response to a replacement session',
      () async {
    final sessions = _MutableAuthSessions('account-a');
    final adapter = _RecordingAdapter(blockResponse: true);
    final dio = _dio(
      sessions,
      adapter,
      readToken: () async => 'account-a-token',
    );
    addTearDown(() => dio.close(force: true));

    final request = dio.get<Map<String, dynamic>>('/api/v1/sessions');
    await adapter.requestStarted.future;
    expect(
      adapter.requests.single.headers['Authorization'],
      'Bearer account-a-token',
    );

    sessions.rotate('account-b');
    adapter.releaseResponse();

    await expectLater(request, throwsA(_isStaleSessionCancellation));
  });

  test('Petit Boo SSE prompt cannot acquire a later account bearer', () async {
    final sessions = _MutableAuthSessions('account-a');
    final storage = _ControlledStorage();
    var clientCreations = 0;
    final source = PetitBooSseDataSource(
      baseUrl: 'https://petit-boo.example.test',
      storage: storage,
      authSessions: sessions,
      clientFactory: () {
        clientCreations++;
        return MockClient((_) async => http.Response('', 200));
      },
    );

    final result = source
        .sendMessage(
          sessionUuid: 'private-session-a',
          message: 'private prompt from account A',
          memoryEnabled: true,
        )
        .toList();
    await storage.readStarted.future;

    sessions.rotate('account-b');
    sessions.rotate('account-a');
    storage.complete('new-account-a-token');

    await expectLater(
      result,
      throwsA(
        isA<PetitBooSseException>()
            .having((error) => error.code, 'code', 'session_changed'),
      ),
    );
    expect(clientCreations, 0);
  });

  test('Petit Boo SSE ownership is captured before the stream is listened to',
      () async {
    final sessions = _MutableAuthSessions('account-a');
    final storage = _ControlledStorage();
    var clientCreations = 0;
    final source = PetitBooSseDataSource(
      baseUrl: 'https://petit-boo.example.test',
      storage: storage,
      authSessions: sessions,
      clientFactory: () {
        clientCreations++;
        return MockClient((_) async => http.Response('', 200));
      },
    );

    final staleStream = source.sendMessage(
      sessionUuid: 'private-session-a',
      message: 'private prompt from account A',
      memoryEnabled: true,
    );
    sessions.rotate('account-b');

    await expectLater(
      staleStream.toList(),
      throwsA(
        isA<PetitBooSseException>()
            .having((error) => error.code, 'code', 'session_changed'),
      ),
    );
    expect(storage.readStarted.isCompleted, isFalse);
    expect(clientCreations, 0);
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
  _RecordingAdapter adapter, {
  required Future<String?> Function() readToken,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://petit-boo.example.test'));
  bindAuthSessionInvocationStamp(dio, sessions: sessions);
  dio.httpClientAdapter = adapter;
  dio.interceptors.addAll([
    AuthSessionOwnershipInterceptor(sessions: sessions),
    PetitBooSessionAuthInterceptor(
      readToken: readToken,
      authSessions: sessions,
    ),
  ]);
  return dio;
}

class _MutableAuthSessions
    implements AuthSessionOwnership, AuthSessionInvocationStampSource {
  _MutableAuthSessions(String? accountId) {
    rotate(accountId);
  }

  late AuthRequestSession _current;
  final Set<void Function(AuthRequestSession)> _stampSinks = {};

  void rotate(String? accountId) {
    _current = AuthRequestSession(accountId: accountId);
    for (final sink in List.of(_stampSinks)) {
      sink(_current);
    }
  }

  @override
  AuthRequestSession capture() => _current;

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

class _ControlledStorage {
  final readStarted = Completer<void>();
  final _read = Completer<String?>();

  Future<String?> read({required String key}) {
    expect(key, AppConstants.keyAuthToken);
    if (!readStarted.isCompleted) readStarted.complete();
    return _read.future;
  }

  void complete(String? token) => _read.complete(token);
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({this.blockResponse = false});

  final bool blockResponse;
  final requests = <RequestOptions>[];
  final requestStarted = Completer<void>();
  final _responseGate = Completer<void>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (!requestStarted.isCompleted) requestStarted.complete();
    if (blockResponse) await _responseGate.future;
    return ResponseBody.fromString(
      '{"data":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  void releaseResponse() {
    if (!_responseGate.isCompleted) _responseGate.complete();
  }

  @override
  void close({bool force = false}) {
    releaseResponse();
  }
}

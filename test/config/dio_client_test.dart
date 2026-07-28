import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:lehiboo/core/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad();

  late FlutterSecureStorage storage;
  late ForceLogoutCallback? previousForceLogout;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      AppConstants.keyAuthToken: 'secret-access-token',
      AppConstants.keyRefreshToken: 'secret-refresh-token',
    });
    storage = const FlutterSecureStorage();
    previousForceLogout = DioClient.onForceLogout;
  });

  tearDown(() {
    DioClient.onForceLogout = previousForceLogout;
  });

  group('maskAuthTokenForDebugLog', () {
    test('masks short tokens completely', () {
      expect(maskAuthTokenForDebugLog('abcd1234'), '***');
      expect(maskAuthTokenForDebugLog('short'), '***');
    });

    test('keeps only the first and last four characters for longer tokens', () {
      expect(
        maskAuthTokenForDebugLog('abcdefghijklmnopqrstuvwxyz'),
        'abcd...wxyz',
      );
    });
  });

  test('hero slides are classified as a public endpoint', () {
    expect(JwtAuthInterceptor.isPublicPath('/hero-slides'), isTrue);
  });

  test('a 401 from hero slides does not expire the user session', () async {
    var forceLogoutCalls = 0;
    DioClient.onForceLogout = () async => forceLogoutCalls++;
    final dio = _unauthorizedDio(storage);
    final messages = <String>[];
    final previousDebugPrint = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message != null) messages.add(message);
    };
    addTearDown(() {
      debugPrint = previousDebugPrint;
      dio.close(force: true);
    });

    await expectLater(
      dio.get<void>('/hero-slides'),
      throwsA(isA<DioException>()),
    );

    expect(forceLogoutCalls, 0);
    expect(
      await storage.read(key: AppConstants.keyAuthToken),
      'secret-access-token',
    );
    expect(messages.join('\n'), isNot(contains('secret-access-token')));
  });

  test('a 401 from a protected endpoint expires the user session', () async {
    var forceLogoutCalls = 0;
    DioClient.onForceLogout = () async => forceLogoutCalls++;
    // No refresh token: this exercises the terminal protected-401 path
    // without making a network request to the configured refresh endpoint.
    await storage.delete(key: AppConstants.keyRefreshToken);
    final dio = _unauthorizedDio(storage);

    await expectLater(
      dio.get<void>('/me/alerts'),
      throwsA(isA<DioException>()),
    );

    expect(forceLogoutCalls, 1);
    expect(await storage.read(key: AppConstants.keyAuthToken), isNull);
    expect(await storage.read(key: AppConstants.keyRefreshToken), isNull);
  });

  test('a late 401 cannot expire a newer account session', () async {
    var forceLogoutCalls = 0;
    DioClient.onForceLogout = () async => forceLogoutCalls++;
    final dio = _unauthorizedDio(
      storage,
      beforeResponse: (_) async {
        await storage.write(
          key: AppConstants.keyAuthToken,
          value: 'new-account-access-token',
        );
        await storage.write(
          key: AppConstants.keyRefreshToken,
          value: 'new-account-refresh-token',
        );
      },
    );

    await expectLater(
      dio.get<void>('/me/alerts'),
      throwsA(isA<DioException>()),
    );

    expect(forceLogoutCalls, 0);
    expect(
      await storage.read(key: AppConstants.keyAuthToken),
      'new-account-access-token',
    );
    expect(
      await storage.read(key: AppConstants.keyRefreshToken),
      'new-account-refresh-token',
    );
  });
}

Dio _unauthorizedDio(
  FlutterSecureStorage storage, {
  Future<void> Function(RequestOptions)? beforeResponse,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.httpClientAdapter = _UnauthorizedAdapter(beforeResponse);
  dio.interceptors.add(JwtAuthInterceptor(storage));
  return dio;
}

class _UnauthorizedAdapter implements HttpClientAdapter {
  final Future<void> Function(RequestOptions)? _beforeResponse;

  _UnauthorizedAdapter([this._beforeResponse]);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await _beforeResponse?.call(options);
    return ResponseBody.fromString(
      '{"message":"Unauthorized"}',
      401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

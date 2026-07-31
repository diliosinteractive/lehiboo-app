import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/services/secure_storage_service.dart';
import 'package:lehiboo/features/auth/data/datasources/auth_api_datasource.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  test('late account-A refresh 401 cannot clear account-B credentials',
      () async {
    final api = _DeferredAuthApi();
    final storage = _ConditionalTokenStorage()..refreshToken = 'refresh-a';
    final repository = AuthRepositoryImpl(api, storage);

    final refresh = repository.refreshTokenIfNeeded();
    await api.refreshStarted.future;

    // A newer login owns storage before A's refresh failure arrives.
    storage.refreshToken = 'refresh-b';
    final request = RequestOptions(path: '/auth/refresh');
    api.refreshResult.completeError(
      DioException(
        requestOptions: request,
        response: Response<void>(requestOptions: request, statusCode: 401),
      ),
      StackTrace.current,
    );

    expect(await refresh, isFalse);
    expect(storage.refreshToken, 'refresh-b');
    expect(storage.conditionalClearCalls, 1);
    expect(storage.unconditionalClearCalls, 0);
  });
}

class _DeferredAuthApi implements AuthApiDataSource {
  final refreshStarted = Completer<void>();
  final refreshResult = Completer<TokensDto>();

  @override
  Future<TokensDto> refreshToken(String refreshToken) {
    if (!refreshStarted.isCompleted) refreshStarted.complete();
    return refreshResult.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ConditionalTokenStorage implements SecureStorageService {
  String? refreshToken;
  int conditionalClearCalls = 0;
  int unconditionalClearCalls = 0;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<bool> clearAuthDataIfRefreshMatches(
    String expectedRefreshToken,
  ) async {
    conditionalClearCalls++;
    if (refreshToken != expectedRefreshToken) return false;
    refreshToken = null;
    return true;
  }

  @override
  Future<void> clearAuthData() async {
    unconditionalClearCalls++;
    refreshToken = null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

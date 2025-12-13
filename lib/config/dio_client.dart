import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/constants/app_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

class DioClient {
  static late Dio _dio;
  static late FlutterSecureStorage _storage;

  static Dio get instance => _dio;
  static FlutterSecureStorage get storage => _storage;

  // Basic Auth helper removed

  static void initialize() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      JwtAuthInterceptor(_dio, _storage),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }
}

class JwtAuthInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;

  JwtAuthInterceptor(this._dio, this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for public endpoints
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/refresh',
      '/events',
      '/categories',
      '/thematiques',
      '/cities',
      '/filters',
    ];

    final isPublic = publicEndpoints.any((e) => options.path.startsWith(e));

    if (!isPublic) {
      final token = await _storage.read(key: AppConstants.keyAuthToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    // Add API key if configured
    if (AppConstants.apiKey.isNotEmpty) {
      options.headers['X-API-Key'] = AppConstants.apiKey;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _storage.read(key: AppConstants.keyRefreshToken);

        if (refreshToken != null) {
          // Create a new Dio instance to avoid interceptor loop
          final refreshDio = Dio(BaseOptions(
            baseUrl: AppConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

          final response = await refreshDio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.data['success'] == true) {
            final tokens = response.data['data']['tokens'] ?? response.data['data'];
            final newAccessToken = tokens['access_token'];
            final newRefreshToken = tokens['refresh_token'];

            // Save new tokens
            await _storage.write(key: AppConstants.keyAuthToken, value: newAccessToken);
            await _storage.write(key: AppConstants.keyRefreshToken, value: newRefreshToken);

            // Retry the original request with new token
            err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await _dio.fetch(err.requestOptions);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          }
        }

        // If refresh failed, clear tokens and reject
        await _clearTokens();
        _isRefreshing = false;
        return handler.reject(err);
      } catch (e) {
        await _clearTokens();
        _isRefreshing = false;
        return handler.reject(err);
      }
    }

    super.onError(err, handler);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConstants.keyAuthToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
    await _storage.delete(key: AppConstants.keyUserId);
    await _storage.delete(key: AppConstants.keyUserRole);
  }
}
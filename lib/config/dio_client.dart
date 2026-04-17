import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/constants/app_constants.dart';
import 'env_config.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

/// Callback type for force logout triggered by 401 interceptor.
typedef ForceLogoutCallback = Future<void> Function();

/// Singleton storage instance shared across the app
/// This ensures consistency between token writes (auth) and reads (interceptor)
class SharedSecureStorage {
  static final FlutterSecureStorage instance = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
}

class DioClient {
  static late Dio _dio;
  static ForceLogoutCallback? onForceLogout;

  static Dio get instance => _dio;
  static FlutterSecureStorage get storage => SharedSecureStorage.instance;

  static void initialize() {
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

    // Add Security Header (.htpasswd) if configured
    if (EnvConfig.htPassword.isNotEmpty) {
      final String username = EnvConfig.htUsername;
      final String password = EnvConfig.htPassword;
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      _dio.options.headers[EnvConfig.securityHeaderName] = basicAuth;
    }

    // Add interceptors
    _dio.interceptors.addAll([
      JwtAuthInterceptor(SharedSecureStorage.instance),
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

class JwtAuthInterceptor extends QueuedInterceptor {
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;

  JwtAuthInterceptor(this._storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for public endpoints
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/refresh',
      '/auth/otp',  // OTP endpoints: /auth/otp/send, /auth/otp/verify, /auth/otp/resend
      '/auth/check-email',
      '/events',
      '/categories',
      '/thematiques',
      '/cities',
      '/filters',
      '/home-feed',
      '/mobile/config',
      '/posts',
    ];

    final isPublic = publicEndpoints.any((e) => options.path.startsWith(e));

    if (!isPublic) {
      final token = await _storage.read(key: AppConstants.keyAuthToken);
      if (kDebugMode) {
        debugPrint('🔐 JwtAuthInterceptor: path=${options.path}, isPublic=$isPublic, hasToken=${token != null && token.isNotEmpty}');
      }
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ JwtAuthInterceptor: No token found for protected endpoint ${options.path}');
        }
      }
    }

    // Add API key if configured
    if (AppConstants.apiKey.isNotEmpty) {
      options.headers['X-API-Key'] = AppConstants.apiKey;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      if (kDebugMode) {
        debugPrint('🔐 JwtAuthInterceptor: 401 on ${err.requestOptions.path}');
      }

      final currentToken = await _storage.read(key: AppConstants.keyAuthToken);

      if (currentToken != null && currentToken.isNotEmpty) {
        // Token exists but server rejected it → session expired.
        // Clear local tokens and trigger force logout so the router
        // redirects to the login screen.
        if (kDebugMode) {
          debugPrint('🔐 JwtAuthInterceptor: Token expired → force logout');
        }
        await _storage.delete(key: AppConstants.keyAuthToken);
        await _storage.delete(key: AppConstants.keyRefreshToken);

        // Notify the auth layer (if wired up) so GoRouter redirects to login.
        await DioClient.onForceLogout?.call();
      } else {
        if (kDebugMode) {
          debugPrint('🔐 JwtAuthInterceptor: No token found, nothing to clear');
        }
      }

      _isRefreshing = false;
      return handler.reject(err);
    }

    super.onError(err, handler);
  }
}
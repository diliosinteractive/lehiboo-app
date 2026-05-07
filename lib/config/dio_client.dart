import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/constants/app_constants.dart';
import '../features/checkin/presentation/providers/active_organization_provider.dart';
import '../features/gamification/data/interceptors/hibons_update_interceptor.dart';
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
          'X-Platform': 'mobile',
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
      OrganizationHeaderInterceptor(),
      HibonsUpdateInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          // Concise mode: only show method + URL + status + timing.
          // Bodies/headers spammed thousands of lines per page.
          // Flip back to true to debug a specific request.
          request: true,
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }
}

/// Injects `X-Organization-Id` on vendor-scoped requests.
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md §6 — every `/vendor/...` call needs the
/// active organization UUID. We source it from the synchronous in-memory
/// cache populated by `ActiveOrganizationNotifier` (Riverpod can't be
/// awaited from a Dio interceptor).
///
/// Customer-facing routes are not touched. If the active org isn't set when
/// a vendor route is called, the request goes out without the header — the
/// backend will return 403 and the UI surfaces the picker. We deliberately
/// don't block the request here so failures stay observable rather than
/// being silently swallowed by the interceptor.
class OrganizationHeaderInterceptor extends Interceptor {
  static const _vendorPrefix = '/vendor/';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.path.startsWith(_vendorPrefix)) {
      final orgUuid = ActiveOrganizationCache.uuid;
      if (orgUuid != null && orgUuid.isNotEmpty) {
        options.headers['X-Organization-Id'] = orgUuid;
      } else if (kDebugMode) {
        debugPrint(
          '⚠️ OrganizationHeaderInterceptor: no active org for ${options.path}',
        );
      }
    }
    handler.next(options);
  }
}

class JwtAuthInterceptor extends QueuedInterceptor {
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;

  JwtAuthInterceptor(this._storage);

  /// Endpoints pour lesquels l'absence de token est attendue (juste pour le log).
  /// On envoie **toujours** le token si on en a un — même sur ces routes — car
  /// certaines sont user-aware (ex: `/events/{slug}/questions` renvoie
  /// `userVoted` si authentifié) ou cachent des sous-routes authentifiées
  /// derrière un même préfixe (ex: `/events/{slug}/my-question`).
  static const _publicPrefixes = [
    '/auth/login',
    '/auth/register',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/refresh',
    '/auth/otp',
    '/auth/check-email',
    '/events',
    '/categories',
    '/thematiques',
    '/cities',
    '/filters',
    '/home-feed',
    '/mobile/config',
    '/posts',
    '/stories',
  ];

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);

    // Toujours attacher le token si disponible. Le serveur l'ignore sur les
    // routes vraiment publiques, et en a besoin sur les sous-routes
    // authentifiées ou user-aware.
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else if (kDebugMode) {
      final isPublic =
          _publicPrefixes.any((e) => options.path.startsWith(e));
      if (!isPublic) {
        debugPrint(
          '⚠️ JwtAuthInterceptor: No token found for protected endpoint ${options.path}',
        );
      }
    }

    if (kDebugMode) {
      // Debug-only: print the full bearer so requests can be replayed via
      // curl/Postman. NEVER enable in release — exposes account credentials.
      final hasToken = token != null && token.isNotEmpty;
      debugPrint(
        '🔐 JwtAuthInterceptor: path=${options.path}, hasToken=$hasToken',
      );
      if (hasToken) {
        debugPrint('🔐   Authorization: Bearer $token');
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

      final path = err.requestOptions.path;
      final isPublic = _publicPrefixes.any((e) => path.startsWith(e));

      if (kDebugMode) {
        debugPrint(
          '🔐 JwtAuthInterceptor: 401 on $path (isPublic=$isPublic)',
        );
      }

      // Ne force-logout que pour les routes *réellement* authentifiées.
      // Un 401 sur une route publique signifie que le backend a rejeté un
      // token invalide sans que la ressource ne nécessite l'auth — inutile
      // et destructif de déconnecter l'user pour ça.
      if (!isPublic) {
        final currentToken = await _storage.read(
          key: AppConstants.keyAuthToken,
        );
        if (currentToken != null && currentToken.isNotEmpty) {
          if (kDebugMode) {
            debugPrint(
              '🔐 JwtAuthInterceptor: Token expired on protected route → force logout',
            );
          }
          await _storage.delete(key: AppConstants.keyAuthToken);
          await _storage.delete(key: AppConstants.keyRefreshToken);
          await DioClient.onForceLogout?.call();
        } else {
          if (kDebugMode) {
            debugPrint(
              '🔐 JwtAuthInterceptor: No token found, nothing to clear',
            );
          }
        }
      }

      _isRefreshing = false;
      return handler.reject(err);
    }

    super.onError(err, handler);
  }
}
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/constants/app_constants.dart';
import '../core/l10n/app_locale.dart';
import '../core/network/json_resilience.dart';
import '../features/checkin/presentation/providers/active_organization_provider.dart';
import '../features/gamification/data/interceptors/hibons_update_interceptor.dart';
import 'env_config.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

/// Callback type for force logout triggered by 401 interceptor.
typedef ForceLogoutCallback = Future<void> Function();

@visibleForTesting
String maskAuthTokenForDebugLog(String token) {
  if (token.length <= 8) return '***';

  return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
}

/// Singleton storage instance shared across the app
/// This ensures consistency between token writes (auth) and reads (interceptor)
class SharedSecureStorage {
  static const FlutterSecureStorage instance = FlutterSecureStorage(
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

    // Décodeur JSON instrumenté : capture le contexte autour de l'offset
    // fautif pour diagnostiquer les payloads malformés (ex: bug intermittent
    // "Unexpected character at offset N" sur /events).
    _dio.transformer = DiagnosticJsonTransformer();

    // Add Security Header (.htpasswd) if configured
    if (EnvConfig.htPassword.isNotEmpty) {
      final String username = EnvConfig.htUsername;
      final String password = EnvConfig.htPassword;
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      _dio.options.headers[EnvConfig.securityHeaderName] = basicAuth;
    }

    // Add interceptors
    _dio.interceptors.addAll([
      LocaleHeaderInterceptor(),
      JwtAuthInterceptor(SharedSecureStorage.instance),
      OrganizationHeaderInterceptor(),
      HibonsUpdateInterceptor(),
      // Retente une fois les GET qui échouent avec FormatException — absorbe
      // l'intermittence du payload corrompu en attendant le fix backend.
      JsonRetryInterceptor(_dio),
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

class LocaleHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = AppLocaleCache.languageCode;
    handler.next(options);
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

  static const _refreshPath = '/auth/refresh';

  /// Tentatives totales du refresh : 1 initiale + 2 retries.
  static const _maxRefreshAttempts = 3;

  /// Backoff de base entre deux tentatives de refresh (multiplié par le n° de
  /// tentative). Sauté quand on détecte qu'un pair a déjà rotaté le token.
  static const _refreshRetryBackoff = Duration(milliseconds: 400);

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
    _refreshPath,
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
    '/hero-slides',
  ];

  static const _noRefreshPrefixes = [
    '/auth/login',
    '/auth/register',
    '/auth/forgot-password',
    '/auth/reset-password',
    _refreshPath,
    '/auth/otp',
    '/auth/check-email',
  ];

  @visibleForTesting
  static bool isPublicPath(String path) {
    return _publicPrefixes.any((prefix) => path.startsWith(prefix));
  }

  static String? _requestBearerToken(RequestOptions options) {
    final authorization = options.headers['Authorization']?.toString();
    if (authorization == null ||
        !authorization.toLowerCase().startsWith('bearer ')) {
      return null;
    }
    final token = authorization.substring(7).trim();
    return token.isEmpty ? null : token;
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    final isRefreshRequest = options.path.startsWith(_refreshPath);

    // Toujours attacher le token si disponible. Le serveur l'ignore sur les
    // routes vraiment publiques, et en a besoin sur les sous-routes
    // authentifiées ou user-aware.
    if (!isRefreshRequest && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else if (kDebugMode) {
      final isPublic = isPublicPath(options.path);
      if (!isPublic) {
        debugPrint(
          '⚠️ JwtAuthInterceptor: No token found for protected endpoint ${options.path}',
        );
      }
    }

    if (kDebugMode) {
      final hasToken = !isRefreshRequest && token != null && token.isNotEmpty;
      debugPrint(
        '🔐 JwtAuthInterceptor: path=${options.path}, hasToken=$hasToken',
      );
      if (hasToken) {
        debugPrint(
          '🔐   Authorization: Bearer ${maskAuthTokenForDebugLog(token)}',
        );
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
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    final path = err.requestOptions.path;
    final isPublic = isPublicPath(path);
    if (isPublic) {
      if (kDebugMode) {
        debugPrint(
          '🔐 JwtAuthInterceptor: 401 on public route $path',
        );
      }
      return handler.reject(err);
    }

    // A public 401 must never acquire this lock: doing so can suppress a
    // concurrent protected 401 that genuinely needs to expire the session.
    if (_isRefreshing) {
      return super.onError(err, handler);
    }
    _isRefreshing = true;

    try {
      final failedRequestToken = _requestBearerToken(err.requestOptions);
      final currentToken = await _storage.read(
        key: AppConstants.keyAuthToken,
      );
      if (failedRequestToken == null || currentToken != failedRequestToken) {
        // The request may have been sent before logout/account switching.
        // Never let its late 401 expire the newer session now in storage.
        if (kDebugMode) {
          debugPrint(
            '🔐 JwtAuthInterceptor: Ignoring 401 from a stale protected request',
          );
        }
      } else {
        final canRefresh =
            !_noRefreshPrefixes.any((prefix) => path.startsWith(prefix));
        final refreshedTokens = canRefresh
            ? await _refreshAccessToken(
                expectedAccessToken: failedRequestToken,
              )
            : null;

        if (refreshedTokens != null) {
          try {
            final retryOptions = err.requestOptions;
            retryOptions.headers['Authorization'] =
                'Bearer ${refreshedTokens.accessToken}';
            if (AppConstants.apiKey.isNotEmpty) {
              retryOptions.headers['X-API-Key'] = AppConstants.apiKey;
            }

            final response =
                await DioClient.instance.fetch<dynamic>(retryOptions);
            return handler.resolve(response);
          } on DioException catch (retryError) {
            if (kDebugMode) {
              debugPrint(
                '🔐 JwtAuthInterceptor: retry after refresh failed '
                '(${retryError.response?.statusCode})',
              );
            }
            if (retryError.response?.statusCode == 401) {
              await _forceLogoutIfTokenPresent(
                expectedAccessToken: refreshedTokens.accessToken,
              );
            }
            return handler.reject(retryError);
          }
        }

        await _forceLogoutIfTokenPresent(
          expectedAccessToken: failedRequestToken,
        );
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '🔐 JwtAuthInterceptor: failed to clear expired session: $error',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
    } finally {
      _isRefreshing = false;
    }

    return handler.reject(err);
  }

  /// Rafraîchit l'access token avec jusqu'à [_maxRefreshAttempts] tentatives
  /// (1 initiale + 2 retries).
  ///
  /// Les retries couvrent deux situations :
  ///   1. **Échec réseau transitoire** pendant le POST /auth/refresh (timeout,
  ///      connexion coupée, 5xx) — on réessaie après un backoff.
  ///   2. **Course concurrente** : si le compte ou ses tokens changent pendant
  ///      le refresh, la réponse tardive est abandonnée afin de ne jamais
  ///      écraser la session plus récente.
  Future<_RefreshTokens?> _refreshAccessToken({
    required String expectedAccessToken,
  }) async {
    for (var attempt = 1; attempt <= _maxRefreshAttempts; attempt++) {
      final accessToken = await _storage.read(
        key: AppConstants.keyAuthToken,
      );
      if (accessToken != expectedAccessToken) return null;

      final refreshToken = await _storage.read(
        key: AppConstants.keyRefreshToken,
      );
      if (refreshToken == null || refreshToken.isEmpty) return null;

      try {
        final response = await _buildRefreshDio().post<Map<String, dynamic>>(
          _refreshPath,
          data: {'refresh_token': refreshToken},
        );

        final tokens = _parseRefreshTokens(response.data);
        if (tokens != null) {
          final currentAccessToken = await _storage.read(
            key: AppConstants.keyAuthToken,
          );
          final currentRefreshToken = await _storage.read(
            key: AppConstants.keyRefreshToken,
          );
          if (currentAccessToken != expectedAccessToken ||
              currentRefreshToken != refreshToken) {
            if (kDebugMode) {
              debugPrint(
                '🔐 JwtAuthInterceptor: discarded refresh from a stale session',
              );
            }
            return null;
          }

          await _storage.write(
            key: AppConstants.keyAuthToken,
            value: tokens.accessToken,
          );
          await _storage.write(
            key: AppConstants.keyRefreshToken,
            value: tokens.refreshToken,
          );
          if (kDebugMode) {
            debugPrint(
              '🔐 JwtAuthInterceptor: access token refreshed '
              '(tentative $attempt/$_maxRefreshAttempts)',
            );
          }
          return tokens;
        }

        // HTTP 200 mais payload sans tokens exploitables : réessayer ne sert à
        // rien (ce n'est ni transitoire ni une rotation), on abandonne.
        if (kDebugMode) {
          debugPrint(
            '🔐 JwtAuthInterceptor: refresh 200 sans tokens (tentative $attempt)',
          );
        }
        return null;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        // Erreur transitoire : pas de réponse (réseau/timeout) ou 5xx serveur.
        final isTransient = status == null || status >= 500;

        final currentAccessToken = await _storage.read(
          key: AppConstants.keyAuthToken,
        );
        final currentRefreshToken = await _storage.read(
          key: AppConstants.keyRefreshToken,
        );
        final sessionChanged = currentAccessToken != expectedAccessToken ||
            currentRefreshToken != refreshToken;
        if (sessionChanged) return null;

        final shouldRetry = attempt < _maxRefreshAttempts && isTransient;

        if (kDebugMode) {
          debugPrint(
            '🔐 JwtAuthInterceptor: refresh échoué '
            '(tentative $attempt/$_maxRefreshAttempts, status=$status, '
            'retry=$shouldRetry): ${e.message}',
          );
        }

        if (!shouldRetry) {
          if (isTransient) {
            Error.throwWithStackTrace(e, e.stackTrace);
          }
          return null;
        }
        await Future<void>.delayed(_refreshRetryBackoff * attempt);
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            '🔐 JwtAuthInterceptor: refresh erreur inattendue '
            '(tentative $attempt): $e',
          );
        }
        if (attempt >= _maxRefreshAttempts) rethrow;
        await Future<void>.delayed(_refreshRetryBackoff * attempt);
      }
    }
    return null;
  }

  Dio _buildRefreshDio() {
    final dio = Dio(
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

    dio.transformer = DiagnosticJsonTransformer();

    if (EnvConfig.htPassword.isNotEmpty) {
      final basicAuth = 'Basic ${base64Encode(
        utf8.encode('${EnvConfig.htUsername}:${EnvConfig.htPassword}'),
      )}';
      dio.options.headers[EnvConfig.securityHeaderName] = basicAuth;
    }

    if (AppConstants.apiKey.isNotEmpty) {
      dio.options.headers['X-API-Key'] = AppConstants.apiKey;
    }

    return dio;
  }

  _RefreshTokens? _parseRefreshTokens(Map<String, dynamic>? response) {
    if (response == null) return null;

    final payload = response['data'] is Map
        ? Map<String, dynamic>.from(response['data'] as Map)
        : response;
    final rawTokens = payload['tokens'];
    final tokenMap =
        rawTokens is Map ? Map<String, dynamic>.from(rawTokens) : payload;

    final accessToken = tokenMap['access_token']?.toString();
    final refreshToken = tokenMap['refresh_token']?.toString();
    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      return null;
    }

    return _RefreshTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> _forceLogoutIfTokenPresent({
    required String expectedAccessToken,
  }) async {
    final currentToken = await _storage.read(
      key: AppConstants.keyAuthToken,
    );
    if (currentToken == expectedAccessToken) {
      if (kDebugMode) {
        debugPrint(
          '🔐 JwtAuthInterceptor: Token expired on protected route → force logout',
        );
      }
      await _storage.delete(key: AppConstants.keyAuthToken);
      await _storage.delete(key: AppConstants.keyRefreshToken);
      await DioClient.onForceLogout?.call();
    } else if (kDebugMode) {
      debugPrint(
        '🔐 JwtAuthInterceptor: Session changed, stale 401 ignored',
      );
    }
  }
}

class _RefreshTokens {
  final String accessToken;
  final String refreshToken;

  const _RefreshTokens({
    required this.accessToken,
    required this.refreshToken,
  });
}

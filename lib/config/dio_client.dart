import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/constants/app_constants.dart';
import '../core/l10n/app_locale.dart';
import '../core/network/auth_credential_mutation_coordinator.dart';
import '../core/network/auth_session_ownership.dart';
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
typedef RefreshTokenRequest = Future<Map<String, dynamic>?> Function(
  String refreshToken,
);

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
  static AuthSessionInvocationStampBinding? _authInvocationStampBinding;

  static Dio get instance => _dio;
  static FlutterSecureStorage get storage => SharedSecureStorage.instance;

  static void initialize() {
    _authInvocationStampBinding?.close();
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
    _authInvocationStampBinding = bindAuthSessionInvocationStamp(_dio);

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
      // BaseOptions.extra holds the true synchronous invocation stamp. This
      // first interceptor materializes that copied stamp as request ownership
      // before the request reaches the queued secure-storage token lookup.
      AuthSessionOwnershipInterceptor(),
      // Must run before the async JWT interceptor so the response remains
      // bound to the account that initiated the request, even if auth changes
      // while the token is being read or while Dio retries the request.
      HibonsUpdateInterceptor(),
      LocaleHeaderInterceptor(),
      JwtAuthInterceptor(SharedSecureStorage.instance),
      OrganizationHeaderInterceptor(),
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

abstract interface class AuthTokenStorage {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

class _FlutterSecureAuthTokenStorage implements AuthTokenStorage {
  const _FlutterSecureAuthTokenStorage(this.storage);

  final FlutterSecureStorage storage;

  @override
  Future<String?> read(String key) => storage.read(key: key);

  @override
  Future<void> write(String key, String value) {
    return storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => storage.delete(key: key);
}

class JwtAuthInterceptor extends QueuedInterceptor {
  final AuthTokenStorage _tokenStorage;
  final AuthSessionOwnership _authSessions;
  final AuthCredentialMutationCoordinator _credentialMutations;
  final RefreshTokenRequest? _refreshTokenRequest;
  bool _isRefreshing = false;

  JwtAuthInterceptor(
    FlutterSecureStorage storage, {
    AuthSessionOwnership? authSessions,
    AuthCredentialMutationCoordinator? credentialMutations,
  })  : _tokenStorage = _FlutterSecureAuthTokenStorage(storage),
        _authSessions = authSessions ?? AuthSessionOwnershipRegistry.instance,
        _credentialMutations =
            credentialMutations ?? AuthCredentialMutationCoordinator.instance,
        _refreshTokenRequest = null;

  @visibleForTesting
  JwtAuthInterceptor.withTokenStorage(
    this._tokenStorage, {
    required AuthSessionOwnership authSessions,
    AuthCredentialMutationCoordinator? credentialMutations,
    RefreshTokenRequest? refreshTokenRequest,
  })  : _authSessions = authSessions,
        _credentialMutations =
            credentialMutations ?? AuthCredentialMutationCoordinator.instance,
        _refreshTokenRequest = refreshTokenRequest;

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
    '/auth/logout',
    '/auth/device-tokens/all',
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

  AuthRequestSession _requestSession(RequestOptions options) {
    return ensureAuthRequestSession(_authSessions, options);
  }

  bool _isAuthorized(AuthRequestSession session, String path) {
    return isAuthSessionAuthorizedForPath(_authSessions, session, path);
  }

  void _rejectStaleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    handler.reject(staleAuthSessionException(options));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Read the invocation-time stamp before the first await. BaseOptions.extra
    // was copied synchronously by Dio.request(), before interceptor scheduling.
    final requestSession = _requestSession(options);
    if (!_isAuthorized(requestSession, options.path)) {
      _rejectStaleRequest(options, handler);
      return;
    }

    final token = await _tokenStorage.read(AppConstants.keyAuthToken);
    if (!_isAuthorized(requestSession, options.path)) {
      _rejectStaleRequest(options, handler);
      return;
    }

    final isRefreshRequest = options.path.startsWith(_refreshPath);

    // Toujours attacher le token si disponible. Le serveur l'ignore sur les
    // routes vraiment publiques, et en a besoin sur les sous-routes
    // authentifiées ou user-aware.
    if (requestSession.isAuthenticated &&
        !isRefreshRequest &&
        token != null &&
        token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      // Never forward a caller-supplied or disk-stale bearer for an anonymous
      // auth epoch.
      options.headers.remove('Authorization');
    }

    if (kDebugMode &&
        requestSession.isAuthenticated &&
        (token == null || token.isEmpty)) {
      final isPublic = isPublicPath(options.path);
      if (!isPublic) {
        debugPrint(
          '⚠️ JwtAuthInterceptor: No token found for protected endpoint ${options.path}',
        );
      }
    }

    if (kDebugMode) {
      final hasToken = requestSession.isAuthenticated &&
          !isRefreshRequest &&
          token != null &&
          token.isNotEmpty;
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
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final requestSession = _requestSession(response.requestOptions);
    if (!_isAuthorized(requestSession, response.requestOptions.path)) {
      handler.reject(
        staleAuthSessionException(
          response.requestOptions,
          response: response,
        ),
      );
      return;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestSession = _requestSession(err.requestOptions);
    final path = err.requestOptions.path;
    if (!_isAuthorized(requestSession, path)) {
      handler.reject(
        staleAuthSessionException(
          err.requestOptions,
          response: err.response,
        ),
      );
      return;
    }

    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

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
      final currentToken = await _tokenStorage.read(
        AppConstants.keyAuthToken,
      );
      if (!_isAuthorized(requestSession, path)) {
        return handler.reject(
          staleAuthSessionException(
            err.requestOptions,
            response: err.response,
          ),
        );
      }
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
                requestSession: requestSession,
                requestPath: path,
              )
            : null;

        if (refreshedTokens != null) {
          if (!_isAuthorized(requestSession, path)) {
            return handler.reject(
              staleAuthSessionException(
                err.requestOptions,
                response: err.response,
              ),
            );
          }
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
                requestSession: requestSession,
                requestPath: path,
              );
            }
            return handler.reject(retryError);
          }
        }

        await _forceLogoutIfTokenPresent(
          expectedAccessToken: failedRequestToken,
          requestSession: requestSession,
          requestPath: path,
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

    if (!_isAuthorized(requestSession, path)) {
      return handler.reject(
        staleAuthSessionException(
          err.requestOptions,
          response: err.response,
        ),
      );
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
    required AuthRequestSession requestSession,
    required String requestPath,
  }) async {
    for (var attempt = 1; attempt <= _maxRefreshAttempts; attempt++) {
      if (!_isAuthorized(requestSession, requestPath)) return null;
      final accessToken = await _tokenStorage.read(
        AppConstants.keyAuthToken,
      );
      if (!_isAuthorized(requestSession, requestPath)) return null;
      if (accessToken != expectedAccessToken) return null;

      final refreshToken = await _tokenStorage.read(
        AppConstants.keyRefreshToken,
      );
      if (!_isAuthorized(requestSession, requestPath)) return null;
      if (refreshToken == null || refreshToken.isEmpty) return null;

      try {
        final response = await _requestRefreshTokens(refreshToken);

        if (!_isAuthorized(requestSession, requestPath)) return null;

        final tokens = _parseRefreshTokens(response);
        if (tokens != null) {
          final persisted = await _persistRefreshedTokens(
            tokens: tokens,
            expectedAccessToken: expectedAccessToken,
            expectedRefreshToken: refreshToken,
            requestSession: requestSession,
            requestPath: requestPath,
          );
          if (!persisted) {
            if (kDebugMode) {
              debugPrint(
                '🔐 JwtAuthInterceptor: discarded refresh from a stale session',
              );
            }
            return null;
          }
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

        final currentAccessToken = await _tokenStorage.read(
          AppConstants.keyAuthToken,
        );
        final currentRefreshToken = await _tokenStorage.read(
          AppConstants.keyRefreshToken,
        );
        final sessionChanged = !_isAuthorized(requestSession, requestPath) ||
            currentAccessToken != expectedAccessToken ||
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
        if (!_isAuthorized(requestSession, requestPath)) return null;
        await Future<void>.delayed(_refreshRetryBackoff * attempt);
        if (!_isAuthorized(requestSession, requestPath)) return null;
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            '🔐 JwtAuthInterceptor: refresh erreur inattendue '
            '(tentative $attempt): $e',
          );
        }
        if (attempt >= _maxRefreshAttempts) rethrow;
        if (!_isAuthorized(requestSession, requestPath)) return null;
        await Future<void>.delayed(_refreshRetryBackoff * attempt);
        if (!_isAuthorized(requestSession, requestPath)) return null;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _requestRefreshTokens(
    String refreshToken,
  ) async {
    final injected = _refreshTokenRequest;
    if (injected != null) return injected(refreshToken);
    final response = await _buildRefreshDio().post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refresh_token': refreshToken},
    );
    return response.data;
  }

  /// Atomically replaces the credential pair relative to every login, logout,
  /// repository refresh, and interceptor refresh writer.
  ///
  /// The epoch and expected pair are revalidated *inside* the shared lease,
  /// immediately before the first write. Once writing begins, both keys are
  /// completed before releasing the lease. If auth rotates during either
  /// secure-storage write, the queued login/clear mutation runs next and owns
  /// the final pair; it can never be overwritten by this stale refresh.
  Future<bool> _persistRefreshedTokens({
    required _RefreshTokens tokens,
    required String expectedAccessToken,
    required String expectedRefreshToken,
    required AuthRequestSession requestSession,
    required String requestPath,
  }) {
    return _credentialMutations.run(() async {
      if (!_isAuthorized(requestSession, requestPath)) return false;

      final currentAccessToken = await _tokenStorage.read(
        AppConstants.keyAuthToken,
      );
      if (!_isAuthorized(requestSession, requestPath)) return false;
      final currentRefreshToken = await _tokenStorage.read(
        AppConstants.keyRefreshToken,
      );
      if (!_isAuthorized(requestSession, requestPath) ||
          currentAccessToken != expectedAccessToken ||
          currentRefreshToken != expectedRefreshToken) {
        return false;
      }

      // Do not release a half-written pair. A session transition can happen
      // while secure storage is awaiting either write, but its credential
      // mutation is queued behind this lease and will deterministically win.
      await _tokenStorage.write(
        AppConstants.keyAuthToken,
        tokens.accessToken,
      );
      await _tokenStorage.write(
        AppConstants.keyRefreshToken,
        tokens.refreshToken,
      );
      return _isAuthorized(requestSession, requestPath);
    });
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
    required AuthRequestSession requestSession,
    required String requestPath,
  }) async {
    if (!_isAuthorized(requestSession, requestPath)) return;
    final currentToken = await _tokenStorage.read(
      AppConstants.keyAuthToken,
    );
    if (!_isAuthorized(requestSession, requestPath)) return;
    if (currentToken == expectedAccessToken) {
      if (kDebugMode) {
        debugPrint(
          '🔐 JwtAuthInterceptor: Token expired on protected route → force logout',
        );
      }
      final forceLogout = DioClient.onForceLogout;
      if (forceLogout != null) {
        // The production callback rotates AuthState synchronously before its
        // asynchronous repository cleanup. If that happened, let the auth
        // repository own storage deletion and never touch a newer session.
        await forceLogout();
        if (!_isAuthorized(requestSession, requestPath)) return;
      }

      // Fallback for isolated clients/tests whose callback does not own local
      // auth cleanup. Delete both keys under the same writer lease, with the
      // exact epoch and expected token revalidated inside it.
      await _credentialMutations.run(() async {
        if (!_isAuthorized(requestSession, requestPath)) return;
        final token = await _tokenStorage.read(AppConstants.keyAuthToken);
        if (!_isAuthorized(requestSession, requestPath) ||
            token != expectedAccessToken) {
          return;
        }
        await _tokenStorage.delete(AppConstants.keyAuthToken);
        await _tokenStorage.delete(AppConstants.keyRefreshToken);
      });
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

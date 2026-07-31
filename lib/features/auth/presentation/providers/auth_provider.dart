import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/auth_session_ownership.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../../domain/entities/user.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../data/models/auth_response_dto.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../favorites/data/datasources/favorites_local_datasource.dart';
import '../../../notifications/data/datasources/device_token_datasource.dart';
import '../../../petit_boo/presentation/providers/petit_boo_chat_provider.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  pendingVerification,
  pendingLoginOtp,
  error
}

const Object _notProvided = Object();

/// User-facing signal set only when the API invalidates the current session.
///
/// Normal, user-initiated logout deliberately leaves [AuthState.errorMessage]
/// empty.
String get authSessionExpiredMessage =>
    cachedAppLocalizations().commonSessionExpiredError;

class AuthState {
  final AuthStatus status;
  final HbUser? user;
  final String? errorMessage;
  // For OTP verification flow
  final String? pendingUserId;
  final String? pendingEmail;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.pendingUserId,
    this.pendingEmail,
  });

  AuthState copyWith({
    AuthStatus? status,
    Object? user = _notProvided,
    Object? errorMessage = _notProvided,
    Object? pendingUserId = _notProvided,
    Object? pendingEmail = _notProvided,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user == _notProvided ? this.user : user as HbUser?,
      errorMessage: errorMessage == _notProvided
          ? this.errorMessage
          : errorMessage as String?,
      pendingUserId: pendingUserId == _notProvided
          ? this.pendingUserId
          : pendingUserId as String?,
      pendingEmail: pendingEmail == _notProvided
          ? this.pendingEmail
          : pendingEmail as String?,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isPendingVerification => status == AuthStatus.pendingVerification;
}

bool didTransitionToUnauthenticated(
  AuthStatus? previous,
  AuthStatus next,
) {
  return next == AuthStatus.unauthenticated &&
      previous != AuthStatus.unauthenticated &&
      previous != AuthStatus.initial;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;
  int _operationGeneration = 0;
  Future<void> _repositoryMutationTail = Future<void>.value();
  bool _repositoryMutationActive = false;

  AuthNotifier(this._authRepository, this._ref) : super(const AuthState()) {
    unawaited(_checkAuthStatus(_beginOperation()));
  }

  int _beginOperation() => ++_operationGeneration;

  bool _ownsOperation(int generation) {
    return mounted && generation == _operationGeneration;
  }

  /// Runs session repository calls in invocation order.
  ///
  /// Login and OTP repository methods persist their tokens before returning.
  /// Serializing them with logout prevents an older response from writing its
  /// credentials after a newer account action has already completed.
  Future<T> _serializeRepositoryMutation<T>(
    Future<T> Function() operation,
  ) {
    final result = _repositoryMutationTail.then((_) async {
      _repositoryMutationActive = true;
      try {
        return await operation();
      } finally {
        _repositoryMutationActive = false;
      }
    });
    _repositoryMutationTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return result;
  }

  Future<void> _checkAuthStatus(int generation) async {
    final isAuth = await _serializeRepositoryMutation(
      _authRepository.isAuthenticated,
    );
    if (!_ownsOperation(generation)) return;

    if (isAuth) {
      final user = await _serializeRepositoryMutation(
        _authRepository.getCurrentUser,
      );
      if (!_ownsOperation(generation)) return;

      state = state.copyWith(
        status: user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        user: user,
      );
      _syncAuthUser(user);
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      );
      _syncAuthUser(null);
    }
  }

  /// Login - may require OTP verification (2FA) or direct auth (Laravel v2)
  Future<LoginOtpResult?> login(
      {required String email, required String password}) async {
    final generation = _beginOperation();
    state = state.copyWith(
      status: AuthStatus.loading,
      user: null,
      errorMessage: null,
      pendingUserId: null,
      pendingEmail: null,
    );

    try {
      final result = await _serializeRepositoryMutation(
        () => _authRepository.login(email: email, password: password),
      );
      if (!_ownsOperation(generation)) return null;

      if (result.requiresOtp) {
        // OTP required - store pending info
        state = state.copyWith(
          status: AuthStatus.pendingLoginOtp,
          user: null,
          pendingUserId: result.userId,
          pendingEmail: result.email,
        );
        // otp_sent — code 2FA envoyé suite à un login valide.
        _analytics.logEvent(
          AnalyticsEvent.otpSent,
          params: {AnalyticsParam.type: AnalyticsOtpType.login},
        );
        return result;
      }

      // No OTP required - check if we have auth result (Laravel v2 direct auth)
      if (result.authResult != null) {
        final user = result.authResult!.user;
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          pendingUserId: null,
          pendingEmail: null,
        );
        _syncAuthUser(user);
        _analytics.logEvent(
          AnalyticsEvent.login,
          params: {AnalyticsParam.method: AnalyticsMethod.email},
        );
        return result;
      }

      // Fallback: No OTP required but no auth result (shouldn't happen)
      debugPrint('⚠️ Login succeeded without OTP but no auth result');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        pendingUserId: null,
        pendingEmail: null,
      );
      return result;
    } catch (e) {
      if (!_ownsOperation(generation)) return null;

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: _parseError(e),
        pendingUserId: null,
        pendingEmail: null,
      );
      _analytics.logEvent(
        AnalyticsEvent.loginFailed,
        params: {AnalyticsParam.reason: _categorizeError(e)},
      );
      return null;
    }
  }

  /// Register a new user - returns RegistrationResult with pending verification
  Future<RegistrationResult?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDate,
  }) async {
    final generation = _beginOperation();
    state = state.copyWith(
      status: AuthStatus.loading,
      user: null,
      errorMessage: null,
    );

    // signup_started — entrée dans le funnel d'inscription (form soumis).
    // Loggué avant l'appel API pour capter aussi les tentatives qui échouent.
    _analytics.logEvent(
      AnalyticsEvent.signupStarted,
      params: {AnalyticsParam.method: AnalyticsMethod.email},
    );

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
      );
      if (!_ownsOperation(generation)) return null;

      // Store pending verification info in state
      state = state.copyWith(
        status: AuthStatus.pendingVerification,
        user: null,
        pendingUserId: result.userId,
        pendingEmail: result.email,
      );

      // otp_sent — le backend a déclenché l'envoi du code de vérification.
      _analytics.logEvent(
        AnalyticsEvent.otpSent,
        params: {AnalyticsParam.type: AnalyticsOtpType.register},
      );

      return result;
    } catch (e) {
      if (!_ownsOperation(generation)) return null;

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: _parseError(e),
      );
      _analytics.logEvent(
        AnalyticsEvent.signupFailed,
        params: {AnalyticsParam.reason: _categorizeError(e)},
      );
      return null;
    }
  }

  /// Verify OTP and complete registration
  Future<bool> verifyOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    final generation = _beginOperation();
    state = state.copyWith(
      status: AuthStatus.loading,
      user: null,
      errorMessage: null,
    );

    try {
      final result = await _serializeRepositoryMutation(
        () => _authRepository.verifyOtp(
          userId: userId,
          email: email,
          otp: otp,
        ),
      );
      if (!_ownsOperation(generation)) return false;

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        pendingUserId: null,
        pendingEmail: null,
      );
      _syncAuthUser(result.user);
      _analytics.logEvent(
        AnalyticsEvent.otpVerified,
        params: {AnalyticsParam.type: AnalyticsOtpType.register},
      );
      _analytics.logEvent(
        AnalyticsEvent.signUp,
        params: {AnalyticsParam.method: AnalyticsMethod.email},
      );
      return true;
    } catch (e) {
      if (!_ownsOperation(generation)) return false;

      final rawError = e.toString();
      final errorMessage = ApiResponseHandler.extractError(e);
      debugPrint('🚨 Verify OTP Error: $errorMessage');

      // Handle case where user is already verified (e.g. double submission or retry)
      if (rawError.contains('user_already_verified')) {
        debugPrint('🚨 Treating already verified as success');
        state = state.copyWith(
          status: AuthStatus
              .unauthenticated, // Will redirect to login (since we don't have token)
          user: null,
          pendingUserId: null,
          pendingEmail: null,
          errorMessage: cachedAppLocalizations().authAccountAlreadyVerified,
        );
        return true; // Treat as handled/success to allow navigation
      }

      state = state.copyWith(
        status: AuthStatus.pendingVerification,
        user: null,
        errorMessage: _parseOtpError(e),
      );
      return false;
    }
  }

  /// Resend OTP code (for registration or login)
  Future<bool> resendOtp({
    required String userId,
    required String email,
    String type = 'register',
  }) async {
    final generation = _operationGeneration;
    try {
      await _authRepository.resendOtp(
        userId: userId,
        email: email,
        type: type,
      );
      if (!_ownsOperation(generation)) return false;

      // otp_sent — renvoi manuel du code (`type` = register | login).
      _analytics.logEvent(
        AnalyticsEvent.otpSent,
        params: {AnalyticsParam.type: type},
      );
      return true;
    } catch (e) {
      if (!_ownsOperation(generation)) return false;

      state = state.copyWith(
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  /// Verify login OTP (2FA)
  Future<bool> verifyLoginOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    final generation = _beginOperation();
    state = state.copyWith(
      status: AuthStatus.loading,
      user: null,
      errorMessage: null,
    );

    try {
      final result = await _serializeRepositoryMutation(
        () => _authRepository.verifyLoginOtp(
          userId: userId,
          email: email,
          otp: otp,
        ),
      );
      if (!_ownsOperation(generation)) return false;

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        pendingUserId: null,
        pendingEmail: null,
      );
      _syncAuthUser(result.user);
      _analytics.logEvent(
        AnalyticsEvent.otpVerified,
        params: {AnalyticsParam.type: AnalyticsOtpType.login},
      );
      _analytics.logEvent(
        AnalyticsEvent.login,
        params: {AnalyticsParam.method: AnalyticsMethod.email},
      );
      return true;
    } catch (e) {
      if (!_ownsOperation(generation)) return false;

      state = state.copyWith(
        status: AuthStatus.pendingLoginOtp,
        user: null,
        errorMessage: _parseOtpError(e),
      );
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    final generation = _beginOperation();
    state = state.copyWith(
      status: AuthStatus.loading,
      user: null,
      errorMessage: null,
    );

    try {
      await _authRepository.forgotPassword(email);
      if (!_ownsOperation(generation)) return false;

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      );
      _analytics.logEvent(AnalyticsEvent.passwordResetRequested);
      return true;
    } catch (e) {
      if (!_ownsOperation(generation)) return false;

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  Future<void> logout() async {
    final retirement = AuthSessionOwnershipRegistry.instance.beginRetirement();
    final generation = _beginOperation();
    state = state.copyWith(
      status: AuthStatus.loading,
      user: null,
      errorMessage: null,
    );
    _syncAuthUser(null);
    try {
      await _serializeRepositoryMutation(() async {
        // Deregister this device's push tokens BEFORE revoking the bearer
        // (spec PUSH_NOTIFICATIONS_MOBILE_SPEC.md §7.4). Failure here must not
        // block logout — branch #2 of §2.1 will eventually deactivate the row
        // when another user signs in on the same device.
        try {
          await _ref.read(deviceTokenDataSourceProvider).unregisterAllTokens();
        } catch (_) {}
        await _authRepository.logout();
        await _clearPersistedUserData();
      });
    } finally {
      retirement?.close();
    }
    if (!_ownsOperation(generation)) return;

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Force logout without calling the API (used by 401 interceptor).
  /// Skips the API call to avoid triggering another 401 loop.
  Future<void> forceLogout() async {
    _beginOperation();
    state = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: authSessionExpiredMessage,
    );
    _syncAuthUser(null);

    // This can be called by the Dio interceptor while a serialized logout is
    // itself awaiting that interceptor. Queue cleanup behind the active
    // mutation, but don't await it in that re-entrant case (which would
    // deadlock). State is already synchronously signed out, and the queued
    // cleanup still runs before any later login mutation.
    final wasMutationActive = _repositoryMutationActive;
    final cleanup = _serializeRepositoryMutation(() async {
      await _authRepository.clearLocalAuthData();
      await _clearPersistedUserData();
    });
    if (wasMutationActive) {
      unawaited(cleanup.catchError((Object _) {}));
      return;
    }
    await cleanup;
  }

  /// Flush unscoped disk-backed caches that hold the current user's identity.
  ///
  /// In-memory provider state is handled by per-notifier `ref.listen` hooks
  /// on `authProvider` (see `BookingListController`, `FavoritesProvider`,
  /// `PetitBooChatNotifier`, …). The cart is deliberately not cleared here:
  /// its persisted values carry an exact owner and use separate account keys,
  /// so they are hidden synchronously on logout/account change and can safely
  /// be restored only when that same account returns.
  Future<void> _clearPersistedUserData() async {
    // Favorites cache (SharedPreferences `favorite_ids` + `favorites_last_sync`).
    try {
      await _ref.read(favoritesLocalDatasourceProvider).clear();
    } catch (_) {}
    // Petit Boo persisted context, chat history, memory toggle.
    try {
      await _ref.read(petitBooContextStorageProvider).clearAll();
    } catch (_) {}
    // Petit Boo session UUID (SecureStorage). Survives app restarts — must be
    // wiped or the next user resumes the previous user's AI session.
    try {
      await SharedSecureStorage.instance
          .delete(key: AppConstants.keyPetitBooSessionUuid);
    } catch (_) {}
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Set authenticated user directly (used after business registration)
  void setAuthenticatedUser(HbUser user) {
    _beginOperation();
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      pendingUserId: null,
      pendingEmail: null,
      errorMessage: null,
    );
    _syncAuthUser(user);
    _analytics.logEvent(
      AnalyticsEvent.signUp,
      params: {AnalyticsParam.method: AnalyticsMethod.email},
    );
    unawaited(
      _serializeRepositoryMutation(() => _authRepository.persistUser(user)),
    );
  }

  /// Refresh auth status from repository (used after external auth changes)
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus(_beginOperation());
  }

  /// Update user data in state and persist editable fields to secure storage
  /// (used after profile edits, avatar upload, settings toggles).
  void updateUser(dynamic updatedUser) {
    final currentUser = state.user;
    if (!state.isAuthenticated || currentUser == null) return;

    HbUser? next;
    if (updatedUser is UserDto) {
      final mapped = AuthMapper.toUser(updatedUser);
      // AuthMapper may default role to subscriber if the profile endpoint
      // doesn't return it — preserve the current role in that case.
      next = mapped.copyWith(
        role:
            mapped.role != UserRole.subscriber ? mapped.role : currentUser.role,
      );
    } else if (updatedUser is HbUser) {
      next = updatedUser;
    }

    if (next == null) return;
    if (next.id.trim() != currentUser.id.trim()) return;

    state = state.copyWith(user: next);
    _syncAuthUser(next);

    // Fire-and-forget: keep the in-memory update synchronous so the UI rebuilds
    // immediately. Disk I/O failures are non-fatal — the next login or
    // /auth/me refresh will reconcile the state.
    unawaited(
      _serializeRepositoryMutation(() => _authRepository.persistUser(next!)),
    );
  }

  String _parseError(dynamic e) {
    final l10n = cachedAppLocalizations();
    final code = _authErrorCode(e);
    final mapped = switch (code) {
      'invalid_credentials' => l10n.authEmailOrPasswordIncorrect,
      'user_exists' => l10n.authAccountAlreadyExists,
      'weak_password' => l10n.authWeakPasswordDetailed,
      'invalid_email' => l10n.authEmailAddressInvalid,
      _ => null,
    };
    if (mapped != null) return mapped;

    return ApiResponseHandler.extractError(
      e,
      fallback: l10n.commonGenericRetryError,
    );
  }

  String _parseOtpError(dynamic e) {
    final l10n = cachedAppLocalizations();
    return switch (_authErrorCode(e)) {
      'otp_expired' => l10n.authVerificationCodeExpired,
      'too_many_attempts' || 'rate_limited' => l10n.authTooManyAttempts,
      'invalid_otp' => l10n.authVerificationCodeInvalid,
      _ => ApiResponseHandler.extractError(
          e,
          fallback: l10n.authVerificationCodeInvalid,
        ),
    };
  }

  String? _authErrorCode(dynamic error) {
    final structured = ApiResponseHandler.extractErrorCode(error);
    if (structured != null) return structured;

    final normalized = error.toString().toLowerCase();
    const knownCodes = <String>[
      'invalid_credentials',
      'user_exists',
      'weak_password',
      'invalid_email',
      'invalid_otp',
      'otp_expired',
      'too_many_attempts',
      'rate_limited',
      'user_already_verified',
    ];
    for (final code in knownCodes) {
      if (normalized.contains(code)) return code;
    }
    return null;
  }

  // ─── Analytics helpers ─────────────────────────────────────────────
  // Lecture paresseuse du service via _ref pour rester compatible avec
  // l'instanciation actuelle (le constructeur ne reçoit pas le service
  // explicitement). La collecte étant désactivée tant que l'étape 7 n'a
  // pas livré le consent gate, ces appels sont des no-ops côté Firebase.

  AnalyticsService get _analytics => _ref.read(analyticsServiceProvider);

  /// Met à jour l'identité analytics à chaque transition de [state.user].
  /// Appelée avec [user] = null à la déconnexion pour purger explicitement
  /// les properties et le user_id — sinon GA4 colle l'ancien profil au
  /// prochain compte qui se connectera sur le device.
  void _syncAuthUser(HbUser? user) {
    if (user != null) {
      _analytics.setUserId(user.id);
      _analytics.setUserProperty(
        AnalyticsUserProperty.userRole,
        _userRoleValue(user.role),
      );
      _analytics.setUserProperty(
        AnalyticsUserProperty.homeCitySlug,
        user.city ?? 'none',
      );
    } else {
      _analytics.setUserId(null);
      _analytics.setUserProperty(AnalyticsUserProperty.userRole, null);
      _analytics.setUserProperty(AnalyticsUserProperty.homeCitySlug, null);
    }
  }

  String _userRoleValue(UserRole role) {
    return switch (role) {
      UserRole.subscriber => AnalyticsUserRole.subscriber,
      UserRole.partner => AnalyticsUserRole.partner,
      UserRole.admin => AnalyticsUserRole.admin,
    };
  }

  /// Normalise une exception en `reason` court et stable pour GA4.
  /// Pendant la dimension n'est pas une chaîne libre — limiter la
  /// cardinalité évite le sampling.
  String _categorizeError(Object e) {
    final message = e.toString().toLowerCase();
    if (message.contains('invalid_credentials')) return 'invalid_credentials';
    if (message.contains('invalid_otp')) return 'otp_invalid';
    if (message.contains('otp_expired')) return 'otp_expired';
    if (message.contains('too_many_attempts')) return 'too_many_attempts';
    if (message.contains('user_exists')) return 'user_exists';
    if (message.contains('weak_password')) return 'weak_password';
    if (message.contains('invalid_email')) return 'invalid_email';
    if (message.contains('socketexception') || message.contains('network')) {
      return 'network';
    }
    if (e is DioException) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout =>
          'network_timeout',
        DioExceptionType.connectionError => 'network',
        DioExceptionType.badResponse => 'bad_response',
        _ => 'dio_unknown',
      };
    }
    return 'unknown';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository, ref);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Stable identity key for account-scoped providers.
///
/// Watching this provider makes a user-scoped notifier get disposed and
/// recreated whenever authentication ends or a different account becomes
/// active. Async work owned by the old notifier must still check `mounted`
/// before publishing, but it can no longer write into the new account's
/// provider instance.
final authSessionUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return null;
  final userId = auth.user?.id.trim();
  return userId == null || userId.isEmpty ? null : userId;
});

final currentUserProvider = Provider<HbUser?>((ref) {
  return ref.watch(authProvider).user;
});

/// True while a [GuestRestrictionDialog] is on screen and listening for
/// auth changes. Authentication screens (register, OTP) check this flag
/// to suppress their own post-auth `context.go('/')` so the dialog can
/// pop itself and let the original gated action resume on the screen
/// underneath.
final guestGuardActiveProvider = StateProvider<bool>((ref) => false);

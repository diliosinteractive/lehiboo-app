import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../domain/entities/user.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../data/models/auth_response_dto.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../booking/presentation/providers/order_cart_provider.dart';
import '../../../favorites/data/datasources/favorites_local_datasource.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import '../../../memberships/presentation/providers/private_events_provider.dart';
import '../../../messages/presentation/providers/admin_conversations_provider.dart';
import '../../../messages/presentation/providers/conversations_provider.dart';
import '../../../messages/presentation/providers/support_conversations_provider.dart';
import '../../../messages/presentation/providers/unread_count_provider.dart';
import '../../../messages/presentation/providers/vendor_conversations_provider.dart';
import '../../../messages/presentation/providers/vendor_org_conversations_provider.dart';
import '../../../notifications/data/datasources/device_token_datasource.dart';
import '../../../partners/presentation/providers/followed_organizers_providers.dart';
import '../../../petit_boo/presentation/providers/conversation_list_provider.dart';
import '../../../petit_boo/presentation/providers/petit_boo_chat_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../profile/presentation/providers/saved_participants_provider.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  pendingVerification,
  pendingLoginOtp,
  error
}

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
    HbUser? user,
    String? errorMessage,
    String? pendingUserId,
    String? pendingEmail,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      pendingUserId: pendingUserId ?? this.pendingUserId,
      pendingEmail: pendingEmail ?? this.pendingEmail,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isPendingVerification => status == AuthStatus.pendingVerification;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuth = await _authRepository.isAuthenticated();
    if (isAuth) {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(
        status: user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        user: user,
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Login - may require OTP verification (2FA) or direct auth (Laravel v2)
  Future<LoginOtpResult?> login(
      {required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result =
          await _authRepository.login(email: email, password: password);

      if (result.requiresOtp) {
        // OTP required - store pending info
        state = state.copyWith(
          status: AuthStatus.pendingLoginOtp,
          pendingUserId: result.userId,
          pendingEmail: result.email,
        );
        return result;
      }

      // No OTP required - check if we have auth result (Laravel v2 direct auth)
      if (result.authResult != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: result.authResult!.user,
        );
        // Personalized feed depends on identity — refetch on login (spec §7).
        _ref.invalidate(personalizedFeedProvider);
        return result;
      }

      // Fallback: No OTP required but no auth result (shouldn't happen)
      debugPrint('⚠️ Login succeeded without OTP but no auth result');
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return result;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _parseError(e),
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
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      // Store pending verification info in state
      state = state.copyWith(
        status: AuthStatus.pendingVerification,
        pendingUserId: result.userId,
        pendingEmail: result.email,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _parseError(e),
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
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authRepository.verifyOtp(
        userId: userId,
        email: email,
        otp: otp,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        pendingUserId: null,
        pendingEmail: null,
      );
      // Personalized feed depends on identity — refetch on registration OTP
      // success (spec §7).
      _ref.invalidate(personalizedFeedProvider);
      return true;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint('🚨 Verify OTP Error: $errorMessage');

      // Handle case where user is already verified (e.g. double submission or retry)
      if (errorMessage.contains('user_already_verified')) {
        debugPrint('🚨 Treating already verified as success');
        state = state.copyWith(
          status: AuthStatus
              .unauthenticated, // Will redirect to login (since we don't have token)
          pendingUserId: null,
          pendingEmail: null,
          errorMessage: cachedAppLocalizations().authAccountAlreadyVerified,
        );
        return true; // Treat as handled/success to allow navigation
      }

      state = state.copyWith(
        status: AuthStatus.pendingVerification,
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
    try {
      await _authRepository.resendOtp(
        userId: userId,
        email: email,
        type: type,
      );
      return true;
    } catch (e) {
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
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authRepository.verifyLoginOtp(
        userId: userId,
        email: email,
        otp: otp,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        pendingUserId: null,
        pendingEmail: null,
      );
      // Personalized feed depends on identity — refetch on login OTP
      // success (spec §7).
      _ref.invalidate(personalizedFeedProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.pendingLoginOtp,
        errorMessage: _parseOtpError(e),
      );
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      await _authRepository.forgotPassword(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    // Deregister this device's push tokens BEFORE revoking the bearer
    // (spec PUSH_NOTIFICATIONS_MOBILE_SPEC.md §7.4). Failure here must not
    // block logout — branch #2 of §2.1 will eventually deactivate the row
    // when another user signs in on the same device.
    try {
      await _ref.read(deviceTokenDataSourceProvider).unregisterAllTokens();
    } catch (_) {}
    await _authRepository.logout();
    await _clearPersistedUserData();
    state = const AuthState(status: AuthStatus.unauthenticated);
    _invalidateUserScopedProviders();
  }

  /// Force logout without calling the API (used by 401 interceptor).
  /// Skips the API call to avoid triggering another 401 loop.
  Future<void> forceLogout() async {
    await _authRepository.clearLocalAuthData();
    await _clearPersistedUserData();
    state = const AuthState(status: AuthStatus.unauthenticated);
    _invalidateUserScopedProviders();
  }

  /// Flush every disk-backed cache that holds the current user's identity.
  ///
  /// In-memory provider state is handled by per-notifier `ref.listen` hooks
  /// on `authProvider` (see `BookingListController`, `FavoritesProvider`,
  /// `PetitBooChatNotifier`, …). Disk caches can't self-listen, so they get
  /// flushed here and we `await` them before flipping to `unauthenticated`
  /// to guarantee the next user can't observe the previous tenant's bytes.
  Future<void> _clearPersistedUserData() async {
    // Cart (SharedPreferences `order_cart_items_v1` + hold expiry).
    // OrderCartNotifier.clear() is fire-and-forget on _prefs.remove(), so we
    // don't await it — calling it synchronously is enough to wipe in-memory
    // state and queue the disk removal.
    try {
      _ref.read(orderCartProvider.notifier).clear();
    } catch (_) {}
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

  /// Invalidate read-only / FutureProvider state that no notifier owns.
  ///
  /// Providers in this list either don't expose a notifier we can hook
  /// `ref.listen(authProvider)` onto (FutureProvider, AsyncNotifier without
  /// an auth-aware build, StateProvider), or do expose one but pre-date the
  /// auth-listener convention used elsewhere in the codebase. Anything that
  /// already self-listens (hibons, inAppNotifications, activeOrganization,
  /// conversationDetail, messagesRealtime, pushNotification, bookings,
  /// favorites, favorite_lists, alerts, reminders, userReviews, tripPlans,
  /// petitBooChat) MUST NOT appear here — double-reset would mask bugs in
  /// those listeners.
  void _invalidateUserScopedProviders() {
    // Personalized feed (per-user strata).
    _ref.invalidate(personalizedFeedProvider);
    // Profile / stats / saved participants (FutureProvider.autoDispose, but a
    // mounted screen at logout time would keep the previous user's data
    // visible until next navigation — invalidate to force a rebuild).
    _ref.invalidate(userStatsProvider);
    _ref.invalidate(savedParticipantsProvider);
    // Partners — followed organizers list.
    _ref.invalidate(followedOrganizersControllerProvider);
    // Memberships derived screens (myMembershipsListProvider self-clears via
    // its build()'s ref.watch on authProvider).
    _ref.invalidate(privateEventsControllerProvider);
    _ref.invalidate(privateEventsSearchProvider);
    _ref.invalidate(privateEventsOrgFilterProvider);
    // Messages — none of these self-listen to auth.
    _ref.invalidate(conversationsProvider);
    _ref.invalidate(adminConversationsProvider);
    _ref.invalidate(vendorConversationsProvider);
    _ref.invalidate(supportConversationsProvider);
    _ref.invalidate(vendorOrgConversationsProvider);
    _ref.invalidate(unreadCountProvider);
    // Petit Boo conversation history list (autoDispose; covers the case
    // where the user is on the history screen at logout time).
    _ref.invalidate(conversationListProvider);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Set authenticated user directly (used after business registration)
  void setAuthenticatedUser(HbUser user) {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      pendingUserId: null,
      pendingEmail: null,
      errorMessage: null,
    );
    // Personalized feed depends on identity — refetch when an external auth
    // path lands the user as authenticated (spec §7).
    _ref.invalidate(personalizedFeedProvider);
  }

  /// Refresh auth status from repository (used after external auth changes)
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }

  /// Update user data in state and persist editable fields to secure storage
  /// (used after profile edits, avatar upload, settings toggles).
  void updateUser(dynamic updatedUser) {
    if (state.user == null) return;

    HbUser? next;
    if (updatedUser is UserDto) {
      final mapped = AuthMapper.toUser(updatedUser);
      final currentUser = state.user!;
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

    state = state.copyWith(user: next);

    // Fire-and-forget: keep the in-memory update synchronous so the UI rebuilds
    // immediately. Disk I/O failures are non-fatal — the next login or
    // /auth/me refresh will reconcile the state.
    unawaited(_authRepository.persistUser(next));
  }

  String _parseError(dynamic e) {
    final l10n = cachedAppLocalizations();

    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse) {
        final data = e.response?.data;
        if (data != null && data is Map<String, dynamic>) {
          // Check for detailed validation error
          if (data['error'] != null && data['error']['details'] != null) {
            final details = data['error']['details'];
            if (details is Map<String, dynamic>) {
              // Return the first validation error message found
              final firstError = details.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                return firstError.first.toString();
              }
              return firstError.toString();
            }
          }
          // Fallback to general message if available
          if (data['message'] != null) {
            return data['message'].toString();
          }
          if (data['data'] != null && data['data']['message'] != null) {
            return data['data']['message'].toString();
          }
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return l10n.commonConnectionError;
      }
    }

    final message = e.toString();
    if (message.contains('invalid_credentials')) {
      return l10n.authEmailOrPasswordIncorrect;
    } else if (message.contains('user_exists')) {
      return l10n.authAccountAlreadyExists;
    } else if (message.contains('weak_password')) {
      return l10n.authWeakPasswordDetailed;
    } else if (message.contains('invalid_email')) {
      return l10n.authEmailAddressInvalid;
    } else if (message.contains('network') ||
        message.contains('SocketException')) {
      return l10n.commonConnectionError;
    }

    // Provide a slightly more helpful fallback if it's an Exception with a message
    if (e is Exception) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.isNotEmpty && !msg.startsWith('http')) return msg;
    }

    return l10n.commonGenericRetryError;
  }

  String _parseOtpError(dynamic e) {
    final l10n = cachedAppLocalizations();
    final message = e.toString();
    if (message.contains('invalid_otp')) {
      return l10n.authVerificationCodeInvalid;
    } else if (message.contains('otp_expired')) {
      return l10n.authVerificationCodeExpired;
    } else if (message.contains('too_many_attempts')) {
      return l10n.authTooManyAttempts;
    }
    return l10n.authVerificationCodeInvalid;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryImplProvider);
  return AuthNotifier(authRepository, ref);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
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

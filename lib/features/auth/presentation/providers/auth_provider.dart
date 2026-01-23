import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, pendingVerification, pendingLoginOtp, error }

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

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuth = await _authRepository.isAuthenticated();
    if (isAuth) {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(
        status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        user: user,
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Login - may require OTP verification (2FA) or direct auth (Laravel v2)
  Future<LoginOtpResult?> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authRepository.login(email: email, password: password);

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
        return result;
      }

      // Fallback: No OTP required but no auth result (shouldn't happen)
      debugPrint('⚠️ Login succeeded without OTP but no auth result');
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return result;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
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
        status: AuthStatus.error,
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
      return true;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint('🚨 Verify OTP Error: $errorMessage');
      
      // Handle case where user is already verified (e.g. double submission or retry)
      if (errorMessage.contains('user_already_verified')) {
         debugPrint('🚨 Treating already verified as success');
         state = state.copyWith(
            status: AuthStatus.unauthenticated, // Will redirect to login (since we don't have token)
            pendingUserId: null,
            pendingEmail: null,
            errorMessage: 'Votre compte est déjà vérifié. Veuillez vous connecter.',
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
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _authRepository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Update user data in state (used after profile update)
  void updateUser(dynamic updatedUser) {
    if (state.user == null) return;

    // Handle UserDto from profile API
    if (updatedUser is! HbUser) {
      // Convert UserDto to HbUser
      final currentUser = state.user!;
      final updated = currentUser.copyWith(
        displayName: updatedUser.displayName ?? currentUser.displayName,
        firstName: updatedUser.firstName ?? currentUser.firstName,
        lastName: updatedUser.lastName ?? currentUser.lastName,
        phone: updatedUser.phone ?? currentUser.phone,
        avatarUrl: updatedUser.avatarUrl ?? currentUser.avatarUrl,
        isVerified: updatedUser.isVerified ?? currentUser.isVerified,
      );
      state = state.copyWith(user: updated);
    } else {
      state = state.copyWith(user: updatedUser);
    }
  }

  String _parseError(dynamic e) {
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
        return 'Erreur de connexion. Vérifiez votre connexion internet.';
      }
    }

    final message = e.toString();
    if (message.contains('invalid_credentials')) {
      return 'Email ou mot de passe incorrect';
    } else if (message.contains('user_exists')) {
      return 'Un compte existe déjà avec cet email';
    } else if (message.contains('weak_password')) {
      return 'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre';
    } else if (message.contains('invalid_email')) {
      return 'Adresse email invalide';
    } else if (message.contains('network') || message.contains('SocketException')) {
      return 'Erreur de connexion. Vérifiez votre connexion internet.';
    }
    
    // Provide a slightly more helpful fallback if it's an Exception with a message
    if (e is Exception) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.isNotEmpty && !msg.startsWith('http')) return msg;
    }
    
    return 'Une erreur est survenue. Veuillez réessayer.';
  }

  String _parseOtpError(dynamic e) {
    final message = e.toString();
    if (message.contains('invalid_otp')) {
      return 'Code de vérification invalide';
    } else if (message.contains('otp_expired')) {
      return 'Le code a expiré. Veuillez en demander un nouveau.';
    } else if (message.contains('too_many_attempts')) {
      return 'Trop de tentatives. Réessayez dans 15 minutes.';
    }
    return 'Code de vérification invalide';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryImplProvider);
  return AuthNotifier(authRepository);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<HbUser?>((ref) {
  return ref.watch(authProvider).user;
});

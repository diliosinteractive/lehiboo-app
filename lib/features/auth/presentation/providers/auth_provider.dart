import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Login - may require OTP verification (2FA)
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
      
      // No OTP required (shouldn't happen with 2FA, but handle it)
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
    String? phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
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

  String _parseError(dynamic e) {
    final message = e.toString();
    if (message.contains('invalid_credentials')) {
      return 'Email ou mot de passe incorrect';
    } else if (message.contains('user_exists')) {
      return 'Un compte existe déjà avec cet email';
    } else if (message.contains('weak_password')) {
      return 'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre';
    } else if (message.contains('invalid_email')) {
      return 'Adresse email invalide';
    } else if (message.contains('network')) {
      return 'Erreur de connexion. Vérifiez votre connexion internet.';
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

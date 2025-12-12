import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';

/// Result of initial registration - pending OTP verification
class RegistrationResult {
  final bool pendingVerification;
  final String userId;
  final String email;
  final String message;

  RegistrationResult({
    required this.pendingVerification,
    required this.userId,
    required this.email,
    required this.message,
  });
}

/// Result of login - may require OTP verification (2FA)
class LoginOtpResult {
  final bool requiresOtp;
  final String? userId;
  final String? email;
  final String? message;

  LoginOtpResult({
    required this.requiresOtp,
    this.userId,
    this.email,
    this.message,
  });
}

abstract class AuthRepository {
  /// Register a new user - returns pending verification result
  Future<RegistrationResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  /// Verify OTP and complete registration
  Future<AuthResult> verifyOtp({
    required String userId,
    required String email,
    required String otp,
  });

  /// Resend OTP code (for registration or login)
  Future<void> resendOtp({
    required String userId,
    required String email,
    String type = 'register',
  });

  /// Login - may require OTP (2FA)
  Future<LoginOtpResult> login({
    required String email,
    required String password,
  });

  /// Verify login OTP (2FA)
  Future<AuthResult> verifyLoginOtp({
    required String userId,
    required String email,
    required String otp,
  });

  Future<void> logout();

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<bool> refreshTokenIfNeeded();

  Future<HbUser?> getCurrentUser();

  Future<bool> isAuthenticated();
}

class AuthResult {
  final HbUser user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider not initialized');
});

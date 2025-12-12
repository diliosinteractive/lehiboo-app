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

  /// Resend OTP code
  Future<void> resendOtp({
    required String userId,
    required String email,
  });

  Future<AuthResult> login({
    required String email,
    required String password,
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

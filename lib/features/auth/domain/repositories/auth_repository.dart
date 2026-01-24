import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../data/models/business_register_dto.dart';

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

/// Result of login - may require OTP verification (2FA) or direct authentication
class LoginOtpResult {
  final bool requiresOtp;
  final String? userId;
  final String? email;
  final String? message;
  /// When requiresOtp is false and authResult is not null, the user is authenticated
  final AuthResult? authResult;

  LoginOtpResult({
    required this.requiresOtp,
    this.userId,
    this.email,
    this.message,
    this.authResult,
  });
}

abstract class AuthRepository {
  /// Register a new user - returns pending verification result
  Future<RegistrationResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
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

  // ============================================================
  // NEW REGISTRATION METHODS FOR MOBILE APP
  // ============================================================

  /// Register a customer (simple registration)
  /// Requires verifiedEmailToken from OTP verification
  Future<CustomerRegistrationResult> registerCustomer({
    required String verifiedEmailToken,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    required bool acceptTerms,
  });

  /// Register a business account (multi-step registration)
  Future<BusinessRegistrationResult> registerBusiness({
    required BusinessRegisterDto dto,
  });

  /// Send OTP code for email verification
  Future<OtpResult> sendOtpCode({
    required String email,
    required String type,
  });

  /// Verify OTP code
  Future<OtpVerificationResult> verifyOtpCode({
    required String email,
    required String code,
    required String type,
  });

  /// Check if email exists
  Future<bool> checkEmailExists(String email);
}

/// Result of customer registration
class CustomerRegistrationResult {
  final bool pendingVerification;
  final bool emailVerificationRequired;
  final String? userId;
  final String email;
  final String message;
  final AuthResult? authResult;

  CustomerRegistrationResult({
    required this.pendingVerification,
    required this.emailVerificationRequired,
    this.userId,
    required this.email,
    required this.message,
    this.authResult,
  });
}

/// Result of business registration
class BusinessRegistrationResult {
  final AuthResult authResult;
  final OrganizationInfo? organization;
  final int invitationsSent;
  final List<String>? invitedEmails;

  BusinessRegistrationResult({
    required this.authResult,
    this.organization,
    required this.invitationsSent,
    this.invitedEmails,
  });
}

/// Organization info
class OrganizationInfo {
  final int id;
  final String uuid;
  final String name;
  final String? type;

  OrganizationInfo({
    required this.id,
    required this.uuid,
    required this.name,
    this.type,
  });
}

/// OTP send result
class OtpResult {
  final bool success;
  final String message;
  final String? expiresAt;

  OtpResult({
    required this.success,
    required this.message,
    this.expiresAt,
  });
}

/// OTP verification result
class OtpVerificationResult {
  final bool success;
  final bool verified;
  final String message;
  /// Token received after successful OTP verification (for registration)
  final String? verifiedEmailToken;
  /// Token expiration time in minutes
  final int? tokenExpiresInMinutes;

  OtpVerificationResult({
    required this.success,
    required this.verified,
    required this.message,
    this.verifiedEmailToken,
    this.tokenExpiresInMinutes,
  });
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

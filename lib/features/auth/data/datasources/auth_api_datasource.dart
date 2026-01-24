import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/auth_response_dto.dart';
import '../models/business_register_dto.dart';

final authApiDataSourceProvider = Provider<AuthApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return AuthApiDataSource(dio);
});

/// Result of registration - pending OTP verification
class RegisterResult {
  final bool pendingVerification;
  final String userId;
  final String email;
  final String message;

  RegisterResult({
    required this.pendingVerification,
    required this.userId,
    required this.email,
    required this.message,
  });

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    return RegisterResult(
      pendingVerification: json['pending_verification'] ?? true,
      userId: json['user_id']?.toString() ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? 'Un code de vérification a été envoyé',
    );
  }
}

/// Result of login - may require OTP verification (2FA) or direct auth
class LoginResult {
  final bool requiresOtp;
  final String? userId;
  final String? email;
  final String? message;
  /// When login succeeds without OTP, this contains the auth data
  final AuthResponseDto? authResponse;

  LoginResult({
    required this.requiresOtp,
    this.userId,
    this.email,
    this.message,
    this.authResponse,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      requiresOtp: json['requires_otp'] ?? false,
      userId: json['user_id']?.toString(),
      email: json['email']?.toString(),
      message: json['message']?.toString(),
    );
  }
}

class AuthApiDataSource {
  final Dio _dio;

  AuthApiDataSource(this._dio);

  /// Register a new user - returns pending verification result
  Future<RegisterResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return RegisterResult.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Registration failed');
  }

  /// Verify OTP code and complete registration
  Future<AuthResponseDto> verifyOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    final response = await _dio.post(
      '/auth/verify-otp',
      data: {
        'user_id': userId,
        'email': email,
        'otp': otp,
      },
    );

    return _parseAuthResponse(response.data);
  }

  /// Resend OTP code
  Future<void> resendOtp({
    required String userId,
    required String email,
    String type = 'register',
  }) async {
    final response = await _dio.post(
      '/auth/resend-otp',
      data: {
        'user_id': userId,
        'email': email,
        'type': type,
      },
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to resend OTP');
    }
  }

  /// Login - may require OTP verification (2FA) or direct auth (Laravel v2)
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    debugPrint('🔐 Login response received: ${data.runtimeType}');

    // Laravel v2 format: { "message": "...", "data": { "user": {...}, "token": "..." } }
    // Check if we have a successful response with user and token
    if (data['data'] != null) {
      final responseData = data['data'];
      debugPrint('🔐 Response data found: user=${responseData['user'] != null}, token=${responseData['token'] != null}');

      // Check if OTP is required (2FA)
      if (responseData['requires_otp'] == true) {
        debugPrint('🔐 OTP required');
        return LoginResult.fromJson(responseData);
      }

      // Check if we have direct auth data (Laravel v2 - no OTP required)
      if (responseData['user'] != null && responseData['token'] != null) {
        try {
          debugPrint('🔐 Parsing Laravel auth response...');
          final authResponse = _parseLaravelAuthResponse(responseData);
          debugPrint('🔐 Auth response parsed successfully');
          return LoginResult(
            requiresOtp: false,
            authResponse: authResponse,
          );
        } catch (e, stackTrace) {
          debugPrint('🔐 Error parsing auth response: $e');
          debugPrint('🔐 Stack trace: $stackTrace');
          rethrow;
        }
      }

      // Fallback: no OTP required but no auth data (shouldn't happen)
      debugPrint('🔐 Fallback: no auth data in response');
      return LoginResult(requiresOtp: false);
    }

    debugPrint('🔐 No data in response, throwing exception');
    throw Exception(data['message'] ?? 'Login failed');
  }

  /// Parse Laravel v2 auth response format
  AuthResponseDto _parseLaravelAuthResponse(Map<String, dynamic> data) {
    final userData = data['user'] as Map<String, dynamic>;
    final token = data['token']?.toString() ?? '';

    // Map Laravel fields to Flutter DTO
    // Laravel returns: { id, name, email, phone, role, ... }
    // Flutter expects: { id, email, display_name, first_name, last_name, role, ... }
    final user = UserDto(
      id: userData['id'] is int ? userData['id'] : int.tryParse(userData['id'].toString()) ?? 0,
      email: userData['email']?.toString() ?? '',
      displayName: userData['name']?.toString() ?? '',
      firstName: userData['first_name']?.toString(),
      lastName: userData['last_name']?.toString(),
      phone: userData['phone']?.toString(),
      avatarUrl: userData['avatar_url']?.toString(),
      role: userData['role']?.toString() ?? 'customer',
      registeredAt: userData['created_at']?.toString(),
      isVerified: userData['is_email_verified'] == true,
    );

    // Laravel Sanctum uses single token, no refresh token
    // We'll use the same token for both access and refresh
    final tokens = TokensDto(
      accessToken: token,
      refreshToken: token, // Sanctum doesn't have refresh tokens
      tokenType: data['token_type']?.toString() ?? 'Bearer',
      expiresIn: 604800, // 7 days default
    );

    return AuthResponseDto(user: user, tokens: tokens);
  }

  /// Verify login OTP (2FA)
  Future<AuthResponseDto> verifyLoginOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    final response = await _dio.post(
      '/auth/verify-otp',
      data: {
        'user_id': userId,
        'email': email,
        'otp': otp,
      },
    );

    return _parseAuthResponse(response.data);
  }

  Future<TokensDto> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
    );

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return TokensDto.fromJson(data['data']['tokens'] ?? data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to refresh token');
  }

  Future<void> forgotPassword(String email) async {
    final response = await _dio.post(
      '/auth/forgot-password',
      data: {
        'email': email,
      },
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to send reset email');
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'new_password': newPassword,
      },
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to reset password');
    }
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  AuthResponseDto _parseAuthResponse(Map<String, dynamic> data) {
    if (data['success'] == true && data['data'] != null) {
      final responseData = data['data'];
      return AuthResponseDto(
        user: UserDto.fromJson(responseData['user']),
        tokens: TokensDto.fromJson(responseData['tokens']),
      );
    }
    throw Exception(data['data']?['message'] ?? 'Authentication failed');
  }

  // ============================================================
  // NEW REGISTRATION METHODS FOR MOBILE APP
  // ============================================================

  /// Register a customer (simple registration)
  /// POST /v1/auth/register
  Future<CustomerRegisterResult> registerCustomer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    required bool acceptTerms,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phone != null) 'phone': phone,
        'accept_terms': acceptTerms,
      },
    );

    final data = response.data;
    debugPrint('📱 Customer register response: $data');

    if (data['data'] != null) {
      final responseData = data['data'];
      return CustomerRegisterResult(
        user: responseData['user'] != null ? UserDto.fromJson(responseData['user']) : null,
        token: responseData['token']?.toString(),
        emailVerificationRequired: responseData['email_verification_required'] ?? true,
        pendingVerification: responseData['pending_verification'] ?? true,
        userId: responseData['user_id']?.toString() ?? responseData['user']?['id']?.toString(),
        email: responseData['email'] ?? email,
        message: responseData['message'] ?? data['message'] ?? 'Un code de vérification a été envoyé',
      );
    }
    throw Exception(data['message'] ?? 'Registration failed');
  }

  /// Register a business account (multi-step registration)
  /// POST /v1/auth/register/business
  Future<BusinessRegisterResult> registerBusiness({
    required BusinessRegisterDto dto,
  }) async {
    final response = await _dio.post(
      '/auth/register/business',
      data: dto.toJson(),
    );

    final data = response.data;
    debugPrint('📱 Business register response: $data');

    if (data['data'] != null) {
      final responseData = data['data'];
      return BusinessRegisterResult(
        user: UserDto.fromJson(responseData['user']),
        organization: responseData['organization'] != null
            ? OrganizationDto.fromJson(responseData['organization'])
            : null,
        token: responseData['token']?.toString() ?? '',
        invitationsSent: responseData['invitations_sent'] ?? 0,
        invitedEmails: responseData['invited_emails'] != null
            ? List<String>.from(responseData['invited_emails'])
            : null,
      );
    }
    throw Exception(data['message'] ?? 'Business registration failed');
  }

  /// Send OTP code via the new API endpoint
  /// POST /v1/auth/otp/send
  /// Laravel returns: { "message": "...", "expires_at": "...", "validity_minutes": 10 }
  Future<OtpSendResult> sendOtpCode({
    required String email,
    required String type,
  }) async {
    final response = await _dio.post(
      '/auth/otp/send',
      data: {
        'email': email,
        'type': type,
      },
    );

    final data = response.data;
    debugPrint('📱 OTP send response: $data');

    // Laravel returns the response directly at root level on success (HTTP 200)
    // Format: { "message": "...", "expires_at": "...", "validity_minutes": 10 }
    // On error (4xx), Dio throws an exception that is handled by the caller
    if (data is Map<String, dynamic>) {
      // Check for success indicators: expires_at field or message containing "succes"
      final hasExpiresAt = data['expires_at'] != null;
      final hasSuccessMessage = (data['message']?.toString() ?? '').toLowerCase().contains('succes');

      if (hasExpiresAt || hasSuccessMessage || data['success'] == true || data['data'] != null) {
        return OtpSendResult(
          success: true,
          message: data['message'] ?? data['data']?['message'] ?? 'Code envoyé',
          expiresAt: data['expires_at'] ?? data['data']?['expires_at'],
        );
      }
    }
    throw Exception(data['message'] ?? 'Failed to send OTP');
  }

  /// Verify OTP code via the new API endpoint
  /// POST /v1/auth/otp/verify
  /// Laravel returns: { "message": "...", "verified": true }
  Future<OtpVerifyResult> verifyOtpCode({
    required String email,
    required String code,
    required String type,
  }) async {
    final response = await _dio.post(
      '/auth/otp/verify',
      data: {
        'email': email,
        'code': code,
        'type': type,
      },
    );

    final data = response.data;
    debugPrint('📱 OTP verify response: $data');

    // Laravel returns the response directly at root level on success (HTTP 200)
    // Format: { "message": "...", "verified": true }
    // On error (4xx), Dio throws an exception that is handled by the caller
    if (data is Map<String, dynamic>) {
      // Check for verified field at root level (Laravel format) or in data (legacy format)
      final verified = data['verified'] ?? data['data']?['verified'] ?? false;

      if (verified == true || data['success'] == true) {
        return OtpVerifyResult(
          success: true,
          verified: true,
          message: data['message'] ?? 'Code vérifié',
        );
      }
    }
    throw Exception(data['message'] ?? 'Invalid OTP code');
  }

  /// Check if email exists
  /// POST /v1/auth/check-email
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _dio.post(
        '/auth/check-email',
        data: {'email': email},
      );
      final data = response.data;
      return data['data']?['exists'] ?? false;
    } catch (e) {
      debugPrint('📱 Check email error: $e');
      return false;
    }
  }
}

/// Result of customer registration
class CustomerRegisterResult {
  final UserDto? user;
  final String? token;
  final bool emailVerificationRequired;
  final bool pendingVerification;
  final String? userId;
  final String email;
  final String message;

  CustomerRegisterResult({
    this.user,
    this.token,
    required this.emailVerificationRequired,
    required this.pendingVerification,
    this.userId,
    required this.email,
    required this.message,
  });
}

/// Result of business registration
class BusinessRegisterResult {
  final UserDto user;
  final OrganizationDto? organization;
  final String token;
  final int invitationsSent;
  final List<String>? invitedEmails;

  BusinessRegisterResult({
    required this.user,
    this.organization,
    required this.token,
    required this.invitationsSent,
    this.invitedEmails,
  });
}

/// Result of OTP send
class OtpSendResult {
  final bool success;
  final String message;
  final String? expiresAt;

  OtpSendResult({
    required this.success,
    required this.message,
    this.expiresAt,
  });
}

/// Result of OTP verify
class OtpVerifyResult {
  final bool success;
  final bool verified;
  final String message;

  OtpVerifyResult({
    required this.success,
    required this.verified,
    required this.message,
  });
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/l10n/l10n.dart';
import '../models/auth_response_dto.dart';
import '../models/business_register_dto.dart';
import '../../../../core/utils/api_response_handler.dart';

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
      message:
          json['message'] ?? cachedAppLocalizations().authVerificationCodeSent,
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

  static const _defaultAccessTtlSeconds = 172800;

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

    final payload = ApiResponseHandler.extractObject(response.data);
    return RegisterResult.fromJson(payload);
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

  /// Resend OTP code (legacy method - delegates to new endpoint)
  /// @deprecated Use resendOtpCode() instead
  Future<void> resendOtp({
    required String userId,
    required String email,
    String type = 'register',
  }) async {
    // Map legacy type to new type format
    final otpType = type == 'register' ? 'email_verification' : type;

    final response = await _dio.post(
      '/auth/otp/resend',
      data: {
        'email': email,
        'type': otpType,
      },
    );

    // HTTP 4xx/5xx handled by Dio — a 200 means success
    ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
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

    debugPrint('🔐 Login response received: ${response.data.runtimeType}');

    final responseData = ApiResponseHandler.extractObject(response.data);
    final hasToken =
        responseData['tokens'] != null || responseData['token'] != null;
    debugPrint(
        '🔐 Response data found: user=${responseData['user'] != null}, token=$hasToken');

    // Check if OTP is required (2FA)
    if (responseData['requires_otp'] == true) {
      debugPrint('🔐 OTP required');
      return LoginResult.fromJson(responseData);
    }

    // Direct auth data (Laravel v2 - no OTP required)
    if (responseData['user'] != null && hasToken) {
      debugPrint('🔐 Parsing Laravel auth response...');
      final authResponse = _parseLaravelAuthResponse(responseData);
      debugPrint('🔐 Auth response parsed successfully');
      return LoginResult(
        requiresOtp: false,
        authResponse: authResponse,
      );
    }

    return LoginResult(requiresOtp: false);
  }

  /// Parse Laravel v2 auth response format
  AuthResponseDto _parseLaravelAuthResponse(Map<String, dynamic> data) {
    final userData = data['user'] as Map<String, dynamic>;

    // Map Laravel fields to Flutter DTO
    // Laravel returns: { id, name, email, phone, role, ... }
    // Flutter expects: { id, email, display_name, first_name, last_name, role, ... }
    final user = UserDto(
      id: userData['id'] is int
          ? userData['id']
          : int.tryParse(userData['id'].toString()) ?? 0,
      email: userData['email']?.toString() ?? '',
      displayName: userData['name']?.toString() ?? '',
      firstName: userData['first_name']?.toString(),
      lastName: userData['last_name']?.toString(),
      phone: userData['phone']?.toString(),
      avatarUrl: (userData['avatar'] ?? userData['avatar_url'])?.toString(),
      birthDate: userData['birthDate']?.toString() ??
          userData['birth_date']?.toString(),
      membershipCity: userData['membershipCity']?.toString() ??
          userData['membership_city']?.toString(),
      role: userData['role']?.toString() ?? 'customer',
      registeredAt: userData['created_at']?.toString(),
      isVerified: userData['is_email_verified'] == true,
      newsletter: userData['newsletter'] == true,
      onesignalId: userData['onesignal_id']?.toString(),
      pushNotificationsEnabled:
          userData['push_notifications_enabled'] == true ||
              userData['pushNotificationsEnabled'] == true,
    );

    final tokens = _parseTokensFromPayload(data) ??
        TokensDto(
          accessToken: data['token']?.toString() ?? '',
          refreshToken: data['token']?.toString() ?? '',
          tokenType: data['token_type']?.toString() ?? 'Bearer',
          expiresIn: _intOrDefault(
            data['expires_in'],
            _defaultAccessTtlSeconds,
          ),
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

    final payload = _extractObjectPayload(response.data, allowRoot: true);
    final tokens = _parseTokensFromPayload(
      payload,
      requireRefreshToken: true,
    );
    if (tokens == null) {
      throw const FormatException('Refresh response did not contain tokens');
    }
    return tokens;
  }

  Future<void> forgotPassword(String email) async {
    // HTTP 4xx/5xx handled by Dio — a 200 means success
    await _dio.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // HTTP 4xx/5xx handled by Dio — a 200 means success
    await _dio.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'new_password': newPassword,
      },
    );
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  AuthResponseDto _parseAuthResponse(Map<String, dynamic> data) {
    final responseData = ApiResponseHandler.extractObject(data);
    return AuthResponseDto(
      user: UserDto.fromJson(responseData['user']),
      tokens: _parseTokensFromPayload(responseData) ??
          TokensDto.fromJson(responseData['tokens']),
    );
  }

  Map<String, dynamic> _extractObjectPayload(
    dynamic data, {
    bool allowRoot = false,
  }) {
    try {
      return ApiResponseHandler.extractObject(data);
    } on ApiFormatException {
      if (allowRoot && data is Map<String, dynamic>) {
        return data;
      }
      rethrow;
    }
  }

  TokensDto? _parseTokensFromPayload(
    Map<String, dynamic> payload, {
    bool requireRefreshToken = false,
  }) {
    final rawTokens = payload['tokens'];
    final tokenMap =
        rawTokens is Map ? Map<String, dynamic>.from(rawTokens) : payload;

    final accessToken = _stringOrNull(tokenMap['access_token']) ??
        _stringOrNull(tokenMap['token']) ??
        _stringOrNull(payload['token']);
    if (accessToken == null || accessToken.isEmpty) return null;

    final parsedRefreshToken = _stringOrNull(tokenMap['refresh_token']) ??
        _stringOrNull(payload['refresh_token']);
    if (requireRefreshToken && parsedRefreshToken == null) return null;

    final refreshToken = parsedRefreshToken ?? accessToken;

    return TokensDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: _stringOrNull(tokenMap['token_type']) ??
          _stringOrNull(payload['token_type']) ??
          'Bearer',
      expiresIn: _intOrDefault(
        tokenMap['expires_in'] ?? payload['expires_in'],
        _defaultAccessTtlSeconds,
      ),
    );
  }

  String? _stringOrNull(dynamic value) {
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }

  int _intOrDefault(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // ============================================================
  // NEW REGISTRATION METHODS FOR MOBILE APP
  // ============================================================

  /// Register a customer (simple registration)
  /// POST /v1/auth/register
  /// Requires verified_email_token from OTP verification
  Future<CustomerRegisterResult> registerCustomer({
    required String verifiedEmailToken,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? birthDate,
    String? membershipCity,
    required bool acceptTerms,
    bool acceptMarketing = false,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'verified_email_token': verifiedEmailToken,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phone != null) 'phone': phone,
        if (birthDate != null) 'birth_date': birthDate,
        if (membershipCity != null) 'membership_city': membershipCity,
        'accept_terms': acceptTerms,
        'newsletter': acceptMarketing,
      },
    );

    debugPrint('📱 Customer register response: ${response.data}');

    final responseData = ApiResponseHandler.extractObject(response.data);
    return CustomerRegisterResult(
      user: responseData['user'] != null
          ? UserDto.fromJson(responseData['user'])
          : null,
      tokens: _parseTokensFromPayload(responseData),
      token: responseData['token']?.toString(),
      emailVerificationRequired:
          responseData['email_verification_required'] ?? true,
      pendingVerification: responseData['pending_verification'] ?? true,
      userId: responseData['user_id']?.toString() ??
          responseData['user']?['id']?.toString(),
      email: responseData['email'] ?? email,
      message: responseData['message'] ??
          cachedAppLocalizations().authVerificationCodeSent,
    );
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

    debugPrint('📱 Business register response: ${response.data}');

    final responseData = ApiResponseHandler.extractObject(response.data);
    return BusinessRegisterResult(
      user: UserDto.fromJson(responseData['user']),
      organization: responseData['organization'] != null
          ? OrganizationDto.fromJson(responseData['organization'])
          : null,
      tokens: _parseTokensFromPayload(responseData),
      token: responseData['token']?.toString() ?? '',
      invitationsSent: responseData['invitations_sent'] ?? 0,
      invitedEmails: responseData['invited_emails'] != null
          ? List<String>.from(responseData['invited_emails'])
          : null,
    );
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

    debugPrint('📱 OTP send response: ${response.data}');

    final payload =
        ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return OtpSendResult(
      success: true,
      message: payload['message'] ??
          cachedAppLocalizations().authVerificationCodeSent,
      expiresAt: payload['expires_at'],
    );
  }

  /// Verify OTP code via the new API endpoint
  /// POST /v1/auth/otp/verify
  /// Laravel returns: { "message": "...", "verified": true, "verified_email_token": "...", "token_expires_in_minutes": 30 }
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

    debugPrint('📱 OTP verify response: ${response.data}');

    final payload =
        ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    debugPrint(
        '📱 OTP verified, token received: ${payload['verified_email_token'] != null}');

    return OtpVerifyResult(
      success: true,
      verified: payload['verified'] ?? true,
      message: payload['message'] ??
          cachedAppLocalizations().authVerificationCodeVerified,
      verifiedEmailToken: payload['verified_email_token']?.toString(),
      tokenExpiresInMinutes: payload['token_expires_in_minutes'] is int
          ? payload['token_expires_in_minutes']
          : null,
    );
  }

  /// Resend OTP code via the new API endpoint
  /// POST /v1/auth/otp/resend
  /// Laravel returns: { "message": "...", "expires_at": "...", "validity_minutes": 10 }
  Future<OtpSendResult> resendOtpCode({
    required String email,
    required String type,
  }) async {
    final response = await _dio.post(
      '/auth/otp/resend',
      data: {
        'email': email,
        'type': type,
      },
    );

    debugPrint('📱 OTP resend response: ${response.data}');

    final payload =
        ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return OtpSendResult(
      success: true,
      message: payload['message'] ?? cachedAppLocalizations().authOtpResent,
      expiresAt: payload['expires_at'],
    );
  }

  /// Get OTP status
  /// POST /v1/auth/otp/status
  /// Laravel returns: { "has_pending_otp": bool, "can_resend": bool, "remaining_cooldown": int, "remaining_attempts": int }
  Future<OtpStatusResult> getOtpStatus({
    required String email,
    required String type,
  }) async {
    final response = await _dio.post(
      '/auth/otp/status',
      data: {
        'email': email,
        'type': type,
      },
    );

    debugPrint('📱 OTP status response: ${response.data}');

    final payload =
        ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return OtpStatusResult(
      hasPendingOtp: payload['has_pending_otp'] ?? false,
      canResend: payload['can_resend'] ?? true,
      remainingCooldown: payload['remaining_cooldown'] ?? 0,
      remainingAttempts: payload['remaining_attempts'] ?? 3,
    );
  }

  /// Check if email exists
  /// POST /v1/auth/check-email
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _dio.post(
        '/auth/check-email',
        data: {'email': email},
      );
      final payload = ApiResponseHandler.extractObject(response.data);
      return payload['exists'] ?? false;
    } catch (e) {
      debugPrint('📱 Check email error: $e');
      return false;
    }
  }
}

/// Result of customer registration
class CustomerRegisterResult {
  final UserDto? user;
  final TokensDto? tokens;
  final String? token;
  final bool emailVerificationRequired;
  final bool pendingVerification;
  final String? userId;
  final String email;
  final String message;

  CustomerRegisterResult({
    this.user,
    this.tokens,
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
  final TokensDto? tokens;
  final String token;
  final int invitationsSent;
  final List<String>? invitedEmails;

  BusinessRegisterResult({
    required this.user,
    this.organization,
    this.tokens,
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

  /// Token for registration (received after email_verification OTP)
  final String? verifiedEmailToken;

  /// Token expiration in minutes
  final int? tokenExpiresInMinutes;

  OtpVerifyResult({
    required this.success,
    required this.verified,
    required this.message,
    this.verifiedEmailToken,
    this.tokenExpiresInMinutes,
  });
}

/// Result of OTP status check
class OtpStatusResult {
  final bool hasPendingOtp;
  final bool canResend;
  final int remainingCooldown;
  final int remainingAttempts;

  OtpStatusResult({
    required this.hasPendingOtp,
    required this.canResend,
    required this.remainingCooldown,
    required this.remainingAttempts,
  });
}

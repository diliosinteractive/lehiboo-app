import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/auth_response_dto.dart';

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

/// Result of login - may require OTP verification (2FA)
class LoginResult {
  final bool requiresOtp;
  final String? userId;
  final String? email;
  final String? message;

  LoginResult({
    required this.requiresOtp,
    this.userId,
    this.email,
    this.message,
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

  /// Login - may require OTP verification (2FA)
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
    if (data['success'] == true && data['data'] != null) {
      final responseData = data['data'];
      // Check if OTP is required (2FA)
      if (responseData['requires_otp'] == true) {
        return LoginResult.fromJson(responseData);
      }
      // If no OTP required, return with requiresOtp = false
      return LoginResult(requiresOtp: false);
    }
    throw Exception(data['data']?['message'] ?? 'Login failed');
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
}

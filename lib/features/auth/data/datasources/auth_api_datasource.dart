import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/auth_response_dto.dart';

final authApiDataSourceProvider = Provider<AuthApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return AuthApiDataSource(dio);
});

class AuthApiDataSource {
  final Dio _dio;

  AuthApiDataSource(this._dio);

  Future<AuthResponseDto> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        if (phone != null) 'phone': phone,
      },
    );

    return _parseAuthResponse(response.data);
  }

  Future<AuthResponseDto> login({
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

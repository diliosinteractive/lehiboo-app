import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/conversation_dto.dart';
import '../models/quota_dto.dart';

/// Provider for the API datasource
final petitBooApiDataSourceProvider = Provider<PetitBooApiDataSource>((ref) {
  // Create a dedicated Dio instance for Petit Boo API
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.petitBooBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add auth interceptor to automatically include JWT token
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = SharedSecureStorage.instance;
        final token = await storage.read(key: AppConstants.keyAuthToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          if (kDebugMode) {
            debugPrint('🤖 PetitBoo: Adding auth token to request');
          }
        } else {
          if (kDebugMode) {
            debugPrint('🤖 PetitBoo: No auth token found');
          }
        }
        handler.next(options);
      },
    ),
  );

  return PetitBooApiDataSource(dio);
});

/// Exception for API-related errors
class PetitBooApiException implements Exception {
  final String message;
  final int? statusCode;

  PetitBooApiException(this.message, {this.statusCode});

  @override
  String toString() => 'PetitBooApiException: $message (status: $statusCode)';
}

/// DataSource for REST API calls to Petit Boo
class PetitBooApiDataSource {
  final Dio _dio;

  PetitBooApiDataSource(this._dio);

  /// Set the auth token for API requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear the auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Get list of conversations/sessions
  Future<ConversationsResponseDto> getConversations({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/sessions',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      return ConversationsResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a specific conversation with its messages
  Future<ConversationDto> getConversation(String uuid) async {
    try {
      final response = await _dio.get('/api/v1/sessions/$uuid');

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        return ConversationDto.fromJson(data['data']);
      }

      throw PetitBooApiException('Invalid response format');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create a new conversation/session
  Future<ConversationDto> createConversation({String? title}) async {
    try {
      final response = await _dio.post(
        '/api/v1/sessions',
        data: {
          if (title != null) 'title': title,
        },
      );

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        return ConversationDto.fromJson(data['data']);
      }

      throw PetitBooApiException('Invalid response format');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Archive/delete a conversation
  Future<void> deleteConversation(String uuid) async {
    try {
      await _dio.delete('/api/v1/sessions/$uuid');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get user's chat quota
  Future<QuotaDto> getQuota() async {
    try {
      final response = await _dio.get('/api/v1/quota');

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        return QuotaDto.fromJson(data['data']);
      }

      throw PetitBooApiException('Invalid response format');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to PetitBooApiException
  PetitBooApiException _handleDioError(DioException e) {
    if (kDebugMode) {
      debugPrint('🤖 PetitBoo API Error: ${e.message}');
      debugPrint('🤖 PetitBoo API Response: ${e.response?.data}');
    }

    final statusCode = e.response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return PetitBooApiException('Connection timeout', statusCode: statusCode);

      case DioExceptionType.connectionError:
        return PetitBooApiException('Network error', statusCode: statusCode);

      case DioExceptionType.badResponse:
        final message = _extractErrorMessage(e.response?.data);

        if (statusCode == 401) {
          return PetitBooApiException('Session expired', statusCode: statusCode);
        }
        if (statusCode == 403) {
          return PetitBooApiException('Access denied', statusCode: statusCode);
        }
        if (statusCode == 404) {
          return PetitBooApiException('Not found', statusCode: statusCode);
        }
        if (statusCode == 429) {
          return PetitBooApiException('Rate limit exceeded', statusCode: statusCode);
        }

        return PetitBooApiException(message, statusCode: statusCode);

      default:
        return PetitBooApiException(
          e.message ?? 'Unknown error',
          statusCode: statusCode,
        );
    }
  }

  /// Extract error message from response data
  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'Unknown error';

    if (data is Map<String, dynamic>) {
      // Check for direct message field
      if (data['message'] is String) {
        return data['message'] as String;
      }

      // Check for nested error object
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return error['message'] as String? ?? 'Unknown error';
      }
      if (error is String) {
        return error;
      }

      return 'Unknown error';
    }

    return data.toString();
  }
}

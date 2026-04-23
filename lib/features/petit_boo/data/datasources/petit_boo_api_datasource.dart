import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/conversation_dto.dart';
import '../models/quota_dto.dart';
import '../models/tool_schema_dto.dart';

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
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo API: GET /api/v1/sessions?page=$page&per_page=$perPage');
      }

      final response = await _dio.get(
        '/api/v1/sessions',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (kDebugMode) {
        debugPrint('🤖 PetitBoo API: Sessions response: ${response.data}');
      }

      return ConversationsResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw PetitBooApiException(
        ApiResponseHandler.extractError(e, fallback: 'Erreur Petit Boo'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get a specific conversation with its messages
  Future<ConversationDto> getConversation(String uuid) async {
    try {
      final response = await _dio.get('/api/v1/sessions/$uuid');
      final payload = ApiResponseHandler.extractObject(response.data);
      return ConversationDto.fromJson(payload);
    } on DioException catch (e) {
      throw PetitBooApiException(
        ApiResponseHandler.extractError(e, fallback: 'Erreur Petit Boo'),
        statusCode: e.response?.statusCode,
      );
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
      final payload = ApiResponseHandler.extractObject(response.data);
      return ConversationDto.fromJson(payload);
    } on DioException catch (e) {
      throw PetitBooApiException(
        ApiResponseHandler.extractError(e, fallback: 'Erreur Petit Boo'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Archive/delete a conversation
  Future<void> deleteConversation(String uuid) async {
    try {
      await _dio.delete('/api/v1/sessions/$uuid');
    } on DioException catch (e) {
      throw PetitBooApiException(
        ApiResponseHandler.extractError(e, fallback: 'Erreur Petit Boo'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get user's chat quota
  Future<QuotaDto> getQuota() async {
    try {
      final response = await _dio.get('/api/v1/quota');
      final payload = ApiResponseHandler.extractObject(response.data);
      return QuotaDto.fromJson(payload);
    } on DioException catch (e) {
      throw PetitBooApiException(
        ApiResponseHandler.extractError(e, fallback: 'Erreur Petit Boo'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get list of available tool schemas for dynamic UI rendering
  Future<List<ToolSchemaDto>> getToolSchemas() async {
    try {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo API: GET /api/v1/tools');
      }

      final response = await _dio.get('/api/v1/tools');

      final data = response.data;
      // Tools endpoint returns { "tools": [...] } at root
      if (data is Map<String, dynamic> && data['tools'] is List) {
        final toolsList = data['tools'] as List;
        return toolsList
            .map((t) => ToolSchemaDto.fromJson(t as Map<String, dynamic>))
            .toList();
      }

      return ToolsResponseDto.fromJson(data).tools;
    } on DioException catch (e) {
      throw PetitBooApiException(
        ApiResponseHandler.extractError(e, fallback: 'Erreur Petit Boo'),
        statusCode: e.response?.statusCode,
      );
    }
  }
}

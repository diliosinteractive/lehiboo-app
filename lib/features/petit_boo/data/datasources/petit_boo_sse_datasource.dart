import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/petit_boo_event_dto.dart';

/// Provider for the SSE datasource
final petitBooSseDataSourceProvider = Provider<PetitBooSseDataSource>((ref) {
  return PetitBooSseDataSource(
    baseUrl: AppConstants.petitBooBaseUrl,
    storage: SharedSecureStorage.instance,
  );
});

/// Exception for SSE-related errors
class PetitBooSseException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  PetitBooSseException(this.message, {this.code, this.statusCode});

  @override
  String toString() =>
      'PetitBooSseException: $message (code: $code, status: $statusCode)';
}

class _PetitBooHttpError {
  final String message;
  final String? code;

  const _PetitBooHttpError({
    required this.message,
    this.code,
  });
}

_PetitBooHttpError _parsePetitBooHttpError(String body, int statusCode) {
  final fallback = 'Server returned $statusCode';
  if (body.trim().isEmpty) {
    return _PetitBooHttpError(message: fallback);
  }

  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final error = decoded['error'];
      String? message;
      String? code;

      if (error is Map<String, dynamic>) {
        message = error['message'] as String?;
        code = error['code'] as String?;
      } else if (error is String) {
        message = error;
      }

      message ??= decoded['message'] as String?;
      code ??= decoded['code'] as String?;

      return _PetitBooHttpError(
        message: message ?? fallback,
        code: code,
      );
    }
  } catch (_) {
    // Fall through to the generic status message.
  }

  return _PetitBooHttpError(message: fallback);
}

/// DataSource for SSE streaming chat with Petit Boo
///
/// Uses the `http` package instead of Dio because Dio doesn't handle
/// Server-Sent Events streaming properly.
class PetitBooSseDataSource {
  final String baseUrl;
  final dynamic storage; // FlutterSecureStorage

  PetitBooSseDataSource({
    required this.baseUrl,
    required this.storage,
  });

  /// Send a message and receive streaming response via SSE
  ///
  /// Yields [PetitBooEventDto] for each SSE event received:
  /// - `session`: Contains session_uuid for new conversations
  /// - `token`: Contains streaming text content
  /// - `tool_call`: Indicates a tool is being called
  /// - `tool_result`: Contains tool execution results
  /// - `error`: Contains error information
  /// - `done`: Signals stream completion
  Stream<PetitBooEventDto> sendMessage({
    String? sessionUuid,
    required String message,
    required bool memoryEnabled,
  }) async* {
    // Get auth token from secure storage
    final token = await storage.read(key: AppConstants.keyAuthToken);

    if (token == null || token.isEmpty) {
      throw PetitBooSseException('Not authenticated', code: 'auth_required');
    }

    final uri = Uri.parse('$baseUrl/api/v1/chat');

    final request = http.Request('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
    });

    request.body = jsonEncode({
      if (sessionUuid != null) 'session_uuid': sessionUuid,
      'message': message,
      'memory_enabled': memoryEnabled,
    });

    if (kDebugMode) {
      debugPrint('🤖 PetitBoo SSE: Sending message to $uri');
      debugPrint('🤖 PetitBoo SSE: session_uuid=$sessionUuid');
      debugPrint('🤖 PetitBoo SSE: memory_enabled=$memoryEnabled');
    }

    try {
      final client = http.Client();
      final streamedResponse = await client.send(request).timeout(
        AppConstants.petitBooStreamTimeout,
        onTimeout: () {
          client.close();
          throw TimeoutException('SSE connection timeout');
        },
      );

      if (streamedResponse.statusCode != 200) {
        final body =
            await streamedResponse.stream.transform(utf8.decoder).join();
        final error =
            _parsePetitBooHttpError(body, streamedResponse.statusCode);
        client.close();
        throw PetitBooSseException(
          error.message,
          code: error.code,
          statusCode: streamedResponse.statusCode,
        );
      }

      // Buffer for incomplete SSE data
      String buffer = '';

      await for (final chunk
          in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // Process complete lines
        while (buffer.contains('\n')) {
          final lineEnd = buffer.indexOf('\n');
          final line = buffer.substring(0, lineEnd).trim();
          buffer = buffer.substring(lineEnd + 1);

          if (line.isEmpty) continue;

          // SSE format: "data: {...}"
          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6); // Remove "data: " prefix

            if (jsonStr.isEmpty || jsonStr == '[DONE]') continue;

            try {
              final json = jsonDecode(jsonStr) as Map<String, dynamic>;
              final event = PetitBooEventDto.fromJson(json);

              if (kDebugMode) {
                debugPrint(
                    '🤖 PetitBoo SSE: Received event type=${event.type}');
              }

              yield event;

              // Stop on done event
              if (event.type == 'done') {
                client.close();
                return;
              }

              // Handle error events
              if (event.type == 'error') {
                client.close();
                throw PetitBooSseException(
                  event.error ?? 'Unknown error',
                  code: event.code,
                );
              }
            } catch (e) {
              if (e is PetitBooSseException) rethrow;
              if (kDebugMode) {
                debugPrint('🤖 PetitBoo SSE: Failed to parse event: $e');
                debugPrint('🤖 PetitBoo SSE: Raw data: $jsonStr');
              }
              // Continue processing other events
            }
          }
        }
      }

      client.close();
    } on TimeoutException {
      throw PetitBooSseException('Connection timeout', code: 'timeout');
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo SSE: ClientException - ${e.message}');
      }
      throw PetitBooSseException('Network error: ${e.message}',
          code: 'network');
    } catch (e) {
      if (e is PetitBooSseException) rethrow;
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo SSE: Unexpected error - $e');
        debugPrint('🤖 PetitBoo SSE: Error type - ${e.runtimeType}');
      }
      // Check for common connection errors
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('connection') ||
          errorStr.contains('socket') ||
          errorStr.contains('closed')) {
        throw PetitBooSseException(
          'Connection lost - backend may have closed the connection',
          code: 'connection_closed',
        );
      }
      throw PetitBooSseException('Unexpected error: $e', code: 'unknown');
    }
  }

  /// Check if the Petit Boo service is available
  Future<bool> healthCheck() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/health/ready'),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo health check failed: $e');
      }
      return false;
    }
  }
}

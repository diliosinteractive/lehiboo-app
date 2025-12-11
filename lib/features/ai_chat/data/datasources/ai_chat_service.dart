import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/activity.dart'; // We'll map events to Activity

class AiChatService {
  final Dio _dio;
  String? _conversationId;
  Map<String, dynamic> _userContext = {};
  List<Map<String, dynamic>> _history = [];
  
  AiChatService(this._dio);
  
  Future<Map<String, dynamic>> sendMessage(String message) async {
    _conversationId ??= const Uuid().v4();
    
    // URL aligned with V2 Doc: https://preprod.lehiboo.com/api-planner/mobile/chat
    final url = '${AppConstants.aiBaseUrl}/mobile/chat';

    try {
      final response = await _dio.post(
        url,
        data: {
          'message': message,
          'conversation_id': _conversationId,
          'user_context': _userContext,
          'history': _history,
        },
        options: Options(
          headers: {
            'X-API-Key': AppConstants.apiKey,
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      // Dio throws on error status by default (unless validateStatus is changed)
      // but let's be safe
      final data = response.data;
      
      // Update local context
      if (data['user_context'] != null) {
        _userContext = data['user_context'];
      }
      if (data['history'] != null) {
        _history = List<Map<String, dynamic>>.from(data['history']);
      }
      
      return data;
    } catch (e) {
      debugPrint("AiChatService Error: $e");
      rethrow;
    }
  }

  void resetConversation() {
    _conversationId = null;
    _userContext = {};
    _history = [];
  }
}

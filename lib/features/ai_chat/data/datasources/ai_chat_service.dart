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
  String? _apiKey;

  Future<void> _fetchApiKey() async {
    try {
      // NOTE: dio base URL is already .../lehiboo/v2
      final response = await _dio.get('/auth/ai-token');
      if (response.data['success'] == true && response.data['data'] != null) {
        _apiKey = response.data['data']['api_key'];
      } else {
        throw Exception("Impossible de créer la session Chat.");
      }
    } catch (e) {
      debugPrint("Error fetching AI Token: $e");
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> sendMessage(String message) async {
    _conversationId ??= const Uuid().v4();
    
    // URL aligned with V2 Doc: https://preprod.lehiboo.com/api-planner/mobile/chat
    final url = '${AppConstants.aiBaseUrl}/mobile/chat';

    try {
      // Lazy load API Key
      if (_apiKey == null) {
        await _fetchApiKey();
      }

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
            if (_apiKey != null) 'X-API-Key': _apiKey!,
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

  void updateUserContext(Map<String, dynamic> context) {
    _userContext.addAll(context);
  }

  void resetConversation() {
    _conversationId = null;
    _userContext = {};
    _history = [];
  }
}

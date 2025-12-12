import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/activity.dart'; // We'll map events to Activity
import 'ai_context_storage.dart';

class AiChatService {
  final Dio _dio;
  final AiContextStorage _contextStorage;
  String? _conversationId;
  Map<String, dynamic> _userContext = {};
  List<Map<String, dynamic>> _history = [];
  
  AiChatService(this._dio, this._contextStorage) {
    _loadContext();
  }
  
  String? _apiKey;

  // Load context and history on startup
  void _loadContext() {
    _userContext = _contextStorage.getContext();
    _history = _contextStorage.getHistory();
  }

  Future<void> _fetchApiKey() async {
    // ... (unchanged)
    try {
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
    final url = '${AppConstants.aiBaseUrl}/mobile/chat';

    try {
      if (_apiKey == null) {
        await _fetchApiKey();
      }

      // Ensure we have the latest context
      if (_userContext.isEmpty) {
        _userContext = _contextStorage.getContext();
      }

      final response = await _dio.post(
        url,
        data: {
          'message': message,
          'conversation_id': _conversationId,
          'user_context': _userContext,
          // Sliding Window: Send only last 4 messages (Backend Spec)
          'history': _history.length > 4 ? _history.sublist(_history.length - 4) : _history,
        },
        options: Options(
          headers: {
            if (_apiKey != null) 'X-API-Key': _apiKey!,
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      final data = response.data;
      
      // Update local context and persist if changed
      if (data['user_context'] != null) {
        _userContext = data['user_context'];
        await _contextStorage.saveContext(_userContext);
      }
      
      // Update history from response (or append manually if backend doesn't return it full)
      // Spec: Backend returns the 2 new messages in 'history' or full? 
      // Current behavior: It returns updated history.
      // But we are sending TRUNCATED history (sliding window).
      // So relying on backend response for FULL history is risky if backend only echoes back what we sent.
      // Better strategy: Append new messages to our local FULL history.
      
      final aiMessageContent = data['message'] as String?;
      if (aiMessageContent != null) {
        _history.add({
          'role': 'user',
          'content': message, // We reconstruct it to be safe
          'timestamp': DateTime.now().toIso8601String(),
        });
        _history.add({
          'role': 'assistant',
          'content': aiMessageContent,
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        await _contextStorage.saveHistory(_history);
      }
      
      return data;
    } catch (e) {
      debugPrint("AiChatService Error: $e");
      rethrow;
    }
  }

  Map<String, dynamic> get userContext => _userContext;
  List<Map<String, dynamic>> get history => _history;

  void updateUserContext(Map<String, dynamic> context) {
    _userContext.addAll(context);
    _contextStorage.saveContext(_userContext);
  }

  void resetConversation() {
    _conversationId = null;
    _userContext = {};
    _history = [];
    _contextStorage.clear();
  }
}

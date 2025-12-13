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
  bool _isMemoryEnabled = true; // Default to true

  
  AiChatService(this._dio, this._contextStorage) {
    _loadContext();
  }
  
  String? _apiKey;

  // Load context and history on startup
  void _loadContext() {
    _userContext = _contextStorage.getContext();
    _history = _contextStorage.getHistory();
    _isMemoryEnabled = _contextStorage.getMemoryEnabled();
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
  
  // Fetch remote history
  Future<List<Map<String, dynamic>>> fetchRemoteHistory(String userId) async {
    final url = '${AppConstants.aiBaseUrl}/mobile/chat/history';
  
    try {
      if (_apiKey == null) await _fetchApiKey();
      
      final response = await _dio.get(
        url,
        queryParameters: {'userId': userId, 'limit': '50'},
        options: Options(headers: {if (_apiKey != null) 'X-API-Key': _apiKey!}),
      );
      
      if (response.data['success'] == true && response.data['data'] != null) {
        final data = response.data['data'];
        
        // 1. Sync History
        final List<dynamic> historyList = data['history'] ?? [];
        
        // Backend now returns full JSONB objects including 'events', so no need to merge!
        _history = historyList.map((e) => e as Map<String, dynamic>).toList();
        
        if (_isMemoryEnabled) {
          await _contextStorage.saveHistory(_history);
        }
        
        // 2. Sync Context (if provided and memory enabled)
        if (data['user_context'] != null && _isMemoryEnabled) {
          debugPrint("🧠 Synced User Context from History: ${data['user_context']}");
          _userContext = Map<String, dynamic>.from(data['user_context']);
          await _contextStorage.saveContext(_userContext);
        }

        return _history;
      }
      return [];
    } catch (e) {
      debugPrint("Fetch History Error: $e");
      return []; // Fail silently or locally
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message, {String? userId, bool addToHistory = true}) async {
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
          // Only send context if enabled
          'user_context': _isMemoryEnabled ? _userContext : {},

          if (userId != null) 'userId': userId,
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

      final responseData = response.data;
      // Handle standard API wrapper { success: true, data: { ... } }
      final data = (responseData['data'] != null && responseData['data'] is Map) 
          ? responseData['data'] 
          : responseData;
      
      debugPrint("🤖 AI Response Raw: ${responseData.keys.toList()}");
      if (data != responseData) debugPrint("🤖 AI Response Data unwrapped: ${data.keys.toList()}");

      // Update local context and persist if changed AND memory enabled
      if (data['user_context'] != null && _isMemoryEnabled) {
        debugPrint("🧠 Saving User Context: ${data['user_context']}");
        _userContext = Map<String, dynamic>.from(data['user_context']);
        await _contextStorage.saveContext(_userContext);
      } else {
        debugPrint("⚠️ No user_context in response or Memory Disabled");
      }
      
      // Update history
      final aiMessageContent = data['message'] as String?;
      if (aiMessageContent != null) {
        // Only add USER message if requested (avoid adding system prompts)
        if (addToHistory) {
          _history.add({
            'role': 'user',
            'content': message, 
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
        
        _history.add({
          'role': 'assistant',
          'content': aiMessageContent,
          'events': data['events'], // Persist events!
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        if (_isMemoryEnabled) {
          await _contextStorage.saveHistory(_history);
        }
      }
      
      return data;
    } catch (e) {
      debugPrint("AiChatService Error: $e");
      rethrow;
    }
  }

  Map<String, dynamic> get userContext => _userContext;
  List<Map<String, dynamic>> get history => _history;
  bool get isMemoryEnabled => _isMemoryEnabled;

  void updateUserContext(Map<String, dynamic> context) {
    if (!_isMemoryEnabled) return;
    _userContext.addAll(context);
    _contextStorage.saveContext(_userContext);
  }
  
  void updateContextKey(String key, dynamic value) {
    if (!_isMemoryEnabled) return;
    _userContext[key] = value;
    _contextStorage.saveContext(_userContext);
  }
  
  void removeContextKey(String key) {
    if (!_isMemoryEnabled) return;
    _userContext.remove(key);
    _contextStorage.saveContext(_userContext);
  }
  
  Future<void> setMemoryEnabled(bool enabled) async {
    _isMemoryEnabled = enabled;
    await _contextStorage.setMemoryEnabled(enabled);
    if (!enabled) {
      // Optional: Clear local history/context when disabled? 
      // For now, keeping it but not using it, as per privacy "pause" logic.
    }
  }

  void resetConversation() {
    _conversationId = null;
    _userContext = {};
    _history = [];
    _contextStorage.clear();
  }
}

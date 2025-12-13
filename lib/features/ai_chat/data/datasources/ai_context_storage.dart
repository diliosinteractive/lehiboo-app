import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AiContextStorage {
  static const String _key = 'ai_user_context';

  final SharedPreferences _prefs;

  AiContextStorage(this._prefs);

  /// Get stored user context or empty map
  Map<String, dynamic> getContext() {
    final jsonString = _prefs.getString(_key);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        // Clear corrupt data
        _prefs.remove(_key);
      }
    }
    return {};
  }

  /// Save user context (merging with existing is handled by service)
  Future<void> saveContext(Map<String, dynamic> context) async {
    await _prefs.setString(_key, json.encode(context));
  }

  static const String _historyKey = 'ai_chat_history';

  // ... previous code ...

  /// Get stored chat history
  List<Map<String, dynamic>> getHistory() {
    final jsonString = _prefs.getString(_historyKey);
    if (jsonString != null) {
      try {
        final List<dynamic> list = json.decode(jsonString);
        return list.map((e) => e as Map<String, dynamic>).toList();
      } catch (e) {
        _prefs.remove(_historyKey);
      }
    }
    return [];
  }

  /// Save chat history
  Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    await _prefs.setString(_historyKey, json.encode(history));
  }

  /// Clear all
  Future<void> clear() async {
    await _prefs.remove(_key);
    await _prefs.remove(_historyKey);
    // Do not clear memory setting preference
  }
  
  static const String _memoryEnabledKey = 'ai_memory_enabled';
  
  bool getMemoryEnabled() {
     return _prefs.getBool(_memoryEnabledKey) ?? true;
  }
  
  Future<void> setMemoryEnabled(bool enabled) async {
    await _prefs.setBool(_memoryEnabledKey, enabled);
  }
}

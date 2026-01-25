import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage for Petit Boo user context, history, and preferences.
///
/// Stores user preferences like city, age_group, children_ages, etc.
/// This data is sent to the AI to personalize responses.
class PetitBooContextStorage {
  static const String _contextKey = 'petit_boo_user_context';
  static const String _historyKey = 'petit_boo_chat_history';
  static const String _memoryEnabledKey = 'petit_boo_memory_enabled';

  final SharedPreferences _prefs;

  PetitBooContextStorage(this._prefs);

  // ==================== Context Methods ====================

  /// Get stored user context or empty map
  Map<String, dynamic> getContext() {
    final jsonString = _prefs.getString(_contextKey);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        // Clear corrupt data
        _prefs.remove(_contextKey);
      }
    }
    return {};
  }

  /// Save user context
  Future<void> saveContext(Map<String, dynamic> context) async {
    await _prefs.setString(_contextKey, json.encode(context));
  }

  /// Update a single key in the context
  Future<void> updateContextKey(String key, dynamic value) async {
    final context = getContext();
    context[key] = value;
    context['_lastUpdated'] = DateTime.now().toIso8601String();
    await saveContext(context);
  }

  /// Remove a single key from the context
  Future<void> removeContextKey(String key) async {
    final context = getContext();
    context.remove(key);
    await saveContext(context);
  }

  /// Merge new context with existing
  Future<void> mergeContext(Map<String, dynamic> newContext) async {
    final existingContext = getContext();
    existingContext.addAll(newContext);
    existingContext['_lastUpdated'] = DateTime.now().toIso8601String();
    await saveContext(existingContext);
  }

  // ==================== History Methods ====================

  /// Get stored chat history (local cache)
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

  /// Save chat history (local cache)
  Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    await _prefs.setString(_historyKey, json.encode(history));
  }

  /// Add a message to history
  Future<void> addToHistory(Map<String, dynamic> message) async {
    final history = getHistory();
    history.add(message);
    await saveHistory(history);
  }

  // ==================== Memory Toggle ====================

  /// Check if memory/context learning is enabled
  bool getMemoryEnabled() {
    return _prefs.getBool(_memoryEnabledKey) ?? true;
  }

  /// Enable or disable memory/context learning
  Future<void> setMemoryEnabled(bool enabled) async {
    await _prefs.setBool(_memoryEnabledKey, enabled);
  }

  // ==================== Clear Methods ====================

  /// Clear all context data
  Future<void> clearContext() async {
    await _prefs.remove(_contextKey);
  }

  /// Clear all history data
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  /// Clear all data (context + history), but keep memory preference
  Future<void> clear() async {
    await _prefs.remove(_contextKey);
    await _prefs.remove(_historyKey);
    // Keep memory enabled preference
  }

  /// Clear everything including memory preference
  Future<void> clearAll() async {
    await _prefs.remove(_contextKey);
    await _prefs.remove(_historyKey);
    await _prefs.remove(_memoryEnabledKey);
  }

  // ==================== Known Context Keys ====================

  /// Known context keys that the AI understands
  /// These are used for displaying/editing in the Brain screen
  static const List<String> knownContextKeys = [
    // Personal info
    'first_name',
    'last_name',
    'nickname',
    'age',
    'birth_year',
    'age_group', // young_adult, adult, senior

    // Location
    'city',
    'region',
    'country',
    'latitude',
    'longitude',
    'max_distance', // in km

    // Preferences
    'favorite_activities',
    'disliked_activities',
    'favorite_categories',
    'budget_preference', // low, medium, high

    // Family
    'group_type', // solo, couple, family, friends
    'has_children',
    'children_ages', // list of ages

    // Special needs
    'dietary_preferences', // vegetarian, vegan, halal, etc.
    'mobility_constraints',
    'pet_friendly_needed',
    'preferred_times', // morning, afternoon, evening

    // Other
    'preferred_language',
    'interests', // list of general interests

    // System
    '_lastUpdated', // timestamp of last context update
  ];

  /// Get a human-readable label for a context key
  static String getKeyLabel(String key) {
    switch (key) {
      case 'first_name':
        return 'Prénom';
      case 'last_name':
        return 'Nom';
      case 'nickname':
        return 'Surnom';
      case 'age':
        return 'Âge';
      case 'birth_year':
        return 'Année de naissance';
      case 'age_group':
        return 'Tranche d\'âge';
      case 'city':
        return 'Ville';
      case 'region':
        return 'Région';
      case 'country':
        return 'Pays';
      case 'latitude':
        return 'Latitude';
      case 'longitude':
        return 'Longitude';
      case 'max_distance':
        return 'Distance max (km)';
      case 'favorite_activities':
        return 'Activités préférées';
      case 'disliked_activities':
        return 'Activités à éviter';
      case 'favorite_categories':
        return 'Catégories préférées';
      case 'budget_preference':
        return 'Budget';
      case 'group_type':
        return 'Type de groupe';
      case 'has_children':
        return 'A des enfants';
      case 'children_ages':
        return 'Âge des enfants';
      case 'dietary_preferences':
        return 'Régime alimentaire';
      case 'mobility_constraints':
        return 'Contraintes de mobilité';
      case 'pet_friendly_needed':
        return 'Animaux acceptés';
      case 'preferred_times':
        return 'Moments préférés';
      case 'preferred_language':
        return 'Langue préférée';
      case 'interests':
        return 'Centres d\'intérêt';
      case '_lastUpdated':
        return 'Dernière mise à jour';
      default:
        return key;
    }
  }

  /// Get icon for a context key
  static String getKeyIcon(String key) {
    switch (key) {
      case 'first_name':
      case 'last_name':
      case 'nickname':
        return '👤';
      case 'age':
      case 'birth_year':
      case 'age_group':
        return '🎂';
      case 'city':
      case 'region':
      case 'country':
      case 'latitude':
      case 'longitude':
        return '📍';
      case 'max_distance':
        return '📏';
      case 'favorite_activities':
      case 'interests':
        return '❤️';
      case 'disliked_activities':
        return '👎';
      case 'favorite_categories':
        return '🏷️';
      case 'budget_preference':
        return '💰';
      case 'group_type':
        return '👥';
      case 'has_children':
      case 'children_ages':
        return '👶';
      case 'dietary_preferences':
        return '🍽️';
      case 'mobility_constraints':
        return '♿';
      case 'pet_friendly_needed':
        return '🐾';
      case 'preferred_times':
        return '🕐';
      case 'preferred_language':
        return '🌐';
      case '_lastUpdated':
        return '🕐';
      default:
        return '📝';
    }
  }

  /// Format a value for display
  static String formatValue(String key, dynamic value) {
    if (value == null) return 'Non défini';

    if (value is List) {
      return value.join(', ');
    }

    if (value is bool) {
      return value ? 'Oui' : 'Non';
    }

    if (key == 'age_group') {
      switch (value) {
        case 'young_adult':
          return 'Jeune adulte';
        case 'adult':
          return 'Adulte';
        case 'senior':
          return 'Senior';
        default:
          return value.toString();
      }
    }

    if (key == 'budget_preference') {
      switch (value) {
        case 'low':
          return 'Petit budget';
        case 'medium':
          return 'Budget moyen';
        case 'high':
          return 'Gros budget';
        default:
          return value.toString();
      }
    }

    if (key == 'group_type') {
      switch (value) {
        case 'solo':
          return 'Seul(e)';
        case 'couple':
          return 'En couple';
        case 'family':
          return 'En famille';
        case 'friends':
          return 'Entre amis';
        default:
          return value.toString();
      }
    }

    if (key == '_lastUpdated') {
      try {
        final date = DateTime.parse(value.toString());
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        return value.toString();
      }
    }

    return value.toString();
  }
}

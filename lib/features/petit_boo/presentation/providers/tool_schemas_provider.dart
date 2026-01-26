import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/tool_schema_dto.dart';

/// Cached map of tool schemas indexed by tool name
/// Currently uses hardcoded defaults as the backend /api/v1/tools
/// returns technical schemas (for LLM) not UI schemas.
/// TODO: When backend adds UI fields (display_type, icon, color, etc.),
/// uncomment the API call below.
final toolSchemasProvider =
    FutureProvider<Map<String, ToolSchemaDto>>((ref) async {
  // For now, use defaults directly - the backend API doesn't include UI info yet
  if (kDebugMode) {
    debugPrint('🤖 ToolSchemas: Using ${defaultToolSchemas.length} default schemas');
  }
  return defaultToolSchemas;

  // Uncomment when backend adds UI fields to /api/v1/tools:
  /*
  final api = ref.read(petitBooApiDataSourceProvider);
  try {
    final schemas = await api.getToolSchemas();
    if (kDebugMode) {
      debugPrint('🤖 ToolSchemas: Loaded ${schemas.length} tool schemas');
    }
    return {for (var s in schemas) s.name: s};
  } catch (e) {
    if (kDebugMode) {
      debugPrint('🤖 ToolSchemas: Failed to load schemas: $e');
    }
    return defaultToolSchemas;
  }
  */
});

/// Helper to get a specific schema by tool name
ToolSchemaDto? getToolSchema(WidgetRef ref, String toolName) {
  final asyncSchemas = ref.watch(toolSchemasProvider);
  return asyncSchemas.valueOrNull?[toolName];
}

/// Default schemas for known tools (fallback if API fails)
/// These are based on the current hardcoded implementations
final defaultToolSchemas = <String, ToolSchemaDto>{
  'getMyFavorites': const ToolSchemaDto(
    name: 'getMyFavorites',
    description: 'Mes événements favoris',
    displayType: 'event_list',
    icon: 'favorite',
    color: '#E74C3C',
    title: 'Tes favoris',
    emptyMessage: 'Aucun favori',
    responseSchema: ToolResponseSchemaDto(
      itemsKey: 'favorites',
      totalKey: 'total',
      itemSchema: ToolItemSchemaDto(
        titleField: 'title',
        imageField: 'image_url',
        dateField: 'next_slot_date',
        navigation: ToolNavigationDto(
          route: '/event/{slug}',
          idField: 'slug',
        ),
      ),
    ),
  ),
  'searchEvents': const ToolSchemaDto(
    name: 'searchEvents',
    description: 'Recherche d\'événements',
    displayType: 'event_list',
    icon: 'search',
    color: '#FF601F',
    title: 'Événements trouvés',
    emptyMessage: 'Aucun événement trouvé avec ces critères',
    responseSchema: ToolResponseSchemaDto(
      itemsKey: 'events',
      totalKey: 'total',
      itemSchema: ToolItemSchemaDto(
        titleField: 'title',
        subtitleField: 'venue_name',
        imageField: 'image_url',
        dateField: 'next_slot_date',
        priceField: 'price_display',
        badgeConditionField: 'is_free',
        badgeText: 'Gratuit',
        navigation: ToolNavigationDto(
          route: '/event/{slug}',
          idField: 'slug',
        ),
      ),
    ),
  ),
  'getMyBookings': const ToolSchemaDto(
    name: 'getMyBookings',
    description: 'Mes réservations',
    displayType: 'booking_list',
    icon: 'confirmation_number_outlined',
    color: '#FF601F',
    title: 'Tes réservations',
    emptyMessage: 'Aucune réservation',
    responseSchema: ToolResponseSchemaDto(
      itemsKey: 'bookings',
      totalKey: 'total',
      itemSchema: ToolItemSchemaDto(
        titleField: 'event_title',
        imageField: 'event_image',
        dateField: 'slot_date',
        timeField: 'slot_time',
        statusField: 'status',
        navigation: ToolNavigationDto(
          route: '/booking/{uuid}',
          idField: 'uuid',
        ),
      ),
    ),
  ),
  'getMyTickets': const ToolSchemaDto(
    name: 'getMyTickets',
    description: 'Mes billets',
    displayType: 'booking_list',
    icon: 'qr_code_2',
    color: '#27AE60',
    title: 'Tes billets',
    emptyMessage: 'Aucun billet',
    responseSchema: ToolResponseSchemaDto(
      itemsKey: 'tickets',
      totalKey: 'total',
      itemSchema: ToolItemSchemaDto(
        titleField: 'event_title',
        subtitleField: 'ticket_type',
        dateField: 'slot_date',
        timeField: 'slot_time',
        statusField: 'status',
        navigation: ToolNavigationDto(
          route: '/ticket/{uuid}',
          idField: 'uuid',
        ),
      ),
    ),
  ),
  'getEventDetails': const ToolSchemaDto(
    name: 'getEventDetails',
    description: 'Détails d\'un événement',
    displayType: 'event_detail',
    icon: 'event',
    color: '#FF601F',
    responseSchema: ToolResponseSchemaDto(
      itemSchema: ToolItemSchemaDto(
        titleField: 'title',
        subtitleField: 'venue.name',
        imageField: 'image_url',
        navigation: ToolNavigationDto(
          route: '/event/{slug}',
          idField: 'slug',
        ),
      ),
    ),
  ),
  'getMyAlerts': const ToolSchemaDto(
    name: 'getMyAlerts',
    description: 'Mes alertes',
    displayType: 'list',
    icon: 'notifications_active',
    color: '#F39C12',
    title: 'Tes alertes',
    emptyMessage: 'Aucune alerte',
    responseSchema: ToolResponseSchemaDto(
      itemsKey: 'alerts',
      totalKey: 'total',
      itemSchema: ToolItemSchemaDto(
        titleField: 'name',
        subtitleField: 'search_criteria_summary',
        navigation: ToolNavigationDto(
          route: '/alerts/{uuid}',
          idField: 'uuid',
        ),
      ),
    ),
  ),
  'getMyProfile': const ToolSchemaDto(
    name: 'getMyProfile',
    description: 'Mon profil',
    displayType: 'profile',
    icon: 'person',
    color: '#FF601F',
    responseSchema: ToolResponseSchemaDto(
      itemKey: 'user',
      stats: [
        ToolStatSchemaDto(
          icon: 'confirmation_number_outlined',
          label: 'Réservations',
          field: 'stats.total_bookings',
        ),
        ToolStatSchemaDto(
          icon: 'event_available',
          label: 'Participations',
          field: 'stats.total_events_attended',
        ),
        ToolStatSchemaDto(
          icon: 'favorite_border',
          label: 'Favoris',
          field: 'stats.total_favorites',
        ),
        ToolStatSchemaDto(
          icon: 'notifications_outlined',
          label: 'Alertes',
          field: 'stats.total_alerts',
        ),
      ],
    ),
  ),
  'getNotifications': const ToolSchemaDto(
    name: 'getNotifications',
    description: 'Mes notifications',
    displayType: 'list',
    icon: 'notifications',
    color: '#3498DB',
    title: 'Tes notifications',
    emptyMessage: 'Aucune notification',
    responseSchema: ToolResponseSchemaDto(
      itemsKey: 'notifications',
      totalKey: 'total',
      itemSchema: ToolItemSchemaDto(
        titleField: 'title',
        subtitleField: 'body',
        dateField: 'created_at',
      ),
    ),
  ),

  // ============================================
  // BRAIN TOOLS
  // ============================================
  'getBrain': const ToolSchemaDto(
    name: 'getBrain',
    description: 'Ma mémoire',
    displayType: 'brain_memory',
    icon: 'psychology',
    color: '#9B59B6',
    title: 'Ce que je sais de toi',
    emptyMessage: 'Je ne sais encore rien. Discutons !',
    sectionSchemas: [
      BrainSectionSchemaDto(key: 'family', title: 'Famille', icon: 'family_restroom'),
      BrainSectionSchemaDto(key: 'location', title: 'Localisation', icon: 'location_on'),
      BrainSectionSchemaDto(key: 'preferences', title: 'Préférences', icon: 'thumb_up'),
      BrainSectionSchemaDto(key: 'constraints', title: 'Contraintes', icon: 'block'),
    ],
  ),

  'updateBrain': const ToolSchemaDto(
    name: 'updateBrain',
    description: 'Mettre à jour ma mémoire',
    displayType: 'action_confirmation',
    icon: 'psychology',
    color: '#9B59B6',
    actionType: 'brain_update',
  ),

  // ============================================
  // FAVORITES TOOLS
  // ============================================
  'addToFavorites': const ToolSchemaDto(
    name: 'addToFavorites',
    description: 'Ajouter aux favoris',
    displayType: 'action_confirmation',
    icon: 'favorite',
    color: '#E74C3C',
    actionType: 'favorite_add',
  ),

  'removeFromFavorites': const ToolSchemaDto(
    name: 'removeFromFavorites',
    description: 'Retirer des favoris',
    displayType: 'action_confirmation',
    icon: 'favorite_border',
    color: '#95A5A6',
    actionType: 'favorite_remove',
  ),

  'createFavoriteList': const ToolSchemaDto(
    name: 'createFavoriteList',
    description: 'Créer une liste de favoris',
    displayType: 'action_confirmation',
    icon: 'folder_special',
    color: '#3498DB',
    actionType: 'list_create',
  ),

  'moveToList': const ToolSchemaDto(
    name: 'moveToList',
    description: 'Déplacer vers une liste',
    displayType: 'action_confirmation',
    icon: 'drive_file_move',
    color: '#3498DB',
    actionType: 'move_to_list',
  ),

  'getFavoriteLists': const ToolSchemaDto(
    name: 'getFavoriteLists',
    description: 'Voir mes listes de favoris',
    displayType: 'favorite_lists',
    icon: 'folder_special',
    color: '#E74C3C',
    title: 'Mes listes de favoris',
  ),

  'updateFavoriteList': const ToolSchemaDto(
    name: 'updateFavoriteList',
    description: 'Renommer une liste',
    displayType: 'action_confirmation',
    icon: 'edit',
    color: '#3498DB',
    actionType: 'list_rename',
  ),

  'deleteFavoriteList': const ToolSchemaDto(
    name: 'deleteFavoriteList',
    description: 'Supprimer une liste',
    displayType: 'action_confirmation',
    icon: 'delete',
    color: '#E74C3C',
    actionType: 'list_delete',
  ),

  // ============================================
  // TRIP PLANNER
  // ============================================
  'planTrip': const ToolSchemaDto(
    name: 'planTrip',
    description: 'Planifier un itinéraire',
    displayType: 'trip_plan',
    icon: 'route',
    color: '#27AE60',
    title: 'Ton itinéraire',
    tripSchema: TripSchemaDto(showMap: true, enableReorder: true),
  ),

  'saveTripPlan': const ToolSchemaDto(
    name: 'saveTripPlan',
    description: 'Sauvegarder un plan de sortie',
    displayType: 'action_confirmation',
    icon: 'bookmark',
    color: '#27AE60',
    actionType: 'trip_save',
    showToast: true,
  ),
};

/// Aliases for tool names (snake_case → camelCase)
const _toolNameAliases = {
  'update_brain': 'updateBrain',
  'get_brain': 'getBrain',
  'add_to_favorites': 'addToFavorites',
  'remove_from_favorites': 'removeFromFavorites',
  'create_favorite_list': 'createFavoriteList',
  'move_to_list': 'moveToList',
  'plan_trip': 'planTrip',
  'search_events': 'searchEvents',
  'get_event_details': 'getEventDetails',
  'get_my_favorites': 'getMyFavorites',
  'get_my_bookings': 'getMyBookings',
  'get_my_tickets': 'getMyTickets',
  'get_my_alerts': 'getMyAlerts',
  'get_my_profile': 'getMyProfile',
  'get_notifications': 'getNotifications',
  // New list management tools
  'get_favorite_lists': 'getFavoriteLists',
  'update_favorite_list': 'updateFavoriteList',
  'delete_favorite_list': 'deleteFavoriteList',
  // Trip planner
  'save_trip_plan': 'saveTripPlan',
};

/// Normalize tool name to camelCase
String _normalizeToolName(String toolName) {
  // Check direct alias first
  if (_toolNameAliases.containsKey(toolName)) {
    return _toolNameAliases[toolName]!;
  }

  // Convert snake_case to camelCase
  if (toolName.contains('_')) {
    final parts = toolName.split('_');
    return parts.first + parts.skip(1).map((p) =>
      p.isNotEmpty ? '${p[0].toUpperCase()}${p.substring(1)}' : ''
    ).join();
  }

  return toolName;
}

/// Get schema with fallback to defaults
/// Handles both snake_case and camelCase tool names
ToolSchemaDto? getToolSchemaWithFallback(
  Map<String, ToolSchemaDto>? loadedSchemas,
  String toolName,
) {
  final normalizedName = _normalizeToolName(toolName);

  // Try loaded schemas first (with both original and normalized name)
  if (loadedSchemas != null) {
    if (loadedSchemas.containsKey(toolName)) {
      return loadedSchemas[toolName];
    }
    if (loadedSchemas.containsKey(normalizedName)) {
      return loadedSchemas[normalizedName];
    }
  }

  // Try defaults with both names
  return defaultToolSchemas[toolName] ?? defaultToolSchemas[normalizedName];
}

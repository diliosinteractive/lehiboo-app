import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/petit_boo_api_datasource.dart';
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
};

/// Get schema with fallback to defaults
ToolSchemaDto? getToolSchemaWithFallback(
  Map<String, ToolSchemaDto>? loadedSchemas,
  String toolName,
) {
  return loadedSchemas?[toolName] ?? defaultToolSchemas[toolName];
}

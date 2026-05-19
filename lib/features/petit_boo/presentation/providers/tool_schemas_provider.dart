import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_locale.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/tool_schema_dto.dart';

/// Cached map of tool schemas indexed by tool name
/// Currently uses hardcoded defaults as the backend /api/v1/tools
/// returns technical schemas (for LLM) not UI schemas.
/// TODO: When backend adds UI fields (display_type, icon, color, etc.),
/// uncomment the API call below.
final toolSchemasProvider =
    FutureProvider<Map<String, ToolSchemaDto>>((ref) async {
  final languageCode = ref.watch(appLanguageCodeProvider);
  final l10n = lookupAppLocalizations(Locale(languageCode));
  final defaults = defaultToolSchemas(l10n);

  // For now, use defaults directly - the backend API doesn't include UI info yet
  if (kDebugMode) {
    debugPrint('🤖 ToolSchemas: Using ${defaults.length} default schemas');
  }
  return defaults;

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
    return defaults;
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
Map<String, ToolSchemaDto> defaultToolSchemas(AppLocalizations l10n) =>
    <String, ToolSchemaDto>{
      'getMyFavorites': ToolSchemaDto(
        name: 'getMyFavorites',
        description: l10n.petitBooToolFavoritesDescription,
        displayType: 'event_list',
        icon: 'favorite',
        color: '#E74C3C',
        title: l10n.petitBooToolFavoritesTitle,
        emptyMessage: l10n.petitBooToolFavoritesEmpty,
        responseSchema: const ToolResponseSchemaDto(
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
      'searchEvents': ToolSchemaDto(
        name: 'searchEvents',
        description: l10n.petitBooToolSearchEventsDescription,
        displayType: 'event_list',
        icon: 'search',
        color: '#FF601F',
        title: l10n.petitBooToolSearchEventsTitle,
        emptyMessage: l10n.petitBooToolSearchEventsEmpty,
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
            badgeText: l10n.petitBooToolFreeBadge,
            navigation: const ToolNavigationDto(
              route: '/event/{slug}',
              idField: 'slug',
            ),
          ),
        ),
      ),
      'getMyBookings': ToolSchemaDto(
        name: 'getMyBookings',
        description: l10n.petitBooToolBookingsDescription,
        displayType: 'booking_list',
        icon: 'confirmation_number_outlined',
        color: '#FF601F',
        title: l10n.petitBooToolBookingsTitle,
        emptyMessage: l10n.petitBooToolBookingsEmpty,
        responseSchema: const ToolResponseSchemaDto(
          itemsKey: 'bookings',
          totalKey: 'total',
          itemSchema: ToolItemSchemaDto(
            titleField: 'event_title',
            imageField: 'event_image',
            dateField: 'slot_date',
            timeField: 'slot_time',
            statusField: 'status',
            navigation: ToolNavigationDto(
              route: '/booking-detail/{uuid}',
              idField: 'uuid',
            ),
          ),
        ),
      ),
      'getMyTickets': ToolSchemaDto(
        name: 'getMyTickets',
        description: l10n.petitBooToolTicketsDescription,
        displayType: 'booking_list',
        icon: 'qr_code_2',
        color: '#27AE60',
        title: l10n.petitBooToolTicketsTitle,
        emptyMessage: l10n.petitBooToolTicketsEmpty,
        responseSchema: const ToolResponseSchemaDto(
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
      'getEventDetails': ToolSchemaDto(
        name: 'getEventDetails',
        description: l10n.petitBooToolEventDetailsDescription,
        displayType: 'event_detail',
        icon: 'event',
        color: '#FF601F',
        responseSchema: const ToolResponseSchemaDto(
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
      'getMyAlerts': ToolSchemaDto(
        name: 'getMyAlerts',
        description: l10n.petitBooToolAlertsDescription,
        displayType: 'list',
        icon: 'notifications_active',
        color: '#F39C12',
        title: l10n.petitBooToolAlertsTitle,
        emptyMessage: l10n.petitBooToolAlertsEmpty,
        responseSchema: const ToolResponseSchemaDto(
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
      'getMyProfile': ToolSchemaDto(
        name: 'getMyProfile',
        description: l10n.petitBooToolProfileDescription,
        displayType: 'profile',
        icon: 'person',
        color: '#FF601F',
        responseSchema: ToolResponseSchemaDto(
          itemKey: 'user',
          stats: [
            ToolStatSchemaDto(
              icon: 'confirmation_number_outlined',
              label: l10n.petitBooToolProfileStatBookings,
              field: 'stats.total_bookings',
            ),
            ToolStatSchemaDto(
              icon: 'event_available',
              label: l10n.petitBooToolProfileStatParticipations,
              field: 'stats.total_events_attended',
            ),
            ToolStatSchemaDto(
              icon: 'favorite_border',
              label: l10n.petitBooToolProfileStatFavorites,
              field: 'stats.total_favorites',
            ),
            ToolStatSchemaDto(
              icon: 'notifications_outlined',
              label: l10n.petitBooToolProfileStatAlerts,
              field: 'stats.total_alerts',
            ),
          ],
        ),
      ),
      'getNotifications': ToolSchemaDto(
        name: 'getNotifications',
        description: l10n.petitBooToolNotificationsDescription,
        displayType: 'list',
        icon: 'notifications',
        color: '#3498DB',
        title: l10n.petitBooToolNotificationsTitle,
        emptyMessage: l10n.petitBooToolNotificationsEmpty,
        responseSchema: const ToolResponseSchemaDto(
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
      'getBrain': ToolSchemaDto(
        name: 'getBrain',
        description: l10n.petitBooToolBrainDescription,
        displayType: 'brain_memory',
        icon: 'psychology',
        color: '#9B59B6',
        title: l10n.petitBooToolBrainTitle,
        emptyMessage: l10n.petitBooToolBrainEmpty,
        sectionSchemas: [
          BrainSectionSchemaDto(
            key: 'family',
            title: l10n.petitBooToolBrainSectionFamily,
            icon: 'family_restroom',
          ),
          BrainSectionSchemaDto(
            key: 'location',
            title: l10n.petitBooToolBrainSectionLocation,
            icon: 'location_on',
          ),
          BrainSectionSchemaDto(
            key: 'preferences',
            title: l10n.petitBooToolBrainSectionPreferences,
            icon: 'thumb_up',
          ),
          BrainSectionSchemaDto(
            key: 'constraints',
            title: l10n.petitBooToolBrainSectionConstraints,
            icon: 'block',
          ),
        ],
      ),

      'updateBrain': ToolSchemaDto(
        name: 'updateBrain',
        description: l10n.petitBooToolUpdateBrainDescription,
        displayType: 'action_confirmation',
        icon: 'psychology',
        color: '#9B59B6',
        actionType: 'brain_update',
      ),

      // ============================================
      // FAVORITES TOOLS
      // ============================================
      'addToFavorites': ToolSchemaDto(
        name: 'addToFavorites',
        description: l10n.petitBooToolAddFavoriteDescription,
        displayType: 'action_confirmation',
        icon: 'favorite',
        color: '#E74C3C',
        actionType: 'favorite_add',
      ),

      'removeFromFavorites': ToolSchemaDto(
        name: 'removeFromFavorites',
        description: l10n.petitBooToolRemoveFavoriteDescription,
        displayType: 'action_confirmation',
        icon: 'favorite_border',
        color: '#95A5A6',
        actionType: 'favorite_remove',
      ),

      'createFavoriteList': ToolSchemaDto(
        name: 'createFavoriteList',
        description: l10n.petitBooToolCreateFavoriteListDescription,
        displayType: 'action_confirmation',
        icon: 'folder_special',
        color: '#3498DB',
        actionType: 'list_create',
      ),

      'moveToList': ToolSchemaDto(
        name: 'moveToList',
        description: l10n.petitBooToolMoveToListDescription,
        displayType: 'action_confirmation',
        icon: 'drive_file_move',
        color: '#3498DB',
        actionType: 'move_to_list',
      ),

      'getFavoriteLists': ToolSchemaDto(
        name: 'getFavoriteLists',
        description: l10n.petitBooToolFavoriteListsDescription,
        displayType: 'favorite_lists',
        icon: 'folder_special',
        color: '#E74C3C',
        title: l10n.petitBooToolFavoriteListsTitle,
      ),

      'updateFavoriteList': ToolSchemaDto(
        name: 'updateFavoriteList',
        description: l10n.petitBooToolUpdateFavoriteListDescription,
        displayType: 'action_confirmation',
        icon: 'edit',
        color: '#3498DB',
        actionType: 'list_rename',
      ),

      'deleteFavoriteList': ToolSchemaDto(
        name: 'deleteFavoriteList',
        description: l10n.petitBooToolDeleteFavoriteListDescription,
        displayType: 'action_confirmation',
        icon: 'delete',
        color: '#E74C3C',
        actionType: 'list_delete',
      ),

      // ============================================
      // TRIP PLANNER
      // ============================================
      'planTrip': ToolSchemaDto(
        name: 'planTrip',
        description: l10n.petitBooToolPlanTripDescription,
        displayType: 'trip_plan',
        icon: 'route',
        color: '#27AE60',
        title: l10n.petitBooToolPlanTripTitle,
        tripSchema: const TripSchemaDto(showMap: true, enableReorder: true),
      ),

      'saveTripPlan': ToolSchemaDto(
        name: 'saveTripPlan',
        description: l10n.petitBooToolSaveTripPlanDescription,
        displayType: 'action_confirmation',
        icon: 'bookmark',
        color: '#27AE60',
        actionType: 'trip_save',
        showToast: true,
      ),

      'getMyTripPlans': ToolSchemaDto(
        name: 'getMyTripPlans',
        description: l10n.petitBooToolTripPlansDescription,
        displayType: 'trip_plans_list',
        icon: 'route',
        color: '#27AE60',
        title: l10n.petitBooToolTripPlansTitle,
        emptyMessage: l10n.petitBooToolTripPlansEmpty,
        responseSchema: const ToolResponseSchemaDto(
          itemsKey: 'plans',
          totalKey: 'total',
          itemSchema: ToolItemSchemaDto(
            titleField: 'title',
            dateField: 'planned_date',
            navigation: ToolNavigationDto(
              route: '/trip-plans',
              idField: 'uuid',
            ),
          ),
        ),
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
  'get_my_trip_plans': 'getMyTripPlans',
  'my_trip_plans': 'getMyTripPlans',
  'myTripPlans': 'getMyTripPlans',
  'list_trip_plans': 'getMyTripPlans',
  'listTripPlans': 'getMyTripPlans',
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
    return parts.first +
        parts
            .skip(1)
            .map((p) =>
                p.isNotEmpty ? '${p[0].toUpperCase()}${p.substring(1)}' : '')
            .join();
  }

  return toolName;
}

/// Get schema with fallback to defaults
/// Handles both snake_case and camelCase tool names
ToolSchemaDto? getToolSchemaWithFallback(
  Map<String, ToolSchemaDto>? loadedSchemas,
  String toolName,
  AppLocalizations l10n,
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
  final defaults = defaultToolSchemas(l10n);
  return defaults[toolName] ?? defaults[normalizedName];
}

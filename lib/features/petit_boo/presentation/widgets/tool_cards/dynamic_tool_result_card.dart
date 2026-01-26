import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_schema_dto.dart';
import '../../providers/tool_schemas_provider.dart';
import 'action_confirmation_card.dart';
import 'booking_list_card.dart';
import 'brain_memory_card.dart';
import 'event_detail_card.dart';
import 'event_list_card.dart';
import 'favorite_lists_card.dart';
import 'generic_list_card.dart';
import 'profile_card.dart';
import 'trip_plan_card.dart';
import 'unknown_tool_card.dart';

/// Dynamic card that renders tool results based on schema from API
class DynamicToolResultCard extends ConsumerWidget {
  final String toolName;
  final Map<String, dynamic> data;

  const DynamicToolResultCard({
    super.key,
    required this.toolName,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemasAsync = ref.watch(toolSchemasProvider);

    return schemasAsync.when(
      data: (schemas) => _buildCard(schemas),
      loading: () => _LoadingCard(toolName: toolName),
      error: (_, __) => _buildCard({}), // Use fallback on error
    );
  }

  Widget _buildCard(Map<String, ToolSchemaDto> loadedSchemas) {
    // Get schema from API or fallback to defaults
    final schema = getToolSchemaWithFallback(loadedSchemas, toolName);

    if (schema == null) {
      return UnknownToolCard(toolName: toolName, data: data);
    }

    // Route to appropriate card based on display_type
    return switch (schema.displayType) {
      'event_list' => EventListCard(schema: schema, data: data),
      'booking_list' => BookingListCard(schema: schema, data: data),
      'event_detail' => EventDetailCard(schema: schema, data: data),
      'profile' => ProfileCard(schema: schema, data: data),
      'list' || 'stats' => GenericListCard(schema: schema, data: data),
      // Phase 7: New display types
      'brain_memory' => BrainMemoryCard(schema: schema, data: data),
      'trip_plan' => TripPlanCard(schema: schema, data: data),
      'action_confirmation' => ActionConfirmationCard(schema: schema, data: data),
      'favorite_lists' => FavoriteListsCard(schema: schema, data: data),
      _ => GenericListCard(schema: schema, data: data),
    };
  }
}

/// Loading placeholder while schemas are being fetched
class _LoadingCard extends StatelessWidget {
  final String toolName;

  const _LoadingCard({required this.toolName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: HbColors.brandPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Chargement...',
            style: TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to parse color from hex string
Color parseHexColor(String? hex, {Color fallback = HbColors.brandPrimary}) {
  if (hex == null || hex.isEmpty) return fallback;

  try {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  } catch (_) {
    return fallback;
  }
}

/// Helper to get icon from string name
IconData getIconFromName(String? iconName) {
  return switch (iconName) {
    'favorite' => Icons.favorite,
    'favorite_border' => Icons.favorite_border,
    'search' => Icons.search,
    'search_off' => Icons.search_off,
    'confirmation_number_outlined' => Icons.confirmation_number_outlined,
    'confirmation_number' => Icons.confirmation_number,
    'qr_code_2' => Icons.qr_code_2,
    'event' => Icons.event,
    'event_available' => Icons.event_available,
    'notifications' => Icons.notifications,
    'notifications_active' => Icons.notifications_active,
    'notifications_outlined' => Icons.notifications_outlined,
    'person' => Icons.person,
    'person_outline' => Icons.person_outline,
    'calendar_today' => Icons.calendar_today,
    'access_time' => Icons.access_time,
    'location_on' => Icons.location_on,
    'arrow_forward' => Icons.arrow_forward,
    'edit_outlined' => Icons.edit_outlined,
    'image' => Icons.image,
    // Phase 7: Brain, Favorites, Trip
    'psychology' => Icons.psychology,
    'family_restroom' => Icons.family_restroom,
    'thumb_up' => Icons.thumb_up,
    'block' => Icons.block,
    'route' => Icons.route,
    'folder_special' => Icons.folder_special,
    'drive_file_move' => Icons.drive_file_move,
    'check_circle' => Icons.check_circle,
    // List management
    'edit' => Icons.edit,
    'delete' => Icons.delete,
    'folder' => Icons.folder,
    'folder_outlined' => Icons.folder_outlined,
    'folder_off' => Icons.folder_off_outlined,
    'bookmark' => Icons.bookmark,
    'bookmark_border' => Icons.bookmark_border,
    _ => Icons.extension,
  };
}

/// Extract a nested field value from data using dot notation
/// e.g., 'user.first_name' or 'stats.total_bookings'
dynamic getNestedValue(Map<String, dynamic> data, String? fieldPath) {
  if (fieldPath == null || fieldPath.isEmpty) return null;

  final parts = fieldPath.split('.');
  dynamic current = data;

  for (final part in parts) {
    if (current is Map<String, dynamic> && current.containsKey(part)) {
      current = current[part];
    } else {
      return null;
    }
  }

  return current;
}

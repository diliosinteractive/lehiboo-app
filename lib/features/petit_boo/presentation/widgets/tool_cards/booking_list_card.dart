import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying a list of bookings or tickets
class BookingListCard extends StatelessWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const BookingListCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final responseSchema = schema.responseSchema;
    final itemsKey = responseSchema?.itemsKey ?? 'bookings';
    final totalKey = responseSchema?.totalKey ?? 'total';

    final items = _extractItems(data, itemsKey);
    final total = data[totalKey] as int? ?? items.length;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    final accentColor = parseHexColor(schema.color);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    getIconFromName(schema.icon),
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schema.title ?? schema.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$total élément${total != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: HbColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Booking items (show max 3)
          ...items.take(3).map(
                (item) => _BookingItem(
                  item: item,
                  schema: responseSchema?.itemSchema,
                ),
              ),

          // Show more button if needed
          if (items.length > 3)
            InkWell(
              onTap: () => _navigateToAll(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Voir les $total éléments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: HbColors.brandPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _extractItems(
    Map<String, dynamic> data,
    String itemsKey,
  ) {
    final items = data[itemsKey];
    if (items is List) {
      return items.cast<Map<String, dynamic>>();
    }
    return [];
  }

  void _navigateToAll(BuildContext context) {
    final route = switch (schema.name) {
      'getMyBookings' => '/my-bookings',
      'getMyTickets' => '/my-tickets',
      _ => '/my-bookings',
    };
    context.push(route);
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            getIconFromName(schema.icon),
            color: parseHexColor(schema.color).withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            schema.emptyMessage ?? 'Aucun élément',
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final ToolItemSchemaDto? schema;

  const _BookingItem({
    required this.item,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        _getValue(schema?.titleField, 'event_title') as String? ?? 'Sans titre';
    final imageUrl = _getValue(schema?.imageField, 'event_image') as String?;
    final date = _getValue(schema?.dateField, 'slot_date') as String?;
    final time = _getValue(schema?.timeField, 'slot_time') as String?;
    final status = _getValue(schema?.statusField, 'status') as String?;
    final ticketsCount = item['tickets_count'] as int? ?? 0;

    return InkWell(
      onTap: () => _navigate(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Event image or placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: HbColors.orangePastel,
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? const Icon(Icons.event, color: HbColors.brandPrimary)
                  : null,
            ),
            const SizedBox(width: 12),

            // Booking details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (date != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                      if (time != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                      if (ticketsCount > 0) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.person_outline,
                          size: 12,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$ticketsCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Status badge
            if (status != null) _StatusBadge(status: status),
          ],
        ),
      ),
    );
  }

  dynamic _getValue(String? schemaField, String defaultField) {
    return item[schemaField ?? defaultField] ?? item[defaultField];
  }

  void _navigate(BuildContext context) {
    final nav = schema?.navigation;
    if (nav != null) {
      final id = item[nav.idField];
      if (id != null) {
        final route = nav.route.replaceAll('{${nav.idField}}', id.toString());
        context.push(route);
      }
    } else {
      // Fallback
      final uuid = item['uuid'];
      if (uuid != null) {
        context.push('/booking/$uuid');
      }
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusStyle() {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'confirme':
      case 'confirmé':
        return (
          HbColors.success,
          HbColors.success.withOpacity(0.1),
          'Confirmé'
        );
      case 'pending':
      case 'en_attente':
        return (
          HbColors.warning,
          HbColors.warning.withOpacity(0.1),
          'En attente'
        );
      case 'cancelled':
      case 'annule':
      case 'annulé':
        return (HbColors.error, HbColors.error.withOpacity(0.1), 'Annulé');
      case 'used':
      case 'utilise':
      case 'utilisé':
        return (
          HbColors.textSecondary,
          Colors.grey.shade100,
          'Utilisé'
        );
      default:
        return (HbColors.textSecondary, Colors.grey.shade100, status);
    }
  }
}

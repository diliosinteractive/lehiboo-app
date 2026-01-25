import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Generic card for displaying any list-type tool result
/// Used for alerts, notifications, and other list-based tools
class GenericListCard extends StatelessWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const GenericListCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final responseSchema = schema.responseSchema;
    final itemsKey = responseSchema?.itemsKey ?? 'items';
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

          // Items (show max 3)
          ...items.take(3).map(
                (item) => _GenericItem(
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
    // Navigate based on tool name
    final route = switch (schema.name) {
      'getMyAlerts' => '/alerts',
      'getNotifications' => '/notifications',
      _ => null,
    };
    if (route != null) {
      context.push(route);
    }
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
          Expanded(
            child: Text(
              schema.emptyMessage ?? 'Aucun élément',
              style: const TextStyle(
                fontSize: 14,
                color: HbColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenericItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final ToolItemSchemaDto? schema;

  const _GenericItem({
    required this.item,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        _getValue(schema?.titleField, 'title') as String? ??
        _getValue(schema?.titleField, 'name') as String? ??
        'Sans titre';
    final subtitle =
        _getValue(schema?.subtitleField, 'body') as String? ??
        _getValue(schema?.subtitleField, 'description') as String?;
    final date = _getValue(schema?.dateField, 'created_at') as String?;
    final isActive = item['is_active'] == true;
    final isRead = item['is_read'] == true;

    return InkWell(
      onTap: () => _navigate(context),
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.white : HbColors.orangePastel.withOpacity(0.3),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4, right: 8),
                decoration: const BoxDecoration(
                  color: HbColors.brandPrimary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: HbColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (date != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: HbColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Active status for alerts
            if (item.containsKey('is_active'))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? HbColors.success.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isActive ? HbColors.success : HbColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  dynamic _getValue(String? schemaField, String defaultField) {
    if (schemaField != null) {
      return item[schemaField] ?? item[defaultField];
    }
    return item[defaultField];
  }

  void _navigate(BuildContext context) {
    final nav = schema?.navigation;
    if (nav != null) {
      final id = item[nav.idField];
      if (id != null) {
        final route = nav.route.replaceAll('{${nav.idField}}', id.toString());
        context.push(route);
      }
    }
  }
}

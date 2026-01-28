import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    // Debug: afficher la structure des données
    debugPrint('🎫 BookingListCard._extractItems: itemsKey=$itemsKey');
    debugPrint('🎫 BookingListCard._extractItems: data.keys=${data.keys.toList()}');

    // Essayer directement
    var items = data[itemsKey];

    // Si pas trouvé, essayer dans data['data'] (structure imbriquée)
    if (items == null && data['data'] is Map<String, dynamic>) {
      final nested = data['data'] as Map<String, dynamic>;
      debugPrint('🎫 BookingListCard._extractItems: nested.keys=${nested.keys.toList()}');
      items = nested[itemsKey];
    }

    // Si toujours pas trouvé, essayer data['data'] directement s'il est une liste
    if (items == null && data['data'] is List) {
      items = data['data'];
    }

    debugPrint('🎫 BookingListCard._extractItems: items is ${items?.runtimeType}, length=${items is List ? items.length : 'N/A'}');

    if (items is List) {
      try {
        return items.whereType<Map<String, dynamic>>().toList();
      } catch (e) {
        debugPrint('🎫 BookingListCard._extractItems: cast error: $e');
        return [];
      }
    }
    return [];
  }

  void _navigateToAll(BuildContext context) {
    // Note: getMyTickets utilise aussi /my-bookings car c'est la même page
    context.push('/my-bookings');
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
    try {
      return _buildContent(context);
    } catch (e, st) {
      debugPrint('🚨 _BookingItem.build ERROR: $e');
      debugPrint('🚨 _BookingItem.build item: $item');
      debugPrint('🚨 Stack: $st');
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('Erreur: $e', style: const TextStyle(color: Colors.red)),
      );
    }
  }

  Widget _buildContent(BuildContext context) {
    final title = _safeString(_getValue(schema?.titleField, 'event_title')) ?? 'Sans titre';
    final imageUrl = _safeString(_getValue(schema?.imageField, 'event_image'));
    final dateStr = _safeString(_getValue(schema?.dateField, 'slot_date'));
    final timeStr = _safeString(_getValue(schema?.timeField, 'slot_time'));
    final status = _safeString(_getValue(schema?.statusField, 'status'));
    final ticketsCount = _safeInt(item['tickets_count']) ?? _safeInt(item['quantity']) ?? 1;
    final totalPrice = _parsePrice(item['total_price'] ?? item['total_amount']);

    // Parse et format la date
    final formattedDate = _formatDate(dateStr);
    final formattedTime = _formatTime(timeStr);

    return InkWell(
      onTap: () => _navigate(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                _buildImage(imageUrl),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title + Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: HbColors.textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13,
                                  color: HbColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '$formattedDate${formattedTime.isNotEmpty ? ' • $formattedTime' : ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: HbColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Bottom: status, tickets, price
                        Row(
                          children: [
                            if (status != null) ...[
                              _StatusBadge(status: status),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              ticketsCount > 1 ? '$ticketsCount billets' : '1 billet',
                              style: TextStyle(
                                fontSize: 12,
                                color: HbColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (totalPrice > 0)
                              Text(
                                '${totalPrice.toStringAsFixed(0)}€',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: HbColors.brandPrimary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return SizedBox(
      width: 85,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => _buildPlaceholder(),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: HbColors.orangePastel,
      child: const Center(
        child: Icon(
          Icons.event,
          size: 28,
          color: HbColors.brandPrimary,
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Date non définie';

    try {
      DateTime date;
      // Essayer plusieurs formats
      if (dateStr.contains('T')) {
        date = DateTime.parse(dateStr);
      } else if (dateStr.contains('-')) {
        date = DateTime.parse(dateStr);
      } else {
        return dateStr;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (dateOnly == today) {
        return "Aujourd'hui";
      } else if (dateOnly == tomorrow) {
        return 'Demain';
      } else {
        return DateFormat('E d MMM yyyy', 'fr_FR').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return '';

    // Si c'est déjà au format HH:mm, le retourner
    if (RegExp(r'^\d{2}:\d{2}$').hasMatch(timeStr)) {
      return timeStr;
    }

    // Si c'est au format HH:mm:ss, prendre les 5 premiers caractères
    if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(timeStr)) {
      return timeStr.substring(0, 5);
    }

    return timeStr;
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0;
    return 0;
  }

  dynamic _getValue(String? schemaField, String defaultField) {
    return item[schemaField ?? defaultField] ?? item[defaultField];
  }

  /// Safely convert any value to String (handles int, double, etc.)
  String? _safeString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  /// Safely convert any value to int (handles String numbers)
  int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  void _navigate(BuildContext context) {
    final nav = schema?.navigation;
    debugPrint('🎫 _BookingItem._navigate: schema.navigation=$nav, item.keys=${item.keys.toList()}');

    if (nav != null) {
      final id = item[nav.idField];
      debugPrint('🎫 _BookingItem._navigate: idField=${nav.idField}, id=$id');
      if (id != null) {
        final route = nav.route.replaceAll('{${nav.idField}}', id.toString());
        debugPrint('🎫 _BookingItem._navigate: Navigating to $route');
        context.push(route);
      } else {
        debugPrint('🎫 _BookingItem._navigate: id is null, trying fallback');
        // Fallback: essayer uuid ou id
        final uuid = item['uuid'] ?? item['id'];
        if (uuid != null) {
          debugPrint('🎫 _BookingItem._navigate: Fallback navigating to /booking-detail/$uuid');
          context.push('/booking-detail/$uuid');
        }
      }
    } else {
      // Fallback
      final uuid = item['uuid'] ?? item['id'];
      if (uuid != null) {
        debugPrint('🎫 _BookingItem._navigate: No schema, navigating to /booking-detail/$uuid');
        context.push('/booking-detail/$uuid');
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

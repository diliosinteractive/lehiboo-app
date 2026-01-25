import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying details of a single event
class EventDetailCard extends StatelessWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const EventDetailCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final itemSchema = schema.responseSchema?.itemSchema;

    final title =
        _getValue(itemSchema?.titleField, 'title') as String? ?? 'Événement';
    final imageUrl = _getValue(itemSchema?.imageField, 'image_url') as String?;
    final description = data['description'] as String?;
    final isFavorite = data['is_favorite'] == true;
    final canBook = data['can_book'] != false;
    final category = data['category'] as String?;
    final tags = (data['tags'] as List?)?.cast<String>();

    // Venue info
    final venue = data['venue'] as Map<String, dynamic>?;
    final venueName = venue?['name'] as String?;
    final venueAddress = venue?['address'] as String?;
    final venueCity = venue?['city'] as String?;

    // Next slot
    final nextSlot = data['next_slot'] as Map<String, dynamic>?;
    final slotDate = nextSlot?['slot_date'] as String?;
    final startTime = nextSlot?['start_time'] as String?;

    // Ticket types
    final ticketTypes =
        (data['ticket_types'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final accentColor = parseHexColor(schema.color);

    return GestureDetector(
      onTap: () => _navigate(context, itemSchema),
      child: Container(
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
            // Image with favorite badge
            if (imageUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: HbColors.orangePastel,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: HbColors.orangePastel,
                          child: const Icon(
                            Icons.event,
                            size: 48,
                            color: HbColors.brandPrimary,
                          ),
                        ),
                      ),
                    ),
                    if (isFavorite)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: HbColors.error,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  if (category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: accentColor,
                        ),
                      ),
                    ),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: HbColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Location
                  if (venueName != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            [venueName, venueCity]
                                .where((e) => e != null)
                                .join(', '),
                            style: TextStyle(
                              fontSize: 13,
                              color: HbColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  // Date & Time
                  if (slotDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: HbColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            [slotDate, startTime]
                                .where((e) => e != null)
                                .join(' à '),
                            style: TextStyle(
                              fontSize: 13,
                              color: HbColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Description
                  if (description != null && description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: HbColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Tags
                  if (tags != null && tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: tags.take(4).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11,
                                color: HbColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Price info
                  if (ticketTypes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _PriceInfo(ticketTypes: ticketTypes),
                    ),

                  // Action button
                  if (canBook)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _navigate(context, itemSchema),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Voir les disponibilités',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _getValue(String? schemaField, String defaultField) {
    if (schemaField != null && schemaField.contains('.')) {
      return getNestedValue(data, schemaField);
    }
    return data[schemaField ?? defaultField] ?? data[defaultField];
  }

  void _navigate(BuildContext context, ToolItemSchemaDto? itemSchema) {
    final nav = itemSchema?.navigation;
    if (nav != null) {
      final id = data[nav.idField];
      if (id != null) {
        final route = nav.route.replaceAll('{${nav.idField}}', id.toString());
        context.push(route);
      }
    } else {
      // Fallback
      final slug = data['slug'];
      if (slug != null) {
        context.push('/event/$slug');
      }
    }
  }
}

class _PriceInfo extends StatelessWidget {
  final List<Map<String, dynamic>> ticketTypes;

  const _PriceInfo({required this.ticketTypes});

  @override
  Widget build(BuildContext context) {
    final prices = ticketTypes
        .map((t) => t['price'] as num?)
        .where((p) => p != null)
        .toList();

    if (prices.isEmpty) return const SizedBox.shrink();

    final minPrice = prices.reduce((a, b) => a! < b! ? a : b)!;
    final hasMultiple = ticketTypes.length > 1;

    return Row(
      children: [
        Text(
          hasMultiple ? 'À partir de ' : '',
          style: TextStyle(
            fontSize: 13,
            color: HbColors.textSecondary,
          ),
        ),
        Text(
          minPrice == 0 ? 'Gratuit' : '${minPrice.toStringAsFixed(0)}€',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HbColors.brandPrimary,
          ),
        ),
        if (hasMultiple && minPrice > 0)
          Text(
            ' • ${ticketTypes.length} tarifs',
            style: TextStyle(
              fontSize: 13,
              color: HbColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

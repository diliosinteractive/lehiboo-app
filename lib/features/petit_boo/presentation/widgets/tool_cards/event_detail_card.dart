import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/l10n/l10n.dart';
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
    final l10n = context.l10n;
    final itemSchema = schema.responseSchema?.itemSchema;
    final eventData = _unwrapData(data);

    final title = _getStringValue(eventData, [
      itemSchema?.titleField,
      'title',
      'name',
      'event_title',
    ]);
    final imageUrl = _getStringValue(eventData, [
      itemSchema?.imageField,
      'image_url',
      'cover_image',
      'featured_image',
      'image',
    ]);
    final description = _getStringValue(eventData, ['description']);
    final isFavorite = _getBoolValue(eventData, ['is_favorite']) ?? false;
    final category = _getStringValue(eventData, ['category', 'category_name']);
    final tags = _getStringList(eventData['tags']);

    // Venue info
    final venue = _asStringKeyedMap(eventData['venue']);
    final venueName = _getStringValue(venue ?? eventData, [
      'name',
      'venue_name',
    ]);
    final venueCity = _getStringValue(venue ?? eventData, [
      'city',
      'venue_city',
      'city_name',
    ]);

    // Next slot
    final nextSlot = _asStringKeyedMap(eventData['next_slot']);
    final slotDate = _getStringValue(nextSlot ?? eventData, [
      'slot_date',
      'date',
      'next_slot_date',
      'start_date',
      'start_datetime',
    ]);
    final startTime = _getStringValue(nextSlot ?? eventData, [
      'start_time',
      'time',
      'next_slot_time',
    ]);

    // Ticket types
    final ticketTypes = _getMapList(eventData['ticket_types']);
    final slug = _getStringValue(eventData, ['slug']);
    final canBook = (_getBoolValue(eventData, [
              'can_book',
              'can_accept_bookings',
            ]) ??
            true) &&
        slug != null;
    final hasRenderableEvent = title != null ||
        slug != null ||
        imageUrl != null ||
        description != null ||
        venueName != null;

    if (!hasRenderableEvent) {
      return const SizedBox.shrink();
    }

    final accentColor = parseHexColor(schema.color);

    return GestureDetector(
      onTap: canBook ? () => _navigate(context, itemSchema, eventData) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                        color: accentColor.withValues(alpha: 0.1),
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
                    title ?? l10n.petitBooToolEventFallbackTitle,
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
                            style: const TextStyle(
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
                            startTime != null
                                ? l10n.petitBooEventDateTime(
                                    slotDate,
                                    startTime,
                                  )
                                : slotDate,
                            style: const TextStyle(
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
                        style: const TextStyle(
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
                              style: const TextStyle(
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
                          onPressed: () =>
                              _navigate(context, itemSchema, eventData),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.petitBooEventAvailabilityAction,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
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

  Map<String, dynamic> _unwrapData(Map<String, dynamic> source) {
    final nested = source['data'];
    if (nested is Map<String, dynamic>) return nested;
    if (nested is Map) return Map<String, dynamic>.from(nested);
    return source;
  }

  String? _getStringValue(
    Map<String, dynamic> source,
    List<String?> fields,
  ) {
    for (final field in fields.whereType<String>()) {
      final value = field.contains('.')
          ? getNestedValue(source, field)
          : source[field] ?? getNestedValue(source, field);
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return null;
  }

  bool? _getBoolValue(Map<String, dynamic> source, List<String> fields) {
    for (final field in fields) {
      final value = source[field];
      if (value is bool) return value;
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true') return true;
        if (normalized == 'false') return false;
      }
    }
    return null;
  }

  List<String>? _getStringList(dynamic value) {
    if (value is! List) return null;
    final values = value.map((item) => item.toString()).toList();
    return values.isEmpty ? null : values;
  }

  List<Map<String, dynamic>> _getMapList(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  void _navigate(
    BuildContext context,
    ToolItemSchemaDto? itemSchema,
    Map<String, dynamic> eventData,
  ) {
    final nav = itemSchema?.navigation;
    if (nav != null) {
      final id = eventData[nav.idField];
      if (id != null) {
        final route = nav.route.replaceAll('{${nav.idField}}', id.toString());
        context.push(route);
      }
    } else {
      // Fallback
      final slug = eventData['slug'];
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
    final l10n = context.l10n;
    final prices = ticketTypes
        .map((t) => t['price'] as num?)
        .where((p) => p != null)
        .toList();

    if (prices.isEmpty) return const SizedBox.shrink();

    final minPrice = prices.reduce((a, b) => a! < b! ? a : b)!;
    final hasMultiple = ticketTypes.length > 1;

    return Row(
      children: [
        if (hasMultiple)
          Text(
            '${l10n.petitBooEventPriceFrom} ',
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.textSecondary,
            ),
          ),
        Text(
          minPrice == 0 ? l10n.commonFree : '${minPrice.toStringAsFixed(0)}€',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HbColors.brandPrimary,
          ),
        ),
        if (hasMultiple && minPrice > 0)
          Text(
            ' • ${l10n.petitBooEventPriceTiers(ticketTypes.length)}',
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

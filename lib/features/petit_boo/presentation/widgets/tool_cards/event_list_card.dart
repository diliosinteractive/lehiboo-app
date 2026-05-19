import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../domain/entities/activity.dart';
import '../../../../../domain/entities/city.dart';
import '../../../../../domain/entities/partner.dart';
import '../../../../../domain/entities/taxonomy.dart';
import '../../../../home/presentation/widgets/event_card.dart' as home;
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying a horizontal list of events (favorites, search results)
class EventListCard extends StatelessWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const EventListCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responseSchema = schema.responseSchema;
    final itemsKey = responseSchema?.itemsKey ?? 'events';
    final totalKey = responseSchema?.totalKey ?? 'total';

    // Handle nested data wrapper from backend
    final actualData = _unwrapData(data);
    final items = _extractItems(actualData, itemsKey);
    final total = actualData[totalKey] as int? ?? items.length;

    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    final accentColor = parseHexColor(schema.color);

    return Container(
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
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
                        l10n.petitBooToolEventCount(total),
                        style: const TextStyle(
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

          // Horizontal scroll of events
          SizedBox(
            height: 360,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.take(5).length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < items.length - 1 ? 12 : 0,
                  ),
                  child: _EventItemCard(
                    item: item,
                    isFavoriteList: schema.name == 'getMyFavorites',
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Show more button
          if (total > 5)
            InkWell(
              onTap: () => _navigateToAll(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.petitBooToolViewEvents(total),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
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

  /// Unwrap nested data if present
  Map<String, dynamic> _unwrapData(Map<String, dynamic> data) {
    // Handle: { "success": true, "data": { ... } }
    if (data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return data;
  }

  /// Extract items list from data
  List<Map<String, dynamic>> _extractItems(
    Map<String, dynamic> data,
    String itemsKey,
  ) {
    // Try primary key
    var items = data[itemsKey];

    // Fallback to 'events' if favorites is missing
    if (items == null && itemsKey == 'favorites') {
      items = data['events'];
    }

    if (items is List) {
      return items.cast<Map<String, dynamic>>();
    }
    return [];
  }

  void _navigateToAll(BuildContext context) {
    // Navigate based on tool name
    final route = switch (schema.name) {
      'getMyFavorites' => '/favorites',
      'searchEvents' => '/explore',
      _ => '/explore',
    };
    context.go(route);
  }

  Widget _buildEmptyState(BuildContext context) {
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
            color: parseHexColor(schema.color).withValues(alpha: 0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              schema.emptyMessage ?? context.l10n.petitBooToolEmptyListFallback,
              style: const TextStyle(
                fontSize: 14,
                color: HbColors.textSecondary,
              ),
            ),
          ),
          if (schema.name == 'getMyFavorites')
            TextButton(
              onPressed: () => context.go('/explore'),
              child: Text(context.l10n.navExplore),
            ),
        ],
      ),
    );
  }
}

class _EventItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isFavoriteList;

  const _EventItemCard({
    required this.item,
    this.isFavoriteList = false,
  });

  @override
  Widget build(BuildContext context) {
    final activity = _toActivity(context);

    return SizedBox(
      width: 200,
      child: home.EventCard(
        activity: activity,
        heroTagPrefix: 'petit_boo',
        isCompact: true,
        forceFavoriteFilled: isFavoriteList || item['is_favorite'] == true,
        forcePrivateBadge: item['is_members_only'] == true,
      ),
    );
  }

  Activity _toActivity(BuildContext context) {
    final slug = _getStringValue(['slug']);
    final id = _getStringValue([
          'uuid',
          'event_uuid',
          'id',
        ]) ??
        slug ??
        item.hashCode.toString();
    final title =
        _getStringValue(['title']) ?? context.l10n.petitBooToolUntitled;
    final imageUrl = _getStringValue([
      'cover_image',
      'image_url',
      'image',
      'thumbnail',
    ]);
    final priceMin = _getPriceMin();
    final priceMax = _getPriceMax();
    final isFree = _getIsFree(priceMin, priceMax);

    return Activity(
      id: id,
      title: title,
      slug: slug ?? id,
      description: _getStringValue(['description']) ?? '',
      imageUrl: imageUrl,
      category: _getCategory(),
      isFree: isFree,
      priceMin: priceMin,
      priceMax: priceMax,
      currency: 'EUR',
      city: _getCity(),
      partner: _getPartner(),
      reservationMode:
          isFree ? ReservationMode.lehibooFree : ReservationMode.lehibooPaid,
      nextSlot: _getSlot(id),
    );
  }

  Category? _getCategory() {
    final raw = item['category'];
    if (raw is Map<String, dynamic>) {
      final name = _mapString(raw, ['name', 'title', 'label']);
      final slug = _mapString(raw, ['slug']) ?? _slugify(name);
      if (name != null && slug != null) {
        return Category(
          id: _mapString(raw, ['uuid', 'id']) ?? slug,
          slug: slug,
          name: name,
        );
      }
    }

    final name = _getStringValue(['category_name', 'category']);
    final slug = _getStringValue(['category_slug']) ?? _slugify(name);
    if (name == null || slug == null) return null;
    return Category(id: slug, slug: slug, name: name);
  }

  City? _getCity() {
    final raw = item['city'];
    if (raw is Map<String, dynamic>) {
      final name = _mapString(raw, ['name', 'city_name']);
      if (name == null) return null;
      final slug = _mapString(raw, ['slug']) ?? _slugify(name) ?? name;
      return City(
        id: _mapString(raw, ['uuid', 'id']) ?? slug,
        name: name,
        slug: slug,
        region: _mapString(raw, ['region']),
      );
    }

    final name = _getStringValue([
      'city_name',
      'city',
      'location',
      'venue_city',
      'venue_name',
    ]);
    if (name == null) return null;
    final slug = _getStringValue(['city_slug']) ?? _slugify(name) ?? name;
    return City(id: slug, name: name, slug: slug);
  }

  Partner? _getPartner() {
    final raw = item['organizer'] ?? item['partner'] ?? item['organization'];
    if (raw is Map<String, dynamic>) {
      final name =
          _mapString(raw, ['name', 'display_name', 'organization_name']);
      if (name == null) return null;
      return Partner(
        id: _mapString(raw, ['uuid', 'id', 'slug']) ?? name,
        name: name,
        logoUrl: _mapString(raw, ['logo_url', 'logo', 'avatar']),
        verified: raw['verified'] == true,
      );
    }

    final name = _getStringValue([
      'organizer_name',
      'partner_name',
      'organization_name',
      'vendor_name',
      'original_organizer_name',
    ]);
    if (name == null) return null;
    return Partner(id: _slugify(name) ?? name, name: name);
  }

  Slot? _getSlot(String activityId) {
    final start = _getStartDateTime();
    if (start == null) return null;

    final rawSlot = item['next_slot'];
    final slotId = rawSlot is Map<String, dynamic>
        ? _mapString(rawSlot, ['uuid', 'id'])
        : null;
    final end = _getEndDateTime() ?? start.add(const Duration(hours: 2));

    return Slot(
      id: slotId ?? '${activityId}_next',
      activityId: activityId,
      startDateTime: start,
      endDateTime: end,
      priceMin: _getPriceMin(),
      priceMax: _getPriceMax(),
    );
  }

  DateTime? _getStartDateTime() {
    final rawSlot = item['next_slot'];
    if (rawSlot is Map<String, dynamic>) {
      return _parseDateTime(
        _mapString(rawSlot, [
          'start_datetime',
          'start_date_time',
          'starts_at',
          'date',
          'slot_date',
        ]),
        _mapString(rawSlot, ['start_time', 'time']),
      );
    }

    return _parseDateTime(
      _getStringValue([
        'start_datetime',
        'start_date_time',
        'date',
        'next_slot_date',
        'start_date'
      ]),
      _getStringValue(['time', 'next_slot_time', 'start_time']),
    );
  }

  DateTime? _getEndDateTime() {
    final rawSlot = item['next_slot'];
    if (rawSlot is Map<String, dynamic>) {
      return _parseDateTime(
        _mapString(rawSlot, [
          'end_datetime',
          'end_date_time',
          'ends_at',
          'end_date',
        ]),
        _mapString(rawSlot, ['end_time']),
      );
    }

    return _parseDateTime(
      _getStringValue(['end_datetime', 'end_date_time', 'end_date']),
      _getStringValue(['end_time']),
    );
  }

  DateTime? _parseDateTime(String? date, String? time) {
    if (date == null || date.isEmpty) return null;
    final value = time != null && !date.contains('T') ? '${date}T$time' : date;
    return DateTime.tryParse(value);
  }

  double? _getPriceMin() {
    return _readPrice([
          'price_min',
          'price_from',
          'min_price',
          'price',
        ]) ??
        _readPriceFromDisplay(first: true);
  }

  double? _getPriceMax() {
    return _readPrice(['price_max', 'max_price']) ??
        _readPriceFromDisplay(first: false);
  }

  bool _getIsFree(double? priceMin, double? priceMax) {
    if (item['is_free'] == true) return true;

    final display = _getStringValue(['price_display'])?.toLowerCase();
    if (display != null &&
        (display.contains('gratuit') || display.contains('free'))) {
      return true;
    }

    return priceMin == 0 && (priceMax == null || priceMax == 0);
  }

  double? _readPrice(List<String> keys) {
    for (final key in keys) {
      final value = item[key];
      final price = _asDouble(value);
      if (price != null) return price;
    }
    return null;
  }

  double? _readPriceFromDisplay({required bool first}) {
    final display = _getStringValue(['price_display']);
    if (display == null) return null;

    final matches = RegExp(r'\d+(?:[,.]\d+)?')
        .allMatches(display)
        .map((m) => double.tryParse(m.group(0)!.replaceAll(',', '.')))
        .whereType<double>()
        .toList();
    if (matches.isEmpty) return null;
    return first ? matches.first : matches.last;
  }

  double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.'));
    }
    return null;
  }

  String? _getStringValue(List<String> keys) {
    for (final key in keys) {
      final value = item[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return null;
  }

  String? _mapString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return null;
  }

  String? _slugify(String? value) {
    if (value == null || value.isEmpty) return null;
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}

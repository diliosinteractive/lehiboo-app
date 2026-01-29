import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/themes/colors.dart';
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
                        '$total événement${total != 1 ? 's' : ''}',
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

          // Horizontal scroll of events
          SizedBox(
            height: 250,
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
                    schema: responseSchema?.itemSchema,
                    accentColor: accentColor,
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
                      'Voir les $total événements',
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
          if (schema.name == 'getMyFavorites')
            TextButton(
              onPressed: () => context.go('/explore'),
              child: const Text('Explorer'),
            ),
        ],
      ),
    );
  }
}

class _EventItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final ToolItemSchemaDto? schema;
  final Color accentColor;
  final bool isFavoriteList;

  const _EventItemCard({
    required this.item,
    required this.schema,
    required this.accentColor,
    this.isFavoriteList = false,
  });

  @override
  Widget build(BuildContext context) {
    // Extract fields with multiple fallbacks for different backend formats
    final title = _getStringValue(['title']) ?? 'Sans titre';
    final imageUrl = _getStringValue([
      'cover_image',
      'image_url',
      'image',
      'thumbnail',
    ]);
    final category = _getStringValue(['category', 'category_name']);
    final city = _getStringValue(['city', 'city_name', 'venue_name', 'location']);
    final date = _getStringValue(['date', 'next_slot_date', 'start_date']);
    final time = _getStringValue(['time', 'next_slot_time', 'start_time']);

    // Price handling
    final isFree = item['is_free'] == true;
    final priceFrom = item['price_from'] ?? item['price_min'] ?? item['price'];
    final priceDisplay = _getStringValue(['price_display']);

    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with category badge and favorite heart
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: _buildImage(imageUrl),
                  ),
                ),

                // Category badge
                if (category != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Favorite heart for favorites list
                if (isFavoriteList)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: HbColors.error,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: HbColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // City
                    if (city != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: HbColors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              city,
                              style: TextStyle(
                                fontSize: 11,
                                color: HbColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    const Spacer(),

                    // Date
                    if (date != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 11,
                            color: HbColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              time != null ? '$date • $time' : date,
                              style: TextStyle(
                                fontSize: 11,
                                color: HbColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),

                    // Price
                    _buildPrice(isFree, priceFrom, priceDisplay),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          color: HbColors.orangePastel,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: HbColors.brandPrimary,
              ),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => _buildFallbackImage(),
      );
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      color: HbColors.brandPrimary,
      child: Center(
        child: Image.asset(
          'assets/images/logo_picto_lehiboo.png',
          width: 40,
          height: 40,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.event,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildPrice(bool isFree, dynamic priceFrom, String? priceDisplay) {
    if (isFree) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: HbColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Gratuit',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: HbColors.success,
          ),
        ),
      );
    }

    if (priceDisplay != null) {
      return Text(
        priceDisplay,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: HbColors.brandPrimary,
        ),
      );
    }

    if (priceFrom != null) {
      final price = priceFrom is num ? priceFrom : num.tryParse(priceFrom.toString());
      if (price != null && price > 0) {
        return Text(
          'Dès ${price.toStringAsFixed(0)}€',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: HbColors.brandPrimary,
          ),
        );
      }
    }

    return const SizedBox.shrink();
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

  Color _getCategoryColor(String category) {
    final slug = category.toLowerCase();
    return switch (slug) {
      'atelier' || 'ateliers' => Colors.purple,
      'concert' || 'concerts' || 'musique' => Colors.blue,
      'spectacle' || 'spectacles' || 'theatre' || 'théâtre' => Colors.red,
      'sport' || 'sports' => Colors.green,
      'marche' || 'marchés' || 'marché' => Colors.orange,
      'culture' || 'expo' || 'exposition' => Colors.indigo,
      'famille' || 'enfants' => Colors.pink,
      'gastronomie' || 'food' => Colors.amber.shade700,
      _ => HbColors.brandPrimary,
    };
  }

  void _navigate(BuildContext context) {
    final nav = schema?.navigation;
    if (nav != null) {
      final id = item[nav.idField];
      if (id != null) {
        final route = nav.route.replaceAll('{${nav.idField}}', id.toString());
        if (nav.useGo) {
          context.go(route);
        } else {
          context.push(route);
        }
        return;
      }
    }

    // Fallback: try slug or uuid
    final slug = item['slug'] ?? item['uuid'];
    if (slug != null) {
      context.push('/event/$slug');
    }
  }
}

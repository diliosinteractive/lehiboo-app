/// Curated city surfaced on the home "Villes populaires" section.
///
/// Backed by `GET /v1/cities?featured_only=1&only_with_upcoming_slots=1`.
/// `slug` is authoritative — it comes from the server and is the one used
/// for `/city/:slug` navigation. Never derive it from `name`.
class PopularCity {
  final String uuid;
  final String name;
  final String slug;
  final String? region;
  final String? department;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;
  final int eventsCount;
  final bool isFeatured;

  const PopularCity({
    required this.uuid,
    required this.name,
    required this.slug,
    required this.eventsCount,
    required this.isFeatured,
    this.region,
    this.department,
    this.imageUrl,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
  });
}

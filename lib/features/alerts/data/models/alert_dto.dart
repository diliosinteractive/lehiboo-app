import '../../domain/entities/alert.dart';
import '../../../search/domain/models/event_filter.dart';

class AlertDto {
  final String id;
  final String name;
  final String createdAt;
  final bool enablePushAlert;
  final bool enableEmailAlert;
  
  // Search Criteria Fields
  final String? searchQuery;
  final String? citySlug;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final String? dateType;
  final String? startDate;
  final String? endDate;
  final String? priceType;
  final double? priceMin;
  final double? priceMax;
  final List<String>? categories;
  final List<String>? tags;
  final List<String>? thematiques; // In case backend distinguished them
  final bool? isFamilyFriendly;
  final bool? isAccessiblePmr;
  final bool? isOnline;

  AlertDto({
    required this.id,
    required this.name,
    required this.createdAt,
    this.enablePushAlert = false,
    this.enableEmailAlert = false,
    this.searchQuery,
    this.citySlug,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.dateType,
    this.startDate,
    this.endDate,
    this.priceType,
    this.priceMin,
    this.priceMax,
    this.categories,
    this.tags,
    this.thematiques,
    this.isFamilyFriendly,
    this.isAccessiblePmr,
    this.isOnline,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) {
    // Extract nested search criteria
    final criteria = json['search_criteria'] as Map<String, dynamic>? ?? {};

    return AlertDto(
      id: json['id'].toString(), // Handle int or string
      name: json['name'] as String? ?? 'Alerte sans nom',
      createdAt: json['created_at'] as String,
      enablePushAlert: json['enable_push_alert'] as bool? ?? false,
      enableEmailAlert: json['enable_email_alert'] as bool? ?? false,
      
      // Fields from inside search_criteria
      searchQuery: criteria['search_query'] as String?,
      citySlug: criteria['city_slug'] as String?,
      latitude: (criteria['latitude'] as num?)?.toDouble(),
      longitude: (criteria['longitude'] as num?)?.toDouble(),
      radiusKm: (criteria['radius_km'] as num?)?.toDouble(),
      
      dateType: criteria['date_type'] as String?,
      startDate: criteria['start_date'] as String?,
      endDate: criteria['end_date'] as String?,
      
      priceType: criteria['price_type'] as String?,
      priceMin: (criteria['price_min'] as num?)?.toDouble(),
      priceMax: (criteria['price_max'] as num?)?.toDouble(),
      
      categories: (criteria['categories'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      tags: (criteria['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      thematiques: (criteria['thematiques'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      
      isFamilyFriendly: criteria['is_family_friendly'] as bool?,
      isAccessiblePmr: criteria['is_accessible_pmr'] as bool?,
      isOnline: criteria['is_online'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'enable_push_alert': enablePushAlert,
      'enable_email_alert': enableEmailAlert,
      'search_query': searchQuery,
      'city_slug': citySlug,
      'latitude': latitude,
      'longitude': longitude,
      'radius_km': radiusKm,
      'date_type': dateType,
      'start_date': startDate,
      'end_date': endDate,
      'price_type': priceType,
      'price_min': priceMin,
      'price_max': priceMax,
      'categories': categories,
      'tags': tags,
      'thematiques': thematiques,
      'is_family_friendly': isFamilyFriendly,
      'is_accessible_pmr': isAccessiblePmr,
      'is_online': isOnline,
    };
  }

  /// Convert to Domain Entity
  Alert toEntity() {
    // Map DateType string to Enum
    DateFilterType? mappedDateType;
    if (dateType != null) {
      switch (dateType) {
        case 'today': mappedDateType = DateFilterType.today; break;
        case 'tomorrow': mappedDateType = DateFilterType.tomorrow; break;
        case 'this_week': mappedDateType = DateFilterType.thisWeek; break;
        case 'this_weekend': mappedDateType = DateFilterType.thisWeekend; break;
        case 'this_month': mappedDateType = DateFilterType.thisMonth; break;
        case 'custom': mappedDateType = DateFilterType.custom; break;
      }
    }

    // Map PriceType string to Enum
    PriceFilterType? mappedPriceType;
    if (priceType != null) {
      switch (priceType) {
        case 'free': mappedPriceType = PriceFilterType.free; break;
        case 'paid': mappedPriceType = PriceFilterType.paid; break;
        case 'range': mappedPriceType = PriceFilterType.range; break;
      }
    }

    // Reconstruct EventFilter
    final filter = EventFilter(
      searchQuery: searchQuery ?? '',
      citySlug: citySlug,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm ?? 50,
      
      dateFilterType: mappedDateType,
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      endDate: endDate != null ? DateTime.tryParse(endDate!) : null,
      
      priceFilterType: mappedPriceType,
      priceMin: priceMin ?? 0,
      priceMax: priceMax ?? 500,
      onlyFree: priceType == 'free',
      
      categoriesSlugs: categories ?? [],
      thematiquesSlugs: thematiques ?? [],
      tagsSlugs: tags ?? [],
      
      familyFriendly: isFamilyFriendly ?? false,
      accessiblePMR: isAccessiblePmr ?? false,
      onlineOnly: isOnline ?? false,
    );

    return Alert(
      id: id,
      name: name,
      filter: filter,
      enablePush: enablePushAlert,
      enableEmail: enableEmailAlert,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}

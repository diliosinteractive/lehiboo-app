import 'package:equatable/equatable.dart';
import 'package:lehiboo/core/l10n/l10n.dart';

// --- Sub-models for Event ---

class Ticket extends Equatable {
  final String id;
  final String name;
  final double price;
  final double? allInclusivePrice;
  final double? platformFee;
  final String? description;
  final int? quantity;
  final int? minPerBooking;
  final int? maxPerBooking;
  final int? remainingPlaces;
  final bool isAvailable;
  final bool isSoldOut;

  const Ticket({
    required this.id,
    required this.name,
    required this.price,
    this.allInclusivePrice,
    this.platformFee,
    this.description,
    this.quantity,
    this.minPerBooking,
    this.maxPerBooking,
    this.remainingPlaces,
    this.isAvailable = true,
    this.isSoldOut = false,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    final buyerPricingRaw = json['buyer_pricing'];
    final buyerPricing = buyerPricingRaw is Map
        ? Map<String, dynamic>.from(buyerPricingRaw)
        : const <String, dynamic>{};
    final remainingPlaces = _parseOptionalInt(
      json['places'] ??
          json['remaining_places'] ??
          json['remainingPlaces'] ??
          json['quantity_remaining'] ??
          json['quantityRemaining'] ??
          json['quota_remaining'] ??
          json['quotaRemaining'] ??
          json['available_quantity'] ??
          json['availableQuantity'],
    );
    final explicitSoldOut = _parseOptionalBool(
      json['is_sold_out'] ?? json['isSoldOut'],
    );
    final isSoldOut =
        explicitSoldOut ?? (remainingPlaces != null && remainingPlaces <= 0);
    final isAvailable = _parseOptionalBool(
          json['is_available'] ?? json['isAvailable'],
        ) ??
        !isSoldOut;

    return Ticket(
      id: json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _parseOptionalDouble(json['price']) ?? 0,
      allInclusivePrice: _parseOptionalDouble(json['all_inclusive_price']) ??
          _parseOptionalDouble(json['allInclusivePrice']) ??
          _parseOptionalDouble(buyerPricing['all_inclusive_price']),
      platformFee: _parseOptionalDouble(json['platform_fee']) ??
          _parseOptionalDouble(json['platformFee']) ??
          _parseOptionalDouble(buyerPricing['platform_fee']),
      description: json['description']?.toString(),
      quantity: _parseOptionalInt(json['quantity']),
      minPerBooking: _parseOptionalInt(
        json['min_per_order'] ??
            json['minPerOrder'] ??
            json['min_per_booking'] ??
            json['minPerBooking'],
      ),
      maxPerBooking: _parseOptionalInt(
        json['max_per_order'] ??
            json['maxPerOrder'] ??
            json['max_per_booking'] ??
            json['maxPerBooking'],
      ),
      remainingPlaces: remainingPlaces,
      isAvailable: isAvailable,
      isSoldOut: isSoldOut,
    );
  }

  double get buyerPrice => allInclusivePrice ?? price;

  /// The smallest valid non-zero selection.
  ///
  /// API values below one are invalid for a ticket purchase and are normalized
  /// to one so the UI never emits a non-positive booking quantity.
  int get effectiveMinPerBooking {
    final minimum = minPerBooking ?? 1;
    return minimum < 1 ? 1 : minimum;
  }

  /// The largest quantity the customer can currently select.
  ///
  /// The per-order limit and remaining stock are both authoritative caps.
  /// Negative values are treated as zero rather than being allowed through.
  int get effectiveMaxPerBooking {
    final orderMaximum = maxPerBooking ?? 10;
    final normalizedOrderMaximum = orderMaximum < 0 ? 0 : orderMaximum;
    final remaining = remainingPlaces;
    if (remaining == null) return normalizedOrderMaximum;

    final normalizedRemaining = remaining < 0 ? 0 : remaining;
    return normalizedRemaining < normalizedOrderMaximum
        ? normalizedRemaining
        : normalizedOrderMaximum;
  }

  bool get hasValidBookingLimits =>
      effectiveMinPerBooking <= effectiveMaxPerBooking;

  bool get isBookable =>
      isAvailable &&
      !isSoldOut &&
      (remainingPlaces == null || remainingPlaces! > 0) &&
      hasValidBookingLimits;

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        allInclusivePrice,
        platformFee,
        description,
        quantity,
        minPerBooking,
        maxPerBooking,
        remainingPlaces,
        isAvailable,
        isSoldOut,
      ];

  static int? _parseOptionalInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static double? _parseOptionalDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim().replaceAll(',', '.'));
  }

  static bool? _parseOptionalBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;

    return switch (value.toString().trim().toLowerCase()) {
      '1' || 'true' || 'yes' || 'on' => true,
      '0' || 'false' || 'no' || 'off' || '' => false,
      _ => null,
    };
  }
}

class TimeSlotConfig extends Equatable {
  final String calendarType;
  final List<String> schedules;
  final Map<String, List<String>>? weeklySlots;

  const TimeSlotConfig({
    required this.calendarType,
    this.schedules = const [],
    this.weeklySlots,
  });

  factory TimeSlotConfig.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? weeklySlotsMap;
    final weeklySlotsRaw = json['weekly_slots'];

    // Explicitly handle Map vs List (empty list [] returned by PHP for empty associative array)
    if (weeklySlotsRaw is Map) {
      weeklySlotsMap = weeklySlotsRaw.map(
        (key, value) => MapEntry(
            key.toString(), (value as List).map((e) => e.toString()).toList()),
      );
    }

    return TimeSlotConfig(
      calendarType: json['calendar_type'] ?? 'auto',
      schedules:
          (json['schedules'] as List?)?.map((e) => e.toString()).toList() ?? [],
      weeklySlots: weeklySlotsMap,
    );
  }

  @override
  List<Object?> get props => [calendarType, schedules, weeklySlots];
}

/// Represents a single bookable date/time slot
class CalendarDateSlot extends Equatable {
  final String id;
  final DateTime date;
  final String? startTime;
  final String? endTime;
  final int? spotsRemaining;
  final int? totalCapacity;

  const CalendarDateSlot({
    required this.id,
    required this.date,
    this.startTime,
    this.endTime,
    this.spotsRemaining,
    this.totalCapacity,
  });

  factory CalendarDateSlot.fromJson(Map<String, dynamic> json) {
    DateTime? date;
    final dateStr = json['date']?.toString();
    if (dateStr != null) {
      date = _parseDate(dateStr);
    }

    return CalendarDateSlot(
      id: json['id']?.toString() ?? '',
      date: date ?? DateTime.now(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      spotsRemaining:
          json['spots_remaining'] is int ? json['spots_remaining'] : null,
      totalCapacity:
          json['total_capacity'] is int ? json['total_capacity'] : null,
    );
  }

  /// Parse a date string in various formats (dd-MM-yyyy, yyyy-MM-dd, etc.)
  static DateTime? _parseDate(String dateStr) {
    // Try standard ISO format first
    var result = DateTime.tryParse(dateStr);
    if (result != null) return result;

    // Try dd-MM-yyyy format
    final parts = dateStr.split('-');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        try {
          return DateTime(year, month, day);
        } catch (_) {}
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [id, date, startTime, endTime, spotsRemaining];
}

class CalendarConfig extends Equatable {
  final String type;
  final List<CalendarDateSlot> dateSlots;
  final List<DateTime> disabledDates;

  const CalendarConfig({
    required this.type,
    this.dateSlots = const [],
    this.disabledDates = const [],
  });

  factory CalendarConfig.fromJson(Map<String, dynamic> json) {
    return CalendarConfig(
      type: json['type']?.toString() ?? 'auto',
      dateSlots: _parseDateSlotList(json['dates']),
      disabledDates: _parseDateList(json['disabled_dates']),
    );
  }

  /// Parse a list of date slot objects
  static List<CalendarDateSlot> _parseDateSlotList(dynamic value) {
    if (value == null || value is! List) return [];
    return value
        .map((e) {
          if (e is Map<String, dynamic>) {
            return CalendarDateSlot.fromJson(e);
          } else if (e is Map) {
            return CalendarDateSlot.fromJson(Map<String, dynamic>.from(e));
          }
          return null;
        })
        .whereType<CalendarDateSlot>()
        .toList();
  }

  /// Parse a list of disabled dates (simple strings)
  static List<DateTime> _parseDateList(dynamic value) {
    if (value == null || value is! List) return [];
    return value
        .map((e) {
          if (e is String) {
            return CalendarDateSlot._parseDate(e);
          }
          return null;
        })
        .whereType<DateTime>()
        .toList();
  }

  @override
  List<Object?> get props => [type, dateSlots, disabledDates];
}

class RecurrenceConfig extends Equatable {
  final String frequency; // daily, weekly, etc.
  final int interval;
  final List<String> byDays;
  final DateTime? startDate;
  final DateTime? endDate;

  const RecurrenceConfig({
    required this.frequency,
    this.interval = 1,
    this.byDays = const [],
    this.startDate,
    this.endDate,
  });

  factory RecurrenceConfig.fromJson(Map<String, dynamic> json) {
    return RecurrenceConfig(
      frequency: json['frequency'] ?? 'daily',
      interval: json['interval'] ?? 1,
      byDays:
          (json['by_days'] as List?)?.map((e) => e.toString()).toList() ?? [],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
    );
  }

  @override
  List<Object?> get props => [frequency, interval, byDays, startDate, endDate];
}

class ExtraService extends Equatable {
  final String id;
  final String name;
  final double price;
  final int? quantity;
  final String? icon; // New: Supports icons for rich details

  const ExtraService({
    required this.id,
    required this.name,
    required this.price,
    this.quantity,
    this.icon,
  });

  factory ExtraService.fromJson(Map<String, dynamic> json) {
    return ExtraService(
      id: json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['max_quantity'] ?? json['quantity'],
      icon: json['icon'],
    );
  }

  @override
  List<Object?> get props => [id, name, price, quantity, icon];
}

class Coupon extends Equatable {
  final String code;
  final String type; // fixed, percent
  final double value;
  final DateTime? validFrom;
  final DateTime? validUntil;

  const Coupon({
    required this.code,
    required this.type,
    required this.value,
    this.validFrom,
    this.validUntil,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] ?? '',
      type: json['type'] ?? 'fixed',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      validFrom: json['valid_from'] != null
          ? DateTime.tryParse(json['valid_from'])
          : null,
      validUntil: json['valid_until'] != null
          ? DateTime.tryParse(json['valid_until'])
          : null,
    );
  }

  @override
  List<Object?> get props => [code, type, value, validFrom, validUntil];
}

class SeatConfig extends Equatable {
  final String type;
  final String? mapImage;
  final Map<String, dynamic>? rawConfig;

  const SeatConfig({
    required this.type,
    this.mapImage,
    this.rawConfig,
  });

  factory SeatConfig.fromJson(Map<String, dynamic> json) {
    return SeatConfig(
      type: json['type'] ?? 'simple',
      mapImage: json['map_image'],
      rawConfig: json,
    );
  }

  @override
  List<Object?> get props => [type, mapImage, rawConfig];
}

class ExternalBooking extends Equatable {
  final String url;
  final double? price; // Optional price override
  final String? buttonText;

  const ExternalBooking({
    required this.url,
    this.price,
    this.buttonText,
  });

  factory ExternalBooking.fromJson(Map<String, dynamic> json) {
    return ExternalBooking(
      url: json['url'] ?? '',
      price: (json['price'] as num?)?.toDouble(),
      buttonText: json['button_text'],
    );
  }

  @override
  List<Object?> get props => [url, price, buttonText];
}

class TaxonomyTerm extends Equatable {
  final int id;
  final String name;
  final String slug;

  const TaxonomyTerm({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory TaxonomyTerm.fromJson(Map<String, dynamic> json) {
    return TaxonomyTerm(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, slug];
}

// --- NEW RICH CONTENT MODELS ---

class RichInfoConfig extends Equatable {
  final String description;
  final String? imageUrl;

  const RichInfoConfig({required this.description, this.imageUrl});

  factory RichInfoConfig.fromJson(Map<String, dynamic> json) {
    return RichInfoConfig(
      description: json['description']?.toString() ?? '',
      imageUrl: json['image'],
    );
  }

  @override
  List<Object?> get props => [description, imageUrl];
}

class AccessibilityConfig extends Equatable {
  final bool available;
  final String? note;

  const AccessibilityConfig({required this.available, this.note});

  factory AccessibilityConfig.fromJson(Map<String, dynamic> json) {
    return AccessibilityConfig(
      available: json['available'] == true ||
          json['available'] == 1 ||
          json['available'] == '1',
      note: json['note']?.toString(),
    );
  }

  @override
  List<Object?> get props => [available, note];
}

class LocationDetails extends Equatable {
  final RichInfoConfig? parking;
  final RichInfoConfig? transport;
  final AccessibilityConfig? pmr;
  final AccessibilityConfig? food;
  final AccessibilityConfig? drinks;
  final AccessibilityConfig? wifi;

  /// All active service keys from the API (e.g. "vestiaire", "hebergement")
  /// that don't have a dedicated field above.
  final List<String> otherServices;

  /// Accessibility features from the API (e.g. "stationnement_handicap", "places_handicap")
  final List<String> accessibilityFeatures;

  const LocationDetails({
    this.parking,
    this.transport,
    this.pmr,
    this.food,
    this.drinks,
    this.wifi,
    this.otherServices = const [],
    this.accessibilityFeatures = const [],
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      parking: json['parking'] != null
          ? RichInfoConfig.fromJson(json['parking'])
          : null,
      transport: json['transport'] != null
          ? RichInfoConfig.fromJson(json['transport'])
          : null,
      pmr: json['pmr'] != null
          ? AccessibilityConfig.fromJson(json['pmr'])
          : null,
      food: json['food'] != null
          ? AccessibilityConfig.fromJson(json['food'])
          : null,
      drinks: json['drinks'] != null
          ? AccessibilityConfig.fromJson(json['drinks'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
        parking,
        transport,
        pmr,
        food,
        drinks,
        wifi,
        otherServices,
        accessibilityFeatures
      ];
}

class CoOrganizer extends Equatable {
  final String id;
  final String name;
  final String? role;
  final String? imageUrl;
  final String? url;

  const CoOrganizer({
    required this.id,
    required this.name,
    this.role,
    this.imageUrl,
    this.url,
  });

  factory CoOrganizer.fromJson(Map<String, dynamic> json) {
    return CoOrganizer(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      role: json['role'],
      imageUrl: json['logo'] ??
          json['image'], // Handle both potential keys if needed, DTO says logo
      url: json['url'],
    );
  }

  @override
  List<Object?> get props => [id, name, role, imageUrl, url];
}

class SocialMediaConfig extends Equatable {
  final String? videoUrl;
  final String? linkedin;
  final String? facebook;
  final String? instagram;
  final String? youtube;

  const SocialMediaConfig({
    this.videoUrl,
    this.linkedin,
    this.facebook,
    this.instagram,
    this.youtube,
  });

  factory SocialMediaConfig.fromJson(Map<String, dynamic> json) {
    return SocialMediaConfig(
      videoUrl: json['video_url'],
      linkedin: json['linkedin'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      youtube: json['youtube'],
    );
  }

  @override
  List<Object?> get props => [videoUrl, linkedin, facebook, instagram, youtube];
}

class IndicativePrice extends Equatable {
  final String uuid;
  final String label;
  final double price;
  final String currency;
  final int sortOrder;

  const IndicativePrice({
    required this.uuid,
    required this.label,
    required this.price,
    required this.currency,
    required this.sortOrder,
  });

  factory IndicativePrice.fromJson(Map<String, dynamic> json) {
    return IndicativePrice(
      uuid: json['uuid']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'EUR',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  String get formattedPrice {
    if (price == 0) return 'Gratuit';
    if (currency.toUpperCase() == 'EUR') return cachedEuroAmount(price);
    return '${cachedApiAmountText(price)} $currency';
  }

  @override
  List<Object?> get props => [uuid, label, price, currency, sortOrder];
}

class EventVenue extends Equatable {
  final String uuid;
  final String name;
  final String slug;
  final Map<String, dynamic> services;
  final Map<String, dynamic> accessibility;

  const EventVenue({
    required this.uuid,
    required this.name,
    required this.slug,
    this.services = const {},
    this.accessibility = const {},
  });

  factory EventVenue.fromJson(Map<String, dynamic> json) {
    return EventVenue(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      services: json['services'] is Map
          ? Map<String, dynamic>.from(json['services'] as Map)
          : const {},
      accessibility: json['accessibility'] is Map
          ? Map<String, dynamic>.from(json['accessibility'] as Map)
          : const {},
    );
  }

  @override
  List<Object?> get props => [uuid, name, slug, services, accessibility];
}

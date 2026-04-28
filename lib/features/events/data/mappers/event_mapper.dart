import '../../domain/entities/event.dart';
import '../../domain/entities/event_submodels.dart';
import '../models/event_dto.dart';

class EventMapper {
  static Event toEvent(EventDto dto) {
    // Parse date and time from dates object
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    if (dto.dates != null) {
      // Try to parse start_date
      if (dto.dates!.startDate != null && dto.dates!.startDate!.isNotEmpty) {
        startDate = DateTime.tryParse(dto.dates!.startDate!) ?? DateTime.now();
      }
      // Try to parse end_date
      if (dto.dates!.endDate != null && dto.dates!.endDate!.isNotEmpty) {
        endDate = DateTime.tryParse(dto.dates!.endDate!) ?? startDate;
      } else {
        endDate = startDate;
      }

      // Apply time if available
      if (dto.dates!.startTime != null) {
        final timeParts = dto.dates!.startTime!.split(':');
        if (timeParts.length >= 2) {
          startDate = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
            int.tryParse(timeParts[0]) ?? 0,
            int.tryParse(timeParts[1]) ?? 0,
          );
        }
      }

      if (dto.dates!.endTime != null) {
        final timeParts = dto.dates!.endTime!.split(':');
        if (timeParts.length >= 2) {
          endDate = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            int.tryParse(timeParts[0]) ?? 0,
            int.tryParse(timeParts[1]) ?? 0,
          );
        }
      }
    }

    // Determine price type from pricing object
    PriceType priceType = PriceType.paid;
    if (dto.pricing?.isFree == true) {
      priceType = PriceType.free;
    } else if (dto.pricing?.min == dto.pricing?.max) {
      priceType = PriceType.paid;
    } else {
      priceType = PriceType.variable;
    }

    // Resolve primary category: prefer primaryCategory (mobile v2),
    // then categories[] with is_primary flag, then legacy category field.
    EventCategoryDto? resolvedCategory = dto.primaryCategory;
    if (resolvedCategory == null && dto.categories != null && dto.categories!.isNotEmpty) {
      resolvedCategory = dto.categories!.cast<EventCategoryDto?>().firstWhere(
        (c) => c?.isPrimary == true,
        orElse: () => dto.categories!.first,
      );
    }
    resolvedCategory ??= dto.category;

    EventCategory category = EventCategory.other;
    if (resolvedCategory != null) {
      category = _parseCategorySlug(resolvedCategory.slug);
    }

    // Get featured image URL (prefer large or full from featuredImage, fallback to thumbnail)
    String? imageUrl;
    if (dto.featuredImage != null) {
      imageUrl = dto.featuredImage!.large ??
          dto.featuredImage!.full ??
          dto.featuredImage!.medium ??
          dto.featuredImage!.thumbnail;
    }
    // Fallback to thumbnail field (used by organizer events API)
    imageUrl ??= dto.thumbnail;

    // Collect all images (featured + gallery)
    final allImages = <String>{};
    if (imageUrl != null) allImages.add(imageUrl);
    if (dto.gallery != null) {
      allImages.addAll(dto.gallery!);
    }

    // Ticket Mapping Logic: Prefer "tickets" (V2), fallback to "ticketTypes" (Legacy)
    // Filter only Map elements to avoid cast errors if API returns unexpected types
    List<Ticket> mappedTickets = [];
    if (dto.tickets != null && dto.tickets!.isNotEmpty) {
      mappedTickets = dto.tickets!
          .whereType<Map<String, dynamic>>()
          .map((e) => Ticket.fromJson(e))
          .toList();
    } else if (dto.ticketTypes != null && dto.ticketTypes!.isNotEmpty) {
      mappedTickets = dto.ticketTypes!
          .whereType<Map<String, dynamic>>()
          .map((e) => Ticket.fromJson(e))
          .toList();
    }

    // TimeSlot Parsing safely
    TimeSlotConfig? timeSlots;
    if (dto.timeSlots != null) {
      try {
        timeSlots = TimeSlotConfig.fromJson(dto.timeSlots!);
      } catch (e) {
        timeSlots = null;
      }
    }

    // Parse mobile v2 top-level slots[] into CalendarDateSlot list
    List<CalendarDateSlot> mobileSlots = [];
    if (dto.slots != null && dto.slots!.isNotEmpty) {
      mobileSlots = dto.slots!
          .whereType<Map>()
          .map((e) => _parseSlotFromMobileFormat(Map<String, dynamic>.from(e)))
          .toList();
    }

    return Event(
      id: dto.uuid ?? dto.id.toString(),
      slug: dto.slug,
      title: dto.title,
      description: dto.excerpt ?? '',
      fullDescription: dto.fullDescription ?? dto.content,
      shortDescription: _truncateDescription(dto.excerpt ?? ''),
      category: category,
      targetAudiences: _resolveTargetAudiences(dto),
      startDate: startDate,
      endDate: endDate,
      venue: dto.location?.venueName ?? '',
      address: dto.location?.address ?? '',
      city: dto.location?.city ?? '',
      postalCode: dto.location?.postalCode ?? '',
      latitude: dto.location?.lat ?? 0.0,
      longitude: dto.location?.lng ?? 0.0,
      distance: null,
      images: allImages.toList(),
      coverImage: imageUrl ?? (allImages.isNotEmpty ? allImages.first : null),
      priceType: priceType,
      price: dto.pricing?.min == dto.pricing?.max ? dto.pricing?.min : null,
      minPrice: dto.pricing?.min,
      maxPrice: dto.pricing?.max,
      isIndoor: dto.venueType?.toLowerCase() != 'outdoor',
      isOutdoor: dto.venueType?.toLowerCase() != 'indoor',
      tags: dto.tags ?? [],
      organizerId: _resolveOrganizerIdentifier(dto.organizer),
      organizerName: dto.organizer?.name ?? '',
      organizerLogo: dto.organizer?.logo ?? dto.organizer?.avatar,
      organizerDescription: dto.organizer?.description,
      organizerIsPlatform: dto.organizer?.isPlatform ?? false,
      organizerVerified: dto.organizer?.verified ?? false,
      organizerEventsCount: dto.organizer?.eventsCount,
      organizerFollowersCount: dto.organizer?.followersCount,
      organizerVenueTypes: dto.organizer?.venueTypes ?? const [],
      organizerAllowPublicContact: dto.organizer?.allowPublicContact ?? false,
      isFavorite: dto.isFavorite,
      isFeatured: dto.isFeatured,
      isRecommended: false,
      status: _determineStatus(startDate, endDate),
      hasDirectBooking: dto.bookingMode != 'discovery',
      discoveryPricingType: dto.discoveryPricingType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      views: 0,
      rating: null,
      reviewsCount: null,
      availableSeats: dto.availability?.spotsRemaining,
      totalSeats: dto.availability?.totalCapacity,
      tickets: mappedTickets,
      timeSlots: timeSlots,
      calendar: _resolveCalendar(dto.calendar, mobileSlots),
      recurrence: dto.recurrence != null
          ? RecurrenceConfig.fromJson(dto.recurrence!)
          : null,
      duration: dto.dates?.durationMinutes != null
          ? Duration(minutes: dto.dates!.durationMinutes!)
          : null,
      extraServices: dto.extraServices
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ExtraService.fromJson(e))
              .toList() ??
          [],
      indicativePrices: dto.indicativePrices
              ?.whereType<Map<String, dynamic>>()
              .map((e) => IndicativePrice.fromJson(e))
              .toList() ??
          [],
      coupons: dto.coupons
              ?.whereType<Map<String, dynamic>>()
              .map((e) => Coupon.fromJson(e))
              .toList() ??
          [],
      seatConfig:
          dto.seatConfig != null ? SeatConfig.fromJson(dto.seatConfig!) : null,
      externalBooking: dto.externalBooking != null
          ? ExternalBooking.fromJson(dto.externalBooking!)
          : null,
      eventTypeTerm: dto.eventTag != null
          ? TaxonomyTerm.fromJson(dto.eventTag!)
          : dto.eventType != null
              ? TaxonomyTerm.fromJson(dto.eventType!)
              : null,
      targetAudienceTerms: _resolveTargetAudienceTerms(dto),
      allCategoryNames: _resolveAllCategoryNames(dto),
      thematiqueName: dto.thematique?.name.isNotEmpty == true ? dto.thematique!.name : null,
      themeNames: dto.themes,
      emotionNames: dto.emotions,

      // RICH CONTENT MAPPING
      locationDetails: _resolveLocationDetails(dto),
      coOrganizers: dto.coOrganizers
              ?.map((e) => CoOrganizer(
                    id: e.id.toString(),
                    name: e.name,
                    role: e.role,
                    imageUrl: e.logo,
                    url: e.profileUrl,
                  ))
              .toList() ??
          [],
      socialMedia: dto.socialMedia != null
          ? SocialMediaConfig.fromJson(dto.socialMedia!)
          : null,
      rawCategorySlug: resolvedCategory?.slug,
      venueDetails: dto.venueData != null
          ? EventVenue.fromJson(dto.venueData!)
          : null,
      creationSource: dto.creationSource,
      originalOrganizerName: dto.originalOrganizerName,
    );
  }

  static EventCategory _parseCategorySlug(String slug) {
    switch (slug.toLowerCase()) {
      case 'spectacle':
      case 'show':
        return EventCategory.show;
      case 'atelier':
      case 'workshop':
        return EventCategory.workshop;
      case 'sport':
        return EventCategory.sport;
      case 'culture':
        return EventCategory.culture;
      case 'marche':
      case 'market':
        return EventCategory.market;
      case 'loisirs':
      case 'leisure':
        return EventCategory.leisure;
      case 'plein-air':
      case 'outdoor':
        return EventCategory.outdoor;
      case 'interieur':
      case 'indoor':
        return EventCategory.indoor;
      case 'festival':
        return EventCategory.festival;
      case 'exposition':
      case 'exhibition':
        return EventCategory.exhibition;
      case 'concert':
      case 'musique':
        return EventCategory.concert;
      case 'theatre':
      case 'theater':
        return EventCategory.theater;
      case 'cinema':
        return EventCategory.cinema;
      default:
        return EventCategory.other;
    }
  }

  static String _resolveOrganizerIdentifier(EventOrganizerDto? organizer) {
    if (organizer == null) return '';

    // Mobile v2: prefer uuid, then slug
    if (organizer.uuid != null && organizer.uuid!.isNotEmpty) {
      return organizer.uuid!;
    }
    if (organizer.slug != null && organizer.slug!.isNotEmpty) {
      return organizer.slug!;
    }

    // Legacy: extract from profile_url path, then fall back to int id
    final profileUrl = organizer.profileUrl?.trim();
    if (profileUrl != null && profileUrl.isNotEmpty) {
      final uri = Uri.tryParse(profileUrl);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.last;
      }
      return profileUrl;
    }

    if (organizer.id > 0) {
      return organizer.id.toString();
    }

    return '';
  }

  static EventStatus _determineStatus(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return EventStatus.upcoming;
    } else if (now.isAfter(endDate)) {
      return EventStatus.completed;
    } else {
      return EventStatus.ongoing;
    }
  }

  static String _truncateDescription(String description,
      {int maxLength = 150}) {
    if (description.length <= maxLength) return description;
    return '${description.substring(0, maxLength)}...';
  }

  /// Merges three sources of service data into LocationDetails:
  /// 1. Root-level `services` map (new mobile format — highest priority)
  /// 2. `venue.services` map (venue infrastructure)
  /// 3. Legacy `organizer.practicalInfo` (old format fallback)
  static LocationDetails? _resolveLocationDetails(EventDto dto) {
    final practicalInfo = dto.organizer?.practicalInfo;

    // Parse root-level services — API sends either:
    //   nested: { "services": {...}, "accessibility": {...} }
    //   flat:   { "restauration": true, "parking": true, ... }
    Map<String, dynamic>? flatServices;
    Map<String, dynamic>? accessibilityMap;
    if (dto.services != null) {
      if (dto.services!['services'] is Map) {
        flatServices = Map<String, dynamic>.from(dto.services!['services'] as Map);
        if (dto.services!['accessibility'] is Map) {
          accessibilityMap = Map<String, dynamic>.from(dto.services!['accessibility'] as Map);
        }
      } else {
        flatServices = dto.services;
      }
    }

    // Venue services (from the venue object)
    final venueServicesRaw = dto.venueData?['services'];
    final venueServices = venueServicesRaw is Map
        ? Map<String, dynamic>.from(venueServicesRaw as Map)
        : null;

    // Merge: event services override venue services
    final allServices = <String, dynamic>{
      ...?venueServices,
      ...?flatServices,
    };

    bool _isTrue(dynamic v) => v == true || v == 1 || v == '1';

    final hasParking = _isTrue(allServices['parking'])
        || practicalInfo?.stationnement != null;
    final hasFood = _isTrue(allServices['restauration'])
        || practicalInfo?.restauration == true;
    final hasDrinks = _isTrue(allServices['bar'])
        || _isTrue(allServices['boisson'])
        || practicalInfo?.boisson == true;
    final hasWifi = _isTrue(allServices['wifi']);
    final hasTransport = _isTrue(allServices['transport']);
    final hasPmr = (accessibilityMap?.values.any(_isTrue) == true)
        || practicalInfo?.pmr == true;

    // Collect remaining services not handled by dedicated fields
    const handledKeys = {'parking', 'restauration', 'bar', 'boisson', 'wifi', 'transport'};
    final otherServices = allServices.entries
        .where((e) => !handledKeys.contains(e.key) && _isTrue(e.value))
        .map((e) => e.key)
        .toList();

    // Collect individual accessibility features
    final accessibilityFeatures = accessibilityMap?.entries
        .where((e) => _isTrue(e.value))
        .map((e) => e.key)
        .toList() ?? <String>[];

    final parking = hasParking
        ? RichInfoConfig(
            description: practicalInfo?.stationnement ?? 'Parking disponible')
        : null;
    final food = hasFood
        ? AccessibilityConfig(available: true, note: practicalInfo?.restaurationInfos)
        : null;
    final drinks = hasDrinks
        ? AccessibilityConfig(available: true, note: practicalInfo?.boissonInfos)
        : null;
    final pmr = hasPmr
        ? AccessibilityConfig(available: true, note: practicalInfo?.pmrInfos)
        : null;
    final wifi = hasWifi
        ? const AccessibilityConfig(available: true)
        : null;
    final transport = hasTransport
        ? const RichInfoConfig(description: 'Transport disponible')
        : null;

    if (parking == null && food == null && drinks == null && pmr == null
        && wifi == null && transport == null
        && otherServices.isEmpty && accessibilityFeatures.isEmpty) {
      return null;
    }

    return LocationDetails(
      parking: parking,
      transport: transport,
      pmr: pmr,
      food: food,
      drinks: drinks,
      wifi: wifi,
      otherServices: otherServices,
      accessibilityFeatures: accessibilityFeatures,
    );
  }

  /// Collect all category names from the DTO (mobile v2 categories list, then legacy)
  static List<String> _resolveAllCategoryNames(EventDto dto) {
    if (dto.categories != null && dto.categories!.isNotEmpty) {
      return dto.categories!
          .where((c) => c.name.isNotEmpty)
          .map((c) => c.name)
          .toList();
    }
    if (dto.primaryCategory != null && dto.primaryCategory!.name.isNotEmpty) {
      return [dto.primaryCategory!.name];
    }
    if (dto.category != null && dto.category!.name.isNotEmpty) {
      return [dto.category!.name];
    }
    return [];
  }

  /// Resolve target audience terms from API data (prefer plural, fallback singular)
  static List<TaxonomyTerm> _resolveTargetAudienceTerms(EventDto dto) {
    final source = dto.targetAudiences ?? dto.targetAudience;
    if (source == null || source.isEmpty) return [];
    return source
        .whereType<Map<String, dynamic>>()
        .map((e) => TaxonomyTerm.fromJson(e))
        .toList();
  }

  /// Derive EventAudience enum list from API target audience data
  static List<EventAudience> _resolveTargetAudiences(EventDto dto) {
    final terms = _resolveTargetAudienceTerms(dto);
    if (terms.isEmpty) return const [EventAudience.all];

    final audiences = terms.map((t) {
      switch (t.slug.toLowerCase()) {
        case 'familles':
        case 'famille':
        case 'families':
          return EventAudience.family;
        case 'enfants':
        case 'children':
          return EventAudience.children;
        case 'adolescents':
        case 'ados':
        case 'teenagers':
          return EventAudience.teenagers;
        case 'adultes':
        case 'adults':
          return EventAudience.adults;
        case 'seniors':
          return EventAudience.seniors;
        default:
          return EventAudience.all;
      }
    }).toSet().toList();

    return audiences.isNotEmpty ? audiences : const [EventAudience.all];
  }

  /// Parse a slot from the mobile v2 format into CalendarDateSlot
  static CalendarDateSlot _parseSlotFromMobileFormat(Map<String, dynamic> json) {
    return CalendarDateSlot.fromJson(<String, dynamic>{
      'id': json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      'date': json['date']?.toString() ?? '',
      'start_time': json['start_time'],
      'end_time': json['end_time'],
      'spots_remaining': json['available_capacity'] ?? json['spots_remaining'],
      'total_capacity': json['capacity'] ?? json['total_capacity'],
    });
  }

  /// Resolve calendar config: prefer legacy calendar map, fallback to mobile slots
  static CalendarConfig? _resolveCalendar(
    Map<String, dynamic>? legacyCalendarMap,
    List<CalendarDateSlot> mobileSlots,
  ) {
    if (legacyCalendarMap != null) {
      return CalendarConfig.fromJson(legacyCalendarMap);
    }
    if (mobileSlots.isNotEmpty) {
      return CalendarConfig(type: 'manual', dateSlots: mobileSlots);
    }
    return null;
  }
}

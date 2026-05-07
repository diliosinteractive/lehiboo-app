import 'package:equatable/equatable.dart';
import 'event_submodels.dart';

enum EventCategory {
  show, // Spectacle
  workshop, // Atelier
  sport,
  culture,
  market, // Marché
  leisure, // Loisirs
  outdoor,
  indoor,
  festival,
  exhibition,
  concert,
  theater,
  cinema,
  other
}

enum EventAudience { all, family, children, teenagers, adults, seniors }

enum EventStatus { upcoming, ongoing, completed, cancelled, postponed, soldOut }

enum PriceType { free, paid, donation, variable }

class Event extends Equatable {
  final String id;
  final String slug;
  final String title;
  final String description; // Typically the excerpt
  final String? fullDescription; // Full HTML content
  final String shortDescription;
  final EventCategory category;
  final List<EventAudience> targetAudiences;
  final DateTime startDate;
  final DateTime endDate;
  final String? recurrencePattern; // Pour les événements récurrents
  final List<DateTime>? occurences;
  final String venue; // Lieu
  final String address;
  final String city;
  final String postalCode;
  final double latitude;
  final double longitude;
  final double? distance; // Distance depuis l'utilisateur
  final List<String> images;
  final String? coverImage;
  final String? videoUrl;
  final PriceType priceType;
  final double? price;
  final double? minPrice;
  final double? maxPrice;
  final String? priceDetails;
  final int? availableSeats;
  final int? totalSeats;
  final bool isIndoor;
  final bool isOutdoor;
  final Duration? duration;
  final int? minAge;
  final int? maxAge;
  final List<String> tags;
  final String organizerId;
  final String organizerName;
  final String? organizerLogo;
  final String? organizerDescription;
  final bool organizerIsPlatform;
  final bool organizerVerified;
  final int? organizerEventsCount;
  final int? organizerFollowersCount;
  final List<String> organizerVenueTypes;
  final bool organizerAllowPublicContact;
  final bool isFavorite;

  /// Members-only event — drives the "Privé 🔒" badge on cards.
  /// Spec: MEMBERSHIPS_MOBILE_SPEC.md §20.
  final bool isMembersOnly;
  final bool isFeatured;
  final bool isRecommended;
  final EventStatus status;
  final String? bookingUrl;
  final bool hasDirectBooking;
  final String? discoveryPricingType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int views;
  final double? rating;
  final int? reviewsCount;
  final Map<String, dynamic>? additionalInfo;
  final List<String>? accessibility; // Accessibilité PMR, etc.
  final String? contactPhone;
  final String? contactEmail;
  final String? website;

  // --- NEW FIELDS from V2 API ---
  final List<Ticket> tickets;
  final TimeSlotConfig? timeSlots;
  final CalendarConfig? calendar;
  final RecurrenceConfig? recurrence;
  final List<ExtraService> extraServices;
  final List<IndicativePrice> indicativePrices;
  final List<Coupon> coupons;
  final SeatConfig? seatConfig;
  final ExternalBooking? externalBooking;
  final TaxonomyTerm? eventTypeTerm; // Maps to 'event_type' from API
  final List<TaxonomyTerm>
      targetAudienceTerms; // Maps to 'target_audience' from API
  final List<String>
      allCategoryNames; // All category names from API (including primary)
  final String? thematiqueName; // Main thematique name from API
  final List<String> themeNames; // From API 'themes' array
  final List<String> emotionNames; // From API 'emotions' array

  // --- RICH CONTENT V2 ---
  final LocationDetails? locationDetails;
  final List<CoOrganizer> coOrganizers;

  final SocialMediaConfig? socialMedia;

  // Added field for raw category slug (fallback image logic)
  final String? rawCategorySlug;

  // Mobile API v2 fields
  final EventVenue? venueDetails;
  final String? creationSource;
  final String? originalOrganizerName;

  // ---- HOME_FEED MobileEventResource fields (spec: docs/HOME_FEED_MOBILE_SPEC.md §4) ----

  // §4.1 / §4.2 — identification & scheduling
  final int? version;
  final String? timezone;
  final String? calendarMode;
  /// Spec §4.2: "offline" | "online" | "hybrid". Distinct from the legacy
  /// taxonomy term `eventTypeTerm`.
  final String? eventTypeMode;

  // §4.3 — flat venue fields (parallel to the existing `venue`/`address`/etc.)
  final String? country;
  final String? addressSource;
  final String? venueId;

  // §4.5 / §4.6 — pricing & capacity (top-level)
  final int? capacityGlobal;
  /// Spec §4.6: "available" | "unavailable". Drives Book CTA gating.
  final String? availabilityStatus;

  // §4.7 — sale window & cancellation policy
  final DateTime? saleStartAt;
  final DateTime? saleEndAt;
  final bool allowCancellation;
  final int? cancelBeforeHours;
  final bool generateQrCodes;

  // §4.8 — status & flags
  /// Raw API value: "published" or "private". Distinct from the date-derived
  /// `status: EventStatus`.
  final String? publicationStatus;
  final String? visibility;
  /// Spec §4.8 caveat: gates the password modal. Not the same as
  /// `hasPassword`, which is informational only.
  final bool isPasswordProtected;
  final bool hasPassword;
  final DateTime? publishedAt;
  final DateTime? scheduledPublishAt;
  final bool isActive;
  final bool isOnSale;
  final bool isLive;

  // §4.9 — booking capabilities
  final bool canAcceptBookings;
  final bool canAcceptDiscovery;
  final bool isDiscovery;
  /// Spec §4.9: only present when `bookingMode == "discovery"`.
  final int? participationCount;
  final bool isParticipating;
  /// Spec §4.9: when set, the mobile UI opens this URL instead of the
  /// in-app booking flow.
  final String? externalTicketingUrl;

  const Event({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    this.fullDescription,
    required this.shortDescription,
    required this.category,
    required this.targetAudiences,
    required this.startDate,
    required this.endDate,
    this.recurrencePattern,
    this.occurences,
    required this.venue,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    this.distance,
    required this.images,
    this.coverImage,
    this.videoUrl,
    required this.priceType,
    this.price,
    this.minPrice,
    this.maxPrice,
    this.priceDetails,
    this.availableSeats,
    this.totalSeats,
    required this.isIndoor,
    required this.isOutdoor,
    this.duration,
    this.minAge,
    this.maxAge,
    required this.tags,
    required this.organizerId,
    required this.organizerName,
    this.organizerLogo,
    this.organizerDescription,
    this.organizerIsPlatform = false,
    this.organizerVerified = false,
    this.organizerEventsCount,
    this.organizerFollowersCount,
    this.organizerVenueTypes = const [],
    this.organizerAllowPublicContact = false,
    required this.isFavorite,
    this.isMembersOnly = false,
    required this.isFeatured,
    required this.isRecommended,
    required this.status,
    this.bookingUrl,
    required this.hasDirectBooking,
    this.discoveryPricingType,
    required this.createdAt,
    required this.updatedAt,
    required this.views,
    this.rating,
    this.reviewsCount,
    this.additionalInfo,
    this.accessibility,
    this.contactPhone,
    this.contactEmail,
    this.website,
    // Defaults for new fields to ensure backward compatibility during migration
    this.tickets = const [],
    this.timeSlots,
    this.calendar,
    this.recurrence,
    this.extraServices = const [],
    this.indicativePrices = const [],
    this.coupons = const [],
    this.seatConfig,
    this.externalBooking,
    this.eventTypeTerm,
    this.targetAudienceTerms = const [],
    this.allCategoryNames = const [],
    this.thematiqueName,
    this.themeNames = const [],
    this.emotionNames = const [],
    this.locationDetails,
    this.coOrganizers = const [],
    this.socialMedia,
    this.rawCategorySlug,
    this.venueDetails,
    this.creationSource,
    this.originalOrganizerName,
    // HOME_FEED §4 fields
    this.version,
    this.timezone,
    this.calendarMode,
    this.eventTypeMode,
    this.country,
    this.addressSource,
    this.venueId,
    this.capacityGlobal,
    this.availabilityStatus,
    this.saleStartAt,
    this.saleEndAt,
    this.allowCancellation = false,
    this.cancelBeforeHours,
    this.generateQrCodes = false,
    this.publicationStatus,
    this.visibility,
    this.isPasswordProtected = false,
    this.hasPassword = false,
    this.publishedAt,
    this.scheduledPublishAt,
    this.isActive = true,
    this.isOnSale = false,
    this.isLive = false,
    this.canAcceptBookings = false,
    this.canAcceptDiscovery = false,
    this.isDiscovery = false,
    this.participationCount,
    this.isParticipating = false,
    this.externalTicketingUrl,
  });

  factory Event.minimal({
    required String id,
    required String slug,
    required String title,
    String venue = '',
    String city = '',
    List<String> images = const [],
    String organizerId = '',
    String organizerName = '',
  }) {
    final now = DateTime.now();

    return Event(
      id: id,
      slug: slug,
      title: title,
      description: '',
      shortDescription: '',
      category: EventCategory.other,
      targetAudiences: const [EventAudience.all],
      startDate: now,
      endDate: now,
      venue: venue,
      address: '',
      city: city,
      postalCode: '',
      latitude: 0,
      longitude: 0,
      images: images,
      priceType: PriceType.paid,
      isIndoor: false,
      isOutdoor: false,
      tags: const [],
      organizerId: organizerId,
      organizerName: organizerName,
      isFavorite: false,
      isFeatured: false,
      isRecommended: false,
      status: EventStatus.upcoming,
      hasDirectBooking: true,
      createdAt: now,
      updatedAt: now,
      views: 0,
    );
  }

  bool get isFree => priceType == PriceType.free;

  bool get isToday {
    final now = DateTime.now();
    return startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return startDate.isAfter(weekStart) && startDate.isBefore(weekEnd);
  }

  bool get isThisWeekend {
    final weekday = startDate.weekday;
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  String get formattedPrice {
    if (priceType == PriceType.free) {
      return 'Gratuit';
    } else if (priceType == PriceType.donation) {
      return 'Participation libre';
    } else if (price != null) {
      return '${price!.toStringAsFixed(2)} €';
    } else if (minPrice != null && maxPrice != null) {
      return 'De ${minPrice!.toStringAsFixed(0)} à ${maxPrice!.toStringAsFixed(0)} €';
    }
    return priceDetails ?? 'Prix variable';
  }

  String get categoryLabel {
    // Prefer the new TaxonomyTerm if available
    if (eventTypeTerm != null) {
      return eventTypeTerm!.name;
    }
    switch (category) {
      case EventCategory.show:
        return 'Spectacle';
      case EventCategory.workshop:
        return 'Atelier';
      case EventCategory.sport:
        return 'Sport';
      case EventCategory.culture:
        return 'Culture';
      case EventCategory.market:
        return 'Marché';
      case EventCategory.leisure:
        return 'Loisirs';
      case EventCategory.outdoor:
        return 'Plein air';
      case EventCategory.indoor:
        return 'Intérieur';
      case EventCategory.festival:
        return 'Festival';
      case EventCategory.exhibition:
        return 'Exposition';
      case EventCategory.concert:
        return 'Concert';
      case EventCategory.theater:
        return 'Théâtre';
      case EventCategory.cinema:
        return 'Cinéma';
      case EventCategory.other:
        return 'Autre';
    }
  }

  String get audienceLabel {
    // Prefer new TaxonomyTerms
    if (targetAudienceTerms.isNotEmpty) {
      return targetAudienceTerms.map((t) => t.name).join(', ');
    }
    if (targetAudiences.contains(EventAudience.all)) {
      return 'Tout public';
    }
    return targetAudiences.map((a) {
      switch (a) {
        case EventAudience.family:
          return 'Famille';
        case EventAudience.children:
          return 'Enfants';
        case EventAudience.teenagers:
          return 'Adolescents';
        case EventAudience.adults:
          return 'Adultes';
        case EventAudience.seniors:
          return 'Seniors';
        default:
          return '';
      }
    }).join(', ');
  }

  String? get ageRangeLabel {
    if (minAge == null && maxAge == null) return null;
    if (minAge != null && maxAge == null) return '$minAge ans et +';
    if (minAge == null && maxAge != null) return 'Jusqu\'à $maxAge ans';
    return '$minAge-$maxAge ans';
  }

  String get locationTypeLabel {
    if (isIndoor && isOutdoor) return 'Intérieur/Extérieur';
    if (isIndoor) return 'Intérieur';
    if (isOutdoor) return 'Extérieur';
    return '';
  }

  String get distanceLabel {
    if (distance == null) return '';
    if (distance! < 1) {
      return '${(distance! * 1000).toStringAsFixed(0)} m';
    }
    return '${distance!.toStringAsFixed(1)} km';
  }

  String get durationLabel {
    Duration diff;
    if (duration != null) {
      diff = duration!;
    } else {
      diff = endDate.difference(startDate);
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours h ${minutes > 0 ? '$minutes' : ''}';
    }
    return '$minutes min';
  }

  Event copyWith({
    String? id,
    String? slug,
    String? title,
    String? description,
    String? fullDescription,
    String? shortDescription,
    EventCategory? category,
    List<EventAudience>? targetAudiences,
    DateTime? startDate,
    DateTime? endDate,
    String? recurrencePattern,
    List<DateTime>? occurences,
    String? venue,
    String? address,
    String? city,
    String? postalCode,
    double? latitude,
    double? longitude,
    double? distance,
    List<String>? images,
    String? coverImage,
    String? videoUrl,
    PriceType? priceType,
    double? price,
    double? minPrice,
    double? maxPrice,
    String? priceDetails,
    int? availableSeats,
    int? totalSeats,
    bool? isIndoor,
    bool? isOutdoor,
    Duration? duration,
    int? minAge,
    int? maxAge,
    List<String>? tags,
    String? organizerId,
    String? organizerName,
    String? organizerLogo,
    String? organizerDescription,
    bool? organizerIsPlatform,
    bool? organizerVerified,
    int? organizerEventsCount,
    int? organizerFollowersCount,
    List<String>? organizerVenueTypes,
    bool? organizerAllowPublicContact,
    bool? isFavorite,
    bool? isMembersOnly,
    bool? isFeatured,
    bool? isRecommended,
    EventStatus? status,
    String? bookingUrl,
    bool? hasDirectBooking,
    String? discoveryPricingType,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? views,
    double? rating,
    int? reviewsCount,
    Map<String, dynamic>? additionalInfo,
    List<String>? accessibility,
    String? contactPhone,
    String? contactEmail,
    String? website,
    List<Ticket>? tickets,
    TimeSlotConfig? timeSlots,
    CalendarConfig? calendar,
    RecurrenceConfig? recurrence,
    List<ExtraService>? extraServices,
    List<IndicativePrice>? indicativePrices,
    List<Coupon>? coupons,
    SeatConfig? seatConfig,
    ExternalBooking? externalBooking,
    TaxonomyTerm? eventTypeTerm,
    List<TaxonomyTerm>? targetAudienceTerms,
    List<String>? allCategoryNames,
    String? thematiqueName,
    List<String>? themeNames,
    List<String>? emotionNames,
    LocationDetails? locationDetails,
    List<CoOrganizer>? coOrganizers,
    SocialMediaConfig? socialMedia,
    String? rawCategorySlug,
    EventVenue? venueDetails,
    String? creationSource,
    String? originalOrganizerName,
    int? version,
    String? timezone,
    String? calendarMode,
    String? eventTypeMode,
    String? country,
    String? addressSource,
    String? venueId,
    int? capacityGlobal,
    String? availabilityStatus,
    DateTime? saleStartAt,
    DateTime? saleEndAt,
    bool? allowCancellation,
    int? cancelBeforeHours,
    bool? generateQrCodes,
    String? publicationStatus,
    String? visibility,
    bool? isPasswordProtected,
    bool? hasPassword,
    DateTime? publishedAt,
    DateTime? scheduledPublishAt,
    bool? isActive,
    bool? isOnSale,
    bool? isLive,
    bool? canAcceptBookings,
    bool? canAcceptDiscovery,
    bool? isDiscovery,
    int? participationCount,
    bool? isParticipating,
    String? externalTicketingUrl,
  }) {
    return Event(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      fullDescription: fullDescription ?? this.fullDescription,
      shortDescription: shortDescription ?? this.shortDescription,
      category: category ?? this.category,
      targetAudiences: targetAudiences ?? this.targetAudiences,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      occurences: occurences ?? this.occurences,
      venue: venue ?? this.venue,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      images: images ?? this.images,
      coverImage: coverImage ?? this.coverImage,
      videoUrl: videoUrl ?? this.videoUrl,
      priceType: priceType ?? this.priceType,
      price: price ?? this.price,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      priceDetails: priceDetails ?? this.priceDetails,
      availableSeats: availableSeats ?? this.availableSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      isIndoor: isIndoor ?? this.isIndoor,
      isOutdoor: isOutdoor ?? this.isOutdoor,
      duration: duration ?? this.duration,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      tags: tags ?? this.tags,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      organizerLogo: organizerLogo ?? this.organizerLogo,
      organizerDescription: organizerDescription ?? this.organizerDescription,
      organizerIsPlatform: organizerIsPlatform ?? this.organizerIsPlatform,
      organizerVerified: organizerVerified ?? this.organizerVerified,
      organizerEventsCount: organizerEventsCount ?? this.organizerEventsCount,
      organizerFollowersCount:
          organizerFollowersCount ?? this.organizerFollowersCount,
      organizerVenueTypes: organizerVenueTypes ?? this.organizerVenueTypes,
      organizerAllowPublicContact:
          organizerAllowPublicContact ?? this.organizerAllowPublicContact,
      isFavorite: isFavorite ?? this.isFavorite,
      isMembersOnly: isMembersOnly ?? this.isMembersOnly,
      isFeatured: isFeatured ?? this.isFeatured,
      isRecommended: isRecommended ?? this.isRecommended,
      status: status ?? this.status,
      bookingUrl: bookingUrl ?? this.bookingUrl,
      hasDirectBooking: hasDirectBooking ?? this.hasDirectBooking,
      discoveryPricingType: discoveryPricingType ?? this.discoveryPricingType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      views: views ?? this.views,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      accessibility: accessibility ?? this.accessibility,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      website: website ?? this.website,
      tickets: tickets ?? this.tickets,
      timeSlots: timeSlots ?? this.timeSlots,
      calendar: calendar ?? this.calendar,
      recurrence: recurrence ?? this.recurrence,
      extraServices: extraServices ?? this.extraServices,
      indicativePrices: indicativePrices ?? this.indicativePrices,
      coupons: coupons ?? this.coupons,
      seatConfig: seatConfig ?? this.seatConfig,
      externalBooking: externalBooking ?? this.externalBooking,
      eventTypeTerm: eventTypeTerm ?? this.eventTypeTerm,
      targetAudienceTerms: targetAudienceTerms ?? this.targetAudienceTerms,
      allCategoryNames: allCategoryNames ?? this.allCategoryNames,
      thematiqueName: thematiqueName ?? this.thematiqueName,
      themeNames: themeNames ?? this.themeNames,
      emotionNames: emotionNames ?? this.emotionNames,
      locationDetails: locationDetails ?? this.locationDetails,
      coOrganizers: coOrganizers ?? this.coOrganizers,
      socialMedia: socialMedia ?? this.socialMedia,
      rawCategorySlug: rawCategorySlug ?? this.rawCategorySlug,
      venueDetails: venueDetails ?? this.venueDetails,
      creationSource: creationSource ?? this.creationSource,
      originalOrganizerName:
          originalOrganizerName ?? this.originalOrganizerName,
      version: version ?? this.version,
      timezone: timezone ?? this.timezone,
      calendarMode: calendarMode ?? this.calendarMode,
      eventTypeMode: eventTypeMode ?? this.eventTypeMode,
      country: country ?? this.country,
      addressSource: addressSource ?? this.addressSource,
      venueId: venueId ?? this.venueId,
      capacityGlobal: capacityGlobal ?? this.capacityGlobal,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      saleStartAt: saleStartAt ?? this.saleStartAt,
      saleEndAt: saleEndAt ?? this.saleEndAt,
      allowCancellation: allowCancellation ?? this.allowCancellation,
      cancelBeforeHours: cancelBeforeHours ?? this.cancelBeforeHours,
      generateQrCodes: generateQrCodes ?? this.generateQrCodes,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      visibility: visibility ?? this.visibility,
      isPasswordProtected: isPasswordProtected ?? this.isPasswordProtected,
      hasPassword: hasPassword ?? this.hasPassword,
      publishedAt: publishedAt ?? this.publishedAt,
      scheduledPublishAt: scheduledPublishAt ?? this.scheduledPublishAt,
      isActive: isActive ?? this.isActive,
      isOnSale: isOnSale ?? this.isOnSale,
      isLive: isLive ?? this.isLive,
      canAcceptBookings: canAcceptBookings ?? this.canAcceptBookings,
      canAcceptDiscovery: canAcceptDiscovery ?? this.canAcceptDiscovery,
      isDiscovery: isDiscovery ?? this.isDiscovery,
      participationCount: participationCount ?? this.participationCount,
      isParticipating: isParticipating ?? this.isParticipating,
      externalTicketingUrl: externalTicketingUrl ?? this.externalTicketingUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        slug,
        title,
        description,
        fullDescription,
        shortDescription,
        category,
        targetAudiences,
        startDate,
        endDate,
        recurrencePattern,
        occurences,
        venue,
        address,
        city,
        postalCode,
        latitude,
        longitude,
        distance,
        images,
        coverImage,
        videoUrl,
        priceType,
        price,
        minPrice,
        maxPrice,
        priceDetails,
        availableSeats,
        totalSeats,
        isIndoor,
        isOutdoor,
        duration,
        minAge,
        maxAge,
        tags,
        organizerId,
        organizerName,
        organizerLogo,
        organizerDescription,
        organizerIsPlatform,
        organizerVerified,
        organizerEventsCount,
        organizerFollowersCount,
        organizerVenueTypes,
        organizerAllowPublicContact,
        isFavorite,
        isMembersOnly,
        isFeatured,
        isRecommended,
        status,
        bookingUrl,
        hasDirectBooking,
        discoveryPricingType,
        createdAt,
        updatedAt,
        views,
        rating,
        reviewsCount,
        additionalInfo,
        accessibility,
        contactPhone,
        contactEmail,
        website,
        tickets,
        timeSlots,
        calendar,
        recurrence,
        extraServices,
        indicativePrices,
        coupons,
        seatConfig,
        externalBooking,
        eventTypeTerm,
        targetAudienceTerms,
        allCategoryNames,
        thematiqueName,
        themeNames,
        emotionNames,
        locationDetails,
        coOrganizers,
        socialMedia,
        rawCategorySlug,
        venueDetails,
        creationSource,
        originalOrganizerName,
        version,
        timezone,
        calendarMode,
        eventTypeMode,
        country,
        addressSource,
        venueId,
        capacityGlobal,
        availabilityStatus,
        saleStartAt,
        saleEndAt,
        allowCancellation,
        cancelBeforeHours,
        generateQrCodes,
        publicationStatus,
        visibility,
        isPasswordProtected,
        hasPassword,
        publishedAt,
        scheduledPublishAt,
        isActive,
        isOnSale,
        isLive,
        canAcceptBookings,
        canAcceptDiscovery,
        isDiscovery,
        participationCount,
        isParticipating,
        externalTicketingUrl,
      ];
}

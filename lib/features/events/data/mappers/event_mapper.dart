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

    // Parse category
    EventCategory category = EventCategory.other;
    if (dto.category != null) {
      category = _parseCategorySlug(dto.category!.slug);
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
    List<Ticket> mappedTickets = [];
    if (dto.tickets != null && dto.tickets!.isNotEmpty) {
      mappedTickets = dto.tickets!.map((e) => Ticket.fromJson(e as Map<String, dynamic>)).toList();
    } else if (dto.ticketTypes != null && dto.ticketTypes!.isNotEmpty) {
      mappedTickets = dto.ticketTypes!.map((e) => Ticket.fromJson(e as Map<String, dynamic>)).toList();
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

    return Event(
      id: dto.id.toString(),
      title: dto.title,
      description: dto.excerpt ?? '',
      fullDescription: dto.content,
      shortDescription: _truncateDescription(dto.excerpt ?? ''),
      category: category,
      targetAudiences: const [EventAudience.all],
      startDate: startDate,
      endDate: endDate,
      venue: dto.location?.venueName ?? '',
      address: dto.location?.address ?? '',
      city: dto.location?.city ?? '',
      postalCode: '',
      latitude: dto.location?.lat ?? 0.0,
      longitude: dto.location?.lng ?? 0.0,
      distance: null,
      images: allImages.toList(),
      coverImage: imageUrl ?? (allImages.isNotEmpty ? allImages.first : null),
      priceType: priceType,
      price: dto.pricing?.min == dto.pricing?.max ? dto.pricing?.min : null,
      minPrice: dto.pricing?.min,
      maxPrice: dto.pricing?.max,
      isIndoor: true, 
      isOutdoor: false,
      tags: dto.tags ?? [],
      organizerId: dto.organizer?.id.toString() ?? '',
      organizerName: dto.organizer?.name ?? '',
      organizerLogo: dto.organizer?.avatar,
      isFavorite: dto.isFavorite,
      isFeatured: false,
      isRecommended: false,
      status: _determineStatus(startDate, endDate),
      hasDirectBooking: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      views: 0,
      rating: null,
      reviewsCount: null,
      availableSeats: dto.availability?.spotsRemaining,
      totalSeats: dto.availability?.totalCapacity,
      tickets: mappedTickets,
      timeSlots: timeSlots,
      calendar: dto.calendar != null ? CalendarConfig.fromJson(dto.calendar!) : null,
      recurrence: dto.recurrence != null ? RecurrenceConfig.fromJson(dto.recurrence!) : null,
      extraServices: dto.extraServices?.map((e) => ExtraService.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      coupons: dto.coupons?.map((e) => Coupon.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      seatConfig: dto.seatConfig != null ? SeatConfig.fromJson(dto.seatConfig!) : null,
      externalBooking: dto.externalBooking != null ? ExternalBooking.fromJson(dto.externalBooking!) : null,
      eventTypeTerm: dto.eventType != null ? TaxonomyTerm.fromJson(dto.eventType!) : null,
      targetAudienceTerms: dto.targetAudience?.map((e) => TaxonomyTerm.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      
      // RICH CONTENT MAPPING
      locationDetails: _mapLocationDetails(dto.organizer?.practicalInfo),
      coOrganizers: dto.coOrganizers?.map((e) => CoOrganizer(
        id: e.id.toString(),
        name: e.name,
        role: e.role,
        imageUrl: e.logo,
        url: e.profileUrl,
      )).toList() ?? [],
      socialMedia: dto.socialMedia != null ? SocialMediaConfig.fromJson(dto.socialMedia!) : null,
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

  static String _truncateDescription(String description, {int maxLength = 150}) {
    if (description.length <= maxLength) return description;
    return '${description.substring(0, maxLength)}...';
  }

  static LocationDetails? _mapLocationDetails(OrganizerPracticalInfoDto? practicalInfo) {
    if (practicalInfo == null) return null;
    return LocationDetails(
      pmr: AccessibilityConfig(available: practicalInfo.pmr, note: practicalInfo.pmrInfos),
      food: AccessibilityConfig(available: practicalInfo.restauration, note: practicalInfo.restaurationInfos),
      drinks: AccessibilityConfig(available: practicalInfo.boisson, note: practicalInfo.boissonInfos),
      parking: practicalInfo.stationnement != null 
          ? RichInfoConfig(description: practicalInfo.stationnement!) 
          : null,
      transport: null, 
    );
  }
}

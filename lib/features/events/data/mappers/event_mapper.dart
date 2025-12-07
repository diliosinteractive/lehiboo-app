import '../../domain/entities/event.dart';
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

    // Get featured image URL (prefer large or full)
    String? imageUrl;
    if (dto.featuredImage != null) {
      imageUrl = dto.featuredImage!.large ??
                 dto.featuredImage!.full ??
                 dto.featuredImage!.medium ??
                 dto.featuredImage!.thumbnail;
    }

    return Event(
      id: dto.id.toString(),
      title: dto.title,
      description: dto.excerpt ?? '',
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
      images: imageUrl != null ? [imageUrl] : [],
      coverImage: imageUrl,
      priceType: priceType,
      price: dto.pricing?.min == dto.pricing?.max ? dto.pricing?.min : null,
      minPrice: dto.pricing?.min,
      maxPrice: dto.pricing?.max,
      isIndoor: true, // Default, API doesn't provide this info
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
      rating: null, // API returns dynamic ratings object
      reviewsCount: null,
      availableSeats: dto.availability?.spotsRemaining,
      totalSeats: dto.availability?.totalCapacity,
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
}

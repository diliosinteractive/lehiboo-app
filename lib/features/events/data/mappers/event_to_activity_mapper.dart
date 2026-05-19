import '../../../../core/l10n/l10n.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/taxonomy.dart';
import '../../../../domain/entities/city.dart';
import '../../../../domain/entities/partner.dart';
import '../../domain/entities/event.dart';

/// Maps Event entities (from real API) to Activity entities (used by existing widgets)
class EventToActivityMapper {
  static Activity toActivity(Event event) {
    // Map EventCategory to Category
    // Use raw API data for unrecognized slugs so the badge still shows
    Category? category;
    if (event.category != EventCategory.other) {
      category = Category(
        id: event.category.index.toString(),
        slug: event.rawCategorySlug ?? _categoryToSlug(event.category),
        name: _categoryLabel(event.category),
      );
    } else if (event.rawCategorySlug != null &&
        event.rawCategorySlug!.isNotEmpty) {
      final name = event.allCategoryNames.isNotEmpty
          ? event.allCategoryNames.first
          : _slugToDisplayName(event.rawCategorySlug!);
      category = Category(
        id: 'other',
        slug: event.rawCategorySlug!,
        name: name,
      );
    }

    // Map tags
    List<Tag>? tags;
    if (event.tags.isNotEmpty) {
      tags = event.tags
          .map((tag) => Tag(
                id: tag.hashCode.toString(),
                slug: tag.toLowerCase().replaceAll(' ', '-'),
                name: tag,
              ))
          .toList();
    }

    // Map city
    City? city;
    if (event.city.isNotEmpty) {
      city = City(
        id: event.city.hashCode.toString(),
        name: event.city,
        slug: event.city.toLowerCase().replaceAll(' ', '-'),
        lat: event.latitude,
        lng: event.longitude,
      );
    }

    // Always populate from event dates. Used as the event's primary slot
    // reference (date display, capacity, pricing) — not "next upcoming slot".
    // Past events surface in the personalized feed (strata 3 & 4 — reminders
    // and favourites have no future-slot filter) and need their date shown.
    final nextSlot = Slot(
      id: '${event.id}_slot',
      activityId: event.id,
      startDateTime: event.startDate,
      endDateTime: event.endDate,
      capacityTotal: event.totalSeats,
      capacityRemaining: event.availableSeats,
      priceMin: event.minPrice ?? event.price,
      priceMax: event.maxPrice ?? event.price,
      currency: 'EUR',
      indoorOutdoor: event.isIndoor && event.isOutdoor
          ? IndoorOutdoor.both
          : event.isIndoor
              ? IndoorOutdoor.indoor
              : IndoorOutdoor.outdoor,
      status: _eventStatusToSlotStatus(event.status),
    );

    // Booking-vs-discovery is the signal the cards use to decide whether
    // to show a "À partir de …" price label. Without this, paid booking
    // events on the home feed silently render no price at all because
    // the EventCard's `isBooking` check defaults to false.
    final ReservationMode? reservationMode = event.hasDirectBooking
        ? (event.isFree
            ? ReservationMode.lehibooFree
            : ReservationMode.lehibooPaid)
        : null;

    return Activity(
      id: event.id,
      title: event.title,
      slug: event.slug,
      description: event.description,
      excerpt: event.shortDescription,
      imageUrl: event.coverImage ??
          (event.images.isNotEmpty ? event.images.first : null),
      category: category,
      tags: tags,
      isFree: event.isFree,
      priceMin: event.minPrice ?? event.price,
      priceMax: event.maxPrice ?? event.price,
      currency: 'EUR',
      reservationMode: reservationMode,
      indoorOutdoor: event.isIndoor && event.isOutdoor
          ? IndoorOutdoor.both
          : event.isIndoor
              ? IndoorOutdoor.indoor
              : IndoorOutdoor.outdoor,
      durationMinutes: event.duration?.inMinutes,
      city: city,
      partner: Partner(
        id: event.organizerId,
        name: event.organizerName,
        logoUrl: event.organizerLogo,
        description: event.organizerDescription,
        email: event.contactEmail,
        phone: event.contactPhone,
        website: event.website,
      ),
      nextSlot: nextSlot,
      rating: event.rating,
      reviewsCount: event.reviewsCount,
      isMembersOnly: event.isMembersOnly,
    );
  }

  static List<Activity> toActivities(List<Event> events) {
    return events.map(toActivity).toList();
  }

  static String _categoryToSlug(EventCategory category) {
    switch (category) {
      case EventCategory.show:
        return 'spectacle';
      case EventCategory.workshop:
        return 'atelier';
      case EventCategory.sport:
        return 'sport';
      case EventCategory.culture:
        return 'culture';
      case EventCategory.market:
        return 'marche';
      case EventCategory.leisure:
        return 'loisirs';
      case EventCategory.outdoor:
        return 'plein-air';
      case EventCategory.indoor:
        return 'interieur';
      case EventCategory.festival:
        return 'festival';
      case EventCategory.exhibition:
        return 'exposition';
      case EventCategory.concert:
        return 'concert';
      case EventCategory.theater:
        return 'theatre';
      case EventCategory.cinema:
        return 'cinema';
      case EventCategory.other:
        return 'autre';
    }
  }

  static String _categoryLabel(EventCategory category) {
    final l10n = cachedAppLocalizations();
    return switch (category) {
      EventCategory.workshop => l10n.eventCategoryWorkshop,
      EventCategory.show => l10n.eventCategoryShow,
      EventCategory.festival => l10n.eventCategoryFestival,
      EventCategory.concert => l10n.eventCategoryConcert,
      EventCategory.exhibition => l10n.eventCategoryExhibition,
      EventCategory.sport => l10n.eventCategorySport,
      EventCategory.culture => l10n.eventCategoryCulture,
      EventCategory.market => l10n.eventCategoryMarket,
      EventCategory.leisure => l10n.eventCategoryLeisure,
      EventCategory.outdoor => l10n.eventCategoryOutdoor,
      EventCategory.indoor => l10n.eventCategoryIndoor,
      EventCategory.theater => l10n.eventCategoryTheater,
      EventCategory.cinema => l10n.eventCategoryCinema,
      EventCategory.other => l10n.eventCategoryOther,
    };
  }

  /// Convert a slug like "bien-etre" to a display name "Bien etre"
  static String _slugToDisplayName(String slug) {
    return slug
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static String _eventStatusToSlotStatus(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'scheduled';
      case EventStatus.ongoing:
        return 'scheduled';
      case EventStatus.completed:
        return 'completed';
      case EventStatus.cancelled:
        return 'cancelled';
      case EventStatus.postponed:
        return 'cancelled';
      case EventStatus.soldOut:
        return 'sold_out';
    }
  }
}

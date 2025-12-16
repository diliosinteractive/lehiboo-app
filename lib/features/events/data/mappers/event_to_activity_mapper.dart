import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/taxonomy.dart';
import '../../../../domain/entities/city.dart';
import '../../../../domain/entities/partner.dart';
import '../../domain/entities/event.dart';

/// Maps Event entities (from real API) to Activity entities (used by existing widgets)
class EventToActivityMapper {
  static Activity toActivity(Event event) {
    // Map EventCategory to Category
    Category? category;
    if (event.category != EventCategory.other) {
      category = Category(
        id: event.category.index.toString(),
        slug: event.rawCategorySlug ?? _categoryToSlug(event.category),
        name: event.categoryLabel,
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

    // Create slot from event dates
    Slot? nextSlot;
    if (event.startDate.isAfter(DateTime.now()) ||
        event.startDate.day == DateTime.now().day) {
      nextSlot = Slot(
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
    }

    return Activity(
      id: event.id,
      title: event.title,
      slug: event.title.toLowerCase().replaceAll(' ', '-'),
      description: event.description,
      excerpt: event.shortDescription,
      imageUrl: event.coverImage ?? (event.images.isNotEmpty ? event.images.first : null),
      category: category,
      tags: tags,
      isFree: event.isFree,
      priceMin: event.minPrice ?? event.price ?? 0,
      priceMax: event.maxPrice ?? event.price ?? 0,
      currency: 'EUR',
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

import 'package:equatable/equatable.dart';

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

enum EventAudience {
  all,
  family,
  children,
  teenagers,
  adults,
  seniors
}

enum EventStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
  postponed,
  soldOut
}

enum PriceType {
  free,
  paid,
  donation,
  variable
}

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
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
  final bool isFavorite;
  final bool isFeatured;
  final bool isRecommended;
  final EventStatus status;
  final String? bookingUrl;
  final bool hasDirectBooking;
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

  const Event({
    required this.id,
    required this.title,
    required this.description,
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
    required this.isFavorite,
    required this.isFeatured,
    required this.isRecommended,
    required this.status,
    this.bookingUrl,
    required this.hasDirectBooking,
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
  });

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

  Event copyWith({
    String? id,
    String? title,
    String? description,
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
    bool? isFavorite,
    bool? isFeatured,
    bool? isRecommended,
    EventStatus? status,
    String? bookingUrl,
    bool? hasDirectBooking,
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
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
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
      isFavorite: isFavorite ?? this.isFavorite,
      isFeatured: isFeatured ?? this.isFeatured,
      isRecommended: isRecommended ?? this.isRecommended,
      status: status ?? this.status,
      bookingUrl: bookingUrl ?? this.bookingUrl,
      hasDirectBooking: hasDirectBooking ?? this.hasDirectBooking,
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
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
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
        isFavorite,
        isFeatured,
        isRecommended,
        status,
        bookingUrl,
        hasDirectBooking,
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
      ];
}
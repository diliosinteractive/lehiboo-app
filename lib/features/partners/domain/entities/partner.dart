import 'package:equatable/equatable.dart';

enum PartnerType {
  association,
  venue, // Salle de spectacle
  organizer,
  company,
  individual,
  municipality // Mairie
}

enum SubscriptionPlan {
  free,
  basic,
  premium,
  enterprise
}

class Partner extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? description;
  final String? logo;
  final String? coverImage;
  final PartnerType type;
  final SubscriptionPlan subscriptionPlan;
  final DateTime? subscriptionExpiresAt;
  final String? website;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final List<String> eventIds;
  final Map<String, dynamic>? socialMediaLinks;
  final bool isVerified;
  final double? rating;
  final int? reviewsCount;
  final int totalEvents;
  final int activeEvents;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? analytics;
  final Map<String, dynamic>? billingInfo;
  final List<String>? adminUserIds;
  final Map<String, dynamic>? settings;
  final bool canCreateEvents;
  final int? maxEventsPerMonth;
  final bool hasHighlighting; // Mise en avant
  final bool hasBilleting; // Billetterie intégrée
  final bool hasAdvancedAnalytics;
  final Map<String, dynamic>? metadata;

  const Partner({
    required this.id,
    required this.name,
    required this.email,
    this.description,
    this.logo,
    this.coverImage,
    required this.type,
    required this.subscriptionPlan,
    this.subscriptionExpiresAt,
    this.website,
    this.phoneNumber,
    this.address,
    this.city,
    this.postalCode,
    this.latitude,
    this.longitude,
    required this.eventIds,
    this.socialMediaLinks,
    required this.isVerified,
    this.rating,
    this.reviewsCount,
    required this.totalEvents,
    required this.activeEvents,
    required this.createdAt,
    required this.updatedAt,
    this.analytics,
    this.billingInfo,
    this.adminUserIds,
    this.settings,
    required this.canCreateEvents,
    this.maxEventsPerMonth,
    required this.hasHighlighting,
    required this.hasBilleting,
    required this.hasAdvancedAnalytics,
    this.metadata,
  });

  bool get isPremium => subscriptionPlan == SubscriptionPlan.premium ||
                         subscriptionPlan == SubscriptionPlan.enterprise;

  bool get isSubscriptionActive {
    if (subscriptionPlan == SubscriptionPlan.free) return true;
    if (subscriptionExpiresAt == null) return false;
    return subscriptionExpiresAt!.isAfter(DateTime.now());
  }

  String get typeLabel {
    switch (type) {
      case PartnerType.association:
        return 'Association';
      case PartnerType.venue:
        return 'Salle/Lieu';
      case PartnerType.organizer:
        return 'Organisateur';
      case PartnerType.company:
        return 'Entreprise';
      case PartnerType.individual:
        return 'Particulier';
      case PartnerType.municipality:
        return 'Municipalité';
    }
  }

  String get subscriptionLabel {
    switch (subscriptionPlan) {
      case SubscriptionPlan.free:
        return 'Gratuit';
      case SubscriptionPlan.basic:
        return 'Basique';
      case SubscriptionPlan.premium:
        return 'Premium';
      case SubscriptionPlan.enterprise:
        return 'Enterprise';
    }
  }

  Partner copyWith({
    String? id,
    String? name,
    String? email,
    String? description,
    String? logo,
    String? coverImage,
    PartnerType? type,
    SubscriptionPlan? subscriptionPlan,
    DateTime? subscriptionExpiresAt,
    String? website,
    String? phoneNumber,
    String? address,
    String? city,
    String? postalCode,
    double? latitude,
    double? longitude,
    List<String>? eventIds,
    Map<String, dynamic>? socialMediaLinks,
    bool? isVerified,
    double? rating,
    int? reviewsCount,
    int? totalEvents,
    int? activeEvents,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? analytics,
    Map<String, dynamic>? billingInfo,
    List<String>? adminUserIds,
    Map<String, dynamic>? settings,
    bool? canCreateEvents,
    int? maxEventsPerMonth,
    bool? hasHighlighting,
    bool? hasBilleting,
    bool? hasAdvancedAnalytics,
    Map<String, dynamic>? metadata,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      type: type ?? this.type,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      website: website ?? this.website,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      eventIds: eventIds ?? this.eventIds,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      totalEvents: totalEvents ?? this.totalEvents,
      activeEvents: activeEvents ?? this.activeEvents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      analytics: analytics ?? this.analytics,
      billingInfo: billingInfo ?? this.billingInfo,
      adminUserIds: adminUserIds ?? this.adminUserIds,
      settings: settings ?? this.settings,
      canCreateEvents: canCreateEvents ?? this.canCreateEvents,
      maxEventsPerMonth: maxEventsPerMonth ?? this.maxEventsPerMonth,
      hasHighlighting: hasHighlighting ?? this.hasHighlighting,
      hasBilleting: hasBilleting ?? this.hasBilleting,
      hasAdvancedAnalytics: hasAdvancedAnalytics ?? this.hasAdvancedAnalytics,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        description,
        logo,
        coverImage,
        type,
        subscriptionPlan,
        subscriptionExpiresAt,
        website,
        phoneNumber,
        address,
        city,
        postalCode,
        latitude,
        longitude,
        eventIds,
        socialMediaLinks,
        isVerified,
        rating,
        reviewsCount,
        totalEvents,
        activeEvents,
        createdAt,
        updatedAt,
        analytics,
        billingInfo,
        adminUserIds,
        settings,
        canCreateEvents,
        maxEventsPerMonth,
        hasHighlighting,
        hasBilleting,
        hasAdvancedAnalytics,
        metadata,
      ];
}
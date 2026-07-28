import 'package:freezed_annotation/freezed_annotation.dart';
import 'taxonomy.dart';
import 'city.dart';
import 'partner.dart';

part 'activity.freezed.dart';

enum IndoorOutdoor { indoor, outdoor, both }

enum ReservationMode {
  lehibooFree,
  lehibooPaid,
  externalUrl,
  phone,
  email,
}

/// Authoritative pricing classification for discovery-mode events.
///
/// The API exposes this as `discovery_pricing_type` with the values
/// `free` and `paid`. Keep it separate from numeric prices: discovery
/// prices can be incomplete or indicative and must not determine whether
/// the event is free.
enum DiscoveryPricingType { free, paid }

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String title,
    required String slug,
    required String description,
    String? excerpt,
    String? imageUrl,
    Category? category,
    List<Tag>? tags,
    AgeRange? ageRange,
    Audience? audience,
    bool? isFree,
    double? priceMin,
    double? priceMax,
    String? currency,
    IndoorOutdoor? indoorOutdoor,
    int? durationMinutes,
    City? city,
    Partner? partner,
    DiscoveryPricingType? discoveryPricingType,
    ReservationMode? reservationMode,
    String? externalBookingUrl,
    String? bookingPhone,
    String? bookingEmail,
    Slot? nextSlot,
    double? rating,
    int? reviewsCount,

    /// Members-only event — drives the "Privé 🔒" badge on event cards.
    /// Spec: MEMBERSHIPS_MOBILE_SPEC.md §20.
    @Default(false) bool isMembersOnly,
  }) = _Activity;
}

extension ActivityPricingX on Activity {
  bool get isBookingActivity =>
      reservationMode == ReservationMode.lehibooFree ||
      reservationMode == ReservationMode.lehibooPaid;

  /// Whether a discovery activity is authoritatively classified as free.
  ///
  /// Unknown/null values deliberately remain non-free rather than falling
  /// back to potentially misleading min/max prices.
  bool get isFreeDiscovery =>
      !isBookingActivity && discoveryPricingType == DiscoveryPricingType.free;

  /// Mode-aware free classification used by listing, filtering, and
  /// synthetic Activity-to-Event conversions.
  bool get isAuthoritativelyFree =>
      isBookingActivity ? isFree == true : isFreeDiscovery;
}

@freezed
class Slot with _$Slot {
  const factory Slot({
    required String id,
    required String activityId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    int? capacityTotal,
    int? capacityRemaining,
    double? priceMin,
    double? priceMax,
    String? currency,
    IndoorOutdoor? indoorOutdoor,
    String? status, // scheduled, cancelled, sold_out
  }) = _Slot;
}

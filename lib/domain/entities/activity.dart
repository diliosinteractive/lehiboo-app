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
    ReservationMode? reservationMode,
    String? externalBookingUrl,
    String? bookingPhone,
    String? bookingEmail,
    Slot? nextSlot,
  }) = _Activity;
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

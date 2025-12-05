import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_dto.freezed.dart';
part 'activity_dto.g.dart';

@freezed
class ActivityDto with _$ActivityDto {
  const factory ActivityDto({
    required int id,
    required String title,
    required String slug,
    String? excerpt,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    ActivityCategoryDto? category,
    List<TagDto>? tags,
    AgeRangeDto? ageRange,
    AudienceDto? audience,
    @JsonKey(name: 'is_free') bool? isFree,
    PriceDto? price,
    @JsonKey(name: 'indoor_outdoor') String? indoorOutdoor,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    CityDto? city,
    PartnerDto? partner,
    @JsonKey(name: 'reservation_mode') String? reservationMode,
    @JsonKey(name: 'external_booking_url') String? externalBookingUrl,
    @JsonKey(name: 'booking_phone') String? bookingPhone,
    @JsonKey(name: 'booking_email') String? bookingEmail,
    @JsonKey(name: 'next_slot') SlotDto? nextSlot,
  }) = _ActivityDto;

  factory ActivityDto.fromJson(Map<String, dynamic> json) => _$ActivityDtoFromJson(json);
}

@freezed
class PriceDto with _$PriceDto {
  const factory PriceDto({
    double? min,
    double? max,
    String? currency,
  }) = _PriceDto;

  factory PriceDto.fromJson(Map<String, dynamic> json) => _$PriceDtoFromJson(json);
}

@freezed
class SlotDto with _$SlotDto {
  const factory SlotDto({
    required int id,
    @JsonKey(name: 'activity_id') required int activityId,
    @JsonKey(name: 'start_date_time') required DateTime startDateTime,
    @JsonKey(name: 'end_date_time') required DateTime endDateTime,
    @JsonKey(name: 'capacity_total') int? capacityTotal,
    @JsonKey(name: 'capacity_remaining') int? capacityRemaining,
    PriceDto? price,
    @JsonKey(name: 'indoor_outdoor') String? indoorOutdoor,
    String? status,
  }) = _SlotDto;

  factory SlotDto.fromJson(Map<String, dynamic> json) => _$SlotDtoFromJson(json);
}

@freezed
class ActivityCategoryDto with _$ActivityCategoryDto {
  const factory ActivityCategoryDto({
    required int id,
    required String slug,
    required String name,
  }) = _ActivityCategoryDto;

  factory ActivityCategoryDto.fromJson(Map<String, dynamic> json) => _$ActivityCategoryDtoFromJson(json);
}

@freezed
class TagDto with _$TagDto {
  const factory TagDto({
    required int id,
    required String slug,
    required String name,
  }) = _TagDto;

  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);
}

@freezed
class AgeRangeDto with _$AgeRangeDto {
  const factory AgeRangeDto({
    required int id,
    required String label,
    @JsonKey(name: 'min_age') int? minAge,
    @JsonKey(name: 'max_age') int? maxAge,
  }) = _AgeRangeDto;

  factory AgeRangeDto.fromJson(Map<String, dynamic> json) => _$AgeRangeDtoFromJson(json);
}

@freezed
class AudienceDto with _$AudienceDto {
  const factory AudienceDto({
    required int id,
    required String slug,
    required String name,
  }) = _AudienceDto;

  factory AudienceDto.fromJson(Map<String, dynamic> json) => _$AudienceDtoFromJson(json);
}

@freezed
class CityDto with _$CityDto {
  const factory CityDto({
    required int id,
    required String name,
    required String slug,
    double? lat,
    double? lng,
    String? region,
  }) = _CityDto;

  factory CityDto.fromJson(Map<String, dynamic> json) => _$CityDtoFromJson(json);
}

@freezed
class PartnerDto with _$PartnerDto {
  const factory PartnerDto({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'city_id') int? cityId,
    String? website,
    String? email,
    String? phone,
    bool? verified,
  }) = _PartnerDto;

  factory PartnerDto.fromJson(Map<String, dynamic> json) => _$PartnerDtoFromJson(json);
}

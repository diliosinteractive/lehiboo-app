import 'package:freezed_annotation/freezed_annotation.dart';
import 'event_dto.dart';

part 'home_feed_response_dto.freezed.dart';
part 'home_feed_response_dto.g.dart';

@freezed
class HomeFeedResponseDto with _$HomeFeedResponseDto {
  const factory HomeFeedResponseDto({
    required bool success,
    HomeFeedDataDto? data,
  }) = _HomeFeedResponseDto;

  factory HomeFeedResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedResponseDtoFromJson(json);
}

@freezed
class HomeFeedDataDto with _$HomeFeedDataDto {
  const factory HomeFeedDataDto({
    @Default([]) List<EventDto> today,
    @Default([]) List<EventDto> tomorrow,
    @Default([]) List<EventDto> recommended,
    @JsonKey(name: 'location_provided') @Default(false) bool locationProvided,
  }) = _HomeFeedDataDto;

  factory HomeFeedDataDto.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedDataDtoFromJson(json);
}

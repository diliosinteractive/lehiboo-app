// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeFeedResponseDtoImpl _$$HomeFeedResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeFeedResponseDtoImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : HomeFeedDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomeFeedResponseDtoImplToJson(
        _$HomeFeedResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

_$HomeFeedDataDtoImpl _$$HomeFeedDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeFeedDataDtoImpl(
      today: (json['today'] as List<dynamic>?)
              ?.map((e) => EventDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tomorrow: (json['tomorrow'] as List<dynamic>?)
              ?.map((e) => EventDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recommended: (json['recommended'] as List<dynamic>?)
              ?.map((e) => EventDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      locationProvided: json['location_provided'] as bool? ?? false,
    );

Map<String, dynamic> _$$HomeFeedDataDtoImplToJson(
        _$HomeFeedDataDtoImpl instance) =>
    <String, dynamic>{
      'today': instance.today,
      'tomorrow': instance.tomorrow,
      'recommended': instance.recommended,
      'location_provided': instance.locationProvided,
    };

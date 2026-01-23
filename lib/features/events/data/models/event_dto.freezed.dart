// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventDto _$EventDtoFromJson(Map<String, dynamic> json) {
  return _EventDto.fromJson(json);
}

/// @nodoc
mixin _$EventDto {
  @JsonKey(fromJson: _parseEventId)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get uuid => throw _privateConstructorUsedError; // UUID from API
  @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull)
  int? get internalId =>
      throw _privateConstructorUsedError; // Integer ID from API
  @JsonKey(fromJson: _parseHtmlString)
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String? get excerpt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String? get content =>
      throw _privateConstructorUsedError; // Full HTML description
  @JsonKey(name: 'featured_image', fromJson: _parseImage)
  EventImageDto? get featuredImage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get thumbnail =>
      throw _privateConstructorUsedError; // Alternative image field from organizer events API
  @JsonKey(fromJson: _parseGallery)
  List<String>? get gallery =>
      throw _privateConstructorUsedError; // Image gallery URLs
  EventCategoryDto? get category => throw _privateConstructorUsedError;
  ThematiqueDto? get thematique =>
      throw _privateConstructorUsedError; // Main thematique
  EventDatesDto? get dates => throw _privateConstructorUsedError;
  EventLocationDto? get location => throw _privateConstructorUsedError;
  EventPricingDto? get pricing => throw _privateConstructorUsedError;
  EventAvailabilityDto? get availability => throw _privateConstructorUsedError;
  dynamic get ratings => throw _privateConstructorUsedError;
  EventOrganizerDto? get organizer => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringList)
  List<String>? get tags =>
      throw _privateConstructorUsedError; // New fields for V2 API
  @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
  List<dynamic>? get ticketTypes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseListOrNull)
  List<dynamic>? get tickets => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get timeSlots => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseMapOrNull)
  Map<String, dynamic>? get calendar => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseMapOrNull)
  Map<String, dynamic>? get recurrence => throw _privateConstructorUsedError;
  @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
  List<dynamic>? get extraServices => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseListOrNull)
  List<dynamic>? get coupons => throw _privateConstructorUsedError;
  @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get seatConfig => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get externalBooking =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get eventType => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
  List<dynamic>? get targetAudience =>
      throw _privateConstructorUsedError; // Rich Content V2
  @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get locationDetails =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
  List<CoOrganizerDto>? get coOrganizers => throw _privateConstructorUsedError;
  @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get socialMedia => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventDtoCopyWith<EventDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDtoCopyWith<$Res> {
  factory $EventDtoCopyWith(EventDto value, $Res Function(EventDto) then) =
      _$EventDtoCopyWithImpl<$Res, EventDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseEventId) int id,
      @JsonKey(fromJson: _parseStringOrNull) String? uuid,
      @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull) int? internalId,
      @JsonKey(fromJson: _parseHtmlString) String title,
      @JsonKey(fromJson: _parseHtmlString) String slug,
      @JsonKey(fromJson: _parseHtmlString) String? excerpt,
      @JsonKey(fromJson: _parseHtmlString) String? content,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      EventImageDto? featuredImage,
      @JsonKey(fromJson: _parseStringOrNull) String? thumbnail,
      @JsonKey(fromJson: _parseGallery) List<String>? gallery,
      EventCategoryDto? category,
      ThematiqueDto? thematique,
      EventDatesDto? dates,
      EventLocationDto? location,
      EventPricingDto? pricing,
      EventAvailabilityDto? availability,
      dynamic ratings,
      EventOrganizerDto? organizer,
      @JsonKey(fromJson: _parseStringList) List<String>? tags,
      @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
      List<dynamic>? ticketTypes,
      @JsonKey(fromJson: _parseListOrNull) List<dynamic>? tickets,
      @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
      Map<String, dynamic>? timeSlots,
      @JsonKey(fromJson: _parseMapOrNull) Map<String, dynamic>? calendar,
      @JsonKey(fromJson: _parseMapOrNull) Map<String, dynamic>? recurrence,
      @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
      List<dynamic>? extraServices,
      @JsonKey(fromJson: _parseListOrNull) List<dynamic>? coupons,
      @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
      Map<String, dynamic>? seatConfig,
      @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
      Map<String, dynamic>? externalBooking,
      @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
      Map<String, dynamic>? eventType,
      @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
      List<dynamic>? targetAudience,
      @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
      Map<String, dynamic>? locationDetails,
      @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
      List<CoOrganizerDto>? coOrganizers,
      @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
      Map<String, dynamic>? socialMedia,
      @JsonKey(name: 'is_favorite') bool isFavorite});

  $EventImageDtoCopyWith<$Res>? get featuredImage;
  $EventCategoryDtoCopyWith<$Res>? get category;
  $ThematiqueDtoCopyWith<$Res>? get thematique;
  $EventDatesDtoCopyWith<$Res>? get dates;
  $EventLocationDtoCopyWith<$Res>? get location;
  $EventPricingDtoCopyWith<$Res>? get pricing;
  $EventAvailabilityDtoCopyWith<$Res>? get availability;
  $EventOrganizerDtoCopyWith<$Res>? get organizer;
}

/// @nodoc
class _$EventDtoCopyWithImpl<$Res, $Val extends EventDto>
    implements $EventDtoCopyWith<$Res> {
  _$EventDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? internalId = freezed,
    Object? title = null,
    Object? slug = null,
    Object? excerpt = freezed,
    Object? content = freezed,
    Object? featuredImage = freezed,
    Object? thumbnail = freezed,
    Object? gallery = freezed,
    Object? category = freezed,
    Object? thematique = freezed,
    Object? dates = freezed,
    Object? location = freezed,
    Object? pricing = freezed,
    Object? availability = freezed,
    Object? ratings = freezed,
    Object? organizer = freezed,
    Object? tags = freezed,
    Object? ticketTypes = freezed,
    Object? tickets = freezed,
    Object? timeSlots = freezed,
    Object? calendar = freezed,
    Object? recurrence = freezed,
    Object? extraServices = freezed,
    Object? coupons = freezed,
    Object? seatConfig = freezed,
    Object? externalBooking = freezed,
    Object? eventType = freezed,
    Object? targetAudience = freezed,
    Object? locationDetails = freezed,
    Object? coOrganizers = freezed,
    Object? socialMedia = freezed,
    Object? isFavorite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      internalId: freezed == internalId
          ? _value.internalId
          : internalId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as EventImageDto?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      gallery: freezed == gallery
          ? _value.gallery
          : gallery // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EventCategoryDto?,
      thematique: freezed == thematique
          ? _value.thematique
          : thematique // ignore: cast_nullable_to_non_nullable
              as ThematiqueDto?,
      dates: freezed == dates
          ? _value.dates
          : dates // ignore: cast_nullable_to_non_nullable
              as EventDatesDto?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as EventLocationDto?,
      pricing: freezed == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as EventPricingDto?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as EventAvailabilityDto?,
      ratings: freezed == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as dynamic,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as EventOrganizerDto?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ticketTypes: freezed == ticketTypes
          ? _value.ticketTypes
          : ticketTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      tickets: freezed == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      timeSlots: freezed == timeSlots
          ? _value.timeSlots
          : timeSlots // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      calendar: freezed == calendar
          ? _value.calendar
          : calendar // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extraServices: freezed == extraServices
          ? _value.extraServices
          : extraServices // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      coupons: freezed == coupons
          ? _value.coupons
          : coupons // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      seatConfig: freezed == seatConfig
          ? _value.seatConfig
          : seatConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      externalBooking: freezed == externalBooking
          ? _value.externalBooking
          : externalBooking // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      targetAudience: freezed == targetAudience
          ? _value.targetAudience
          : targetAudience // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      locationDetails: freezed == locationDetails
          ? _value.locationDetails
          : locationDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      coOrganizers: freezed == coOrganizers
          ? _value.coOrganizers
          : coOrganizers // ignore: cast_nullable_to_non_nullable
              as List<CoOrganizerDto>?,
      socialMedia: freezed == socialMedia
          ? _value.socialMedia
          : socialMedia // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventImageDtoCopyWith<$Res>? get featuredImage {
    if (_value.featuredImage == null) {
      return null;
    }

    return $EventImageDtoCopyWith<$Res>(_value.featuredImage!, (value) {
      return _then(_value.copyWith(featuredImage: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCategoryDtoCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $EventCategoryDtoCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ThematiqueDtoCopyWith<$Res>? get thematique {
    if (_value.thematique == null) {
      return null;
    }

    return $ThematiqueDtoCopyWith<$Res>(_value.thematique!, (value) {
      return _then(_value.copyWith(thematique: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventDatesDtoCopyWith<$Res>? get dates {
    if (_value.dates == null) {
      return null;
    }

    return $EventDatesDtoCopyWith<$Res>(_value.dates!, (value) {
      return _then(_value.copyWith(dates: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventLocationDtoCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $EventLocationDtoCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventPricingDtoCopyWith<$Res>? get pricing {
    if (_value.pricing == null) {
      return null;
    }

    return $EventPricingDtoCopyWith<$Res>(_value.pricing!, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventAvailabilityDtoCopyWith<$Res>? get availability {
    if (_value.availability == null) {
      return null;
    }

    return $EventAvailabilityDtoCopyWith<$Res>(_value.availability!, (value) {
      return _then(_value.copyWith(availability: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventOrganizerDtoCopyWith<$Res>? get organizer {
    if (_value.organizer == null) {
      return null;
    }

    return $EventOrganizerDtoCopyWith<$Res>(_value.organizer!, (value) {
      return _then(_value.copyWith(organizer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventDtoImplCopyWith<$Res>
    implements $EventDtoCopyWith<$Res> {
  factory _$$EventDtoImplCopyWith(
          _$EventDtoImpl value, $Res Function(_$EventDtoImpl) then) =
      __$$EventDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseEventId) int id,
      @JsonKey(fromJson: _parseStringOrNull) String? uuid,
      @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull) int? internalId,
      @JsonKey(fromJson: _parseHtmlString) String title,
      @JsonKey(fromJson: _parseHtmlString) String slug,
      @JsonKey(fromJson: _parseHtmlString) String? excerpt,
      @JsonKey(fromJson: _parseHtmlString) String? content,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      EventImageDto? featuredImage,
      @JsonKey(fromJson: _parseStringOrNull) String? thumbnail,
      @JsonKey(fromJson: _parseGallery) List<String>? gallery,
      EventCategoryDto? category,
      ThematiqueDto? thematique,
      EventDatesDto? dates,
      EventLocationDto? location,
      EventPricingDto? pricing,
      EventAvailabilityDto? availability,
      dynamic ratings,
      EventOrganizerDto? organizer,
      @JsonKey(fromJson: _parseStringList) List<String>? tags,
      @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
      List<dynamic>? ticketTypes,
      @JsonKey(fromJson: _parseListOrNull) List<dynamic>? tickets,
      @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
      Map<String, dynamic>? timeSlots,
      @JsonKey(fromJson: _parseMapOrNull) Map<String, dynamic>? calendar,
      @JsonKey(fromJson: _parseMapOrNull) Map<String, dynamic>? recurrence,
      @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
      List<dynamic>? extraServices,
      @JsonKey(fromJson: _parseListOrNull) List<dynamic>? coupons,
      @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
      Map<String, dynamic>? seatConfig,
      @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
      Map<String, dynamic>? externalBooking,
      @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
      Map<String, dynamic>? eventType,
      @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
      List<dynamic>? targetAudience,
      @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
      Map<String, dynamic>? locationDetails,
      @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
      List<CoOrganizerDto>? coOrganizers,
      @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
      Map<String, dynamic>? socialMedia,
      @JsonKey(name: 'is_favorite') bool isFavorite});

  @override
  $EventImageDtoCopyWith<$Res>? get featuredImage;
  @override
  $EventCategoryDtoCopyWith<$Res>? get category;
  @override
  $ThematiqueDtoCopyWith<$Res>? get thematique;
  @override
  $EventDatesDtoCopyWith<$Res>? get dates;
  @override
  $EventLocationDtoCopyWith<$Res>? get location;
  @override
  $EventPricingDtoCopyWith<$Res>? get pricing;
  @override
  $EventAvailabilityDtoCopyWith<$Res>? get availability;
  @override
  $EventOrganizerDtoCopyWith<$Res>? get organizer;
}

/// @nodoc
class __$$EventDtoImplCopyWithImpl<$Res>
    extends _$EventDtoCopyWithImpl<$Res, _$EventDtoImpl>
    implements _$$EventDtoImplCopyWith<$Res> {
  __$$EventDtoImplCopyWithImpl(
      _$EventDtoImpl _value, $Res Function(_$EventDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? internalId = freezed,
    Object? title = null,
    Object? slug = null,
    Object? excerpt = freezed,
    Object? content = freezed,
    Object? featuredImage = freezed,
    Object? thumbnail = freezed,
    Object? gallery = freezed,
    Object? category = freezed,
    Object? thematique = freezed,
    Object? dates = freezed,
    Object? location = freezed,
    Object? pricing = freezed,
    Object? availability = freezed,
    Object? ratings = freezed,
    Object? organizer = freezed,
    Object? tags = freezed,
    Object? ticketTypes = freezed,
    Object? tickets = freezed,
    Object? timeSlots = freezed,
    Object? calendar = freezed,
    Object? recurrence = freezed,
    Object? extraServices = freezed,
    Object? coupons = freezed,
    Object? seatConfig = freezed,
    Object? externalBooking = freezed,
    Object? eventType = freezed,
    Object? targetAudience = freezed,
    Object? locationDetails = freezed,
    Object? coOrganizers = freezed,
    Object? socialMedia = freezed,
    Object? isFavorite = null,
  }) {
    return _then(_$EventDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      internalId: freezed == internalId
          ? _value.internalId
          : internalId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as EventImageDto?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      gallery: freezed == gallery
          ? _value._gallery
          : gallery // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EventCategoryDto?,
      thematique: freezed == thematique
          ? _value.thematique
          : thematique // ignore: cast_nullable_to_non_nullable
              as ThematiqueDto?,
      dates: freezed == dates
          ? _value.dates
          : dates // ignore: cast_nullable_to_non_nullable
              as EventDatesDto?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as EventLocationDto?,
      pricing: freezed == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as EventPricingDto?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as EventAvailabilityDto?,
      ratings: freezed == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as dynamic,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as EventOrganizerDto?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ticketTypes: freezed == ticketTypes
          ? _value._ticketTypes
          : ticketTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      tickets: freezed == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      timeSlots: freezed == timeSlots
          ? _value._timeSlots
          : timeSlots // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      calendar: freezed == calendar
          ? _value._calendar
          : calendar // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      recurrence: freezed == recurrence
          ? _value._recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extraServices: freezed == extraServices
          ? _value._extraServices
          : extraServices // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      coupons: freezed == coupons
          ? _value._coupons
          : coupons // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      seatConfig: freezed == seatConfig
          ? _value._seatConfig
          : seatConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      externalBooking: freezed == externalBooking
          ? _value._externalBooking
          : externalBooking // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      eventType: freezed == eventType
          ? _value._eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      targetAudience: freezed == targetAudience
          ? _value._targetAudience
          : targetAudience // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      locationDetails: freezed == locationDetails
          ? _value._locationDetails
          : locationDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      coOrganizers: freezed == coOrganizers
          ? _value._coOrganizers
          : coOrganizers // ignore: cast_nullable_to_non_nullable
              as List<CoOrganizerDto>?,
      socialMedia: freezed == socialMedia
          ? _value._socialMedia
          : socialMedia // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventDtoImpl implements _EventDto {
  const _$EventDtoImpl(
      {@JsonKey(fromJson: _parseEventId) required this.id,
      @JsonKey(fromJson: _parseStringOrNull) this.uuid,
      @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull) this.internalId,
      @JsonKey(fromJson: _parseHtmlString) required this.title,
      @JsonKey(fromJson: _parseHtmlString) required this.slug,
      @JsonKey(fromJson: _parseHtmlString) this.excerpt,
      @JsonKey(fromJson: _parseHtmlString) this.content,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      this.featuredImage,
      @JsonKey(fromJson: _parseStringOrNull) this.thumbnail,
      @JsonKey(fromJson: _parseGallery) final List<String>? gallery,
      this.category,
      this.thematique,
      this.dates,
      this.location,
      this.pricing,
      this.availability,
      this.ratings,
      this.organizer,
      @JsonKey(fromJson: _parseStringList) final List<String>? tags,
      @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
      final List<dynamic>? ticketTypes,
      @JsonKey(fromJson: _parseListOrNull) final List<dynamic>? tickets,
      @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? timeSlots,
      @JsonKey(fromJson: _parseMapOrNull) final Map<String, dynamic>? calendar,
      @JsonKey(fromJson: _parseMapOrNull)
      final Map<String, dynamic>? recurrence,
      @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
      final List<dynamic>? extraServices,
      @JsonKey(fromJson: _parseListOrNull) final List<dynamic>? coupons,
      @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? seatConfig,
      @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? externalBooking,
      @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? eventType,
      @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
      final List<dynamic>? targetAudience,
      @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? locationDetails,
      @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
      final List<CoOrganizerDto>? coOrganizers,
      @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? socialMedia,
      @JsonKey(name: 'is_favorite') this.isFavorite = false})
      : _gallery = gallery,
        _tags = tags,
        _ticketTypes = ticketTypes,
        _tickets = tickets,
        _timeSlots = timeSlots,
        _calendar = calendar,
        _recurrence = recurrence,
        _extraServices = extraServices,
        _coupons = coupons,
        _seatConfig = seatConfig,
        _externalBooking = externalBooking,
        _eventType = eventType,
        _targetAudience = targetAudience,
        _locationDetails = locationDetails,
        _coOrganizers = coOrganizers,
        _socialMedia = socialMedia;

  factory _$EventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseEventId)
  final int id;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? uuid;
// UUID from API
  @override
  @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull)
  final int? internalId;
// Integer ID from API
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String title;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String slug;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String? excerpt;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String? content;
// Full HTML description
  @override
  @JsonKey(name: 'featured_image', fromJson: _parseImage)
  final EventImageDto? featuredImage;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? thumbnail;
// Alternative image field from organizer events API
  final List<String>? _gallery;
// Alternative image field from organizer events API
  @override
  @JsonKey(fromJson: _parseGallery)
  List<String>? get gallery {
    final value = _gallery;
    if (value == null) return null;
    if (_gallery is EqualUnmodifiableListView) return _gallery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Image gallery URLs
  @override
  final EventCategoryDto? category;
  @override
  final ThematiqueDto? thematique;
// Main thematique
  @override
  final EventDatesDto? dates;
  @override
  final EventLocationDto? location;
  @override
  final EventPricingDto? pricing;
  @override
  final EventAvailabilityDto? availability;
  @override
  final dynamic ratings;
  @override
  final EventOrganizerDto? organizer;
  final List<String>? _tags;
  @override
  @JsonKey(fromJson: _parseStringList)
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// New fields for V2 API
  final List<dynamic>? _ticketTypes;
// New fields for V2 API
  @override
  @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
  List<dynamic>? get ticketTypes {
    final value = _ticketTypes;
    if (value == null) return null;
    if (_ticketTypes is EqualUnmodifiableListView) return _ticketTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _tickets;
  @override
  @JsonKey(fromJson: _parseListOrNull)
  List<dynamic>? get tickets {
    final value = _tickets;
    if (value == null) return null;
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _timeSlots;
  @override
  @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get timeSlots {
    final value = _timeSlots;
    if (value == null) return null;
    if (_timeSlots is EqualUnmodifiableMapView) return _timeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _calendar;
  @override
  @JsonKey(fromJson: _parseMapOrNull)
  Map<String, dynamic>? get calendar {
    final value = _calendar;
    if (value == null) return null;
    if (_calendar is EqualUnmodifiableMapView) return _calendar;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _recurrence;
  @override
  @JsonKey(fromJson: _parseMapOrNull)
  Map<String, dynamic>? get recurrence {
    final value = _recurrence;
    if (value == null) return null;
    if (_recurrence is EqualUnmodifiableMapView) return _recurrence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<dynamic>? _extraServices;
  @override
  @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
  List<dynamic>? get extraServices {
    final value = _extraServices;
    if (value == null) return null;
    if (_extraServices is EqualUnmodifiableListView) return _extraServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _coupons;
  @override
  @JsonKey(fromJson: _parseListOrNull)
  List<dynamic>? get coupons {
    final value = _coupons;
    if (value == null) return null;
    if (_coupons is EqualUnmodifiableListView) return _coupons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _seatConfig;
  @override
  @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get seatConfig {
    final value = _seatConfig;
    if (value == null) return null;
    if (_seatConfig is EqualUnmodifiableMapView) return _seatConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _externalBooking;
  @override
  @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get externalBooking {
    final value = _externalBooking;
    if (value == null) return null;
    if (_externalBooking is EqualUnmodifiableMapView) return _externalBooking;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _eventType;
  @override
  @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get eventType {
    final value = _eventType;
    if (value == null) return null;
    if (_eventType is EqualUnmodifiableMapView) return _eventType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<dynamic>? _targetAudience;
  @override
  @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
  List<dynamic>? get targetAudience {
    final value = _targetAudience;
    if (value == null) return null;
    if (_targetAudience is EqualUnmodifiableListView) return _targetAudience;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Rich Content V2
  final Map<String, dynamic>? _locationDetails;
// Rich Content V2
  @override
  @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get locationDetails {
    final value = _locationDetails;
    if (value == null) return null;
    if (_locationDetails is EqualUnmodifiableMapView) return _locationDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<CoOrganizerDto>? _coOrganizers;
  @override
  @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
  List<CoOrganizerDto>? get coOrganizers {
    final value = _coOrganizers;
    if (value == null) return null;
    if (_coOrganizers is EqualUnmodifiableListView) return _coOrganizers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _socialMedia;
  @override
  @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get socialMedia {
    final value = _socialMedia;
    if (value == null) return null;
    if (_socialMedia is EqualUnmodifiableMapView) return _socialMedia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  @override
  String toString() {
    return 'EventDto(id: $id, uuid: $uuid, internalId: $internalId, title: $title, slug: $slug, excerpt: $excerpt, content: $content, featuredImage: $featuredImage, thumbnail: $thumbnail, gallery: $gallery, category: $category, thematique: $thematique, dates: $dates, location: $location, pricing: $pricing, availability: $availability, ratings: $ratings, organizer: $organizer, tags: $tags, ticketTypes: $ticketTypes, tickets: $tickets, timeSlots: $timeSlots, calendar: $calendar, recurrence: $recurrence, extraServices: $extraServices, coupons: $coupons, seatConfig: $seatConfig, externalBooking: $externalBooking, eventType: $eventType, targetAudience: $targetAudience, locationDetails: $locationDetails, coOrganizers: $coOrganizers, socialMedia: $socialMedia, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.internalId, internalId) ||
                other.internalId == internalId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.featuredImage, featuredImage) ||
                other.featuredImage == featuredImage) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            const DeepCollectionEquality().equals(other._gallery, _gallery) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.thematique, thematique) ||
                other.thematique == thematique) &&
            (identical(other.dates, dates) || other.dates == dates) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            const DeepCollectionEquality().equals(other.ratings, ratings) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._ticketTypes, _ticketTypes) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            const DeepCollectionEquality()
                .equals(other._timeSlots, _timeSlots) &&
            const DeepCollectionEquality().equals(other._calendar, _calendar) &&
            const DeepCollectionEquality()
                .equals(other._recurrence, _recurrence) &&
            const DeepCollectionEquality()
                .equals(other._extraServices, _extraServices) &&
            const DeepCollectionEquality().equals(other._coupons, _coupons) &&
            const DeepCollectionEquality()
                .equals(other._seatConfig, _seatConfig) &&
            const DeepCollectionEquality()
                .equals(other._externalBooking, _externalBooking) &&
            const DeepCollectionEquality()
                .equals(other._eventType, _eventType) &&
            const DeepCollectionEquality()
                .equals(other._targetAudience, _targetAudience) &&
            const DeepCollectionEquality()
                .equals(other._locationDetails, _locationDetails) &&
            const DeepCollectionEquality()
                .equals(other._coOrganizers, _coOrganizers) &&
            const DeepCollectionEquality()
                .equals(other._socialMedia, _socialMedia) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        uuid,
        internalId,
        title,
        slug,
        excerpt,
        content,
        featuredImage,
        thumbnail,
        const DeepCollectionEquality().hash(_gallery),
        category,
        thematique,
        dates,
        location,
        pricing,
        availability,
        const DeepCollectionEquality().hash(ratings),
        organizer,
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_ticketTypes),
        const DeepCollectionEquality().hash(_tickets),
        const DeepCollectionEquality().hash(_timeSlots),
        const DeepCollectionEquality().hash(_calendar),
        const DeepCollectionEquality().hash(_recurrence),
        const DeepCollectionEquality().hash(_extraServices),
        const DeepCollectionEquality().hash(_coupons),
        const DeepCollectionEquality().hash(_seatConfig),
        const DeepCollectionEquality().hash(_externalBooking),
        const DeepCollectionEquality().hash(_eventType),
        const DeepCollectionEquality().hash(_targetAudience),
        const DeepCollectionEquality().hash(_locationDetails),
        const DeepCollectionEquality().hash(_coOrganizers),
        const DeepCollectionEquality().hash(_socialMedia),
        isFavorite
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDtoImplCopyWith<_$EventDtoImpl> get copyWith =>
      __$$EventDtoImplCopyWithImpl<_$EventDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventDtoImplToJson(
      this,
    );
  }
}

abstract class _EventDto implements EventDto {
  const factory _EventDto(
      {@JsonKey(fromJson: _parseEventId) required final int id,
      @JsonKey(fromJson: _parseStringOrNull) final String? uuid,
      @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull)
      final int? internalId,
      @JsonKey(fromJson: _parseHtmlString) required final String title,
      @JsonKey(fromJson: _parseHtmlString) required final String slug,
      @JsonKey(fromJson: _parseHtmlString) final String? excerpt,
      @JsonKey(fromJson: _parseHtmlString) final String? content,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      final EventImageDto? featuredImage,
      @JsonKey(fromJson: _parseStringOrNull) final String? thumbnail,
      @JsonKey(fromJson: _parseGallery) final List<String>? gallery,
      final EventCategoryDto? category,
      final ThematiqueDto? thematique,
      final EventDatesDto? dates,
      final EventLocationDto? location,
      final EventPricingDto? pricing,
      final EventAvailabilityDto? availability,
      final dynamic ratings,
      final EventOrganizerDto? organizer,
      @JsonKey(fromJson: _parseStringList) final List<String>? tags,
      @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
      final List<dynamic>? ticketTypes,
      @JsonKey(fromJson: _parseListOrNull) final List<dynamic>? tickets,
      @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? timeSlots,
      @JsonKey(fromJson: _parseMapOrNull) final Map<String, dynamic>? calendar,
      @JsonKey(fromJson: _parseMapOrNull)
      final Map<String, dynamic>? recurrence,
      @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
      final List<dynamic>? extraServices,
      @JsonKey(fromJson: _parseListOrNull) final List<dynamic>? coupons,
      @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? seatConfig,
      @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? externalBooking,
      @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? eventType,
      @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
      final List<dynamic>? targetAudience,
      @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? locationDetails,
      @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
      final List<CoOrganizerDto>? coOrganizers,
      @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? socialMedia,
      @JsonKey(name: 'is_favorite') final bool isFavorite}) = _$EventDtoImpl;

  factory _EventDto.fromJson(Map<String, dynamic> json) =
      _$EventDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseEventId)
  int get id;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get uuid;
  @override // UUID from API
  @JsonKey(name: 'internal_id', fromJson: _parseIntOrNull)
  int? get internalId;
  @override // Integer ID from API
  @JsonKey(fromJson: _parseHtmlString)
  String get title;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get slug;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String? get excerpt;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String? get content;
  @override // Full HTML description
  @JsonKey(name: 'featured_image', fromJson: _parseImage)
  EventImageDto? get featuredImage;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get thumbnail;
  @override // Alternative image field from organizer events API
  @JsonKey(fromJson: _parseGallery)
  List<String>? get gallery;
  @override // Image gallery URLs
  EventCategoryDto? get category;
  @override
  ThematiqueDto? get thematique;
  @override // Main thematique
  EventDatesDto? get dates;
  @override
  EventLocationDto? get location;
  @override
  EventPricingDto? get pricing;
  @override
  EventAvailabilityDto? get availability;
  @override
  dynamic get ratings;
  @override
  EventOrganizerDto? get organizer;
  @override
  @JsonKey(fromJson: _parseStringList)
  List<String>? get tags;
  @override // New fields for V2 API
  @JsonKey(name: 'ticket_types', fromJson: _parseListOrNull)
  List<dynamic>? get ticketTypes;
  @override
  @JsonKey(fromJson: _parseListOrNull)
  List<dynamic>? get tickets;
  @override
  @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get timeSlots;
  @override
  @JsonKey(fromJson: _parseMapOrNull)
  Map<String, dynamic>? get calendar;
  @override
  @JsonKey(fromJson: _parseMapOrNull)
  Map<String, dynamic>? get recurrence;
  @override
  @JsonKey(name: 'extra_services', fromJson: _parseListOrNull)
  List<dynamic>? get extraServices;
  @override
  @JsonKey(fromJson: _parseListOrNull)
  List<dynamic>? get coupons;
  @override
  @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get seatConfig;
  @override
  @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get externalBooking;
  @override
  @JsonKey(name: 'event_type', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get eventType;
  @override
  @JsonKey(name: 'target_audience', fromJson: _parseListOrNull)
  List<dynamic>? get targetAudience;
  @override // Rich Content V2
  @JsonKey(name: 'location_details', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get locationDetails;
  @override
  @JsonKey(name: 'coorganizers', fromJson: _parseCoOrganizers)
  List<CoOrganizerDto>? get coOrganizers;
  @override
  @JsonKey(name: 'social_media', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get socialMedia;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;
  @override
  @JsonKey(ignore: true)
  _$$EventDtoImplCopyWith<_$EventDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventImageDto _$EventImageDtoFromJson(Map<String, dynamic> json) {
  return _EventImageDto.fromJson(json);
}

/// @nodoc
mixin _$EventImageDto {
  String? get thumbnail => throw _privateConstructorUsedError;
  String? get medium => throw _privateConstructorUsedError;
  String? get large => throw _privateConstructorUsedError;
  String? get full => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventImageDtoCopyWith<EventImageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventImageDtoCopyWith<$Res> {
  factory $EventImageDtoCopyWith(
          EventImageDto value, $Res Function(EventImageDto) then) =
      _$EventImageDtoCopyWithImpl<$Res, EventImageDto>;
  @useResult
  $Res call({String? thumbnail, String? medium, String? large, String? full});
}

/// @nodoc
class _$EventImageDtoCopyWithImpl<$Res, $Val extends EventImageDto>
    implements $EventImageDtoCopyWith<$Res> {
  _$EventImageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = freezed,
    Object? medium = freezed,
    Object? large = freezed,
    Object? full = freezed,
  }) {
    return _then(_value.copyWith(
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      large: freezed == large
          ? _value.large
          : large // ignore: cast_nullable_to_non_nullable
              as String?,
      full: freezed == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImageDtoImplCopyWith<$Res>
    implements $EventImageDtoCopyWith<$Res> {
  factory _$$EventImageDtoImplCopyWith(
          _$EventImageDtoImpl value, $Res Function(_$EventImageDtoImpl) then) =
      __$$EventImageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? thumbnail, String? medium, String? large, String? full});
}

/// @nodoc
class __$$EventImageDtoImplCopyWithImpl<$Res>
    extends _$EventImageDtoCopyWithImpl<$Res, _$EventImageDtoImpl>
    implements _$$EventImageDtoImplCopyWith<$Res> {
  __$$EventImageDtoImplCopyWithImpl(
      _$EventImageDtoImpl _value, $Res Function(_$EventImageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = freezed,
    Object? medium = freezed,
    Object? large = freezed,
    Object? full = freezed,
  }) {
    return _then(_$EventImageDtoImpl(
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      large: freezed == large
          ? _value.large
          : large // ignore: cast_nullable_to_non_nullable
              as String?,
      full: freezed == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImageDtoImpl implements _EventImageDto {
  const _$EventImageDtoImpl(
      {this.thumbnail, this.medium, this.large, this.full});

  factory _$EventImageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImageDtoImplFromJson(json);

  @override
  final String? thumbnail;
  @override
  final String? medium;
  @override
  final String? large;
  @override
  final String? full;

  @override
  String toString() {
    return 'EventImageDto(thumbnail: $thumbnail, medium: $medium, large: $large, full: $full)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImageDtoImpl &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.full, full) || other.full == full));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, thumbnail, medium, large, full);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImageDtoImplCopyWith<_$EventImageDtoImpl> get copyWith =>
      __$$EventImageDtoImplCopyWithImpl<_$EventImageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImageDtoImplToJson(
      this,
    );
  }
}

abstract class _EventImageDto implements EventImageDto {
  const factory _EventImageDto(
      {final String? thumbnail,
      final String? medium,
      final String? large,
      final String? full}) = _$EventImageDtoImpl;

  factory _EventImageDto.fromJson(Map<String, dynamic> json) =
      _$EventImageDtoImpl.fromJson;

  @override
  String? get thumbnail;
  @override
  String? get medium;
  @override
  String? get large;
  @override
  String? get full;
  @override
  @JsonKey(ignore: true)
  _$$EventImageDtoImplCopyWith<_$EventImageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventDatesDto _$EventDatesDtoFromJson(Map<String, dynamic> json) {
  return _EventDatesDto.fromJson(json);
}

/// @nodoc
mixin _$EventDatesDto {
  @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
  String? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
  String? get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
  String? get endTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get display => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring', fromJson: _parseBool)
  bool get isRecurring => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventDatesDtoCopyWith<EventDatesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDatesDtoCopyWith<$Res> {
  factory $EventDatesDtoCopyWith(
          EventDatesDto value, $Res Function(EventDatesDto) then) =
      _$EventDatesDtoCopyWithImpl<$Res, EventDatesDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      String? startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) String? endDate,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
      String? startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) String? endTime,
      @JsonKey(fromJson: _parseStringOrNull) String? display,
      @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
      int? durationMinutes,
      @JsonKey(name: 'is_recurring', fromJson: _parseBool) bool isRecurring});
}

/// @nodoc
class _$EventDatesDtoCopyWithImpl<$Res, $Val extends EventDatesDto>
    implements $EventDatesDtoCopyWith<$Res> {
  _$EventDatesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? display = freezed,
    Object? durationMinutes = freezed,
    Object? isRecurring = null,
  }) {
    return _then(_value.copyWith(
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      display: freezed == display
          ? _value.display
          : display // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventDatesDtoImplCopyWith<$Res>
    implements $EventDatesDtoCopyWith<$Res> {
  factory _$$EventDatesDtoImplCopyWith(
          _$EventDatesDtoImpl value, $Res Function(_$EventDatesDtoImpl) then) =
      __$$EventDatesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      String? startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) String? endDate,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
      String? startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) String? endTime,
      @JsonKey(fromJson: _parseStringOrNull) String? display,
      @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
      int? durationMinutes,
      @JsonKey(name: 'is_recurring', fromJson: _parseBool) bool isRecurring});
}

/// @nodoc
class __$$EventDatesDtoImplCopyWithImpl<$Res>
    extends _$EventDatesDtoCopyWithImpl<$Res, _$EventDatesDtoImpl>
    implements _$$EventDatesDtoImplCopyWith<$Res> {
  __$$EventDatesDtoImplCopyWithImpl(
      _$EventDatesDtoImpl _value, $Res Function(_$EventDatesDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? display = freezed,
    Object? durationMinutes = freezed,
    Object? isRecurring = null,
  }) {
    return _then(_$EventDatesDtoImpl(
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      display: freezed == display
          ? _value.display
          : display // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventDatesDtoImpl implements _EventDatesDto {
  const _$EventDatesDtoImpl(
      {@JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      this.startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) this.endDate,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull) this.startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) this.endTime,
      @JsonKey(fromJson: _parseStringOrNull) this.display,
      @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
      this.durationMinutes,
      @JsonKey(name: 'is_recurring', fromJson: _parseBool)
      this.isRecurring = false});

  factory _$EventDatesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDatesDtoImplFromJson(json);

  @override
  @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
  final String? startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
  final String? endDate;
  @override
  @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
  final String? startTime;
  @override
  @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
  final String? endTime;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? display;
  @override
  @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
  final int? durationMinutes;
  @override
  @JsonKey(name: 'is_recurring', fromJson: _parseBool)
  final bool isRecurring;

  @override
  String toString() {
    return 'EventDatesDto(startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, display: $display, durationMinutes: $durationMinutes, isRecurring: $isRecurring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDatesDtoImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.display, display) || other.display == display) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate, startTime,
      endTime, display, durationMinutes, isRecurring);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDatesDtoImplCopyWith<_$EventDatesDtoImpl> get copyWith =>
      __$$EventDatesDtoImplCopyWithImpl<_$EventDatesDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventDatesDtoImplToJson(
      this,
    );
  }
}

abstract class _EventDatesDto implements EventDatesDto {
  const factory _EventDatesDto(
      {@JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      final String? startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
      final String? endDate,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
      final String? startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
      final String? endTime,
      @JsonKey(fromJson: _parseStringOrNull) final String? display,
      @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
      final int? durationMinutes,
      @JsonKey(name: 'is_recurring', fromJson: _parseBool)
      final bool isRecurring}) = _$EventDatesDtoImpl;

  factory _EventDatesDto.fromJson(Map<String, dynamic> json) =
      _$EventDatesDtoImpl.fromJson;

  @override
  @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
  String? get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
  String? get endDate;
  @override
  @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
  String? get startTime;
  @override
  @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
  String? get endTime;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get display;
  @override
  @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull)
  int? get durationMinutes;
  @override
  @JsonKey(name: 'is_recurring', fromJson: _parseBool)
  bool get isRecurring;
  @override
  @JsonKey(ignore: true)
  _$$EventDatesDtoImplCopyWith<_$EventDatesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventPricingDto _$EventPricingDtoFromJson(Map<String, dynamic> json) {
  return _EventPricingDto.fromJson(json);
}

/// @nodoc
mixin _$EventPricingDto {
  @JsonKey(name: 'is_free', fromJson: _parseBool)
  bool get isFree => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get min => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get max => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get display => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventPricingDtoCopyWith<EventPricingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventPricingDtoCopyWith<$Res> {
  factory $EventPricingDtoCopyWith(
          EventPricingDto value, $Res Function(EventPricingDto) then) =
      _$EventPricingDtoCopyWithImpl<$Res, EventPricingDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_free', fromJson: _parseBool) bool isFree,
      @JsonKey(fromJson: _parseDouble) double min,
      @JsonKey(fromJson: _parseDouble) double max,
      String currency,
      @JsonKey(fromJson: _parseStringOrNull) String? display});
}

/// @nodoc
class _$EventPricingDtoCopyWithImpl<$Res, $Val extends EventPricingDto>
    implements $EventPricingDtoCopyWith<$Res> {
  _$EventPricingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFree = null,
    Object? min = null,
    Object? max = null,
    Object? currency = null,
    Object? display = freezed,
  }) {
    return _then(_value.copyWith(
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      display: freezed == display
          ? _value.display
          : display // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventPricingDtoImplCopyWith<$Res>
    implements $EventPricingDtoCopyWith<$Res> {
  factory _$$EventPricingDtoImplCopyWith(_$EventPricingDtoImpl value,
          $Res Function(_$EventPricingDtoImpl) then) =
      __$$EventPricingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_free', fromJson: _parseBool) bool isFree,
      @JsonKey(fromJson: _parseDouble) double min,
      @JsonKey(fromJson: _parseDouble) double max,
      String currency,
      @JsonKey(fromJson: _parseStringOrNull) String? display});
}

/// @nodoc
class __$$EventPricingDtoImplCopyWithImpl<$Res>
    extends _$EventPricingDtoCopyWithImpl<$Res, _$EventPricingDtoImpl>
    implements _$$EventPricingDtoImplCopyWith<$Res> {
  __$$EventPricingDtoImplCopyWithImpl(
      _$EventPricingDtoImpl _value, $Res Function(_$EventPricingDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFree = null,
    Object? min = null,
    Object? max = null,
    Object? currency = null,
    Object? display = freezed,
  }) {
    return _then(_$EventPricingDtoImpl(
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      display: freezed == display
          ? _value.display
          : display // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventPricingDtoImpl implements _EventPricingDto {
  const _$EventPricingDtoImpl(
      {@JsonKey(name: 'is_free', fromJson: _parseBool) this.isFree = false,
      @JsonKey(fromJson: _parseDouble) this.min = 0,
      @JsonKey(fromJson: _parseDouble) this.max = 0,
      this.currency = 'EUR',
      @JsonKey(fromJson: _parseStringOrNull) this.display});

  factory _$EventPricingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventPricingDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_free', fromJson: _parseBool)
  final bool isFree;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double min;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double max;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? display;

  @override
  String toString() {
    return 'EventPricingDto(isFree: $isFree, min: $min, max: $max, currency: $currency, display: $display)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventPricingDtoImpl &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.display, display) || other.display == display));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isFree, min, max, currency, display);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventPricingDtoImplCopyWith<_$EventPricingDtoImpl> get copyWith =>
      __$$EventPricingDtoImplCopyWithImpl<_$EventPricingDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventPricingDtoImplToJson(
      this,
    );
  }
}

abstract class _EventPricingDto implements EventPricingDto {
  const factory _EventPricingDto(
          {@JsonKey(name: 'is_free', fromJson: _parseBool) final bool isFree,
          @JsonKey(fromJson: _parseDouble) final double min,
          @JsonKey(fromJson: _parseDouble) final double max,
          final String currency,
          @JsonKey(fromJson: _parseStringOrNull) final String? display}) =
      _$EventPricingDtoImpl;

  factory _EventPricingDto.fromJson(Map<String, dynamic> json) =
      _$EventPricingDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_free', fromJson: _parseBool)
  bool get isFree;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get min;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get max;
  @override
  String get currency;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get display;
  @override
  @JsonKey(ignore: true)
  _$$EventPricingDtoImplCopyWith<_$EventPricingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventAvailabilityDto _$EventAvailabilityDtoFromJson(Map<String, dynamic> json) {
  return _EventAvailabilityDto.fromJson(json);
}

/// @nodoc
mixin _$EventAvailabilityDto {
  @JsonKey(fromJson: _parseStringOrNull)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
  int? get totalCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
  int? get spotsRemaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
  int? get percentageFilled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventAvailabilityDtoCopyWith<EventAvailabilityDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventAvailabilityDtoCopyWith<$Res> {
  factory $EventAvailabilityDtoCopyWith(EventAvailabilityDto value,
          $Res Function(EventAvailabilityDto) then) =
      _$EventAvailabilityDtoCopyWithImpl<$Res, EventAvailabilityDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? status,
      @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
      int? totalCapacity,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      int? spotsRemaining,
      @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
      int? percentageFilled});
}

/// @nodoc
class _$EventAvailabilityDtoCopyWithImpl<$Res,
        $Val extends EventAvailabilityDto>
    implements $EventAvailabilityDtoCopyWith<$Res> {
  _$EventAvailabilityDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? totalCapacity = freezed,
    Object? spotsRemaining = freezed,
    Object? percentageFilled = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCapacity: freezed == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      spotsRemaining: freezed == spotsRemaining
          ? _value.spotsRemaining
          : spotsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      percentageFilled: freezed == percentageFilled
          ? _value.percentageFilled
          : percentageFilled // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventAvailabilityDtoImplCopyWith<$Res>
    implements $EventAvailabilityDtoCopyWith<$Res> {
  factory _$$EventAvailabilityDtoImplCopyWith(_$EventAvailabilityDtoImpl value,
          $Res Function(_$EventAvailabilityDtoImpl) then) =
      __$$EventAvailabilityDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? status,
      @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
      int? totalCapacity,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      int? spotsRemaining,
      @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
      int? percentageFilled});
}

/// @nodoc
class __$$EventAvailabilityDtoImplCopyWithImpl<$Res>
    extends _$EventAvailabilityDtoCopyWithImpl<$Res, _$EventAvailabilityDtoImpl>
    implements _$$EventAvailabilityDtoImplCopyWith<$Res> {
  __$$EventAvailabilityDtoImplCopyWithImpl(_$EventAvailabilityDtoImpl _value,
      $Res Function(_$EventAvailabilityDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? totalCapacity = freezed,
    Object? spotsRemaining = freezed,
    Object? percentageFilled = freezed,
  }) {
    return _then(_$EventAvailabilityDtoImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCapacity: freezed == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      spotsRemaining: freezed == spotsRemaining
          ? _value.spotsRemaining
          : spotsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      percentageFilled: freezed == percentageFilled
          ? _value.percentageFilled
          : percentageFilled // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventAvailabilityDtoImpl implements _EventAvailabilityDto {
  const _$EventAvailabilityDtoImpl(
      {@JsonKey(fromJson: _parseStringOrNull) this.status,
      @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
      this.totalCapacity,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      this.spotsRemaining,
      @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
      this.percentageFilled});

  factory _$EventAvailabilityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventAvailabilityDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? status;
  @override
  @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
  final int? totalCapacity;
  @override
  @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
  final int? spotsRemaining;
  @override
  @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
  final int? percentageFilled;

  @override
  String toString() {
    return 'EventAvailabilityDto(status: $status, totalCapacity: $totalCapacity, spotsRemaining: $spotsRemaining, percentageFilled: $percentageFilled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventAvailabilityDtoImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalCapacity, totalCapacity) ||
                other.totalCapacity == totalCapacity) &&
            (identical(other.spotsRemaining, spotsRemaining) ||
                other.spotsRemaining == spotsRemaining) &&
            (identical(other.percentageFilled, percentageFilled) ||
                other.percentageFilled == percentageFilled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, status, totalCapacity, spotsRemaining, percentageFilled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventAvailabilityDtoImplCopyWith<_$EventAvailabilityDtoImpl>
      get copyWith =>
          __$$EventAvailabilityDtoImplCopyWithImpl<_$EventAvailabilityDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventAvailabilityDtoImplToJson(
      this,
    );
  }
}

abstract class _EventAvailabilityDto implements EventAvailabilityDto {
  const factory _EventAvailabilityDto(
      {@JsonKey(fromJson: _parseStringOrNull) final String? status,
      @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
      final int? totalCapacity,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      final int? spotsRemaining,
      @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
      final int? percentageFilled}) = _$EventAvailabilityDtoImpl;

  factory _EventAvailabilityDto.fromJson(Map<String, dynamic> json) =
      _$EventAvailabilityDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get status;
  @override
  @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull)
  int? get totalCapacity;
  @override
  @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
  int? get spotsRemaining;
  @override
  @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull)
  int? get percentageFilled;
  @override
  @JsonKey(ignore: true)
  _$$EventAvailabilityDtoImplCopyWith<_$EventAvailabilityDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EventCategoryDto _$EventCategoryDtoFromJson(Map<String, dynamic> json) {
  return _EventCategoryDto.fromJson(json);
}

/// @nodoc
mixin _$EventCategoryDto {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
  int? get eventCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCategoryDtoCopyWith<EventCategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCategoryDtoCopyWith<$Res> {
  factory $EventCategoryDtoCopyWith(
          EventCategoryDto value, $Res Function(EventCategoryDto) then) =
      _$EventCategoryDtoCopyWithImpl<$Res, EventCategoryDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseHtmlString) String slug,
      @JsonKey(fromJson: _parseHtmlString) String? description,
      @JsonKey(fromJson: _parseStringOrNull) String? icon,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      int? eventCount});
}

/// @nodoc
class _$EventCategoryDtoCopyWithImpl<$Res, $Val extends EventCategoryDto>
    implements $EventCategoryDtoCopyWith<$Res> {
  _$EventCategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? eventCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCategoryDtoImplCopyWith<$Res>
    implements $EventCategoryDtoCopyWith<$Res> {
  factory _$$EventCategoryDtoImplCopyWith(_$EventCategoryDtoImpl value,
          $Res Function(_$EventCategoryDtoImpl) then) =
      __$$EventCategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseHtmlString) String slug,
      @JsonKey(fromJson: _parseHtmlString) String? description,
      @JsonKey(fromJson: _parseStringOrNull) String? icon,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      int? eventCount});
}

/// @nodoc
class __$$EventCategoryDtoImplCopyWithImpl<$Res>
    extends _$EventCategoryDtoCopyWithImpl<$Res, _$EventCategoryDtoImpl>
    implements _$$EventCategoryDtoImplCopyWith<$Res> {
  __$$EventCategoryDtoImplCopyWithImpl(_$EventCategoryDtoImpl _value,
      $Res Function(_$EventCategoryDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? eventCount = freezed,
  }) {
    return _then(_$EventCategoryDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCategoryDtoImpl implements _EventCategoryDto {
  const _$EventCategoryDtoImpl(
      {@JsonKey(fromJson: _parseInt) this.id = 0,
      @JsonKey(fromJson: _parseHtmlString) this.name = '',
      @JsonKey(fromJson: _parseHtmlString) this.slug = '',
      @JsonKey(fromJson: _parseHtmlString) this.description,
      @JsonKey(fromJson: _parseStringOrNull) this.icon,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      this.eventCount});

  factory _$EventCategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCategoryDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String name;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String slug;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String? description;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? icon;
  @override
  @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
  final int? eventCount;

  @override
  String toString() {
    return 'EventCategoryDto(id: $id, name: $name, slug: $slug, description: $description, icon: $icon, eventCount: $eventCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCategoryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, slug, description, icon, eventCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCategoryDtoImplCopyWith<_$EventCategoryDtoImpl> get copyWith =>
      __$$EventCategoryDtoImplCopyWithImpl<_$EventCategoryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCategoryDtoImplToJson(
      this,
    );
  }
}

abstract class _EventCategoryDto implements EventCategoryDto {
  const factory _EventCategoryDto(
      {@JsonKey(fromJson: _parseInt) final int id,
      @JsonKey(fromJson: _parseHtmlString) final String name,
      @JsonKey(fromJson: _parseHtmlString) final String slug,
      @JsonKey(fromJson: _parseHtmlString) final String? description,
      @JsonKey(fromJson: _parseStringOrNull) final String? icon,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      final int? eventCount}) = _$EventCategoryDtoImpl;

  factory _EventCategoryDto.fromJson(Map<String, dynamic> json) =
      _$EventCategoryDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get name;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get slug;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String? get description;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get icon;
  @override
  @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
  int? get eventCount;
  @override
  @JsonKey(ignore: true)
  _$$EventCategoryDtoImplCopyWith<_$EventCategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventPriceDto _$EventPriceDtoFromJson(Map<String, dynamic> json) {
  return _EventPriceDto.fromJson(json);
}

/// @nodoc
mixin _$EventPriceDto {
  @JsonKey(name: 'is_free')
  bool get isFree => throw _privateConstructorUsedError;
  double? get min => throw _privateConstructorUsedError;
  double? get max => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventPriceDtoCopyWith<EventPriceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventPriceDtoCopyWith<$Res> {
  factory $EventPriceDtoCopyWith(
          EventPriceDto value, $Res Function(EventPriceDto) then) =
      _$EventPriceDtoCopyWithImpl<$Res, EventPriceDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_free') bool isFree,
      double? min,
      double? max,
      String currency});
}

/// @nodoc
class _$EventPriceDtoCopyWithImpl<$Res, $Val extends EventPriceDto>
    implements $EventPriceDtoCopyWith<$Res> {
  _$EventPriceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFree = null,
    Object? min = freezed,
    Object? max = freezed,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventPriceDtoImplCopyWith<$Res>
    implements $EventPriceDtoCopyWith<$Res> {
  factory _$$EventPriceDtoImplCopyWith(
          _$EventPriceDtoImpl value, $Res Function(_$EventPriceDtoImpl) then) =
      __$$EventPriceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_free') bool isFree,
      double? min,
      double? max,
      String currency});
}

/// @nodoc
class __$$EventPriceDtoImplCopyWithImpl<$Res>
    extends _$EventPriceDtoCopyWithImpl<$Res, _$EventPriceDtoImpl>
    implements _$$EventPriceDtoImplCopyWith<$Res> {
  __$$EventPriceDtoImplCopyWithImpl(
      _$EventPriceDtoImpl _value, $Res Function(_$EventPriceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFree = null,
    Object? min = freezed,
    Object? max = freezed,
    Object? currency = null,
  }) {
    return _then(_$EventPriceDtoImpl(
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventPriceDtoImpl implements _EventPriceDto {
  const _$EventPriceDtoImpl(
      {@JsonKey(name: 'is_free') this.isFree = false,
      this.min,
      this.max,
      this.currency = 'EUR'});

  factory _$EventPriceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventPriceDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_free')
  final bool isFree;
  @override
  final double? min;
  @override
  final double? max;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'EventPriceDto(isFree: $isFree, min: $min, max: $max, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventPriceDtoImpl &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isFree, min, max, currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventPriceDtoImplCopyWith<_$EventPriceDtoImpl> get copyWith =>
      __$$EventPriceDtoImplCopyWithImpl<_$EventPriceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventPriceDtoImplToJson(
      this,
    );
  }
}

abstract class _EventPriceDto implements EventPriceDto {
  const factory _EventPriceDto(
      {@JsonKey(name: 'is_free') final bool isFree,
      final double? min,
      final double? max,
      final String currency}) = _$EventPriceDtoImpl;

  factory _EventPriceDto.fromJson(Map<String, dynamic> json) =
      _$EventPriceDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_free')
  bool get isFree;
  @override
  double? get min;
  @override
  double? get max;
  @override
  String get currency;
  @override
  @JsonKey(ignore: true)
  _$$EventPriceDtoImplCopyWith<_$EventPriceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventLocationDto _$EventLocationDtoFromJson(Map<String, dynamic> json) {
  return _EventLocationDto.fromJson(json);
}

/// @nodoc
mixin _$EventLocationDto {
  @JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
  String? get venueName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDoubleOrNull)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDoubleOrNull)
  double? get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
  double? get distanceKm => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventLocationDtoCopyWith<EventLocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventLocationDtoCopyWith<$Res> {
  factory $EventLocationDtoCopyWith(
          EventLocationDto value, $Res Function(EventLocationDto) then) =
      _$EventLocationDtoCopyWithImpl<$Res, EventLocationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
      String? venueName,
      @JsonKey(fromJson: _parseStringOrNull) String? address,
      @JsonKey(fromJson: _parseStringOrNull) String? city,
      @JsonKey(fromJson: _parseDoubleOrNull) double? lat,
      @JsonKey(fromJson: _parseDoubleOrNull) double? lng,
      @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
      double? distanceKm});
}

/// @nodoc
class _$EventLocationDtoCopyWithImpl<$Res, $Val extends EventLocationDto>
    implements $EventLocationDtoCopyWith<$Res> {
  _$EventLocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueName = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? distanceKm = freezed,
  }) {
    return _then(_value.copyWith(
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventLocationDtoImplCopyWith<$Res>
    implements $EventLocationDtoCopyWith<$Res> {
  factory _$$EventLocationDtoImplCopyWith(_$EventLocationDtoImpl value,
          $Res Function(_$EventLocationDtoImpl) then) =
      __$$EventLocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
      String? venueName,
      @JsonKey(fromJson: _parseStringOrNull) String? address,
      @JsonKey(fromJson: _parseStringOrNull) String? city,
      @JsonKey(fromJson: _parseDoubleOrNull) double? lat,
      @JsonKey(fromJson: _parseDoubleOrNull) double? lng,
      @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
      double? distanceKm});
}

/// @nodoc
class __$$EventLocationDtoImplCopyWithImpl<$Res>
    extends _$EventLocationDtoCopyWithImpl<$Res, _$EventLocationDtoImpl>
    implements _$$EventLocationDtoImplCopyWith<$Res> {
  __$$EventLocationDtoImplCopyWithImpl(_$EventLocationDtoImpl _value,
      $Res Function(_$EventLocationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueName = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? distanceKm = freezed,
  }) {
    return _then(_$EventLocationDtoImpl(
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventLocationDtoImpl implements _EventLocationDto {
  const _$EventLocationDtoImpl(
      {@JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
      this.venueName,
      @JsonKey(fromJson: _parseStringOrNull) this.address,
      @JsonKey(fromJson: _parseStringOrNull) this.city,
      @JsonKey(fromJson: _parseDoubleOrNull) this.lat,
      @JsonKey(fromJson: _parseDoubleOrNull) this.lng,
      @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
      this.distanceKm});

  factory _$EventLocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventLocationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
  final String? venueName;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? address;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? city;
  @override
  @JsonKey(fromJson: _parseDoubleOrNull)
  final double? lat;
  @override
  @JsonKey(fromJson: _parseDoubleOrNull)
  final double? lng;
  @override
  @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
  final double? distanceKm;

  @override
  String toString() {
    return 'EventLocationDto(venueName: $venueName, address: $address, city: $city, lat: $lat, lng: $lng, distanceKm: $distanceKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventLocationDtoImpl &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, venueName, address, city, lat, lng, distanceKm);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventLocationDtoImplCopyWith<_$EventLocationDtoImpl> get copyWith =>
      __$$EventLocationDtoImplCopyWithImpl<_$EventLocationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventLocationDtoImplToJson(
      this,
    );
  }
}

abstract class _EventLocationDto implements EventLocationDto {
  const factory _EventLocationDto(
      {@JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
      final String? venueName,
      @JsonKey(fromJson: _parseStringOrNull) final String? address,
      @JsonKey(fromJson: _parseStringOrNull) final String? city,
      @JsonKey(fromJson: _parseDoubleOrNull) final double? lat,
      @JsonKey(fromJson: _parseDoubleOrNull) final double? lng,
      @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
      final double? distanceKm}) = _$EventLocationDtoImpl;

  factory _EventLocationDto.fromJson(Map<String, dynamic> json) =
      _$EventLocationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'venue_name', fromJson: _parseStringOrNull)
  String? get venueName;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get address;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get city;
  @override
  @JsonKey(fromJson: _parseDoubleOrNull)
  double? get lat;
  @override
  @JsonKey(fromJson: _parseDoubleOrNull)
  double? get lng;
  @override
  @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull)
  double? get distanceKm;
  @override
  @JsonKey(ignore: true)
  _$$EventLocationDtoImplCopyWith<_$EventLocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventOrganizerDto _$EventOrganizerDtoFromJson(Map<String, dynamic> json) {
  return _EventOrganizerDto.fromJson(json);
}

/// @nodoc
mixin _$EventOrganizerDto {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get logoSizes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get website => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
  String? get coverImage => throw _privateConstructorUsedError;
  OrganizerContactDto? get contact => throw _privateConstructorUsedError;
  OrganizerLocationDto? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'practical_info')
  OrganizerPracticalInfoDto? get practicalInfo =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
  List<OrganizerSocialLinkDto>? get socialLinks =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'stats')
  OrganizerStatsDto? get stats => throw _privateConstructorUsedError;
  @JsonKey(name: 'categories', fromJson: _parseCategories)
  List<EventCategoryDto>? get categories => throw _privateConstructorUsedError;
  @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
  List<CoOrganizerDto>? get partnerships => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
  String? get profileUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
  String? get memberSince => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseBool)
  bool get verified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventOrganizerDtoCopyWith<EventOrganizerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventOrganizerDtoCopyWith<$Res> {
  factory $EventOrganizerDtoCopyWith(
          EventOrganizerDto value, $Res Function(EventOrganizerDto) then) =
      _$EventOrganizerDtoCopyWithImpl<$Res, EventOrganizerDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? avatar,
      @JsonKey(fromJson: _parseHtmlString) String? description,
      @JsonKey(fromJson: _parseStringOrNull) String? logo,
      @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
      Map<String, dynamic>? logoSizes,
      @JsonKey(fromJson: _parseStringOrNull) String? website,
      @JsonKey(fromJson: _parseStringOrNull) String? phone,
      @JsonKey(fromJson: _parseStringOrNull) String? email,
      @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
      String? coverImage,
      OrganizerContactDto? contact,
      OrganizerLocationDto? location,
      @JsonKey(name: 'practical_info') OrganizerPracticalInfoDto? practicalInfo,
      @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
      List<OrganizerSocialLinkDto>? socialLinks,
      @JsonKey(name: 'stats') OrganizerStatsDto? stats,
      @JsonKey(name: 'categories', fromJson: _parseCategories)
      List<EventCategoryDto>? categories,
      @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
      List<CoOrganizerDto>? partnerships,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      String? profileUrl,
      @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
      String? memberSince,
      @JsonKey(fromJson: _parseBool) bool verified});

  $OrganizerContactDtoCopyWith<$Res>? get contact;
  $OrganizerLocationDtoCopyWith<$Res>? get location;
  $OrganizerPracticalInfoDtoCopyWith<$Res>? get practicalInfo;
  $OrganizerStatsDtoCopyWith<$Res>? get stats;
}

/// @nodoc
class _$EventOrganizerDtoCopyWithImpl<$Res, $Val extends EventOrganizerDto>
    implements $EventOrganizerDtoCopyWith<$Res> {
  _$EventOrganizerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? description = freezed,
    Object? logo = freezed,
    Object? logoSizes = freezed,
    Object? website = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? coverImage = freezed,
    Object? contact = freezed,
    Object? location = freezed,
    Object? practicalInfo = freezed,
    Object? socialLinks = freezed,
    Object? stats = freezed,
    Object? categories = freezed,
    Object? partnerships = freezed,
    Object? profileUrl = freezed,
    Object? memberSince = freezed,
    Object? verified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      logoSizes: freezed == logoSizes
          ? _value.logoSizes
          : logoSizes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as OrganizerContactDto?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as OrganizerLocationDto?,
      practicalInfo: freezed == practicalInfo
          ? _value.practicalInfo
          : practicalInfo // ignore: cast_nullable_to_non_nullable
              as OrganizerPracticalInfoDto?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as List<OrganizerSocialLinkDto>?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as OrganizerStatsDto?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<EventCategoryDto>?,
      partnerships: freezed == partnerships
          ? _value.partnerships
          : partnerships // ignore: cast_nullable_to_non_nullable
              as List<CoOrganizerDto>?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      memberSince: freezed == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizerContactDtoCopyWith<$Res>? get contact {
    if (_value.contact == null) {
      return null;
    }

    return $OrganizerContactDtoCopyWith<$Res>(_value.contact!, (value) {
      return _then(_value.copyWith(contact: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizerLocationDtoCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $OrganizerLocationDtoCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizerPracticalInfoDtoCopyWith<$Res>? get practicalInfo {
    if (_value.practicalInfo == null) {
      return null;
    }

    return $OrganizerPracticalInfoDtoCopyWith<$Res>(_value.practicalInfo!,
        (value) {
      return _then(_value.copyWith(practicalInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizerStatsDtoCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $OrganizerStatsDtoCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventOrganizerDtoImplCopyWith<$Res>
    implements $EventOrganizerDtoCopyWith<$Res> {
  factory _$$EventOrganizerDtoImplCopyWith(_$EventOrganizerDtoImpl value,
          $Res Function(_$EventOrganizerDtoImpl) then) =
      __$$EventOrganizerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? avatar,
      @JsonKey(fromJson: _parseHtmlString) String? description,
      @JsonKey(fromJson: _parseStringOrNull) String? logo,
      @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
      Map<String, dynamic>? logoSizes,
      @JsonKey(fromJson: _parseStringOrNull) String? website,
      @JsonKey(fromJson: _parseStringOrNull) String? phone,
      @JsonKey(fromJson: _parseStringOrNull) String? email,
      @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
      String? coverImage,
      OrganizerContactDto? contact,
      OrganizerLocationDto? location,
      @JsonKey(name: 'practical_info') OrganizerPracticalInfoDto? practicalInfo,
      @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
      List<OrganizerSocialLinkDto>? socialLinks,
      @JsonKey(name: 'stats') OrganizerStatsDto? stats,
      @JsonKey(name: 'categories', fromJson: _parseCategories)
      List<EventCategoryDto>? categories,
      @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
      List<CoOrganizerDto>? partnerships,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      String? profileUrl,
      @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
      String? memberSince,
      @JsonKey(fromJson: _parseBool) bool verified});

  @override
  $OrganizerContactDtoCopyWith<$Res>? get contact;
  @override
  $OrganizerLocationDtoCopyWith<$Res>? get location;
  @override
  $OrganizerPracticalInfoDtoCopyWith<$Res>? get practicalInfo;
  @override
  $OrganizerStatsDtoCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$EventOrganizerDtoImplCopyWithImpl<$Res>
    extends _$EventOrganizerDtoCopyWithImpl<$Res, _$EventOrganizerDtoImpl>
    implements _$$EventOrganizerDtoImplCopyWith<$Res> {
  __$$EventOrganizerDtoImplCopyWithImpl(_$EventOrganizerDtoImpl _value,
      $Res Function(_$EventOrganizerDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? description = freezed,
    Object? logo = freezed,
    Object? logoSizes = freezed,
    Object? website = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? coverImage = freezed,
    Object? contact = freezed,
    Object? location = freezed,
    Object? practicalInfo = freezed,
    Object? socialLinks = freezed,
    Object? stats = freezed,
    Object? categories = freezed,
    Object? partnerships = freezed,
    Object? profileUrl = freezed,
    Object? memberSince = freezed,
    Object? verified = null,
  }) {
    return _then(_$EventOrganizerDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      logoSizes: freezed == logoSizes
          ? _value._logoSizes
          : logoSizes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as OrganizerContactDto?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as OrganizerLocationDto?,
      practicalInfo: freezed == practicalInfo
          ? _value.practicalInfo
          : practicalInfo // ignore: cast_nullable_to_non_nullable
              as OrganizerPracticalInfoDto?,
      socialLinks: freezed == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as List<OrganizerSocialLinkDto>?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as OrganizerStatsDto?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<EventCategoryDto>?,
      partnerships: freezed == partnerships
          ? _value._partnerships
          : partnerships // ignore: cast_nullable_to_non_nullable
              as List<CoOrganizerDto>?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      memberSince: freezed == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventOrganizerDtoImpl implements _EventOrganizerDto {
  const _$EventOrganizerDtoImpl(
      {@JsonKey(fromJson: _parseInt) this.id = 0,
      @JsonKey(fromJson: _parseHtmlString) this.name = '',
      @JsonKey(fromJson: _parseStringOrNull) this.avatar,
      @JsonKey(fromJson: _parseHtmlString) this.description,
      @JsonKey(fromJson: _parseStringOrNull) this.logo,
      @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
      final Map<String, dynamic>? logoSizes,
      @JsonKey(fromJson: _parseStringOrNull) this.website,
      @JsonKey(fromJson: _parseStringOrNull) this.phone,
      @JsonKey(fromJson: _parseStringOrNull) this.email,
      @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
      this.coverImage,
      this.contact,
      this.location,
      @JsonKey(name: 'practical_info') this.practicalInfo,
      @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
      final List<OrganizerSocialLinkDto>? socialLinks,
      @JsonKey(name: 'stats') this.stats,
      @JsonKey(name: 'categories', fromJson: _parseCategories)
      final List<EventCategoryDto>? categories,
      @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
      final List<CoOrganizerDto>? partnerships,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      this.profileUrl,
      @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
      this.memberSince,
      @JsonKey(fromJson: _parseBool) this.verified = false})
      : _logoSizes = logoSizes,
        _socialLinks = socialLinks,
        _categories = categories,
        _partnerships = partnerships;

  factory _$EventOrganizerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventOrganizerDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? avatar;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String? description;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? logo;
  final Map<String, dynamic>? _logoSizes;
  @override
  @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get logoSizes {
    final value = _logoSizes;
    if (value == null) return null;
    if (_logoSizes is EqualUnmodifiableMapView) return _logoSizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? website;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? phone;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? email;
  @override
  @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
  final String? coverImage;
  @override
  final OrganizerContactDto? contact;
  @override
  final OrganizerLocationDto? location;
  @override
  @JsonKey(name: 'practical_info')
  final OrganizerPracticalInfoDto? practicalInfo;
  final List<OrganizerSocialLinkDto>? _socialLinks;
  @override
  @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
  List<OrganizerSocialLinkDto>? get socialLinks {
    final value = _socialLinks;
    if (value == null) return null;
    if (_socialLinks is EqualUnmodifiableListView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'stats')
  final OrganizerStatsDto? stats;
  final List<EventCategoryDto>? _categories;
  @override
  @JsonKey(name: 'categories', fromJson: _parseCategories)
  List<EventCategoryDto>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CoOrganizerDto>? _partnerships;
  @override
  @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
  List<CoOrganizerDto>? get partnerships {
    final value = _partnerships;
    if (value == null) return null;
    if (_partnerships is EqualUnmodifiableListView) return _partnerships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
  final String? profileUrl;
  @override
  @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
  final String? memberSince;
  @override
  @JsonKey(fromJson: _parseBool)
  final bool verified;

  @override
  String toString() {
    return 'EventOrganizerDto(id: $id, name: $name, avatar: $avatar, description: $description, logo: $logo, logoSizes: $logoSizes, website: $website, phone: $phone, email: $email, coverImage: $coverImage, contact: $contact, location: $location, practicalInfo: $practicalInfo, socialLinks: $socialLinks, stats: $stats, categories: $categories, partnerships: $partnerships, profileUrl: $profileUrl, memberSince: $memberSince, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventOrganizerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            const DeepCollectionEquality()
                .equals(other._logoSizes, _logoSizes) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.practicalInfo, practicalInfo) ||
                other.practicalInfo == practicalInfo) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._partnerships, _partnerships) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            (identical(other.memberSince, memberSince) ||
                other.memberSince == memberSince) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        avatar,
        description,
        logo,
        const DeepCollectionEquality().hash(_logoSizes),
        website,
        phone,
        email,
        coverImage,
        contact,
        location,
        practicalInfo,
        const DeepCollectionEquality().hash(_socialLinks),
        stats,
        const DeepCollectionEquality().hash(_categories),
        const DeepCollectionEquality().hash(_partnerships),
        profileUrl,
        memberSince,
        verified
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventOrganizerDtoImplCopyWith<_$EventOrganizerDtoImpl> get copyWith =>
      __$$EventOrganizerDtoImplCopyWithImpl<_$EventOrganizerDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventOrganizerDtoImplToJson(
      this,
    );
  }
}

abstract class _EventOrganizerDto implements EventOrganizerDto {
  const factory _EventOrganizerDto(
          {@JsonKey(fromJson: _parseInt) final int id,
          @JsonKey(fromJson: _parseHtmlString) final String name,
          @JsonKey(fromJson: _parseStringOrNull) final String? avatar,
          @JsonKey(fromJson: _parseHtmlString) final String? description,
          @JsonKey(fromJson: _parseStringOrNull) final String? logo,
          @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
          final Map<String, dynamic>? logoSizes,
          @JsonKey(fromJson: _parseStringOrNull) final String? website,
          @JsonKey(fromJson: _parseStringOrNull) final String? phone,
          @JsonKey(fromJson: _parseStringOrNull) final String? email,
          @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
          final String? coverImage,
          final OrganizerContactDto? contact,
          final OrganizerLocationDto? location,
          @JsonKey(name: 'practical_info')
          final OrganizerPracticalInfoDto? practicalInfo,
          @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
          final List<OrganizerSocialLinkDto>? socialLinks,
          @JsonKey(name: 'stats') final OrganizerStatsDto? stats,
          @JsonKey(name: 'categories', fromJson: _parseCategories)
          final List<EventCategoryDto>? categories,
          @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
          final List<CoOrganizerDto>? partnerships,
          @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
          final String? profileUrl,
          @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
          final String? memberSince,
          @JsonKey(fromJson: _parseBool) final bool verified}) =
      _$EventOrganizerDtoImpl;

  factory _EventOrganizerDto.fromJson(Map<String, dynamic> json) =
      _$EventOrganizerDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get avatar;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String? get description;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get logo;
  @override
  @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull)
  Map<String, dynamic>? get logoSizes;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get website;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get phone;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get email;
  @override
  @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull)
  String? get coverImage;
  @override
  OrganizerContactDto? get contact;
  @override
  OrganizerLocationDto? get location;
  @override
  @JsonKey(name: 'practical_info')
  OrganizerPracticalInfoDto? get practicalInfo;
  @override
  @JsonKey(name: 'social_links', fromJson: _parseSocialLinks)
  List<OrganizerSocialLinkDto>? get socialLinks;
  @override
  @JsonKey(name: 'stats')
  OrganizerStatsDto? get stats;
  @override
  @JsonKey(name: 'categories', fromJson: _parseCategories)
  List<EventCategoryDto>? get categories;
  @override
  @JsonKey(name: 'partnerships', fromJson: _parseCoOrganizers)
  List<CoOrganizerDto>? get partnerships;
  @override
  @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
  String? get profileUrl;
  @override
  @JsonKey(name: 'member_since', fromJson: _parseStringOrNull)
  String? get memberSince;
  @override
  @JsonKey(fromJson: _parseBool)
  bool get verified;
  @override
  @JsonKey(ignore: true)
  _$$EventOrganizerDtoImplCopyWith<_$EventOrganizerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrganizerSocialLinkDto _$OrganizerSocialLinkDtoFromJson(
    Map<String, dynamic> json) {
  return _OrganizerSocialLinkDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizerSocialLinkDto {
  @JsonKey(fromJson: _parseStringOrNull)
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get icon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizerSocialLinkDtoCopyWith<OrganizerSocialLinkDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerSocialLinkDtoCopyWith<$Res> {
  factory $OrganizerSocialLinkDtoCopyWith(OrganizerSocialLinkDto value,
          $Res Function(OrganizerSocialLinkDto) then) =
      _$OrganizerSocialLinkDtoCopyWithImpl<$Res, OrganizerSocialLinkDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? type,
      @JsonKey(fromJson: _parseStringOrNull) String? url,
      @JsonKey(fromJson: _parseStringOrNull) String? icon});
}

/// @nodoc
class _$OrganizerSocialLinkDtoCopyWithImpl<$Res,
        $Val extends OrganizerSocialLinkDto>
    implements $OrganizerSocialLinkDtoCopyWith<$Res> {
  _$OrganizerSocialLinkDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? url = freezed,
    Object? icon = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizerSocialLinkDtoImplCopyWith<$Res>
    implements $OrganizerSocialLinkDtoCopyWith<$Res> {
  factory _$$OrganizerSocialLinkDtoImplCopyWith(
          _$OrganizerSocialLinkDtoImpl value,
          $Res Function(_$OrganizerSocialLinkDtoImpl) then) =
      __$$OrganizerSocialLinkDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? type,
      @JsonKey(fromJson: _parseStringOrNull) String? url,
      @JsonKey(fromJson: _parseStringOrNull) String? icon});
}

/// @nodoc
class __$$OrganizerSocialLinkDtoImplCopyWithImpl<$Res>
    extends _$OrganizerSocialLinkDtoCopyWithImpl<$Res,
        _$OrganizerSocialLinkDtoImpl>
    implements _$$OrganizerSocialLinkDtoImplCopyWith<$Res> {
  __$$OrganizerSocialLinkDtoImplCopyWithImpl(
      _$OrganizerSocialLinkDtoImpl _value,
      $Res Function(_$OrganizerSocialLinkDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? url = freezed,
    Object? icon = freezed,
  }) {
    return _then(_$OrganizerSocialLinkDtoImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerSocialLinkDtoImpl implements _OrganizerSocialLinkDto {
  const _$OrganizerSocialLinkDtoImpl(
      {@JsonKey(fromJson: _parseStringOrNull) this.type,
      @JsonKey(fromJson: _parseStringOrNull) this.url,
      @JsonKey(fromJson: _parseStringOrNull) this.icon});

  factory _$OrganizerSocialLinkDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerSocialLinkDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? type;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? url;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? icon;

  @override
  String toString() {
    return 'OrganizerSocialLinkDto(type: $type, url: $url, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerSocialLinkDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, url, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerSocialLinkDtoImplCopyWith<_$OrganizerSocialLinkDtoImpl>
      get copyWith => __$$OrganizerSocialLinkDtoImplCopyWithImpl<
          _$OrganizerSocialLinkDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerSocialLinkDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizerSocialLinkDto implements OrganizerSocialLinkDto {
  const factory _OrganizerSocialLinkDto(
          {@JsonKey(fromJson: _parseStringOrNull) final String? type,
          @JsonKey(fromJson: _parseStringOrNull) final String? url,
          @JsonKey(fromJson: _parseStringOrNull) final String? icon}) =
      _$OrganizerSocialLinkDtoImpl;

  factory _OrganizerSocialLinkDto.fromJson(Map<String, dynamic> json) =
      _$OrganizerSocialLinkDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get type;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get url;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get icon;
  @override
  @JsonKey(ignore: true)
  _$$OrganizerSocialLinkDtoImplCopyWith<_$OrganizerSocialLinkDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrganizerStatsDto _$OrganizerStatsDtoFromJson(Map<String, dynamic> json) {
  return _OrganizerStatsDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizerStatsDto {
  @JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
  int? get totalEvents => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizerStatsDtoCopyWith<OrganizerStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerStatsDtoCopyWith<$Res> {
  factory $OrganizerStatsDtoCopyWith(
          OrganizerStatsDto value, $Res Function(OrganizerStatsDto) then) =
      _$OrganizerStatsDtoCopyWithImpl<$Res, OrganizerStatsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
      int? totalEvents});
}

/// @nodoc
class _$OrganizerStatsDtoCopyWithImpl<$Res, $Val extends OrganizerStatsDto>
    implements $OrganizerStatsDtoCopyWith<$Res> {
  _$OrganizerStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEvents = freezed,
  }) {
    return _then(_value.copyWith(
      totalEvents: freezed == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizerStatsDtoImplCopyWith<$Res>
    implements $OrganizerStatsDtoCopyWith<$Res> {
  factory _$$OrganizerStatsDtoImplCopyWith(_$OrganizerStatsDtoImpl value,
          $Res Function(_$OrganizerStatsDtoImpl) then) =
      __$$OrganizerStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
      int? totalEvents});
}

/// @nodoc
class __$$OrganizerStatsDtoImplCopyWithImpl<$Res>
    extends _$OrganizerStatsDtoCopyWithImpl<$Res, _$OrganizerStatsDtoImpl>
    implements _$$OrganizerStatsDtoImplCopyWith<$Res> {
  __$$OrganizerStatsDtoImplCopyWithImpl(_$OrganizerStatsDtoImpl _value,
      $Res Function(_$OrganizerStatsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEvents = freezed,
  }) {
    return _then(_$OrganizerStatsDtoImpl(
      totalEvents: freezed == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerStatsDtoImpl implements _OrganizerStatsDto {
  const _$OrganizerStatsDtoImpl(
      {@JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
      this.totalEvents});

  factory _$OrganizerStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerStatsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
  final int? totalEvents;

  @override
  String toString() {
    return 'OrganizerStatsDto(totalEvents: $totalEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerStatsDtoImpl &&
            (identical(other.totalEvents, totalEvents) ||
                other.totalEvents == totalEvents));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalEvents);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerStatsDtoImplCopyWith<_$OrganizerStatsDtoImpl> get copyWith =>
      __$$OrganizerStatsDtoImplCopyWithImpl<_$OrganizerStatsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerStatsDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizerStatsDto implements OrganizerStatsDto {
  const factory _OrganizerStatsDto(
      {@JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
      final int? totalEvents}) = _$OrganizerStatsDtoImpl;

  factory _OrganizerStatsDto.fromJson(Map<String, dynamic> json) =
      _$OrganizerStatsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'total_events', fromJson: _parseIntOrNull)
  int? get totalEvents;
  @override
  @JsonKey(ignore: true)
  _$$OrganizerStatsDtoImplCopyWith<_$OrganizerStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrganizerContactDto _$OrganizerContactDtoFromJson(Map<String, dynamic> json) {
  return _OrganizerContactDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizerContactDto {
  @JsonKey(fromJson: _parseStringOrNull)
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get website => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizerContactDtoCopyWith<OrganizerContactDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerContactDtoCopyWith<$Res> {
  factory $OrganizerContactDtoCopyWith(
          OrganizerContactDto value, $Res Function(OrganizerContactDto) then) =
      _$OrganizerContactDtoCopyWithImpl<$Res, OrganizerContactDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? phone,
      @JsonKey(fromJson: _parseStringOrNull) String? email,
      @JsonKey(fromJson: _parseStringOrNull) String? website});
}

/// @nodoc
class _$OrganizerContactDtoCopyWithImpl<$Res, $Val extends OrganizerContactDto>
    implements $OrganizerContactDtoCopyWith<$Res> {
  _$OrganizerContactDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
  }) {
    return _then(_value.copyWith(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizerContactDtoImplCopyWith<$Res>
    implements $OrganizerContactDtoCopyWith<$Res> {
  factory _$$OrganizerContactDtoImplCopyWith(_$OrganizerContactDtoImpl value,
          $Res Function(_$OrganizerContactDtoImpl) then) =
      __$$OrganizerContactDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? phone,
      @JsonKey(fromJson: _parseStringOrNull) String? email,
      @JsonKey(fromJson: _parseStringOrNull) String? website});
}

/// @nodoc
class __$$OrganizerContactDtoImplCopyWithImpl<$Res>
    extends _$OrganizerContactDtoCopyWithImpl<$Res, _$OrganizerContactDtoImpl>
    implements _$$OrganizerContactDtoImplCopyWith<$Res> {
  __$$OrganizerContactDtoImplCopyWithImpl(_$OrganizerContactDtoImpl _value,
      $Res Function(_$OrganizerContactDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
  }) {
    return _then(_$OrganizerContactDtoImpl(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerContactDtoImpl implements _OrganizerContactDto {
  const _$OrganizerContactDtoImpl(
      {@JsonKey(fromJson: _parseStringOrNull) this.phone,
      @JsonKey(fromJson: _parseStringOrNull) this.email,
      @JsonKey(fromJson: _parseStringOrNull) this.website});

  factory _$OrganizerContactDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerContactDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? phone;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? email;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? website;

  @override
  String toString() {
    return 'OrganizerContactDto(phone: $phone, email: $email, website: $website)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerContactDtoImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, email, website);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerContactDtoImplCopyWith<_$OrganizerContactDtoImpl> get copyWith =>
      __$$OrganizerContactDtoImplCopyWithImpl<_$OrganizerContactDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerContactDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizerContactDto implements OrganizerContactDto {
  const factory _OrganizerContactDto(
          {@JsonKey(fromJson: _parseStringOrNull) final String? phone,
          @JsonKey(fromJson: _parseStringOrNull) final String? email,
          @JsonKey(fromJson: _parseStringOrNull) final String? website}) =
      _$OrganizerContactDtoImpl;

  factory _OrganizerContactDto.fromJson(Map<String, dynamic> json) =
      _$OrganizerContactDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get phone;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get email;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get website;
  @override
  @JsonKey(ignore: true)
  _$$OrganizerContactDtoImplCopyWith<_$OrganizerContactDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrganizerLocationDto _$OrganizerLocationDtoFromJson(Map<String, dynamic> json) {
  return _OrganizerLocationDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizerLocationDto {
  @JsonKey(fromJson: _parseStringOrNull)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get postcode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get address => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizerLocationDtoCopyWith<OrganizerLocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerLocationDtoCopyWith<$Res> {
  factory $OrganizerLocationDtoCopyWith(OrganizerLocationDto value,
          $Res Function(OrganizerLocationDto) then) =
      _$OrganizerLocationDtoCopyWithImpl<$Res, OrganizerLocationDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? city,
      @JsonKey(fromJson: _parseStringOrNull) String? country,
      @JsonKey(fromJson: _parseStringOrNull) String? postcode,
      @JsonKey(fromJson: _parseStringOrNull) String? address});
}

/// @nodoc
class _$OrganizerLocationDtoCopyWithImpl<$Res,
        $Val extends OrganizerLocationDto>
    implements $OrganizerLocationDtoCopyWith<$Res> {
  _$OrganizerLocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = freezed,
    Object? country = freezed,
    Object? postcode = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postcode: freezed == postcode
          ? _value.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizerLocationDtoImplCopyWith<$Res>
    implements $OrganizerLocationDtoCopyWith<$Res> {
  factory _$$OrganizerLocationDtoImplCopyWith(_$OrganizerLocationDtoImpl value,
          $Res Function(_$OrganizerLocationDtoImpl) then) =
      __$$OrganizerLocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringOrNull) String? city,
      @JsonKey(fromJson: _parseStringOrNull) String? country,
      @JsonKey(fromJson: _parseStringOrNull) String? postcode,
      @JsonKey(fromJson: _parseStringOrNull) String? address});
}

/// @nodoc
class __$$OrganizerLocationDtoImplCopyWithImpl<$Res>
    extends _$OrganizerLocationDtoCopyWithImpl<$Res, _$OrganizerLocationDtoImpl>
    implements _$$OrganizerLocationDtoImplCopyWith<$Res> {
  __$$OrganizerLocationDtoImplCopyWithImpl(_$OrganizerLocationDtoImpl _value,
      $Res Function(_$OrganizerLocationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = freezed,
    Object? country = freezed,
    Object? postcode = freezed,
    Object? address = freezed,
  }) {
    return _then(_$OrganizerLocationDtoImpl(
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postcode: freezed == postcode
          ? _value.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerLocationDtoImpl implements _OrganizerLocationDto {
  const _$OrganizerLocationDtoImpl(
      {@JsonKey(fromJson: _parseStringOrNull) this.city,
      @JsonKey(fromJson: _parseStringOrNull) this.country,
      @JsonKey(fromJson: _parseStringOrNull) this.postcode,
      @JsonKey(fromJson: _parseStringOrNull) this.address});

  factory _$OrganizerLocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerLocationDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? city;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? country;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? postcode;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? address;

  @override
  String toString() {
    return 'OrganizerLocationDto(city: $city, country: $country, postcode: $postcode, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerLocationDtoImpl &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, city, country, postcode, address);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerLocationDtoImplCopyWith<_$OrganizerLocationDtoImpl>
      get copyWith =>
          __$$OrganizerLocationDtoImplCopyWithImpl<_$OrganizerLocationDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerLocationDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizerLocationDto implements OrganizerLocationDto {
  const factory _OrganizerLocationDto(
          {@JsonKey(fromJson: _parseStringOrNull) final String? city,
          @JsonKey(fromJson: _parseStringOrNull) final String? country,
          @JsonKey(fromJson: _parseStringOrNull) final String? postcode,
          @JsonKey(fromJson: _parseStringOrNull) final String? address}) =
      _$OrganizerLocationDtoImpl;

  factory _OrganizerLocationDto.fromJson(Map<String, dynamic> json) =
      _$OrganizerLocationDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get city;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get country;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get postcode;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get address;
  @override
  @JsonKey(ignore: true)
  _$$OrganizerLocationDtoImplCopyWith<_$OrganizerLocationDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrganizerPracticalInfoDto _$OrganizerPracticalInfoDtoFromJson(
    Map<String, dynamic> json) {
  return _OrganizerPracticalInfoDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizerPracticalInfoDto {
// PMR
  bool get pmr => throw _privateConstructorUsedError;
  @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull)
  String? get pmrInfos => throw _privateConstructorUsedError; // Restauration
  bool get restauration => throw _privateConstructorUsedError;
  @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
  String? get restaurationInfos =>
      throw _privateConstructorUsedError; // Boisson
  bool get boisson => throw _privateConstructorUsedError;
  @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
  String? get boissonInfos =>
      throw _privateConstructorUsedError; // Stationnement
  @JsonKey(fromJson: _parseStringOrNull)
  String? get stationnement => throw _privateConstructorUsedError; // Event Type
  @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
  String? get eventType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizerPracticalInfoDtoCopyWith<OrganizerPracticalInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerPracticalInfoDtoCopyWith<$Res> {
  factory $OrganizerPracticalInfoDtoCopyWith(OrganizerPracticalInfoDto value,
          $Res Function(OrganizerPracticalInfoDto) then) =
      _$OrganizerPracticalInfoDtoCopyWithImpl<$Res, OrganizerPracticalInfoDto>;
  @useResult
  $Res call(
      {bool pmr,
      @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull)
      String? pmrInfos,
      bool restauration,
      @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
      String? restaurationInfos,
      bool boisson,
      @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
      String? boissonInfos,
      @JsonKey(fromJson: _parseStringOrNull) String? stationnement,
      @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
      String? eventType});
}

/// @nodoc
class _$OrganizerPracticalInfoDtoCopyWithImpl<$Res,
        $Val extends OrganizerPracticalInfoDto>
    implements $OrganizerPracticalInfoDtoCopyWith<$Res> {
  _$OrganizerPracticalInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pmr = null,
    Object? pmrInfos = freezed,
    Object? restauration = null,
    Object? restaurationInfos = freezed,
    Object? boisson = null,
    Object? boissonInfos = freezed,
    Object? stationnement = freezed,
    Object? eventType = freezed,
  }) {
    return _then(_value.copyWith(
      pmr: null == pmr
          ? _value.pmr
          : pmr // ignore: cast_nullable_to_non_nullable
              as bool,
      pmrInfos: freezed == pmrInfos
          ? _value.pmrInfos
          : pmrInfos // ignore: cast_nullable_to_non_nullable
              as String?,
      restauration: null == restauration
          ? _value.restauration
          : restauration // ignore: cast_nullable_to_non_nullable
              as bool,
      restaurationInfos: freezed == restaurationInfos
          ? _value.restaurationInfos
          : restaurationInfos // ignore: cast_nullable_to_non_nullable
              as String?,
      boisson: null == boisson
          ? _value.boisson
          : boisson // ignore: cast_nullable_to_non_nullable
              as bool,
      boissonInfos: freezed == boissonInfos
          ? _value.boissonInfos
          : boissonInfos // ignore: cast_nullable_to_non_nullable
              as String?,
      stationnement: freezed == stationnement
          ? _value.stationnement
          : stationnement // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizerPracticalInfoDtoImplCopyWith<$Res>
    implements $OrganizerPracticalInfoDtoCopyWith<$Res> {
  factory _$$OrganizerPracticalInfoDtoImplCopyWith(
          _$OrganizerPracticalInfoDtoImpl value,
          $Res Function(_$OrganizerPracticalInfoDtoImpl) then) =
      __$$OrganizerPracticalInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool pmr,
      @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull)
      String? pmrInfos,
      bool restauration,
      @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
      String? restaurationInfos,
      bool boisson,
      @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
      String? boissonInfos,
      @JsonKey(fromJson: _parseStringOrNull) String? stationnement,
      @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
      String? eventType});
}

/// @nodoc
class __$$OrganizerPracticalInfoDtoImplCopyWithImpl<$Res>
    extends _$OrganizerPracticalInfoDtoCopyWithImpl<$Res,
        _$OrganizerPracticalInfoDtoImpl>
    implements _$$OrganizerPracticalInfoDtoImplCopyWith<$Res> {
  __$$OrganizerPracticalInfoDtoImplCopyWithImpl(
      _$OrganizerPracticalInfoDtoImpl _value,
      $Res Function(_$OrganizerPracticalInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pmr = null,
    Object? pmrInfos = freezed,
    Object? restauration = null,
    Object? restaurationInfos = freezed,
    Object? boisson = null,
    Object? boissonInfos = freezed,
    Object? stationnement = freezed,
    Object? eventType = freezed,
  }) {
    return _then(_$OrganizerPracticalInfoDtoImpl(
      pmr: null == pmr
          ? _value.pmr
          : pmr // ignore: cast_nullable_to_non_nullable
              as bool,
      pmrInfos: freezed == pmrInfos
          ? _value.pmrInfos
          : pmrInfos // ignore: cast_nullable_to_non_nullable
              as String?,
      restauration: null == restauration
          ? _value.restauration
          : restauration // ignore: cast_nullable_to_non_nullable
              as bool,
      restaurationInfos: freezed == restaurationInfos
          ? _value.restaurationInfos
          : restaurationInfos // ignore: cast_nullable_to_non_nullable
              as String?,
      boisson: null == boisson
          ? _value.boisson
          : boisson // ignore: cast_nullable_to_non_nullable
              as bool,
      boissonInfos: freezed == boissonInfos
          ? _value.boissonInfos
          : boissonInfos // ignore: cast_nullable_to_non_nullable
              as String?,
      stationnement: freezed == stationnement
          ? _value.stationnement
          : stationnement // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerPracticalInfoDtoImpl implements _OrganizerPracticalInfoDto {
  const _$OrganizerPracticalInfoDtoImpl(
      {this.pmr = false,
      @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull) this.pmrInfos,
      this.restauration = false,
      @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
      this.restaurationInfos,
      this.boisson = false,
      @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
      this.boissonInfos,
      @JsonKey(fromJson: _parseStringOrNull) this.stationnement,
      @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
      this.eventType});

  factory _$OrganizerPracticalInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerPracticalInfoDtoImplFromJson(json);

// PMR
  @override
  @JsonKey()
  final bool pmr;
  @override
  @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull)
  final String? pmrInfos;
// Restauration
  @override
  @JsonKey()
  final bool restauration;
  @override
  @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
  final String? restaurationInfos;
// Boisson
  @override
  @JsonKey()
  final bool boisson;
  @override
  @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
  final String? boissonInfos;
// Stationnement
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? stationnement;
// Event Type
  @override
  @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
  final String? eventType;

  @override
  String toString() {
    return 'OrganizerPracticalInfoDto(pmr: $pmr, pmrInfos: $pmrInfos, restauration: $restauration, restaurationInfos: $restaurationInfos, boisson: $boisson, boissonInfos: $boissonInfos, stationnement: $stationnement, eventType: $eventType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerPracticalInfoDtoImpl &&
            (identical(other.pmr, pmr) || other.pmr == pmr) &&
            (identical(other.pmrInfos, pmrInfos) ||
                other.pmrInfos == pmrInfos) &&
            (identical(other.restauration, restauration) ||
                other.restauration == restauration) &&
            (identical(other.restaurationInfos, restaurationInfos) ||
                other.restaurationInfos == restaurationInfos) &&
            (identical(other.boisson, boisson) || other.boisson == boisson) &&
            (identical(other.boissonInfos, boissonInfos) ||
                other.boissonInfos == boissonInfos) &&
            (identical(other.stationnement, stationnement) ||
                other.stationnement == stationnement) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pmr, pmrInfos, restauration,
      restaurationInfos, boisson, boissonInfos, stationnement, eventType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerPracticalInfoDtoImplCopyWith<_$OrganizerPracticalInfoDtoImpl>
      get copyWith => __$$OrganizerPracticalInfoDtoImplCopyWithImpl<
          _$OrganizerPracticalInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerPracticalInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizerPracticalInfoDto implements OrganizerPracticalInfoDto {
  const factory _OrganizerPracticalInfoDto(
      {final bool pmr,
      @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull)
      final String? pmrInfos,
      final bool restauration,
      @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
      final String? restaurationInfos,
      final bool boisson,
      @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
      final String? boissonInfos,
      @JsonKey(fromJson: _parseStringOrNull) final String? stationnement,
      @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
      final String? eventType}) = _$OrganizerPracticalInfoDtoImpl;

  factory _OrganizerPracticalInfoDto.fromJson(Map<String, dynamic> json) =
      _$OrganizerPracticalInfoDtoImpl.fromJson;

  @override // PMR
  bool get pmr;
  @override
  @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull)
  String? get pmrInfos;
  @override // Restauration
  bool get restauration;
  @override
  @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull)
  String? get restaurationInfos;
  @override // Boisson
  bool get boisson;
  @override
  @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull)
  String? get boissonInfos;
  @override // Stationnement
  @JsonKey(fromJson: _parseStringOrNull)
  String? get stationnement;
  @override // Event Type
  @JsonKey(name: 'event_type', fromJson: _parseStringOrNull)
  String? get eventType;
  @override
  @JsonKey(ignore: true)
  _$$OrganizerPracticalInfoDtoImplCopyWith<_$OrganizerPracticalInfoDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CoOrganizerDto _$CoOrganizerDtoFromJson(Map<String, dynamic> json) {
  return _CoOrganizerDto.fromJson(json);
}

/// @nodoc
mixin _$CoOrganizerDto {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_label', fromJson: _parseStringOrNull)
  String? get roleLabel => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
  String? get profileUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoOrganizerDtoCopyWith<CoOrganizerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoOrganizerDtoCopyWith<$Res> {
  factory $CoOrganizerDtoCopyWith(
          CoOrganizerDto value, $Res Function(CoOrganizerDto) then) =
      _$CoOrganizerDtoCopyWithImpl<$Res, CoOrganizerDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? logo,
      @JsonKey(fromJson: _parseStringOrNull) String? role,
      @JsonKey(name: 'role_label', fromJson: _parseStringOrNull)
      String? roleLabel,
      @JsonKey(fromJson: _parseStringOrNull) String? city,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      String? profileUrl});
}

/// @nodoc
class _$CoOrganizerDtoCopyWithImpl<$Res, $Val extends CoOrganizerDto>
    implements $CoOrganizerDtoCopyWith<$Res> {
  _$CoOrganizerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logo = freezed,
    Object? role = freezed,
    Object? roleLabel = freezed,
    Object? city = freezed,
    Object? profileUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _value.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoOrganizerDtoImplCopyWith<$Res>
    implements $CoOrganizerDtoCopyWith<$Res> {
  factory _$$CoOrganizerDtoImplCopyWith(_$CoOrganizerDtoImpl value,
          $Res Function(_$CoOrganizerDtoImpl) then) =
      __$$CoOrganizerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? logo,
      @JsonKey(fromJson: _parseStringOrNull) String? role,
      @JsonKey(name: 'role_label', fromJson: _parseStringOrNull)
      String? roleLabel,
      @JsonKey(fromJson: _parseStringOrNull) String? city,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      String? profileUrl});
}

/// @nodoc
class __$$CoOrganizerDtoImplCopyWithImpl<$Res>
    extends _$CoOrganizerDtoCopyWithImpl<$Res, _$CoOrganizerDtoImpl>
    implements _$$CoOrganizerDtoImplCopyWith<$Res> {
  __$$CoOrganizerDtoImplCopyWithImpl(
      _$CoOrganizerDtoImpl _value, $Res Function(_$CoOrganizerDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logo = freezed,
    Object? role = freezed,
    Object? roleLabel = freezed,
    Object? city = freezed,
    Object? profileUrl = freezed,
  }) {
    return _then(_$CoOrganizerDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _value.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoOrganizerDtoImpl implements _CoOrganizerDto {
  const _$CoOrganizerDtoImpl(
      {@JsonKey(fromJson: _parseInt) this.id = 0,
      @JsonKey(fromJson: _parseHtmlString) this.name = '',
      @JsonKey(fromJson: _parseStringOrNull) this.logo,
      @JsonKey(fromJson: _parseStringOrNull) this.role,
      @JsonKey(name: 'role_label', fromJson: _parseStringOrNull) this.roleLabel,
      @JsonKey(fromJson: _parseStringOrNull) this.city,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      this.profileUrl});

  factory _$CoOrganizerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoOrganizerDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? logo;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? role;
  @override
  @JsonKey(name: 'role_label', fromJson: _parseStringOrNull)
  final String? roleLabel;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? city;
  @override
  @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
  final String? profileUrl;

  @override
  String toString() {
    return 'CoOrganizerDto(id: $id, name: $name, logo: $logo, role: $role, roleLabel: $roleLabel, city: $city, profileUrl: $profileUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoOrganizerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, logo, role, roleLabel, city, profileUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoOrganizerDtoImplCopyWith<_$CoOrganizerDtoImpl> get copyWith =>
      __$$CoOrganizerDtoImplCopyWithImpl<_$CoOrganizerDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoOrganizerDtoImplToJson(
      this,
    );
  }
}

abstract class _CoOrganizerDto implements CoOrganizerDto {
  const factory _CoOrganizerDto(
      {@JsonKey(fromJson: _parseInt) final int id,
      @JsonKey(fromJson: _parseHtmlString) final String name,
      @JsonKey(fromJson: _parseStringOrNull) final String? logo,
      @JsonKey(fromJson: _parseStringOrNull) final String? role,
      @JsonKey(name: 'role_label', fromJson: _parseStringOrNull)
      final String? roleLabel,
      @JsonKey(fromJson: _parseStringOrNull) final String? city,
      @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
      final String? profileUrl}) = _$CoOrganizerDtoImpl;

  factory _CoOrganizerDto.fromJson(Map<String, dynamic> json) =
      _$CoOrganizerDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get logo;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get role;
  @override
  @JsonKey(name: 'role_label', fromJson: _parseStringOrNull)
  String? get roleLabel;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get city;
  @override
  @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull)
  String? get profileUrl;
  @override
  @JsonKey(ignore: true)
  _$$CoOrganizerDtoImplCopyWith<_$CoOrganizerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventCapacityDto _$EventCapacityDtoFromJson(Map<String, dynamic> json) {
  return _EventCapacityDto.fromJson(json);
}

/// @nodoc
mixin _$EventCapacityDto {
  int? get total => throw _privateConstructorUsedError;
  int? get available => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCapacityDtoCopyWith<EventCapacityDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCapacityDtoCopyWith<$Res> {
  factory $EventCapacityDtoCopyWith(
          EventCapacityDto value, $Res Function(EventCapacityDto) then) =
      _$EventCapacityDtoCopyWithImpl<$Res, EventCapacityDto>;
  @useResult
  $Res call({int? total, int? available});
}

/// @nodoc
class _$EventCapacityDtoCopyWithImpl<$Res, $Val extends EventCapacityDto>
    implements $EventCapacityDtoCopyWith<$Res> {
  _$EventCapacityDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = freezed,
    Object? available = freezed,
  }) {
    return _then(_value.copyWith(
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      available: freezed == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCapacityDtoImplCopyWith<$Res>
    implements $EventCapacityDtoCopyWith<$Res> {
  factory _$$EventCapacityDtoImplCopyWith(_$EventCapacityDtoImpl value,
          $Res Function(_$EventCapacityDtoImpl) then) =
      __$$EventCapacityDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? total, int? available});
}

/// @nodoc
class __$$EventCapacityDtoImplCopyWithImpl<$Res>
    extends _$EventCapacityDtoCopyWithImpl<$Res, _$EventCapacityDtoImpl>
    implements _$$EventCapacityDtoImplCopyWith<$Res> {
  __$$EventCapacityDtoImplCopyWithImpl(_$EventCapacityDtoImpl _value,
      $Res Function(_$EventCapacityDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = freezed,
    Object? available = freezed,
  }) {
    return _then(_$EventCapacityDtoImpl(
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      available: freezed == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCapacityDtoImpl implements _EventCapacityDto {
  const _$EventCapacityDtoImpl({this.total, this.available});

  factory _$EventCapacityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCapacityDtoImplFromJson(json);

  @override
  final int? total;
  @override
  final int? available;

  @override
  String toString() {
    return 'EventCapacityDto(total: $total, available: $available)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCapacityDtoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, total, available);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCapacityDtoImplCopyWith<_$EventCapacityDtoImpl> get copyWith =>
      __$$EventCapacityDtoImplCopyWithImpl<_$EventCapacityDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCapacityDtoImplToJson(
      this,
    );
  }
}

abstract class _EventCapacityDto implements EventCapacityDto {
  const factory _EventCapacityDto({final int? total, final int? available}) =
      _$EventCapacityDtoImpl;

  factory _EventCapacityDto.fromJson(Map<String, dynamic> json) =
      _$EventCapacityDtoImpl.fromJson;

  @override
  int? get total;
  @override
  int? get available;
  @override
  @JsonKey(ignore: true)
  _$$EventCapacityDtoImplCopyWith<_$EventCapacityDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventsResponseDto _$EventsResponseDtoFromJson(Map<String, dynamic> json) {
  return _EventsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$EventsResponseDto {
  List<EventDto> get events => throw _privateConstructorUsedError;
  PaginationDto get pagination => throw _privateConstructorUsedError;
  @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
  dynamic get filtersApplied => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventsResponseDtoCopyWith<EventsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventsResponseDtoCopyWith<$Res> {
  factory $EventsResponseDtoCopyWith(
          EventsResponseDto value, $Res Function(EventsResponseDto) then) =
      _$EventsResponseDtoCopyWithImpl<$Res, EventsResponseDto>;
  @useResult
  $Res call(
      {List<EventDto> events,
      PaginationDto pagination,
      @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
      dynamic filtersApplied});

  $PaginationDtoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$EventsResponseDtoCopyWithImpl<$Res, $Val extends EventsResponseDto>
    implements $EventsResponseDtoCopyWith<$Res> {
  _$EventsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
    Object? pagination = null,
    Object? filtersApplied = freezed,
  }) {
    return _then(_value.copyWith(
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationDto,
      filtersApplied: freezed == filtersApplied
          ? _value.filtersApplied
          : filtersApplied // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationDtoCopyWith<$Res> get pagination {
    return $PaginationDtoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventsResponseDtoImplCopyWith<$Res>
    implements $EventsResponseDtoCopyWith<$Res> {
  factory _$$EventsResponseDtoImplCopyWith(_$EventsResponseDtoImpl value,
          $Res Function(_$EventsResponseDtoImpl) then) =
      __$$EventsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EventDto> events,
      PaginationDto pagination,
      @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
      dynamic filtersApplied});

  @override
  $PaginationDtoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$EventsResponseDtoImplCopyWithImpl<$Res>
    extends _$EventsResponseDtoCopyWithImpl<$Res, _$EventsResponseDtoImpl>
    implements _$$EventsResponseDtoImplCopyWith<$Res> {
  __$$EventsResponseDtoImplCopyWithImpl(_$EventsResponseDtoImpl _value,
      $Res Function(_$EventsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
    Object? pagination = null,
    Object? filtersApplied = freezed,
  }) {
    return _then(_$EventsResponseDtoImpl(
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationDto,
      filtersApplied: freezed == filtersApplied
          ? _value.filtersApplied
          : filtersApplied // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventsResponseDtoImpl implements _EventsResponseDto {
  const _$EventsResponseDtoImpl(
      {required final List<EventDto> events,
      required this.pagination,
      @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
      this.filtersApplied})
      : _events = events;

  factory _$EventsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventsResponseDtoImplFromJson(json);

  final List<EventDto> _events;
  @override
  List<EventDto> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final PaginationDto pagination;
  @override
  @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
  final dynamic filtersApplied;

  @override
  String toString() {
    return 'EventsResponseDto(events: $events, pagination: $pagination, filtersApplied: $filtersApplied)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventsResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            const DeepCollectionEquality()
                .equals(other.filtersApplied, filtersApplied));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_events),
      pagination,
      const DeepCollectionEquality().hash(filtersApplied));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventsResponseDtoImplCopyWith<_$EventsResponseDtoImpl> get copyWith =>
      __$$EventsResponseDtoImplCopyWithImpl<_$EventsResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _EventsResponseDto implements EventsResponseDto {
  const factory _EventsResponseDto(
      {required final List<EventDto> events,
      required final PaginationDto pagination,
      @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
      final dynamic filtersApplied}) = _$EventsResponseDtoImpl;

  factory _EventsResponseDto.fromJson(Map<String, dynamic> json) =
      _$EventsResponseDtoImpl.fromJson;

  @override
  List<EventDto> get events;
  @override
  PaginationDto get pagination;
  @override
  @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied)
  dynamic get filtersApplied;
  @override
  @JsonKey(ignore: true)
  _$$EventsResponseDtoImplCopyWith<_$EventsResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationDto _$PaginationDtoFromJson(Map<String, dynamic> json) {
  return _PaginationDto.fromJson(json);
}

/// @nodoc
mixin _$PaginationDto {
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items', fromJson: _parseInt)
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages', fromJson: _parseInt)
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_next', fromJson: _parseBool)
  bool get hasNext => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_prev', fromJson: _parseBool)
  bool get hasPrev => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationDtoCopyWith<PaginationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationDtoCopyWith<$Res> {
  factory $PaginationDtoCopyWith(
          PaginationDto value, $Res Function(PaginationDto) then) =
      _$PaginationDtoCopyWithImpl<$Res, PaginationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) int currentPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) int perPage,
      @JsonKey(name: 'total_items', fromJson: _parseInt) int totalItems,
      @JsonKey(name: 'total_pages', fromJson: _parseInt) int totalPages,
      @JsonKey(name: 'has_next', fromJson: _parseBool) bool hasNext,
      @JsonKey(name: 'has_prev', fromJson: _parseBool) bool hasPrev});
}

/// @nodoc
class _$PaginationDtoCopyWithImpl<$Res, $Val extends PaginationDto>
    implements $PaginationDtoCopyWith<$Res> {
  _$PaginationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? perPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationDtoImplCopyWith<$Res>
    implements $PaginationDtoCopyWith<$Res> {
  factory _$$PaginationDtoImplCopyWith(
          _$PaginationDtoImpl value, $Res Function(_$PaginationDtoImpl) then) =
      __$$PaginationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) int currentPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) int perPage,
      @JsonKey(name: 'total_items', fromJson: _parseInt) int totalItems,
      @JsonKey(name: 'total_pages', fromJson: _parseInt) int totalPages,
      @JsonKey(name: 'has_next', fromJson: _parseBool) bool hasNext,
      @JsonKey(name: 'has_prev', fromJson: _parseBool) bool hasPrev});
}

/// @nodoc
class __$$PaginationDtoImplCopyWithImpl<$Res>
    extends _$PaginationDtoCopyWithImpl<$Res, _$PaginationDtoImpl>
    implements _$$PaginationDtoImplCopyWith<$Res> {
  __$$PaginationDtoImplCopyWithImpl(
      _$PaginationDtoImpl _value, $Res Function(_$PaginationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? perPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_$PaginationDtoImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationDtoImpl implements _PaginationDto {
  const _$PaginationDtoImpl(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) this.currentPage = 1,
      @JsonKey(name: 'per_page', fromJson: _parseInt) this.perPage = 10,
      @JsonKey(name: 'total_items', fromJson: _parseInt) this.totalItems = 0,
      @JsonKey(name: 'total_pages', fromJson: _parseInt) this.totalPages = 0,
      @JsonKey(name: 'has_next', fromJson: _parseBool) this.hasNext = false,
      @JsonKey(name: 'has_prev', fromJson: _parseBool) this.hasPrev = false});

  factory _$PaginationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  final int currentPage;
  @override
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  final int perPage;
  @override
  @JsonKey(name: 'total_items', fromJson: _parseInt)
  final int totalItems;
  @override
  @JsonKey(name: 'total_pages', fromJson: _parseInt)
  final int totalPages;
  @override
  @JsonKey(name: 'has_next', fromJson: _parseBool)
  final bool hasNext;
  @override
  @JsonKey(name: 'has_prev', fromJson: _parseBool)
  final bool hasPrev;

  @override
  String toString() {
    return 'PaginationDto(currentPage: $currentPage, perPage: $perPage, totalItems: $totalItems, totalPages: $totalPages, hasNext: $hasNext, hasPrev: $hasPrev)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationDtoImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrev, hasPrev) || other.hasPrev == hasPrev));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage, perPage, totalItems,
      totalPages, hasNext, hasPrev);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationDtoImplCopyWith<_$PaginationDtoImpl> get copyWith =>
      __$$PaginationDtoImplCopyWithImpl<_$PaginationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationDtoImplToJson(
      this,
    );
  }
}

abstract class _PaginationDto implements PaginationDto {
  const factory _PaginationDto(
      {@JsonKey(name: 'current_page', fromJson: _parseInt)
      final int currentPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) final int perPage,
      @JsonKey(name: 'total_items', fromJson: _parseInt) final int totalItems,
      @JsonKey(name: 'total_pages', fromJson: _parseInt) final int totalPages,
      @JsonKey(name: 'has_next', fromJson: _parseBool) final bool hasNext,
      @JsonKey(name: 'has_prev', fromJson: _parseBool)
      final bool hasPrev}) = _$PaginationDtoImpl;

  factory _PaginationDto.fromJson(Map<String, dynamic> json) =
      _$PaginationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  int get currentPage;
  @override
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  int get perPage;
  @override
  @JsonKey(name: 'total_items', fromJson: _parseInt)
  int get totalItems;
  @override
  @JsonKey(name: 'total_pages', fromJson: _parseInt)
  int get totalPages;
  @override
  @JsonKey(name: 'has_next', fromJson: _parseBool)
  bool get hasNext;
  @override
  @JsonKey(name: 'has_prev', fromJson: _parseBool)
  bool get hasPrev;
  @override
  @JsonKey(ignore: true)
  _$$PaginationDtoImplCopyWith<_$PaginationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FiltersResponseDto _$FiltersResponseDtoFromJson(Map<String, dynamic> json) {
  return _FiltersResponseDto.fromJson(json);
}

/// @nodoc
mixin _$FiltersResponseDto {
  List<EventCategoryDto> get categories => throw _privateConstructorUsedError;
  List<ThematiqueDto> get thematiques => throw _privateConstructorUsedError;
  List<String> get cities => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_range')
  PriceRangeDto get priceRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_options')
  List<SortOptionDto> get sortOptions => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_filters')
  List<AdditionalFilterDto>? get additionalFilters =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FiltersResponseDtoCopyWith<FiltersResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiltersResponseDtoCopyWith<$Res> {
  factory $FiltersResponseDtoCopyWith(
          FiltersResponseDto value, $Res Function(FiltersResponseDto) then) =
      _$FiltersResponseDtoCopyWithImpl<$Res, FiltersResponseDto>;
  @useResult
  $Res call(
      {List<EventCategoryDto> categories,
      List<ThematiqueDto> thematiques,
      List<String> cities,
      @JsonKey(name: 'price_range') PriceRangeDto priceRange,
      @JsonKey(name: 'sort_options') List<SortOptionDto> sortOptions,
      @JsonKey(name: 'additional_filters')
      List<AdditionalFilterDto>? additionalFilters});

  $PriceRangeDtoCopyWith<$Res> get priceRange;
}

/// @nodoc
class _$FiltersResponseDtoCopyWithImpl<$Res, $Val extends FiltersResponseDto>
    implements $FiltersResponseDtoCopyWith<$Res> {
  _$FiltersResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? thematiques = null,
    Object? cities = null,
    Object? priceRange = null,
    Object? sortOptions = null,
    Object? additionalFilters = freezed,
  }) {
    return _then(_value.copyWith(
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<EventCategoryDto>,
      thematiques: null == thematiques
          ? _value.thematiques
          : thematiques // ignore: cast_nullable_to_non_nullable
              as List<ThematiqueDto>,
      cities: null == cities
          ? _value.cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priceRange: null == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as PriceRangeDto,
      sortOptions: null == sortOptions
          ? _value.sortOptions
          : sortOptions // ignore: cast_nullable_to_non_nullable
              as List<SortOptionDto>,
      additionalFilters: freezed == additionalFilters
          ? _value.additionalFilters
          : additionalFilters // ignore: cast_nullable_to_non_nullable
              as List<AdditionalFilterDto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PriceRangeDtoCopyWith<$Res> get priceRange {
    return $PriceRangeDtoCopyWith<$Res>(_value.priceRange, (value) {
      return _then(_value.copyWith(priceRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FiltersResponseDtoImplCopyWith<$Res>
    implements $FiltersResponseDtoCopyWith<$Res> {
  factory _$$FiltersResponseDtoImplCopyWith(_$FiltersResponseDtoImpl value,
          $Res Function(_$FiltersResponseDtoImpl) then) =
      __$$FiltersResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EventCategoryDto> categories,
      List<ThematiqueDto> thematiques,
      List<String> cities,
      @JsonKey(name: 'price_range') PriceRangeDto priceRange,
      @JsonKey(name: 'sort_options') List<SortOptionDto> sortOptions,
      @JsonKey(name: 'additional_filters')
      List<AdditionalFilterDto>? additionalFilters});

  @override
  $PriceRangeDtoCopyWith<$Res> get priceRange;
}

/// @nodoc
class __$$FiltersResponseDtoImplCopyWithImpl<$Res>
    extends _$FiltersResponseDtoCopyWithImpl<$Res, _$FiltersResponseDtoImpl>
    implements _$$FiltersResponseDtoImplCopyWith<$Res> {
  __$$FiltersResponseDtoImplCopyWithImpl(_$FiltersResponseDtoImpl _value,
      $Res Function(_$FiltersResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? thematiques = null,
    Object? cities = null,
    Object? priceRange = null,
    Object? sortOptions = null,
    Object? additionalFilters = freezed,
  }) {
    return _then(_$FiltersResponseDtoImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<EventCategoryDto>,
      thematiques: null == thematiques
          ? _value._thematiques
          : thematiques // ignore: cast_nullable_to_non_nullable
              as List<ThematiqueDto>,
      cities: null == cities
          ? _value._cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priceRange: null == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as PriceRangeDto,
      sortOptions: null == sortOptions
          ? _value._sortOptions
          : sortOptions // ignore: cast_nullable_to_non_nullable
              as List<SortOptionDto>,
      additionalFilters: freezed == additionalFilters
          ? _value._additionalFilters
          : additionalFilters // ignore: cast_nullable_to_non_nullable
              as List<AdditionalFilterDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FiltersResponseDtoImpl implements _FiltersResponseDto {
  const _$FiltersResponseDtoImpl(
      {required final List<EventCategoryDto> categories,
      required final List<ThematiqueDto> thematiques,
      required final List<String> cities,
      @JsonKey(name: 'price_range') required this.priceRange,
      @JsonKey(name: 'sort_options')
      required final List<SortOptionDto> sortOptions,
      @JsonKey(name: 'additional_filters')
      final List<AdditionalFilterDto>? additionalFilters})
      : _categories = categories,
        _thematiques = thematiques,
        _cities = cities,
        _sortOptions = sortOptions,
        _additionalFilters = additionalFilters;

  factory _$FiltersResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FiltersResponseDtoImplFromJson(json);

  final List<EventCategoryDto> _categories;
  @override
  List<EventCategoryDto> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<ThematiqueDto> _thematiques;
  @override
  List<ThematiqueDto> get thematiques {
    if (_thematiques is EqualUnmodifiableListView) return _thematiques;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thematiques);
  }

  final List<String> _cities;
  @override
  List<String> get cities {
    if (_cities is EqualUnmodifiableListView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cities);
  }

  @override
  @JsonKey(name: 'price_range')
  final PriceRangeDto priceRange;
  final List<SortOptionDto> _sortOptions;
  @override
  @JsonKey(name: 'sort_options')
  List<SortOptionDto> get sortOptions {
    if (_sortOptions is EqualUnmodifiableListView) return _sortOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sortOptions);
  }

  final List<AdditionalFilterDto>? _additionalFilters;
  @override
  @JsonKey(name: 'additional_filters')
  List<AdditionalFilterDto>? get additionalFilters {
    final value = _additionalFilters;
    if (value == null) return null;
    if (_additionalFilters is EqualUnmodifiableListView)
      return _additionalFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FiltersResponseDto(categories: $categories, thematiques: $thematiques, cities: $cities, priceRange: $priceRange, sortOptions: $sortOptions, additionalFilters: $additionalFilters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiltersResponseDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._thematiques, _thematiques) &&
            const DeepCollectionEquality().equals(other._cities, _cities) &&
            (identical(other.priceRange, priceRange) ||
                other.priceRange == priceRange) &&
            const DeepCollectionEquality()
                .equals(other._sortOptions, _sortOptions) &&
            const DeepCollectionEquality()
                .equals(other._additionalFilters, _additionalFilters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_thematiques),
      const DeepCollectionEquality().hash(_cities),
      priceRange,
      const DeepCollectionEquality().hash(_sortOptions),
      const DeepCollectionEquality().hash(_additionalFilters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FiltersResponseDtoImplCopyWith<_$FiltersResponseDtoImpl> get copyWith =>
      __$$FiltersResponseDtoImplCopyWithImpl<_$FiltersResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FiltersResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _FiltersResponseDto implements FiltersResponseDto {
  const factory _FiltersResponseDto(
          {required final List<EventCategoryDto> categories,
          required final List<ThematiqueDto> thematiques,
          required final List<String> cities,
          @JsonKey(name: 'price_range') required final PriceRangeDto priceRange,
          @JsonKey(name: 'sort_options')
          required final List<SortOptionDto> sortOptions,
          @JsonKey(name: 'additional_filters')
          final List<AdditionalFilterDto>? additionalFilters}) =
      _$FiltersResponseDtoImpl;

  factory _FiltersResponseDto.fromJson(Map<String, dynamic> json) =
      _$FiltersResponseDtoImpl.fromJson;

  @override
  List<EventCategoryDto> get categories;
  @override
  List<ThematiqueDto> get thematiques;
  @override
  List<String> get cities;
  @override
  @JsonKey(name: 'price_range')
  PriceRangeDto get priceRange;
  @override
  @JsonKey(name: 'sort_options')
  List<SortOptionDto> get sortOptions;
  @override
  @JsonKey(name: 'additional_filters')
  List<AdditionalFilterDto>? get additionalFilters;
  @override
  @JsonKey(ignore: true)
  _$$FiltersResponseDtoImplCopyWith<_$FiltersResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThematiqueDto _$ThematiqueDtoFromJson(Map<String, dynamic> json) {
  return _ThematiqueDto.fromJson(json);
}

/// @nodoc
mixin _$ThematiqueDto {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseHtmlString)
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
  int? get eventCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThematiqueDtoCopyWith<ThematiqueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThematiqueDtoCopyWith<$Res> {
  factory $ThematiqueDtoCopyWith(
          ThematiqueDto value, $Res Function(ThematiqueDto) then) =
      _$ThematiqueDtoCopyWithImpl<$Res, ThematiqueDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseHtmlString) String slug,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      int? eventCount});
}

/// @nodoc
class _$ThematiqueDtoCopyWithImpl<$Res, $Val extends ThematiqueDto>
    implements $ThematiqueDtoCopyWith<$Res> {
  _$ThematiqueDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? eventCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThematiqueDtoImplCopyWith<$Res>
    implements $ThematiqueDtoCopyWith<$Res> {
  factory _$$ThematiqueDtoImplCopyWith(
          _$ThematiqueDtoImpl value, $Res Function(_$ThematiqueDtoImpl) then) =
      __$$ThematiqueDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(fromJson: _parseHtmlString) String name,
      @JsonKey(fromJson: _parseHtmlString) String slug,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      int? eventCount});
}

/// @nodoc
class __$$ThematiqueDtoImplCopyWithImpl<$Res>
    extends _$ThematiqueDtoCopyWithImpl<$Res, _$ThematiqueDtoImpl>
    implements _$$ThematiqueDtoImplCopyWith<$Res> {
  __$$ThematiqueDtoImplCopyWithImpl(
      _$ThematiqueDtoImpl _value, $Res Function(_$ThematiqueDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? eventCount = freezed,
  }) {
    return _then(_$ThematiqueDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThematiqueDtoImpl implements _ThematiqueDto {
  const _$ThematiqueDtoImpl(
      {@JsonKey(fromJson: _parseInt) this.id = 0,
      @JsonKey(fromJson: _parseHtmlString) this.name = '',
      @JsonKey(fromJson: _parseHtmlString) this.slug = '',
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      this.eventCount});

  factory _$ThematiqueDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThematiqueDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String name;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  final String slug;
  @override
  @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
  final int? eventCount;

  @override
  String toString() {
    return 'ThematiqueDto(id: $id, name: $name, slug: $slug, eventCount: $eventCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThematiqueDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, eventCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThematiqueDtoImplCopyWith<_$ThematiqueDtoImpl> get copyWith =>
      __$$ThematiqueDtoImplCopyWithImpl<_$ThematiqueDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThematiqueDtoImplToJson(
      this,
    );
  }
}

abstract class _ThematiqueDto implements ThematiqueDto {
  const factory _ThematiqueDto(
      {@JsonKey(fromJson: _parseInt) final int id,
      @JsonKey(fromJson: _parseHtmlString) final String name,
      @JsonKey(fromJson: _parseHtmlString) final String slug,
      @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
      final int? eventCount}) = _$ThematiqueDtoImpl;

  factory _ThematiqueDto.fromJson(Map<String, dynamic> json) =
      _$ThematiqueDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get name;
  @override
  @JsonKey(fromJson: _parseHtmlString)
  String get slug;
  @override
  @JsonKey(name: 'event_count', fromJson: _parseIntOrNull)
  int? get eventCount;
  @override
  @JsonKey(ignore: true)
  _$$ThematiqueDtoImplCopyWith<_$ThematiqueDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceRangeDto _$PriceRangeDtoFromJson(Map<String, dynamic> json) {
  return _PriceRangeDto.fromJson(json);
}

/// @nodoc
mixin _$PriceRangeDto {
  double get min => throw _privateConstructorUsedError;
  double get max => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PriceRangeDtoCopyWith<PriceRangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceRangeDtoCopyWith<$Res> {
  factory $PriceRangeDtoCopyWith(
          PriceRangeDto value, $Res Function(PriceRangeDto) then) =
      _$PriceRangeDtoCopyWithImpl<$Res, PriceRangeDto>;
  @useResult
  $Res call({double min, double max});
}

/// @nodoc
class _$PriceRangeDtoCopyWithImpl<$Res, $Val extends PriceRangeDto>
    implements $PriceRangeDtoCopyWith<$Res> {
  _$PriceRangeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
  }) {
    return _then(_value.copyWith(
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceRangeDtoImplCopyWith<$Res>
    implements $PriceRangeDtoCopyWith<$Res> {
  factory _$$PriceRangeDtoImplCopyWith(
          _$PriceRangeDtoImpl value, $Res Function(_$PriceRangeDtoImpl) then) =
      __$$PriceRangeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double min, double max});
}

/// @nodoc
class __$$PriceRangeDtoImplCopyWithImpl<$Res>
    extends _$PriceRangeDtoCopyWithImpl<$Res, _$PriceRangeDtoImpl>
    implements _$$PriceRangeDtoImplCopyWith<$Res> {
  __$$PriceRangeDtoImplCopyWithImpl(
      _$PriceRangeDtoImpl _value, $Res Function(_$PriceRangeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
  }) {
    return _then(_$PriceRangeDtoImpl(
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceRangeDtoImpl implements _PriceRangeDto {
  const _$PriceRangeDtoImpl({required this.min, required this.max});

  factory _$PriceRangeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceRangeDtoImplFromJson(json);

  @override
  final double min;
  @override
  final double max;

  @override
  String toString() {
    return 'PriceRangeDto(min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceRangeDtoImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, min, max);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceRangeDtoImplCopyWith<_$PriceRangeDtoImpl> get copyWith =>
      __$$PriceRangeDtoImplCopyWithImpl<_$PriceRangeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceRangeDtoImplToJson(
      this,
    );
  }
}

abstract class _PriceRangeDto implements PriceRangeDto {
  const factory _PriceRangeDto(
      {required final double min,
      required final double max}) = _$PriceRangeDtoImpl;

  factory _PriceRangeDto.fromJson(Map<String, dynamic> json) =
      _$PriceRangeDtoImpl.fromJson;

  @override
  double get min;
  @override
  double get max;
  @override
  @JsonKey(ignore: true)
  _$$PriceRangeDtoImplCopyWith<_$PriceRangeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SortOptionDto _$SortOptionDtoFromJson(Map<String, dynamic> json) {
  return _SortOptionDto.fromJson(json);
}

/// @nodoc
mixin _$SortOptionDto {
  String get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SortOptionDtoCopyWith<SortOptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortOptionDtoCopyWith<$Res> {
  factory $SortOptionDtoCopyWith(
          SortOptionDto value, $Res Function(SortOptionDto) then) =
      _$SortOptionDtoCopyWithImpl<$Res, SortOptionDto>;
  @useResult
  $Res call({String value, String label});
}

/// @nodoc
class _$SortOptionDtoCopyWithImpl<$Res, $Val extends SortOptionDto>
    implements $SortOptionDtoCopyWith<$Res> {
  _$SortOptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SortOptionDtoImplCopyWith<$Res>
    implements $SortOptionDtoCopyWith<$Res> {
  factory _$$SortOptionDtoImplCopyWith(
          _$SortOptionDtoImpl value, $Res Function(_$SortOptionDtoImpl) then) =
      __$$SortOptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String label});
}

/// @nodoc
class __$$SortOptionDtoImplCopyWithImpl<$Res>
    extends _$SortOptionDtoCopyWithImpl<$Res, _$SortOptionDtoImpl>
    implements _$$SortOptionDtoImplCopyWith<$Res> {
  __$$SortOptionDtoImplCopyWithImpl(
      _$SortOptionDtoImpl _value, $Res Function(_$SortOptionDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_$SortOptionDtoImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SortOptionDtoImpl implements _SortOptionDto {
  const _$SortOptionDtoImpl({required this.value, required this.label});

  factory _$SortOptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SortOptionDtoImplFromJson(json);

  @override
  final String value;
  @override
  final String label;

  @override
  String toString() {
    return 'SortOptionDto(value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortOptionDtoImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SortOptionDtoImplCopyWith<_$SortOptionDtoImpl> get copyWith =>
      __$$SortOptionDtoImplCopyWithImpl<_$SortOptionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SortOptionDtoImplToJson(
      this,
    );
  }
}

abstract class _SortOptionDto implements SortOptionDto {
  const factory _SortOptionDto(
      {required final String value,
      required final String label}) = _$SortOptionDtoImpl;

  factory _SortOptionDto.fromJson(Map<String, dynamic> json) =
      _$SortOptionDtoImpl.fromJson;

  @override
  String get value;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$SortOptionDtoImplCopyWith<_$SortOptionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdditionalFilterDto _$AdditionalFilterDtoFromJson(Map<String, dynamic> json) {
  return _AdditionalFilterDto.fromJson(json);
}

/// @nodoc
mixin _$AdditionalFilterDto {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdditionalFilterDtoCopyWith<AdditionalFilterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdditionalFilterDtoCopyWith<$Res> {
  factory $AdditionalFilterDtoCopyWith(
          AdditionalFilterDto value, $Res Function(AdditionalFilterDto) then) =
      _$AdditionalFilterDtoCopyWithImpl<$Res, AdditionalFilterDto>;
  @useResult
  $Res call({String key, String label, String type});
}

/// @nodoc
class _$AdditionalFilterDtoCopyWithImpl<$Res, $Val extends AdditionalFilterDto>
    implements $AdditionalFilterDtoCopyWith<$Res> {
  _$AdditionalFilterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdditionalFilterDtoImplCopyWith<$Res>
    implements $AdditionalFilterDtoCopyWith<$Res> {
  factory _$$AdditionalFilterDtoImplCopyWith(_$AdditionalFilterDtoImpl value,
          $Res Function(_$AdditionalFilterDtoImpl) then) =
      __$$AdditionalFilterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String label, String type});
}

/// @nodoc
class __$$AdditionalFilterDtoImplCopyWithImpl<$Res>
    extends _$AdditionalFilterDtoCopyWithImpl<$Res, _$AdditionalFilterDtoImpl>
    implements _$$AdditionalFilterDtoImplCopyWith<$Res> {
  __$$AdditionalFilterDtoImplCopyWithImpl(_$AdditionalFilterDtoImpl _value,
      $Res Function(_$AdditionalFilterDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? type = null,
  }) {
    return _then(_$AdditionalFilterDtoImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdditionalFilterDtoImpl implements _AdditionalFilterDto {
  const _$AdditionalFilterDtoImpl(
      {required this.key, required this.label, required this.type});

  factory _$AdditionalFilterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdditionalFilterDtoImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  @override
  final String type;

  @override
  String toString() {
    return 'AdditionalFilterDto(key: $key, label: $label, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdditionalFilterDtoImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, label, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdditionalFilterDtoImplCopyWith<_$AdditionalFilterDtoImpl> get copyWith =>
      __$$AdditionalFilterDtoImplCopyWithImpl<_$AdditionalFilterDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdditionalFilterDtoImplToJson(
      this,
    );
  }
}

abstract class _AdditionalFilterDto implements AdditionalFilterDto {
  const factory _AdditionalFilterDto(
      {required final String key,
      required final String label,
      required final String type}) = _$AdditionalFilterDtoImpl;

  factory _AdditionalFilterDto.fromJson(Map<String, dynamic> json) =
      _$AdditionalFilterDtoImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$AdditionalFilterDtoImplCopyWith<_$AdditionalFilterDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityDto _$CityDtoFromJson(Map<String, dynamic> json) {
  return _CityDto.fromJson(json);
}

/// @nodoc
mixin _$CityDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  int? get parentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_count')
  int? get eventCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CityDtoCopyWith<CityDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityDtoCopyWith<$Res> {
  factory $CityDtoCopyWith(CityDto value, $Res Function(CityDto) then) =
      _$CityDtoCopyWithImpl<$Res, CityDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      @JsonKey(name: 'parent_id') int? parentId,
      @JsonKey(name: 'event_count') int? eventCount});
}

/// @nodoc
class _$CityDtoCopyWithImpl<$Res, $Val extends CityDto>
    implements $CityDtoCopyWith<$Res> {
  _$CityDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? parentId = freezed,
    Object? eventCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CityDtoImplCopyWith<$Res> implements $CityDtoCopyWith<$Res> {
  factory _$$CityDtoImplCopyWith(
          _$CityDtoImpl value, $Res Function(_$CityDtoImpl) then) =
      __$$CityDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      @JsonKey(name: 'parent_id') int? parentId,
      @JsonKey(name: 'event_count') int? eventCount});
}

/// @nodoc
class __$$CityDtoImplCopyWithImpl<$Res>
    extends _$CityDtoCopyWithImpl<$Res, _$CityDtoImpl>
    implements _$$CityDtoImplCopyWith<$Res> {
  __$$CityDtoImplCopyWithImpl(
      _$CityDtoImpl _value, $Res Function(_$CityDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? parentId = freezed,
    Object? eventCount = freezed,
  }) {
    return _then(_$CityDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CityDtoImpl implements _CityDto {
  const _$CityDtoImpl(
      {required this.id,
      required this.name,
      required this.slug,
      @JsonKey(name: 'parent_id') this.parentId,
      @JsonKey(name: 'event_count') this.eventCount});

  factory _$CityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @override
  @JsonKey(name: 'event_count')
  final int? eventCount;

  @override
  String toString() {
    return 'CityDto(id: $id, name: $name, slug: $slug, parentId: $parentId, eventCount: $eventCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, slug, parentId, eventCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CityDtoImplCopyWith<_$CityDtoImpl> get copyWith =>
      __$$CityDtoImplCopyWithImpl<_$CityDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CityDtoImplToJson(
      this,
    );
  }
}

abstract class _CityDto implements CityDto {
  const factory _CityDto(
      {required final int id,
      required final String name,
      required final String slug,
      @JsonKey(name: 'parent_id') final int? parentId,
      @JsonKey(name: 'event_count') final int? eventCount}) = _$CityDtoImpl;

  factory _CityDto.fromJson(Map<String, dynamic> json) = _$CityDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(name: 'parent_id')
  int? get parentId;
  @override
  @JsonKey(name: 'event_count')
  int? get eventCount;
  @override
  @JsonKey(ignore: true)
  _$$CityDtoImplCopyWith<_$CityDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

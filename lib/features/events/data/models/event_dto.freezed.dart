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
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get excerpt => throw _privateConstructorUsedError;
  @JsonKey(name: 'featured_image', fromJson: _parseImage)
  EventImageDto? get featuredImage => throw _privateConstructorUsedError;
  EventCategoryDto? get category => throw _privateConstructorUsedError;
  EventDatesDto? get dates => throw _privateConstructorUsedError;
  EventLocationDto? get location => throw _privateConstructorUsedError;
  EventPricingDto? get pricing => throw _privateConstructorUsedError;
  EventAvailabilityDto? get availability => throw _privateConstructorUsedError;
  dynamic get ratings => throw _privateConstructorUsedError;
  EventOrganizerDto? get organizer => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
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
      {int id,
      String title,
      String slug,
      String? excerpt,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      EventImageDto? featuredImage,
      EventCategoryDto? category,
      EventDatesDto? dates,
      EventLocationDto? location,
      EventPricingDto? pricing,
      EventAvailabilityDto? availability,
      dynamic ratings,
      EventOrganizerDto? organizer,
      List<String>? tags,
      @JsonKey(name: 'is_favorite') bool isFavorite});

  $EventImageDtoCopyWith<$Res>? get featuredImage;
  $EventCategoryDtoCopyWith<$Res>? get category;
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
    Object? title = null,
    Object? slug = null,
    Object? excerpt = freezed,
    Object? featuredImage = freezed,
    Object? category = freezed,
    Object? dates = freezed,
    Object? location = freezed,
    Object? pricing = freezed,
    Object? availability = freezed,
    Object? ratings = freezed,
    Object? organizer = freezed,
    Object? tags = freezed,
    Object? isFavorite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as EventImageDto?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EventCategoryDto?,
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
      {int id,
      String title,
      String slug,
      String? excerpt,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      EventImageDto? featuredImage,
      EventCategoryDto? category,
      EventDatesDto? dates,
      EventLocationDto? location,
      EventPricingDto? pricing,
      EventAvailabilityDto? availability,
      dynamic ratings,
      EventOrganizerDto? organizer,
      List<String>? tags,
      @JsonKey(name: 'is_favorite') bool isFavorite});

  @override
  $EventImageDtoCopyWith<$Res>? get featuredImage;
  @override
  $EventCategoryDtoCopyWith<$Res>? get category;
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
    Object? title = null,
    Object? slug = null,
    Object? excerpt = freezed,
    Object? featuredImage = freezed,
    Object? category = freezed,
    Object? dates = freezed,
    Object? location = freezed,
    Object? pricing = freezed,
    Object? availability = freezed,
    Object? ratings = freezed,
    Object? organizer = freezed,
    Object? tags = freezed,
    Object? isFavorite = null,
  }) {
    return _then(_$EventDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as EventImageDto?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EventCategoryDto?,
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
      {required this.id,
      required this.title,
      required this.slug,
      this.excerpt,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      this.featuredImage,
      this.category,
      this.dates,
      this.location,
      this.pricing,
      this.availability,
      this.ratings,
      this.organizer,
      final List<String>? tags,
      @JsonKey(name: 'is_favorite') this.isFavorite = false})
      : _tags = tags;

  factory _$EventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String? excerpt;
  @override
  @JsonKey(name: 'featured_image', fromJson: _parseImage)
  final EventImageDto? featuredImage;
  @override
  final EventCategoryDto? category;
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
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  @override
  String toString() {
    return 'EventDto(id: $id, title: $title, slug: $slug, excerpt: $excerpt, featuredImage: $featuredImage, category: $category, dates: $dates, location: $location, pricing: $pricing, availability: $availability, ratings: $ratings, organizer: $organizer, tags: $tags, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.featuredImage, featuredImage) ||
                other.featuredImage == featuredImage) &&
            (identical(other.category, category) ||
                other.category == category) &&
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
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      slug,
      excerpt,
      featuredImage,
      category,
      dates,
      location,
      pricing,
      availability,
      const DeepCollectionEquality().hash(ratings),
      organizer,
      const DeepCollectionEquality().hash(_tags),
      isFavorite);

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
      {required final int id,
      required final String title,
      required final String slug,
      final String? excerpt,
      @JsonKey(name: 'featured_image', fromJson: _parseImage)
      final EventImageDto? featuredImage,
      final EventCategoryDto? category,
      final EventDatesDto? dates,
      final EventLocationDto? location,
      final EventPricingDto? pricing,
      final EventAvailabilityDto? availability,
      final dynamic ratings,
      final EventOrganizerDto? organizer,
      final List<String>? tags,
      @JsonKey(name: 'is_favorite') final bool isFavorite}) = _$EventDtoImpl;

  factory _EventDto.fromJson(Map<String, dynamic> json) =
      _$EventDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String? get excerpt;
  @override
  @JsonKey(name: 'featured_image', fromJson: _parseImage)
  EventImageDto? get featuredImage;
  @override
  EventCategoryDto? get category;
  @override
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
  List<String>? get tags;
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
  @JsonKey(name: 'start_date')
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String? get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String? get endTime => throw _privateConstructorUsedError;
  String? get display => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring')
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
      {@JsonKey(name: 'start_date') String? startDate,
      @JsonKey(name: 'end_date') String? endDate,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'end_time') String? endTime,
      String? display,
      @JsonKey(name: 'duration_minutes') int? durationMinutes,
      @JsonKey(name: 'is_recurring') bool isRecurring});
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
      {@JsonKey(name: 'start_date') String? startDate,
      @JsonKey(name: 'end_date') String? endDate,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'end_time') String? endTime,
      String? display,
      @JsonKey(name: 'duration_minutes') int? durationMinutes,
      @JsonKey(name: 'is_recurring') bool isRecurring});
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
      {@JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'start_time') this.startTime,
      @JsonKey(name: 'end_time') this.endTime,
      this.display,
      @JsonKey(name: 'duration_minutes') this.durationMinutes,
      @JsonKey(name: 'is_recurring') this.isRecurring = false});

  factory _$EventDatesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDatesDtoImplFromJson(json);

  @override
  @JsonKey(name: 'start_date')
  final String? startDate;
  @override
  @JsonKey(name: 'end_date')
  final String? endDate;
  @override
  @JsonKey(name: 'start_time')
  final String? startTime;
  @override
  @JsonKey(name: 'end_time')
  final String? endTime;
  @override
  final String? display;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  @JsonKey(name: 'is_recurring')
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
          {@JsonKey(name: 'start_date') final String? startDate,
          @JsonKey(name: 'end_date') final String? endDate,
          @JsonKey(name: 'start_time') final String? startTime,
          @JsonKey(name: 'end_time') final String? endTime,
          final String? display,
          @JsonKey(name: 'duration_minutes') final int? durationMinutes,
          @JsonKey(name: 'is_recurring') final bool isRecurring}) =
      _$EventDatesDtoImpl;

  factory _EventDatesDto.fromJson(Map<String, dynamic> json) =
      _$EventDatesDtoImpl.fromJson;

  @override
  @JsonKey(name: 'start_date')
  String? get startDate;
  @override
  @JsonKey(name: 'end_date')
  String? get endDate;
  @override
  @JsonKey(name: 'start_time')
  String? get startTime;
  @override
  @JsonKey(name: 'end_time')
  String? get endTime;
  @override
  String? get display;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  @JsonKey(name: 'is_recurring')
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
  @JsonKey(name: 'is_free')
  bool get isFree => throw _privateConstructorUsedError;
  double get min => throw _privateConstructorUsedError;
  double get max => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
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
      {@JsonKey(name: 'is_free') bool isFree,
      double min,
      double max,
      String currency,
      String? display});
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
      {@JsonKey(name: 'is_free') bool isFree,
      double min,
      double max,
      String currency,
      String? display});
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
      {@JsonKey(name: 'is_free') this.isFree = false,
      this.min = 0,
      this.max = 0,
      this.currency = 'EUR',
      this.display});

  factory _$EventPricingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventPricingDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_free')
  final bool isFree;
  @override
  @JsonKey()
  final double min;
  @override
  @JsonKey()
  final double max;
  @override
  @JsonKey()
  final String currency;
  @override
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
      {@JsonKey(name: 'is_free') final bool isFree,
      final double min,
      final double max,
      final String currency,
      final String? display}) = _$EventPricingDtoImpl;

  factory _EventPricingDto.fromJson(Map<String, dynamic> json) =
      _$EventPricingDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_free')
  bool get isFree;
  @override
  double get min;
  @override
  double get max;
  @override
  String get currency;
  @override
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
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_capacity')
  int? get totalCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'spots_remaining')
  int? get spotsRemaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'percentage_filled')
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
      {String? status,
      @JsonKey(name: 'total_capacity') int? totalCapacity,
      @JsonKey(name: 'spots_remaining') int? spotsRemaining,
      @JsonKey(name: 'percentage_filled') int? percentageFilled});
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
      {String? status,
      @JsonKey(name: 'total_capacity') int? totalCapacity,
      @JsonKey(name: 'spots_remaining') int? spotsRemaining,
      @JsonKey(name: 'percentage_filled') int? percentageFilled});
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
      {this.status,
      @JsonKey(name: 'total_capacity') this.totalCapacity,
      @JsonKey(name: 'spots_remaining') this.spotsRemaining,
      @JsonKey(name: 'percentage_filled') this.percentageFilled});

  factory _$EventAvailabilityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventAvailabilityDtoImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'total_capacity')
  final int? totalCapacity;
  @override
  @JsonKey(name: 'spots_remaining')
  final int? spotsRemaining;
  @override
  @JsonKey(name: 'percentage_filled')
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
          {final String? status,
          @JsonKey(name: 'total_capacity') final int? totalCapacity,
          @JsonKey(name: 'spots_remaining') final int? spotsRemaining,
          @JsonKey(name: 'percentage_filled') final int? percentageFilled}) =
      _$EventAvailabilityDtoImpl;

  factory _EventAvailabilityDto.fromJson(Map<String, dynamic> json) =
      _$EventAvailabilityDtoImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'total_capacity')
  int? get totalCapacity;
  @override
  @JsonKey(name: 'spots_remaining')
  int? get spotsRemaining;
  @override
  @JsonKey(name: 'percentage_filled')
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
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_count')
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
      {int id,
      String name,
      String slug,
      String? description,
      String? icon,
      @JsonKey(name: 'event_count') int? eventCount});
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
      {int id,
      String name,
      String slug,
      String? description,
      String? icon,
      @JsonKey(name: 'event_count') int? eventCount});
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
      {required this.id,
      required this.name,
      required this.slug,
      this.description,
      this.icon,
      @JsonKey(name: 'event_count') this.eventCount});

  factory _$EventCategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCategoryDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'event_count')
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
          {required final int id,
          required final String name,
          required final String slug,
          final String? description,
          final String? icon,
          @JsonKey(name: 'event_count') final int? eventCount}) =
      _$EventCategoryDtoImpl;

  factory _EventCategoryDto.fromJson(Map<String, dynamic> json) =
      _$EventCategoryDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'event_count')
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
      @JsonKey(fromJson: _parseDoubleOrNull) double? lng});
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
      @JsonKey(fromJson: _parseDoubleOrNull) double? lng});
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
      @JsonKey(fromJson: _parseDoubleOrNull) this.lng});

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
  String toString() {
    return 'EventLocationDto(venueName: $venueName, address: $address, city: $city, lat: $lat, lng: $lng)';
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
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, venueName, address, city, lat, lng);

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
          @JsonKey(fromJson: _parseDoubleOrNull) final double? lng}) =
      _$EventLocationDtoImpl;

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
  @JsonKey(ignore: true)
  _$$EventLocationDtoImplCopyWith<_$EventLocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventOrganizerDto _$EventOrganizerDtoFromJson(Map<String, dynamic> json) {
  return _EventOrganizerDto.fromJson(json);
}

/// @nodoc
mixin _$EventOrganizerDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;

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
  $Res call({int id, String name, String? avatar});
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
    ) as $Val);
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
  $Res call({int id, String name, String? avatar});
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventOrganizerDtoImpl implements _EventOrganizerDto {
  const _$EventOrganizerDtoImpl(
      {required this.id, required this.name, this.avatar});

  factory _$EventOrganizerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventOrganizerDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? avatar;

  @override
  String toString() {
    return 'EventOrganizerDto(id: $id, name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventOrganizerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatar);

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
      {required final int id,
      required final String name,
      final String? avatar}) = _$EventOrganizerDtoImpl;

  factory _EventOrganizerDto.fromJson(Map<String, dynamic> json) =
      _$EventOrganizerDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$EventOrganizerDtoImplCopyWith<_$EventOrganizerDtoImpl> get copyWith =>
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
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_next')
  bool get hasNext => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_prev')
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
      {@JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'has_next') bool hasNext,
      @JsonKey(name: 'has_prev') bool hasPrev});
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
      {@JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'has_next') bool hasNext,
      @JsonKey(name: 'has_prev') bool hasPrev});
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
      {@JsonKey(name: 'current_page') required this.currentPage,
      @JsonKey(name: 'per_page') required this.perPage,
      @JsonKey(name: 'total_items') required this.totalItems,
      @JsonKey(name: 'total_pages') required this.totalPages,
      @JsonKey(name: 'has_next') this.hasNext = false,
      @JsonKey(name: 'has_prev') this.hasPrev = false});

  factory _$PaginationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  @JsonKey(name: 'total_items')
  final int totalItems;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'has_next')
  final bool hasNext;
  @override
  @JsonKey(name: 'has_prev')
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
      {@JsonKey(name: 'current_page') required final int currentPage,
      @JsonKey(name: 'per_page') required final int perPage,
      @JsonKey(name: 'total_items') required final int totalItems,
      @JsonKey(name: 'total_pages') required final int totalPages,
      @JsonKey(name: 'has_next') final bool hasNext,
      @JsonKey(name: 'has_prev') final bool hasPrev}) = _$PaginationDtoImpl;

  factory _PaginationDto.fromJson(Map<String, dynamic> json) =
      _$PaginationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(name: 'has_next')
  bool get hasNext;
  @override
  @JsonKey(name: 'has_prev')
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
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_count')
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
      {int id,
      String name,
      String slug,
      @JsonKey(name: 'event_count') int? eventCount});
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
      {int id,
      String name,
      String slug,
      @JsonKey(name: 'event_count') int? eventCount});
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
      {required this.id,
      required this.name,
      required this.slug,
      @JsonKey(name: 'event_count') this.eventCount});

  factory _$ThematiqueDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThematiqueDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  @JsonKey(name: 'event_count')
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
          {required final int id,
          required final String name,
          required final String slug,
          @JsonKey(name: 'event_count') final int? eventCount}) =
      _$ThematiqueDtoImpl;

  factory _ThematiqueDto.fromJson(Map<String, dynamic> json) =
      _$ThematiqueDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(name: 'event_count')
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

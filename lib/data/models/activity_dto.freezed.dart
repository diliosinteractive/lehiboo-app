// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityDto _$ActivityDtoFromJson(Map<String, dynamic> json) {
  return _ActivityDto.fromJson(json);
}

/// @nodoc
mixin _$ActivityDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get excerpt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  ActivityCategoryDto? get category => throw _privateConstructorUsedError;
  List<TagDto>? get tags => throw _privateConstructorUsedError;
  AgeRangeDto? get ageRange => throw _privateConstructorUsedError;
  AudienceDto? get audience => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_free')
  bool? get isFree => throw _privateConstructorUsedError;
  PriceDto? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'indoor_outdoor')
  String? get indoorOutdoor => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  CityDto? get city => throw _privateConstructorUsedError;
  PartnerDto? get partner => throw _privateConstructorUsedError;
  @JsonKey(name: 'reservation_mode')
  String? get reservationMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_booking_url')
  String? get externalBookingUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_phone')
  String? get bookingPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_email')
  String? get bookingEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_slot')
  SlotDto? get nextSlot => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityDtoCopyWith<ActivityDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityDtoCopyWith<$Res> {
  factory $ActivityDtoCopyWith(
          ActivityDto value, $Res Function(ActivityDto) then) =
      _$ActivityDtoCopyWithImpl<$Res, ActivityDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String slug,
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
      @JsonKey(name: 'next_slot') SlotDto? nextSlot});

  $ActivityCategoryDtoCopyWith<$Res>? get category;
  $AgeRangeDtoCopyWith<$Res>? get ageRange;
  $AudienceDtoCopyWith<$Res>? get audience;
  $PriceDtoCopyWith<$Res>? get price;
  $CityDtoCopyWith<$Res>? get city;
  $PartnerDtoCopyWith<$Res>? get partner;
  $SlotDtoCopyWith<$Res>? get nextSlot;
}

/// @nodoc
class _$ActivityDtoCopyWithImpl<$Res, $Val extends ActivityDto>
    implements $ActivityDtoCopyWith<$Res> {
  _$ActivityDtoCopyWithImpl(this._value, this._then);

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
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? ageRange = freezed,
    Object? audience = freezed,
    Object? isFree = freezed,
    Object? price = freezed,
    Object? indoorOutdoor = freezed,
    Object? durationMinutes = freezed,
    Object? city = freezed,
    Object? partner = freezed,
    Object? reservationMode = freezed,
    Object? externalBookingUrl = freezed,
    Object? bookingPhone = freezed,
    Object? bookingEmail = freezed,
    Object? nextSlot = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActivityCategoryDto?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<TagDto>?,
      ageRange: freezed == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as AgeRangeDto?,
      audience: freezed == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as AudienceDto?,
      isFree: freezed == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as PriceDto?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as CityDto?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as PartnerDto?,
      reservationMode: freezed == reservationMode
          ? _value.reservationMode
          : reservationMode // ignore: cast_nullable_to_non_nullable
              as String?,
      externalBookingUrl: freezed == externalBookingUrl
          ? _value.externalBookingUrl
          : externalBookingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingPhone: freezed == bookingPhone
          ? _value.bookingPhone
          : bookingPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingEmail: freezed == bookingEmail
          ? _value.bookingEmail
          : bookingEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSlot: freezed == nextSlot
          ? _value.nextSlot
          : nextSlot // ignore: cast_nullable_to_non_nullable
              as SlotDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityCategoryDtoCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $ActivityCategoryDtoCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AgeRangeDtoCopyWith<$Res>? get ageRange {
    if (_value.ageRange == null) {
      return null;
    }

    return $AgeRangeDtoCopyWith<$Res>(_value.ageRange!, (value) {
      return _then(_value.copyWith(ageRange: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AudienceDtoCopyWith<$Res>? get audience {
    if (_value.audience == null) {
      return null;
    }

    return $AudienceDtoCopyWith<$Res>(_value.audience!, (value) {
      return _then(_value.copyWith(audience: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PriceDtoCopyWith<$Res>? get price {
    if (_value.price == null) {
      return null;
    }

    return $PriceDtoCopyWith<$Res>(_value.price!, (value) {
      return _then(_value.copyWith(price: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CityDtoCopyWith<$Res>? get city {
    if (_value.city == null) {
      return null;
    }

    return $CityDtoCopyWith<$Res>(_value.city!, (value) {
      return _then(_value.copyWith(city: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PartnerDtoCopyWith<$Res>? get partner {
    if (_value.partner == null) {
      return null;
    }

    return $PartnerDtoCopyWith<$Res>(_value.partner!, (value) {
      return _then(_value.copyWith(partner: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SlotDtoCopyWith<$Res>? get nextSlot {
    if (_value.nextSlot == null) {
      return null;
    }

    return $SlotDtoCopyWith<$Res>(_value.nextSlot!, (value) {
      return _then(_value.copyWith(nextSlot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityDtoImplCopyWith<$Res>
    implements $ActivityDtoCopyWith<$Res> {
  factory _$$ActivityDtoImplCopyWith(
          _$ActivityDtoImpl value, $Res Function(_$ActivityDtoImpl) then) =
      __$$ActivityDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String slug,
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
      @JsonKey(name: 'next_slot') SlotDto? nextSlot});

  @override
  $ActivityCategoryDtoCopyWith<$Res>? get category;
  @override
  $AgeRangeDtoCopyWith<$Res>? get ageRange;
  @override
  $AudienceDtoCopyWith<$Res>? get audience;
  @override
  $PriceDtoCopyWith<$Res>? get price;
  @override
  $CityDtoCopyWith<$Res>? get city;
  @override
  $PartnerDtoCopyWith<$Res>? get partner;
  @override
  $SlotDtoCopyWith<$Res>? get nextSlot;
}

/// @nodoc
class __$$ActivityDtoImplCopyWithImpl<$Res>
    extends _$ActivityDtoCopyWithImpl<$Res, _$ActivityDtoImpl>
    implements _$$ActivityDtoImplCopyWith<$Res> {
  __$$ActivityDtoImplCopyWithImpl(
      _$ActivityDtoImpl _value, $Res Function(_$ActivityDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? excerpt = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? ageRange = freezed,
    Object? audience = freezed,
    Object? isFree = freezed,
    Object? price = freezed,
    Object? indoorOutdoor = freezed,
    Object? durationMinutes = freezed,
    Object? city = freezed,
    Object? partner = freezed,
    Object? reservationMode = freezed,
    Object? externalBookingUrl = freezed,
    Object? bookingPhone = freezed,
    Object? bookingEmail = freezed,
    Object? nextSlot = freezed,
  }) {
    return _then(_$ActivityDtoImpl(
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActivityCategoryDto?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<TagDto>?,
      ageRange: freezed == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as AgeRangeDto?,
      audience: freezed == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as AudienceDto?,
      isFree: freezed == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as PriceDto?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as CityDto?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as PartnerDto?,
      reservationMode: freezed == reservationMode
          ? _value.reservationMode
          : reservationMode // ignore: cast_nullable_to_non_nullable
              as String?,
      externalBookingUrl: freezed == externalBookingUrl
          ? _value.externalBookingUrl
          : externalBookingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingPhone: freezed == bookingPhone
          ? _value.bookingPhone
          : bookingPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingEmail: freezed == bookingEmail
          ? _value.bookingEmail
          : bookingEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSlot: freezed == nextSlot
          ? _value.nextSlot
          : nextSlot // ignore: cast_nullable_to_non_nullable
              as SlotDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityDtoImpl implements _ActivityDto {
  const _$ActivityDtoImpl(
      {required this.id,
      required this.title,
      required this.slug,
      this.excerpt,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl,
      this.category,
      final List<TagDto>? tags,
      this.ageRange,
      this.audience,
      @JsonKey(name: 'is_free') this.isFree,
      this.price,
      @JsonKey(name: 'indoor_outdoor') this.indoorOutdoor,
      @JsonKey(name: 'duration_minutes') this.durationMinutes,
      this.city,
      this.partner,
      @JsonKey(name: 'reservation_mode') this.reservationMode,
      @JsonKey(name: 'external_booking_url') this.externalBookingUrl,
      @JsonKey(name: 'booking_phone') this.bookingPhone,
      @JsonKey(name: 'booking_email') this.bookingEmail,
      @JsonKey(name: 'next_slot') this.nextSlot})
      : _tags = tags;

  factory _$ActivityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String? excerpt;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final ActivityCategoryDto? category;
  final List<TagDto>? _tags;
  @override
  List<TagDto>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final AgeRangeDto? ageRange;
  @override
  final AudienceDto? audience;
  @override
  @JsonKey(name: 'is_free')
  final bool? isFree;
  @override
  final PriceDto? price;
  @override
  @JsonKey(name: 'indoor_outdoor')
  final String? indoorOutdoor;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  final CityDto? city;
  @override
  final PartnerDto? partner;
  @override
  @JsonKey(name: 'reservation_mode')
  final String? reservationMode;
  @override
  @JsonKey(name: 'external_booking_url')
  final String? externalBookingUrl;
  @override
  @JsonKey(name: 'booking_phone')
  final String? bookingPhone;
  @override
  @JsonKey(name: 'booking_email')
  final String? bookingEmail;
  @override
  @JsonKey(name: 'next_slot')
  final SlotDto? nextSlot;

  @override
  String toString() {
    return 'ActivityDto(id: $id, title: $title, slug: $slug, excerpt: $excerpt, description: $description, imageUrl: $imageUrl, category: $category, tags: $tags, ageRange: $ageRange, audience: $audience, isFree: $isFree, price: $price, indoorOutdoor: $indoorOutdoor, durationMinutes: $durationMinutes, city: $city, partner: $partner, reservationMode: $reservationMode, externalBookingUrl: $externalBookingUrl, bookingPhone: $bookingPhone, bookingEmail: $bookingEmail, nextSlot: $nextSlot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.ageRange, ageRange) ||
                other.ageRange == ageRange) &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.indoorOutdoor, indoorOutdoor) ||
                other.indoorOutdoor == indoorOutdoor) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.reservationMode, reservationMode) ||
                other.reservationMode == reservationMode) &&
            (identical(other.externalBookingUrl, externalBookingUrl) ||
                other.externalBookingUrl == externalBookingUrl) &&
            (identical(other.bookingPhone, bookingPhone) ||
                other.bookingPhone == bookingPhone) &&
            (identical(other.bookingEmail, bookingEmail) ||
                other.bookingEmail == bookingEmail) &&
            (identical(other.nextSlot, nextSlot) ||
                other.nextSlot == nextSlot));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        slug,
        excerpt,
        description,
        imageUrl,
        category,
        const DeepCollectionEquality().hash(_tags),
        ageRange,
        audience,
        isFree,
        price,
        indoorOutdoor,
        durationMinutes,
        city,
        partner,
        reservationMode,
        externalBookingUrl,
        bookingPhone,
        bookingEmail,
        nextSlot
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityDtoImplCopyWith<_$ActivityDtoImpl> get copyWith =>
      __$$ActivityDtoImplCopyWithImpl<_$ActivityDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityDtoImplToJson(
      this,
    );
  }
}

abstract class _ActivityDto implements ActivityDto {
  const factory _ActivityDto(
      {required final int id,
      required final String title,
      required final String slug,
      final String? excerpt,
      final String? description,
      @JsonKey(name: 'image_url') final String? imageUrl,
      final ActivityCategoryDto? category,
      final List<TagDto>? tags,
      final AgeRangeDto? ageRange,
      final AudienceDto? audience,
      @JsonKey(name: 'is_free') final bool? isFree,
      final PriceDto? price,
      @JsonKey(name: 'indoor_outdoor') final String? indoorOutdoor,
      @JsonKey(name: 'duration_minutes') final int? durationMinutes,
      final CityDto? city,
      final PartnerDto? partner,
      @JsonKey(name: 'reservation_mode') final String? reservationMode,
      @JsonKey(name: 'external_booking_url') final String? externalBookingUrl,
      @JsonKey(name: 'booking_phone') final String? bookingPhone,
      @JsonKey(name: 'booking_email') final String? bookingEmail,
      @JsonKey(name: 'next_slot') final SlotDto? nextSlot}) = _$ActivityDtoImpl;

  factory _ActivityDto.fromJson(Map<String, dynamic> json) =
      _$ActivityDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String? get excerpt;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  ActivityCategoryDto? get category;
  @override
  List<TagDto>? get tags;
  @override
  AgeRangeDto? get ageRange;
  @override
  AudienceDto? get audience;
  @override
  @JsonKey(name: 'is_free')
  bool? get isFree;
  @override
  PriceDto? get price;
  @override
  @JsonKey(name: 'indoor_outdoor')
  String? get indoorOutdoor;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  CityDto? get city;
  @override
  PartnerDto? get partner;
  @override
  @JsonKey(name: 'reservation_mode')
  String? get reservationMode;
  @override
  @JsonKey(name: 'external_booking_url')
  String? get externalBookingUrl;
  @override
  @JsonKey(name: 'booking_phone')
  String? get bookingPhone;
  @override
  @JsonKey(name: 'booking_email')
  String? get bookingEmail;
  @override
  @JsonKey(name: 'next_slot')
  SlotDto? get nextSlot;
  @override
  @JsonKey(ignore: true)
  _$$ActivityDtoImplCopyWith<_$ActivityDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceDto _$PriceDtoFromJson(Map<String, dynamic> json) {
  return _PriceDto.fromJson(json);
}

/// @nodoc
mixin _$PriceDto {
  double? get min => throw _privateConstructorUsedError;
  double? get max => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PriceDtoCopyWith<PriceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceDtoCopyWith<$Res> {
  factory $PriceDtoCopyWith(PriceDto value, $Res Function(PriceDto) then) =
      _$PriceDtoCopyWithImpl<$Res, PriceDto>;
  @useResult
  $Res call({double? min, double? max, String? currency});
}

/// @nodoc
class _$PriceDtoCopyWithImpl<$Res, $Val extends PriceDto>
    implements $PriceDtoCopyWith<$Res> {
  _$PriceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = freezed,
    Object? max = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceDtoImplCopyWith<$Res>
    implements $PriceDtoCopyWith<$Res> {
  factory _$$PriceDtoImplCopyWith(
          _$PriceDtoImpl value, $Res Function(_$PriceDtoImpl) then) =
      __$$PriceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? min, double? max, String? currency});
}

/// @nodoc
class __$$PriceDtoImplCopyWithImpl<$Res>
    extends _$PriceDtoCopyWithImpl<$Res, _$PriceDtoImpl>
    implements _$$PriceDtoImplCopyWith<$Res> {
  __$$PriceDtoImplCopyWithImpl(
      _$PriceDtoImpl _value, $Res Function(_$PriceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = freezed,
    Object? max = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$PriceDtoImpl(
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceDtoImpl implements _PriceDto {
  const _$PriceDtoImpl({this.min, this.max, this.currency});

  factory _$PriceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceDtoImplFromJson(json);

  @override
  final double? min;
  @override
  final double? max;
  @override
  final String? currency;

  @override
  String toString() {
    return 'PriceDto(min: $min, max: $max, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceDtoImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, min, max, currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceDtoImplCopyWith<_$PriceDtoImpl> get copyWith =>
      __$$PriceDtoImplCopyWithImpl<_$PriceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceDtoImplToJson(
      this,
    );
  }
}

abstract class _PriceDto implements PriceDto {
  const factory _PriceDto(
      {final double? min,
      final double? max,
      final String? currency}) = _$PriceDtoImpl;

  factory _PriceDto.fromJson(Map<String, dynamic> json) =
      _$PriceDtoImpl.fromJson;

  @override
  double? get min;
  @override
  double? get max;
  @override
  String? get currency;
  @override
  @JsonKey(ignore: true)
  _$$PriceDtoImplCopyWith<_$PriceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SlotDto _$SlotDtoFromJson(Map<String, dynamic> json) {
  return _SlotDto.fromJson(json);
}

/// @nodoc
mixin _$SlotDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  int get activityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date_time')
  DateTime get startDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date_time')
  DateTime get endDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'capacity_total')
  int? get capacityTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'capacity_remaining')
  int? get capacityRemaining => throw _privateConstructorUsedError;
  PriceDto? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'indoor_outdoor')
  String? get indoorOutdoor => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SlotDtoCopyWith<SlotDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlotDtoCopyWith<$Res> {
  factory $SlotDtoCopyWith(SlotDto value, $Res Function(SlotDto) then) =
      _$SlotDtoCopyWithImpl<$Res, SlotDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'activity_id') int activityId,
      @JsonKey(name: 'start_date_time') DateTime startDateTime,
      @JsonKey(name: 'end_date_time') DateTime endDateTime,
      @JsonKey(name: 'capacity_total') int? capacityTotal,
      @JsonKey(name: 'capacity_remaining') int? capacityRemaining,
      PriceDto? price,
      @JsonKey(name: 'indoor_outdoor') String? indoorOutdoor,
      String? status});

  $PriceDtoCopyWith<$Res>? get price;
}

/// @nodoc
class _$SlotDtoCopyWithImpl<$Res, $Val extends SlotDto>
    implements $SlotDtoCopyWith<$Res> {
  _$SlotDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activityId = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? capacityTotal = freezed,
    Object? capacityRemaining = freezed,
    Object? price = freezed,
    Object? indoorOutdoor = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as int,
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      capacityTotal: freezed == capacityTotal
          ? _value.capacityTotal
          : capacityTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      capacityRemaining: freezed == capacityRemaining
          ? _value.capacityRemaining
          : capacityRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as PriceDto?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PriceDtoCopyWith<$Res>? get price {
    if (_value.price == null) {
      return null;
    }

    return $PriceDtoCopyWith<$Res>(_value.price!, (value) {
      return _then(_value.copyWith(price: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SlotDtoImplCopyWith<$Res> implements $SlotDtoCopyWith<$Res> {
  factory _$$SlotDtoImplCopyWith(
          _$SlotDtoImpl value, $Res Function(_$SlotDtoImpl) then) =
      __$$SlotDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'activity_id') int activityId,
      @JsonKey(name: 'start_date_time') DateTime startDateTime,
      @JsonKey(name: 'end_date_time') DateTime endDateTime,
      @JsonKey(name: 'capacity_total') int? capacityTotal,
      @JsonKey(name: 'capacity_remaining') int? capacityRemaining,
      PriceDto? price,
      @JsonKey(name: 'indoor_outdoor') String? indoorOutdoor,
      String? status});

  @override
  $PriceDtoCopyWith<$Res>? get price;
}

/// @nodoc
class __$$SlotDtoImplCopyWithImpl<$Res>
    extends _$SlotDtoCopyWithImpl<$Res, _$SlotDtoImpl>
    implements _$$SlotDtoImplCopyWith<$Res> {
  __$$SlotDtoImplCopyWithImpl(
      _$SlotDtoImpl _value, $Res Function(_$SlotDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activityId = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? capacityTotal = freezed,
    Object? capacityRemaining = freezed,
    Object? price = freezed,
    Object? indoorOutdoor = freezed,
    Object? status = freezed,
  }) {
    return _then(_$SlotDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as int,
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      capacityTotal: freezed == capacityTotal
          ? _value.capacityTotal
          : capacityTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      capacityRemaining: freezed == capacityRemaining
          ? _value.capacityRemaining
          : capacityRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as PriceDto?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SlotDtoImpl implements _SlotDto {
  const _$SlotDtoImpl(
      {required this.id,
      @JsonKey(name: 'activity_id') required this.activityId,
      @JsonKey(name: 'start_date_time') required this.startDateTime,
      @JsonKey(name: 'end_date_time') required this.endDateTime,
      @JsonKey(name: 'capacity_total') this.capacityTotal,
      @JsonKey(name: 'capacity_remaining') this.capacityRemaining,
      this.price,
      @JsonKey(name: 'indoor_outdoor') this.indoorOutdoor,
      this.status});

  factory _$SlotDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SlotDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'activity_id')
  final int activityId;
  @override
  @JsonKey(name: 'start_date_time')
  final DateTime startDateTime;
  @override
  @JsonKey(name: 'end_date_time')
  final DateTime endDateTime;
  @override
  @JsonKey(name: 'capacity_total')
  final int? capacityTotal;
  @override
  @JsonKey(name: 'capacity_remaining')
  final int? capacityRemaining;
  @override
  final PriceDto? price;
  @override
  @JsonKey(name: 'indoor_outdoor')
  final String? indoorOutdoor;
  @override
  final String? status;

  @override
  String toString() {
    return 'SlotDto(id: $id, activityId: $activityId, startDateTime: $startDateTime, endDateTime: $endDateTime, capacityTotal: $capacityTotal, capacityRemaining: $capacityRemaining, price: $price, indoorOutdoor: $indoorOutdoor, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SlotDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.capacityTotal, capacityTotal) ||
                other.capacityTotal == capacityTotal) &&
            (identical(other.capacityRemaining, capacityRemaining) ||
                other.capacityRemaining == capacityRemaining) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.indoorOutdoor, indoorOutdoor) ||
                other.indoorOutdoor == indoorOutdoor) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      activityId,
      startDateTime,
      endDateTime,
      capacityTotal,
      capacityRemaining,
      price,
      indoorOutdoor,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SlotDtoImplCopyWith<_$SlotDtoImpl> get copyWith =>
      __$$SlotDtoImplCopyWithImpl<_$SlotDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SlotDtoImplToJson(
      this,
    );
  }
}

abstract class _SlotDto implements SlotDto {
  const factory _SlotDto(
      {required final int id,
      @JsonKey(name: 'activity_id') required final int activityId,
      @JsonKey(name: 'start_date_time') required final DateTime startDateTime,
      @JsonKey(name: 'end_date_time') required final DateTime endDateTime,
      @JsonKey(name: 'capacity_total') final int? capacityTotal,
      @JsonKey(name: 'capacity_remaining') final int? capacityRemaining,
      final PriceDto? price,
      @JsonKey(name: 'indoor_outdoor') final String? indoorOutdoor,
      final String? status}) = _$SlotDtoImpl;

  factory _SlotDto.fromJson(Map<String, dynamic> json) = _$SlotDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'activity_id')
  int get activityId;
  @override
  @JsonKey(name: 'start_date_time')
  DateTime get startDateTime;
  @override
  @JsonKey(name: 'end_date_time')
  DateTime get endDateTime;
  @override
  @JsonKey(name: 'capacity_total')
  int? get capacityTotal;
  @override
  @JsonKey(name: 'capacity_remaining')
  int? get capacityRemaining;
  @override
  PriceDto? get price;
  @override
  @JsonKey(name: 'indoor_outdoor')
  String? get indoorOutdoor;
  @override
  String? get status;
  @override
  @JsonKey(ignore: true)
  _$$SlotDtoImplCopyWith<_$SlotDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityCategoryDto _$ActivityCategoryDtoFromJson(Map<String, dynamic> json) {
  return _ActivityCategoryDto.fromJson(json);
}

/// @nodoc
mixin _$ActivityCategoryDto {
  int get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityCategoryDtoCopyWith<ActivityCategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCategoryDtoCopyWith<$Res> {
  factory $ActivityCategoryDtoCopyWith(
          ActivityCategoryDto value, $Res Function(ActivityCategoryDto) then) =
      _$ActivityCategoryDtoCopyWithImpl<$Res, ActivityCategoryDto>;
  @useResult
  $Res call({int id, String slug, String name});
}

/// @nodoc
class _$ActivityCategoryDtoCopyWithImpl<$Res, $Val extends ActivityCategoryDto>
    implements $ActivityCategoryDtoCopyWith<$Res> {
  _$ActivityCategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityCategoryDtoImplCopyWith<$Res>
    implements $ActivityCategoryDtoCopyWith<$Res> {
  factory _$$ActivityCategoryDtoImplCopyWith(_$ActivityCategoryDtoImpl value,
          $Res Function(_$ActivityCategoryDtoImpl) then) =
      __$$ActivityCategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String slug, String name});
}

/// @nodoc
class __$$ActivityCategoryDtoImplCopyWithImpl<$Res>
    extends _$ActivityCategoryDtoCopyWithImpl<$Res, _$ActivityCategoryDtoImpl>
    implements _$$ActivityCategoryDtoImplCopyWith<$Res> {
  __$$ActivityCategoryDtoImplCopyWithImpl(_$ActivityCategoryDtoImpl _value,
      $Res Function(_$ActivityCategoryDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$ActivityCategoryDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityCategoryDtoImpl implements _ActivityCategoryDto {
  const _$ActivityCategoryDtoImpl(
      {required this.id, required this.slug, required this.name});

  factory _$ActivityCategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityCategoryDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'ActivityCategoryDto(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityCategoryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityCategoryDtoImplCopyWith<_$ActivityCategoryDtoImpl> get copyWith =>
      __$$ActivityCategoryDtoImplCopyWithImpl<_$ActivityCategoryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityCategoryDtoImplToJson(
      this,
    );
  }
}

abstract class _ActivityCategoryDto implements ActivityCategoryDto {
  const factory _ActivityCategoryDto(
      {required final int id,
      required final String slug,
      required final String name}) = _$ActivityCategoryDtoImpl;

  factory _ActivityCategoryDto.fromJson(Map<String, dynamic> json) =
      _$ActivityCategoryDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ActivityCategoryDtoImplCopyWith<_$ActivityCategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TagDto _$TagDtoFromJson(Map<String, dynamic> json) {
  return _TagDto.fromJson(json);
}

/// @nodoc
mixin _$TagDto {
  int get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagDtoCopyWith<TagDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagDtoCopyWith<$Res> {
  factory $TagDtoCopyWith(TagDto value, $Res Function(TagDto) then) =
      _$TagDtoCopyWithImpl<$Res, TagDto>;
  @useResult
  $Res call({int id, String slug, String name});
}

/// @nodoc
class _$TagDtoCopyWithImpl<$Res, $Val extends TagDto>
    implements $TagDtoCopyWith<$Res> {
  _$TagDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagDtoImplCopyWith<$Res> implements $TagDtoCopyWith<$Res> {
  factory _$$TagDtoImplCopyWith(
          _$TagDtoImpl value, $Res Function(_$TagDtoImpl) then) =
      __$$TagDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String slug, String name});
}

/// @nodoc
class __$$TagDtoImplCopyWithImpl<$Res>
    extends _$TagDtoCopyWithImpl<$Res, _$TagDtoImpl>
    implements _$$TagDtoImplCopyWith<$Res> {
  __$$TagDtoImplCopyWithImpl(
      _$TagDtoImpl _value, $Res Function(_$TagDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$TagDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagDtoImpl implements _TagDto {
  const _$TagDtoImpl(
      {required this.id, required this.slug, required this.name});

  factory _$TagDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'TagDto(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagDtoImplCopyWith<_$TagDtoImpl> get copyWith =>
      __$$TagDtoImplCopyWithImpl<_$TagDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagDtoImplToJson(
      this,
    );
  }
}

abstract class _TagDto implements TagDto {
  const factory _TagDto(
      {required final int id,
      required final String slug,
      required final String name}) = _$TagDtoImpl;

  factory _TagDto.fromJson(Map<String, dynamic> json) = _$TagDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$TagDtoImplCopyWith<_$TagDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AgeRangeDto _$AgeRangeDtoFromJson(Map<String, dynamic> json) {
  return _AgeRangeDto.fromJson(json);
}

/// @nodoc
mixin _$AgeRangeDto {
  int get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_age')
  int? get minAge => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_age')
  int? get maxAge => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AgeRangeDtoCopyWith<AgeRangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgeRangeDtoCopyWith<$Res> {
  factory $AgeRangeDtoCopyWith(
          AgeRangeDto value, $Res Function(AgeRangeDto) then) =
      _$AgeRangeDtoCopyWithImpl<$Res, AgeRangeDto>;
  @useResult
  $Res call(
      {int id,
      String label,
      @JsonKey(name: 'min_age') int? minAge,
      @JsonKey(name: 'max_age') int? maxAge});
}

/// @nodoc
class _$AgeRangeDtoCopyWithImpl<$Res, $Val extends AgeRangeDto>
    implements $AgeRangeDtoCopyWith<$Res> {
  _$AgeRangeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? minAge = freezed,
    Object? maxAge = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgeRangeDtoImplCopyWith<$Res>
    implements $AgeRangeDtoCopyWith<$Res> {
  factory _$$AgeRangeDtoImplCopyWith(
          _$AgeRangeDtoImpl value, $Res Function(_$AgeRangeDtoImpl) then) =
      __$$AgeRangeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String label,
      @JsonKey(name: 'min_age') int? minAge,
      @JsonKey(name: 'max_age') int? maxAge});
}

/// @nodoc
class __$$AgeRangeDtoImplCopyWithImpl<$Res>
    extends _$AgeRangeDtoCopyWithImpl<$Res, _$AgeRangeDtoImpl>
    implements _$$AgeRangeDtoImplCopyWith<$Res> {
  __$$AgeRangeDtoImplCopyWithImpl(
      _$AgeRangeDtoImpl _value, $Res Function(_$AgeRangeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? minAge = freezed,
    Object? maxAge = freezed,
  }) {
    return _then(_$AgeRangeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgeRangeDtoImpl implements _AgeRangeDto {
  const _$AgeRangeDtoImpl(
      {required this.id,
      required this.label,
      @JsonKey(name: 'min_age') this.minAge,
      @JsonKey(name: 'max_age') this.maxAge});

  factory _$AgeRangeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgeRangeDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String label;
  @override
  @JsonKey(name: 'min_age')
  final int? minAge;
  @override
  @JsonKey(name: 'max_age')
  final int? maxAge;

  @override
  String toString() {
    return 'AgeRangeDto(id: $id, label: $label, minAge: $minAge, maxAge: $maxAge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgeRangeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, minAge, maxAge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgeRangeDtoImplCopyWith<_$AgeRangeDtoImpl> get copyWith =>
      __$$AgeRangeDtoImplCopyWithImpl<_$AgeRangeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgeRangeDtoImplToJson(
      this,
    );
  }
}

abstract class _AgeRangeDto implements AgeRangeDto {
  const factory _AgeRangeDto(
      {required final int id,
      required final String label,
      @JsonKey(name: 'min_age') final int? minAge,
      @JsonKey(name: 'max_age') final int? maxAge}) = _$AgeRangeDtoImpl;

  factory _AgeRangeDto.fromJson(Map<String, dynamic> json) =
      _$AgeRangeDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get label;
  @override
  @JsonKey(name: 'min_age')
  int? get minAge;
  @override
  @JsonKey(name: 'max_age')
  int? get maxAge;
  @override
  @JsonKey(ignore: true)
  _$$AgeRangeDtoImplCopyWith<_$AgeRangeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AudienceDto _$AudienceDtoFromJson(Map<String, dynamic> json) {
  return _AudienceDto.fromJson(json);
}

/// @nodoc
mixin _$AudienceDto {
  int get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AudienceDtoCopyWith<AudienceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudienceDtoCopyWith<$Res> {
  factory $AudienceDtoCopyWith(
          AudienceDto value, $Res Function(AudienceDto) then) =
      _$AudienceDtoCopyWithImpl<$Res, AudienceDto>;
  @useResult
  $Res call({int id, String slug, String name});
}

/// @nodoc
class _$AudienceDtoCopyWithImpl<$Res, $Val extends AudienceDto>
    implements $AudienceDtoCopyWith<$Res> {
  _$AudienceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudienceDtoImplCopyWith<$Res>
    implements $AudienceDtoCopyWith<$Res> {
  factory _$$AudienceDtoImplCopyWith(
          _$AudienceDtoImpl value, $Res Function(_$AudienceDtoImpl) then) =
      __$$AudienceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String slug, String name});
}

/// @nodoc
class __$$AudienceDtoImplCopyWithImpl<$Res>
    extends _$AudienceDtoCopyWithImpl<$Res, _$AudienceDtoImpl>
    implements _$$AudienceDtoImplCopyWith<$Res> {
  __$$AudienceDtoImplCopyWithImpl(
      _$AudienceDtoImpl _value, $Res Function(_$AudienceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$AudienceDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AudienceDtoImpl implements _AudienceDto {
  const _$AudienceDtoImpl(
      {required this.id, required this.slug, required this.name});

  factory _$AudienceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudienceDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'AudienceDto(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudienceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AudienceDtoImplCopyWith<_$AudienceDtoImpl> get copyWith =>
      __$$AudienceDtoImplCopyWithImpl<_$AudienceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudienceDtoImplToJson(
      this,
    );
  }
}

abstract class _AudienceDto implements AudienceDto {
  const factory _AudienceDto(
      {required final int id,
      required final String slug,
      required final String name}) = _$AudienceDtoImpl;

  factory _AudienceDto.fromJson(Map<String, dynamic> json) =
      _$AudienceDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$AudienceDtoImplCopyWith<_$AudienceDtoImpl> get copyWith =>
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
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;

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
      double? lat,
      double? lng,
      String? region});
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
    Object? lat = freezed,
    Object? lng = freezed,
    Object? region = freezed,
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
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
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
      double? lat,
      double? lng,
      String? region});
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
    Object? lat = freezed,
    Object? lng = freezed,
    Object? region = freezed,
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
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
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
      this.lat,
      this.lng,
      this.region});

  factory _$CityDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final double? lat;
  @override
  final double? lng;
  @override
  final String? region;

  @override
  String toString() {
    return 'CityDto(id: $id, name: $name, slug: $slug, lat: $lat, lng: $lng, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.region, region) || other.region == region));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, slug, lat, lng, region);

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
      final double? lat,
      final double? lng,
      final String? region}) = _$CityDtoImpl;

  factory _CityDto.fromJson(Map<String, dynamic> json) = _$CityDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  String? get region;
  @override
  @JsonKey(ignore: true)
  _$$CityDtoImplCopyWith<_$CityDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PartnerDto _$PartnerDtoFromJson(Map<String, dynamic> json) {
  return _PartnerDto.fromJson(json);
}

/// @nodoc
mixin _$PartnerDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  bool? get verified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PartnerDtoCopyWith<PartnerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnerDtoCopyWith<$Res> {
  factory $PartnerDtoCopyWith(
          PartnerDto value, $Res Function(PartnerDto) then) =
      _$PartnerDtoCopyWithImpl<$Res, PartnerDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      @JsonKey(name: 'logo_url') String? logoUrl,
      @JsonKey(name: 'city_id') int? cityId,
      String? website,
      String? email,
      String? phone,
      bool? verified});
}

/// @nodoc
class _$PartnerDtoCopyWithImpl<$Res, $Val extends PartnerDto>
    implements $PartnerDtoCopyWith<$Res> {
  _$PartnerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? cityId = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? verified = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartnerDtoImplCopyWith<$Res>
    implements $PartnerDtoCopyWith<$Res> {
  factory _$$PartnerDtoImplCopyWith(
          _$PartnerDtoImpl value, $Res Function(_$PartnerDtoImpl) then) =
      __$$PartnerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      @JsonKey(name: 'logo_url') String? logoUrl,
      @JsonKey(name: 'city_id') int? cityId,
      String? website,
      String? email,
      String? phone,
      bool? verified});
}

/// @nodoc
class __$$PartnerDtoImplCopyWithImpl<$Res>
    extends _$PartnerDtoCopyWithImpl<$Res, _$PartnerDtoImpl>
    implements _$$PartnerDtoImplCopyWith<$Res> {
  __$$PartnerDtoImplCopyWithImpl(
      _$PartnerDtoImpl _value, $Res Function(_$PartnerDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? cityId = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? verified = freezed,
  }) {
    return _then(_$PartnerDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartnerDtoImpl implements _PartnerDto {
  const _$PartnerDtoImpl(
      {required this.id,
      required this.name,
      this.description,
      @JsonKey(name: 'logo_url') this.logoUrl,
      @JsonKey(name: 'city_id') this.cityId,
      this.website,
      this.email,
      this.phone,
      this.verified});

  factory _$PartnerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartnerDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @JsonKey(name: 'city_id')
  final int? cityId;
  @override
  final String? website;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final bool? verified;

  @override
  String toString() {
    return 'PartnerDto(id: $id, name: $name, description: $description, logoUrl: $logoUrl, cityId: $cityId, website: $website, email: $email, phone: $phone, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, logoUrl,
      cityId, website, email, phone, verified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnerDtoImplCopyWith<_$PartnerDtoImpl> get copyWith =>
      __$$PartnerDtoImplCopyWithImpl<_$PartnerDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartnerDtoImplToJson(
      this,
    );
  }
}

abstract class _PartnerDto implements PartnerDto {
  const factory _PartnerDto(
      {required final int id,
      required final String name,
      final String? description,
      @JsonKey(name: 'logo_url') final String? logoUrl,
      @JsonKey(name: 'city_id') final int? cityId,
      final String? website,
      final String? email,
      final String? phone,
      final bool? verified}) = _$PartnerDtoImpl;

  factory _PartnerDto.fromJson(Map<String, dynamic> json) =
      _$PartnerDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;
  @override
  String? get website;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  bool? get verified;
  @override
  @JsonKey(ignore: true)
  _$$PartnerDtoImplCopyWith<_$PartnerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

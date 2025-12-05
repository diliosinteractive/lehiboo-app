// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Activity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get excerpt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  List<Tag>? get tags => throw _privateConstructorUsedError;
  AgeRange? get ageRange => throw _privateConstructorUsedError;
  Audience? get audience => throw _privateConstructorUsedError;
  bool? get isFree => throw _privateConstructorUsedError;
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  IndoorOutdoor? get indoorOutdoor => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  Partner? get partner => throw _privateConstructorUsedError;
  ReservationMode? get reservationMode => throw _privateConstructorUsedError;
  String? get externalBookingUrl => throw _privateConstructorUsedError;
  String? get bookingPhone => throw _privateConstructorUsedError;
  String? get bookingEmail => throw _privateConstructorUsedError;
  Slot? get nextSlot => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String slug,
      String description,
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
      Slot? nextSlot});

  $CategoryCopyWith<$Res>? get category;
  $AgeRangeCopyWith<$Res>? get ageRange;
  $AudienceCopyWith<$Res>? get audience;
  $CityCopyWith<$Res>? get city;
  $PartnerCopyWith<$Res>? get partner;
  $SlotCopyWith<$Res>? get nextSlot;
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

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
    Object? description = null,
    Object? excerpt = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? ageRange = freezed,
    Object? audience = freezed,
    Object? isFree = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? currency = freezed,
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
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>?,
      ageRange: freezed == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as AgeRange?,
      audience: freezed == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as Audience?,
      isFree: freezed == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool?,
      priceMin: freezed == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double?,
      priceMax: freezed == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as IndoorOutdoor?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as Partner?,
      reservationMode: freezed == reservationMode
          ? _value.reservationMode
          : reservationMode // ignore: cast_nullable_to_non_nullable
              as ReservationMode?,
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
              as Slot?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AgeRangeCopyWith<$Res>? get ageRange {
    if (_value.ageRange == null) {
      return null;
    }

    return $AgeRangeCopyWith<$Res>(_value.ageRange!, (value) {
      return _then(_value.copyWith(ageRange: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AudienceCopyWith<$Res>? get audience {
    if (_value.audience == null) {
      return null;
    }

    return $AudienceCopyWith<$Res>(_value.audience!, (value) {
      return _then(_value.copyWith(audience: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CityCopyWith<$Res>? get city {
    if (_value.city == null) {
      return null;
    }

    return $CityCopyWith<$Res>(_value.city!, (value) {
      return _then(_value.copyWith(city: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PartnerCopyWith<$Res>? get partner {
    if (_value.partner == null) {
      return null;
    }

    return $PartnerCopyWith<$Res>(_value.partner!, (value) {
      return _then(_value.copyWith(partner: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SlotCopyWith<$Res>? get nextSlot {
    if (_value.nextSlot == null) {
      return null;
    }

    return $SlotCopyWith<$Res>(_value.nextSlot!, (value) {
      return _then(_value.copyWith(nextSlot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
          _$ActivityImpl value, $Res Function(_$ActivityImpl) then) =
      __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String slug,
      String description,
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
      Slot? nextSlot});

  @override
  $CategoryCopyWith<$Res>? get category;
  @override
  $AgeRangeCopyWith<$Res>? get ageRange;
  @override
  $AudienceCopyWith<$Res>? get audience;
  @override
  $CityCopyWith<$Res>? get city;
  @override
  $PartnerCopyWith<$Res>? get partner;
  @override
  $SlotCopyWith<$Res>? get nextSlot;
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
      _$ActivityImpl _value, $Res Function(_$ActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? description = null,
    Object? excerpt = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? ageRange = freezed,
    Object? audience = freezed,
    Object? isFree = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? currency = freezed,
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
    return _then(_$ActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>?,
      ageRange: freezed == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as AgeRange?,
      audience: freezed == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as Audience?,
      isFree: freezed == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool?,
      priceMin: freezed == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double?,
      priceMax: freezed == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as IndoorOutdoor?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as Partner?,
      reservationMode: freezed == reservationMode
          ? _value.reservationMode
          : reservationMode // ignore: cast_nullable_to_non_nullable
              as ReservationMode?,
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
              as Slot?,
    ));
  }
}

/// @nodoc

class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {required this.id,
      required this.title,
      required this.slug,
      required this.description,
      this.excerpt,
      this.imageUrl,
      this.category,
      final List<Tag>? tags,
      this.ageRange,
      this.audience,
      this.isFree,
      this.priceMin,
      this.priceMax,
      this.currency,
      this.indoorOutdoor,
      this.durationMinutes,
      this.city,
      this.partner,
      this.reservationMode,
      this.externalBookingUrl,
      this.bookingPhone,
      this.bookingEmail,
      this.nextSlot})
      : _tags = tags;

  @override
  final String id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String description;
  @override
  final String? excerpt;
  @override
  final String? imageUrl;
  @override
  final Category? category;
  final List<Tag>? _tags;
  @override
  List<Tag>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final AgeRange? ageRange;
  @override
  final Audience? audience;
  @override
  final bool? isFree;
  @override
  final double? priceMin;
  @override
  final double? priceMax;
  @override
  final String? currency;
  @override
  final IndoorOutdoor? indoorOutdoor;
  @override
  final int? durationMinutes;
  @override
  final City? city;
  @override
  final Partner? partner;
  @override
  final ReservationMode? reservationMode;
  @override
  final String? externalBookingUrl;
  @override
  final String? bookingPhone;
  @override
  final String? bookingEmail;
  @override
  final Slot? nextSlot;

  @override
  String toString() {
    return 'Activity(id: $id, title: $title, slug: $slug, description: $description, excerpt: $excerpt, imageUrl: $imageUrl, category: $category, tags: $tags, ageRange: $ageRange, audience: $audience, isFree: $isFree, priceMin: $priceMin, priceMax: $priceMax, currency: $currency, indoorOutdoor: $indoorOutdoor, durationMinutes: $durationMinutes, city: $city, partner: $partner, reservationMode: $reservationMode, externalBookingUrl: $externalBookingUrl, bookingPhone: $bookingPhone, bookingEmail: $bookingEmail, nextSlot: $nextSlot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
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
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
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

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        slug,
        description,
        excerpt,
        imageUrl,
        category,
        const DeepCollectionEquality().hash(_tags),
        ageRange,
        audience,
        isFree,
        priceMin,
        priceMax,
        currency,
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
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);
}

abstract class _Activity implements Activity {
  const factory _Activity(
      {required final String id,
      required final String title,
      required final String slug,
      required final String description,
      final String? excerpt,
      final String? imageUrl,
      final Category? category,
      final List<Tag>? tags,
      final AgeRange? ageRange,
      final Audience? audience,
      final bool? isFree,
      final double? priceMin,
      final double? priceMax,
      final String? currency,
      final IndoorOutdoor? indoorOutdoor,
      final int? durationMinutes,
      final City? city,
      final Partner? partner,
      final ReservationMode? reservationMode,
      final String? externalBookingUrl,
      final String? bookingPhone,
      final String? bookingEmail,
      final Slot? nextSlot}) = _$ActivityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String get description;
  @override
  String? get excerpt;
  @override
  String? get imageUrl;
  @override
  Category? get category;
  @override
  List<Tag>? get tags;
  @override
  AgeRange? get ageRange;
  @override
  Audience? get audience;
  @override
  bool? get isFree;
  @override
  double? get priceMin;
  @override
  double? get priceMax;
  @override
  String? get currency;
  @override
  IndoorOutdoor? get indoorOutdoor;
  @override
  int? get durationMinutes;
  @override
  City? get city;
  @override
  Partner? get partner;
  @override
  ReservationMode? get reservationMode;
  @override
  String? get externalBookingUrl;
  @override
  String? get bookingPhone;
  @override
  String? get bookingEmail;
  @override
  Slot? get nextSlot;
  @override
  @JsonKey(ignore: true)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Slot {
  String get id => throw _privateConstructorUsedError;
  String get activityId => throw _privateConstructorUsedError;
  DateTime get startDateTime => throw _privateConstructorUsedError;
  DateTime get endDateTime => throw _privateConstructorUsedError;
  int? get capacityTotal => throw _privateConstructorUsedError;
  int? get capacityRemaining => throw _privateConstructorUsedError;
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  IndoorOutdoor? get indoorOutdoor => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SlotCopyWith<Slot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlotCopyWith<$Res> {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) then) =
      _$SlotCopyWithImpl<$Res, Slot>;
  @useResult
  $Res call(
      {String id,
      String activityId,
      DateTime startDateTime,
      DateTime endDateTime,
      int? capacityTotal,
      int? capacityRemaining,
      double? priceMin,
      double? priceMax,
      String? currency,
      IndoorOutdoor? indoorOutdoor,
      String? status});
}

/// @nodoc
class _$SlotCopyWithImpl<$Res, $Val extends Slot>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._value, this._then);

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
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? currency = freezed,
    Object? indoorOutdoor = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
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
      priceMin: freezed == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double?,
      priceMax: freezed == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as IndoorOutdoor?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SlotImplCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$$SlotImplCopyWith(
          _$SlotImpl value, $Res Function(_$SlotImpl) then) =
      __$$SlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String activityId,
      DateTime startDateTime,
      DateTime endDateTime,
      int? capacityTotal,
      int? capacityRemaining,
      double? priceMin,
      double? priceMax,
      String? currency,
      IndoorOutdoor? indoorOutdoor,
      String? status});
}

/// @nodoc
class __$$SlotImplCopyWithImpl<$Res>
    extends _$SlotCopyWithImpl<$Res, _$SlotImpl>
    implements _$$SlotImplCopyWith<$Res> {
  __$$SlotImplCopyWithImpl(_$SlotImpl _value, $Res Function(_$SlotImpl) _then)
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
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? currency = freezed,
    Object? indoorOutdoor = freezed,
    Object? status = freezed,
  }) {
    return _then(_$SlotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
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
      priceMin: freezed == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double?,
      priceMax: freezed == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      indoorOutdoor: freezed == indoorOutdoor
          ? _value.indoorOutdoor
          : indoorOutdoor // ignore: cast_nullable_to_non_nullable
              as IndoorOutdoor?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SlotImpl implements _Slot {
  const _$SlotImpl(
      {required this.id,
      required this.activityId,
      required this.startDateTime,
      required this.endDateTime,
      this.capacityTotal,
      this.capacityRemaining,
      this.priceMin,
      this.priceMax,
      this.currency,
      this.indoorOutdoor,
      this.status});

  @override
  final String id;
  @override
  final String activityId;
  @override
  final DateTime startDateTime;
  @override
  final DateTime endDateTime;
  @override
  final int? capacityTotal;
  @override
  final int? capacityRemaining;
  @override
  final double? priceMin;
  @override
  final double? priceMax;
  @override
  final String? currency;
  @override
  final IndoorOutdoor? indoorOutdoor;
  @override
  final String? status;

  @override
  String toString() {
    return 'Slot(id: $id, activityId: $activityId, startDateTime: $startDateTime, endDateTime: $endDateTime, capacityTotal: $capacityTotal, capacityRemaining: $capacityRemaining, priceMin: $priceMin, priceMax: $priceMax, currency: $currency, indoorOutdoor: $indoorOutdoor, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SlotImpl &&
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
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.indoorOutdoor, indoorOutdoor) ||
                other.indoorOutdoor == indoorOutdoor) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      activityId,
      startDateTime,
      endDateTime,
      capacityTotal,
      capacityRemaining,
      priceMin,
      priceMax,
      currency,
      indoorOutdoor,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SlotImplCopyWith<_$SlotImpl> get copyWith =>
      __$$SlotImplCopyWithImpl<_$SlotImpl>(this, _$identity);
}

abstract class _Slot implements Slot {
  const factory _Slot(
      {required final String id,
      required final String activityId,
      required final DateTime startDateTime,
      required final DateTime endDateTime,
      final int? capacityTotal,
      final int? capacityRemaining,
      final double? priceMin,
      final double? priceMax,
      final String? currency,
      final IndoorOutdoor? indoorOutdoor,
      final String? status}) = _$SlotImpl;

  @override
  String get id;
  @override
  String get activityId;
  @override
  DateTime get startDateTime;
  @override
  DateTime get endDateTime;
  @override
  int? get capacityTotal;
  @override
  int? get capacityRemaining;
  @override
  double? get priceMin;
  @override
  double? get priceMax;
  @override
  String? get currency;
  @override
  IndoorOutdoor? get indoorOutdoor;
  @override
  String? get status;
  @override
  @JsonKey(ignore: true)
  _$$SlotImplCopyWith<_$SlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

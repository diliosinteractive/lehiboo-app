// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FilterOption _$FilterOptionFromJson(Map<String, dynamic> json) {
  return _FilterOption.fromJson(json);
}

/// @nodoc
mixin _$FilterOption {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterOptionCopyWith<FilterOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterOptionCopyWith<$Res> {
  factory $FilterOptionCopyWith(
          FilterOption value, $Res Function(FilterOption) then) =
      _$FilterOptionCopyWithImpl<$Res, FilterOption>;
  @useResult
  $Res call({String id, String label, String? slug, int? count, String? icon});
}

/// @nodoc
class _$FilterOptionCopyWithImpl<$Res, $Val extends FilterOption>
    implements $FilterOptionCopyWith<$Res> {
  _$FilterOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? slug = freezed,
    Object? count = freezed,
    Object? icon = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterOptionImplCopyWith<$Res>
    implements $FilterOptionCopyWith<$Res> {
  factory _$$FilterOptionImplCopyWith(
          _$FilterOptionImpl value, $Res Function(_$FilterOptionImpl) then) =
      __$$FilterOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, String? slug, int? count, String? icon});
}

/// @nodoc
class __$$FilterOptionImplCopyWithImpl<$Res>
    extends _$FilterOptionCopyWithImpl<$Res, _$FilterOptionImpl>
    implements _$$FilterOptionImplCopyWith<$Res> {
  __$$FilterOptionImplCopyWithImpl(
      _$FilterOptionImpl _value, $Res Function(_$FilterOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? slug = freezed,
    Object? count = freezed,
    Object? icon = freezed,
  }) {
    return _then(_$FilterOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterOptionImpl implements _FilterOption {
  const _$FilterOptionImpl(
      {required this.id,
      required this.label,
      this.slug,
      this.count,
      this.icon});

  factory _$FilterOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String? slug;
  @override
  final int? count;
  @override
  final String? icon;

  @override
  String toString() {
    return 'FilterOption(id: $id, label: $label, slug: $slug, count: $count, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, slug, count, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterOptionImplCopyWith<_$FilterOptionImpl> get copyWith =>
      __$$FilterOptionImplCopyWithImpl<_$FilterOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterOptionImplToJson(
      this,
    );
  }
}

abstract class _FilterOption implements FilterOption {
  const factory _FilterOption(
      {required final String id,
      required final String label,
      final String? slug,
      final int? count,
      final String? icon}) = _$FilterOptionImpl;

  factory _FilterOption.fromJson(Map<String, dynamic> json) =
      _$FilterOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String? get slug;
  @override
  int? get count;
  @override
  String? get icon;
  @override
  @JsonKey(ignore: true)
  _$$FilterOptionImplCopyWith<_$FilterOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventFilter _$EventFilterFromJson(Map<String, dynamic> json) {
  return _EventFilter.fromJson(json);
}

/// @nodoc
mixin _$EventFilter {
// Text search
  String get searchQuery => throw _privateConstructorUsedError; // Date filters
  DateFilterType? get dateFilterType => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError; // Price filters
  PriceFilterType? get priceFilterType => throw _privateConstructorUsedError;
  double get priceMin => throw _privateConstructorUsedError;
  double get priceMax => throw _privateConstructorUsedError;
  bool get onlyFree => throw _privateConstructorUsedError; // Location filters
  String? get citySlug => throw _privateConstructorUsedError;
  String? get cityName => throw _privateConstructorUsedError;
  double get cityRadiusKm => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double get radiusKm =>
      throw _privateConstructorUsedError; // Bounding Box (Search this area)
  double? get northEastLat => throw _privateConstructorUsedError;
  double? get northEastLng => throw _privateConstructorUsedError;
  double? get southWestLat => throw _privateConstructorUsedError;
  double? get southWestLng =>
      throw _privateConstructorUsedError; // Category filters (multi-select)
  List<String> get thematiquesSlugs => throw _privateConstructorUsedError;
  List<String> get categoriesSlugs =>
      throw _privateConstructorUsedError; // Organizer filter
  String? get organizerSlug => throw _privateConstructorUsedError;
  String? get organizerName =>
      throw _privateConstructorUsedError; // Tags filter (multi-select)
  List<String> get tagsSlugs =>
      throw _privateConstructorUsedError; // Web /events reference-data filters
  List<String> get targetAudienceSlugs => throw _privateConstructorUsedError;
  String? get eventTagSlug => throw _privateConstructorUsedError;
  List<String> get specialEventSlugs => throw _privateConstructorUsedError;
  List<String> get emotionSlugs => throw _privateConstructorUsedError;
  bool get availableOnly => throw _privateConstructorUsedError;
  LocationTypeFilter? get locationType =>
      throw _privateConstructorUsedError; // Audience filter
  bool get familyFriendly => throw _privateConstructorUsedError;
  bool get accessiblePMR =>
      throw _privateConstructorUsedError; // Online/In-person
  bool get onlineOnly => throw _privateConstructorUsedError;
  bool get inPersonOnly => throw _privateConstructorUsedError; // Sorting
  SortOption get sortBy => throw _privateConstructorUsedError;
  bool get hasExplicitSort => throw _privateConstructorUsedError; // Pagination
  int get page => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventFilterCopyWith<EventFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventFilterCopyWith<$Res> {
  factory $EventFilterCopyWith(
          EventFilter value, $Res Function(EventFilter) then) =
      _$EventFilterCopyWithImpl<$Res, EventFilter>;
  @useResult
  $Res call(
      {String searchQuery,
      DateFilterType? dateFilterType,
      DateTime? startDate,
      DateTime? endDate,
      PriceFilterType? priceFilterType,
      double priceMin,
      double priceMax,
      bool onlyFree,
      String? citySlug,
      String? cityName,
      double cityRadiusKm,
      double? latitude,
      double? longitude,
      double radiusKm,
      double? northEastLat,
      double? northEastLng,
      double? southWestLat,
      double? southWestLng,
      List<String> thematiquesSlugs,
      List<String> categoriesSlugs,
      String? organizerSlug,
      String? organizerName,
      List<String> tagsSlugs,
      List<String> targetAudienceSlugs,
      String? eventTagSlug,
      List<String> specialEventSlugs,
      List<String> emotionSlugs,
      bool availableOnly,
      LocationTypeFilter? locationType,
      bool familyFriendly,
      bool accessiblePMR,
      bool onlineOnly,
      bool inPersonOnly,
      SortOption sortBy,
      bool hasExplicitSort,
      int page,
      int perPage});
}

/// @nodoc
class _$EventFilterCopyWithImpl<$Res, $Val extends EventFilter>
    implements $EventFilterCopyWith<$Res> {
  _$EventFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? dateFilterType = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? priceFilterType = freezed,
    Object? priceMin = null,
    Object? priceMax = null,
    Object? onlyFree = null,
    Object? citySlug = freezed,
    Object? cityName = freezed,
    Object? cityRadiusKm = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? radiusKm = null,
    Object? northEastLat = freezed,
    Object? northEastLng = freezed,
    Object? southWestLat = freezed,
    Object? southWestLng = freezed,
    Object? thematiquesSlugs = null,
    Object? categoriesSlugs = null,
    Object? organizerSlug = freezed,
    Object? organizerName = freezed,
    Object? tagsSlugs = null,
    Object? targetAudienceSlugs = null,
    Object? eventTagSlug = freezed,
    Object? specialEventSlugs = null,
    Object? emotionSlugs = null,
    Object? availableOnly = null,
    Object? locationType = freezed,
    Object? familyFriendly = null,
    Object? accessiblePMR = null,
    Object? onlineOnly = null,
    Object? inPersonOnly = null,
    Object? sortBy = null,
    Object? hasExplicitSort = null,
    Object? page = null,
    Object? perPage = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      dateFilterType: freezed == dateFilterType
          ? _value.dateFilterType
          : dateFilterType // ignore: cast_nullable_to_non_nullable
              as DateFilterType?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priceFilterType: freezed == priceFilterType
          ? _value.priceFilterType
          : priceFilterType // ignore: cast_nullable_to_non_nullable
              as PriceFilterType?,
      priceMin: null == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double,
      priceMax: null == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double,
      onlyFree: null == onlyFree
          ? _value.onlyFree
          : onlyFree // ignore: cast_nullable_to_non_nullable
              as bool,
      citySlug: freezed == citySlug
          ? _value.citySlug
          : citySlug // ignore: cast_nullable_to_non_nullable
              as String?,
      cityName: freezed == cityName
          ? _value.cityName
          : cityName // ignore: cast_nullable_to_non_nullable
              as String?,
      cityRadiusKm: null == cityRadiusKm
          ? _value.cityRadiusKm
          : cityRadiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      radiusKm: null == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      northEastLat: freezed == northEastLat
          ? _value.northEastLat
          : northEastLat // ignore: cast_nullable_to_non_nullable
              as double?,
      northEastLng: freezed == northEastLng
          ? _value.northEastLng
          : northEastLng // ignore: cast_nullable_to_non_nullable
              as double?,
      southWestLat: freezed == southWestLat
          ? _value.southWestLat
          : southWestLat // ignore: cast_nullable_to_non_nullable
              as double?,
      southWestLng: freezed == southWestLng
          ? _value.southWestLng
          : southWestLng // ignore: cast_nullable_to_non_nullable
              as double?,
      thematiquesSlugs: null == thematiquesSlugs
          ? _value.thematiquesSlugs
          : thematiquesSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoriesSlugs: null == categoriesSlugs
          ? _value.categoriesSlugs
          : categoriesSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      organizerSlug: freezed == organizerSlug
          ? _value.organizerSlug
          : organizerSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerName: freezed == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String?,
      tagsSlugs: null == tagsSlugs
          ? _value.tagsSlugs
          : tagsSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetAudienceSlugs: null == targetAudienceSlugs
          ? _value.targetAudienceSlugs
          : targetAudienceSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      eventTagSlug: freezed == eventTagSlug
          ? _value.eventTagSlug
          : eventTagSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      specialEventSlugs: null == specialEventSlugs
          ? _value.specialEventSlugs
          : specialEventSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emotionSlugs: null == emotionSlugs
          ? _value.emotionSlugs
          : emotionSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableOnly: null == availableOnly
          ? _value.availableOnly
          : availableOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as LocationTypeFilter?,
      familyFriendly: null == familyFriendly
          ? _value.familyFriendly
          : familyFriendly // ignore: cast_nullable_to_non_nullable
              as bool,
      accessiblePMR: null == accessiblePMR
          ? _value.accessiblePMR
          : accessiblePMR // ignore: cast_nullable_to_non_nullable
              as bool,
      onlineOnly: null == onlineOnly
          ? _value.onlineOnly
          : onlineOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      inPersonOnly: null == inPersonOnly
          ? _value.inPersonOnly
          : inPersonOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortOption,
      hasExplicitSort: null == hasExplicitSort
          ? _value.hasExplicitSort
          : hasExplicitSort // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventFilterImplCopyWith<$Res>
    implements $EventFilterCopyWith<$Res> {
  factory _$$EventFilterImplCopyWith(
          _$EventFilterImpl value, $Res Function(_$EventFilterImpl) then) =
      __$$EventFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchQuery,
      DateFilterType? dateFilterType,
      DateTime? startDate,
      DateTime? endDate,
      PriceFilterType? priceFilterType,
      double priceMin,
      double priceMax,
      bool onlyFree,
      String? citySlug,
      String? cityName,
      double cityRadiusKm,
      double? latitude,
      double? longitude,
      double radiusKm,
      double? northEastLat,
      double? northEastLng,
      double? southWestLat,
      double? southWestLng,
      List<String> thematiquesSlugs,
      List<String> categoriesSlugs,
      String? organizerSlug,
      String? organizerName,
      List<String> tagsSlugs,
      List<String> targetAudienceSlugs,
      String? eventTagSlug,
      List<String> specialEventSlugs,
      List<String> emotionSlugs,
      bool availableOnly,
      LocationTypeFilter? locationType,
      bool familyFriendly,
      bool accessiblePMR,
      bool onlineOnly,
      bool inPersonOnly,
      SortOption sortBy,
      bool hasExplicitSort,
      int page,
      int perPage});
}

/// @nodoc
class __$$EventFilterImplCopyWithImpl<$Res>
    extends _$EventFilterCopyWithImpl<$Res, _$EventFilterImpl>
    implements _$$EventFilterImplCopyWith<$Res> {
  __$$EventFilterImplCopyWithImpl(
      _$EventFilterImpl _value, $Res Function(_$EventFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? dateFilterType = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? priceFilterType = freezed,
    Object? priceMin = null,
    Object? priceMax = null,
    Object? onlyFree = null,
    Object? citySlug = freezed,
    Object? cityName = freezed,
    Object? cityRadiusKm = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? radiusKm = null,
    Object? northEastLat = freezed,
    Object? northEastLng = freezed,
    Object? southWestLat = freezed,
    Object? southWestLng = freezed,
    Object? thematiquesSlugs = null,
    Object? categoriesSlugs = null,
    Object? organizerSlug = freezed,
    Object? organizerName = freezed,
    Object? tagsSlugs = null,
    Object? targetAudienceSlugs = null,
    Object? eventTagSlug = freezed,
    Object? specialEventSlugs = null,
    Object? emotionSlugs = null,
    Object? availableOnly = null,
    Object? locationType = freezed,
    Object? familyFriendly = null,
    Object? accessiblePMR = null,
    Object? onlineOnly = null,
    Object? inPersonOnly = null,
    Object? sortBy = null,
    Object? hasExplicitSort = null,
    Object? page = null,
    Object? perPage = null,
  }) {
    return _then(_$EventFilterImpl(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      dateFilterType: freezed == dateFilterType
          ? _value.dateFilterType
          : dateFilterType // ignore: cast_nullable_to_non_nullable
              as DateFilterType?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priceFilterType: freezed == priceFilterType
          ? _value.priceFilterType
          : priceFilterType // ignore: cast_nullable_to_non_nullable
              as PriceFilterType?,
      priceMin: null == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double,
      priceMax: null == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double,
      onlyFree: null == onlyFree
          ? _value.onlyFree
          : onlyFree // ignore: cast_nullable_to_non_nullable
              as bool,
      citySlug: freezed == citySlug
          ? _value.citySlug
          : citySlug // ignore: cast_nullable_to_non_nullable
              as String?,
      cityName: freezed == cityName
          ? _value.cityName
          : cityName // ignore: cast_nullable_to_non_nullable
              as String?,
      cityRadiusKm: null == cityRadiusKm
          ? _value.cityRadiusKm
          : cityRadiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      radiusKm: null == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      northEastLat: freezed == northEastLat
          ? _value.northEastLat
          : northEastLat // ignore: cast_nullable_to_non_nullable
              as double?,
      northEastLng: freezed == northEastLng
          ? _value.northEastLng
          : northEastLng // ignore: cast_nullable_to_non_nullable
              as double?,
      southWestLat: freezed == southWestLat
          ? _value.southWestLat
          : southWestLat // ignore: cast_nullable_to_non_nullable
              as double?,
      southWestLng: freezed == southWestLng
          ? _value.southWestLng
          : southWestLng // ignore: cast_nullable_to_non_nullable
              as double?,
      thematiquesSlugs: null == thematiquesSlugs
          ? _value._thematiquesSlugs
          : thematiquesSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoriesSlugs: null == categoriesSlugs
          ? _value._categoriesSlugs
          : categoriesSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      organizerSlug: freezed == organizerSlug
          ? _value.organizerSlug
          : organizerSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerName: freezed == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String?,
      tagsSlugs: null == tagsSlugs
          ? _value._tagsSlugs
          : tagsSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetAudienceSlugs: null == targetAudienceSlugs
          ? _value._targetAudienceSlugs
          : targetAudienceSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      eventTagSlug: freezed == eventTagSlug
          ? _value.eventTagSlug
          : eventTagSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      specialEventSlugs: null == specialEventSlugs
          ? _value._specialEventSlugs
          : specialEventSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emotionSlugs: null == emotionSlugs
          ? _value._emotionSlugs
          : emotionSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableOnly: null == availableOnly
          ? _value.availableOnly
          : availableOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as LocationTypeFilter?,
      familyFriendly: null == familyFriendly
          ? _value.familyFriendly
          : familyFriendly // ignore: cast_nullable_to_non_nullable
              as bool,
      accessiblePMR: null == accessiblePMR
          ? _value.accessiblePMR
          : accessiblePMR // ignore: cast_nullable_to_non_nullable
              as bool,
      onlineOnly: null == onlineOnly
          ? _value.onlineOnly
          : onlineOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      inPersonOnly: null == inPersonOnly
          ? _value.inPersonOnly
          : inPersonOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortOption,
      hasExplicitSort: null == hasExplicitSort
          ? _value.hasExplicitSort
          : hasExplicitSort // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventFilterImpl extends _EventFilter {
  const _$EventFilterImpl(
      {this.searchQuery = '',
      this.dateFilterType,
      this.startDate,
      this.endDate,
      this.priceFilterType,
      this.priceMin = 0,
      this.priceMax = 500,
      this.onlyFree = false,
      this.citySlug,
      this.cityName,
      this.cityRadiusKm = 10,
      this.latitude,
      this.longitude,
      this.radiusKm = 10,
      this.northEastLat,
      this.northEastLng,
      this.southWestLat,
      this.southWestLng,
      final List<String> thematiquesSlugs = const [],
      final List<String> categoriesSlugs = const [],
      this.organizerSlug,
      this.organizerName,
      final List<String> tagsSlugs = const [],
      final List<String> targetAudienceSlugs = const [],
      this.eventTagSlug,
      final List<String> specialEventSlugs = const [],
      final List<String> emotionSlugs = const [],
      this.availableOnly = false,
      this.locationType,
      this.familyFriendly = false,
      this.accessiblePMR = false,
      this.onlineOnly = false,
      this.inPersonOnly = false,
      this.sortBy = SortOption.dateAsc,
      this.hasExplicitSort = false,
      this.page = 1,
      this.perPage = 20})
      : _thematiquesSlugs = thematiquesSlugs,
        _categoriesSlugs = categoriesSlugs,
        _tagsSlugs = tagsSlugs,
        _targetAudienceSlugs = targetAudienceSlugs,
        _specialEventSlugs = specialEventSlugs,
        _emotionSlugs = emotionSlugs,
        super._();

  factory _$EventFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventFilterImplFromJson(json);

// Text search
  @override
  @JsonKey()
  final String searchQuery;
// Date filters
  @override
  final DateFilterType? dateFilterType;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
// Price filters
  @override
  final PriceFilterType? priceFilterType;
  @override
  @JsonKey()
  final double priceMin;
  @override
  @JsonKey()
  final double priceMax;
  @override
  @JsonKey()
  final bool onlyFree;
// Location filters
  @override
  final String? citySlug;
  @override
  final String? cityName;
  @override
  @JsonKey()
  final double cityRadiusKm;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey()
  final double radiusKm;
// Bounding Box (Search this area)
  @override
  final double? northEastLat;
  @override
  final double? northEastLng;
  @override
  final double? southWestLat;
  @override
  final double? southWestLng;
// Category filters (multi-select)
  final List<String> _thematiquesSlugs;
// Category filters (multi-select)
  @override
  @JsonKey()
  List<String> get thematiquesSlugs {
    if (_thematiquesSlugs is EqualUnmodifiableListView)
      return _thematiquesSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thematiquesSlugs);
  }

  final List<String> _categoriesSlugs;
  @override
  @JsonKey()
  List<String> get categoriesSlugs {
    if (_categoriesSlugs is EqualUnmodifiableListView) return _categoriesSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoriesSlugs);
  }

// Organizer filter
  @override
  final String? organizerSlug;
  @override
  final String? organizerName;
// Tags filter (multi-select)
  final List<String> _tagsSlugs;
// Tags filter (multi-select)
  @override
  @JsonKey()
  List<String> get tagsSlugs {
    if (_tagsSlugs is EqualUnmodifiableListView) return _tagsSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagsSlugs);
  }

// Web /events reference-data filters
  final List<String> _targetAudienceSlugs;
// Web /events reference-data filters
  @override
  @JsonKey()
  List<String> get targetAudienceSlugs {
    if (_targetAudienceSlugs is EqualUnmodifiableListView)
      return _targetAudienceSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetAudienceSlugs);
  }

  @override
  final String? eventTagSlug;
  final List<String> _specialEventSlugs;
  @override
  @JsonKey()
  List<String> get specialEventSlugs {
    if (_specialEventSlugs is EqualUnmodifiableListView)
      return _specialEventSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialEventSlugs);
  }

  final List<String> _emotionSlugs;
  @override
  @JsonKey()
  List<String> get emotionSlugs {
    if (_emotionSlugs is EqualUnmodifiableListView) return _emotionSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emotionSlugs);
  }

  @override
  @JsonKey()
  final bool availableOnly;
  @override
  final LocationTypeFilter? locationType;
// Audience filter
  @override
  @JsonKey()
  final bool familyFriendly;
  @override
  @JsonKey()
  final bool accessiblePMR;
// Online/In-person
  @override
  @JsonKey()
  final bool onlineOnly;
  @override
  @JsonKey()
  final bool inPersonOnly;
// Sorting
  @override
  @JsonKey()
  final SortOption sortBy;
  @override
  @JsonKey()
  final bool hasExplicitSort;
// Pagination
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int perPage;

  @override
  String toString() {
    return 'EventFilter(searchQuery: $searchQuery, dateFilterType: $dateFilterType, startDate: $startDate, endDate: $endDate, priceFilterType: $priceFilterType, priceMin: $priceMin, priceMax: $priceMax, onlyFree: $onlyFree, citySlug: $citySlug, cityName: $cityName, cityRadiusKm: $cityRadiusKm, latitude: $latitude, longitude: $longitude, radiusKm: $radiusKm, northEastLat: $northEastLat, northEastLng: $northEastLng, southWestLat: $southWestLat, southWestLng: $southWestLng, thematiquesSlugs: $thematiquesSlugs, categoriesSlugs: $categoriesSlugs, organizerSlug: $organizerSlug, organizerName: $organizerName, tagsSlugs: $tagsSlugs, targetAudienceSlugs: $targetAudienceSlugs, eventTagSlug: $eventTagSlug, specialEventSlugs: $specialEventSlugs, emotionSlugs: $emotionSlugs, availableOnly: $availableOnly, locationType: $locationType, familyFriendly: $familyFriendly, accessiblePMR: $accessiblePMR, onlineOnly: $onlineOnly, inPersonOnly: $inPersonOnly, sortBy: $sortBy, hasExplicitSort: $hasExplicitSort, page: $page, perPage: $perPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventFilterImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.dateFilterType, dateFilterType) ||
                other.dateFilterType == dateFilterType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.priceFilterType, priceFilterType) ||
                other.priceFilterType == priceFilterType) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.onlyFree, onlyFree) ||
                other.onlyFree == onlyFree) &&
            (identical(other.citySlug, citySlug) ||
                other.citySlug == citySlug) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.cityRadiusKm, cityRadiusKm) ||
                other.cityRadiusKm == cityRadiusKm) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radiusKm, radiusKm) ||
                other.radiusKm == radiusKm) &&
            (identical(other.northEastLat, northEastLat) ||
                other.northEastLat == northEastLat) &&
            (identical(other.northEastLng, northEastLng) ||
                other.northEastLng == northEastLng) &&
            (identical(other.southWestLat, southWestLat) ||
                other.southWestLat == southWestLat) &&
            (identical(other.southWestLng, southWestLng) ||
                other.southWestLng == southWestLng) &&
            const DeepCollectionEquality()
                .equals(other._thematiquesSlugs, _thematiquesSlugs) &&
            const DeepCollectionEquality()
                .equals(other._categoriesSlugs, _categoriesSlugs) &&
            (identical(other.organizerSlug, organizerSlug) ||
                other.organizerSlug == organizerSlug) &&
            (identical(other.organizerName, organizerName) ||
                other.organizerName == organizerName) &&
            const DeepCollectionEquality()
                .equals(other._tagsSlugs, _tagsSlugs) &&
            const DeepCollectionEquality()
                .equals(other._targetAudienceSlugs, _targetAudienceSlugs) &&
            (identical(other.eventTagSlug, eventTagSlug) ||
                other.eventTagSlug == eventTagSlug) &&
            const DeepCollectionEquality()
                .equals(other._specialEventSlugs, _specialEventSlugs) &&
            const DeepCollectionEquality()
                .equals(other._emotionSlugs, _emotionSlugs) &&
            (identical(other.availableOnly, availableOnly) ||
                other.availableOnly == availableOnly) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.familyFriendly, familyFriendly) ||
                other.familyFriendly == familyFriendly) &&
            (identical(other.accessiblePMR, accessiblePMR) ||
                other.accessiblePMR == accessiblePMR) &&
            (identical(other.onlineOnly, onlineOnly) ||
                other.onlineOnly == onlineOnly) &&
            (identical(other.inPersonOnly, inPersonOnly) ||
                other.inPersonOnly == inPersonOnly) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.hasExplicitSort, hasExplicitSort) ||
                other.hasExplicitSort == hasExplicitSort) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        searchQuery,
        dateFilterType,
        startDate,
        endDate,
        priceFilterType,
        priceMin,
        priceMax,
        onlyFree,
        citySlug,
        cityName,
        cityRadiusKm,
        latitude,
        longitude,
        radiusKm,
        northEastLat,
        northEastLng,
        southWestLat,
        southWestLng,
        const DeepCollectionEquality().hash(_thematiquesSlugs),
        const DeepCollectionEquality().hash(_categoriesSlugs),
        organizerSlug,
        organizerName,
        const DeepCollectionEquality().hash(_tagsSlugs),
        const DeepCollectionEquality().hash(_targetAudienceSlugs),
        eventTagSlug,
        const DeepCollectionEquality().hash(_specialEventSlugs),
        const DeepCollectionEquality().hash(_emotionSlugs),
        availableOnly,
        locationType,
        familyFriendly,
        accessiblePMR,
        onlineOnly,
        inPersonOnly,
        sortBy,
        hasExplicitSort,
        page,
        perPage
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventFilterImplCopyWith<_$EventFilterImpl> get copyWith =>
      __$$EventFilterImplCopyWithImpl<_$EventFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventFilterImplToJson(
      this,
    );
  }
}

abstract class _EventFilter extends EventFilter {
  const factory _EventFilter(
      {final String searchQuery,
      final DateFilterType? dateFilterType,
      final DateTime? startDate,
      final DateTime? endDate,
      final PriceFilterType? priceFilterType,
      final double priceMin,
      final double priceMax,
      final bool onlyFree,
      final String? citySlug,
      final String? cityName,
      final double cityRadiusKm,
      final double? latitude,
      final double? longitude,
      final double radiusKm,
      final double? northEastLat,
      final double? northEastLng,
      final double? southWestLat,
      final double? southWestLng,
      final List<String> thematiquesSlugs,
      final List<String> categoriesSlugs,
      final String? organizerSlug,
      final String? organizerName,
      final List<String> tagsSlugs,
      final List<String> targetAudienceSlugs,
      final String? eventTagSlug,
      final List<String> specialEventSlugs,
      final List<String> emotionSlugs,
      final bool availableOnly,
      final LocationTypeFilter? locationType,
      final bool familyFriendly,
      final bool accessiblePMR,
      final bool onlineOnly,
      final bool inPersonOnly,
      final SortOption sortBy,
      final bool hasExplicitSort,
      final int page,
      final int perPage}) = _$EventFilterImpl;
  const _EventFilter._() : super._();

  factory _EventFilter.fromJson(Map<String, dynamic> json) =
      _$EventFilterImpl.fromJson;

  @override // Text search
  String get searchQuery;
  @override // Date filters
  DateFilterType? get dateFilterType;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override // Price filters
  PriceFilterType? get priceFilterType;
  @override
  double get priceMin;
  @override
  double get priceMax;
  @override
  bool get onlyFree;
  @override // Location filters
  String? get citySlug;
  @override
  String? get cityName;
  @override
  double get cityRadiusKm;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double get radiusKm;
  @override // Bounding Box (Search this area)
  double? get northEastLat;
  @override
  double? get northEastLng;
  @override
  double? get southWestLat;
  @override
  double? get southWestLng;
  @override // Category filters (multi-select)
  List<String> get thematiquesSlugs;
  @override
  List<String> get categoriesSlugs;
  @override // Organizer filter
  String? get organizerSlug;
  @override
  String? get organizerName;
  @override // Tags filter (multi-select)
  List<String> get tagsSlugs;
  @override // Web /events reference-data filters
  List<String> get targetAudienceSlugs;
  @override
  String? get eventTagSlug;
  @override
  List<String> get specialEventSlugs;
  @override
  List<String> get emotionSlugs;
  @override
  bool get availableOnly;
  @override
  LocationTypeFilter? get locationType;
  @override // Audience filter
  bool get familyFriendly;
  @override
  bool get accessiblePMR;
  @override // Online/In-person
  bool get onlineOnly;
  @override
  bool get inPersonOnly;
  @override // Sorting
  SortOption get sortBy;
  @override
  bool get hasExplicitSort;
  @override // Pagination
  int get page;
  @override
  int get perPage;
  @override
  @JsonKey(ignore: true)
  _$$EventFilterImplCopyWith<_$EventFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActiveFilterChip {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  FilterChipType get type => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActiveFilterChipCopyWith<ActiveFilterChip> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveFilterChipCopyWith<$Res> {
  factory $ActiveFilterChipCopyWith(
          ActiveFilterChip value, $Res Function(ActiveFilterChip) then) =
      _$ActiveFilterChipCopyWithImpl<$Res, ActiveFilterChip>;
  @useResult
  $Res call({String id, String label, FilterChipType type, String? value});
}

/// @nodoc
class _$ActiveFilterChipCopyWithImpl<$Res, $Val extends ActiveFilterChip>
    implements $ActiveFilterChipCopyWith<$Res> {
  _$ActiveFilterChipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FilterChipType,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActiveFilterChipImplCopyWith<$Res>
    implements $ActiveFilterChipCopyWith<$Res> {
  factory _$$ActiveFilterChipImplCopyWith(_$ActiveFilterChipImpl value,
          $Res Function(_$ActiveFilterChipImpl) then) =
      __$$ActiveFilterChipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, FilterChipType type, String? value});
}

/// @nodoc
class __$$ActiveFilterChipImplCopyWithImpl<$Res>
    extends _$ActiveFilterChipCopyWithImpl<$Res, _$ActiveFilterChipImpl>
    implements _$$ActiveFilterChipImplCopyWith<$Res> {
  __$$ActiveFilterChipImplCopyWithImpl(_$ActiveFilterChipImpl _value,
      $Res Function(_$ActiveFilterChipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(_$ActiveFilterChipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FilterChipType,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ActiveFilterChipImpl implements _ActiveFilterChip {
  const _$ActiveFilterChipImpl(
      {required this.id, required this.label, required this.type, this.value});

  @override
  final String id;
  @override
  final String label;
  @override
  final FilterChipType type;
  @override
  final String? value;

  @override
  String toString() {
    return 'ActiveFilterChip(id: $id, label: $label, type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveFilterChipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, label, type, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveFilterChipImplCopyWith<_$ActiveFilterChipImpl> get copyWith =>
      __$$ActiveFilterChipImplCopyWithImpl<_$ActiveFilterChipImpl>(
          this, _$identity);
}

abstract class _ActiveFilterChip implements ActiveFilterChip {
  const factory _ActiveFilterChip(
      {required final String id,
      required final String label,
      required final FilterChipType type,
      final String? value}) = _$ActiveFilterChipImpl;

  @override
  String get id;
  @override
  String get label;
  @override
  FilterChipType get type;
  @override
  String? get value;
  @override
  @JsonKey(ignore: true)
  _$$ActiveFilterChipImplCopyWith<_$ActiveFilterChipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

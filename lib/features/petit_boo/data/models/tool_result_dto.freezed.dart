// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToolResultDto _$ToolResultDtoFromJson(Map<String, dynamic> json) {
  return _ToolResultDto.fromJson(json);
}

/// @nodoc
mixin _$ToolResultDto {
  /// Tool name
  String get tool => throw _privateConstructorUsedError;

  /// Tool-specific result data
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Timestamp of tool execution
  @JsonKey(name: 'executed_at')
  String? get executedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolResultDtoCopyWith<ToolResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolResultDtoCopyWith<$Res> {
  factory $ToolResultDtoCopyWith(
          ToolResultDto value, $Res Function(ToolResultDto) then) =
      _$ToolResultDtoCopyWithImpl<$Res, ToolResultDto>;
  @useResult
  $Res call(
      {String tool,
      Map<String, dynamic> data,
      @JsonKey(name: 'executed_at') String? executedAt});
}

/// @nodoc
class _$ToolResultDtoCopyWithImpl<$Res, $Val extends ToolResultDto>
    implements $ToolResultDtoCopyWith<$Res> {
  _$ToolResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tool = null,
    Object? data = null,
    Object? executedAt = freezed,
  }) {
    return _then(_value.copyWith(
      tool: null == tool
          ? _value.tool
          : tool // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolResultDtoImplCopyWith<$Res>
    implements $ToolResultDtoCopyWith<$Res> {
  factory _$$ToolResultDtoImplCopyWith(
          _$ToolResultDtoImpl value, $Res Function(_$ToolResultDtoImpl) then) =
      __$$ToolResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tool,
      Map<String, dynamic> data,
      @JsonKey(name: 'executed_at') String? executedAt});
}

/// @nodoc
class __$$ToolResultDtoImplCopyWithImpl<$Res>
    extends _$ToolResultDtoCopyWithImpl<$Res, _$ToolResultDtoImpl>
    implements _$$ToolResultDtoImplCopyWith<$Res> {
  __$$ToolResultDtoImplCopyWithImpl(
      _$ToolResultDtoImpl _value, $Res Function(_$ToolResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tool = null,
    Object? data = null,
    Object? executedAt = freezed,
  }) {
    return _then(_$ToolResultDtoImpl(
      tool: null == tool
          ? _value.tool
          : tool // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolResultDtoImpl extends _ToolResultDto {
  const _$ToolResultDtoImpl(
      {required this.tool,
      required final Map<String, dynamic> data,
      @JsonKey(name: 'executed_at') this.executedAt})
      : _data = data,
        super._();

  factory _$ToolResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolResultDtoImplFromJson(json);

  /// Tool name
  @override
  final String tool;

  /// Tool-specific result data
  final Map<String, dynamic> _data;

  /// Tool-specific result data
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Timestamp of tool execution
  @override
  @JsonKey(name: 'executed_at')
  final String? executedAt;

  @override
  String toString() {
    return 'ToolResultDto(tool: $tool, data: $data, executedAt: $executedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolResultDtoImpl &&
            (identical(other.tool, tool) || other.tool == tool) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tool,
      const DeepCollectionEquality().hash(_data), executedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolResultDtoImplCopyWith<_$ToolResultDtoImpl> get copyWith =>
      __$$ToolResultDtoImplCopyWithImpl<_$ToolResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolResultDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolResultDto extends ToolResultDto {
  const factory _ToolResultDto(
          {required final String tool,
          required final Map<String, dynamic> data,
          @JsonKey(name: 'executed_at') final String? executedAt}) =
      _$ToolResultDtoImpl;
  const _ToolResultDto._() : super._();

  factory _ToolResultDto.fromJson(Map<String, dynamic> json) =
      _$ToolResultDtoImpl.fromJson;

  @override

  /// Tool name
  String get tool;
  @override

  /// Tool-specific result data
  Map<String, dynamic> get data;
  @override

  /// Timestamp of tool execution
  @JsonKey(name: 'executed_at')
  String? get executedAt;
  @override
  @JsonKey(ignore: true)
  _$$ToolResultDtoImplCopyWith<_$ToolResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingsToolResult _$BookingsToolResultFromJson(Map<String, dynamic> json) {
  return _BookingsToolResult.fromJson(json);
}

/// @nodoc
mixin _$BookingsToolResult {
  List<BookingResultItem> get bookings => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_count')
  int get pendingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'upcoming_count')
  int get upcomingCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingsToolResultCopyWith<BookingsToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingsToolResultCopyWith<$Res> {
  factory $BookingsToolResultCopyWith(
          BookingsToolResult value, $Res Function(BookingsToolResult) then) =
      _$BookingsToolResultCopyWithImpl<$Res, BookingsToolResult>;
  @useResult
  $Res call(
      {List<BookingResultItem> bookings,
      int total,
      @JsonKey(name: 'pending_count') int pendingCount,
      @JsonKey(name: 'upcoming_count') int upcomingCount});
}

/// @nodoc
class _$BookingsToolResultCopyWithImpl<$Res, $Val extends BookingsToolResult>
    implements $BookingsToolResultCopyWith<$Res> {
  _$BookingsToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? total = null,
    Object? pendingCount = null,
    Object? upcomingCount = null,
  }) {
    return _then(_value.copyWith(
      bookings: null == bookings
          ? _value.bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<BookingResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingCount: null == upcomingCount
          ? _value.upcomingCount
          : upcomingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingsToolResultImplCopyWith<$Res>
    implements $BookingsToolResultCopyWith<$Res> {
  factory _$$BookingsToolResultImplCopyWith(_$BookingsToolResultImpl value,
          $Res Function(_$BookingsToolResultImpl) then) =
      __$$BookingsToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BookingResultItem> bookings,
      int total,
      @JsonKey(name: 'pending_count') int pendingCount,
      @JsonKey(name: 'upcoming_count') int upcomingCount});
}

/// @nodoc
class __$$BookingsToolResultImplCopyWithImpl<$Res>
    extends _$BookingsToolResultCopyWithImpl<$Res, _$BookingsToolResultImpl>
    implements _$$BookingsToolResultImplCopyWith<$Res> {
  __$$BookingsToolResultImplCopyWithImpl(_$BookingsToolResultImpl _value,
      $Res Function(_$BookingsToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? total = null,
    Object? pendingCount = null,
    Object? upcomingCount = null,
  }) {
    return _then(_$BookingsToolResultImpl(
      bookings: null == bookings
          ? _value._bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<BookingResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingCount: null == upcomingCount
          ? _value.upcomingCount
          : upcomingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingsToolResultImpl implements _BookingsToolResult {
  const _$BookingsToolResultImpl(
      {required final List<BookingResultItem> bookings,
      required this.total,
      @JsonKey(name: 'pending_count') this.pendingCount = 0,
      @JsonKey(name: 'upcoming_count') this.upcomingCount = 0})
      : _bookings = bookings;

  factory _$BookingsToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingsToolResultImplFromJson(json);

  final List<BookingResultItem> _bookings;
  @override
  List<BookingResultItem> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  @override
  final int total;
  @override
  @JsonKey(name: 'pending_count')
  final int pendingCount;
  @override
  @JsonKey(name: 'upcoming_count')
  final int upcomingCount;

  @override
  String toString() {
    return 'BookingsToolResult(bookings: $bookings, total: $total, pendingCount: $pendingCount, upcomingCount: $upcomingCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingsToolResultImpl &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.upcomingCount, upcomingCount) ||
                other.upcomingCount == upcomingCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_bookings),
      total,
      pendingCount,
      upcomingCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingsToolResultImplCopyWith<_$BookingsToolResultImpl> get copyWith =>
      __$$BookingsToolResultImplCopyWithImpl<_$BookingsToolResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingsToolResultImplToJson(
      this,
    );
  }
}

abstract class _BookingsToolResult implements BookingsToolResult {
  const factory _BookingsToolResult(
          {required final List<BookingResultItem> bookings,
          required final int total,
          @JsonKey(name: 'pending_count') final int pendingCount,
          @JsonKey(name: 'upcoming_count') final int upcomingCount}) =
      _$BookingsToolResultImpl;

  factory _BookingsToolResult.fromJson(Map<String, dynamic> json) =
      _$BookingsToolResultImpl.fromJson;

  @override
  List<BookingResultItem> get bookings;
  @override
  int get total;
  @override
  @JsonKey(name: 'pending_count')
  int get pendingCount;
  @override
  @JsonKey(name: 'upcoming_count')
  int get upcomingCount;
  @override
  @JsonKey(ignore: true)
  _$$BookingsToolResultImplCopyWith<_$BookingsToolResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingResultItem _$BookingResultItemFromJson(Map<String, dynamic> json) {
  return _BookingResultItem.fromJson(json);
}

/// @nodoc
mixin _$BookingResultItem {
  String get uuid => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_title')
  String get eventTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_slug')
  String? get eventSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_image')
  String? get eventImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_date')
  String? get slotDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_time')
  String? get slotTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'tickets_count')
  int get ticketsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double? get totalPrice => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingResultItemCopyWith<BookingResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingResultItemCopyWith<$Res> {
  factory $BookingResultItemCopyWith(
          BookingResultItem value, $Res Function(BookingResultItem) then) =
      _$BookingResultItemCopyWithImpl<$Res, BookingResultItem>;
  @useResult
  $Res call(
      {String uuid,
      String? reference,
      String status,
      @JsonKey(name: 'event_title') String eventTitle,
      @JsonKey(name: 'event_slug') String? eventSlug,
      @JsonKey(name: 'event_image') String? eventImage,
      @JsonKey(name: 'slot_date') String? slotDate,
      @JsonKey(name: 'slot_time') String? slotTime,
      @JsonKey(name: 'tickets_count') int ticketsCount,
      @JsonKey(name: 'total_price') double? totalPrice,
      String? currency});
}

/// @nodoc
class _$BookingResultItemCopyWithImpl<$Res, $Val extends BookingResultItem>
    implements $BookingResultItemCopyWith<$Res> {
  _$BookingResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? reference = freezed,
    Object? status = null,
    Object? eventTitle = null,
    Object? eventSlug = freezed,
    Object? eventImage = freezed,
    Object? slotDate = freezed,
    Object? slotTime = freezed,
    Object? ticketsCount = null,
    Object? totalPrice = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      eventTitle: null == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String,
      eventSlug: freezed == eventSlug
          ? _value.eventSlug
          : eventSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      eventImage: freezed == eventImage
          ? _value.eventImage
          : eventImage // ignore: cast_nullable_to_non_nullable
              as String?,
      slotDate: freezed == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
              as String?,
      slotTime: freezed == slotTime
          ? _value.slotTime
          : slotTime // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketsCount: null == ticketsCount
          ? _value.ticketsCount
          : ticketsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingResultItemImplCopyWith<$Res>
    implements $BookingResultItemCopyWith<$Res> {
  factory _$$BookingResultItemImplCopyWith(_$BookingResultItemImpl value,
          $Res Function(_$BookingResultItemImpl) then) =
      __$$BookingResultItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String? reference,
      String status,
      @JsonKey(name: 'event_title') String eventTitle,
      @JsonKey(name: 'event_slug') String? eventSlug,
      @JsonKey(name: 'event_image') String? eventImage,
      @JsonKey(name: 'slot_date') String? slotDate,
      @JsonKey(name: 'slot_time') String? slotTime,
      @JsonKey(name: 'tickets_count') int ticketsCount,
      @JsonKey(name: 'total_price') double? totalPrice,
      String? currency});
}

/// @nodoc
class __$$BookingResultItemImplCopyWithImpl<$Res>
    extends _$BookingResultItemCopyWithImpl<$Res, _$BookingResultItemImpl>
    implements _$$BookingResultItemImplCopyWith<$Res> {
  __$$BookingResultItemImplCopyWithImpl(_$BookingResultItemImpl _value,
      $Res Function(_$BookingResultItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? reference = freezed,
    Object? status = null,
    Object? eventTitle = null,
    Object? eventSlug = freezed,
    Object? eventImage = freezed,
    Object? slotDate = freezed,
    Object? slotTime = freezed,
    Object? ticketsCount = null,
    Object? totalPrice = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$BookingResultItemImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      eventTitle: null == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String,
      eventSlug: freezed == eventSlug
          ? _value.eventSlug
          : eventSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      eventImage: freezed == eventImage
          ? _value.eventImage
          : eventImage // ignore: cast_nullable_to_non_nullable
              as String?,
      slotDate: freezed == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
              as String?,
      slotTime: freezed == slotTime
          ? _value.slotTime
          : slotTime // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketsCount: null == ticketsCount
          ? _value.ticketsCount
          : ticketsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
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
class _$BookingResultItemImpl implements _BookingResultItem {
  const _$BookingResultItemImpl(
      {required this.uuid,
      this.reference,
      required this.status,
      @JsonKey(name: 'event_title') required this.eventTitle,
      @JsonKey(name: 'event_slug') this.eventSlug,
      @JsonKey(name: 'event_image') this.eventImage,
      @JsonKey(name: 'slot_date') this.slotDate,
      @JsonKey(name: 'slot_time') this.slotTime,
      @JsonKey(name: 'tickets_count') this.ticketsCount = 0,
      @JsonKey(name: 'total_price') this.totalPrice,
      this.currency});

  factory _$BookingResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingResultItemImplFromJson(json);

  @override
  final String uuid;
  @override
  final String? reference;
  @override
  final String status;
  @override
  @JsonKey(name: 'event_title')
  final String eventTitle;
  @override
  @JsonKey(name: 'event_slug')
  final String? eventSlug;
  @override
  @JsonKey(name: 'event_image')
  final String? eventImage;
  @override
  @JsonKey(name: 'slot_date')
  final String? slotDate;
  @override
  @JsonKey(name: 'slot_time')
  final String? slotTime;
  @override
  @JsonKey(name: 'tickets_count')
  final int ticketsCount;
  @override
  @JsonKey(name: 'total_price')
  final double? totalPrice;
  @override
  final String? currency;

  @override
  String toString() {
    return 'BookingResultItem(uuid: $uuid, reference: $reference, status: $status, eventTitle: $eventTitle, eventSlug: $eventSlug, eventImage: $eventImage, slotDate: $slotDate, slotTime: $slotTime, ticketsCount: $ticketsCount, totalPrice: $totalPrice, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingResultItemImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.eventSlug, eventSlug) ||
                other.eventSlug == eventSlug) &&
            (identical(other.eventImage, eventImage) ||
                other.eventImage == eventImage) &&
            (identical(other.slotDate, slotDate) ||
                other.slotDate == slotDate) &&
            (identical(other.slotTime, slotTime) ||
                other.slotTime == slotTime) &&
            (identical(other.ticketsCount, ticketsCount) ||
                other.ticketsCount == ticketsCount) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      reference,
      status,
      eventTitle,
      eventSlug,
      eventImage,
      slotDate,
      slotTime,
      ticketsCount,
      totalPrice,
      currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingResultItemImplCopyWith<_$BookingResultItemImpl> get copyWith =>
      __$$BookingResultItemImplCopyWithImpl<_$BookingResultItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingResultItemImplToJson(
      this,
    );
  }
}

abstract class _BookingResultItem implements BookingResultItem {
  const factory _BookingResultItem(
      {required final String uuid,
      final String? reference,
      required final String status,
      @JsonKey(name: 'event_title') required final String eventTitle,
      @JsonKey(name: 'event_slug') final String? eventSlug,
      @JsonKey(name: 'event_image') final String? eventImage,
      @JsonKey(name: 'slot_date') final String? slotDate,
      @JsonKey(name: 'slot_time') final String? slotTime,
      @JsonKey(name: 'tickets_count') final int ticketsCount,
      @JsonKey(name: 'total_price') final double? totalPrice,
      final String? currency}) = _$BookingResultItemImpl;

  factory _BookingResultItem.fromJson(Map<String, dynamic> json) =
      _$BookingResultItemImpl.fromJson;

  @override
  String get uuid;
  @override
  String? get reference;
  @override
  String get status;
  @override
  @JsonKey(name: 'event_title')
  String get eventTitle;
  @override
  @JsonKey(name: 'event_slug')
  String? get eventSlug;
  @override
  @JsonKey(name: 'event_image')
  String? get eventImage;
  @override
  @JsonKey(name: 'slot_date')
  String? get slotDate;
  @override
  @JsonKey(name: 'slot_time')
  String? get slotTime;
  @override
  @JsonKey(name: 'tickets_count')
  int get ticketsCount;
  @override
  @JsonKey(name: 'total_price')
  double? get totalPrice;
  @override
  String? get currency;
  @override
  @JsonKey(ignore: true)
  _$$BookingResultItemImplCopyWith<_$BookingResultItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketsToolResult _$TicketsToolResultFromJson(Map<String, dynamic> json) {
  return _TicketsToolResult.fromJson(json);
}

/// @nodoc
mixin _$TicketsToolResult {
  List<TicketResultItem> get tickets => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_count')
  int get activeCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketsToolResultCopyWith<TicketsToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketsToolResultCopyWith<$Res> {
  factory $TicketsToolResultCopyWith(
          TicketsToolResult value, $Res Function(TicketsToolResult) then) =
      _$TicketsToolResultCopyWithImpl<$Res, TicketsToolResult>;
  @useResult
  $Res call(
      {List<TicketResultItem> tickets,
      int total,
      @JsonKey(name: 'active_count') int activeCount});
}

/// @nodoc
class _$TicketsToolResultCopyWithImpl<$Res, $Val extends TicketsToolResult>
    implements $TicketsToolResultCopyWith<$Res> {
  _$TicketsToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tickets = null,
    Object? total = null,
    Object? activeCount = null,
  }) {
    return _then(_value.copyWith(
      tickets: null == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<TicketResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketsToolResultImplCopyWith<$Res>
    implements $TicketsToolResultCopyWith<$Res> {
  factory _$$TicketsToolResultImplCopyWith(_$TicketsToolResultImpl value,
          $Res Function(_$TicketsToolResultImpl) then) =
      __$$TicketsToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TicketResultItem> tickets,
      int total,
      @JsonKey(name: 'active_count') int activeCount});
}

/// @nodoc
class __$$TicketsToolResultImplCopyWithImpl<$Res>
    extends _$TicketsToolResultCopyWithImpl<$Res, _$TicketsToolResultImpl>
    implements _$$TicketsToolResultImplCopyWith<$Res> {
  __$$TicketsToolResultImplCopyWithImpl(_$TicketsToolResultImpl _value,
      $Res Function(_$TicketsToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tickets = null,
    Object? total = null,
    Object? activeCount = null,
  }) {
    return _then(_$TicketsToolResultImpl(
      tickets: null == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<TicketResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketsToolResultImpl implements _TicketsToolResult {
  const _$TicketsToolResultImpl(
      {required final List<TicketResultItem> tickets,
      required this.total,
      @JsonKey(name: 'active_count') this.activeCount = 0})
      : _tickets = tickets;

  factory _$TicketsToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketsToolResultImplFromJson(json);

  final List<TicketResultItem> _tickets;
  @override
  List<TicketResultItem> get tickets {
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tickets);
  }

  @override
  final int total;
  @override
  @JsonKey(name: 'active_count')
  final int activeCount;

  @override
  String toString() {
    return 'TicketsToolResult(tickets: $tickets, total: $total, activeCount: $activeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketsToolResultImpl &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.activeCount, activeCount) ||
                other.activeCount == activeCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_tickets), total, activeCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketsToolResultImplCopyWith<_$TicketsToolResultImpl> get copyWith =>
      __$$TicketsToolResultImplCopyWithImpl<_$TicketsToolResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketsToolResultImplToJson(
      this,
    );
  }
}

abstract class _TicketsToolResult implements TicketsToolResult {
  const factory _TicketsToolResult(
          {required final List<TicketResultItem> tickets,
          required final int total,
          @JsonKey(name: 'active_count') final int activeCount}) =
      _$TicketsToolResultImpl;

  factory _TicketsToolResult.fromJson(Map<String, dynamic> json) =
      _$TicketsToolResultImpl.fromJson;

  @override
  List<TicketResultItem> get tickets;
  @override
  int get total;
  @override
  @JsonKey(name: 'active_count')
  int get activeCount;
  @override
  @JsonKey(ignore: true)
  _$$TicketsToolResultImplCopyWith<_$TicketsToolResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketResultItem _$TicketResultItemFromJson(Map<String, dynamic> json) {
  return _TicketResultItem.fromJson(json);
}

/// @nodoc
mixin _$TicketResultItem {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String? get qrCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_title')
  String get eventTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_slug')
  String? get eventSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type')
  String? get ticketType => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_date')
  String? get slotDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_time')
  String? get slotTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendee_name')
  String? get attendeeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketResultItemCopyWith<TicketResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketResultItemCopyWith<$Res> {
  factory $TicketResultItemCopyWith(
          TicketResultItem value, $Res Function(TicketResultItem) then) =
      _$TicketResultItemCopyWithImpl<$Res, TicketResultItem>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'qr_code') String? qrCode,
      String status,
      @JsonKey(name: 'event_title') String eventTitle,
      @JsonKey(name: 'event_slug') String? eventSlug,
      @JsonKey(name: 'ticket_type') String? ticketType,
      @JsonKey(name: 'slot_date') String? slotDate,
      @JsonKey(name: 'slot_time') String? slotTime,
      @JsonKey(name: 'attendee_name') String? attendeeName});
}

/// @nodoc
class _$TicketResultItemCopyWithImpl<$Res, $Val extends TicketResultItem>
    implements $TicketResultItemCopyWith<$Res> {
  _$TicketResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? qrCode = freezed,
    Object? status = null,
    Object? eventTitle = null,
    Object? eventSlug = freezed,
    Object? ticketType = freezed,
    Object? slotDate = freezed,
    Object? slotTime = freezed,
    Object? attendeeName = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      eventTitle: null == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String,
      eventSlug: freezed == eventSlug
          ? _value.eventSlug
          : eventSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String?,
      slotDate: freezed == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
              as String?,
      slotTime: freezed == slotTime
          ? _value.slotTime
          : slotTime // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeName: freezed == attendeeName
          ? _value.attendeeName
          : attendeeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketResultItemImplCopyWith<$Res>
    implements $TicketResultItemCopyWith<$Res> {
  factory _$$TicketResultItemImplCopyWith(_$TicketResultItemImpl value,
          $Res Function(_$TicketResultItemImpl) then) =
      __$$TicketResultItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'qr_code') String? qrCode,
      String status,
      @JsonKey(name: 'event_title') String eventTitle,
      @JsonKey(name: 'event_slug') String? eventSlug,
      @JsonKey(name: 'ticket_type') String? ticketType,
      @JsonKey(name: 'slot_date') String? slotDate,
      @JsonKey(name: 'slot_time') String? slotTime,
      @JsonKey(name: 'attendee_name') String? attendeeName});
}

/// @nodoc
class __$$TicketResultItemImplCopyWithImpl<$Res>
    extends _$TicketResultItemCopyWithImpl<$Res, _$TicketResultItemImpl>
    implements _$$TicketResultItemImplCopyWith<$Res> {
  __$$TicketResultItemImplCopyWithImpl(_$TicketResultItemImpl _value,
      $Res Function(_$TicketResultItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? qrCode = freezed,
    Object? status = null,
    Object? eventTitle = null,
    Object? eventSlug = freezed,
    Object? ticketType = freezed,
    Object? slotDate = freezed,
    Object? slotTime = freezed,
    Object? attendeeName = freezed,
  }) {
    return _then(_$TicketResultItemImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      eventTitle: null == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String,
      eventSlug: freezed == eventSlug
          ? _value.eventSlug
          : eventSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String?,
      slotDate: freezed == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
              as String?,
      slotTime: freezed == slotTime
          ? _value.slotTime
          : slotTime // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeName: freezed == attendeeName
          ? _value.attendeeName
          : attendeeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketResultItemImpl implements _TicketResultItem {
  const _$TicketResultItemImpl(
      {required this.uuid,
      @JsonKey(name: 'qr_code') this.qrCode,
      required this.status,
      @JsonKey(name: 'event_title') required this.eventTitle,
      @JsonKey(name: 'event_slug') this.eventSlug,
      @JsonKey(name: 'ticket_type') this.ticketType,
      @JsonKey(name: 'slot_date') this.slotDate,
      @JsonKey(name: 'slot_time') this.slotTime,
      @JsonKey(name: 'attendee_name') this.attendeeName});

  factory _$TicketResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketResultItemImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(name: 'qr_code')
  final String? qrCode;
  @override
  final String status;
  @override
  @JsonKey(name: 'event_title')
  final String eventTitle;
  @override
  @JsonKey(name: 'event_slug')
  final String? eventSlug;
  @override
  @JsonKey(name: 'ticket_type')
  final String? ticketType;
  @override
  @JsonKey(name: 'slot_date')
  final String? slotDate;
  @override
  @JsonKey(name: 'slot_time')
  final String? slotTime;
  @override
  @JsonKey(name: 'attendee_name')
  final String? attendeeName;

  @override
  String toString() {
    return 'TicketResultItem(uuid: $uuid, qrCode: $qrCode, status: $status, eventTitle: $eventTitle, eventSlug: $eventSlug, ticketType: $ticketType, slotDate: $slotDate, slotTime: $slotTime, attendeeName: $attendeeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketResultItemImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.eventSlug, eventSlug) ||
                other.eventSlug == eventSlug) &&
            (identical(other.ticketType, ticketType) ||
                other.ticketType == ticketType) &&
            (identical(other.slotDate, slotDate) ||
                other.slotDate == slotDate) &&
            (identical(other.slotTime, slotTime) ||
                other.slotTime == slotTime) &&
            (identical(other.attendeeName, attendeeName) ||
                other.attendeeName == attendeeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, qrCode, status, eventTitle,
      eventSlug, ticketType, slotDate, slotTime, attendeeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketResultItemImplCopyWith<_$TicketResultItemImpl> get copyWith =>
      __$$TicketResultItemImplCopyWithImpl<_$TicketResultItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketResultItemImplToJson(
      this,
    );
  }
}

abstract class _TicketResultItem implements TicketResultItem {
  const factory _TicketResultItem(
          {required final String uuid,
          @JsonKey(name: 'qr_code') final String? qrCode,
          required final String status,
          @JsonKey(name: 'event_title') required final String eventTitle,
          @JsonKey(name: 'event_slug') final String? eventSlug,
          @JsonKey(name: 'ticket_type') final String? ticketType,
          @JsonKey(name: 'slot_date') final String? slotDate,
          @JsonKey(name: 'slot_time') final String? slotTime,
          @JsonKey(name: 'attendee_name') final String? attendeeName}) =
      _$TicketResultItemImpl;

  factory _TicketResultItem.fromJson(Map<String, dynamic> json) =
      _$TicketResultItemImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(name: 'qr_code')
  String? get qrCode;
  @override
  String get status;
  @override
  @JsonKey(name: 'event_title')
  String get eventTitle;
  @override
  @JsonKey(name: 'event_slug')
  String? get eventSlug;
  @override
  @JsonKey(name: 'ticket_type')
  String? get ticketType;
  @override
  @JsonKey(name: 'slot_date')
  String? get slotDate;
  @override
  @JsonKey(name: 'slot_time')
  String? get slotTime;
  @override
  @JsonKey(name: 'attendee_name')
  String? get attendeeName;
  @override
  @JsonKey(ignore: true)
  _$$TicketResultItemImplCopyWith<_$TicketResultItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventSearchToolResult _$EventSearchToolResultFromJson(
    Map<String, dynamic> json) {
  return _EventSearchToolResult.fromJson(json);
}

/// @nodoc
mixin _$EventSearchToolResult {
  List<EventResultItem> get events => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'filters_applied')
  Map<String, dynamic>? get filtersApplied =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventSearchToolResultCopyWith<EventSearchToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventSearchToolResultCopyWith<$Res> {
  factory $EventSearchToolResultCopyWith(EventSearchToolResult value,
          $Res Function(EventSearchToolResult) then) =
      _$EventSearchToolResultCopyWithImpl<$Res, EventSearchToolResult>;
  @useResult
  $Res call(
      {List<EventResultItem> events,
      int total,
      @JsonKey(name: 'filters_applied') Map<String, dynamic>? filtersApplied});
}

/// @nodoc
class _$EventSearchToolResultCopyWithImpl<$Res,
        $Val extends EventSearchToolResult>
    implements $EventSearchToolResultCopyWith<$Res> {
  _$EventSearchToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
    Object? total = null,
    Object? filtersApplied = freezed,
  }) {
    return _then(_value.copyWith(
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<EventResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      filtersApplied: freezed == filtersApplied
          ? _value.filtersApplied
          : filtersApplied // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventSearchToolResultImplCopyWith<$Res>
    implements $EventSearchToolResultCopyWith<$Res> {
  factory _$$EventSearchToolResultImplCopyWith(
          _$EventSearchToolResultImpl value,
          $Res Function(_$EventSearchToolResultImpl) then) =
      __$$EventSearchToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EventResultItem> events,
      int total,
      @JsonKey(name: 'filters_applied') Map<String, dynamic>? filtersApplied});
}

/// @nodoc
class __$$EventSearchToolResultImplCopyWithImpl<$Res>
    extends _$EventSearchToolResultCopyWithImpl<$Res,
        _$EventSearchToolResultImpl>
    implements _$$EventSearchToolResultImplCopyWith<$Res> {
  __$$EventSearchToolResultImplCopyWithImpl(_$EventSearchToolResultImpl _value,
      $Res Function(_$EventSearchToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
    Object? total = null,
    Object? filtersApplied = freezed,
  }) {
    return _then(_$EventSearchToolResultImpl(
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<EventResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      filtersApplied: freezed == filtersApplied
          ? _value._filtersApplied
          : filtersApplied // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventSearchToolResultImpl implements _EventSearchToolResult {
  const _$EventSearchToolResultImpl(
      {required final List<EventResultItem> events,
      required this.total,
      @JsonKey(name: 'filters_applied')
      final Map<String, dynamic>? filtersApplied})
      : _events = events,
        _filtersApplied = filtersApplied;

  factory _$EventSearchToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventSearchToolResultImplFromJson(json);

  final List<EventResultItem> _events;
  @override
  List<EventResultItem> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final int total;
  final Map<String, dynamic>? _filtersApplied;
  @override
  @JsonKey(name: 'filters_applied')
  Map<String, dynamic>? get filtersApplied {
    final value = _filtersApplied;
    if (value == null) return null;
    if (_filtersApplied is EqualUnmodifiableMapView) return _filtersApplied;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'EventSearchToolResult(events: $events, total: $total, filtersApplied: $filtersApplied)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventSearchToolResultImpl &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality()
                .equals(other._filtersApplied, _filtersApplied));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_events),
      total,
      const DeepCollectionEquality().hash(_filtersApplied));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventSearchToolResultImplCopyWith<_$EventSearchToolResultImpl>
      get copyWith => __$$EventSearchToolResultImplCopyWithImpl<
          _$EventSearchToolResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventSearchToolResultImplToJson(
      this,
    );
  }
}

abstract class _EventSearchToolResult implements EventSearchToolResult {
  const factory _EventSearchToolResult(
          {required final List<EventResultItem> events,
          required final int total,
          @JsonKey(name: 'filters_applied')
          final Map<String, dynamic>? filtersApplied}) =
      _$EventSearchToolResultImpl;

  factory _EventSearchToolResult.fromJson(Map<String, dynamic> json) =
      _$EventSearchToolResultImpl.fromJson;

  @override
  List<EventResultItem> get events;
  @override
  int get total;
  @override
  @JsonKey(name: 'filters_applied')
  Map<String, dynamic>? get filtersApplied;
  @override
  @JsonKey(ignore: true)
  _$$EventSearchToolResultImplCopyWith<_$EventSearchToolResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EventResultItem _$EventResultItemFromJson(Map<String, dynamic> json) {
  return _EventResultItem.fromJson(json);
}

/// @nodoc
mixin _$EventResultItem {
  String get uuid => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_name')
  String? get venueName => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_name')
  String? get cityName => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_slot_date')
  String? get nextSlotDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_slot_time')
  String? get nextSlotTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_display')
  String? get priceDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_free')
  bool get isFree => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventResultItemCopyWith<EventResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventResultItemCopyWith<$Res> {
  factory $EventResultItemCopyWith(
          EventResultItem value, $Res Function(EventResultItem) then) =
      _$EventResultItemCopyWithImpl<$Res, EventResultItem>;
  @useResult
  $Res call(
      {String uuid,
      String slug,
      String title,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'venue_name') String? venueName,
      @JsonKey(name: 'city_name') String? cityName,
      @JsonKey(name: 'next_slot_date') String? nextSlotDate,
      @JsonKey(name: 'next_slot_time') String? nextSlotTime,
      @JsonKey(name: 'price_display') String? priceDisplay,
      @JsonKey(name: 'is_free') bool isFree,
      @JsonKey(name: 'is_favorite') bool isFavorite});
}

/// @nodoc
class _$EventResultItemCopyWithImpl<$Res, $Val extends EventResultItem>
    implements $EventResultItemCopyWith<$Res> {
  _$EventResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? venueName = freezed,
    Object? cityName = freezed,
    Object? nextSlotDate = freezed,
    Object? nextSlotTime = freezed,
    Object? priceDisplay = freezed,
    Object? isFree = null,
    Object? isFavorite = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      cityName: freezed == cityName
          ? _value.cityName
          : cityName // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSlotDate: freezed == nextSlotDate
          ? _value.nextSlotDate
          : nextSlotDate // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSlotTime: freezed == nextSlotTime
          ? _value.nextSlotTime
          : nextSlotTime // ignore: cast_nullable_to_non_nullable
              as String?,
      priceDisplay: freezed == priceDisplay
          ? _value.priceDisplay
          : priceDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventResultItemImplCopyWith<$Res>
    implements $EventResultItemCopyWith<$Res> {
  factory _$$EventResultItemImplCopyWith(_$EventResultItemImpl value,
          $Res Function(_$EventResultItemImpl) then) =
      __$$EventResultItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String slug,
      String title,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'venue_name') String? venueName,
      @JsonKey(name: 'city_name') String? cityName,
      @JsonKey(name: 'next_slot_date') String? nextSlotDate,
      @JsonKey(name: 'next_slot_time') String? nextSlotTime,
      @JsonKey(name: 'price_display') String? priceDisplay,
      @JsonKey(name: 'is_free') bool isFree,
      @JsonKey(name: 'is_favorite') bool isFavorite});
}

/// @nodoc
class __$$EventResultItemImplCopyWithImpl<$Res>
    extends _$EventResultItemCopyWithImpl<$Res, _$EventResultItemImpl>
    implements _$$EventResultItemImplCopyWith<$Res> {
  __$$EventResultItemImplCopyWithImpl(
      _$EventResultItemImpl _value, $Res Function(_$EventResultItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? venueName = freezed,
    Object? cityName = freezed,
    Object? nextSlotDate = freezed,
    Object? nextSlotTime = freezed,
    Object? priceDisplay = freezed,
    Object? isFree = null,
    Object? isFavorite = null,
  }) {
    return _then(_$EventResultItemImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      cityName: freezed == cityName
          ? _value.cityName
          : cityName // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSlotDate: freezed == nextSlotDate
          ? _value.nextSlotDate
          : nextSlotDate // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSlotTime: freezed == nextSlotTime
          ? _value.nextSlotTime
          : nextSlotTime // ignore: cast_nullable_to_non_nullable
              as String?,
      priceDisplay: freezed == priceDisplay
          ? _value.priceDisplay
          : priceDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventResultItemImpl implements _EventResultItem {
  const _$EventResultItemImpl(
      {required this.uuid,
      required this.slug,
      required this.title,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'venue_name') this.venueName,
      @JsonKey(name: 'city_name') this.cityName,
      @JsonKey(name: 'next_slot_date') this.nextSlotDate,
      @JsonKey(name: 'next_slot_time') this.nextSlotTime,
      @JsonKey(name: 'price_display') this.priceDisplay,
      @JsonKey(name: 'is_free') this.isFree = false,
      @JsonKey(name: 'is_favorite') this.isFavorite = false});

  factory _$EventResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventResultItemImplFromJson(json);

  @override
  final String uuid;
  @override
  final String slug;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'venue_name')
  final String? venueName;
  @override
  @JsonKey(name: 'city_name')
  final String? cityName;
  @override
  @JsonKey(name: 'next_slot_date')
  final String? nextSlotDate;
  @override
  @JsonKey(name: 'next_slot_time')
  final String? nextSlotTime;
  @override
  @JsonKey(name: 'price_display')
  final String? priceDisplay;
  @override
  @JsonKey(name: 'is_free')
  final bool isFree;
  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  @override
  String toString() {
    return 'EventResultItem(uuid: $uuid, slug: $slug, title: $title, description: $description, imageUrl: $imageUrl, venueName: $venueName, cityName: $cityName, nextSlotDate: $nextSlotDate, nextSlotTime: $nextSlotTime, priceDisplay: $priceDisplay, isFree: $isFree, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventResultItemImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.nextSlotDate, nextSlotDate) ||
                other.nextSlotDate == nextSlotDate) &&
            (identical(other.nextSlotTime, nextSlotTime) ||
                other.nextSlotTime == nextSlotTime) &&
            (identical(other.priceDisplay, priceDisplay) ||
                other.priceDisplay == priceDisplay) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      slug,
      title,
      description,
      imageUrl,
      venueName,
      cityName,
      nextSlotDate,
      nextSlotTime,
      priceDisplay,
      isFree,
      isFavorite);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventResultItemImplCopyWith<_$EventResultItemImpl> get copyWith =>
      __$$EventResultItemImplCopyWithImpl<_$EventResultItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventResultItemImplToJson(
      this,
    );
  }
}

abstract class _EventResultItem implements EventResultItem {
  const factory _EventResultItem(
          {required final String uuid,
          required final String slug,
          required final String title,
          final String? description,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'venue_name') final String? venueName,
          @JsonKey(name: 'city_name') final String? cityName,
          @JsonKey(name: 'next_slot_date') final String? nextSlotDate,
          @JsonKey(name: 'next_slot_time') final String? nextSlotTime,
          @JsonKey(name: 'price_display') final String? priceDisplay,
          @JsonKey(name: 'is_free') final bool isFree,
          @JsonKey(name: 'is_favorite') final bool isFavorite}) =
      _$EventResultItemImpl;

  factory _EventResultItem.fromJson(Map<String, dynamic> json) =
      _$EventResultItemImpl.fromJson;

  @override
  String get uuid;
  @override
  String get slug;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'venue_name')
  String? get venueName;
  @override
  @JsonKey(name: 'city_name')
  String? get cityName;
  @override
  @JsonKey(name: 'next_slot_date')
  String? get nextSlotDate;
  @override
  @JsonKey(name: 'next_slot_time')
  String? get nextSlotTime;
  @override
  @JsonKey(name: 'price_display')
  String? get priceDisplay;
  @override
  @JsonKey(name: 'is_free')
  bool get isFree;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;
  @override
  @JsonKey(ignore: true)
  _$$EventResultItemImplCopyWith<_$EventResultItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventDetailsToolResult _$EventDetailsToolResultFromJson(
    Map<String, dynamic> json) {
  return _EventDetailsToolResult.fromJson(json);
}

/// @nodoc
mixin _$EventDetailsToolResult {
  String get uuid => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  EventVenueResult? get venue => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_slot')
  EventSlotResult? get nextSlot => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_types')
  List<TicketTypeResult>? get ticketTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_book')
  bool get canBook => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventDetailsToolResultCopyWith<EventDetailsToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDetailsToolResultCopyWith<$Res> {
  factory $EventDetailsToolResultCopyWith(EventDetailsToolResult value,
          $Res Function(EventDetailsToolResult) then) =
      _$EventDetailsToolResultCopyWithImpl<$Res, EventDetailsToolResult>;
  @useResult
  $Res call(
      {String uuid,
      String slug,
      String title,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      EventVenueResult? venue,
      @JsonKey(name: 'next_slot') EventSlotResult? nextSlot,
      @JsonKey(name: 'ticket_types') List<TicketTypeResult>? ticketTypes,
      @JsonKey(name: 'is_favorite') bool isFavorite,
      @JsonKey(name: 'can_book') bool canBook,
      String? category,
      List<String>? tags});

  $EventVenueResultCopyWith<$Res>? get venue;
  $EventSlotResultCopyWith<$Res>? get nextSlot;
}

/// @nodoc
class _$EventDetailsToolResultCopyWithImpl<$Res,
        $Val extends EventDetailsToolResult>
    implements $EventDetailsToolResultCopyWith<$Res> {
  _$EventDetailsToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? venue = freezed,
    Object? nextSlot = freezed,
    Object? ticketTypes = freezed,
    Object? isFavorite = null,
    Object? canBook = null,
    Object? category = freezed,
    Object? tags = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as EventVenueResult?,
      nextSlot: freezed == nextSlot
          ? _value.nextSlot
          : nextSlot // ignore: cast_nullable_to_non_nullable
              as EventSlotResult?,
      ticketTypes: freezed == ticketTypes
          ? _value.ticketTypes
          : ticketTypes // ignore: cast_nullable_to_non_nullable
              as List<TicketTypeResult>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      canBook: null == canBook
          ? _value.canBook
          : canBook // ignore: cast_nullable_to_non_nullable
              as bool,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventVenueResultCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $EventVenueResultCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventSlotResultCopyWith<$Res>? get nextSlot {
    if (_value.nextSlot == null) {
      return null;
    }

    return $EventSlotResultCopyWith<$Res>(_value.nextSlot!, (value) {
      return _then(_value.copyWith(nextSlot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventDetailsToolResultImplCopyWith<$Res>
    implements $EventDetailsToolResultCopyWith<$Res> {
  factory _$$EventDetailsToolResultImplCopyWith(
          _$EventDetailsToolResultImpl value,
          $Res Function(_$EventDetailsToolResultImpl) then) =
      __$$EventDetailsToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String slug,
      String title,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      EventVenueResult? venue,
      @JsonKey(name: 'next_slot') EventSlotResult? nextSlot,
      @JsonKey(name: 'ticket_types') List<TicketTypeResult>? ticketTypes,
      @JsonKey(name: 'is_favorite') bool isFavorite,
      @JsonKey(name: 'can_book') bool canBook,
      String? category,
      List<String>? tags});

  @override
  $EventVenueResultCopyWith<$Res>? get venue;
  @override
  $EventSlotResultCopyWith<$Res>? get nextSlot;
}

/// @nodoc
class __$$EventDetailsToolResultImplCopyWithImpl<$Res>
    extends _$EventDetailsToolResultCopyWithImpl<$Res,
        _$EventDetailsToolResultImpl>
    implements _$$EventDetailsToolResultImplCopyWith<$Res> {
  __$$EventDetailsToolResultImplCopyWithImpl(
      _$EventDetailsToolResultImpl _value,
      $Res Function(_$EventDetailsToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? venue = freezed,
    Object? nextSlot = freezed,
    Object? ticketTypes = freezed,
    Object? isFavorite = null,
    Object? canBook = null,
    Object? category = freezed,
    Object? tags = freezed,
  }) {
    return _then(_$EventDetailsToolResultImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as EventVenueResult?,
      nextSlot: freezed == nextSlot
          ? _value.nextSlot
          : nextSlot // ignore: cast_nullable_to_non_nullable
              as EventSlotResult?,
      ticketTypes: freezed == ticketTypes
          ? _value._ticketTypes
          : ticketTypes // ignore: cast_nullable_to_non_nullable
              as List<TicketTypeResult>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      canBook: null == canBook
          ? _value.canBook
          : canBook // ignore: cast_nullable_to_non_nullable
              as bool,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventDetailsToolResultImpl implements _EventDetailsToolResult {
  const _$EventDetailsToolResultImpl(
      {required this.uuid,
      required this.slug,
      required this.title,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl,
      this.venue,
      @JsonKey(name: 'next_slot') this.nextSlot,
      @JsonKey(name: 'ticket_types') final List<TicketTypeResult>? ticketTypes,
      @JsonKey(name: 'is_favorite') this.isFavorite = false,
      @JsonKey(name: 'can_book') this.canBook = true,
      this.category,
      final List<String>? tags})
      : _ticketTypes = ticketTypes,
        _tags = tags;

  factory _$EventDetailsToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDetailsToolResultImplFromJson(json);

  @override
  final String uuid;
  @override
  final String slug;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final EventVenueResult? venue;
  @override
  @JsonKey(name: 'next_slot')
  final EventSlotResult? nextSlot;
  final List<TicketTypeResult>? _ticketTypes;
  @override
  @JsonKey(name: 'ticket_types')
  List<TicketTypeResult>? get ticketTypes {
    final value = _ticketTypes;
    if (value == null) return null;
    if (_ticketTypes is EqualUnmodifiableListView) return _ticketTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  @override
  @JsonKey(name: 'can_book')
  final bool canBook;
  @override
  final String? category;
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
  String toString() {
    return 'EventDetailsToolResult(uuid: $uuid, slug: $slug, title: $title, description: $description, imageUrl: $imageUrl, venue: $venue, nextSlot: $nextSlot, ticketTypes: $ticketTypes, isFavorite: $isFavorite, canBook: $canBook, category: $category, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailsToolResultImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.nextSlot, nextSlot) ||
                other.nextSlot == nextSlot) &&
            const DeepCollectionEquality()
                .equals(other._ticketTypes, _ticketTypes) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.canBook, canBook) || other.canBook == canBook) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      slug,
      title,
      description,
      imageUrl,
      venue,
      nextSlot,
      const DeepCollectionEquality().hash(_ticketTypes),
      isFavorite,
      canBook,
      category,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDetailsToolResultImplCopyWith<_$EventDetailsToolResultImpl>
      get copyWith => __$$EventDetailsToolResultImplCopyWithImpl<
          _$EventDetailsToolResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventDetailsToolResultImplToJson(
      this,
    );
  }
}

abstract class _EventDetailsToolResult implements EventDetailsToolResult {
  const factory _EventDetailsToolResult(
      {required final String uuid,
      required final String slug,
      required final String title,
      final String? description,
      @JsonKey(name: 'image_url') final String? imageUrl,
      final EventVenueResult? venue,
      @JsonKey(name: 'next_slot') final EventSlotResult? nextSlot,
      @JsonKey(name: 'ticket_types') final List<TicketTypeResult>? ticketTypes,
      @JsonKey(name: 'is_favorite') final bool isFavorite,
      @JsonKey(name: 'can_book') final bool canBook,
      final String? category,
      final List<String>? tags}) = _$EventDetailsToolResultImpl;

  factory _EventDetailsToolResult.fromJson(Map<String, dynamic> json) =
      _$EventDetailsToolResultImpl.fromJson;

  @override
  String get uuid;
  @override
  String get slug;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  EventVenueResult? get venue;
  @override
  @JsonKey(name: 'next_slot')
  EventSlotResult? get nextSlot;
  @override
  @JsonKey(name: 'ticket_types')
  List<TicketTypeResult>? get ticketTypes;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;
  @override
  @JsonKey(name: 'can_book')
  bool get canBook;
  @override
  String? get category;
  @override
  List<String>? get tags;
  @override
  @JsonKey(ignore: true)
  _$$EventDetailsToolResultImplCopyWith<_$EventDetailsToolResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EventVenueResult _$EventVenueResultFromJson(Map<String, dynamic> json) {
  return _EventVenueResult.fromJson(json);
}

/// @nodoc
mixin _$EventVenueResult {
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventVenueResultCopyWith<EventVenueResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventVenueResultCopyWith<$Res> {
  factory $EventVenueResultCopyWith(
          EventVenueResult value, $Res Function(EventVenueResult) then) =
      _$EventVenueResultCopyWithImpl<$Res, EventVenueResult>;
  @useResult
  $Res call(
      {String name,
      String? address,
      String? city,
      double? latitude,
      double? longitude});
}

/// @nodoc
class _$EventVenueResultCopyWithImpl<$Res, $Val extends EventVenueResult>
    implements $EventVenueResultCopyWith<$Res> {
  _$EventVenueResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventVenueResultImplCopyWith<$Res>
    implements $EventVenueResultCopyWith<$Res> {
  factory _$$EventVenueResultImplCopyWith(_$EventVenueResultImpl value,
          $Res Function(_$EventVenueResultImpl) then) =
      __$$EventVenueResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? address,
      String? city,
      double? latitude,
      double? longitude});
}

/// @nodoc
class __$$EventVenueResultImplCopyWithImpl<$Res>
    extends _$EventVenueResultCopyWithImpl<$Res, _$EventVenueResultImpl>
    implements _$$EventVenueResultImplCopyWith<$Res> {
  __$$EventVenueResultImplCopyWithImpl(_$EventVenueResultImpl _value,
      $Res Function(_$EventVenueResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$EventVenueResultImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventVenueResultImpl implements _EventVenueResult {
  const _$EventVenueResultImpl(
      {required this.name,
      this.address,
      this.city,
      this.latitude,
      this.longitude});

  factory _$EventVenueResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventVenueResultImplFromJson(json);

  @override
  final String name;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'EventVenueResult(name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventVenueResultImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, address, city, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventVenueResultImplCopyWith<_$EventVenueResultImpl> get copyWith =>
      __$$EventVenueResultImplCopyWithImpl<_$EventVenueResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventVenueResultImplToJson(
      this,
    );
  }
}

abstract class _EventVenueResult implements EventVenueResult {
  const factory _EventVenueResult(
      {required final String name,
      final String? address,
      final String? city,
      final double? latitude,
      final double? longitude}) = _$EventVenueResultImpl;

  factory _EventVenueResult.fromJson(Map<String, dynamic> json) =
      _$EventVenueResultImpl.fromJson;

  @override
  String get name;
  @override
  String? get address;
  @override
  String? get city;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(ignore: true)
  _$$EventVenueResultImplCopyWith<_$EventVenueResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventSlotResult _$EventSlotResultFromJson(Map<String, dynamic> json) {
  return _EventSlotResult.fromJson(json);
}

/// @nodoc
mixin _$EventSlotResult {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_date')
  String get slotDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String? get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_capacity')
  int? get availableCapacity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventSlotResultCopyWith<EventSlotResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventSlotResultCopyWith<$Res> {
  factory $EventSlotResultCopyWith(
          EventSlotResult value, $Res Function(EventSlotResult) then) =
      _$EventSlotResultCopyWithImpl<$Res, EventSlotResult>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'slot_date') String slotDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String? endTime,
      @JsonKey(name: 'available_capacity') int? availableCapacity});
}

/// @nodoc
class _$EventSlotResultCopyWithImpl<$Res, $Val extends EventSlotResult>
    implements $EventSlotResultCopyWith<$Res> {
  _$EventSlotResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slotDate = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? availableCapacity = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slotDate: null == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      availableCapacity: freezed == availableCapacity
          ? _value.availableCapacity
          : availableCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventSlotResultImplCopyWith<$Res>
    implements $EventSlotResultCopyWith<$Res> {
  factory _$$EventSlotResultImplCopyWith(_$EventSlotResultImpl value,
          $Res Function(_$EventSlotResultImpl) then) =
      __$$EventSlotResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'slot_date') String slotDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String? endTime,
      @JsonKey(name: 'available_capacity') int? availableCapacity});
}

/// @nodoc
class __$$EventSlotResultImplCopyWithImpl<$Res>
    extends _$EventSlotResultCopyWithImpl<$Res, _$EventSlotResultImpl>
    implements _$$EventSlotResultImplCopyWith<$Res> {
  __$$EventSlotResultImplCopyWithImpl(
      _$EventSlotResultImpl _value, $Res Function(_$EventSlotResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slotDate = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? availableCapacity = freezed,
  }) {
    return _then(_$EventSlotResultImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slotDate: null == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      availableCapacity: freezed == availableCapacity
          ? _value.availableCapacity
          : availableCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventSlotResultImpl implements _EventSlotResult {
  const _$EventSlotResultImpl(
      {required this.uuid,
      @JsonKey(name: 'slot_date') required this.slotDate,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') this.endTime,
      @JsonKey(name: 'available_capacity') this.availableCapacity});

  factory _$EventSlotResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventSlotResultImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(name: 'slot_date')
  final String slotDate;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String? endTime;
  @override
  @JsonKey(name: 'available_capacity')
  final int? availableCapacity;

  @override
  String toString() {
    return 'EventSlotResult(uuid: $uuid, slotDate: $slotDate, startTime: $startTime, endTime: $endTime, availableCapacity: $availableCapacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventSlotResultImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slotDate, slotDate) ||
                other.slotDate == slotDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.availableCapacity, availableCapacity) ||
                other.availableCapacity == availableCapacity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uuid, slotDate, startTime, endTime, availableCapacity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventSlotResultImplCopyWith<_$EventSlotResultImpl> get copyWith =>
      __$$EventSlotResultImplCopyWithImpl<_$EventSlotResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventSlotResultImplToJson(
      this,
    );
  }
}

abstract class _EventSlotResult implements EventSlotResult {
  const factory _EventSlotResult(
          {required final String uuid,
          @JsonKey(name: 'slot_date') required final String slotDate,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') final String? endTime,
          @JsonKey(name: 'available_capacity') final int? availableCapacity}) =
      _$EventSlotResultImpl;

  factory _EventSlotResult.fromJson(Map<String, dynamic> json) =
      _$EventSlotResultImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(name: 'slot_date')
  String get slotDate;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String? get endTime;
  @override
  @JsonKey(name: 'available_capacity')
  int? get availableCapacity;
  @override
  @JsonKey(ignore: true)
  _$$EventSlotResultImplCopyWith<_$EventSlotResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketTypeResult _$TicketTypeResultFromJson(Map<String, dynamic> json) {
  return _TicketTypeResult.fromJson(json);
}

/// @nodoc
mixin _$TicketTypeResult {
  String get uuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_quantity')
  int? get availableQuantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketTypeResultCopyWith<TicketTypeResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketTypeResultCopyWith<$Res> {
  factory $TicketTypeResultCopyWith(
          TicketTypeResult value, $Res Function(TicketTypeResult) then) =
      _$TicketTypeResultCopyWithImpl<$Res, TicketTypeResult>;
  @useResult
  $Res call(
      {String uuid,
      String name,
      double price,
      String? description,
      @JsonKey(name: 'available_quantity') int? availableQuantity});
}

/// @nodoc
class _$TicketTypeResultCopyWithImpl<$Res, $Val extends TicketTypeResult>
    implements $TicketTypeResultCopyWith<$Res> {
  _$TicketTypeResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? price = null,
    Object? description = freezed,
    Object? availableQuantity = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      availableQuantity: freezed == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketTypeResultImplCopyWith<$Res>
    implements $TicketTypeResultCopyWith<$Res> {
  factory _$$TicketTypeResultImplCopyWith(_$TicketTypeResultImpl value,
          $Res Function(_$TicketTypeResultImpl) then) =
      __$$TicketTypeResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String name,
      double price,
      String? description,
      @JsonKey(name: 'available_quantity') int? availableQuantity});
}

/// @nodoc
class __$$TicketTypeResultImplCopyWithImpl<$Res>
    extends _$TicketTypeResultCopyWithImpl<$Res, _$TicketTypeResultImpl>
    implements _$$TicketTypeResultImplCopyWith<$Res> {
  __$$TicketTypeResultImplCopyWithImpl(_$TicketTypeResultImpl _value,
      $Res Function(_$TicketTypeResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? price = null,
    Object? description = freezed,
    Object? availableQuantity = freezed,
  }) {
    return _then(_$TicketTypeResultImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      availableQuantity: freezed == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketTypeResultImpl implements _TicketTypeResult {
  const _$TicketTypeResultImpl(
      {required this.uuid,
      required this.name,
      required this.price,
      this.description,
      @JsonKey(name: 'available_quantity') this.availableQuantity});

  factory _$TicketTypeResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketTypeResultImplFromJson(json);

  @override
  final String uuid;
  @override
  final String name;
  @override
  final double price;
  @override
  final String? description;
  @override
  @JsonKey(name: 'available_quantity')
  final int? availableQuantity;

  @override
  String toString() {
    return 'TicketTypeResult(uuid: $uuid, name: $name, price: $price, description: $description, availableQuantity: $availableQuantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketTypeResultImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uuid, name, price, description, availableQuantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketTypeResultImplCopyWith<_$TicketTypeResultImpl> get copyWith =>
      __$$TicketTypeResultImplCopyWithImpl<_$TicketTypeResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketTypeResultImplToJson(
      this,
    );
  }
}

abstract class _TicketTypeResult implements TicketTypeResult {
  const factory _TicketTypeResult(
          {required final String uuid,
          required final String name,
          required final double price,
          final String? description,
          @JsonKey(name: 'available_quantity') final int? availableQuantity}) =
      _$TicketTypeResultImpl;

  factory _TicketTypeResult.fromJson(Map<String, dynamic> json) =
      _$TicketTypeResultImpl.fromJson;

  @override
  String get uuid;
  @override
  String get name;
  @override
  double get price;
  @override
  String? get description;
  @override
  @JsonKey(name: 'available_quantity')
  int? get availableQuantity;
  @override
  @JsonKey(ignore: true)
  _$$TicketTypeResultImplCopyWith<_$TicketTypeResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FavoritesToolResult _$FavoritesToolResultFromJson(Map<String, dynamic> json) {
  return _FavoritesToolResult.fromJson(json);
}

/// @nodoc
mixin _$FavoritesToolResult {
  List<EventResultItem> get favorites => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  List<FavoriteListResult>? get lists => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FavoritesToolResultCopyWith<FavoritesToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesToolResultCopyWith<$Res> {
  factory $FavoritesToolResultCopyWith(
          FavoritesToolResult value, $Res Function(FavoritesToolResult) then) =
      _$FavoritesToolResultCopyWithImpl<$Res, FavoritesToolResult>;
  @useResult
  $Res call(
      {List<EventResultItem> favorites,
      int total,
      List<FavoriteListResult>? lists});
}

/// @nodoc
class _$FavoritesToolResultCopyWithImpl<$Res, $Val extends FavoritesToolResult>
    implements $FavoritesToolResultCopyWith<$Res> {
  _$FavoritesToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favorites = null,
    Object? total = null,
    Object? lists = freezed,
  }) {
    return _then(_value.copyWith(
      favorites: null == favorites
          ? _value.favorites
          : favorites // ignore: cast_nullable_to_non_nullable
              as List<EventResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lists: freezed == lists
          ? _value.lists
          : lists // ignore: cast_nullable_to_non_nullable
              as List<FavoriteListResult>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoritesToolResultImplCopyWith<$Res>
    implements $FavoritesToolResultCopyWith<$Res> {
  factory _$$FavoritesToolResultImplCopyWith(_$FavoritesToolResultImpl value,
          $Res Function(_$FavoritesToolResultImpl) then) =
      __$$FavoritesToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EventResultItem> favorites,
      int total,
      List<FavoriteListResult>? lists});
}

/// @nodoc
class __$$FavoritesToolResultImplCopyWithImpl<$Res>
    extends _$FavoritesToolResultCopyWithImpl<$Res, _$FavoritesToolResultImpl>
    implements _$$FavoritesToolResultImplCopyWith<$Res> {
  __$$FavoritesToolResultImplCopyWithImpl(_$FavoritesToolResultImpl _value,
      $Res Function(_$FavoritesToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favorites = null,
    Object? total = null,
    Object? lists = freezed,
  }) {
    return _then(_$FavoritesToolResultImpl(
      favorites: null == favorites
          ? _value._favorites
          : favorites // ignore: cast_nullable_to_non_nullable
              as List<EventResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lists: freezed == lists
          ? _value._lists
          : lists // ignore: cast_nullable_to_non_nullable
              as List<FavoriteListResult>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoritesToolResultImpl implements _FavoritesToolResult {
  const _$FavoritesToolResultImpl(
      {required final List<EventResultItem> favorites,
      required this.total,
      final List<FavoriteListResult>? lists})
      : _favorites = favorites,
        _lists = lists;

  factory _$FavoritesToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoritesToolResultImplFromJson(json);

  final List<EventResultItem> _favorites;
  @override
  List<EventResultItem> get favorites {
    if (_favorites is EqualUnmodifiableListView) return _favorites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favorites);
  }

  @override
  final int total;
  final List<FavoriteListResult>? _lists;
  @override
  List<FavoriteListResult>? get lists {
    final value = _lists;
    if (value == null) return null;
    if (_lists is EqualUnmodifiableListView) return _lists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FavoritesToolResult(favorites: $favorites, total: $total, lists: $lists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesToolResultImpl &&
            const DeepCollectionEquality()
                .equals(other._favorites, _favorites) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._lists, _lists));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_favorites),
      total,
      const DeepCollectionEquality().hash(_lists));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesToolResultImplCopyWith<_$FavoritesToolResultImpl> get copyWith =>
      __$$FavoritesToolResultImplCopyWithImpl<_$FavoritesToolResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoritesToolResultImplToJson(
      this,
    );
  }
}

abstract class _FavoritesToolResult implements FavoritesToolResult {
  const factory _FavoritesToolResult(
      {required final List<EventResultItem> favorites,
      required final int total,
      final List<FavoriteListResult>? lists}) = _$FavoritesToolResultImpl;

  factory _FavoritesToolResult.fromJson(Map<String, dynamic> json) =
      _$FavoritesToolResultImpl.fromJson;

  @override
  List<EventResultItem> get favorites;
  @override
  int get total;
  @override
  List<FavoriteListResult>? get lists;
  @override
  @JsonKey(ignore: true)
  _$$FavoritesToolResultImplCopyWith<_$FavoritesToolResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FavoriteListResult _$FavoriteListResultFromJson(Map<String, dynamic> json) {
  return _FavoriteListResult.fromJson(json);
}

/// @nodoc
mixin _$FavoriteListResult {
  String get uuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'events_count')
  int get eventsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FavoriteListResultCopyWith<FavoriteListResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteListResultCopyWith<$Res> {
  factory $FavoriteListResultCopyWith(
          FavoriteListResult value, $Res Function(FavoriteListResult) then) =
      _$FavoriteListResultCopyWithImpl<$Res, FavoriteListResult>;
  @useResult
  $Res call(
      {String uuid,
      String name,
      @JsonKey(name: 'events_count') int eventsCount});
}

/// @nodoc
class _$FavoriteListResultCopyWithImpl<$Res, $Val extends FavoriteListResult>
    implements $FavoriteListResultCopyWith<$Res> {
  _$FavoriteListResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? eventsCount = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      eventsCount: null == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoriteListResultImplCopyWith<$Res>
    implements $FavoriteListResultCopyWith<$Res> {
  factory _$$FavoriteListResultImplCopyWith(_$FavoriteListResultImpl value,
          $Res Function(_$FavoriteListResultImpl) then) =
      __$$FavoriteListResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String name,
      @JsonKey(name: 'events_count') int eventsCount});
}

/// @nodoc
class __$$FavoriteListResultImplCopyWithImpl<$Res>
    extends _$FavoriteListResultCopyWithImpl<$Res, _$FavoriteListResultImpl>
    implements _$$FavoriteListResultImplCopyWith<$Res> {
  __$$FavoriteListResultImplCopyWithImpl(_$FavoriteListResultImpl _value,
      $Res Function(_$FavoriteListResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? eventsCount = null,
  }) {
    return _then(_$FavoriteListResultImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      eventsCount: null == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteListResultImpl implements _FavoriteListResult {
  const _$FavoriteListResultImpl(
      {required this.uuid,
      required this.name,
      @JsonKey(name: 'events_count') this.eventsCount = 0});

  factory _$FavoriteListResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteListResultImplFromJson(json);

  @override
  final String uuid;
  @override
  final String name;
  @override
  @JsonKey(name: 'events_count')
  final int eventsCount;

  @override
  String toString() {
    return 'FavoriteListResult(uuid: $uuid, name: $name, eventsCount: $eventsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteListResultImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.eventsCount, eventsCount) ||
                other.eventsCount == eventsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, name, eventsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteListResultImplCopyWith<_$FavoriteListResultImpl> get copyWith =>
      __$$FavoriteListResultImplCopyWithImpl<_$FavoriteListResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteListResultImplToJson(
      this,
    );
  }
}

abstract class _FavoriteListResult implements FavoriteListResult {
  const factory _FavoriteListResult(
          {required final String uuid,
          required final String name,
          @JsonKey(name: 'events_count') final int eventsCount}) =
      _$FavoriteListResultImpl;

  factory _FavoriteListResult.fromJson(Map<String, dynamic> json) =
      _$FavoriteListResultImpl.fromJson;

  @override
  String get uuid;
  @override
  String get name;
  @override
  @JsonKey(name: 'events_count')
  int get eventsCount;
  @override
  @JsonKey(ignore: true)
  _$$FavoriteListResultImplCopyWith<_$FavoriteListResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertsToolResult _$AlertsToolResultFromJson(Map<String, dynamic> json) {
  return _AlertsToolResult.fromJson(json);
}

/// @nodoc
mixin _$AlertsToolResult {
  List<AlertResultItem> get alerts => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_count')
  int get activeCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlertsToolResultCopyWith<AlertsToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertsToolResultCopyWith<$Res> {
  factory $AlertsToolResultCopyWith(
          AlertsToolResult value, $Res Function(AlertsToolResult) then) =
      _$AlertsToolResultCopyWithImpl<$Res, AlertsToolResult>;
  @useResult
  $Res call(
      {List<AlertResultItem> alerts,
      int total,
      @JsonKey(name: 'active_count') int activeCount});
}

/// @nodoc
class _$AlertsToolResultCopyWithImpl<$Res, $Val extends AlertsToolResult>
    implements $AlertsToolResultCopyWith<$Res> {
  _$AlertsToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alerts = null,
    Object? total = null,
    Object? activeCount = null,
  }) {
    return _then(_value.copyWith(
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<AlertResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertsToolResultImplCopyWith<$Res>
    implements $AlertsToolResultCopyWith<$Res> {
  factory _$$AlertsToolResultImplCopyWith(_$AlertsToolResultImpl value,
          $Res Function(_$AlertsToolResultImpl) then) =
      __$$AlertsToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AlertResultItem> alerts,
      int total,
      @JsonKey(name: 'active_count') int activeCount});
}

/// @nodoc
class __$$AlertsToolResultImplCopyWithImpl<$Res>
    extends _$AlertsToolResultCopyWithImpl<$Res, _$AlertsToolResultImpl>
    implements _$$AlertsToolResultImplCopyWith<$Res> {
  __$$AlertsToolResultImplCopyWithImpl(_$AlertsToolResultImpl _value,
      $Res Function(_$AlertsToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alerts = null,
    Object? total = null,
    Object? activeCount = null,
  }) {
    return _then(_$AlertsToolResultImpl(
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<AlertResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertsToolResultImpl implements _AlertsToolResult {
  const _$AlertsToolResultImpl(
      {required final List<AlertResultItem> alerts,
      required this.total,
      @JsonKey(name: 'active_count') this.activeCount = 0})
      : _alerts = alerts;

  factory _$AlertsToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertsToolResultImplFromJson(json);

  final List<AlertResultItem> _alerts;
  @override
  List<AlertResultItem> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  final int total;
  @override
  @JsonKey(name: 'active_count')
  final int activeCount;

  @override
  String toString() {
    return 'AlertsToolResult(alerts: $alerts, total: $total, activeCount: $activeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertsToolResultImpl &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.activeCount, activeCount) ||
                other.activeCount == activeCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_alerts), total, activeCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertsToolResultImplCopyWith<_$AlertsToolResultImpl> get copyWith =>
      __$$AlertsToolResultImplCopyWithImpl<_$AlertsToolResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertsToolResultImplToJson(
      this,
    );
  }
}

abstract class _AlertsToolResult implements AlertsToolResult {
  const factory _AlertsToolResult(
          {required final List<AlertResultItem> alerts,
          required final int total,
          @JsonKey(name: 'active_count') final int activeCount}) =
      _$AlertsToolResultImpl;

  factory _AlertsToolResult.fromJson(Map<String, dynamic> json) =
      _$AlertsToolResultImpl.fromJson;

  @override
  List<AlertResultItem> get alerts;
  @override
  int get total;
  @override
  @JsonKey(name: 'active_count')
  int get activeCount;
  @override
  @JsonKey(ignore: true)
  _$$AlertsToolResultImplCopyWith<_$AlertsToolResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertResultItem _$AlertResultItemFromJson(Map<String, dynamic> json) {
  return _AlertResultItem.fromJson(json);
}

/// @nodoc
mixin _$AlertResultItem {
  String get uuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_triggered_at')
  String? get lastTriggeredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_events_count')
  int get newEventsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'search_criteria_summary')
  String? get searchCriteriaSummary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlertResultItemCopyWith<AlertResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertResultItemCopyWith<$Res> {
  factory $AlertResultItemCopyWith(
          AlertResultItem value, $Res Function(AlertResultItem) then) =
      _$AlertResultItemCopyWithImpl<$Res, AlertResultItem>;
  @useResult
  $Res call(
      {String uuid,
      String name,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_triggered_at') String? lastTriggeredAt,
      @JsonKey(name: 'new_events_count') int newEventsCount,
      @JsonKey(name: 'search_criteria_summary') String? searchCriteriaSummary});
}

/// @nodoc
class _$AlertResultItemCopyWithImpl<$Res, $Val extends AlertResultItem>
    implements $AlertResultItemCopyWith<$Res> {
  _$AlertResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? isActive = null,
    Object? lastTriggeredAt = freezed,
    Object? newEventsCount = null,
    Object? searchCriteriaSummary = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTriggeredAt: freezed == lastTriggeredAt
          ? _value.lastTriggeredAt
          : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      newEventsCount: null == newEventsCount
          ? _value.newEventsCount
          : newEventsCount // ignore: cast_nullable_to_non_nullable
              as int,
      searchCriteriaSummary: freezed == searchCriteriaSummary
          ? _value.searchCriteriaSummary
          : searchCriteriaSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertResultItemImplCopyWith<$Res>
    implements $AlertResultItemCopyWith<$Res> {
  factory _$$AlertResultItemImplCopyWith(_$AlertResultItemImpl value,
          $Res Function(_$AlertResultItemImpl) then) =
      __$$AlertResultItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String name,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_triggered_at') String? lastTriggeredAt,
      @JsonKey(name: 'new_events_count') int newEventsCount,
      @JsonKey(name: 'search_criteria_summary') String? searchCriteriaSummary});
}

/// @nodoc
class __$$AlertResultItemImplCopyWithImpl<$Res>
    extends _$AlertResultItemCopyWithImpl<$Res, _$AlertResultItemImpl>
    implements _$$AlertResultItemImplCopyWith<$Res> {
  __$$AlertResultItemImplCopyWithImpl(
      _$AlertResultItemImpl _value, $Res Function(_$AlertResultItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? isActive = null,
    Object? lastTriggeredAt = freezed,
    Object? newEventsCount = null,
    Object? searchCriteriaSummary = freezed,
  }) {
    return _then(_$AlertResultItemImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTriggeredAt: freezed == lastTriggeredAt
          ? _value.lastTriggeredAt
          : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      newEventsCount: null == newEventsCount
          ? _value.newEventsCount
          : newEventsCount // ignore: cast_nullable_to_non_nullable
              as int,
      searchCriteriaSummary: freezed == searchCriteriaSummary
          ? _value.searchCriteriaSummary
          : searchCriteriaSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertResultItemImpl implements _AlertResultItem {
  const _$AlertResultItemImpl(
      {required this.uuid,
      required this.name,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'last_triggered_at') this.lastTriggeredAt,
      @JsonKey(name: 'new_events_count') this.newEventsCount = 0,
      @JsonKey(name: 'search_criteria_summary') this.searchCriteriaSummary});

  factory _$AlertResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertResultItemImplFromJson(json);

  @override
  final String uuid;
  @override
  final String name;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'last_triggered_at')
  final String? lastTriggeredAt;
  @override
  @JsonKey(name: 'new_events_count')
  final int newEventsCount;
  @override
  @JsonKey(name: 'search_criteria_summary')
  final String? searchCriteriaSummary;

  @override
  String toString() {
    return 'AlertResultItem(uuid: $uuid, name: $name, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, newEventsCount: $newEventsCount, searchCriteriaSummary: $searchCriteriaSummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertResultItemImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastTriggeredAt, lastTriggeredAt) ||
                other.lastTriggeredAt == lastTriggeredAt) &&
            (identical(other.newEventsCount, newEventsCount) ||
                other.newEventsCount == newEventsCount) &&
            (identical(other.searchCriteriaSummary, searchCriteriaSummary) ||
                other.searchCriteriaSummary == searchCriteriaSummary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, name, isActive,
      lastTriggeredAt, newEventsCount, searchCriteriaSummary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertResultItemImplCopyWith<_$AlertResultItemImpl> get copyWith =>
      __$$AlertResultItemImplCopyWithImpl<_$AlertResultItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertResultItemImplToJson(
      this,
    );
  }
}

abstract class _AlertResultItem implements AlertResultItem {
  const factory _AlertResultItem(
      {required final String uuid,
      required final String name,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'last_triggered_at') final String? lastTriggeredAt,
      @JsonKey(name: 'new_events_count') final int newEventsCount,
      @JsonKey(name: 'search_criteria_summary')
      final String? searchCriteriaSummary}) = _$AlertResultItemImpl;

  factory _AlertResultItem.fromJson(Map<String, dynamic> json) =
      _$AlertResultItemImpl.fromJson;

  @override
  String get uuid;
  @override
  String get name;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'last_triggered_at')
  String? get lastTriggeredAt;
  @override
  @JsonKey(name: 'new_events_count')
  int get newEventsCount;
  @override
  @JsonKey(name: 'search_criteria_summary')
  String? get searchCriteriaSummary;
  @override
  @JsonKey(ignore: true)
  _$$AlertResultItemImplCopyWith<_$AlertResultItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileToolResult _$ProfileToolResultFromJson(Map<String, dynamic> json) {
  return _ProfileToolResult.fromJson(json);
}

/// @nodoc
mixin _$ProfileToolResult {
  UserProfileResult get user => throw _privateConstructorUsedError;
  ProfileStatsResult? get stats => throw _privateConstructorUsedError;
  @JsonKey(name: 'hiboos_balance')
  int get hiboosBalance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileToolResultCopyWith<ProfileToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileToolResultCopyWith<$Res> {
  factory $ProfileToolResultCopyWith(
          ProfileToolResult value, $Res Function(ProfileToolResult) then) =
      _$ProfileToolResultCopyWithImpl<$Res, ProfileToolResult>;
  @useResult
  $Res call(
      {UserProfileResult user,
      ProfileStatsResult? stats,
      @JsonKey(name: 'hiboos_balance') int hiboosBalance});

  $UserProfileResultCopyWith<$Res> get user;
  $ProfileStatsResultCopyWith<$Res>? get stats;
}

/// @nodoc
class _$ProfileToolResultCopyWithImpl<$Res, $Val extends ProfileToolResult>
    implements $ProfileToolResultCopyWith<$Res> {
  _$ProfileToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? stats = freezed,
    Object? hiboosBalance = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfileResult,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as ProfileStatsResult?,
      hiboosBalance: null == hiboosBalance
          ? _value.hiboosBalance
          : hiboosBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileResultCopyWith<$Res> get user {
    return $UserProfileResultCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileStatsResultCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $ProfileStatsResultCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileToolResultImplCopyWith<$Res>
    implements $ProfileToolResultCopyWith<$Res> {
  factory _$$ProfileToolResultImplCopyWith(_$ProfileToolResultImpl value,
          $Res Function(_$ProfileToolResultImpl) then) =
      __$$ProfileToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserProfileResult user,
      ProfileStatsResult? stats,
      @JsonKey(name: 'hiboos_balance') int hiboosBalance});

  @override
  $UserProfileResultCopyWith<$Res> get user;
  @override
  $ProfileStatsResultCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$ProfileToolResultImplCopyWithImpl<$Res>
    extends _$ProfileToolResultCopyWithImpl<$Res, _$ProfileToolResultImpl>
    implements _$$ProfileToolResultImplCopyWith<$Res> {
  __$$ProfileToolResultImplCopyWithImpl(_$ProfileToolResultImpl _value,
      $Res Function(_$ProfileToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? stats = freezed,
    Object? hiboosBalance = null,
  }) {
    return _then(_$ProfileToolResultImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfileResult,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as ProfileStatsResult?,
      hiboosBalance: null == hiboosBalance
          ? _value.hiboosBalance
          : hiboosBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileToolResultImpl implements _ProfileToolResult {
  const _$ProfileToolResultImpl(
      {required this.user,
      this.stats,
      @JsonKey(name: 'hiboos_balance') this.hiboosBalance = 0});

  factory _$ProfileToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileToolResultImplFromJson(json);

  @override
  final UserProfileResult user;
  @override
  final ProfileStatsResult? stats;
  @override
  @JsonKey(name: 'hiboos_balance')
  final int hiboosBalance;

  @override
  String toString() {
    return 'ProfileToolResult(user: $user, stats: $stats, hiboosBalance: $hiboosBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileToolResultImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.hiboosBalance, hiboosBalance) ||
                other.hiboosBalance == hiboosBalance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, stats, hiboosBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileToolResultImplCopyWith<_$ProfileToolResultImpl> get copyWith =>
      __$$ProfileToolResultImplCopyWithImpl<_$ProfileToolResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileToolResultImplToJson(
      this,
    );
  }
}

abstract class _ProfileToolResult implements ProfileToolResult {
  const factory _ProfileToolResult(
          {required final UserProfileResult user,
          final ProfileStatsResult? stats,
          @JsonKey(name: 'hiboos_balance') final int hiboosBalance}) =
      _$ProfileToolResultImpl;

  factory _ProfileToolResult.fromJson(Map<String, dynamic> json) =
      _$ProfileToolResultImpl.fromJson;

  @override
  UserProfileResult get user;
  @override
  ProfileStatsResult? get stats;
  @override
  @JsonKey(name: 'hiboos_balance')
  int get hiboosBalance;
  @override
  @JsonKey(ignore: true)
  _$$ProfileToolResultImplCopyWith<_$ProfileToolResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfileResult _$UserProfileResultFromJson(Map<String, dynamic> json) {
  return _UserProfileResult.fromJson(json);
}

/// @nodoc
mixin _$UserProfileResult {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileResultCopyWith<UserProfileResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileResultCopyWith<$Res> {
  factory $UserProfileResultCopyWith(
          UserProfileResult value, $Res Function(UserProfileResult) then) =
      _$UserProfileResultCopyWithImpl<$Res, UserProfileResult>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String email,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$UserProfileResultCopyWithImpl<$Res, $Val extends UserProfileResult>
    implements $UserProfileResultCopyWith<$Res> {
  _$UserProfileResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? phoneNumber = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileResultImplCopyWith<$Res>
    implements $UserProfileResultCopyWith<$Res> {
  factory _$$UserProfileResultImplCopyWith(_$UserProfileResultImpl value,
          $Res Function(_$UserProfileResultImpl) then) =
      __$$UserProfileResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String email,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$UserProfileResultImplCopyWithImpl<$Res>
    extends _$UserProfileResultCopyWithImpl<$Res, _$UserProfileResultImpl>
    implements _$$UserProfileResultImplCopyWith<$Res> {
  __$$UserProfileResultImplCopyWithImpl(_$UserProfileResultImpl _value,
      $Res Function(_$UserProfileResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? phoneNumber = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserProfileResultImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileResultImpl implements _UserProfileResult {
  const _$UserProfileResultImpl(
      {required this.uuid,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      required this.email,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'phone_number') this.phoneNumber,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$UserProfileResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileResultImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String email;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'UserProfileResult(uuid: $uuid, firstName: $firstName, lastName: $lastName, email: $email, avatarUrl: $avatarUrl, phoneNumber: $phoneNumber, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileResultImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, firstName, lastName, email,
      avatarUrl, phoneNumber, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileResultImplCopyWith<_$UserProfileResultImpl> get copyWith =>
      __$$UserProfileResultImplCopyWithImpl<_$UserProfileResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileResultImplToJson(
      this,
    );
  }
}

abstract class _UserProfileResult implements UserProfileResult {
  const factory _UserProfileResult(
          {required final String uuid,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          required final String email,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'phone_number') final String? phoneNumber,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$UserProfileResultImpl;

  factory _UserProfileResult.fromJson(Map<String, dynamic> json) =
      _$UserProfileResultImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String get email;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileResultImplCopyWith<_$UserProfileResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileStatsResult _$ProfileStatsResultFromJson(Map<String, dynamic> json) {
  return _ProfileStatsResult.fromJson(json);
}

/// @nodoc
mixin _$ProfileStatsResult {
  @JsonKey(name: 'total_bookings')
  int get totalBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_events_attended')
  int get totalEventsAttended => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_favorites')
  int get totalFavorites => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_alerts')
  int get totalAlerts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileStatsResultCopyWith<ProfileStatsResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStatsResultCopyWith<$Res> {
  factory $ProfileStatsResultCopyWith(
          ProfileStatsResult value, $Res Function(ProfileStatsResult) then) =
      _$ProfileStatsResultCopyWithImpl<$Res, ProfileStatsResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_bookings') int totalBookings,
      @JsonKey(name: 'total_events_attended') int totalEventsAttended,
      @JsonKey(name: 'total_favorites') int totalFavorites,
      @JsonKey(name: 'total_alerts') int totalAlerts});
}

/// @nodoc
class _$ProfileStatsResultCopyWithImpl<$Res, $Val extends ProfileStatsResult>
    implements $ProfileStatsResultCopyWith<$Res> {
  _$ProfileStatsResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBookings = null,
    Object? totalEventsAttended = null,
    Object? totalFavorites = null,
    Object? totalAlerts = null,
  }) {
    return _then(_value.copyWith(
      totalBookings: null == totalBookings
          ? _value.totalBookings
          : totalBookings // ignore: cast_nullable_to_non_nullable
              as int,
      totalEventsAttended: null == totalEventsAttended
          ? _value.totalEventsAttended
          : totalEventsAttended // ignore: cast_nullable_to_non_nullable
              as int,
      totalFavorites: null == totalFavorites
          ? _value.totalFavorites
          : totalFavorites // ignore: cast_nullable_to_non_nullable
              as int,
      totalAlerts: null == totalAlerts
          ? _value.totalAlerts
          : totalAlerts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileStatsResultImplCopyWith<$Res>
    implements $ProfileStatsResultCopyWith<$Res> {
  factory _$$ProfileStatsResultImplCopyWith(_$ProfileStatsResultImpl value,
          $Res Function(_$ProfileStatsResultImpl) then) =
      __$$ProfileStatsResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_bookings') int totalBookings,
      @JsonKey(name: 'total_events_attended') int totalEventsAttended,
      @JsonKey(name: 'total_favorites') int totalFavorites,
      @JsonKey(name: 'total_alerts') int totalAlerts});
}

/// @nodoc
class __$$ProfileStatsResultImplCopyWithImpl<$Res>
    extends _$ProfileStatsResultCopyWithImpl<$Res, _$ProfileStatsResultImpl>
    implements _$$ProfileStatsResultImplCopyWith<$Res> {
  __$$ProfileStatsResultImplCopyWithImpl(_$ProfileStatsResultImpl _value,
      $Res Function(_$ProfileStatsResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBookings = null,
    Object? totalEventsAttended = null,
    Object? totalFavorites = null,
    Object? totalAlerts = null,
  }) {
    return _then(_$ProfileStatsResultImpl(
      totalBookings: null == totalBookings
          ? _value.totalBookings
          : totalBookings // ignore: cast_nullable_to_non_nullable
              as int,
      totalEventsAttended: null == totalEventsAttended
          ? _value.totalEventsAttended
          : totalEventsAttended // ignore: cast_nullable_to_non_nullable
              as int,
      totalFavorites: null == totalFavorites
          ? _value.totalFavorites
          : totalFavorites // ignore: cast_nullable_to_non_nullable
              as int,
      totalAlerts: null == totalAlerts
          ? _value.totalAlerts
          : totalAlerts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileStatsResultImpl implements _ProfileStatsResult {
  const _$ProfileStatsResultImpl(
      {@JsonKey(name: 'total_bookings') this.totalBookings = 0,
      @JsonKey(name: 'total_events_attended') this.totalEventsAttended = 0,
      @JsonKey(name: 'total_favorites') this.totalFavorites = 0,
      @JsonKey(name: 'total_alerts') this.totalAlerts = 0});

  factory _$ProfileStatsResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileStatsResultImplFromJson(json);

  @override
  @JsonKey(name: 'total_bookings')
  final int totalBookings;
  @override
  @JsonKey(name: 'total_events_attended')
  final int totalEventsAttended;
  @override
  @JsonKey(name: 'total_favorites')
  final int totalFavorites;
  @override
  @JsonKey(name: 'total_alerts')
  final int totalAlerts;

  @override
  String toString() {
    return 'ProfileStatsResult(totalBookings: $totalBookings, totalEventsAttended: $totalEventsAttended, totalFavorites: $totalFavorites, totalAlerts: $totalAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStatsResultImpl &&
            (identical(other.totalBookings, totalBookings) ||
                other.totalBookings == totalBookings) &&
            (identical(other.totalEventsAttended, totalEventsAttended) ||
                other.totalEventsAttended == totalEventsAttended) &&
            (identical(other.totalFavorites, totalFavorites) ||
                other.totalFavorites == totalFavorites) &&
            (identical(other.totalAlerts, totalAlerts) ||
                other.totalAlerts == totalAlerts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalBookings,
      totalEventsAttended, totalFavorites, totalAlerts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStatsResultImplCopyWith<_$ProfileStatsResultImpl> get copyWith =>
      __$$ProfileStatsResultImplCopyWithImpl<_$ProfileStatsResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileStatsResultImplToJson(
      this,
    );
  }
}

abstract class _ProfileStatsResult implements ProfileStatsResult {
  const factory _ProfileStatsResult(
          {@JsonKey(name: 'total_bookings') final int totalBookings,
          @JsonKey(name: 'total_events_attended') final int totalEventsAttended,
          @JsonKey(name: 'total_favorites') final int totalFavorites,
          @JsonKey(name: 'total_alerts') final int totalAlerts}) =
      _$ProfileStatsResultImpl;

  factory _ProfileStatsResult.fromJson(Map<String, dynamic> json) =
      _$ProfileStatsResultImpl.fromJson;

  @override
  @JsonKey(name: 'total_bookings')
  int get totalBookings;
  @override
  @JsonKey(name: 'total_events_attended')
  int get totalEventsAttended;
  @override
  @JsonKey(name: 'total_favorites')
  int get totalFavorites;
  @override
  @JsonKey(name: 'total_alerts')
  int get totalAlerts;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStatsResultImplCopyWith<_$ProfileStatsResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationsToolResult _$NotificationsToolResultFromJson(
    Map<String, dynamic> json) {
  return _NotificationsToolResult.fromJson(json);
}

/// @nodoc
mixin _$NotificationsToolResult {
  List<NotificationResultItem> get notifications =>
      throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationsToolResultCopyWith<NotificationsToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsToolResultCopyWith<$Res> {
  factory $NotificationsToolResultCopyWith(NotificationsToolResult value,
          $Res Function(NotificationsToolResult) then) =
      _$NotificationsToolResultCopyWithImpl<$Res, NotificationsToolResult>;
  @useResult
  $Res call(
      {List<NotificationResultItem> notifications,
      int total,
      @JsonKey(name: 'unread_count') int unreadCount});
}

/// @nodoc
class _$NotificationsToolResultCopyWithImpl<$Res,
        $Val extends NotificationsToolResult>
    implements $NotificationsToolResultCopyWith<$Res> {
  _$NotificationsToolResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? total = null,
    Object? unreadCount = null,
  }) {
    return _then(_value.copyWith(
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsToolResultImplCopyWith<$Res>
    implements $NotificationsToolResultCopyWith<$Res> {
  factory _$$NotificationsToolResultImplCopyWith(
          _$NotificationsToolResultImpl value,
          $Res Function(_$NotificationsToolResultImpl) then) =
      __$$NotificationsToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NotificationResultItem> notifications,
      int total,
      @JsonKey(name: 'unread_count') int unreadCount});
}

/// @nodoc
class __$$NotificationsToolResultImplCopyWithImpl<$Res>
    extends _$NotificationsToolResultCopyWithImpl<$Res,
        _$NotificationsToolResultImpl>
    implements _$$NotificationsToolResultImplCopyWith<$Res> {
  __$$NotificationsToolResultImplCopyWithImpl(
      _$NotificationsToolResultImpl _value,
      $Res Function(_$NotificationsToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? total = null,
    Object? unreadCount = null,
  }) {
    return _then(_$NotificationsToolResultImpl(
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationResultItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationsToolResultImpl implements _NotificationsToolResult {
  const _$NotificationsToolResultImpl(
      {required final List<NotificationResultItem> notifications,
      required this.total,
      @JsonKey(name: 'unread_count') this.unreadCount = 0})
      : _notifications = notifications;

  factory _$NotificationsToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationsToolResultImplFromJson(json);

  final List<NotificationResultItem> _notifications;
  @override
  List<NotificationResultItem> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final int total;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;

  @override
  String toString() {
    return 'NotificationsToolResult(notifications: $notifications, total: $total, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsToolResultImpl &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_notifications), total, unreadCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsToolResultImplCopyWith<_$NotificationsToolResultImpl>
      get copyWith => __$$NotificationsToolResultImplCopyWithImpl<
          _$NotificationsToolResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationsToolResultImplToJson(
      this,
    );
  }
}

abstract class _NotificationsToolResult implements NotificationsToolResult {
  const factory _NotificationsToolResult(
          {required final List<NotificationResultItem> notifications,
          required final int total,
          @JsonKey(name: 'unread_count') final int unreadCount}) =
      _$NotificationsToolResultImpl;

  factory _NotificationsToolResult.fromJson(Map<String, dynamic> json) =
      _$NotificationsToolResultImpl.fromJson;

  @override
  List<NotificationResultItem> get notifications;
  @override
  int get total;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsToolResultImplCopyWith<_$NotificationsToolResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationResultItem _$NotificationResultItemFromJson(
    Map<String, dynamic> json) {
  return _NotificationResultItem.fromJson(json);
}

/// @nodoc
mixin _$NotificationResultItem {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationResultItemCopyWith<NotificationResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationResultItemCopyWith<$Res> {
  factory $NotificationResultItemCopyWith(NotificationResultItem value,
          $Res Function(NotificationResultItem) then) =
      _$NotificationResultItemCopyWithImpl<$Res, NotificationResultItem>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String? body,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') String createdAt,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$NotificationResultItemCopyWithImpl<$Res,
        $Val extends NotificationResultItem>
    implements $NotificationResultItemCopyWith<$Res> {
  _$NotificationResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationResultItemImplCopyWith<$Res>
    implements $NotificationResultItemCopyWith<$Res> {
  factory _$$NotificationResultItemImplCopyWith(
          _$NotificationResultItemImpl value,
          $Res Function(_$NotificationResultItemImpl) then) =
      __$$NotificationResultItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String? body,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') String createdAt,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$NotificationResultItemImplCopyWithImpl<$Res>
    extends _$NotificationResultItemCopyWithImpl<$Res,
        _$NotificationResultItemImpl>
    implements _$$NotificationResultItemImplCopyWith<$Res> {
  __$$NotificationResultItemImplCopyWithImpl(
      _$NotificationResultItemImpl _value,
      $Res Function(_$NotificationResultItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_$NotificationResultItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationResultItemImpl implements _NotificationResultItem {
  const _$NotificationResultItemImpl(
      {required this.id,
      required this.type,
      required this.title,
      this.body,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'created_at') required this.createdAt,
      final Map<String, dynamic>? data})
      : _data = data;

  factory _$NotificationResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationResultItemImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String title;
  @override
  final String? body;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NotificationResultItem(id: $id, type: $type, title: $title, body: $body, isRead: $isRead, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationResultItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, title, body, isRead,
      createdAt, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationResultItemImplCopyWith<_$NotificationResultItemImpl>
      get copyWith => __$$NotificationResultItemImplCopyWithImpl<
          _$NotificationResultItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationResultItemImplToJson(
      this,
    );
  }
}

abstract class _NotificationResultItem implements NotificationResultItem {
  const factory _NotificationResultItem(
      {required final String id,
      required final String type,
      required final String title,
      final String? body,
      @JsonKey(name: 'is_read') final bool isRead,
      @JsonKey(name: 'created_at') required final String createdAt,
      final Map<String, dynamic>? data}) = _$NotificationResultItemImpl;

  factory _NotificationResultItem.fromJson(Map<String, dynamic> json) =
      _$NotificationResultItemImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get title;
  @override
  String? get body;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$$NotificationResultItemImplCopyWith<_$NotificationResultItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingCreatedData _$BookingCreatedDataFromJson(Map<String, dynamic> json) {
  return _BookingCreatedData.fromJson(json);
}

/// @nodoc
mixin _$BookingCreatedData {
  @JsonKey(name: 'booking_id')
  int get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_uuid')
  String get bookingUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingCreatedDataCopyWith<BookingCreatedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCreatedDataCopyWith<$Res> {
  factory $BookingCreatedDataCopyWith(
          BookingCreatedData value, $Res Function(BookingCreatedData) then) =
      _$BookingCreatedDataCopyWithImpl<$Res, BookingCreatedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$BookingCreatedDataCopyWithImpl<$Res, $Val extends BookingCreatedData>
    implements $BookingCreatedDataCopyWith<$Res> {
  _$BookingCreatedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookingUuid = null,
    Object? eventId = null,
    Object? totalAmount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      bookingUuid: null == bookingUuid
          ? _value.bookingUuid
          : bookingUuid // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingCreatedDataImplCopyWith<$Res>
    implements $BookingCreatedDataCopyWith<$Res> {
  factory _$$BookingCreatedDataImplCopyWith(_$BookingCreatedDataImpl value,
          $Res Function(_$BookingCreatedDataImpl) then) =
      __$$BookingCreatedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$BookingCreatedDataImplCopyWithImpl<$Res>
    extends _$BookingCreatedDataCopyWithImpl<$Res, _$BookingCreatedDataImpl>
    implements _$$BookingCreatedDataImplCopyWith<$Res> {
  __$$BookingCreatedDataImplCopyWithImpl(_$BookingCreatedDataImpl _value,
      $Res Function(_$BookingCreatedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookingUuid = null,
    Object? eventId = null,
    Object? totalAmount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$BookingCreatedDataImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      bookingUuid: null == bookingUuid
          ? _value.bookingUuid
          : bookingUuid // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$BookingCreatedDataImpl implements _BookingCreatedData {
  const _$BookingCreatedDataImpl(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'booking_uuid') required this.bookingUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$BookingCreatedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingCreatedDataImplFromJson(json);

  @override
  @JsonKey(name: 'booking_id')
  final int bookingId;
  @override
  @JsonKey(name: 'booking_uuid')
  final String bookingUuid;
  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BookingCreatedData(bookingId: $bookingId, bookingUuid: $bookingUuid, eventId: $eventId, totalAmount: $totalAmount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingCreatedDataImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookingUuid, bookingUuid) ||
                other.bookingUuid == bookingUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, bookingId, bookingUuid, eventId, totalAmount, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingCreatedDataImplCopyWith<_$BookingCreatedDataImpl> get copyWith =>
      __$$BookingCreatedDataImplCopyWithImpl<_$BookingCreatedDataImpl>(
          this, _$identity);
}

abstract class _BookingCreatedData implements BookingCreatedData {
  const factory _BookingCreatedData(
          {@JsonKey(name: 'booking_id') required final int bookingId,
          @JsonKey(name: 'booking_uuid') required final String bookingUuid,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'total_amount') required final int totalAmount,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$BookingCreatedDataImpl;

  factory _BookingCreatedData.fromJson(Map<String, dynamic> json) =
      _$BookingCreatedDataImpl.fromJson;

  @override
  @JsonKey(name: 'booking_id')
  int get bookingId;
  @override
  @JsonKey(name: 'booking_uuid')
  String get bookingUuid;
  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingCreatedDataImplCopyWith<_$BookingCreatedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingCreatedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  BookingCreatedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingCreatedNotificationCopyWith<BookingCreatedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCreatedNotificationCopyWith<$Res> {
  factory $BookingCreatedNotificationCopyWith(BookingCreatedNotification value,
          $Res Function(BookingCreatedNotification) then) =
      _$BookingCreatedNotificationCopyWithImpl<$Res,
          BookingCreatedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingCreatedData data,
      DateTime? receivedAt});

  $BookingCreatedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$BookingCreatedNotificationCopyWithImpl<$Res,
        $Val extends BookingCreatedNotification>
    implements $BookingCreatedNotificationCopyWith<$Res> {
  _$BookingCreatedNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as BookingCreatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingCreatedDataCopyWith<$Res> get data {
    return $BookingCreatedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingCreatedNotificationImplCopyWith<$Res>
    implements $BookingCreatedNotificationCopyWith<$Res> {
  factory _$$BookingCreatedNotificationImplCopyWith(
          _$BookingCreatedNotificationImpl value,
          $Res Function(_$BookingCreatedNotificationImpl) then) =
      __$$BookingCreatedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingCreatedData data,
      DateTime? receivedAt});

  @override
  $BookingCreatedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$BookingCreatedNotificationImplCopyWithImpl<$Res>
    extends _$BookingCreatedNotificationCopyWithImpl<$Res,
        _$BookingCreatedNotificationImpl>
    implements _$$BookingCreatedNotificationImplCopyWith<$Res> {
  __$$BookingCreatedNotificationImplCopyWithImpl(
      _$BookingCreatedNotificationImpl _value,
      $Res Function(_$BookingCreatedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$BookingCreatedNotificationImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as BookingCreatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BookingCreatedNotificationImpl implements _BookingCreatedNotification {
  const _$BookingCreatedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final BookingCreatedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'BookingCreatedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingCreatedNotificationImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, event, channel, data, receivedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingCreatedNotificationImplCopyWith<_$BookingCreatedNotificationImpl>
      get copyWith => __$$BookingCreatedNotificationImplCopyWithImpl<
          _$BookingCreatedNotificationImpl>(this, _$identity);
}

abstract class _BookingCreatedNotification
    implements BookingCreatedNotification {
  const factory _BookingCreatedNotification(
      {required final String event,
      final String? channel,
      required final BookingCreatedData data,
      final DateTime? receivedAt}) = _$BookingCreatedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  BookingCreatedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingCreatedNotificationImplCopyWith<_$BookingCreatedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

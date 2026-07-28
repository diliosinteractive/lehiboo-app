// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_confirmed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingConfirmedData _$BookingConfirmedDataFromJson(Map<String, dynamic> json) {
  return _BookingConfirmedData.fromJson(json);
}

/// @nodoc
mixin _$BookingConfirmedData {
  @JsonKey(name: 'booking_id')
  int get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_uuid')
  String get bookingUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingConfirmedDataCopyWith<BookingConfirmedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingConfirmedDataCopyWith<$Res> {
  factory $BookingConfirmedDataCopyWith(BookingConfirmedData value,
          $Res Function(BookingConfirmedData) then) =
      _$BookingConfirmedDataCopyWithImpl<$Res, BookingConfirmedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'confirmed_at') DateTime? confirmedAt});
}

/// @nodoc
class _$BookingConfirmedDataCopyWithImpl<$Res,
        $Val extends BookingConfirmedData>
    implements $BookingConfirmedDataCopyWith<$Res> {
  _$BookingConfirmedDataCopyWithImpl(this._value, this._then);

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
    Object? confirmedAt = freezed,
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
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingConfirmedDataImplCopyWith<$Res>
    implements $BookingConfirmedDataCopyWith<$Res> {
  factory _$$BookingConfirmedDataImplCopyWith(_$BookingConfirmedDataImpl value,
          $Res Function(_$BookingConfirmedDataImpl) then) =
      __$$BookingConfirmedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'confirmed_at') DateTime? confirmedAt});
}

/// @nodoc
class __$$BookingConfirmedDataImplCopyWithImpl<$Res>
    extends _$BookingConfirmedDataCopyWithImpl<$Res, _$BookingConfirmedDataImpl>
    implements _$$BookingConfirmedDataImplCopyWith<$Res> {
  __$$BookingConfirmedDataImplCopyWithImpl(_$BookingConfirmedDataImpl _value,
      $Res Function(_$BookingConfirmedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookingUuid = null,
    Object? eventId = null,
    Object? totalAmount = null,
    Object? confirmedAt = freezed,
  }) {
    return _then(_$BookingConfirmedDataImpl(
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
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$BookingConfirmedDataImpl implements _BookingConfirmedData {
  const _$BookingConfirmedDataImpl(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'booking_uuid') required this.bookingUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'confirmed_at') this.confirmedAt});

  factory _$BookingConfirmedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingConfirmedDataImplFromJson(json);

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
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;

  @override
  String toString() {
    return 'BookingConfirmedData(bookingId: $bookingId, bookingUuid: $bookingUuid, eventId: $eventId, totalAmount: $totalAmount, confirmedAt: $confirmedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingConfirmedDataImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookingUuid, bookingUuid) ||
                other.bookingUuid == bookingUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, bookingId, bookingUuid, eventId, totalAmount, confirmedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingConfirmedDataImplCopyWith<_$BookingConfirmedDataImpl>
      get copyWith =>
          __$$BookingConfirmedDataImplCopyWithImpl<_$BookingConfirmedDataImpl>(
              this, _$identity);
}

abstract class _BookingConfirmedData implements BookingConfirmedData {
  const factory _BookingConfirmedData(
          {@JsonKey(name: 'booking_id') required final int bookingId,
          @JsonKey(name: 'booking_uuid') required final String bookingUuid,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'total_amount') required final int totalAmount,
          @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt}) =
      _$BookingConfirmedDataImpl;

  factory _BookingConfirmedData.fromJson(Map<String, dynamic> json) =
      _$BookingConfirmedDataImpl.fromJson;

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
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingConfirmedDataImplCopyWith<_$BookingConfirmedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingConfirmedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  BookingConfirmedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingConfirmedNotificationCopyWith<BookingConfirmedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingConfirmedNotificationCopyWith<$Res> {
  factory $BookingConfirmedNotificationCopyWith(
          BookingConfirmedNotification value,
          $Res Function(BookingConfirmedNotification) then) =
      _$BookingConfirmedNotificationCopyWithImpl<$Res,
          BookingConfirmedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingConfirmedData data,
      DateTime? receivedAt});

  $BookingConfirmedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$BookingConfirmedNotificationCopyWithImpl<$Res,
        $Val extends BookingConfirmedNotification>
    implements $BookingConfirmedNotificationCopyWith<$Res> {
  _$BookingConfirmedNotificationCopyWithImpl(this._value, this._then);

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
              as BookingConfirmedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingConfirmedDataCopyWith<$Res> get data {
    return $BookingConfirmedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingConfirmedNotificationImplCopyWith<$Res>
    implements $BookingConfirmedNotificationCopyWith<$Res> {
  factory _$$BookingConfirmedNotificationImplCopyWith(
          _$BookingConfirmedNotificationImpl value,
          $Res Function(_$BookingConfirmedNotificationImpl) then) =
      __$$BookingConfirmedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingConfirmedData data,
      DateTime? receivedAt});

  @override
  $BookingConfirmedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$BookingConfirmedNotificationImplCopyWithImpl<$Res>
    extends _$BookingConfirmedNotificationCopyWithImpl<$Res,
        _$BookingConfirmedNotificationImpl>
    implements _$$BookingConfirmedNotificationImplCopyWith<$Res> {
  __$$BookingConfirmedNotificationImplCopyWithImpl(
      _$BookingConfirmedNotificationImpl _value,
      $Res Function(_$BookingConfirmedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$BookingConfirmedNotificationImpl(
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
              as BookingConfirmedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BookingConfirmedNotificationImpl
    implements _BookingConfirmedNotification {
  const _$BookingConfirmedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final BookingConfirmedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'BookingConfirmedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingConfirmedNotificationImpl &&
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
  _$$BookingConfirmedNotificationImplCopyWith<
          _$BookingConfirmedNotificationImpl>
      get copyWith => __$$BookingConfirmedNotificationImplCopyWithImpl<
          _$BookingConfirmedNotificationImpl>(this, _$identity);
}

abstract class _BookingConfirmedNotification
    implements BookingConfirmedNotification {
  const factory _BookingConfirmedNotification(
      {required final String event,
      final String? channel,
      required final BookingConfirmedData data,
      final DateTime? receivedAt}) = _$BookingConfirmedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  BookingConfirmedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingConfirmedNotificationImplCopyWith<
          _$BookingConfirmedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

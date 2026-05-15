// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_cancelled.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingCancelledData _$BookingCancelledDataFromJson(Map<String, dynamic> json) {
  return _BookingCancelledData.fromJson(json);
}

/// @nodoc
mixin _$BookingCancelledData {
  @JsonKey(name: 'booking_id')
  int get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_uuid')
  String get bookingUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingCancelledDataCopyWith<BookingCancelledData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCancelledDataCopyWith<$Res> {
  factory $BookingCancelledDataCopyWith(BookingCancelledData value,
          $Res Function(BookingCancelledData) then) =
      _$BookingCancelledDataCopyWithImpl<$Res, BookingCancelledData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'event_id') int eventId,
      String? reason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt});
}

/// @nodoc
class _$BookingCancelledDataCopyWithImpl<$Res,
        $Val extends BookingCancelledData>
    implements $BookingCancelledDataCopyWith<$Res> {
  _$BookingCancelledDataCopyWithImpl(this._value, this._then);

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
    Object? reason = freezed,
    Object? cancelledAt = freezed,
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
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingCancelledDataImplCopyWith<$Res>
    implements $BookingCancelledDataCopyWith<$Res> {
  factory _$$BookingCancelledDataImplCopyWith(_$BookingCancelledDataImpl value,
          $Res Function(_$BookingCancelledDataImpl) then) =
      __$$BookingCancelledDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'event_id') int eventId,
      String? reason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt});
}

/// @nodoc
class __$$BookingCancelledDataImplCopyWithImpl<$Res>
    extends _$BookingCancelledDataCopyWithImpl<$Res, _$BookingCancelledDataImpl>
    implements _$$BookingCancelledDataImplCopyWith<$Res> {
  __$$BookingCancelledDataImplCopyWithImpl(_$BookingCancelledDataImpl _value,
      $Res Function(_$BookingCancelledDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookingUuid = null,
    Object? eventId = null,
    Object? reason = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_$BookingCancelledDataImpl(
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
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$BookingCancelledDataImpl implements _BookingCancelledData {
  const _$BookingCancelledDataImpl(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'booking_uuid') required this.bookingUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      this.reason,
      @JsonKey(name: 'cancelled_at') this.cancelledAt});

  factory _$BookingCancelledDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingCancelledDataImplFromJson(json);

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
  final String? reason;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;

  @override
  String toString() {
    return 'BookingCancelledData(bookingId: $bookingId, bookingUuid: $bookingUuid, eventId: $eventId, reason: $reason, cancelledAt: $cancelledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingCancelledDataImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookingUuid, bookingUuid) ||
                other.bookingUuid == bookingUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, bookingId, bookingUuid, eventId, reason, cancelledAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingCancelledDataImplCopyWith<_$BookingCancelledDataImpl>
      get copyWith =>
          __$$BookingCancelledDataImplCopyWithImpl<_$BookingCancelledDataImpl>(
              this, _$identity);
}

abstract class _BookingCancelledData implements BookingCancelledData {
  const factory _BookingCancelledData(
          {@JsonKey(name: 'booking_id') required final int bookingId,
          @JsonKey(name: 'booking_uuid') required final String bookingUuid,
          @JsonKey(name: 'event_id') required final int eventId,
          final String? reason,
          @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt}) =
      _$BookingCancelledDataImpl;

  factory _BookingCancelledData.fromJson(Map<String, dynamic> json) =
      _$BookingCancelledDataImpl.fromJson;

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
  String? get reason;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingCancelledDataImplCopyWith<_$BookingCancelledDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingCancelledNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  BookingCancelledData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingCancelledNotificationCopyWith<BookingCancelledNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCancelledNotificationCopyWith<$Res> {
  factory $BookingCancelledNotificationCopyWith(
          BookingCancelledNotification value,
          $Res Function(BookingCancelledNotification) then) =
      _$BookingCancelledNotificationCopyWithImpl<$Res,
          BookingCancelledNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingCancelledData data,
      DateTime? receivedAt});

  $BookingCancelledDataCopyWith<$Res> get data;
}

/// @nodoc
class _$BookingCancelledNotificationCopyWithImpl<$Res,
        $Val extends BookingCancelledNotification>
    implements $BookingCancelledNotificationCopyWith<$Res> {
  _$BookingCancelledNotificationCopyWithImpl(this._value, this._then);

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
              as BookingCancelledData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingCancelledDataCopyWith<$Res> get data {
    return $BookingCancelledDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingCancelledNotificationImplCopyWith<$Res>
    implements $BookingCancelledNotificationCopyWith<$Res> {
  factory _$$BookingCancelledNotificationImplCopyWith(
          _$BookingCancelledNotificationImpl value,
          $Res Function(_$BookingCancelledNotificationImpl) then) =
      __$$BookingCancelledNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingCancelledData data,
      DateTime? receivedAt});

  @override
  $BookingCancelledDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$BookingCancelledNotificationImplCopyWithImpl<$Res>
    extends _$BookingCancelledNotificationCopyWithImpl<$Res,
        _$BookingCancelledNotificationImpl>
    implements _$$BookingCancelledNotificationImplCopyWith<$Res> {
  __$$BookingCancelledNotificationImplCopyWithImpl(
      _$BookingCancelledNotificationImpl _value,
      $Res Function(_$BookingCancelledNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$BookingCancelledNotificationImpl(
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
              as BookingCancelledData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BookingCancelledNotificationImpl
    implements _BookingCancelledNotification {
  const _$BookingCancelledNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final BookingCancelledData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'BookingCancelledNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingCancelledNotificationImpl &&
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
  _$$BookingCancelledNotificationImplCopyWith<
          _$BookingCancelledNotificationImpl>
      get copyWith => __$$BookingCancelledNotificationImplCopyWithImpl<
          _$BookingCancelledNotificationImpl>(this, _$identity);
}

abstract class _BookingCancelledNotification
    implements BookingCancelledNotification {
  const factory _BookingCancelledNotification(
      {required final String event,
      final String? channel,
      required final BookingCancelledData data,
      final DateTime? receivedAt}) = _$BookingCancelledNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  BookingCancelledData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingCancelledNotificationImplCopyWith<
          _$BookingCancelledNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

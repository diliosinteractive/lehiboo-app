// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_refunded.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingRefundedData _$BookingRefundedDataFromJson(Map<String, dynamic> json) {
  return _BookingRefundedData.fromJson(json);
}

/// @nodoc
mixin _$BookingRefundedData {
  @JsonKey(name: 'booking_id')
  int get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_uuid')
  String get bookingUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'refund_amount')
  int get refundAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_partial')
  bool get isPartial => throw _privateConstructorUsedError;
  @JsonKey(name: 'refunded_at')
  DateTime? get refundedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingRefundedDataCopyWith<BookingRefundedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingRefundedDataCopyWith<$Res> {
  factory $BookingRefundedDataCopyWith(
          BookingRefundedData value, $Res Function(BookingRefundedData) then) =
      _$BookingRefundedDataCopyWithImpl<$Res, BookingRefundedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'refund_amount') int refundAmount,
      @JsonKey(name: 'is_partial') bool isPartial,
      @JsonKey(name: 'refunded_at') DateTime? refundedAt});
}

/// @nodoc
class _$BookingRefundedDataCopyWithImpl<$Res, $Val extends BookingRefundedData>
    implements $BookingRefundedDataCopyWith<$Res> {
  _$BookingRefundedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookingUuid = null,
    Object? refundAmount = null,
    Object? isPartial = null,
    Object? refundedAt = freezed,
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
      refundAmount: null == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as int,
      isPartial: null == isPartial
          ? _value.isPartial
          : isPartial // ignore: cast_nullable_to_non_nullable
              as bool,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingRefundedDataImplCopyWith<$Res>
    implements $BookingRefundedDataCopyWith<$Res> {
  factory _$$BookingRefundedDataImplCopyWith(_$BookingRefundedDataImpl value,
          $Res Function(_$BookingRefundedDataImpl) then) =
      __$$BookingRefundedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'booking_uuid') String bookingUuid,
      @JsonKey(name: 'refund_amount') int refundAmount,
      @JsonKey(name: 'is_partial') bool isPartial,
      @JsonKey(name: 'refunded_at') DateTime? refundedAt});
}

/// @nodoc
class __$$BookingRefundedDataImplCopyWithImpl<$Res>
    extends _$BookingRefundedDataCopyWithImpl<$Res, _$BookingRefundedDataImpl>
    implements _$$BookingRefundedDataImplCopyWith<$Res> {
  __$$BookingRefundedDataImplCopyWithImpl(_$BookingRefundedDataImpl _value,
      $Res Function(_$BookingRefundedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookingUuid = null,
    Object? refundAmount = null,
    Object? isPartial = null,
    Object? refundedAt = freezed,
  }) {
    return _then(_$BookingRefundedDataImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      bookingUuid: null == bookingUuid
          ? _value.bookingUuid
          : bookingUuid // ignore: cast_nullable_to_non_nullable
              as String,
      refundAmount: null == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as int,
      isPartial: null == isPartial
          ? _value.isPartial
          : isPartial // ignore: cast_nullable_to_non_nullable
              as bool,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$BookingRefundedDataImpl implements _BookingRefundedData {
  const _$BookingRefundedDataImpl(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'booking_uuid') required this.bookingUuid,
      @JsonKey(name: 'refund_amount') required this.refundAmount,
      @JsonKey(name: 'is_partial') this.isPartial = false,
      @JsonKey(name: 'refunded_at') this.refundedAt});

  factory _$BookingRefundedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingRefundedDataImplFromJson(json);

  @override
  @JsonKey(name: 'booking_id')
  final int bookingId;
  @override
  @JsonKey(name: 'booking_uuid')
  final String bookingUuid;
  @override
  @JsonKey(name: 'refund_amount')
  final int refundAmount;
  @override
  @JsonKey(name: 'is_partial')
  final bool isPartial;
  @override
  @JsonKey(name: 'refunded_at')
  final DateTime? refundedAt;

  @override
  String toString() {
    return 'BookingRefundedData(bookingId: $bookingId, bookingUuid: $bookingUuid, refundAmount: $refundAmount, isPartial: $isPartial, refundedAt: $refundedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingRefundedDataImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookingUuid, bookingUuid) ||
                other.bookingUuid == bookingUuid) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.isPartial, isPartial) ||
                other.isPartial == isPartial) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, bookingId, bookingUuid, refundAmount, isPartial, refundedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingRefundedDataImplCopyWith<_$BookingRefundedDataImpl> get copyWith =>
      __$$BookingRefundedDataImplCopyWithImpl<_$BookingRefundedDataImpl>(
          this, _$identity);
}

abstract class _BookingRefundedData implements BookingRefundedData {
  const factory _BookingRefundedData(
          {@JsonKey(name: 'booking_id') required final int bookingId,
          @JsonKey(name: 'booking_uuid') required final String bookingUuid,
          @JsonKey(name: 'refund_amount') required final int refundAmount,
          @JsonKey(name: 'is_partial') final bool isPartial,
          @JsonKey(name: 'refunded_at') final DateTime? refundedAt}) =
      _$BookingRefundedDataImpl;

  factory _BookingRefundedData.fromJson(Map<String, dynamic> json) =
      _$BookingRefundedDataImpl.fromJson;

  @override
  @JsonKey(name: 'booking_id')
  int get bookingId;
  @override
  @JsonKey(name: 'booking_uuid')
  String get bookingUuid;
  @override
  @JsonKey(name: 'refund_amount')
  int get refundAmount;
  @override
  @JsonKey(name: 'is_partial')
  bool get isPartial;
  @override
  @JsonKey(name: 'refunded_at')
  DateTime? get refundedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingRefundedDataImplCopyWith<_$BookingRefundedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingRefundedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  BookingRefundedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingRefundedNotificationCopyWith<BookingRefundedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingRefundedNotificationCopyWith<$Res> {
  factory $BookingRefundedNotificationCopyWith(
          BookingRefundedNotification value,
          $Res Function(BookingRefundedNotification) then) =
      _$BookingRefundedNotificationCopyWithImpl<$Res,
          BookingRefundedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingRefundedData data,
      DateTime? receivedAt});

  $BookingRefundedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$BookingRefundedNotificationCopyWithImpl<$Res,
        $Val extends BookingRefundedNotification>
    implements $BookingRefundedNotificationCopyWith<$Res> {
  _$BookingRefundedNotificationCopyWithImpl(this._value, this._then);

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
              as BookingRefundedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingRefundedDataCopyWith<$Res> get data {
    return $BookingRefundedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingRefundedNotificationImplCopyWith<$Res>
    implements $BookingRefundedNotificationCopyWith<$Res> {
  factory _$$BookingRefundedNotificationImplCopyWith(
          _$BookingRefundedNotificationImpl value,
          $Res Function(_$BookingRefundedNotificationImpl) then) =
      __$$BookingRefundedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      BookingRefundedData data,
      DateTime? receivedAt});

  @override
  $BookingRefundedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$BookingRefundedNotificationImplCopyWithImpl<$Res>
    extends _$BookingRefundedNotificationCopyWithImpl<$Res,
        _$BookingRefundedNotificationImpl>
    implements _$$BookingRefundedNotificationImplCopyWith<$Res> {
  __$$BookingRefundedNotificationImplCopyWithImpl(
      _$BookingRefundedNotificationImpl _value,
      $Res Function(_$BookingRefundedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$BookingRefundedNotificationImpl(
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
              as BookingRefundedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BookingRefundedNotificationImpl
    implements _BookingRefundedNotification {
  const _$BookingRefundedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final BookingRefundedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'BookingRefundedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingRefundedNotificationImpl &&
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
  _$$BookingRefundedNotificationImplCopyWith<_$BookingRefundedNotificationImpl>
      get copyWith => __$$BookingRefundedNotificationImplCopyWithImpl<
          _$BookingRefundedNotificationImpl>(this, _$identity);
}

abstract class _BookingRefundedNotification
    implements BookingRefundedNotification {
  const factory _BookingRefundedNotification(
      {required final String event,
      final String? channel,
      required final BookingRefundedData data,
      final DateTime? receivedAt}) = _$BookingRefundedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  BookingRefundedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingRefundedNotificationImplCopyWith<_$BookingRefundedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_cancelled.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayoutCancelledData _$PayoutCancelledDataFromJson(Map<String, dynamic> json) {
  return _PayoutCancelledData.fromJson(json);
}

/// @nodoc
mixin _$PayoutCancelledData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payout_reference')
  String? get payoutReference => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayoutCancelledDataCopyWith<PayoutCancelledData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutCancelledDataCopyWith<$Res> {
  factory $PayoutCancelledDataCopyWith(
          PayoutCancelledData value, $Res Function(PayoutCancelledData) then) =
      _$PayoutCancelledDataCopyWithImpl<$Res, PayoutCancelledData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      int amount,
      @JsonKey(name: 'payout_reference') String? payoutReference,
      String? reason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt});
}

/// @nodoc
class _$PayoutCancelledDataCopyWithImpl<$Res, $Val extends PayoutCancelledData>
    implements $PayoutCancelledDataCopyWith<$Res> {
  _$PayoutCancelledDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? amount = null,
    Object? payoutReference = freezed,
    Object? reason = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      payoutReference: freezed == payoutReference
          ? _value.payoutReference
          : payoutReference // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$PayoutCancelledDataImplCopyWith<$Res>
    implements $PayoutCancelledDataCopyWith<$Res> {
  factory _$$PayoutCancelledDataImplCopyWith(_$PayoutCancelledDataImpl value,
          $Res Function(_$PayoutCancelledDataImpl) then) =
      __$$PayoutCancelledDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      int amount,
      @JsonKey(name: 'payout_reference') String? payoutReference,
      String? reason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt});
}

/// @nodoc
class __$$PayoutCancelledDataImplCopyWithImpl<$Res>
    extends _$PayoutCancelledDataCopyWithImpl<$Res, _$PayoutCancelledDataImpl>
    implements _$$PayoutCancelledDataImplCopyWith<$Res> {
  __$$PayoutCancelledDataImplCopyWithImpl(_$PayoutCancelledDataImpl _value,
      $Res Function(_$PayoutCancelledDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? amount = null,
    Object? payoutReference = freezed,
    Object? reason = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_$PayoutCancelledDataImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      payoutReference: freezed == payoutReference
          ? _value.payoutReference
          : payoutReference // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$PayoutCancelledDataImpl implements _PayoutCancelledData {
  const _$PayoutCancelledDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      required this.amount,
      @JsonKey(name: 'payout_reference') this.payoutReference,
      this.reason,
      @JsonKey(name: 'cancelled_at') this.cancelledAt});

  factory _$PayoutCancelledDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayoutCancelledDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  final int amount;
  @override
  @JsonKey(name: 'payout_reference')
  final String? payoutReference;
  @override
  final String? reason;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;

  @override
  String toString() {
    return 'PayoutCancelledData(organizationId: $organizationId, amount: $amount, payoutReference: $payoutReference, reason: $reason, cancelledAt: $cancelledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutCancelledDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.payoutReference, payoutReference) ||
                other.payoutReference == payoutReference) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, organizationId, amount,
      payoutReference, reason, cancelledAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayoutCancelledDataImplCopyWith<_$PayoutCancelledDataImpl> get copyWith =>
      __$$PayoutCancelledDataImplCopyWithImpl<_$PayoutCancelledDataImpl>(
          this, _$identity);
}

abstract class _PayoutCancelledData implements PayoutCancelledData {
  const factory _PayoutCancelledData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          required final int amount,
          @JsonKey(name: 'payout_reference') final String? payoutReference,
          final String? reason,
          @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt}) =
      _$PayoutCancelledDataImpl;

  factory _PayoutCancelledData.fromJson(Map<String, dynamic> json) =
      _$PayoutCancelledDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  int get amount;
  @override
  @JsonKey(name: 'payout_reference')
  String? get payoutReference;
  @override
  String? get reason;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(ignore: true)
  _$$PayoutCancelledDataImplCopyWith<_$PayoutCancelledDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PayoutCancelledNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  PayoutCancelledData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayoutCancelledNotificationCopyWith<PayoutCancelledNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutCancelledNotificationCopyWith<$Res> {
  factory $PayoutCancelledNotificationCopyWith(
          PayoutCancelledNotification value,
          $Res Function(PayoutCancelledNotification) then) =
      _$PayoutCancelledNotificationCopyWithImpl<$Res,
          PayoutCancelledNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      PayoutCancelledData data,
      DateTime? receivedAt});

  $PayoutCancelledDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PayoutCancelledNotificationCopyWithImpl<$Res,
        $Val extends PayoutCancelledNotification>
    implements $PayoutCancelledNotificationCopyWith<$Res> {
  _$PayoutCancelledNotificationCopyWithImpl(this._value, this._then);

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
              as PayoutCancelledData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PayoutCancelledDataCopyWith<$Res> get data {
    return $PayoutCancelledDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PayoutCancelledNotificationImplCopyWith<$Res>
    implements $PayoutCancelledNotificationCopyWith<$Res> {
  factory _$$PayoutCancelledNotificationImplCopyWith(
          _$PayoutCancelledNotificationImpl value,
          $Res Function(_$PayoutCancelledNotificationImpl) then) =
      __$$PayoutCancelledNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      PayoutCancelledData data,
      DateTime? receivedAt});

  @override
  $PayoutCancelledDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PayoutCancelledNotificationImplCopyWithImpl<$Res>
    extends _$PayoutCancelledNotificationCopyWithImpl<$Res,
        _$PayoutCancelledNotificationImpl>
    implements _$$PayoutCancelledNotificationImplCopyWith<$Res> {
  __$$PayoutCancelledNotificationImplCopyWithImpl(
      _$PayoutCancelledNotificationImpl _value,
      $Res Function(_$PayoutCancelledNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$PayoutCancelledNotificationImpl(
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
              as PayoutCancelledData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$PayoutCancelledNotificationImpl
    implements _PayoutCancelledNotification {
  const _$PayoutCancelledNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final PayoutCancelledData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'PayoutCancelledNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutCancelledNotificationImpl &&
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
  _$$PayoutCancelledNotificationImplCopyWith<_$PayoutCancelledNotificationImpl>
      get copyWith => __$$PayoutCancelledNotificationImplCopyWithImpl<
          _$PayoutCancelledNotificationImpl>(this, _$identity);
}

abstract class _PayoutCancelledNotification
    implements PayoutCancelledNotification {
  const factory _PayoutCancelledNotification(
      {required final String event,
      final String? channel,
      required final PayoutCancelledData data,
      final DateTime? receivedAt}) = _$PayoutCancelledNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  PayoutCancelledData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$PayoutCancelledNotificationImplCopyWith<_$PayoutCancelledNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

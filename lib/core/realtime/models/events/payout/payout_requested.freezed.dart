// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_requested.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayoutRequestedData _$PayoutRequestedDataFromJson(Map<String, dynamic> json) {
  return _PayoutRequestedData.fromJson(json);
}

/// @nodoc
mixin _$PayoutRequestedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payout_reference')
  String? get payoutReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_at')
  DateTime? get requestedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayoutRequestedDataCopyWith<PayoutRequestedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutRequestedDataCopyWith<$Res> {
  factory $PayoutRequestedDataCopyWith(
          PayoutRequestedData value, $Res Function(PayoutRequestedData) then) =
      _$PayoutRequestedDataCopyWithImpl<$Res, PayoutRequestedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      int amount,
      @JsonKey(name: 'payout_reference') String? payoutReference,
      @JsonKey(name: 'requested_at') DateTime? requestedAt});
}

/// @nodoc
class _$PayoutRequestedDataCopyWithImpl<$Res, $Val extends PayoutRequestedData>
    implements $PayoutRequestedDataCopyWith<$Res> {
  _$PayoutRequestedDataCopyWithImpl(this._value, this._then);

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
    Object? requestedAt = freezed,
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
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayoutRequestedDataImplCopyWith<$Res>
    implements $PayoutRequestedDataCopyWith<$Res> {
  factory _$$PayoutRequestedDataImplCopyWith(_$PayoutRequestedDataImpl value,
          $Res Function(_$PayoutRequestedDataImpl) then) =
      __$$PayoutRequestedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      int amount,
      @JsonKey(name: 'payout_reference') String? payoutReference,
      @JsonKey(name: 'requested_at') DateTime? requestedAt});
}

/// @nodoc
class __$$PayoutRequestedDataImplCopyWithImpl<$Res>
    extends _$PayoutRequestedDataCopyWithImpl<$Res, _$PayoutRequestedDataImpl>
    implements _$$PayoutRequestedDataImplCopyWith<$Res> {
  __$$PayoutRequestedDataImplCopyWithImpl(_$PayoutRequestedDataImpl _value,
      $Res Function(_$PayoutRequestedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? amount = null,
    Object? payoutReference = freezed,
    Object? requestedAt = freezed,
  }) {
    return _then(_$PayoutRequestedDataImpl(
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
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PayoutRequestedDataImpl implements _PayoutRequestedData {
  const _$PayoutRequestedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      required this.amount,
      @JsonKey(name: 'payout_reference') this.payoutReference,
      @JsonKey(name: 'requested_at') this.requestedAt});

  factory _$PayoutRequestedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayoutRequestedDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  final int amount;
  @override
  @JsonKey(name: 'payout_reference')
  final String? payoutReference;
  @override
  @JsonKey(name: 'requested_at')
  final DateTime? requestedAt;

  @override
  String toString() {
    return 'PayoutRequestedData(organizationId: $organizationId, amount: $amount, payoutReference: $payoutReference, requestedAt: $requestedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutRequestedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.payoutReference, payoutReference) ||
                other.payoutReference == payoutReference) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, organizationId, amount, payoutReference, requestedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayoutRequestedDataImplCopyWith<_$PayoutRequestedDataImpl> get copyWith =>
      __$$PayoutRequestedDataImplCopyWithImpl<_$PayoutRequestedDataImpl>(
          this, _$identity);
}

abstract class _PayoutRequestedData implements PayoutRequestedData {
  const factory _PayoutRequestedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          required final int amount,
          @JsonKey(name: 'payout_reference') final String? payoutReference,
          @JsonKey(name: 'requested_at') final DateTime? requestedAt}) =
      _$PayoutRequestedDataImpl;

  factory _PayoutRequestedData.fromJson(Map<String, dynamic> json) =
      _$PayoutRequestedDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  int get amount;
  @override
  @JsonKey(name: 'payout_reference')
  String? get payoutReference;
  @override
  @JsonKey(name: 'requested_at')
  DateTime? get requestedAt;
  @override
  @JsonKey(ignore: true)
  _$$PayoutRequestedDataImplCopyWith<_$PayoutRequestedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PayoutRequestedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  PayoutRequestedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayoutRequestedNotificationCopyWith<PayoutRequestedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutRequestedNotificationCopyWith<$Res> {
  factory $PayoutRequestedNotificationCopyWith(
          PayoutRequestedNotification value,
          $Res Function(PayoutRequestedNotification) then) =
      _$PayoutRequestedNotificationCopyWithImpl<$Res,
          PayoutRequestedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      PayoutRequestedData data,
      DateTime? receivedAt});

  $PayoutRequestedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PayoutRequestedNotificationCopyWithImpl<$Res,
        $Val extends PayoutRequestedNotification>
    implements $PayoutRequestedNotificationCopyWith<$Res> {
  _$PayoutRequestedNotificationCopyWithImpl(this._value, this._then);

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
              as PayoutRequestedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PayoutRequestedDataCopyWith<$Res> get data {
    return $PayoutRequestedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PayoutRequestedNotificationImplCopyWith<$Res>
    implements $PayoutRequestedNotificationCopyWith<$Res> {
  factory _$$PayoutRequestedNotificationImplCopyWith(
          _$PayoutRequestedNotificationImpl value,
          $Res Function(_$PayoutRequestedNotificationImpl) then) =
      __$$PayoutRequestedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      PayoutRequestedData data,
      DateTime? receivedAt});

  @override
  $PayoutRequestedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PayoutRequestedNotificationImplCopyWithImpl<$Res>
    extends _$PayoutRequestedNotificationCopyWithImpl<$Res,
        _$PayoutRequestedNotificationImpl>
    implements _$$PayoutRequestedNotificationImplCopyWith<$Res> {
  __$$PayoutRequestedNotificationImplCopyWithImpl(
      _$PayoutRequestedNotificationImpl _value,
      $Res Function(_$PayoutRequestedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$PayoutRequestedNotificationImpl(
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
              as PayoutRequestedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$PayoutRequestedNotificationImpl
    implements _PayoutRequestedNotification {
  const _$PayoutRequestedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final PayoutRequestedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'PayoutRequestedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutRequestedNotificationImpl &&
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
  _$$PayoutRequestedNotificationImplCopyWith<_$PayoutRequestedNotificationImpl>
      get copyWith => __$$PayoutRequestedNotificationImplCopyWithImpl<
          _$PayoutRequestedNotificationImpl>(this, _$identity);
}

abstract class _PayoutRequestedNotification
    implements PayoutRequestedNotification {
  const factory _PayoutRequestedNotification(
      {required final String event,
      final String? channel,
      required final PayoutRequestedData data,
      final DateTime? receivedAt}) = _$PayoutRequestedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  PayoutRequestedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$PayoutRequestedNotificationImplCopyWith<_$PayoutRequestedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

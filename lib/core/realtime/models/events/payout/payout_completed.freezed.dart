// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_completed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayoutCompletedData _$PayoutCompletedDataFromJson(Map<String, dynamic> json) {
  return _PayoutCompletedData.fromJson(json);
}

/// @nodoc
mixin _$PayoutCompletedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payout_reference')
  String? get payoutReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayoutCompletedDataCopyWith<PayoutCompletedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutCompletedDataCopyWith<$Res> {
  factory $PayoutCompletedDataCopyWith(
          PayoutCompletedData value, $Res Function(PayoutCompletedData) then) =
      _$PayoutCompletedDataCopyWithImpl<$Res, PayoutCompletedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      int amount,
      @JsonKey(name: 'payout_reference') String? payoutReference,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class _$PayoutCompletedDataCopyWithImpl<$Res, $Val extends PayoutCompletedData>
    implements $PayoutCompletedDataCopyWith<$Res> {
  _$PayoutCompletedDataCopyWithImpl(this._value, this._then);

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
    Object? completedAt = freezed,
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
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayoutCompletedDataImplCopyWith<$Res>
    implements $PayoutCompletedDataCopyWith<$Res> {
  factory _$$PayoutCompletedDataImplCopyWith(_$PayoutCompletedDataImpl value,
          $Res Function(_$PayoutCompletedDataImpl) then) =
      __$$PayoutCompletedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      int amount,
      @JsonKey(name: 'payout_reference') String? payoutReference,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class __$$PayoutCompletedDataImplCopyWithImpl<$Res>
    extends _$PayoutCompletedDataCopyWithImpl<$Res, _$PayoutCompletedDataImpl>
    implements _$$PayoutCompletedDataImplCopyWith<$Res> {
  __$$PayoutCompletedDataImplCopyWithImpl(_$PayoutCompletedDataImpl _value,
      $Res Function(_$PayoutCompletedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? amount = null,
    Object? payoutReference = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$PayoutCompletedDataImpl(
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
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PayoutCompletedDataImpl implements _PayoutCompletedData {
  const _$PayoutCompletedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      required this.amount,
      @JsonKey(name: 'payout_reference') this.payoutReference,
      @JsonKey(name: 'completed_at') this.completedAt});

  factory _$PayoutCompletedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayoutCompletedDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  final int amount;
  @override
  @JsonKey(name: 'payout_reference')
  final String? payoutReference;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'PayoutCompletedData(organizationId: $organizationId, amount: $amount, payoutReference: $payoutReference, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutCompletedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.payoutReference, payoutReference) ||
                other.payoutReference == payoutReference) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, organizationId, amount, payoutReference, completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayoutCompletedDataImplCopyWith<_$PayoutCompletedDataImpl> get copyWith =>
      __$$PayoutCompletedDataImplCopyWithImpl<_$PayoutCompletedDataImpl>(
          this, _$identity);
}

abstract class _PayoutCompletedData implements PayoutCompletedData {
  const factory _PayoutCompletedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          required final int amount,
          @JsonKey(name: 'payout_reference') final String? payoutReference,
          @JsonKey(name: 'completed_at') final DateTime? completedAt}) =
      _$PayoutCompletedDataImpl;

  factory _PayoutCompletedData.fromJson(Map<String, dynamic> json) =
      _$PayoutCompletedDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  int get amount;
  @override
  @JsonKey(name: 'payout_reference')
  String? get payoutReference;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$PayoutCompletedDataImplCopyWith<_$PayoutCompletedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PayoutCompletedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  PayoutCompletedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayoutCompletedNotificationCopyWith<PayoutCompletedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutCompletedNotificationCopyWith<$Res> {
  factory $PayoutCompletedNotificationCopyWith(
          PayoutCompletedNotification value,
          $Res Function(PayoutCompletedNotification) then) =
      _$PayoutCompletedNotificationCopyWithImpl<$Res,
          PayoutCompletedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      PayoutCompletedData data,
      DateTime? receivedAt});

  $PayoutCompletedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PayoutCompletedNotificationCopyWithImpl<$Res,
        $Val extends PayoutCompletedNotification>
    implements $PayoutCompletedNotificationCopyWith<$Res> {
  _$PayoutCompletedNotificationCopyWithImpl(this._value, this._then);

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
              as PayoutCompletedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PayoutCompletedDataCopyWith<$Res> get data {
    return $PayoutCompletedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PayoutCompletedNotificationImplCopyWith<$Res>
    implements $PayoutCompletedNotificationCopyWith<$Res> {
  factory _$$PayoutCompletedNotificationImplCopyWith(
          _$PayoutCompletedNotificationImpl value,
          $Res Function(_$PayoutCompletedNotificationImpl) then) =
      __$$PayoutCompletedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      PayoutCompletedData data,
      DateTime? receivedAt});

  @override
  $PayoutCompletedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PayoutCompletedNotificationImplCopyWithImpl<$Res>
    extends _$PayoutCompletedNotificationCopyWithImpl<$Res,
        _$PayoutCompletedNotificationImpl>
    implements _$$PayoutCompletedNotificationImplCopyWith<$Res> {
  __$$PayoutCompletedNotificationImplCopyWithImpl(
      _$PayoutCompletedNotificationImpl _value,
      $Res Function(_$PayoutCompletedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$PayoutCompletedNotificationImpl(
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
              as PayoutCompletedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$PayoutCompletedNotificationImpl
    implements _PayoutCompletedNotification {
  const _$PayoutCompletedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final PayoutCompletedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'PayoutCompletedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutCompletedNotificationImpl &&
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
  _$$PayoutCompletedNotificationImplCopyWith<_$PayoutCompletedNotificationImpl>
      get copyWith => __$$PayoutCompletedNotificationImplCopyWithImpl<
          _$PayoutCompletedNotificationImpl>(this, _$identity);
}

abstract class _PayoutCompletedNotification
    implements PayoutCompletedNotification {
  const factory _PayoutCompletedNotification(
      {required final String event,
      final String? channel,
      required final PayoutCompletedData data,
      final DateTime? receivedAt}) = _$PayoutCompletedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  PayoutCompletedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$PayoutCompletedNotificationImplCopyWith<_$PayoutCompletedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

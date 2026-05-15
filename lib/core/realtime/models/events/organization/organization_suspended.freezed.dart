// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_suspended.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationSuspendedData _$OrganizationSuspendedDataFromJson(
    Map<String, dynamic> json) {
  return _OrganizationSuspendedData.fromJson(json);
}

/// @nodoc
mixin _$OrganizationSuspendedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'suspended_at')
  DateTime? get suspendedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationSuspendedDataCopyWith<OrganizationSuspendedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationSuspendedDataCopyWith<$Res> {
  factory $OrganizationSuspendedDataCopyWith(OrganizationSuspendedData value,
          $Res Function(OrganizationSuspendedData) then) =
      _$OrganizationSuspendedDataCopyWithImpl<$Res, OrganizationSuspendedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      String? reason,
      @JsonKey(name: 'suspended_at') DateTime? suspendedAt});
}

/// @nodoc
class _$OrganizationSuspendedDataCopyWithImpl<$Res,
        $Val extends OrganizationSuspendedData>
    implements $OrganizationSuspendedDataCopyWith<$Res> {
  _$OrganizationSuspendedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? reason = freezed,
    Object? suspendedAt = freezed,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      suspendedAt: freezed == suspendedAt
          ? _value.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationSuspendedDataImplCopyWith<$Res>
    implements $OrganizationSuspendedDataCopyWith<$Res> {
  factory _$$OrganizationSuspendedDataImplCopyWith(
          _$OrganizationSuspendedDataImpl value,
          $Res Function(_$OrganizationSuspendedDataImpl) then) =
      __$$OrganizationSuspendedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      String? reason,
      @JsonKey(name: 'suspended_at') DateTime? suspendedAt});
}

/// @nodoc
class __$$OrganizationSuspendedDataImplCopyWithImpl<$Res>
    extends _$OrganizationSuspendedDataCopyWithImpl<$Res,
        _$OrganizationSuspendedDataImpl>
    implements _$$OrganizationSuspendedDataImplCopyWith<$Res> {
  __$$OrganizationSuspendedDataImplCopyWithImpl(
      _$OrganizationSuspendedDataImpl _value,
      $Res Function(_$OrganizationSuspendedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? reason = freezed,
    Object? suspendedAt = freezed,
  }) {
    return _then(_$OrganizationSuspendedDataImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      suspendedAt: freezed == suspendedAt
          ? _value.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrganizationSuspendedDataImpl implements _OrganizationSuspendedData {
  const _$OrganizationSuspendedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      this.reason,
      @JsonKey(name: 'suspended_at') this.suspendedAt});

  factory _$OrganizationSuspendedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationSuspendedDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  final String? reason;
  @override
  @JsonKey(name: 'suspended_at')
  final DateTime? suspendedAt;

  @override
  String toString() {
    return 'OrganizationSuspendedData(organizationId: $organizationId, reason: $reason, suspendedAt: $suspendedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationSuspendedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.suspendedAt, suspendedAt) ||
                other.suspendedAt == suspendedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, organizationId, reason, suspendedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationSuspendedDataImplCopyWith<_$OrganizationSuspendedDataImpl>
      get copyWith => __$$OrganizationSuspendedDataImplCopyWithImpl<
          _$OrganizationSuspendedDataImpl>(this, _$identity);
}

abstract class _OrganizationSuspendedData implements OrganizationSuspendedData {
  const factory _OrganizationSuspendedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          final String? reason,
          @JsonKey(name: 'suspended_at') final DateTime? suspendedAt}) =
      _$OrganizationSuspendedDataImpl;

  factory _OrganizationSuspendedData.fromJson(Map<String, dynamic> json) =
      _$OrganizationSuspendedDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  String? get reason;
  @override
  @JsonKey(name: 'suspended_at')
  DateTime? get suspendedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationSuspendedDataImplCopyWith<_$OrganizationSuspendedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizationSuspendedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  OrganizationSuspendedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationSuspendedNotificationCopyWith<OrganizationSuspendedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationSuspendedNotificationCopyWith<$Res> {
  factory $OrganizationSuspendedNotificationCopyWith(
          OrganizationSuspendedNotification value,
          $Res Function(OrganizationSuspendedNotification) then) =
      _$OrganizationSuspendedNotificationCopyWithImpl<$Res,
          OrganizationSuspendedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationSuspendedData data,
      DateTime? receivedAt});

  $OrganizationSuspendedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$OrganizationSuspendedNotificationCopyWithImpl<$Res,
        $Val extends OrganizationSuspendedNotification>
    implements $OrganizationSuspendedNotificationCopyWith<$Res> {
  _$OrganizationSuspendedNotificationCopyWithImpl(this._value, this._then);

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
              as OrganizationSuspendedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationSuspendedDataCopyWith<$Res> get data {
    return $OrganizationSuspendedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationSuspendedNotificationImplCopyWith<$Res>
    implements $OrganizationSuspendedNotificationCopyWith<$Res> {
  factory _$$OrganizationSuspendedNotificationImplCopyWith(
          _$OrganizationSuspendedNotificationImpl value,
          $Res Function(_$OrganizationSuspendedNotificationImpl) then) =
      __$$OrganizationSuspendedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationSuspendedData data,
      DateTime? receivedAt});

  @override
  $OrganizationSuspendedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrganizationSuspendedNotificationImplCopyWithImpl<$Res>
    extends _$OrganizationSuspendedNotificationCopyWithImpl<$Res,
        _$OrganizationSuspendedNotificationImpl>
    implements _$$OrganizationSuspendedNotificationImplCopyWith<$Res> {
  __$$OrganizationSuspendedNotificationImplCopyWithImpl(
      _$OrganizationSuspendedNotificationImpl _value,
      $Res Function(_$OrganizationSuspendedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$OrganizationSuspendedNotificationImpl(
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
              as OrganizationSuspendedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationSuspendedNotificationImpl
    implements _OrganizationSuspendedNotification {
  const _$OrganizationSuspendedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final OrganizationSuspendedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'OrganizationSuspendedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationSuspendedNotificationImpl &&
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
  _$$OrganizationSuspendedNotificationImplCopyWith<
          _$OrganizationSuspendedNotificationImpl>
      get copyWith => __$$OrganizationSuspendedNotificationImplCopyWithImpl<
          _$OrganizationSuspendedNotificationImpl>(this, _$identity);
}

abstract class _OrganizationSuspendedNotification
    implements OrganizationSuspendedNotification {
  const factory _OrganizationSuspendedNotification(
      {required final String event,
      final String? channel,
      required final OrganizationSuspendedData data,
      final DateTime? receivedAt}) = _$OrganizationSuspendedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  OrganizationSuspendedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationSuspendedNotificationImplCopyWith<
          _$OrganizationSuspendedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_rejected.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationRejectedData _$OrganizationRejectedDataFromJson(
    Map<String, dynamic> json) {
  return _OrganizationRejectedData.fromJson(json);
}

/// @nodoc
mixin _$OrganizationRejectedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_uuid')
  String? get organizationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name')
  String? get organizationName => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_at')
  DateTime? get rejectedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationRejectedDataCopyWith<OrganizationRejectedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationRejectedDataCopyWith<$Res> {
  factory $OrganizationRejectedDataCopyWith(OrganizationRejectedData value,
          $Res Function(OrganizationRejectedData) then) =
      _$OrganizationRejectedDataCopyWithImpl<$Res, OrganizationRejectedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_uuid') String? organizationUuid,
      @JsonKey(name: 'organization_name') String? organizationName,
      String? reason,
      @JsonKey(name: 'rejected_at') DateTime? rejectedAt});
}

/// @nodoc
class _$OrganizationRejectedDataCopyWithImpl<$Res,
        $Val extends OrganizationRejectedData>
    implements $OrganizationRejectedDataCopyWith<$Res> {
  _$OrganizationRejectedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationUuid = freezed,
    Object? organizationName = freezed,
    Object? reason = freezed,
    Object? rejectedAt = freezed,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      organizationUuid: freezed == organizationUuid
          ? _value.organizationUuid
          : organizationUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationRejectedDataImplCopyWith<$Res>
    implements $OrganizationRejectedDataCopyWith<$Res> {
  factory _$$OrganizationRejectedDataImplCopyWith(
          _$OrganizationRejectedDataImpl value,
          $Res Function(_$OrganizationRejectedDataImpl) then) =
      __$$OrganizationRejectedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_uuid') String? organizationUuid,
      @JsonKey(name: 'organization_name') String? organizationName,
      String? reason,
      @JsonKey(name: 'rejected_at') DateTime? rejectedAt});
}

/// @nodoc
class __$$OrganizationRejectedDataImplCopyWithImpl<$Res>
    extends _$OrganizationRejectedDataCopyWithImpl<$Res,
        _$OrganizationRejectedDataImpl>
    implements _$$OrganizationRejectedDataImplCopyWith<$Res> {
  __$$OrganizationRejectedDataImplCopyWithImpl(
      _$OrganizationRejectedDataImpl _value,
      $Res Function(_$OrganizationRejectedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationUuid = freezed,
    Object? organizationName = freezed,
    Object? reason = freezed,
    Object? rejectedAt = freezed,
  }) {
    return _then(_$OrganizationRejectedDataImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      organizationUuid: freezed == organizationUuid
          ? _value.organizationUuid
          : organizationUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrganizationRejectedDataImpl implements _OrganizationRejectedData {
  const _$OrganizationRejectedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      @JsonKey(name: 'organization_uuid') this.organizationUuid,
      @JsonKey(name: 'organization_name') this.organizationName,
      this.reason,
      @JsonKey(name: 'rejected_at') this.rejectedAt});

  factory _$OrganizationRejectedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationRejectedDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  @JsonKey(name: 'organization_uuid')
  final String? organizationUuid;
  @override
  @JsonKey(name: 'organization_name')
  final String? organizationName;
  @override
  final String? reason;
  @override
  @JsonKey(name: 'rejected_at')
  final DateTime? rejectedAt;

  @override
  String toString() {
    return 'OrganizationRejectedData(organizationId: $organizationId, organizationUuid: $organizationUuid, organizationName: $organizationName, reason: $reason, rejectedAt: $rejectedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationRejectedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationUuid, organizationUuid) ||
                other.organizationUuid == organizationUuid) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, organizationId, organizationUuid,
      organizationName, reason, rejectedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationRejectedDataImplCopyWith<_$OrganizationRejectedDataImpl>
      get copyWith => __$$OrganizationRejectedDataImplCopyWithImpl<
          _$OrganizationRejectedDataImpl>(this, _$identity);
}

abstract class _OrganizationRejectedData implements OrganizationRejectedData {
  const factory _OrganizationRejectedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          @JsonKey(name: 'organization_uuid') final String? organizationUuid,
          @JsonKey(name: 'organization_name') final String? organizationName,
          final String? reason,
          @JsonKey(name: 'rejected_at') final DateTime? rejectedAt}) =
      _$OrganizationRejectedDataImpl;

  factory _OrganizationRejectedData.fromJson(Map<String, dynamic> json) =
      _$OrganizationRejectedDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  @JsonKey(name: 'organization_uuid')
  String? get organizationUuid;
  @override
  @JsonKey(name: 'organization_name')
  String? get organizationName;
  @override
  String? get reason;
  @override
  @JsonKey(name: 'rejected_at')
  DateTime? get rejectedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationRejectedDataImplCopyWith<_$OrganizationRejectedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizationRejectedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  OrganizationRejectedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationRejectedNotificationCopyWith<OrganizationRejectedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationRejectedNotificationCopyWith<$Res> {
  factory $OrganizationRejectedNotificationCopyWith(
          OrganizationRejectedNotification value,
          $Res Function(OrganizationRejectedNotification) then) =
      _$OrganizationRejectedNotificationCopyWithImpl<$Res,
          OrganizationRejectedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationRejectedData data,
      DateTime? receivedAt});

  $OrganizationRejectedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$OrganizationRejectedNotificationCopyWithImpl<$Res,
        $Val extends OrganizationRejectedNotification>
    implements $OrganizationRejectedNotificationCopyWith<$Res> {
  _$OrganizationRejectedNotificationCopyWithImpl(this._value, this._then);

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
              as OrganizationRejectedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationRejectedDataCopyWith<$Res> get data {
    return $OrganizationRejectedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationRejectedNotificationImplCopyWith<$Res>
    implements $OrganizationRejectedNotificationCopyWith<$Res> {
  factory _$$OrganizationRejectedNotificationImplCopyWith(
          _$OrganizationRejectedNotificationImpl value,
          $Res Function(_$OrganizationRejectedNotificationImpl) then) =
      __$$OrganizationRejectedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationRejectedData data,
      DateTime? receivedAt});

  @override
  $OrganizationRejectedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrganizationRejectedNotificationImplCopyWithImpl<$Res>
    extends _$OrganizationRejectedNotificationCopyWithImpl<$Res,
        _$OrganizationRejectedNotificationImpl>
    implements _$$OrganizationRejectedNotificationImplCopyWith<$Res> {
  __$$OrganizationRejectedNotificationImplCopyWithImpl(
      _$OrganizationRejectedNotificationImpl _value,
      $Res Function(_$OrganizationRejectedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$OrganizationRejectedNotificationImpl(
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
              as OrganizationRejectedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationRejectedNotificationImpl
    implements _OrganizationRejectedNotification {
  const _$OrganizationRejectedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final OrganizationRejectedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'OrganizationRejectedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationRejectedNotificationImpl &&
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
  _$$OrganizationRejectedNotificationImplCopyWith<
          _$OrganizationRejectedNotificationImpl>
      get copyWith => __$$OrganizationRejectedNotificationImplCopyWithImpl<
          _$OrganizationRejectedNotificationImpl>(this, _$identity);
}

abstract class _OrganizationRejectedNotification
    implements OrganizationRejectedNotification {
  const factory _OrganizationRejectedNotification(
      {required final String event,
      final String? channel,
      required final OrganizationRejectedData data,
      final DateTime? receivedAt}) = _$OrganizationRejectedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  OrganizationRejectedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationRejectedNotificationImplCopyWith<
          _$OrganizationRejectedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

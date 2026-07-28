// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_approved.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationApprovedData _$OrganizationApprovedDataFromJson(
    Map<String, dynamic> json) {
  return _OrganizationApprovedData.fromJson(json);
}

/// @nodoc
mixin _$OrganizationApprovedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_uuid')
  String? get organizationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name')
  String? get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationApprovedDataCopyWith<OrganizationApprovedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationApprovedDataCopyWith<$Res> {
  factory $OrganizationApprovedDataCopyWith(OrganizationApprovedData value,
          $Res Function(OrganizationApprovedData) then) =
      _$OrganizationApprovedDataCopyWithImpl<$Res, OrganizationApprovedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_uuid') String? organizationUuid,
      @JsonKey(name: 'organization_name') String? organizationName,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});
}

/// @nodoc
class _$OrganizationApprovedDataCopyWithImpl<$Res,
        $Val extends OrganizationApprovedData>
    implements $OrganizationApprovedDataCopyWith<$Res> {
  _$OrganizationApprovedDataCopyWithImpl(this._value, this._then);

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
    Object? approvedAt = freezed,
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
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationApprovedDataImplCopyWith<$Res>
    implements $OrganizationApprovedDataCopyWith<$Res> {
  factory _$$OrganizationApprovedDataImplCopyWith(
          _$OrganizationApprovedDataImpl value,
          $Res Function(_$OrganizationApprovedDataImpl) then) =
      __$$OrganizationApprovedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_uuid') String? organizationUuid,
      @JsonKey(name: 'organization_name') String? organizationName,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});
}

/// @nodoc
class __$$OrganizationApprovedDataImplCopyWithImpl<$Res>
    extends _$OrganizationApprovedDataCopyWithImpl<$Res,
        _$OrganizationApprovedDataImpl>
    implements _$$OrganizationApprovedDataImplCopyWith<$Res> {
  __$$OrganizationApprovedDataImplCopyWithImpl(
      _$OrganizationApprovedDataImpl _value,
      $Res Function(_$OrganizationApprovedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationUuid = freezed,
    Object? organizationName = freezed,
    Object? approvedAt = freezed,
  }) {
    return _then(_$OrganizationApprovedDataImpl(
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
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrganizationApprovedDataImpl implements _OrganizationApprovedData {
  const _$OrganizationApprovedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      @JsonKey(name: 'organization_uuid') this.organizationUuid,
      @JsonKey(name: 'organization_name') this.organizationName,
      @JsonKey(name: 'approved_at') this.approvedAt});

  factory _$OrganizationApprovedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationApprovedDataImplFromJson(json);

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
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;

  @override
  String toString() {
    return 'OrganizationApprovedData(organizationId: $organizationId, organizationUuid: $organizationUuid, organizationName: $organizationName, approvedAt: $approvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationApprovedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationUuid, organizationUuid) ||
                other.organizationUuid == organizationUuid) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, organizationId, organizationUuid,
      organizationName, approvedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationApprovedDataImplCopyWith<_$OrganizationApprovedDataImpl>
      get copyWith => __$$OrganizationApprovedDataImplCopyWithImpl<
          _$OrganizationApprovedDataImpl>(this, _$identity);
}

abstract class _OrganizationApprovedData implements OrganizationApprovedData {
  const factory _OrganizationApprovedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          @JsonKey(name: 'organization_uuid') final String? organizationUuid,
          @JsonKey(name: 'organization_name') final String? organizationName,
          @JsonKey(name: 'approved_at') final DateTime? approvedAt}) =
      _$OrganizationApprovedDataImpl;

  factory _OrganizationApprovedData.fromJson(Map<String, dynamic> json) =
      _$OrganizationApprovedDataImpl.fromJson;

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
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationApprovedDataImplCopyWith<_$OrganizationApprovedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizationApprovedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  OrganizationApprovedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationApprovedNotificationCopyWith<OrganizationApprovedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationApprovedNotificationCopyWith<$Res> {
  factory $OrganizationApprovedNotificationCopyWith(
          OrganizationApprovedNotification value,
          $Res Function(OrganizationApprovedNotification) then) =
      _$OrganizationApprovedNotificationCopyWithImpl<$Res,
          OrganizationApprovedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationApprovedData data,
      DateTime? receivedAt});

  $OrganizationApprovedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$OrganizationApprovedNotificationCopyWithImpl<$Res,
        $Val extends OrganizationApprovedNotification>
    implements $OrganizationApprovedNotificationCopyWith<$Res> {
  _$OrganizationApprovedNotificationCopyWithImpl(this._value, this._then);

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
              as OrganizationApprovedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationApprovedDataCopyWith<$Res> get data {
    return $OrganizationApprovedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationApprovedNotificationImplCopyWith<$Res>
    implements $OrganizationApprovedNotificationCopyWith<$Res> {
  factory _$$OrganizationApprovedNotificationImplCopyWith(
          _$OrganizationApprovedNotificationImpl value,
          $Res Function(_$OrganizationApprovedNotificationImpl) then) =
      __$$OrganizationApprovedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationApprovedData data,
      DateTime? receivedAt});

  @override
  $OrganizationApprovedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrganizationApprovedNotificationImplCopyWithImpl<$Res>
    extends _$OrganizationApprovedNotificationCopyWithImpl<$Res,
        _$OrganizationApprovedNotificationImpl>
    implements _$$OrganizationApprovedNotificationImplCopyWith<$Res> {
  __$$OrganizationApprovedNotificationImplCopyWithImpl(
      _$OrganizationApprovedNotificationImpl _value,
      $Res Function(_$OrganizationApprovedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$OrganizationApprovedNotificationImpl(
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
              as OrganizationApprovedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationApprovedNotificationImpl
    implements _OrganizationApprovedNotification {
  const _$OrganizationApprovedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final OrganizationApprovedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'OrganizationApprovedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationApprovedNotificationImpl &&
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
  _$$OrganizationApprovedNotificationImplCopyWith<
          _$OrganizationApprovedNotificationImpl>
      get copyWith => __$$OrganizationApprovedNotificationImplCopyWithImpl<
          _$OrganizationApprovedNotificationImpl>(this, _$identity);
}

abstract class _OrganizationApprovedNotification
    implements OrganizationApprovedNotification {
  const factory _OrganizationApprovedNotification(
      {required final String event,
      final String? channel,
      required final OrganizationApprovedData data,
      final DateTime? receivedAt}) = _$OrganizationApprovedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  OrganizationApprovedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationApprovedNotificationImplCopyWith<
          _$OrganizationApprovedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

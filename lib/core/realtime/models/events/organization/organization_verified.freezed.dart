// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_verified.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationVerifiedData _$OrganizationVerifiedDataFromJson(
    Map<String, dynamic> json) {
  return _OrganizationVerifiedData.fromJson(json);
}

/// @nodoc
mixin _$OrganizationVerifiedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name')
  String? get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationVerifiedDataCopyWith<OrganizationVerifiedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationVerifiedDataCopyWith<$Res> {
  factory $OrganizationVerifiedDataCopyWith(OrganizationVerifiedData value,
          $Res Function(OrganizationVerifiedData) then) =
      _$OrganizationVerifiedDataCopyWithImpl<$Res, OrganizationVerifiedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_name') String? organizationName,
      @JsonKey(name: 'verified_at') DateTime? verifiedAt});
}

/// @nodoc
class _$OrganizationVerifiedDataCopyWithImpl<$Res,
        $Val extends OrganizationVerifiedData>
    implements $OrganizationVerifiedDataCopyWith<$Res> {
  _$OrganizationVerifiedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationName = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationVerifiedDataImplCopyWith<$Res>
    implements $OrganizationVerifiedDataCopyWith<$Res> {
  factory _$$OrganizationVerifiedDataImplCopyWith(
          _$OrganizationVerifiedDataImpl value,
          $Res Function(_$OrganizationVerifiedDataImpl) then) =
      __$$OrganizationVerifiedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_name') String? organizationName,
      @JsonKey(name: 'verified_at') DateTime? verifiedAt});
}

/// @nodoc
class __$$OrganizationVerifiedDataImplCopyWithImpl<$Res>
    extends _$OrganizationVerifiedDataCopyWithImpl<$Res,
        _$OrganizationVerifiedDataImpl>
    implements _$$OrganizationVerifiedDataImplCopyWith<$Res> {
  __$$OrganizationVerifiedDataImplCopyWithImpl(
      _$OrganizationVerifiedDataImpl _value,
      $Res Function(_$OrganizationVerifiedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationName = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_$OrganizationVerifiedDataImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrganizationVerifiedDataImpl implements _OrganizationVerifiedData {
  const _$OrganizationVerifiedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      @JsonKey(name: 'organization_name') this.organizationName,
      @JsonKey(name: 'verified_at') this.verifiedAt});

  factory _$OrganizationVerifiedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationVerifiedDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  @JsonKey(name: 'organization_name')
  final String? organizationName;
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'OrganizationVerifiedData(organizationId: $organizationId, organizationName: $organizationName, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationVerifiedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, organizationId, organizationName, verifiedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationVerifiedDataImplCopyWith<_$OrganizationVerifiedDataImpl>
      get copyWith => __$$OrganizationVerifiedDataImplCopyWithImpl<
          _$OrganizationVerifiedDataImpl>(this, _$identity);
}

abstract class _OrganizationVerifiedData implements OrganizationVerifiedData {
  const factory _OrganizationVerifiedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          @JsonKey(name: 'organization_name') final String? organizationName,
          @JsonKey(name: 'verified_at') final DateTime? verifiedAt}) =
      _$OrganizationVerifiedDataImpl;

  factory _OrganizationVerifiedData.fromJson(Map<String, dynamic> json) =
      _$OrganizationVerifiedDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  @JsonKey(name: 'organization_name')
  String? get organizationName;
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationVerifiedDataImplCopyWith<_$OrganizationVerifiedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizationVerifiedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  OrganizationVerifiedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationVerifiedNotificationCopyWith<OrganizationVerifiedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationVerifiedNotificationCopyWith<$Res> {
  factory $OrganizationVerifiedNotificationCopyWith(
          OrganizationVerifiedNotification value,
          $Res Function(OrganizationVerifiedNotification) then) =
      _$OrganizationVerifiedNotificationCopyWithImpl<$Res,
          OrganizationVerifiedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationVerifiedData data,
      DateTime? receivedAt});

  $OrganizationVerifiedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$OrganizationVerifiedNotificationCopyWithImpl<$Res,
        $Val extends OrganizationVerifiedNotification>
    implements $OrganizationVerifiedNotificationCopyWith<$Res> {
  _$OrganizationVerifiedNotificationCopyWithImpl(this._value, this._then);

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
              as OrganizationVerifiedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationVerifiedDataCopyWith<$Res> get data {
    return $OrganizationVerifiedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationVerifiedNotificationImplCopyWith<$Res>
    implements $OrganizationVerifiedNotificationCopyWith<$Res> {
  factory _$$OrganizationVerifiedNotificationImplCopyWith(
          _$OrganizationVerifiedNotificationImpl value,
          $Res Function(_$OrganizationVerifiedNotificationImpl) then) =
      __$$OrganizationVerifiedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationVerifiedData data,
      DateTime? receivedAt});

  @override
  $OrganizationVerifiedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrganizationVerifiedNotificationImplCopyWithImpl<$Res>
    extends _$OrganizationVerifiedNotificationCopyWithImpl<$Res,
        _$OrganizationVerifiedNotificationImpl>
    implements _$$OrganizationVerifiedNotificationImplCopyWith<$Res> {
  __$$OrganizationVerifiedNotificationImplCopyWithImpl(
      _$OrganizationVerifiedNotificationImpl _value,
      $Res Function(_$OrganizationVerifiedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$OrganizationVerifiedNotificationImpl(
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
              as OrganizationVerifiedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationVerifiedNotificationImpl
    implements _OrganizationVerifiedNotification {
  const _$OrganizationVerifiedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final OrganizationVerifiedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'OrganizationVerifiedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationVerifiedNotificationImpl &&
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
  _$$OrganizationVerifiedNotificationImplCopyWith<
          _$OrganizationVerifiedNotificationImpl>
      get copyWith => __$$OrganizationVerifiedNotificationImplCopyWithImpl<
          _$OrganizationVerifiedNotificationImpl>(this, _$identity);
}

abstract class _OrganizationVerifiedNotification
    implements OrganizationVerifiedNotification {
  const factory _OrganizationVerifiedNotification(
      {required final String event,
      final String? channel,
      required final OrganizationVerifiedData data,
      final DateTime? receivedAt}) = _$OrganizationVerifiedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  OrganizationVerifiedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationVerifiedNotificationImplCopyWith<
          _$OrganizationVerifiedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_registered.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationRegisteredData _$OrganizationRegisteredDataFromJson(
    Map<String, dynamic> json) {
  return _OrganizationRegisteredData.fromJson(json);
}

/// @nodoc
mixin _$OrganizationRegisteredData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name')
  String? get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_at')
  DateTime? get registeredAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationRegisteredDataCopyWith<OrganizationRegisteredData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationRegisteredDataCopyWith<$Res> {
  factory $OrganizationRegisteredDataCopyWith(OrganizationRegisteredData value,
          $Res Function(OrganizationRegisteredData) then) =
      _$OrganizationRegisteredDataCopyWithImpl<$Res,
          OrganizationRegisteredData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_name') String? organizationName,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'registered_at') DateTime? registeredAt});
}

/// @nodoc
class _$OrganizationRegisteredDataCopyWithImpl<$Res,
        $Val extends OrganizationRegisteredData>
    implements $OrganizationRegisteredDataCopyWith<$Res> {
  _$OrganizationRegisteredDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationName = freezed,
    Object? userId = freezed,
    Object? registeredAt = freezed,
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
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      registeredAt: freezed == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationRegisteredDataImplCopyWith<$Res>
    implements $OrganizationRegisteredDataCopyWith<$Res> {
  factory _$$OrganizationRegisteredDataImplCopyWith(
          _$OrganizationRegisteredDataImpl value,
          $Res Function(_$OrganizationRegisteredDataImpl) then) =
      __$$OrganizationRegisteredDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'organization_name') String? organizationName,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'registered_at') DateTime? registeredAt});
}

/// @nodoc
class __$$OrganizationRegisteredDataImplCopyWithImpl<$Res>
    extends _$OrganizationRegisteredDataCopyWithImpl<$Res,
        _$OrganizationRegisteredDataImpl>
    implements _$$OrganizationRegisteredDataImplCopyWith<$Res> {
  __$$OrganizationRegisteredDataImplCopyWithImpl(
      _$OrganizationRegisteredDataImpl _value,
      $Res Function(_$OrganizationRegisteredDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? organizationName = freezed,
    Object? userId = freezed,
    Object? registeredAt = freezed,
  }) {
    return _then(_$OrganizationRegisteredDataImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      registeredAt: freezed == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrganizationRegisteredDataImpl implements _OrganizationRegisteredData {
  const _$OrganizationRegisteredDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      @JsonKey(name: 'organization_name') this.organizationName,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'registered_at') this.registeredAt});

  factory _$OrganizationRegisteredDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$OrganizationRegisteredDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  @JsonKey(name: 'organization_name')
  final String? organizationName;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'registered_at')
  final DateTime? registeredAt;

  @override
  String toString() {
    return 'OrganizationRegisteredData(organizationId: $organizationId, organizationName: $organizationName, userId: $userId, registeredAt: $registeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationRegisteredDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, organizationId, organizationName, userId, registeredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationRegisteredDataImplCopyWith<_$OrganizationRegisteredDataImpl>
      get copyWith => __$$OrganizationRegisteredDataImplCopyWithImpl<
          _$OrganizationRegisteredDataImpl>(this, _$identity);
}

abstract class _OrganizationRegisteredData
    implements OrganizationRegisteredData {
  const factory _OrganizationRegisteredData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          @JsonKey(name: 'organization_name') final String? organizationName,
          @JsonKey(name: 'user_id') final int? userId,
          @JsonKey(name: 'registered_at') final DateTime? registeredAt}) =
      _$OrganizationRegisteredDataImpl;

  factory _OrganizationRegisteredData.fromJson(Map<String, dynamic> json) =
      _$OrganizationRegisteredDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  @JsonKey(name: 'organization_name')
  String? get organizationName;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'registered_at')
  DateTime? get registeredAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationRegisteredDataImplCopyWith<_$OrganizationRegisteredDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizationRegisteredNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  OrganizationRegisteredData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationRegisteredNotificationCopyWith<
          OrganizationRegisteredNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationRegisteredNotificationCopyWith<$Res> {
  factory $OrganizationRegisteredNotificationCopyWith(
          OrganizationRegisteredNotification value,
          $Res Function(OrganizationRegisteredNotification) then) =
      _$OrganizationRegisteredNotificationCopyWithImpl<$Res,
          OrganizationRegisteredNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationRegisteredData data,
      DateTime? receivedAt});

  $OrganizationRegisteredDataCopyWith<$Res> get data;
}

/// @nodoc
class _$OrganizationRegisteredNotificationCopyWithImpl<$Res,
        $Val extends OrganizationRegisteredNotification>
    implements $OrganizationRegisteredNotificationCopyWith<$Res> {
  _$OrganizationRegisteredNotificationCopyWithImpl(this._value, this._then);

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
              as OrganizationRegisteredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationRegisteredDataCopyWith<$Res> get data {
    return $OrganizationRegisteredDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationRegisteredNotificationImplCopyWith<$Res>
    implements $OrganizationRegisteredNotificationCopyWith<$Res> {
  factory _$$OrganizationRegisteredNotificationImplCopyWith(
          _$OrganizationRegisteredNotificationImpl value,
          $Res Function(_$OrganizationRegisteredNotificationImpl) then) =
      __$$OrganizationRegisteredNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationRegisteredData data,
      DateTime? receivedAt});

  @override
  $OrganizationRegisteredDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrganizationRegisteredNotificationImplCopyWithImpl<$Res>
    extends _$OrganizationRegisteredNotificationCopyWithImpl<$Res,
        _$OrganizationRegisteredNotificationImpl>
    implements _$$OrganizationRegisteredNotificationImplCopyWith<$Res> {
  __$$OrganizationRegisteredNotificationImplCopyWithImpl(
      _$OrganizationRegisteredNotificationImpl _value,
      $Res Function(_$OrganizationRegisteredNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$OrganizationRegisteredNotificationImpl(
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
              as OrganizationRegisteredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationRegisteredNotificationImpl
    implements _OrganizationRegisteredNotification {
  const _$OrganizationRegisteredNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final OrganizationRegisteredData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'OrganizationRegisteredNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationRegisteredNotificationImpl &&
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
  _$$OrganizationRegisteredNotificationImplCopyWith<
          _$OrganizationRegisteredNotificationImpl>
      get copyWith => __$$OrganizationRegisteredNotificationImplCopyWithImpl<
          _$OrganizationRegisteredNotificationImpl>(this, _$identity);
}

abstract class _OrganizationRegisteredNotification
    implements OrganizationRegisteredNotification {
  const factory _OrganizationRegisteredNotification(
      {required final String event,
      final String? channel,
      required final OrganizationRegisteredData data,
      final DateTime? receivedAt}) = _$OrganizationRegisteredNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  OrganizationRegisteredData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationRegisteredNotificationImplCopyWith<
          _$OrganizationRegisteredNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

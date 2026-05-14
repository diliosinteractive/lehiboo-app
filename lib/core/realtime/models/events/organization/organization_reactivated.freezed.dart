// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_reactivated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationReactivatedData _$OrganizationReactivatedDataFromJson(
    Map<String, dynamic> json) {
  return _OrganizationReactivatedData.fromJson(json);
}

/// @nodoc
mixin _$OrganizationReactivatedData {
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reactivated_at')
  DateTime? get reactivatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationReactivatedDataCopyWith<OrganizationReactivatedData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationReactivatedDataCopyWith<$Res> {
  factory $OrganizationReactivatedDataCopyWith(
          OrganizationReactivatedData value,
          $Res Function(OrganizationReactivatedData) then) =
      _$OrganizationReactivatedDataCopyWithImpl<$Res,
          OrganizationReactivatedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'reactivated_at') DateTime? reactivatedAt});
}

/// @nodoc
class _$OrganizationReactivatedDataCopyWithImpl<$Res,
        $Val extends OrganizationReactivatedData>
    implements $OrganizationReactivatedDataCopyWith<$Res> {
  _$OrganizationReactivatedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? reactivatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      reactivatedAt: freezed == reactivatedAt
          ? _value.reactivatedAt
          : reactivatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationReactivatedDataImplCopyWith<$Res>
    implements $OrganizationReactivatedDataCopyWith<$Res> {
  factory _$$OrganizationReactivatedDataImplCopyWith(
          _$OrganizationReactivatedDataImpl value,
          $Res Function(_$OrganizationReactivatedDataImpl) then) =
      __$$OrganizationReactivatedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'reactivated_at') DateTime? reactivatedAt});
}

/// @nodoc
class __$$OrganizationReactivatedDataImplCopyWithImpl<$Res>
    extends _$OrganizationReactivatedDataCopyWithImpl<$Res,
        _$OrganizationReactivatedDataImpl>
    implements _$$OrganizationReactivatedDataImplCopyWith<$Res> {
  __$$OrganizationReactivatedDataImplCopyWithImpl(
      _$OrganizationReactivatedDataImpl _value,
      $Res Function(_$OrganizationReactivatedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? reactivatedAt = freezed,
  }) {
    return _then(_$OrganizationReactivatedDataImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      reactivatedAt: freezed == reactivatedAt
          ? _value.reactivatedAt
          : reactivatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$OrganizationReactivatedDataImpl
    implements _OrganizationReactivatedData {
  const _$OrganizationReactivatedDataImpl(
      {@JsonKey(name: 'organization_id') required this.organizationId,
      @JsonKey(name: 'reactivated_at') this.reactivatedAt});

  factory _$OrganizationReactivatedDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$OrganizationReactivatedDataImplFromJson(json);

  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  @JsonKey(name: 'reactivated_at')
  final DateTime? reactivatedAt;

  @override
  String toString() {
    return 'OrganizationReactivatedData(organizationId: $organizationId, reactivatedAt: $reactivatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationReactivatedDataImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.reactivatedAt, reactivatedAt) ||
                other.reactivatedAt == reactivatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, organizationId, reactivatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationReactivatedDataImplCopyWith<_$OrganizationReactivatedDataImpl>
      get copyWith => __$$OrganizationReactivatedDataImplCopyWithImpl<
          _$OrganizationReactivatedDataImpl>(this, _$identity);
}

abstract class _OrganizationReactivatedData
    implements OrganizationReactivatedData {
  const factory _OrganizationReactivatedData(
          {@JsonKey(name: 'organization_id') required final int organizationId,
          @JsonKey(name: 'reactivated_at') final DateTime? reactivatedAt}) =
      _$OrganizationReactivatedDataImpl;

  factory _OrganizationReactivatedData.fromJson(Map<String, dynamic> json) =
      _$OrganizationReactivatedDataImpl.fromJson;

  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  @JsonKey(name: 'reactivated_at')
  DateTime? get reactivatedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationReactivatedDataImplCopyWith<_$OrganizationReactivatedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizationReactivatedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  OrganizationReactivatedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationReactivatedNotificationCopyWith<
          OrganizationReactivatedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationReactivatedNotificationCopyWith<$Res> {
  factory $OrganizationReactivatedNotificationCopyWith(
          OrganizationReactivatedNotification value,
          $Res Function(OrganizationReactivatedNotification) then) =
      _$OrganizationReactivatedNotificationCopyWithImpl<$Res,
          OrganizationReactivatedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationReactivatedData data,
      DateTime? receivedAt});

  $OrganizationReactivatedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$OrganizationReactivatedNotificationCopyWithImpl<$Res,
        $Val extends OrganizationReactivatedNotification>
    implements $OrganizationReactivatedNotificationCopyWith<$Res> {
  _$OrganizationReactivatedNotificationCopyWithImpl(this._value, this._then);

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
              as OrganizationReactivatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationReactivatedDataCopyWith<$Res> get data {
    return $OrganizationReactivatedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationReactivatedNotificationImplCopyWith<$Res>
    implements $OrganizationReactivatedNotificationCopyWith<$Res> {
  factory _$$OrganizationReactivatedNotificationImplCopyWith(
          _$OrganizationReactivatedNotificationImpl value,
          $Res Function(_$OrganizationReactivatedNotificationImpl) then) =
      __$$OrganizationReactivatedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      OrganizationReactivatedData data,
      DateTime? receivedAt});

  @override
  $OrganizationReactivatedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrganizationReactivatedNotificationImplCopyWithImpl<$Res>
    extends _$OrganizationReactivatedNotificationCopyWithImpl<$Res,
        _$OrganizationReactivatedNotificationImpl>
    implements _$$OrganizationReactivatedNotificationImplCopyWith<$Res> {
  __$$OrganizationReactivatedNotificationImplCopyWithImpl(
      _$OrganizationReactivatedNotificationImpl _value,
      $Res Function(_$OrganizationReactivatedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$OrganizationReactivatedNotificationImpl(
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
              as OrganizationReactivatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationReactivatedNotificationImpl
    implements _OrganizationReactivatedNotification {
  const _$OrganizationReactivatedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final OrganizationReactivatedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'OrganizationReactivatedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationReactivatedNotificationImpl &&
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
  _$$OrganizationReactivatedNotificationImplCopyWith<
          _$OrganizationReactivatedNotificationImpl>
      get copyWith => __$$OrganizationReactivatedNotificationImplCopyWithImpl<
          _$OrganizationReactivatedNotificationImpl>(this, _$identity);
}

abstract class _OrganizationReactivatedNotification
    implements OrganizationReactivatedNotification {
  const factory _OrganizationReactivatedNotification(
      {required final String event,
      final String? channel,
      required final OrganizationReactivatedData data,
      final DateTime? receivedAt}) = _$OrganizationReactivatedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  OrganizationReactivatedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationReactivatedNotificationImplCopyWith<
          _$OrganizationReactivatedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

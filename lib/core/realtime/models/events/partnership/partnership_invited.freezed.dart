// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partnership_invited.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartnershipInvitedData _$PartnershipInvitedDataFromJson(
    Map<String, dynamic> json) {
  return _PartnershipInvitedData.fromJson(json);
}

/// @nodoc
mixin _$PartnershipInvitedData {
  @JsonKey(name: 'partnership_id')
  String get partnershipId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inviter_name')
  String? get inviterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_at')
  DateTime? get invitedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartnershipInvitedDataCopyWith<PartnershipInvitedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnershipInvitedDataCopyWith<$Res> {
  factory $PartnershipInvitedDataCopyWith(PartnershipInvitedData value,
          $Res Function(PartnershipInvitedData) then) =
      _$PartnershipInvitedDataCopyWithImpl<$Res, PartnershipInvitedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'partnership_id') String partnershipId,
      @JsonKey(name: 'inviter_name') String? inviterName,
      @JsonKey(name: 'invited_at') DateTime? invitedAt});
}

/// @nodoc
class _$PartnershipInvitedDataCopyWithImpl<$Res,
        $Val extends PartnershipInvitedData>
    implements $PartnershipInvitedDataCopyWith<$Res> {
  _$PartnershipInvitedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partnershipId = null,
    Object? inviterName = freezed,
    Object? invitedAt = freezed,
  }) {
    return _then(_value.copyWith(
      partnershipId: null == partnershipId
          ? _value.partnershipId
          : partnershipId // ignore: cast_nullable_to_non_nullable
              as String,
      inviterName: freezed == inviterName
          ? _value.inviterName
          : inviterName // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedAt: freezed == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartnershipInvitedDataImplCopyWith<$Res>
    implements $PartnershipInvitedDataCopyWith<$Res> {
  factory _$$PartnershipInvitedDataImplCopyWith(
          _$PartnershipInvitedDataImpl value,
          $Res Function(_$PartnershipInvitedDataImpl) then) =
      __$$PartnershipInvitedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'partnership_id') String partnershipId,
      @JsonKey(name: 'inviter_name') String? inviterName,
      @JsonKey(name: 'invited_at') DateTime? invitedAt});
}

/// @nodoc
class __$$PartnershipInvitedDataImplCopyWithImpl<$Res>
    extends _$PartnershipInvitedDataCopyWithImpl<$Res,
        _$PartnershipInvitedDataImpl>
    implements _$$PartnershipInvitedDataImplCopyWith<$Res> {
  __$$PartnershipInvitedDataImplCopyWithImpl(
      _$PartnershipInvitedDataImpl _value,
      $Res Function(_$PartnershipInvitedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partnershipId = null,
    Object? inviterName = freezed,
    Object? invitedAt = freezed,
  }) {
    return _then(_$PartnershipInvitedDataImpl(
      partnershipId: null == partnershipId
          ? _value.partnershipId
          : partnershipId // ignore: cast_nullable_to_non_nullable
              as String,
      inviterName: freezed == inviterName
          ? _value.inviterName
          : inviterName // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedAt: freezed == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PartnershipInvitedDataImpl implements _PartnershipInvitedData {
  const _$PartnershipInvitedDataImpl(
      {@JsonKey(name: 'partnership_id') required this.partnershipId,
      @JsonKey(name: 'inviter_name') this.inviterName,
      @JsonKey(name: 'invited_at') this.invitedAt});

  factory _$PartnershipInvitedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartnershipInvitedDataImplFromJson(json);

  @override
  @JsonKey(name: 'partnership_id')
  final String partnershipId;
  @override
  @JsonKey(name: 'inviter_name')
  final String? inviterName;
  @override
  @JsonKey(name: 'invited_at')
  final DateTime? invitedAt;

  @override
  String toString() {
    return 'PartnershipInvitedData(partnershipId: $partnershipId, inviterName: $inviterName, invitedAt: $invitedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnershipInvitedDataImpl &&
            (identical(other.partnershipId, partnershipId) ||
                other.partnershipId == partnershipId) &&
            (identical(other.inviterName, inviterName) ||
                other.inviterName == inviterName) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, partnershipId, inviterName, invitedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnershipInvitedDataImplCopyWith<_$PartnershipInvitedDataImpl>
      get copyWith => __$$PartnershipInvitedDataImplCopyWithImpl<
          _$PartnershipInvitedDataImpl>(this, _$identity);
}

abstract class _PartnershipInvitedData implements PartnershipInvitedData {
  const factory _PartnershipInvitedData(
          {@JsonKey(name: 'partnership_id') required final String partnershipId,
          @JsonKey(name: 'inviter_name') final String? inviterName,
          @JsonKey(name: 'invited_at') final DateTime? invitedAt}) =
      _$PartnershipInvitedDataImpl;

  factory _PartnershipInvitedData.fromJson(Map<String, dynamic> json) =
      _$PartnershipInvitedDataImpl.fromJson;

  @override
  @JsonKey(name: 'partnership_id')
  String get partnershipId;
  @override
  @JsonKey(name: 'inviter_name')
  String? get inviterName;
  @override
  @JsonKey(name: 'invited_at')
  DateTime? get invitedAt;
  @override
  @JsonKey(ignore: true)
  _$$PartnershipInvitedDataImplCopyWith<_$PartnershipInvitedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PartnershipInvitedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  PartnershipInvitedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartnershipInvitedNotificationCopyWith<PartnershipInvitedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnershipInvitedNotificationCopyWith<$Res> {
  factory $PartnershipInvitedNotificationCopyWith(
          PartnershipInvitedNotification value,
          $Res Function(PartnershipInvitedNotification) then) =
      _$PartnershipInvitedNotificationCopyWithImpl<$Res,
          PartnershipInvitedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      PartnershipInvitedData data,
      DateTime? receivedAt});

  $PartnershipInvitedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PartnershipInvitedNotificationCopyWithImpl<$Res,
        $Val extends PartnershipInvitedNotification>
    implements $PartnershipInvitedNotificationCopyWith<$Res> {
  _$PartnershipInvitedNotificationCopyWithImpl(this._value, this._then);

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
              as PartnershipInvitedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PartnershipInvitedDataCopyWith<$Res> get data {
    return $PartnershipInvitedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartnershipInvitedNotificationImplCopyWith<$Res>
    implements $PartnershipInvitedNotificationCopyWith<$Res> {
  factory _$$PartnershipInvitedNotificationImplCopyWith(
          _$PartnershipInvitedNotificationImpl value,
          $Res Function(_$PartnershipInvitedNotificationImpl) then) =
      __$$PartnershipInvitedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      PartnershipInvitedData data,
      DateTime? receivedAt});

  @override
  $PartnershipInvitedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PartnershipInvitedNotificationImplCopyWithImpl<$Res>
    extends _$PartnershipInvitedNotificationCopyWithImpl<$Res,
        _$PartnershipInvitedNotificationImpl>
    implements _$$PartnershipInvitedNotificationImplCopyWith<$Res> {
  __$$PartnershipInvitedNotificationImplCopyWithImpl(
      _$PartnershipInvitedNotificationImpl _value,
      $Res Function(_$PartnershipInvitedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$PartnershipInvitedNotificationImpl(
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
              as PartnershipInvitedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$PartnershipInvitedNotificationImpl
    implements _PartnershipInvitedNotification {
  const _$PartnershipInvitedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final PartnershipInvitedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'PartnershipInvitedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnershipInvitedNotificationImpl &&
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
  _$$PartnershipInvitedNotificationImplCopyWith<
          _$PartnershipInvitedNotificationImpl>
      get copyWith => __$$PartnershipInvitedNotificationImplCopyWithImpl<
          _$PartnershipInvitedNotificationImpl>(this, _$identity);
}

abstract class _PartnershipInvitedNotification
    implements PartnershipInvitedNotification {
  const factory _PartnershipInvitedNotification(
      {required final String event,
      final String? channel,
      required final PartnershipInvitedData data,
      final DateTime? receivedAt}) = _$PartnershipInvitedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  PartnershipInvitedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$PartnershipInvitedNotificationImplCopyWith<
          _$PartnershipInvitedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

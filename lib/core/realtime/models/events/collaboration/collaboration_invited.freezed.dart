// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaboration_invited.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollaborationInvitedData _$CollaborationInvitedDataFromJson(
    Map<String, dynamic> json) {
  return _CollaborationInvitedData.fromJson(json);
}

/// @nodoc
mixin _$CollaborationInvitedData {
  @JsonKey(name: 'collaborator_id')
  int get collaboratorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'collaborator_uuid')
  String get collaboratorUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_title')
  String? get eventTitle => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_by')
  String? get invitedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaborationInvitedDataCopyWith<CollaborationInvitedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaborationInvitedDataCopyWith<$Res> {
  factory $CollaborationInvitedDataCopyWith(CollaborationInvitedData value,
          $Res Function(CollaborationInvitedData) then) =
      _$CollaborationInvitedDataCopyWithImpl<$Res, CollaborationInvitedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'collaborator_id') int collaboratorId,
      @JsonKey(name: 'collaborator_uuid') String collaboratorUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle,
      String? role,
      @JsonKey(name: 'invited_by') String? invitedBy,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$CollaborationInvitedDataCopyWithImpl<$Res,
        $Val extends CollaborationInvitedData>
    implements $CollaborationInvitedDataCopyWith<$Res> {
  _$CollaborationInvitedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collaboratorId = null,
    Object? collaboratorUuid = null,
    Object? eventId = null,
    Object? eventTitle = freezed,
    Object? role = freezed,
    Object? invitedBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      collaboratorId: null == collaboratorId
          ? _value.collaboratorId
          : collaboratorId // ignore: cast_nullable_to_non_nullable
              as int,
      collaboratorUuid: null == collaboratorUuid
          ? _value.collaboratorUuid
          : collaboratorUuid // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollaborationInvitedDataImplCopyWith<$Res>
    implements $CollaborationInvitedDataCopyWith<$Res> {
  factory _$$CollaborationInvitedDataImplCopyWith(
          _$CollaborationInvitedDataImpl value,
          $Res Function(_$CollaborationInvitedDataImpl) then) =
      __$$CollaborationInvitedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'collaborator_id') int collaboratorId,
      @JsonKey(name: 'collaborator_uuid') String collaboratorUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle,
      String? role,
      @JsonKey(name: 'invited_by') String? invitedBy,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$CollaborationInvitedDataImplCopyWithImpl<$Res>
    extends _$CollaborationInvitedDataCopyWithImpl<$Res,
        _$CollaborationInvitedDataImpl>
    implements _$$CollaborationInvitedDataImplCopyWith<$Res> {
  __$$CollaborationInvitedDataImplCopyWithImpl(
      _$CollaborationInvitedDataImpl _value,
      $Res Function(_$CollaborationInvitedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collaboratorId = null,
    Object? collaboratorUuid = null,
    Object? eventId = null,
    Object? eventTitle = freezed,
    Object? role = freezed,
    Object? invitedBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$CollaborationInvitedDataImpl(
      collaboratorId: null == collaboratorId
          ? _value.collaboratorId
          : collaboratorId // ignore: cast_nullable_to_non_nullable
              as int,
      collaboratorUuid: null == collaboratorUuid
          ? _value.collaboratorUuid
          : collaboratorUuid // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$CollaborationInvitedDataImpl implements _CollaborationInvitedData {
  const _$CollaborationInvitedDataImpl(
      {@JsonKey(name: 'collaborator_id') required this.collaboratorId,
      @JsonKey(name: 'collaborator_uuid') required this.collaboratorUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'event_title') this.eventTitle,
      this.role,
      @JsonKey(name: 'invited_by') this.invitedBy,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$CollaborationInvitedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollaborationInvitedDataImplFromJson(json);

  @override
  @JsonKey(name: 'collaborator_id')
  final int collaboratorId;
  @override
  @JsonKey(name: 'collaborator_uuid')
  final String collaboratorUuid;
  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'event_title')
  final String? eventTitle;
  @override
  final String? role;
  @override
  @JsonKey(name: 'invited_by')
  final String? invitedBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CollaborationInvitedData(collaboratorId: $collaboratorId, collaboratorUuid: $collaboratorUuid, eventId: $eventId, eventTitle: $eventTitle, role: $role, invitedBy: $invitedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaborationInvitedDataImpl &&
            (identical(other.collaboratorId, collaboratorId) ||
                other.collaboratorId == collaboratorId) &&
            (identical(other.collaboratorUuid, collaboratorUuid) ||
                other.collaboratorUuid == collaboratorUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, collaboratorId, collaboratorUuid,
      eventId, eventTitle, role, invitedBy, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollaborationInvitedDataImplCopyWith<_$CollaborationInvitedDataImpl>
      get copyWith => __$$CollaborationInvitedDataImplCopyWithImpl<
          _$CollaborationInvitedDataImpl>(this, _$identity);
}

abstract class _CollaborationInvitedData implements CollaborationInvitedData {
  const factory _CollaborationInvitedData(
          {@JsonKey(name: 'collaborator_id') required final int collaboratorId,
          @JsonKey(name: 'collaborator_uuid')
          required final String collaboratorUuid,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'event_title') final String? eventTitle,
          final String? role,
          @JsonKey(name: 'invited_by') final String? invitedBy,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$CollaborationInvitedDataImpl;

  factory _CollaborationInvitedData.fromJson(Map<String, dynamic> json) =
      _$CollaborationInvitedDataImpl.fromJson;

  @override
  @JsonKey(name: 'collaborator_id')
  int get collaboratorId;
  @override
  @JsonKey(name: 'collaborator_uuid')
  String get collaboratorUuid;
  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'event_title')
  String? get eventTitle;
  @override
  String? get role;
  @override
  @JsonKey(name: 'invited_by')
  String? get invitedBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CollaborationInvitedDataImplCopyWith<_$CollaborationInvitedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CollaborationInvitedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  CollaborationInvitedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaborationInvitedNotificationCopyWith<CollaborationInvitedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaborationInvitedNotificationCopyWith<$Res> {
  factory $CollaborationInvitedNotificationCopyWith(
          CollaborationInvitedNotification value,
          $Res Function(CollaborationInvitedNotification) then) =
      _$CollaborationInvitedNotificationCopyWithImpl<$Res,
          CollaborationInvitedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaborationInvitedData data,
      DateTime? receivedAt});

  $CollaborationInvitedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CollaborationInvitedNotificationCopyWithImpl<$Res,
        $Val extends CollaborationInvitedNotification>
    implements $CollaborationInvitedNotificationCopyWith<$Res> {
  _$CollaborationInvitedNotificationCopyWithImpl(this._value, this._then);

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
              as CollaborationInvitedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CollaborationInvitedDataCopyWith<$Res> get data {
    return $CollaborationInvitedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollaborationInvitedNotificationImplCopyWith<$Res>
    implements $CollaborationInvitedNotificationCopyWith<$Res> {
  factory _$$CollaborationInvitedNotificationImplCopyWith(
          _$CollaborationInvitedNotificationImpl value,
          $Res Function(_$CollaborationInvitedNotificationImpl) then) =
      __$$CollaborationInvitedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaborationInvitedData data,
      DateTime? receivedAt});

  @override
  $CollaborationInvitedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CollaborationInvitedNotificationImplCopyWithImpl<$Res>
    extends _$CollaborationInvitedNotificationCopyWithImpl<$Res,
        _$CollaborationInvitedNotificationImpl>
    implements _$$CollaborationInvitedNotificationImplCopyWith<$Res> {
  __$$CollaborationInvitedNotificationImplCopyWithImpl(
      _$CollaborationInvitedNotificationImpl _value,
      $Res Function(_$CollaborationInvitedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$CollaborationInvitedNotificationImpl(
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
              as CollaborationInvitedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CollaborationInvitedNotificationImpl
    implements _CollaborationInvitedNotification {
  const _$CollaborationInvitedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final CollaborationInvitedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'CollaborationInvitedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaborationInvitedNotificationImpl &&
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
  _$$CollaborationInvitedNotificationImplCopyWith<
          _$CollaborationInvitedNotificationImpl>
      get copyWith => __$$CollaborationInvitedNotificationImplCopyWithImpl<
          _$CollaborationInvitedNotificationImpl>(this, _$identity);
}

abstract class _CollaborationInvitedNotification
    implements CollaborationInvitedNotification {
  const factory _CollaborationInvitedNotification(
      {required final String event,
      final String? channel,
      required final CollaborationInvitedData data,
      final DateTime? receivedAt}) = _$CollaborationInvitedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  CollaborationInvitedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$CollaborationInvitedNotificationImplCopyWith<
          _$CollaborationInvitedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

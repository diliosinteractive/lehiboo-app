// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaborator_invitation_declined.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollaboratorInvitationDeclinedData _$CollaboratorInvitationDeclinedDataFromJson(
    Map<String, dynamic> json) {
  return _CollaboratorInvitationDeclinedData.fromJson(json);
}

/// @nodoc
mixin _$CollaboratorInvitationDeclinedData {
  @JsonKey(name: 'invitation_id')
  int get invitationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invitation_uuid')
  String get invitationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_title')
  String? get eventTitle => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaboratorInvitationDeclinedDataCopyWith<
          CollaboratorInvitationDeclinedData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaboratorInvitationDeclinedDataCopyWith<$Res> {
  factory $CollaboratorInvitationDeclinedDataCopyWith(
          CollaboratorInvitationDeclinedData value,
          $Res Function(CollaboratorInvitationDeclinedData) then) =
      _$CollaboratorInvitationDeclinedDataCopyWithImpl<$Res,
          CollaboratorInvitationDeclinedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'invitation_id') int invitationId,
      @JsonKey(name: 'invitation_uuid') String invitationUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle,
      String email,
      String? role});
}

/// @nodoc
class _$CollaboratorInvitationDeclinedDataCopyWithImpl<$Res,
        $Val extends CollaboratorInvitationDeclinedData>
    implements $CollaboratorInvitationDeclinedDataCopyWith<$Res> {
  _$CollaboratorInvitationDeclinedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invitationId = null,
    Object? invitationUuid = null,
    Object? eventId = null,
    Object? eventTitle = freezed,
    Object? email = null,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
      invitationId: null == invitationId
          ? _value.invitationId
          : invitationId // ignore: cast_nullable_to_non_nullable
              as int,
      invitationUuid: null == invitationUuid
          ? _value.invitationUuid
          : invitationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollaboratorInvitationDeclinedDataImplCopyWith<$Res>
    implements $CollaboratorInvitationDeclinedDataCopyWith<$Res> {
  factory _$$CollaboratorInvitationDeclinedDataImplCopyWith(
          _$CollaboratorInvitationDeclinedDataImpl value,
          $Res Function(_$CollaboratorInvitationDeclinedDataImpl) then) =
      __$$CollaboratorInvitationDeclinedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'invitation_id') int invitationId,
      @JsonKey(name: 'invitation_uuid') String invitationUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle,
      String email,
      String? role});
}

/// @nodoc
class __$$CollaboratorInvitationDeclinedDataImplCopyWithImpl<$Res>
    extends _$CollaboratorInvitationDeclinedDataCopyWithImpl<$Res,
        _$CollaboratorInvitationDeclinedDataImpl>
    implements _$$CollaboratorInvitationDeclinedDataImplCopyWith<$Res> {
  __$$CollaboratorInvitationDeclinedDataImplCopyWithImpl(
      _$CollaboratorInvitationDeclinedDataImpl _value,
      $Res Function(_$CollaboratorInvitationDeclinedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invitationId = null,
    Object? invitationUuid = null,
    Object? eventId = null,
    Object? eventTitle = freezed,
    Object? email = null,
    Object? role = freezed,
  }) {
    return _then(_$CollaboratorInvitationDeclinedDataImpl(
      invitationId: null == invitationId
          ? _value.invitationId
          : invitationId // ignore: cast_nullable_to_non_nullable
              as int,
      invitationUuid: null == invitationUuid
          ? _value.invitationUuid
          : invitationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$CollaboratorInvitationDeclinedDataImpl
    implements _CollaboratorInvitationDeclinedData {
  const _$CollaboratorInvitationDeclinedDataImpl(
      {@JsonKey(name: 'invitation_id') required this.invitationId,
      @JsonKey(name: 'invitation_uuid') required this.invitationUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'event_title') this.eventTitle,
      required this.email,
      this.role});

  factory _$CollaboratorInvitationDeclinedDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CollaboratorInvitationDeclinedDataImplFromJson(json);

  @override
  @JsonKey(name: 'invitation_id')
  final int invitationId;
  @override
  @JsonKey(name: 'invitation_uuid')
  final String invitationUuid;
  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'event_title')
  final String? eventTitle;
  @override
  final String email;
  @override
  final String? role;

  @override
  String toString() {
    return 'CollaboratorInvitationDeclinedData(invitationId: $invitationId, invitationUuid: $invitationUuid, eventId: $eventId, eventTitle: $eventTitle, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaboratorInvitationDeclinedDataImpl &&
            (identical(other.invitationId, invitationId) ||
                other.invitationId == invitationId) &&
            (identical(other.invitationUuid, invitationUuid) ||
                other.invitationUuid == invitationUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, invitationId, invitationUuid,
      eventId, eventTitle, email, role);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollaboratorInvitationDeclinedDataImplCopyWith<
          _$CollaboratorInvitationDeclinedDataImpl>
      get copyWith => __$$CollaboratorInvitationDeclinedDataImplCopyWithImpl<
          _$CollaboratorInvitationDeclinedDataImpl>(this, _$identity);
}

abstract class _CollaboratorInvitationDeclinedData
    implements CollaboratorInvitationDeclinedData {
  const factory _CollaboratorInvitationDeclinedData(
      {@JsonKey(name: 'invitation_id') required final int invitationId,
      @JsonKey(name: 'invitation_uuid') required final String invitationUuid,
      @JsonKey(name: 'event_id') required final int eventId,
      @JsonKey(name: 'event_title') final String? eventTitle,
      required final String email,
      final String? role}) = _$CollaboratorInvitationDeclinedDataImpl;

  factory _CollaboratorInvitationDeclinedData.fromJson(
          Map<String, dynamic> json) =
      _$CollaboratorInvitationDeclinedDataImpl.fromJson;

  @override
  @JsonKey(name: 'invitation_id')
  int get invitationId;
  @override
  @JsonKey(name: 'invitation_uuid')
  String get invitationUuid;
  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'event_title')
  String? get eventTitle;
  @override
  String get email;
  @override
  String? get role;
  @override
  @JsonKey(ignore: true)
  _$$CollaboratorInvitationDeclinedDataImplCopyWith<
          _$CollaboratorInvitationDeclinedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CollaboratorInvitationDeclinedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  CollaboratorInvitationDeclinedData get data =>
      throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaboratorInvitationDeclinedNotificationCopyWith<
          CollaboratorInvitationDeclinedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaboratorInvitationDeclinedNotificationCopyWith<$Res> {
  factory $CollaboratorInvitationDeclinedNotificationCopyWith(
          CollaboratorInvitationDeclinedNotification value,
          $Res Function(CollaboratorInvitationDeclinedNotification) then) =
      _$CollaboratorInvitationDeclinedNotificationCopyWithImpl<$Res,
          CollaboratorInvitationDeclinedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaboratorInvitationDeclinedData data,
      DateTime? receivedAt});

  $CollaboratorInvitationDeclinedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CollaboratorInvitationDeclinedNotificationCopyWithImpl<$Res,
        $Val extends CollaboratorInvitationDeclinedNotification>
    implements $CollaboratorInvitationDeclinedNotificationCopyWith<$Res> {
  _$CollaboratorInvitationDeclinedNotificationCopyWithImpl(
      this._value, this._then);

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
              as CollaboratorInvitationDeclinedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CollaboratorInvitationDeclinedDataCopyWith<$Res> get data {
    return $CollaboratorInvitationDeclinedDataCopyWith<$Res>(_value.data,
        (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollaboratorInvitationDeclinedNotificationImplCopyWith<$Res>
    implements $CollaboratorInvitationDeclinedNotificationCopyWith<$Res> {
  factory _$$CollaboratorInvitationDeclinedNotificationImplCopyWith(
          _$CollaboratorInvitationDeclinedNotificationImpl value,
          $Res Function(_$CollaboratorInvitationDeclinedNotificationImpl)
              then) =
      __$$CollaboratorInvitationDeclinedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaboratorInvitationDeclinedData data,
      DateTime? receivedAt});

  @override
  $CollaboratorInvitationDeclinedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CollaboratorInvitationDeclinedNotificationImplCopyWithImpl<$Res>
    extends _$CollaboratorInvitationDeclinedNotificationCopyWithImpl<$Res,
        _$CollaboratorInvitationDeclinedNotificationImpl>
    implements _$$CollaboratorInvitationDeclinedNotificationImplCopyWith<$Res> {
  __$$CollaboratorInvitationDeclinedNotificationImplCopyWithImpl(
      _$CollaboratorInvitationDeclinedNotificationImpl _value,
      $Res Function(_$CollaboratorInvitationDeclinedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$CollaboratorInvitationDeclinedNotificationImpl(
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
              as CollaboratorInvitationDeclinedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CollaboratorInvitationDeclinedNotificationImpl
    implements _CollaboratorInvitationDeclinedNotification {
  const _$CollaboratorInvitationDeclinedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final CollaboratorInvitationDeclinedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'CollaboratorInvitationDeclinedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaboratorInvitationDeclinedNotificationImpl &&
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
  _$$CollaboratorInvitationDeclinedNotificationImplCopyWith<
          _$CollaboratorInvitationDeclinedNotificationImpl>
      get copyWith =>
          __$$CollaboratorInvitationDeclinedNotificationImplCopyWithImpl<
                  _$CollaboratorInvitationDeclinedNotificationImpl>(
              this, _$identity);
}

abstract class _CollaboratorInvitationDeclinedNotification
    implements CollaboratorInvitationDeclinedNotification {
  const factory _CollaboratorInvitationDeclinedNotification(
          {required final String event,
          final String? channel,
          required final CollaboratorInvitationDeclinedData data,
          final DateTime? receivedAt}) =
      _$CollaboratorInvitationDeclinedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  CollaboratorInvitationDeclinedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$CollaboratorInvitationDeclinedNotificationImplCopyWith<
          _$CollaboratorInvitationDeclinedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

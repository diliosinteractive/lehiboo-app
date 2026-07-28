// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaboration_accepted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollaborationAcceptedData _$CollaborationAcceptedDataFromJson(
    Map<String, dynamic> json) {
  return _CollaborationAcceptedData.fromJson(json);
}

/// @nodoc
mixin _$CollaborationAcceptedData {
  @JsonKey(name: 'collaborator_id')
  int get collaboratorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'collaborator_uuid')
  String get collaboratorUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_title')
  String? get eventTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_id')
  int? get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name')
  String? get organizationName => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaborationAcceptedDataCopyWith<CollaborationAcceptedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaborationAcceptedDataCopyWith<$Res> {
  factory $CollaborationAcceptedDataCopyWith(CollaborationAcceptedData value,
          $Res Function(CollaborationAcceptedData) then) =
      _$CollaborationAcceptedDataCopyWithImpl<$Res, CollaborationAcceptedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'collaborator_id') int collaboratorId,
      @JsonKey(name: 'collaborator_uuid') String collaboratorUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle,
      @JsonKey(name: 'organization_id') int? organizationId,
      @JsonKey(name: 'organization_name') String? organizationName,
      String? role,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt});
}

/// @nodoc
class _$CollaborationAcceptedDataCopyWithImpl<$Res,
        $Val extends CollaborationAcceptedData>
    implements $CollaborationAcceptedDataCopyWith<$Res> {
  _$CollaborationAcceptedDataCopyWithImpl(this._value, this._then);

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
    Object? organizationId = freezed,
    Object? organizationName = freezed,
    Object? role = freezed,
    Object? acceptedAt = freezed,
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
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollaborationAcceptedDataImplCopyWith<$Res>
    implements $CollaborationAcceptedDataCopyWith<$Res> {
  factory _$$CollaborationAcceptedDataImplCopyWith(
          _$CollaborationAcceptedDataImpl value,
          $Res Function(_$CollaborationAcceptedDataImpl) then) =
      __$$CollaborationAcceptedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'collaborator_id') int collaboratorId,
      @JsonKey(name: 'collaborator_uuid') String collaboratorUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle,
      @JsonKey(name: 'organization_id') int? organizationId,
      @JsonKey(name: 'organization_name') String? organizationName,
      String? role,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt});
}

/// @nodoc
class __$$CollaborationAcceptedDataImplCopyWithImpl<$Res>
    extends _$CollaborationAcceptedDataCopyWithImpl<$Res,
        _$CollaborationAcceptedDataImpl>
    implements _$$CollaborationAcceptedDataImplCopyWith<$Res> {
  __$$CollaborationAcceptedDataImplCopyWithImpl(
      _$CollaborationAcceptedDataImpl _value,
      $Res Function(_$CollaborationAcceptedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collaboratorId = null,
    Object? collaboratorUuid = null,
    Object? eventId = null,
    Object? eventTitle = freezed,
    Object? organizationId = freezed,
    Object? organizationName = freezed,
    Object? role = freezed,
    Object? acceptedAt = freezed,
  }) {
    return _then(_$CollaborationAcceptedDataImpl(
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
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$CollaborationAcceptedDataImpl implements _CollaborationAcceptedData {
  const _$CollaborationAcceptedDataImpl(
      {@JsonKey(name: 'collaborator_id') required this.collaboratorId,
      @JsonKey(name: 'collaborator_uuid') required this.collaboratorUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'event_title') this.eventTitle,
      @JsonKey(name: 'organization_id') this.organizationId,
      @JsonKey(name: 'organization_name') this.organizationName,
      this.role,
      @JsonKey(name: 'accepted_at') this.acceptedAt});

  factory _$CollaborationAcceptedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollaborationAcceptedDataImplFromJson(json);

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
  @JsonKey(name: 'organization_id')
  final int? organizationId;
  @override
  @JsonKey(name: 'organization_name')
  final String? organizationName;
  @override
  final String? role;
  @override
  @JsonKey(name: 'accepted_at')
  final DateTime? acceptedAt;

  @override
  String toString() {
    return 'CollaborationAcceptedData(collaboratorId: $collaboratorId, collaboratorUuid: $collaboratorUuid, eventId: $eventId, eventTitle: $eventTitle, organizationId: $organizationId, organizationName: $organizationName, role: $role, acceptedAt: $acceptedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaborationAcceptedDataImpl &&
            (identical(other.collaboratorId, collaboratorId) ||
                other.collaboratorId == collaboratorId) &&
            (identical(other.collaboratorUuid, collaboratorUuid) ||
                other.collaboratorUuid == collaboratorUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, collaboratorId, collaboratorUuid,
      eventId, eventTitle, organizationId, organizationName, role, acceptedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollaborationAcceptedDataImplCopyWith<_$CollaborationAcceptedDataImpl>
      get copyWith => __$$CollaborationAcceptedDataImplCopyWithImpl<
          _$CollaborationAcceptedDataImpl>(this, _$identity);
}

abstract class _CollaborationAcceptedData implements CollaborationAcceptedData {
  const factory _CollaborationAcceptedData(
          {@JsonKey(name: 'collaborator_id') required final int collaboratorId,
          @JsonKey(name: 'collaborator_uuid')
          required final String collaboratorUuid,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'event_title') final String? eventTitle,
          @JsonKey(name: 'organization_id') final int? organizationId,
          @JsonKey(name: 'organization_name') final String? organizationName,
          final String? role,
          @JsonKey(name: 'accepted_at') final DateTime? acceptedAt}) =
      _$CollaborationAcceptedDataImpl;

  factory _CollaborationAcceptedData.fromJson(Map<String, dynamic> json) =
      _$CollaborationAcceptedDataImpl.fromJson;

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
  @JsonKey(name: 'organization_id')
  int? get organizationId;
  @override
  @JsonKey(name: 'organization_name')
  String? get organizationName;
  @override
  String? get role;
  @override
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt;
  @override
  @JsonKey(ignore: true)
  _$$CollaborationAcceptedDataImplCopyWith<_$CollaborationAcceptedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CollaborationAcceptedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  CollaborationAcceptedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaborationAcceptedNotificationCopyWith<CollaborationAcceptedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaborationAcceptedNotificationCopyWith<$Res> {
  factory $CollaborationAcceptedNotificationCopyWith(
          CollaborationAcceptedNotification value,
          $Res Function(CollaborationAcceptedNotification) then) =
      _$CollaborationAcceptedNotificationCopyWithImpl<$Res,
          CollaborationAcceptedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaborationAcceptedData data,
      DateTime? receivedAt});

  $CollaborationAcceptedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CollaborationAcceptedNotificationCopyWithImpl<$Res,
        $Val extends CollaborationAcceptedNotification>
    implements $CollaborationAcceptedNotificationCopyWith<$Res> {
  _$CollaborationAcceptedNotificationCopyWithImpl(this._value, this._then);

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
              as CollaborationAcceptedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CollaborationAcceptedDataCopyWith<$Res> get data {
    return $CollaborationAcceptedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollaborationAcceptedNotificationImplCopyWith<$Res>
    implements $CollaborationAcceptedNotificationCopyWith<$Res> {
  factory _$$CollaborationAcceptedNotificationImplCopyWith(
          _$CollaborationAcceptedNotificationImpl value,
          $Res Function(_$CollaborationAcceptedNotificationImpl) then) =
      __$$CollaborationAcceptedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaborationAcceptedData data,
      DateTime? receivedAt});

  @override
  $CollaborationAcceptedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CollaborationAcceptedNotificationImplCopyWithImpl<$Res>
    extends _$CollaborationAcceptedNotificationCopyWithImpl<$Res,
        _$CollaborationAcceptedNotificationImpl>
    implements _$$CollaborationAcceptedNotificationImplCopyWith<$Res> {
  __$$CollaborationAcceptedNotificationImplCopyWithImpl(
      _$CollaborationAcceptedNotificationImpl _value,
      $Res Function(_$CollaborationAcceptedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$CollaborationAcceptedNotificationImpl(
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
              as CollaborationAcceptedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CollaborationAcceptedNotificationImpl
    implements _CollaborationAcceptedNotification {
  const _$CollaborationAcceptedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final CollaborationAcceptedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'CollaborationAcceptedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaborationAcceptedNotificationImpl &&
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
  _$$CollaborationAcceptedNotificationImplCopyWith<
          _$CollaborationAcceptedNotificationImpl>
      get copyWith => __$$CollaborationAcceptedNotificationImplCopyWithImpl<
          _$CollaborationAcceptedNotificationImpl>(this, _$identity);
}

abstract class _CollaborationAcceptedNotification
    implements CollaborationAcceptedNotification {
  const factory _CollaborationAcceptedNotification(
      {required final String event,
      final String? channel,
      required final CollaborationAcceptedData data,
      final DateTime? receivedAt}) = _$CollaborationAcceptedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  CollaborationAcceptedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$CollaborationAcceptedNotificationImplCopyWith<
          _$CollaborationAcceptedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

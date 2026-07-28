// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaboration_removed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollaborationRemovedData _$CollaborationRemovedDataFromJson(
    Map<String, dynamic> json) {
  return _CollaborationRemovedData.fromJson(json);
}

/// @nodoc
mixin _$CollaborationRemovedData {
  @JsonKey(name: 'collaborator_id')
  int get collaboratorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'collaborator_uuid')
  String get collaboratorUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_title')
  String? get eventTitle => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaborationRemovedDataCopyWith<CollaborationRemovedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaborationRemovedDataCopyWith<$Res> {
  factory $CollaborationRemovedDataCopyWith(CollaborationRemovedData value,
          $Res Function(CollaborationRemovedData) then) =
      _$CollaborationRemovedDataCopyWithImpl<$Res, CollaborationRemovedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'collaborator_id') int collaboratorId,
      @JsonKey(name: 'collaborator_uuid') String collaboratorUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle});
}

/// @nodoc
class _$CollaborationRemovedDataCopyWithImpl<$Res,
        $Val extends CollaborationRemovedData>
    implements $CollaborationRemovedDataCopyWith<$Res> {
  _$CollaborationRemovedDataCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollaborationRemovedDataImplCopyWith<$Res>
    implements $CollaborationRemovedDataCopyWith<$Res> {
  factory _$$CollaborationRemovedDataImplCopyWith(
          _$CollaborationRemovedDataImpl value,
          $Res Function(_$CollaborationRemovedDataImpl) then) =
      __$$CollaborationRemovedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'collaborator_id') int collaboratorId,
      @JsonKey(name: 'collaborator_uuid') String collaboratorUuid,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_title') String? eventTitle});
}

/// @nodoc
class __$$CollaborationRemovedDataImplCopyWithImpl<$Res>
    extends _$CollaborationRemovedDataCopyWithImpl<$Res,
        _$CollaborationRemovedDataImpl>
    implements _$$CollaborationRemovedDataImplCopyWith<$Res> {
  __$$CollaborationRemovedDataImplCopyWithImpl(
      _$CollaborationRemovedDataImpl _value,
      $Res Function(_$CollaborationRemovedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collaboratorId = null,
    Object? collaboratorUuid = null,
    Object? eventId = null,
    Object? eventTitle = freezed,
  }) {
    return _then(_$CollaborationRemovedDataImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$CollaborationRemovedDataImpl implements _CollaborationRemovedData {
  const _$CollaborationRemovedDataImpl(
      {@JsonKey(name: 'collaborator_id') required this.collaboratorId,
      @JsonKey(name: 'collaborator_uuid') required this.collaboratorUuid,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'event_title') this.eventTitle});

  factory _$CollaborationRemovedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollaborationRemovedDataImplFromJson(json);

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
  String toString() {
    return 'CollaborationRemovedData(collaboratorId: $collaboratorId, collaboratorUuid: $collaboratorUuid, eventId: $eventId, eventTitle: $eventTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaborationRemovedDataImpl &&
            (identical(other.collaboratorId, collaboratorId) ||
                other.collaboratorId == collaboratorId) &&
            (identical(other.collaboratorUuid, collaboratorUuid) ||
                other.collaboratorUuid == collaboratorUuid) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, collaboratorId, collaboratorUuid, eventId, eventTitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollaborationRemovedDataImplCopyWith<_$CollaborationRemovedDataImpl>
      get copyWith => __$$CollaborationRemovedDataImplCopyWithImpl<
          _$CollaborationRemovedDataImpl>(this, _$identity);
}

abstract class _CollaborationRemovedData implements CollaborationRemovedData {
  const factory _CollaborationRemovedData(
          {@JsonKey(name: 'collaborator_id') required final int collaboratorId,
          @JsonKey(name: 'collaborator_uuid')
          required final String collaboratorUuid,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'event_title') final String? eventTitle}) =
      _$CollaborationRemovedDataImpl;

  factory _CollaborationRemovedData.fromJson(Map<String, dynamic> json) =
      _$CollaborationRemovedDataImpl.fromJson;

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
  @JsonKey(ignore: true)
  _$$CollaborationRemovedDataImplCopyWith<_$CollaborationRemovedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CollaborationRemovedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  CollaborationRemovedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollaborationRemovedNotificationCopyWith<CollaborationRemovedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaborationRemovedNotificationCopyWith<$Res> {
  factory $CollaborationRemovedNotificationCopyWith(
          CollaborationRemovedNotification value,
          $Res Function(CollaborationRemovedNotification) then) =
      _$CollaborationRemovedNotificationCopyWithImpl<$Res,
          CollaborationRemovedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaborationRemovedData data,
      DateTime? receivedAt});

  $CollaborationRemovedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CollaborationRemovedNotificationCopyWithImpl<$Res,
        $Val extends CollaborationRemovedNotification>
    implements $CollaborationRemovedNotificationCopyWith<$Res> {
  _$CollaborationRemovedNotificationCopyWithImpl(this._value, this._then);

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
              as CollaborationRemovedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CollaborationRemovedDataCopyWith<$Res> get data {
    return $CollaborationRemovedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollaborationRemovedNotificationImplCopyWith<$Res>
    implements $CollaborationRemovedNotificationCopyWith<$Res> {
  factory _$$CollaborationRemovedNotificationImplCopyWith(
          _$CollaborationRemovedNotificationImpl value,
          $Res Function(_$CollaborationRemovedNotificationImpl) then) =
      __$$CollaborationRemovedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      CollaborationRemovedData data,
      DateTime? receivedAt});

  @override
  $CollaborationRemovedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CollaborationRemovedNotificationImplCopyWithImpl<$Res>
    extends _$CollaborationRemovedNotificationCopyWithImpl<$Res,
        _$CollaborationRemovedNotificationImpl>
    implements _$$CollaborationRemovedNotificationImplCopyWith<$Res> {
  __$$CollaborationRemovedNotificationImplCopyWithImpl(
      _$CollaborationRemovedNotificationImpl _value,
      $Res Function(_$CollaborationRemovedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$CollaborationRemovedNotificationImpl(
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
              as CollaborationRemovedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CollaborationRemovedNotificationImpl
    implements _CollaborationRemovedNotification {
  const _$CollaborationRemovedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final CollaborationRemovedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'CollaborationRemovedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaborationRemovedNotificationImpl &&
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
  _$$CollaborationRemovedNotificationImplCopyWith<
          _$CollaborationRemovedNotificationImpl>
      get copyWith => __$$CollaborationRemovedNotificationImplCopyWithImpl<
          _$CollaborationRemovedNotificationImpl>(this, _$identity);
}

abstract class _CollaborationRemovedNotification
    implements CollaborationRemovedNotification {
  const factory _CollaborationRemovedNotification(
      {required final String event,
      final String? channel,
      required final CollaborationRemovedData data,
      final DateTime? receivedAt}) = _$CollaborationRemovedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  CollaborationRemovedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$CollaborationRemovedNotificationImplCopyWith<
          _$CollaborationRemovedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

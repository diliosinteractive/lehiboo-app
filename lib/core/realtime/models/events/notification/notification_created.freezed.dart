// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationCreatedData _$NotificationCreatedDataFromJson(
    Map<String, dynamic> json) {
  return _NotificationCreatedData.fromJson(json);
}

/// @nodoc
mixin _$NotificationCreatedData {
  @JsonKey(fromJson: _notificationFromJson)
  InAppNotificationDto get notification => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int? get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'occurred_at')
  DateTime? get occurredAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationCreatedDataCopyWith<NotificationCreatedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationCreatedDataCopyWith<$Res> {
  factory $NotificationCreatedDataCopyWith(NotificationCreatedData value,
          $Res Function(NotificationCreatedData) then) =
      _$NotificationCreatedDataCopyWithImpl<$Res, NotificationCreatedData>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _notificationFromJson)
      InAppNotificationDto notification,
      @JsonKey(name: 'unread_count') int? unreadCount,
      @JsonKey(name: 'occurred_at') DateTime? occurredAt});
}

/// @nodoc
class _$NotificationCreatedDataCopyWithImpl<$Res,
        $Val extends NotificationCreatedData>
    implements $NotificationCreatedDataCopyWith<$Res> {
  _$NotificationCreatedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notification = null,
    Object? unreadCount = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(_value.copyWith(
      notification: null == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as InAppNotificationDto,
      unreadCount: freezed == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int?,
      occurredAt: freezed == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationCreatedDataImplCopyWith<$Res>
    implements $NotificationCreatedDataCopyWith<$Res> {
  factory _$$NotificationCreatedDataImplCopyWith(
          _$NotificationCreatedDataImpl value,
          $Res Function(_$NotificationCreatedDataImpl) then) =
      __$$NotificationCreatedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _notificationFromJson)
      InAppNotificationDto notification,
      @JsonKey(name: 'unread_count') int? unreadCount,
      @JsonKey(name: 'occurred_at') DateTime? occurredAt});
}

/// @nodoc
class __$$NotificationCreatedDataImplCopyWithImpl<$Res>
    extends _$NotificationCreatedDataCopyWithImpl<$Res,
        _$NotificationCreatedDataImpl>
    implements _$$NotificationCreatedDataImplCopyWith<$Res> {
  __$$NotificationCreatedDataImplCopyWithImpl(
      _$NotificationCreatedDataImpl _value,
      $Res Function(_$NotificationCreatedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notification = null,
    Object? unreadCount = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(_$NotificationCreatedDataImpl(
      notification: null == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as InAppNotificationDto,
      unreadCount: freezed == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int?,
      occurredAt: freezed == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$NotificationCreatedDataImpl implements _NotificationCreatedData {
  const _$NotificationCreatedDataImpl(
      {@JsonKey(fromJson: _notificationFromJson) required this.notification,
      @JsonKey(name: 'unread_count') this.unreadCount,
      @JsonKey(name: 'occurred_at') this.occurredAt});

  factory _$NotificationCreatedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationCreatedDataImplFromJson(json);

  @override
  @JsonKey(fromJson: _notificationFromJson)
  final InAppNotificationDto notification;
  @override
  @JsonKey(name: 'unread_count')
  final int? unreadCount;
  @override
  @JsonKey(name: 'occurred_at')
  final DateTime? occurredAt;

  @override
  String toString() {
    return 'NotificationCreatedData(notification: $notification, unreadCount: $unreadCount, occurredAt: $occurredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationCreatedDataImpl &&
            (identical(other.notification, notification) ||
                other.notification == notification) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, notification, unreadCount, occurredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationCreatedDataImplCopyWith<_$NotificationCreatedDataImpl>
      get copyWith => __$$NotificationCreatedDataImplCopyWithImpl<
          _$NotificationCreatedDataImpl>(this, _$identity);
}

abstract class _NotificationCreatedData implements NotificationCreatedData {
  const factory _NotificationCreatedData(
          {@JsonKey(fromJson: _notificationFromJson)
          required final InAppNotificationDto notification,
          @JsonKey(name: 'unread_count') final int? unreadCount,
          @JsonKey(name: 'occurred_at') final DateTime? occurredAt}) =
      _$NotificationCreatedDataImpl;

  factory _NotificationCreatedData.fromJson(Map<String, dynamic> json) =
      _$NotificationCreatedDataImpl.fromJson;

  @override
  @JsonKey(fromJson: _notificationFromJson)
  InAppNotificationDto get notification;
  @override
  @JsonKey(name: 'unread_count')
  int? get unreadCount;
  @override
  @JsonKey(name: 'occurred_at')
  DateTime? get occurredAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationCreatedDataImplCopyWith<_$NotificationCreatedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NotificationCreatedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  NotificationCreatedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationCreatedNotificationCopyWith<NotificationCreatedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationCreatedNotificationCopyWith<$Res> {
  factory $NotificationCreatedNotificationCopyWith(
          NotificationCreatedNotification value,
          $Res Function(NotificationCreatedNotification) then) =
      _$NotificationCreatedNotificationCopyWithImpl<$Res,
          NotificationCreatedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      NotificationCreatedData data,
      DateTime? receivedAt});

  $NotificationCreatedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$NotificationCreatedNotificationCopyWithImpl<$Res,
        $Val extends NotificationCreatedNotification>
    implements $NotificationCreatedNotificationCopyWith<$Res> {
  _$NotificationCreatedNotificationCopyWithImpl(this._value, this._then);

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
              as NotificationCreatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationCreatedDataCopyWith<$Res> get data {
    return $NotificationCreatedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationCreatedNotificationImplCopyWith<$Res>
    implements $NotificationCreatedNotificationCopyWith<$Res> {
  factory _$$NotificationCreatedNotificationImplCopyWith(
          _$NotificationCreatedNotificationImpl value,
          $Res Function(_$NotificationCreatedNotificationImpl) then) =
      __$$NotificationCreatedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      NotificationCreatedData data,
      DateTime? receivedAt});

  @override
  $NotificationCreatedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$NotificationCreatedNotificationImplCopyWithImpl<$Res>
    extends _$NotificationCreatedNotificationCopyWithImpl<$Res,
        _$NotificationCreatedNotificationImpl>
    implements _$$NotificationCreatedNotificationImplCopyWith<$Res> {
  __$$NotificationCreatedNotificationImplCopyWithImpl(
      _$NotificationCreatedNotificationImpl _value,
      $Res Function(_$NotificationCreatedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$NotificationCreatedNotificationImpl(
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
              as NotificationCreatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$NotificationCreatedNotificationImpl
    implements _NotificationCreatedNotification {
  const _$NotificationCreatedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final NotificationCreatedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'NotificationCreatedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationCreatedNotificationImpl &&
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
  _$$NotificationCreatedNotificationImplCopyWith<
          _$NotificationCreatedNotificationImpl>
      get copyWith => __$$NotificationCreatedNotificationImplCopyWithImpl<
          _$NotificationCreatedNotificationImpl>(this, _$identity);
}

abstract class _NotificationCreatedNotification
    implements NotificationCreatedNotification {
  const factory _NotificationCreatedNotification(
      {required final String event,
      final String? channel,
      required final NotificationCreatedData data,
      final DateTime? receivedAt}) = _$NotificationCreatedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  NotificationCreatedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationCreatedNotificationImplCopyWith<
          _$NotificationCreatedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

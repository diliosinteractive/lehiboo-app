// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_cancelled.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventCancelledData _$EventCancelledDataFromJson(Map<String, dynamic> json) {
  return _EventCancelledData.fromJson(json);
}

/// @nodoc
mixin _$EventCancelledData {
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_uuid')
  String get eventUuid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventCancelledDataCopyWith<EventCancelledData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCancelledDataCopyWith<$Res> {
  factory $EventCancelledDataCopyWith(
          EventCancelledData value, $Res Function(EventCancelledData) then) =
      _$EventCancelledDataCopyWithImpl<$Res, EventCancelledData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_uuid') String eventUuid,
      String title,
      String? reason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt});
}

/// @nodoc
class _$EventCancelledDataCopyWithImpl<$Res, $Val extends EventCancelledData>
    implements $EventCancelledDataCopyWith<$Res> {
  _$EventCancelledDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventUuid = null,
    Object? title = null,
    Object? reason = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      eventUuid: null == eventUuid
          ? _value.eventUuid
          : eventUuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCancelledDataImplCopyWith<$Res>
    implements $EventCancelledDataCopyWith<$Res> {
  factory _$$EventCancelledDataImplCopyWith(_$EventCancelledDataImpl value,
          $Res Function(_$EventCancelledDataImpl) then) =
      __$$EventCancelledDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_uuid') String eventUuid,
      String title,
      String? reason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt});
}

/// @nodoc
class __$$EventCancelledDataImplCopyWithImpl<$Res>
    extends _$EventCancelledDataCopyWithImpl<$Res, _$EventCancelledDataImpl>
    implements _$$EventCancelledDataImplCopyWith<$Res> {
  __$$EventCancelledDataImplCopyWithImpl(_$EventCancelledDataImpl _value,
      $Res Function(_$EventCancelledDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventUuid = null,
    Object? title = null,
    Object? reason = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_$EventCancelledDataImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      eventUuid: null == eventUuid
          ? _value.eventUuid
          : eventUuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$EventCancelledDataImpl implements _EventCancelledData {
  const _$EventCancelledDataImpl(
      {@JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'event_uuid') required this.eventUuid,
      required this.title,
      this.reason,
      @JsonKey(name: 'cancelled_at') this.cancelledAt});

  factory _$EventCancelledDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCancelledDataImplFromJson(json);

  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'event_uuid')
  final String eventUuid;
  @override
  final String title;
  @override
  final String? reason;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;

  @override
  String toString() {
    return 'EventCancelledData(eventId: $eventId, eventUuid: $eventUuid, title: $title, reason: $reason, cancelledAt: $cancelledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCancelledDataImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventUuid, eventUuid) ||
                other.eventUuid == eventUuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, eventId, eventUuid, title, reason, cancelledAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCancelledDataImplCopyWith<_$EventCancelledDataImpl> get copyWith =>
      __$$EventCancelledDataImplCopyWithImpl<_$EventCancelledDataImpl>(
          this, _$identity);
}

abstract class _EventCancelledData implements EventCancelledData {
  const factory _EventCancelledData(
          {@JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'event_uuid') required final String eventUuid,
          required final String title,
          final String? reason,
          @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt}) =
      _$EventCancelledDataImpl;

  factory _EventCancelledData.fromJson(Map<String, dynamic> json) =
      _$EventCancelledDataImpl.fromJson;

  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'event_uuid')
  String get eventUuid;
  @override
  String get title;
  @override
  String? get reason;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(ignore: true)
  _$$EventCancelledDataImplCopyWith<_$EventCancelledDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EventCancelledNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  EventCancelledData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventCancelledNotificationCopyWith<EventCancelledNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCancelledNotificationCopyWith<$Res> {
  factory $EventCancelledNotificationCopyWith(EventCancelledNotification value,
          $Res Function(EventCancelledNotification) then) =
      _$EventCancelledNotificationCopyWithImpl<$Res,
          EventCancelledNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      EventCancelledData data,
      DateTime? receivedAt});

  $EventCancelledDataCopyWith<$Res> get data;
}

/// @nodoc
class _$EventCancelledNotificationCopyWithImpl<$Res,
        $Val extends EventCancelledNotification>
    implements $EventCancelledNotificationCopyWith<$Res> {
  _$EventCancelledNotificationCopyWithImpl(this._value, this._then);

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
              as EventCancelledData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCancelledDataCopyWith<$Res> get data {
    return $EventCancelledDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventCancelledNotificationImplCopyWith<$Res>
    implements $EventCancelledNotificationCopyWith<$Res> {
  factory _$$EventCancelledNotificationImplCopyWith(
          _$EventCancelledNotificationImpl value,
          $Res Function(_$EventCancelledNotificationImpl) then) =
      __$$EventCancelledNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      EventCancelledData data,
      DateTime? receivedAt});

  @override
  $EventCancelledDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$EventCancelledNotificationImplCopyWithImpl<$Res>
    extends _$EventCancelledNotificationCopyWithImpl<$Res,
        _$EventCancelledNotificationImpl>
    implements _$$EventCancelledNotificationImplCopyWith<$Res> {
  __$$EventCancelledNotificationImplCopyWithImpl(
      _$EventCancelledNotificationImpl _value,
      $Res Function(_$EventCancelledNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$EventCancelledNotificationImpl(
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
              as EventCancelledData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$EventCancelledNotificationImpl implements _EventCancelledNotification {
  const _$EventCancelledNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final EventCancelledData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'EventCancelledNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCancelledNotificationImpl &&
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
  _$$EventCancelledNotificationImplCopyWith<_$EventCancelledNotificationImpl>
      get copyWith => __$$EventCancelledNotificationImplCopyWithImpl<
          _$EventCancelledNotificationImpl>(this, _$identity);
}

abstract class _EventCancelledNotification
    implements EventCancelledNotification {
  const factory _EventCancelledNotification(
      {required final String event,
      final String? channel,
      required final EventCancelledData data,
      final DateTime? receivedAt}) = _$EventCancelledNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  EventCancelledData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$EventCancelledNotificationImplCopyWith<_$EventCancelledNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_published.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventPublishedData _$EventPublishedDataFromJson(Map<String, dynamic> json) {
  return _EventPublishedData.fromJson(json);
}

/// @nodoc
mixin _$EventPublishedData {
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_uuid')
  String get eventUuid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_id')
  int get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventPublishedDataCopyWith<EventPublishedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventPublishedDataCopyWith<$Res> {
  factory $EventPublishedDataCopyWith(
          EventPublishedData value, $Res Function(EventPublishedData) then) =
      _$EventPublishedDataCopyWithImpl<$Res, EventPublishedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_uuid') String eventUuid,
      String title,
      String slug,
      @JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'published_at') DateTime? publishedAt});
}

/// @nodoc
class _$EventPublishedDataCopyWithImpl<$Res, $Val extends EventPublishedData>
    implements $EventPublishedDataCopyWith<$Res> {
  _$EventPublishedDataCopyWithImpl(this._value, this._then);

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
    Object? slug = null,
    Object? organizationId = null,
    Object? publishedAt = freezed,
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventPublishedDataImplCopyWith<$Res>
    implements $EventPublishedDataCopyWith<$Res> {
  factory _$$EventPublishedDataImplCopyWith(_$EventPublishedDataImpl value,
          $Res Function(_$EventPublishedDataImpl) then) =
      __$$EventPublishedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'event_uuid') String eventUuid,
      String title,
      String slug,
      @JsonKey(name: 'organization_id') int organizationId,
      @JsonKey(name: 'published_at') DateTime? publishedAt});
}

/// @nodoc
class __$$EventPublishedDataImplCopyWithImpl<$Res>
    extends _$EventPublishedDataCopyWithImpl<$Res, _$EventPublishedDataImpl>
    implements _$$EventPublishedDataImplCopyWith<$Res> {
  __$$EventPublishedDataImplCopyWithImpl(_$EventPublishedDataImpl _value,
      $Res Function(_$EventPublishedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventUuid = null,
    Object? title = null,
    Object? slug = null,
    Object? organizationId = null,
    Object? publishedAt = freezed,
  }) {
    return _then(_$EventPublishedDataImpl(
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as int,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$EventPublishedDataImpl implements _EventPublishedData {
  const _$EventPublishedDataImpl(
      {@JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'event_uuid') required this.eventUuid,
      required this.title,
      required this.slug,
      @JsonKey(name: 'organization_id') required this.organizationId,
      @JsonKey(name: 'published_at') this.publishedAt});

  factory _$EventPublishedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventPublishedDataImplFromJson(json);

  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'event_uuid')
  final String eventUuid;
  @override
  final String title;
  @override
  final String slug;
  @override
  @JsonKey(name: 'organization_id')
  final int organizationId;
  @override
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'EventPublishedData(eventId: $eventId, eventUuid: $eventUuid, title: $title, slug: $slug, organizationId: $organizationId, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventPublishedDataImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventUuid, eventUuid) ||
                other.eventUuid == eventUuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, eventUuid, title, slug,
      organizationId, publishedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventPublishedDataImplCopyWith<_$EventPublishedDataImpl> get copyWith =>
      __$$EventPublishedDataImplCopyWithImpl<_$EventPublishedDataImpl>(
          this, _$identity);
}

abstract class _EventPublishedData implements EventPublishedData {
  const factory _EventPublishedData(
          {@JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'event_uuid') required final String eventUuid,
          required final String title,
          required final String slug,
          @JsonKey(name: 'organization_id') required final int organizationId,
          @JsonKey(name: 'published_at') final DateTime? publishedAt}) =
      _$EventPublishedDataImpl;

  factory _EventPublishedData.fromJson(Map<String, dynamic> json) =
      _$EventPublishedDataImpl.fromJson;

  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'event_uuid')
  String get eventUuid;
  @override
  String get title;
  @override
  String get slug;
  @override
  @JsonKey(name: 'organization_id')
  int get organizationId;
  @override
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt;
  @override
  @JsonKey(ignore: true)
  _$$EventPublishedDataImplCopyWith<_$EventPublishedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EventPublishedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  EventPublishedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventPublishedNotificationCopyWith<EventPublishedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventPublishedNotificationCopyWith<$Res> {
  factory $EventPublishedNotificationCopyWith(EventPublishedNotification value,
          $Res Function(EventPublishedNotification) then) =
      _$EventPublishedNotificationCopyWithImpl<$Res,
          EventPublishedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      EventPublishedData data,
      DateTime? receivedAt});

  $EventPublishedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$EventPublishedNotificationCopyWithImpl<$Res,
        $Val extends EventPublishedNotification>
    implements $EventPublishedNotificationCopyWith<$Res> {
  _$EventPublishedNotificationCopyWithImpl(this._value, this._then);

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
              as EventPublishedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventPublishedDataCopyWith<$Res> get data {
    return $EventPublishedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventPublishedNotificationImplCopyWith<$Res>
    implements $EventPublishedNotificationCopyWith<$Res> {
  factory _$$EventPublishedNotificationImplCopyWith(
          _$EventPublishedNotificationImpl value,
          $Res Function(_$EventPublishedNotificationImpl) then) =
      __$$EventPublishedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      EventPublishedData data,
      DateTime? receivedAt});

  @override
  $EventPublishedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$EventPublishedNotificationImplCopyWithImpl<$Res>
    extends _$EventPublishedNotificationCopyWithImpl<$Res,
        _$EventPublishedNotificationImpl>
    implements _$$EventPublishedNotificationImplCopyWith<$Res> {
  __$$EventPublishedNotificationImplCopyWithImpl(
      _$EventPublishedNotificationImpl _value,
      $Res Function(_$EventPublishedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$EventPublishedNotificationImpl(
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
              as EventPublishedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$EventPublishedNotificationImpl implements _EventPublishedNotification {
  const _$EventPublishedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final EventPublishedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'EventPublishedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventPublishedNotificationImpl &&
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
  _$$EventPublishedNotificationImplCopyWith<_$EventPublishedNotificationImpl>
      get copyWith => __$$EventPublishedNotificationImplCopyWithImpl<
          _$EventPublishedNotificationImpl>(this, _$identity);
}

abstract class _EventPublishedNotification
    implements EventPublishedNotification {
  const factory _EventPublishedNotification(
      {required final String event,
      final String? channel,
      required final EventPublishedData data,
      final DateTime? receivedAt}) = _$EventPublishedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  EventPublishedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$EventPublishedNotificationImplCopyWith<_$EventPublishedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

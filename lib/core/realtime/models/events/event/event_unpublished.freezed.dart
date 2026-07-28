// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_unpublished.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventUnpublishedData _$EventUnpublishedDataFromJson(Map<String, dynamic> json) {
  return _EventUnpublishedData.fromJson(json);
}

/// @nodoc
mixin _$EventUnpublishedData {
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  int get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'unpublished_at')
  DateTime? get unpublishedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventUnpublishedDataCopyWith<EventUnpublishedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventUnpublishedDataCopyWith<$Res> {
  factory $EventUnpublishedDataCopyWith(EventUnpublishedData value,
          $Res Function(EventUnpublishedData) then) =
      _$EventUnpublishedDataCopyWithImpl<$Res, EventUnpublishedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      String title,
      String slug,
      @JsonKey(name: 'vendor_id') int vendorId,
      @JsonKey(name: 'unpublished_at') DateTime? unpublishedAt});
}

/// @nodoc
class _$EventUnpublishedDataCopyWithImpl<$Res,
        $Val extends EventUnpublishedData>
    implements $EventUnpublishedDataCopyWith<$Res> {
  _$EventUnpublishedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? title = null,
    Object? slug = null,
    Object? vendorId = null,
    Object? unpublishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as int,
      unpublishedAt: freezed == unpublishedAt
          ? _value.unpublishedAt
          : unpublishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventUnpublishedDataImplCopyWith<$Res>
    implements $EventUnpublishedDataCopyWith<$Res> {
  factory _$$EventUnpublishedDataImplCopyWith(_$EventUnpublishedDataImpl value,
          $Res Function(_$EventUnpublishedDataImpl) then) =
      __$$EventUnpublishedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      String title,
      String slug,
      @JsonKey(name: 'vendor_id') int vendorId,
      @JsonKey(name: 'unpublished_at') DateTime? unpublishedAt});
}

/// @nodoc
class __$$EventUnpublishedDataImplCopyWithImpl<$Res>
    extends _$EventUnpublishedDataCopyWithImpl<$Res, _$EventUnpublishedDataImpl>
    implements _$$EventUnpublishedDataImplCopyWith<$Res> {
  __$$EventUnpublishedDataImplCopyWithImpl(_$EventUnpublishedDataImpl _value,
      $Res Function(_$EventUnpublishedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? title = null,
    Object? slug = null,
    Object? vendorId = null,
    Object? unpublishedAt = freezed,
  }) {
    return _then(_$EventUnpublishedDataImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as int,
      unpublishedAt: freezed == unpublishedAt
          ? _value.unpublishedAt
          : unpublishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$EventUnpublishedDataImpl implements _EventUnpublishedData {
  const _$EventUnpublishedDataImpl(
      {@JsonKey(name: 'event_id') required this.eventId,
      required this.title,
      required this.slug,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'unpublished_at') this.unpublishedAt});

  factory _$EventUnpublishedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventUnpublishedDataImplFromJson(json);

  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  final String title;
  @override
  final String slug;
  @override
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  @override
  @JsonKey(name: 'unpublished_at')
  final DateTime? unpublishedAt;

  @override
  String toString() {
    return 'EventUnpublishedData(eventId: $eventId, title: $title, slug: $slug, vendorId: $vendorId, unpublishedAt: $unpublishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventUnpublishedDataImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.unpublishedAt, unpublishedAt) ||
                other.unpublishedAt == unpublishedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, eventId, title, slug, vendorId, unpublishedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventUnpublishedDataImplCopyWith<_$EventUnpublishedDataImpl>
      get copyWith =>
          __$$EventUnpublishedDataImplCopyWithImpl<_$EventUnpublishedDataImpl>(
              this, _$identity);
}

abstract class _EventUnpublishedData implements EventUnpublishedData {
  const factory _EventUnpublishedData(
          {@JsonKey(name: 'event_id') required final int eventId,
          required final String title,
          required final String slug,
          @JsonKey(name: 'vendor_id') required final int vendorId,
          @JsonKey(name: 'unpublished_at') final DateTime? unpublishedAt}) =
      _$EventUnpublishedDataImpl;

  factory _EventUnpublishedData.fromJson(Map<String, dynamic> json) =
      _$EventUnpublishedDataImpl.fromJson;

  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  String get title;
  @override
  String get slug;
  @override
  @JsonKey(name: 'vendor_id')
  int get vendorId;
  @override
  @JsonKey(name: 'unpublished_at')
  DateTime? get unpublishedAt;
  @override
  @JsonKey(ignore: true)
  _$$EventUnpublishedDataImplCopyWith<_$EventUnpublishedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EventUnpublishedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  EventUnpublishedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventUnpublishedNotificationCopyWith<EventUnpublishedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventUnpublishedNotificationCopyWith<$Res> {
  factory $EventUnpublishedNotificationCopyWith(
          EventUnpublishedNotification value,
          $Res Function(EventUnpublishedNotification) then) =
      _$EventUnpublishedNotificationCopyWithImpl<$Res,
          EventUnpublishedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      EventUnpublishedData data,
      DateTime? receivedAt});

  $EventUnpublishedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$EventUnpublishedNotificationCopyWithImpl<$Res,
        $Val extends EventUnpublishedNotification>
    implements $EventUnpublishedNotificationCopyWith<$Res> {
  _$EventUnpublishedNotificationCopyWithImpl(this._value, this._then);

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
              as EventUnpublishedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventUnpublishedDataCopyWith<$Res> get data {
    return $EventUnpublishedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventUnpublishedNotificationImplCopyWith<$Res>
    implements $EventUnpublishedNotificationCopyWith<$Res> {
  factory _$$EventUnpublishedNotificationImplCopyWith(
          _$EventUnpublishedNotificationImpl value,
          $Res Function(_$EventUnpublishedNotificationImpl) then) =
      __$$EventUnpublishedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      EventUnpublishedData data,
      DateTime? receivedAt});

  @override
  $EventUnpublishedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$EventUnpublishedNotificationImplCopyWithImpl<$Res>
    extends _$EventUnpublishedNotificationCopyWithImpl<$Res,
        _$EventUnpublishedNotificationImpl>
    implements _$$EventUnpublishedNotificationImplCopyWith<$Res> {
  __$$EventUnpublishedNotificationImplCopyWithImpl(
      _$EventUnpublishedNotificationImpl _value,
      $Res Function(_$EventUnpublishedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$EventUnpublishedNotificationImpl(
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
              as EventUnpublishedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$EventUnpublishedNotificationImpl
    implements _EventUnpublishedNotification {
  const _$EventUnpublishedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final EventUnpublishedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'EventUnpublishedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventUnpublishedNotificationImpl &&
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
  _$$EventUnpublishedNotificationImplCopyWith<
          _$EventUnpublishedNotificationImpl>
      get copyWith => __$$EventUnpublishedNotificationImplCopyWithImpl<
          _$EventUnpublishedNotificationImpl>(this, _$identity);
}

abstract class _EventUnpublishedNotification
    implements EventUnpublishedNotification {
  const factory _EventUnpublishedNotification(
      {required final String event,
      final String? channel,
      required final EventUnpublishedData data,
      final DateTime? receivedAt}) = _$EventUnpublishedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  EventUnpublishedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$EventUnpublishedNotificationImplCopyWith<
          _$EventUnpublishedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

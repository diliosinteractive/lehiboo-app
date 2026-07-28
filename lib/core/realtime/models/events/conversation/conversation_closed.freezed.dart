// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_closed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationClosedData _$ConversationClosedDataFromJson(
    Map<String, dynamic> json) {
  return _ConversationClosedData.fromJson(json);
}

/// @nodoc
mixin _$ConversationClosedData {
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'closed_at')
  DateTime? get closedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationClosedDataCopyWith<ConversationClosedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationClosedDataCopyWith<$Res> {
  factory $ConversationClosedDataCopyWith(ConversationClosedData value,
          $Res Function(ConversationClosedData) then) =
      _$ConversationClosedDataCopyWithImpl<$Res, ConversationClosedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'closed_at') DateTime? closedAt});
}

/// @nodoc
class _$ConversationClosedDataCopyWithImpl<$Res,
        $Val extends ConversationClosedData>
    implements $ConversationClosedDataCopyWith<$Res> {
  _$ConversationClosedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? closedAt = freezed,
  }) {
    return _then(_value.copyWith(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationClosedDataImplCopyWith<$Res>
    implements $ConversationClosedDataCopyWith<$Res> {
  factory _$$ConversationClosedDataImplCopyWith(
          _$ConversationClosedDataImpl value,
          $Res Function(_$ConversationClosedDataImpl) then) =
      __$$ConversationClosedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'closed_at') DateTime? closedAt});
}

/// @nodoc
class __$$ConversationClosedDataImplCopyWithImpl<$Res>
    extends _$ConversationClosedDataCopyWithImpl<$Res,
        _$ConversationClosedDataImpl>
    implements _$$ConversationClosedDataImplCopyWith<$Res> {
  __$$ConversationClosedDataImplCopyWithImpl(
      _$ConversationClosedDataImpl _value,
      $Res Function(_$ConversationClosedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? closedAt = freezed,
  }) {
    return _then(_$ConversationClosedDataImpl(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$ConversationClosedDataImpl implements _ConversationClosedData {
  const _$ConversationClosedDataImpl(
      {@JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'closed_at') this.closedAt});

  factory _$ConversationClosedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationClosedDataImplFromJson(json);

  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'closed_at')
  final DateTime? closedAt;

  @override
  String toString() {
    return 'ConversationClosedData(conversationUuid: $conversationUuid, closedAt: $closedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationClosedDataImpl &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, conversationUuid, closedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationClosedDataImplCopyWith<_$ConversationClosedDataImpl>
      get copyWith => __$$ConversationClosedDataImplCopyWithImpl<
          _$ConversationClosedDataImpl>(this, _$identity);
}

abstract class _ConversationClosedData implements ConversationClosedData {
  const factory _ConversationClosedData(
          {@JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          @JsonKey(name: 'closed_at') final DateTime? closedAt}) =
      _$ConversationClosedDataImpl;

  factory _ConversationClosedData.fromJson(Map<String, dynamic> json) =
      _$ConversationClosedDataImpl.fromJson;

  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'closed_at')
  DateTime? get closedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationClosedDataImplCopyWith<_$ConversationClosedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversationClosedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  ConversationClosedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationClosedNotificationCopyWith<ConversationClosedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationClosedNotificationCopyWith<$Res> {
  factory $ConversationClosedNotificationCopyWith(
          ConversationClosedNotification value,
          $Res Function(ConversationClosedNotification) then) =
      _$ConversationClosedNotificationCopyWithImpl<$Res,
          ConversationClosedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationClosedData data,
      DateTime? receivedAt});

  $ConversationClosedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ConversationClosedNotificationCopyWithImpl<$Res,
        $Val extends ConversationClosedNotification>
    implements $ConversationClosedNotificationCopyWith<$Res> {
  _$ConversationClosedNotificationCopyWithImpl(this._value, this._then);

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
              as ConversationClosedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationClosedDataCopyWith<$Res> get data {
    return $ConversationClosedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationClosedNotificationImplCopyWith<$Res>
    implements $ConversationClosedNotificationCopyWith<$Res> {
  factory _$$ConversationClosedNotificationImplCopyWith(
          _$ConversationClosedNotificationImpl value,
          $Res Function(_$ConversationClosedNotificationImpl) then) =
      __$$ConversationClosedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationClosedData data,
      DateTime? receivedAt});

  @override
  $ConversationClosedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ConversationClosedNotificationImplCopyWithImpl<$Res>
    extends _$ConversationClosedNotificationCopyWithImpl<$Res,
        _$ConversationClosedNotificationImpl>
    implements _$$ConversationClosedNotificationImplCopyWith<$Res> {
  __$$ConversationClosedNotificationImplCopyWithImpl(
      _$ConversationClosedNotificationImpl _value,
      $Res Function(_$ConversationClosedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$ConversationClosedNotificationImpl(
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
              as ConversationClosedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ConversationClosedNotificationImpl
    implements _ConversationClosedNotification {
  const _$ConversationClosedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final ConversationClosedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'ConversationClosedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationClosedNotificationImpl &&
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
  _$$ConversationClosedNotificationImplCopyWith<
          _$ConversationClosedNotificationImpl>
      get copyWith => __$$ConversationClosedNotificationImplCopyWithImpl<
          _$ConversationClosedNotificationImpl>(this, _$identity);
}

abstract class _ConversationClosedNotification
    implements ConversationClosedNotification {
  const factory _ConversationClosedNotification(
      {required final String event,
      final String? channel,
      required final ConversationClosedData data,
      final DateTime? receivedAt}) = _$ConversationClosedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  ConversationClosedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationClosedNotificationImplCopyWith<
          _$ConversationClosedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

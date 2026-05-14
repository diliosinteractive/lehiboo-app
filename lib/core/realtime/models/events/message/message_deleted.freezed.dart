// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_deleted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageDeletedData _$MessageDeletedDataFromJson(Map<String, dynamic> json) {
  return _MessageDeletedData.fromJson(json);
}

/// @nodoc
mixin _$MessageDeletedData {
  @JsonKey(name: 'message_uuid')
  String get messageUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageDeletedDataCopyWith<MessageDeletedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDeletedDataCopyWith<$Res> {
  factory $MessageDeletedDataCopyWith(
          MessageDeletedData value, $Res Function(MessageDeletedData) then) =
      _$MessageDeletedDataCopyWithImpl<$Res, MessageDeletedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt});
}

/// @nodoc
class _$MessageDeletedDataCopyWithImpl<$Res, $Val extends MessageDeletedData>
    implements $MessageDeletedDataCopyWith<$Res> {
  _$MessageDeletedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      messageUuid: null == messageUuid
          ? _value.messageUuid
          : messageUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageDeletedDataImplCopyWith<$Res>
    implements $MessageDeletedDataCopyWith<$Res> {
  factory _$$MessageDeletedDataImplCopyWith(_$MessageDeletedDataImpl value,
          $Res Function(_$MessageDeletedDataImpl) then) =
      __$$MessageDeletedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt});
}

/// @nodoc
class __$$MessageDeletedDataImplCopyWithImpl<$Res>
    extends _$MessageDeletedDataCopyWithImpl<$Res, _$MessageDeletedDataImpl>
    implements _$$MessageDeletedDataImplCopyWith<$Res> {
  __$$MessageDeletedDataImplCopyWithImpl(_$MessageDeletedDataImpl _value,
      $Res Function(_$MessageDeletedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_$MessageDeletedDataImpl(
      messageUuid: null == messageUuid
          ? _value.messageUuid
          : messageUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$MessageDeletedDataImpl implements _MessageDeletedData {
  const _$MessageDeletedDataImpl(
      {@JsonKey(name: 'message_uuid') required this.messageUuid,
      @JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'deleted_at') this.deletedAt});

  factory _$MessageDeletedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDeletedDataImplFromJson(json);

  @override
  @JsonKey(name: 'message_uuid')
  final String messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'MessageDeletedData(messageUuid: $messageUuid, conversationUuid: $conversationUuid, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDeletedDataImpl &&
            (identical(other.messageUuid, messageUuid) ||
                other.messageUuid == messageUuid) &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, messageUuid, conversationUuid, deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDeletedDataImplCopyWith<_$MessageDeletedDataImpl> get copyWith =>
      __$$MessageDeletedDataImplCopyWithImpl<_$MessageDeletedDataImpl>(
          this, _$identity);
}

abstract class _MessageDeletedData implements MessageDeletedData {
  const factory _MessageDeletedData(
          {@JsonKey(name: 'message_uuid') required final String messageUuid,
          @JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          @JsonKey(name: 'deleted_at') final DateTime? deletedAt}) =
      _$MessageDeletedDataImpl;

  factory _MessageDeletedData.fromJson(Map<String, dynamic> json) =
      _$MessageDeletedDataImpl.fromJson;

  @override
  @JsonKey(name: 'message_uuid')
  String get messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageDeletedDataImplCopyWith<_$MessageDeletedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MessageDeletedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  MessageDeletedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageDeletedNotificationCopyWith<MessageDeletedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDeletedNotificationCopyWith<$Res> {
  factory $MessageDeletedNotificationCopyWith(MessageDeletedNotification value,
          $Res Function(MessageDeletedNotification) then) =
      _$MessageDeletedNotificationCopyWithImpl<$Res,
          MessageDeletedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageDeletedData data,
      DateTime? receivedAt});

  $MessageDeletedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MessageDeletedNotificationCopyWithImpl<$Res,
        $Val extends MessageDeletedNotification>
    implements $MessageDeletedNotificationCopyWith<$Res> {
  _$MessageDeletedNotificationCopyWithImpl(this._value, this._then);

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
              as MessageDeletedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageDeletedDataCopyWith<$Res> get data {
    return $MessageDeletedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageDeletedNotificationImplCopyWith<$Res>
    implements $MessageDeletedNotificationCopyWith<$Res> {
  factory _$$MessageDeletedNotificationImplCopyWith(
          _$MessageDeletedNotificationImpl value,
          $Res Function(_$MessageDeletedNotificationImpl) then) =
      __$$MessageDeletedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageDeletedData data,
      DateTime? receivedAt});

  @override
  $MessageDeletedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MessageDeletedNotificationImplCopyWithImpl<$Res>
    extends _$MessageDeletedNotificationCopyWithImpl<$Res,
        _$MessageDeletedNotificationImpl>
    implements _$$MessageDeletedNotificationImplCopyWith<$Res> {
  __$$MessageDeletedNotificationImplCopyWithImpl(
      _$MessageDeletedNotificationImpl _value,
      $Res Function(_$MessageDeletedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$MessageDeletedNotificationImpl(
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
              as MessageDeletedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$MessageDeletedNotificationImpl implements _MessageDeletedNotification {
  const _$MessageDeletedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final MessageDeletedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'MessageDeletedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDeletedNotificationImpl &&
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
  _$$MessageDeletedNotificationImplCopyWith<_$MessageDeletedNotificationImpl>
      get copyWith => __$$MessageDeletedNotificationImplCopyWithImpl<
          _$MessageDeletedNotificationImpl>(this, _$identity);
}

abstract class _MessageDeletedNotification
    implements MessageDeletedNotification {
  const factory _MessageDeletedNotification(
      {required final String event,
      final String? channel,
      required final MessageDeletedData data,
      final DateTime? receivedAt}) = _$MessageDeletedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  MessageDeletedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageDeletedNotificationImplCopyWith<_$MessageDeletedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

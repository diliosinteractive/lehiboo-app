// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_edited.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageEditedData _$MessageEditedDataFromJson(Map<String, dynamic> json) {
  return _MessageEditedData.fromJson(json);
}

/// @nodoc
mixin _$MessageEditedData {
  @JsonKey(name: 'message_uuid')
  String get messageUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_at')
  DateTime? get editedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageEditedDataCopyWith<MessageEditedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageEditedDataCopyWith<$Res> {
  factory $MessageEditedDataCopyWith(
          MessageEditedData value, $Res Function(MessageEditedData) then) =
      _$MessageEditedDataCopyWithImpl<$Res, MessageEditedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      String? content,
      @JsonKey(name: 'edited_at') DateTime? editedAt});
}

/// @nodoc
class _$MessageEditedDataCopyWithImpl<$Res, $Val extends MessageEditedData>
    implements $MessageEditedDataCopyWith<$Res> {
  _$MessageEditedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? content = freezed,
    Object? editedAt = freezed,
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
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageEditedDataImplCopyWith<$Res>
    implements $MessageEditedDataCopyWith<$Res> {
  factory _$$MessageEditedDataImplCopyWith(_$MessageEditedDataImpl value,
          $Res Function(_$MessageEditedDataImpl) then) =
      __$$MessageEditedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      String? content,
      @JsonKey(name: 'edited_at') DateTime? editedAt});
}

/// @nodoc
class __$$MessageEditedDataImplCopyWithImpl<$Res>
    extends _$MessageEditedDataCopyWithImpl<$Res, _$MessageEditedDataImpl>
    implements _$$MessageEditedDataImplCopyWith<$Res> {
  __$$MessageEditedDataImplCopyWithImpl(_$MessageEditedDataImpl _value,
      $Res Function(_$MessageEditedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? content = freezed,
    Object? editedAt = freezed,
  }) {
    return _then(_$MessageEditedDataImpl(
      messageUuid: null == messageUuid
          ? _value.messageUuid
          : messageUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$MessageEditedDataImpl implements _MessageEditedData {
  const _$MessageEditedDataImpl(
      {@JsonKey(name: 'message_uuid') required this.messageUuid,
      @JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      this.content,
      @JsonKey(name: 'edited_at') this.editedAt});

  factory _$MessageEditedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageEditedDataImplFromJson(json);

  @override
  @JsonKey(name: 'message_uuid')
  final String messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  final String? content;
  @override
  @JsonKey(name: 'edited_at')
  final DateTime? editedAt;

  @override
  String toString() {
    return 'MessageEditedData(messageUuid: $messageUuid, conversationUuid: $conversationUuid, content: $content, editedAt: $editedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageEditedDataImpl &&
            (identical(other.messageUuid, messageUuid) ||
                other.messageUuid == messageUuid) &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, messageUuid, conversationUuid, content, editedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageEditedDataImplCopyWith<_$MessageEditedDataImpl> get copyWith =>
      __$$MessageEditedDataImplCopyWithImpl<_$MessageEditedDataImpl>(
          this, _$identity);
}

abstract class _MessageEditedData implements MessageEditedData {
  const factory _MessageEditedData(
          {@JsonKey(name: 'message_uuid') required final String messageUuid,
          @JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          final String? content,
          @JsonKey(name: 'edited_at') final DateTime? editedAt}) =
      _$MessageEditedDataImpl;

  factory _MessageEditedData.fromJson(Map<String, dynamic> json) =
      _$MessageEditedDataImpl.fromJson;

  @override
  @JsonKey(name: 'message_uuid')
  String get messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  String? get content;
  @override
  @JsonKey(name: 'edited_at')
  DateTime? get editedAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageEditedDataImplCopyWith<_$MessageEditedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MessageEditedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  MessageEditedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageEditedNotificationCopyWith<MessageEditedNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageEditedNotificationCopyWith<$Res> {
  factory $MessageEditedNotificationCopyWith(MessageEditedNotification value,
          $Res Function(MessageEditedNotification) then) =
      _$MessageEditedNotificationCopyWithImpl<$Res, MessageEditedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageEditedData data,
      DateTime? receivedAt});

  $MessageEditedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MessageEditedNotificationCopyWithImpl<$Res,
        $Val extends MessageEditedNotification>
    implements $MessageEditedNotificationCopyWith<$Res> {
  _$MessageEditedNotificationCopyWithImpl(this._value, this._then);

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
              as MessageEditedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageEditedDataCopyWith<$Res> get data {
    return $MessageEditedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageEditedNotificationImplCopyWith<$Res>
    implements $MessageEditedNotificationCopyWith<$Res> {
  factory _$$MessageEditedNotificationImplCopyWith(
          _$MessageEditedNotificationImpl value,
          $Res Function(_$MessageEditedNotificationImpl) then) =
      __$$MessageEditedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageEditedData data,
      DateTime? receivedAt});

  @override
  $MessageEditedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MessageEditedNotificationImplCopyWithImpl<$Res>
    extends _$MessageEditedNotificationCopyWithImpl<$Res,
        _$MessageEditedNotificationImpl>
    implements _$$MessageEditedNotificationImplCopyWith<$Res> {
  __$$MessageEditedNotificationImplCopyWithImpl(
      _$MessageEditedNotificationImpl _value,
      $Res Function(_$MessageEditedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$MessageEditedNotificationImpl(
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
              as MessageEditedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$MessageEditedNotificationImpl implements _MessageEditedNotification {
  const _$MessageEditedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final MessageEditedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'MessageEditedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageEditedNotificationImpl &&
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
  _$$MessageEditedNotificationImplCopyWith<_$MessageEditedNotificationImpl>
      get copyWith => __$$MessageEditedNotificationImplCopyWithImpl<
          _$MessageEditedNotificationImpl>(this, _$identity);
}

abstract class _MessageEditedNotification implements MessageEditedNotification {
  const factory _MessageEditedNotification(
      {required final String event,
      final String? channel,
      required final MessageEditedData data,
      final DateTime? receivedAt}) = _$MessageEditedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  MessageEditedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageEditedNotificationImplCopyWith<_$MessageEditedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

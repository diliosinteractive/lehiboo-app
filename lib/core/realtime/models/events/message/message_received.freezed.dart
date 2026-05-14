// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_received.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageReceivedData _$MessageReceivedDataFromJson(Map<String, dynamic> json) {
  return _MessageReceivedData.fromJson(json);
}

/// @nodoc
mixin _$MessageReceivedData {
  @JsonKey(name: 'message_uuid')
  String get messageUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_type')
  String? get senderType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_name')
  String? get senderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_preview')
  String? get contentPreview => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_subject')
  String? get conversationSubject => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageReceivedDataCopyWith<MessageReceivedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReceivedDataCopyWith<$Res> {
  factory $MessageReceivedDataCopyWith(
          MessageReceivedData value, $Res Function(MessageReceivedData) then) =
      _$MessageReceivedDataCopyWithImpl<$Res, MessageReceivedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'sender_type') String? senderType,
      @JsonKey(name: 'sender_name') String? senderName,
      @JsonKey(name: 'content_preview') String? contentPreview,
      @JsonKey(name: 'conversation_subject') String? conversationSubject,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$MessageReceivedDataCopyWithImpl<$Res, $Val extends MessageReceivedData>
    implements $MessageReceivedDataCopyWith<$Res> {
  _$MessageReceivedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? senderType = freezed,
    Object? senderName = freezed,
    Object? contentPreview = freezed,
    Object? conversationSubject = freezed,
    Object? createdAt = freezed,
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
      senderType: freezed == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String?,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      contentPreview: freezed == contentPreview
          ? _value.contentPreview
          : contentPreview // ignore: cast_nullable_to_non_nullable
              as String?,
      conversationSubject: freezed == conversationSubject
          ? _value.conversationSubject
          : conversationSubject // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageReceivedDataImplCopyWith<$Res>
    implements $MessageReceivedDataCopyWith<$Res> {
  factory _$$MessageReceivedDataImplCopyWith(_$MessageReceivedDataImpl value,
          $Res Function(_$MessageReceivedDataImpl) then) =
      __$$MessageReceivedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'sender_type') String? senderType,
      @JsonKey(name: 'sender_name') String? senderName,
      @JsonKey(name: 'content_preview') String? contentPreview,
      @JsonKey(name: 'conversation_subject') String? conversationSubject,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$MessageReceivedDataImplCopyWithImpl<$Res>
    extends _$MessageReceivedDataCopyWithImpl<$Res, _$MessageReceivedDataImpl>
    implements _$$MessageReceivedDataImplCopyWith<$Res> {
  __$$MessageReceivedDataImplCopyWithImpl(_$MessageReceivedDataImpl _value,
      $Res Function(_$MessageReceivedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? senderType = freezed,
    Object? senderName = freezed,
    Object? contentPreview = freezed,
    Object? conversationSubject = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MessageReceivedDataImpl(
      messageUuid: null == messageUuid
          ? _value.messageUuid
          : messageUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      senderType: freezed == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String?,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      contentPreview: freezed == contentPreview
          ? _value.contentPreview
          : contentPreview // ignore: cast_nullable_to_non_nullable
              as String?,
      conversationSubject: freezed == conversationSubject
          ? _value.conversationSubject
          : conversationSubject // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$MessageReceivedDataImpl implements _MessageReceivedData {
  const _$MessageReceivedDataImpl(
      {@JsonKey(name: 'message_uuid') required this.messageUuid,
      @JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'sender_type') this.senderType,
      @JsonKey(name: 'sender_name') this.senderName,
      @JsonKey(name: 'content_preview') this.contentPreview,
      @JsonKey(name: 'conversation_subject') this.conversationSubject,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$MessageReceivedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReceivedDataImplFromJson(json);

  @override
  @JsonKey(name: 'message_uuid')
  final String messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'sender_type')
  final String? senderType;
  @override
  @JsonKey(name: 'sender_name')
  final String? senderName;
  @override
  @JsonKey(name: 'content_preview')
  final String? contentPreview;
  @override
  @JsonKey(name: 'conversation_subject')
  final String? conversationSubject;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MessageReceivedData(messageUuid: $messageUuid, conversationUuid: $conversationUuid, senderType: $senderType, senderName: $senderName, contentPreview: $contentPreview, conversationSubject: $conversationSubject, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReceivedDataImpl &&
            (identical(other.messageUuid, messageUuid) ||
                other.messageUuid == messageUuid) &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.senderType, senderType) ||
                other.senderType == senderType) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.contentPreview, contentPreview) ||
                other.contentPreview == contentPreview) &&
            (identical(other.conversationSubject, conversationSubject) ||
                other.conversationSubject == conversationSubject) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, messageUuid, conversationUuid,
      senderType, senderName, contentPreview, conversationSubject, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReceivedDataImplCopyWith<_$MessageReceivedDataImpl> get copyWith =>
      __$$MessageReceivedDataImplCopyWithImpl<_$MessageReceivedDataImpl>(
          this, _$identity);
}

abstract class _MessageReceivedData implements MessageReceivedData {
  const factory _MessageReceivedData(
      {@JsonKey(name: 'message_uuid') required final String messageUuid,
      @JsonKey(name: 'conversation_uuid')
      required final String conversationUuid,
      @JsonKey(name: 'sender_type') final String? senderType,
      @JsonKey(name: 'sender_name') final String? senderName,
      @JsonKey(name: 'content_preview') final String? contentPreview,
      @JsonKey(name: 'conversation_subject') final String? conversationSubject,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$MessageReceivedDataImpl;

  factory _MessageReceivedData.fromJson(Map<String, dynamic> json) =
      _$MessageReceivedDataImpl.fromJson;

  @override
  @JsonKey(name: 'message_uuid')
  String get messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'sender_type')
  String? get senderType;
  @override
  @JsonKey(name: 'sender_name')
  String? get senderName;
  @override
  @JsonKey(name: 'content_preview')
  String? get contentPreview;
  @override
  @JsonKey(name: 'conversation_subject')
  String? get conversationSubject;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageReceivedDataImplCopyWith<_$MessageReceivedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MessageReceivedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  MessageReceivedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageReceivedNotificationCopyWith<MessageReceivedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReceivedNotificationCopyWith<$Res> {
  factory $MessageReceivedNotificationCopyWith(
          MessageReceivedNotification value,
          $Res Function(MessageReceivedNotification) then) =
      _$MessageReceivedNotificationCopyWithImpl<$Res,
          MessageReceivedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageReceivedData data,
      DateTime? receivedAt});

  $MessageReceivedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MessageReceivedNotificationCopyWithImpl<$Res,
        $Val extends MessageReceivedNotification>
    implements $MessageReceivedNotificationCopyWith<$Res> {
  _$MessageReceivedNotificationCopyWithImpl(this._value, this._then);

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
              as MessageReceivedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageReceivedDataCopyWith<$Res> get data {
    return $MessageReceivedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageReceivedNotificationImplCopyWith<$Res>
    implements $MessageReceivedNotificationCopyWith<$Res> {
  factory _$$MessageReceivedNotificationImplCopyWith(
          _$MessageReceivedNotificationImpl value,
          $Res Function(_$MessageReceivedNotificationImpl) then) =
      __$$MessageReceivedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageReceivedData data,
      DateTime? receivedAt});

  @override
  $MessageReceivedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MessageReceivedNotificationImplCopyWithImpl<$Res>
    extends _$MessageReceivedNotificationCopyWithImpl<$Res,
        _$MessageReceivedNotificationImpl>
    implements _$$MessageReceivedNotificationImplCopyWith<$Res> {
  __$$MessageReceivedNotificationImplCopyWithImpl(
      _$MessageReceivedNotificationImpl _value,
      $Res Function(_$MessageReceivedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$MessageReceivedNotificationImpl(
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
              as MessageReceivedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$MessageReceivedNotificationImpl
    implements _MessageReceivedNotification {
  const _$MessageReceivedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final MessageReceivedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'MessageReceivedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReceivedNotificationImpl &&
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
  _$$MessageReceivedNotificationImplCopyWith<_$MessageReceivedNotificationImpl>
      get copyWith => __$$MessageReceivedNotificationImplCopyWithImpl<
          _$MessageReceivedNotificationImpl>(this, _$identity);
}

abstract class _MessageReceivedNotification
    implements MessageReceivedNotification {
  const factory _MessageReceivedNotification(
      {required final String event,
      final String? channel,
      required final MessageReceivedData data,
      final DateTime? receivedAt}) = _$MessageReceivedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  MessageReceivedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageReceivedNotificationImplCopyWith<_$MessageReceivedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

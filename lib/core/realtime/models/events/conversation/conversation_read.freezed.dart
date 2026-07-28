// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_read.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationReadData _$ConversationReadDataFromJson(Map<String, dynamic> json) {
  return _ConversationReadData.fromJson(json);
}

/// @nodoc
mixin _$ConversationReadData {
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'reader_id')
  int get readerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reader_name')
  String? get readerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'messages_read_count')
  int get messagesReadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationReadDataCopyWith<ConversationReadData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationReadDataCopyWith<$Res> {
  factory $ConversationReadDataCopyWith(ConversationReadData value,
          $Res Function(ConversationReadData) then) =
      _$ConversationReadDataCopyWithImpl<$Res, ConversationReadData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'reader_id') int readerId,
      @JsonKey(name: 'reader_name') String? readerName,
      @JsonKey(name: 'messages_read_count') int messagesReadCount,
      @JsonKey(name: 'read_at') DateTime? readAt});
}

/// @nodoc
class _$ConversationReadDataCopyWithImpl<$Res,
        $Val extends ConversationReadData>
    implements $ConversationReadDataCopyWith<$Res> {
  _$ConversationReadDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? readerId = null,
    Object? readerName = freezed,
    Object? messagesReadCount = null,
    Object? readAt = freezed,
  }) {
    return _then(_value.copyWith(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      readerId: null == readerId
          ? _value.readerId
          : readerId // ignore: cast_nullable_to_non_nullable
              as int,
      readerName: freezed == readerName
          ? _value.readerName
          : readerName // ignore: cast_nullable_to_non_nullable
              as String?,
      messagesReadCount: null == messagesReadCount
          ? _value.messagesReadCount
          : messagesReadCount // ignore: cast_nullable_to_non_nullable
              as int,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationReadDataImplCopyWith<$Res>
    implements $ConversationReadDataCopyWith<$Res> {
  factory _$$ConversationReadDataImplCopyWith(_$ConversationReadDataImpl value,
          $Res Function(_$ConversationReadDataImpl) then) =
      __$$ConversationReadDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'reader_id') int readerId,
      @JsonKey(name: 'reader_name') String? readerName,
      @JsonKey(name: 'messages_read_count') int messagesReadCount,
      @JsonKey(name: 'read_at') DateTime? readAt});
}

/// @nodoc
class __$$ConversationReadDataImplCopyWithImpl<$Res>
    extends _$ConversationReadDataCopyWithImpl<$Res, _$ConversationReadDataImpl>
    implements _$$ConversationReadDataImplCopyWith<$Res> {
  __$$ConversationReadDataImplCopyWithImpl(_$ConversationReadDataImpl _value,
      $Res Function(_$ConversationReadDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? readerId = null,
    Object? readerName = freezed,
    Object? messagesReadCount = null,
    Object? readAt = freezed,
  }) {
    return _then(_$ConversationReadDataImpl(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      readerId: null == readerId
          ? _value.readerId
          : readerId // ignore: cast_nullable_to_non_nullable
              as int,
      readerName: freezed == readerName
          ? _value.readerName
          : readerName // ignore: cast_nullable_to_non_nullable
              as String?,
      messagesReadCount: null == messagesReadCount
          ? _value.messagesReadCount
          : messagesReadCount // ignore: cast_nullable_to_non_nullable
              as int,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$ConversationReadDataImpl implements _ConversationReadData {
  const _$ConversationReadDataImpl(
      {@JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'reader_id') required this.readerId,
      @JsonKey(name: 'reader_name') this.readerName,
      @JsonKey(name: 'messages_read_count') this.messagesReadCount = 0,
      @JsonKey(name: 'read_at') this.readAt});

  factory _$ConversationReadDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationReadDataImplFromJson(json);

  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'reader_id')
  final int readerId;
  @override
  @JsonKey(name: 'reader_name')
  final String? readerName;
  @override
  @JsonKey(name: 'messages_read_count')
  final int messagesReadCount;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;

  @override
  String toString() {
    return 'ConversationReadData(conversationUuid: $conversationUuid, readerId: $readerId, readerName: $readerName, messagesReadCount: $messagesReadCount, readAt: $readAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationReadDataImpl &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.readerId, readerId) ||
                other.readerId == readerId) &&
            (identical(other.readerName, readerName) ||
                other.readerName == readerName) &&
            (identical(other.messagesReadCount, messagesReadCount) ||
                other.messagesReadCount == messagesReadCount) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, conversationUuid, readerId,
      readerName, messagesReadCount, readAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationReadDataImplCopyWith<_$ConversationReadDataImpl>
      get copyWith =>
          __$$ConversationReadDataImplCopyWithImpl<_$ConversationReadDataImpl>(
              this, _$identity);
}

abstract class _ConversationReadData implements ConversationReadData {
  const factory _ConversationReadData(
          {@JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          @JsonKey(name: 'reader_id') required final int readerId,
          @JsonKey(name: 'reader_name') final String? readerName,
          @JsonKey(name: 'messages_read_count') final int messagesReadCount,
          @JsonKey(name: 'read_at') final DateTime? readAt}) =
      _$ConversationReadDataImpl;

  factory _ConversationReadData.fromJson(Map<String, dynamic> json) =
      _$ConversationReadDataImpl.fromJson;

  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'reader_id')
  int get readerId;
  @override
  @JsonKey(name: 'reader_name')
  String? get readerName;
  @override
  @JsonKey(name: 'messages_read_count')
  int get messagesReadCount;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationReadDataImplCopyWith<_$ConversationReadDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversationReadNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  ConversationReadData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationReadNotificationCopyWith<ConversationReadNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationReadNotificationCopyWith<$Res> {
  factory $ConversationReadNotificationCopyWith(
          ConversationReadNotification value,
          $Res Function(ConversationReadNotification) then) =
      _$ConversationReadNotificationCopyWithImpl<$Res,
          ConversationReadNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationReadData data,
      DateTime? receivedAt});

  $ConversationReadDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ConversationReadNotificationCopyWithImpl<$Res,
        $Val extends ConversationReadNotification>
    implements $ConversationReadNotificationCopyWith<$Res> {
  _$ConversationReadNotificationCopyWithImpl(this._value, this._then);

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
              as ConversationReadData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationReadDataCopyWith<$Res> get data {
    return $ConversationReadDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationReadNotificationImplCopyWith<$Res>
    implements $ConversationReadNotificationCopyWith<$Res> {
  factory _$$ConversationReadNotificationImplCopyWith(
          _$ConversationReadNotificationImpl value,
          $Res Function(_$ConversationReadNotificationImpl) then) =
      __$$ConversationReadNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationReadData data,
      DateTime? receivedAt});

  @override
  $ConversationReadDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ConversationReadNotificationImplCopyWithImpl<$Res>
    extends _$ConversationReadNotificationCopyWithImpl<$Res,
        _$ConversationReadNotificationImpl>
    implements _$$ConversationReadNotificationImplCopyWith<$Res> {
  __$$ConversationReadNotificationImplCopyWithImpl(
      _$ConversationReadNotificationImpl _value,
      $Res Function(_$ConversationReadNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$ConversationReadNotificationImpl(
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
              as ConversationReadData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ConversationReadNotificationImpl
    implements _ConversationReadNotification {
  const _$ConversationReadNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final ConversationReadData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'ConversationReadNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationReadNotificationImpl &&
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
  _$$ConversationReadNotificationImplCopyWith<
          _$ConversationReadNotificationImpl>
      get copyWith => __$$ConversationReadNotificationImplCopyWithImpl<
          _$ConversationReadNotificationImpl>(this, _$identity);
}

abstract class _ConversationReadNotification
    implements ConversationReadNotification {
  const factory _ConversationReadNotification(
      {required final String event,
      final String? channel,
      required final ConversationReadData data,
      final DateTime? receivedAt}) = _$ConversationReadNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  ConversationReadData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationReadNotificationImplCopyWith<
          _$ConversationReadNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

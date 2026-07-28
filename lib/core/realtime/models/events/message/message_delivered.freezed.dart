// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_delivered.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageDeliveredData _$MessageDeliveredDataFromJson(Map<String, dynamic> json) {
  return _MessageDeliveredData.fromJson(json);
}

/// @nodoc
mixin _$MessageDeliveredData {
  @JsonKey(name: 'message_uuid')
  String get messageUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageDeliveredDataCopyWith<MessageDeliveredData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDeliveredDataCopyWith<$Res> {
  factory $MessageDeliveredDataCopyWith(MessageDeliveredData value,
          $Res Function(MessageDeliveredData) then) =
      _$MessageDeliveredDataCopyWithImpl<$Res, MessageDeliveredData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'delivered_at') DateTime? deliveredAt});
}

/// @nodoc
class _$MessageDeliveredDataCopyWithImpl<$Res,
        $Val extends MessageDeliveredData>
    implements $MessageDeliveredDataCopyWith<$Res> {
  _$MessageDeliveredDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? deliveredAt = freezed,
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
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageDeliveredDataImplCopyWith<$Res>
    implements $MessageDeliveredDataCopyWith<$Res> {
  factory _$$MessageDeliveredDataImplCopyWith(_$MessageDeliveredDataImpl value,
          $Res Function(_$MessageDeliveredDataImpl) then) =
      __$$MessageDeliveredDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'message_uuid') String messageUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'delivered_at') DateTime? deliveredAt});
}

/// @nodoc
class __$$MessageDeliveredDataImplCopyWithImpl<$Res>
    extends _$MessageDeliveredDataCopyWithImpl<$Res, _$MessageDeliveredDataImpl>
    implements _$$MessageDeliveredDataImplCopyWith<$Res> {
  __$$MessageDeliveredDataImplCopyWithImpl(_$MessageDeliveredDataImpl _value,
      $Res Function(_$MessageDeliveredDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageUuid = null,
    Object? conversationUuid = null,
    Object? deliveredAt = freezed,
  }) {
    return _then(_$MessageDeliveredDataImpl(
      messageUuid: null == messageUuid
          ? _value.messageUuid
          : messageUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$MessageDeliveredDataImpl implements _MessageDeliveredData {
  const _$MessageDeliveredDataImpl(
      {@JsonKey(name: 'message_uuid') required this.messageUuid,
      @JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'delivered_at') this.deliveredAt});

  factory _$MessageDeliveredDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDeliveredDataImplFromJson(json);

  @override
  @JsonKey(name: 'message_uuid')
  final String messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;

  @override
  String toString() {
    return 'MessageDeliveredData(messageUuid: $messageUuid, conversationUuid: $conversationUuid, deliveredAt: $deliveredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDeliveredDataImpl &&
            (identical(other.messageUuid, messageUuid) ||
                other.messageUuid == messageUuid) &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, messageUuid, conversationUuid, deliveredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDeliveredDataImplCopyWith<_$MessageDeliveredDataImpl>
      get copyWith =>
          __$$MessageDeliveredDataImplCopyWithImpl<_$MessageDeliveredDataImpl>(
              this, _$identity);
}

abstract class _MessageDeliveredData implements MessageDeliveredData {
  const factory _MessageDeliveredData(
          {@JsonKey(name: 'message_uuid') required final String messageUuid,
          @JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          @JsonKey(name: 'delivered_at') final DateTime? deliveredAt}) =
      _$MessageDeliveredDataImpl;

  factory _MessageDeliveredData.fromJson(Map<String, dynamic> json) =
      _$MessageDeliveredDataImpl.fromJson;

  @override
  @JsonKey(name: 'message_uuid')
  String get messageUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageDeliveredDataImplCopyWith<_$MessageDeliveredDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MessageDeliveredNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  MessageDeliveredData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageDeliveredNotificationCopyWith<MessageDeliveredNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDeliveredNotificationCopyWith<$Res> {
  factory $MessageDeliveredNotificationCopyWith(
          MessageDeliveredNotification value,
          $Res Function(MessageDeliveredNotification) then) =
      _$MessageDeliveredNotificationCopyWithImpl<$Res,
          MessageDeliveredNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageDeliveredData data,
      DateTime? receivedAt});

  $MessageDeliveredDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MessageDeliveredNotificationCopyWithImpl<$Res,
        $Val extends MessageDeliveredNotification>
    implements $MessageDeliveredNotificationCopyWith<$Res> {
  _$MessageDeliveredNotificationCopyWithImpl(this._value, this._then);

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
              as MessageDeliveredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageDeliveredDataCopyWith<$Res> get data {
    return $MessageDeliveredDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageDeliveredNotificationImplCopyWith<$Res>
    implements $MessageDeliveredNotificationCopyWith<$Res> {
  factory _$$MessageDeliveredNotificationImplCopyWith(
          _$MessageDeliveredNotificationImpl value,
          $Res Function(_$MessageDeliveredNotificationImpl) then) =
      __$$MessageDeliveredNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      MessageDeliveredData data,
      DateTime? receivedAt});

  @override
  $MessageDeliveredDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MessageDeliveredNotificationImplCopyWithImpl<$Res>
    extends _$MessageDeliveredNotificationCopyWithImpl<$Res,
        _$MessageDeliveredNotificationImpl>
    implements _$$MessageDeliveredNotificationImplCopyWith<$Res> {
  __$$MessageDeliveredNotificationImplCopyWithImpl(
      _$MessageDeliveredNotificationImpl _value,
      $Res Function(_$MessageDeliveredNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$MessageDeliveredNotificationImpl(
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
              as MessageDeliveredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$MessageDeliveredNotificationImpl
    implements _MessageDeliveredNotification {
  const _$MessageDeliveredNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final MessageDeliveredData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'MessageDeliveredNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDeliveredNotificationImpl &&
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
  _$$MessageDeliveredNotificationImplCopyWith<
          _$MessageDeliveredNotificationImpl>
      get copyWith => __$$MessageDeliveredNotificationImplCopyWithImpl<
          _$MessageDeliveredNotificationImpl>(this, _$identity);
}

abstract class _MessageDeliveredNotification
    implements MessageDeliveredNotification {
  const factory _MessageDeliveredNotification(
      {required final String event,
      final String? channel,
      required final MessageDeliveredData data,
      final DateTime? receivedAt}) = _$MessageDeliveredNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  MessageDeliveredData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageDeliveredNotificationImplCopyWith<
          _$MessageDeliveredNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

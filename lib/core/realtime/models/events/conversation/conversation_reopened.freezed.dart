// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_reopened.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationReopenedData _$ConversationReopenedDataFromJson(
    Map<String, dynamic> json) {
  return _ConversationReopenedData.fromJson(json);
}

/// @nodoc
mixin _$ConversationReopenedData {
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'reopened_at')
  DateTime? get reopenedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationReopenedDataCopyWith<ConversationReopenedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationReopenedDataCopyWith<$Res> {
  factory $ConversationReopenedDataCopyWith(ConversationReopenedData value,
          $Res Function(ConversationReopenedData) then) =
      _$ConversationReopenedDataCopyWithImpl<$Res, ConversationReopenedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'reopened_at') DateTime? reopenedAt});
}

/// @nodoc
class _$ConversationReopenedDataCopyWithImpl<$Res,
        $Val extends ConversationReopenedData>
    implements $ConversationReopenedDataCopyWith<$Res> {
  _$ConversationReopenedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? reopenedAt = freezed,
  }) {
    return _then(_value.copyWith(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      reopenedAt: freezed == reopenedAt
          ? _value.reopenedAt
          : reopenedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationReopenedDataImplCopyWith<$Res>
    implements $ConversationReopenedDataCopyWith<$Res> {
  factory _$$ConversationReopenedDataImplCopyWith(
          _$ConversationReopenedDataImpl value,
          $Res Function(_$ConversationReopenedDataImpl) then) =
      __$$ConversationReopenedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'reopened_at') DateTime? reopenedAt});
}

/// @nodoc
class __$$ConversationReopenedDataImplCopyWithImpl<$Res>
    extends _$ConversationReopenedDataCopyWithImpl<$Res,
        _$ConversationReopenedDataImpl>
    implements _$$ConversationReopenedDataImplCopyWith<$Res> {
  __$$ConversationReopenedDataImplCopyWithImpl(
      _$ConversationReopenedDataImpl _value,
      $Res Function(_$ConversationReopenedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? reopenedAt = freezed,
  }) {
    return _then(_$ConversationReopenedDataImpl(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      reopenedAt: freezed == reopenedAt
          ? _value.reopenedAt
          : reopenedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$ConversationReopenedDataImpl implements _ConversationReopenedData {
  const _$ConversationReopenedDataImpl(
      {@JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'reopened_at') this.reopenedAt});

  factory _$ConversationReopenedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationReopenedDataImplFromJson(json);

  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'reopened_at')
  final DateTime? reopenedAt;

  @override
  String toString() {
    return 'ConversationReopenedData(conversationUuid: $conversationUuid, reopenedAt: $reopenedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationReopenedDataImpl &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.reopenedAt, reopenedAt) ||
                other.reopenedAt == reopenedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, conversationUuid, reopenedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationReopenedDataImplCopyWith<_$ConversationReopenedDataImpl>
      get copyWith => __$$ConversationReopenedDataImplCopyWithImpl<
          _$ConversationReopenedDataImpl>(this, _$identity);
}

abstract class _ConversationReopenedData implements ConversationReopenedData {
  const factory _ConversationReopenedData(
          {@JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          @JsonKey(name: 'reopened_at') final DateTime? reopenedAt}) =
      _$ConversationReopenedDataImpl;

  factory _ConversationReopenedData.fromJson(Map<String, dynamic> json) =
      _$ConversationReopenedDataImpl.fromJson;

  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'reopened_at')
  DateTime? get reopenedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationReopenedDataImplCopyWith<_$ConversationReopenedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversationReopenedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  ConversationReopenedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationReopenedNotificationCopyWith<ConversationReopenedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationReopenedNotificationCopyWith<$Res> {
  factory $ConversationReopenedNotificationCopyWith(
          ConversationReopenedNotification value,
          $Res Function(ConversationReopenedNotification) then) =
      _$ConversationReopenedNotificationCopyWithImpl<$Res,
          ConversationReopenedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationReopenedData data,
      DateTime? receivedAt});

  $ConversationReopenedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ConversationReopenedNotificationCopyWithImpl<$Res,
        $Val extends ConversationReopenedNotification>
    implements $ConversationReopenedNotificationCopyWith<$Res> {
  _$ConversationReopenedNotificationCopyWithImpl(this._value, this._then);

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
              as ConversationReopenedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationReopenedDataCopyWith<$Res> get data {
    return $ConversationReopenedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationReopenedNotificationImplCopyWith<$Res>
    implements $ConversationReopenedNotificationCopyWith<$Res> {
  factory _$$ConversationReopenedNotificationImplCopyWith(
          _$ConversationReopenedNotificationImpl value,
          $Res Function(_$ConversationReopenedNotificationImpl) then) =
      __$$ConversationReopenedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationReopenedData data,
      DateTime? receivedAt});

  @override
  $ConversationReopenedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ConversationReopenedNotificationImplCopyWithImpl<$Res>
    extends _$ConversationReopenedNotificationCopyWithImpl<$Res,
        _$ConversationReopenedNotificationImpl>
    implements _$$ConversationReopenedNotificationImplCopyWith<$Res> {
  __$$ConversationReopenedNotificationImplCopyWithImpl(
      _$ConversationReopenedNotificationImpl _value,
      $Res Function(_$ConversationReopenedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$ConversationReopenedNotificationImpl(
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
              as ConversationReopenedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ConversationReopenedNotificationImpl
    implements _ConversationReopenedNotification {
  const _$ConversationReopenedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final ConversationReopenedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'ConversationReopenedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationReopenedNotificationImpl &&
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
  _$$ConversationReopenedNotificationImplCopyWith<
          _$ConversationReopenedNotificationImpl>
      get copyWith => __$$ConversationReopenedNotificationImplCopyWithImpl<
          _$ConversationReopenedNotificationImpl>(this, _$identity);
}

abstract class _ConversationReopenedNotification
    implements ConversationReopenedNotification {
  const factory _ConversationReopenedNotification(
      {required final String event,
      final String? channel,
      required final ConversationReopenedData data,
      final DateTime? receivedAt}) = _$ConversationReopenedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  ConversationReopenedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationReopenedNotificationImplCopyWith<
          _$ConversationReopenedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationCreatedData _$ConversationCreatedDataFromJson(
    Map<String, dynamic> json) {
  return _ConversationCreatedData.fromJson(json);
}

/// @nodoc
mixin _$ConversationCreatedData {
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_type')
  String get conversationType => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationCreatedDataCopyWith<ConversationCreatedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCreatedDataCopyWith<$Res> {
  factory $ConversationCreatedDataCopyWith(ConversationCreatedData value,
          $Res Function(ConversationCreatedData) then) =
      _$ConversationCreatedDataCopyWithImpl<$Res, ConversationCreatedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'conversation_type') String conversationType,
      String? subject,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$ConversationCreatedDataCopyWithImpl<$Res,
        $Val extends ConversationCreatedData>
    implements $ConversationCreatedDataCopyWith<$Res> {
  _$ConversationCreatedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? conversationType = null,
    Object? subject = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationType: null == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationCreatedDataImplCopyWith<$Res>
    implements $ConversationCreatedDataCopyWith<$Res> {
  factory _$$ConversationCreatedDataImplCopyWith(
          _$ConversationCreatedDataImpl value,
          $Res Function(_$ConversationCreatedDataImpl) then) =
      __$$ConversationCreatedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_uuid') String conversationUuid,
      @JsonKey(name: 'conversation_type') String conversationType,
      String? subject,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$ConversationCreatedDataImplCopyWithImpl<$Res>
    extends _$ConversationCreatedDataCopyWithImpl<$Res,
        _$ConversationCreatedDataImpl>
    implements _$$ConversationCreatedDataImplCopyWith<$Res> {
  __$$ConversationCreatedDataImplCopyWithImpl(
      _$ConversationCreatedDataImpl _value,
      $Res Function(_$ConversationCreatedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationUuid = null,
    Object? conversationType = null,
    Object? subject = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ConversationCreatedDataImpl(
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationType: null == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
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
class _$ConversationCreatedDataImpl implements _ConversationCreatedData {
  const _$ConversationCreatedDataImpl(
      {@JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      @JsonKey(name: 'conversation_type') required this.conversationType,
      this.subject,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$ConversationCreatedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationCreatedDataImplFromJson(json);

  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  @JsonKey(name: 'conversation_type')
  final String conversationType;
  @override
  final String? subject;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ConversationCreatedData(conversationUuid: $conversationUuid, conversationType: $conversationType, subject: $subject, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationCreatedDataImpl &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, conversationUuid, conversationType, subject, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationCreatedDataImplCopyWith<_$ConversationCreatedDataImpl>
      get copyWith => __$$ConversationCreatedDataImplCopyWithImpl<
          _$ConversationCreatedDataImpl>(this, _$identity);
}

abstract class _ConversationCreatedData implements ConversationCreatedData {
  const factory _ConversationCreatedData(
          {@JsonKey(name: 'conversation_uuid')
          required final String conversationUuid,
          @JsonKey(name: 'conversation_type')
          required final String conversationType,
          final String? subject,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$ConversationCreatedDataImpl;

  factory _ConversationCreatedData.fromJson(Map<String, dynamic> json) =
      _$ConversationCreatedDataImpl.fromJson;

  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  @JsonKey(name: 'conversation_type')
  String get conversationType;
  @override
  String? get subject;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationCreatedDataImplCopyWith<_$ConversationCreatedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversationCreatedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  ConversationCreatedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationCreatedNotificationCopyWith<ConversationCreatedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCreatedNotificationCopyWith<$Res> {
  factory $ConversationCreatedNotificationCopyWith(
          ConversationCreatedNotification value,
          $Res Function(ConversationCreatedNotification) then) =
      _$ConversationCreatedNotificationCopyWithImpl<$Res,
          ConversationCreatedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationCreatedData data,
      DateTime? receivedAt});

  $ConversationCreatedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ConversationCreatedNotificationCopyWithImpl<$Res,
        $Val extends ConversationCreatedNotification>
    implements $ConversationCreatedNotificationCopyWith<$Res> {
  _$ConversationCreatedNotificationCopyWithImpl(this._value, this._then);

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
              as ConversationCreatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationCreatedDataCopyWith<$Res> get data {
    return $ConversationCreatedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationCreatedNotificationImplCopyWith<$Res>
    implements $ConversationCreatedNotificationCopyWith<$Res> {
  factory _$$ConversationCreatedNotificationImplCopyWith(
          _$ConversationCreatedNotificationImpl value,
          $Res Function(_$ConversationCreatedNotificationImpl) then) =
      __$$ConversationCreatedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationCreatedData data,
      DateTime? receivedAt});

  @override
  $ConversationCreatedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ConversationCreatedNotificationImplCopyWithImpl<$Res>
    extends _$ConversationCreatedNotificationCopyWithImpl<$Res,
        _$ConversationCreatedNotificationImpl>
    implements _$$ConversationCreatedNotificationImplCopyWith<$Res> {
  __$$ConversationCreatedNotificationImplCopyWithImpl(
      _$ConversationCreatedNotificationImpl _value,
      $Res Function(_$ConversationCreatedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$ConversationCreatedNotificationImpl(
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
              as ConversationCreatedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ConversationCreatedNotificationImpl
    implements _ConversationCreatedNotification {
  const _$ConversationCreatedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final ConversationCreatedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'ConversationCreatedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationCreatedNotificationImpl &&
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
  _$$ConversationCreatedNotificationImplCopyWith<
          _$ConversationCreatedNotificationImpl>
      get copyWith => __$$ConversationCreatedNotificationImplCopyWithImpl<
          _$ConversationCreatedNotificationImpl>(this, _$identity);
}

abstract class _ConversationCreatedNotification
    implements ConversationCreatedNotification {
  const factory _ConversationCreatedNotification(
      {required final String event,
      final String? channel,
      required final ConversationCreatedData data,
      final DateTime? receivedAt}) = _$ConversationCreatedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  ConversationCreatedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationCreatedNotificationImplCopyWith<
          _$ConversationCreatedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

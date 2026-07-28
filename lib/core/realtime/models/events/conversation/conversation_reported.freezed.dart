// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_reported.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationReportedData _$ConversationReportedDataFromJson(
    Map<String, dynamic> json) {
  return _ConversationReportedData.fromJson(json);
}

/// @nodoc
mixin _$ConversationReportedData {
  @JsonKey(name: 'report_uuid')
  String get reportUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationReportedDataCopyWith<ConversationReportedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationReportedDataCopyWith<$Res> {
  factory $ConversationReportedDataCopyWith(ConversationReportedData value,
          $Res Function(ConversationReportedData) then) =
      _$ConversationReportedDataCopyWithImpl<$Res, ConversationReportedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'report_uuid') String reportUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      String? reason});
}

/// @nodoc
class _$ConversationReportedDataCopyWithImpl<$Res,
        $Val extends ConversationReportedData>
    implements $ConversationReportedDataCopyWith<$Res> {
  _$ConversationReportedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportUuid = null,
    Object? conversationUuid = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      reportUuid: null == reportUuid
          ? _value.reportUuid
          : reportUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationReportedDataImplCopyWith<$Res>
    implements $ConversationReportedDataCopyWith<$Res> {
  factory _$$ConversationReportedDataImplCopyWith(
          _$ConversationReportedDataImpl value,
          $Res Function(_$ConversationReportedDataImpl) then) =
      __$$ConversationReportedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'report_uuid') String reportUuid,
      @JsonKey(name: 'conversation_uuid') String conversationUuid,
      String? reason});
}

/// @nodoc
class __$$ConversationReportedDataImplCopyWithImpl<$Res>
    extends _$ConversationReportedDataCopyWithImpl<$Res,
        _$ConversationReportedDataImpl>
    implements _$$ConversationReportedDataImplCopyWith<$Res> {
  __$$ConversationReportedDataImplCopyWithImpl(
      _$ConversationReportedDataImpl _value,
      $Res Function(_$ConversationReportedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportUuid = null,
    Object? conversationUuid = null,
    Object? reason = freezed,
  }) {
    return _then(_$ConversationReportedDataImpl(
      reportUuid: null == reportUuid
          ? _value.reportUuid
          : reportUuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationUuid: null == conversationUuid
          ? _value.conversationUuid
          : conversationUuid // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$ConversationReportedDataImpl implements _ConversationReportedData {
  const _$ConversationReportedDataImpl(
      {@JsonKey(name: 'report_uuid') required this.reportUuid,
      @JsonKey(name: 'conversation_uuid') required this.conversationUuid,
      this.reason});

  factory _$ConversationReportedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationReportedDataImplFromJson(json);

  @override
  @JsonKey(name: 'report_uuid')
  final String reportUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  final String conversationUuid;
  @override
  final String? reason;

  @override
  String toString() {
    return 'ConversationReportedData(reportUuid: $reportUuid, conversationUuid: $conversationUuid, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationReportedDataImpl &&
            (identical(other.reportUuid, reportUuid) ||
                other.reportUuid == reportUuid) &&
            (identical(other.conversationUuid, conversationUuid) ||
                other.conversationUuid == conversationUuid) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, reportUuid, conversationUuid, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationReportedDataImplCopyWith<_$ConversationReportedDataImpl>
      get copyWith => __$$ConversationReportedDataImplCopyWithImpl<
          _$ConversationReportedDataImpl>(this, _$identity);
}

abstract class _ConversationReportedData implements ConversationReportedData {
  const factory _ConversationReportedData(
      {@JsonKey(name: 'report_uuid') required final String reportUuid,
      @JsonKey(name: 'conversation_uuid')
      required final String conversationUuid,
      final String? reason}) = _$ConversationReportedDataImpl;

  factory _ConversationReportedData.fromJson(Map<String, dynamic> json) =
      _$ConversationReportedDataImpl.fromJson;

  @override
  @JsonKey(name: 'report_uuid')
  String get reportUuid;
  @override
  @JsonKey(name: 'conversation_uuid')
  String get conversationUuid;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$ConversationReportedDataImplCopyWith<_$ConversationReportedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversationReportedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  ConversationReportedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversationReportedNotificationCopyWith<ConversationReportedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationReportedNotificationCopyWith<$Res> {
  factory $ConversationReportedNotificationCopyWith(
          ConversationReportedNotification value,
          $Res Function(ConversationReportedNotification) then) =
      _$ConversationReportedNotificationCopyWithImpl<$Res,
          ConversationReportedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationReportedData data,
      DateTime? receivedAt});

  $ConversationReportedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ConversationReportedNotificationCopyWithImpl<$Res,
        $Val extends ConversationReportedNotification>
    implements $ConversationReportedNotificationCopyWith<$Res> {
  _$ConversationReportedNotificationCopyWithImpl(this._value, this._then);

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
              as ConversationReportedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationReportedDataCopyWith<$Res> get data {
    return $ConversationReportedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationReportedNotificationImplCopyWith<$Res>
    implements $ConversationReportedNotificationCopyWith<$Res> {
  factory _$$ConversationReportedNotificationImplCopyWith(
          _$ConversationReportedNotificationImpl value,
          $Res Function(_$ConversationReportedNotificationImpl) then) =
      __$$ConversationReportedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      ConversationReportedData data,
      DateTime? receivedAt});

  @override
  $ConversationReportedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ConversationReportedNotificationImplCopyWithImpl<$Res>
    extends _$ConversationReportedNotificationCopyWithImpl<$Res,
        _$ConversationReportedNotificationImpl>
    implements _$$ConversationReportedNotificationImplCopyWith<$Res> {
  __$$ConversationReportedNotificationImplCopyWithImpl(
      _$ConversationReportedNotificationImpl _value,
      $Res Function(_$ConversationReportedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$ConversationReportedNotificationImpl(
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
              as ConversationReportedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ConversationReportedNotificationImpl
    implements _ConversationReportedNotification {
  const _$ConversationReportedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final ConversationReportedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'ConversationReportedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationReportedNotificationImpl &&
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
  _$$ConversationReportedNotificationImplCopyWith<
          _$ConversationReportedNotificationImpl>
      get copyWith => __$$ConversationReportedNotificationImplCopyWithImpl<
          _$ConversationReportedNotificationImpl>(this, _$identity);
}

abstract class _ConversationReportedNotification
    implements ConversationReportedNotification {
  const factory _ConversationReportedNotification(
      {required final String event,
      final String? channel,
      required final ConversationReportedData data,
      final DateTime? receivedAt}) = _$ConversationReportedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  ConversationReportedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationReportedNotificationImplCopyWith<
          _$ConversationReportedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

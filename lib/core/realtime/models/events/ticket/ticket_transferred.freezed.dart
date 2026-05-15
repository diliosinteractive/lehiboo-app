// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_transferred.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketTransferredData _$TicketTransferredDataFromJson(
    Map<String, dynamic> json) {
  return _TicketTransferredData.fromJson(json);
}

/// @nodoc
mixin _$TicketTransferredData {
  @JsonKey(name: 'ticket_id')
  int get ticketId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_user_id')
  int get fromUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_email')
  String get toEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'transferred_at')
  DateTime? get transferredAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketTransferredDataCopyWith<TicketTransferredData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketTransferredDataCopyWith<$Res> {
  factory $TicketTransferredDataCopyWith(TicketTransferredData value,
          $Res Function(TicketTransferredData) then) =
      _$TicketTransferredDataCopyWithImpl<$Res, TicketTransferredData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_id') int ticketId,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'from_user_id') int fromUserId,
      @JsonKey(name: 'to_email') String toEmail,
      @JsonKey(name: 'transferred_at') DateTime? transferredAt});
}

/// @nodoc
class _$TicketTransferredDataCopyWithImpl<$Res,
        $Val extends TicketTransferredData>
    implements $TicketTransferredDataCopyWith<$Res> {
  _$TicketTransferredDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? eventId = null,
    Object? fromUserId = null,
    Object? toEmail = null,
    Object? transferredAt = freezed,
  }) {
    return _then(_value.copyWith(
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as int,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as int,
      toEmail: null == toEmail
          ? _value.toEmail
          : toEmail // ignore: cast_nullable_to_non_nullable
              as String,
      transferredAt: freezed == transferredAt
          ? _value.transferredAt
          : transferredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketTransferredDataImplCopyWith<$Res>
    implements $TicketTransferredDataCopyWith<$Res> {
  factory _$$TicketTransferredDataImplCopyWith(
          _$TicketTransferredDataImpl value,
          $Res Function(_$TicketTransferredDataImpl) then) =
      __$$TicketTransferredDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_id') int ticketId,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'from_user_id') int fromUserId,
      @JsonKey(name: 'to_email') String toEmail,
      @JsonKey(name: 'transferred_at') DateTime? transferredAt});
}

/// @nodoc
class __$$TicketTransferredDataImplCopyWithImpl<$Res>
    extends _$TicketTransferredDataCopyWithImpl<$Res,
        _$TicketTransferredDataImpl>
    implements _$$TicketTransferredDataImplCopyWith<$Res> {
  __$$TicketTransferredDataImplCopyWithImpl(_$TicketTransferredDataImpl _value,
      $Res Function(_$TicketTransferredDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? eventId = null,
    Object? fromUserId = null,
    Object? toEmail = null,
    Object? transferredAt = freezed,
  }) {
    return _then(_$TicketTransferredDataImpl(
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as int,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as int,
      toEmail: null == toEmail
          ? _value.toEmail
          : toEmail // ignore: cast_nullable_to_non_nullable
              as String,
      transferredAt: freezed == transferredAt
          ? _value.transferredAt
          : transferredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$TicketTransferredDataImpl implements _TicketTransferredData {
  const _$TicketTransferredDataImpl(
      {@JsonKey(name: 'ticket_id') required this.ticketId,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'from_user_id') required this.fromUserId,
      @JsonKey(name: 'to_email') required this.toEmail,
      @JsonKey(name: 'transferred_at') this.transferredAt});

  factory _$TicketTransferredDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketTransferredDataImplFromJson(json);

  @override
  @JsonKey(name: 'ticket_id')
  final int ticketId;
  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'from_user_id')
  final int fromUserId;
  @override
  @JsonKey(name: 'to_email')
  final String toEmail;
  @override
  @JsonKey(name: 'transferred_at')
  final DateTime? transferredAt;

  @override
  String toString() {
    return 'TicketTransferredData(ticketId: $ticketId, eventId: $eventId, fromUserId: $fromUserId, toEmail: $toEmail, transferredAt: $transferredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketTransferredDataImpl &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toEmail, toEmail) || other.toEmail == toEmail) &&
            (identical(other.transferredAt, transferredAt) ||
                other.transferredAt == transferredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, ticketId, eventId, fromUserId, toEmail, transferredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketTransferredDataImplCopyWith<_$TicketTransferredDataImpl>
      get copyWith => __$$TicketTransferredDataImplCopyWithImpl<
          _$TicketTransferredDataImpl>(this, _$identity);
}

abstract class _TicketTransferredData implements TicketTransferredData {
  const factory _TicketTransferredData(
          {@JsonKey(name: 'ticket_id') required final int ticketId,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'from_user_id') required final int fromUserId,
          @JsonKey(name: 'to_email') required final String toEmail,
          @JsonKey(name: 'transferred_at') final DateTime? transferredAt}) =
      _$TicketTransferredDataImpl;

  factory _TicketTransferredData.fromJson(Map<String, dynamic> json) =
      _$TicketTransferredDataImpl.fromJson;

  @override
  @JsonKey(name: 'ticket_id')
  int get ticketId;
  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'from_user_id')
  int get fromUserId;
  @override
  @JsonKey(name: 'to_email')
  String get toEmail;
  @override
  @JsonKey(name: 'transferred_at')
  DateTime? get transferredAt;
  @override
  @JsonKey(ignore: true)
  _$$TicketTransferredDataImplCopyWith<_$TicketTransferredDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TicketTransferredNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  TicketTransferredData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketTransferredNotificationCopyWith<TicketTransferredNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketTransferredNotificationCopyWith<$Res> {
  factory $TicketTransferredNotificationCopyWith(
          TicketTransferredNotification value,
          $Res Function(TicketTransferredNotification) then) =
      _$TicketTransferredNotificationCopyWithImpl<$Res,
          TicketTransferredNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      TicketTransferredData data,
      DateTime? receivedAt});

  $TicketTransferredDataCopyWith<$Res> get data;
}

/// @nodoc
class _$TicketTransferredNotificationCopyWithImpl<$Res,
        $Val extends TicketTransferredNotification>
    implements $TicketTransferredNotificationCopyWith<$Res> {
  _$TicketTransferredNotificationCopyWithImpl(this._value, this._then);

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
              as TicketTransferredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TicketTransferredDataCopyWith<$Res> get data {
    return $TicketTransferredDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TicketTransferredNotificationImplCopyWith<$Res>
    implements $TicketTransferredNotificationCopyWith<$Res> {
  factory _$$TicketTransferredNotificationImplCopyWith(
          _$TicketTransferredNotificationImpl value,
          $Res Function(_$TicketTransferredNotificationImpl) then) =
      __$$TicketTransferredNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      TicketTransferredData data,
      DateTime? receivedAt});

  @override
  $TicketTransferredDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$TicketTransferredNotificationImplCopyWithImpl<$Res>
    extends _$TicketTransferredNotificationCopyWithImpl<$Res,
        _$TicketTransferredNotificationImpl>
    implements _$$TicketTransferredNotificationImplCopyWith<$Res> {
  __$$TicketTransferredNotificationImplCopyWithImpl(
      _$TicketTransferredNotificationImpl _value,
      $Res Function(_$TicketTransferredNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$TicketTransferredNotificationImpl(
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
              as TicketTransferredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$TicketTransferredNotificationImpl
    implements _TicketTransferredNotification {
  const _$TicketTransferredNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final TicketTransferredData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'TicketTransferredNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketTransferredNotificationImpl &&
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
  _$$TicketTransferredNotificationImplCopyWith<
          _$TicketTransferredNotificationImpl>
      get copyWith => __$$TicketTransferredNotificationImplCopyWithImpl<
          _$TicketTransferredNotificationImpl>(this, _$identity);
}

abstract class _TicketTransferredNotification
    implements TicketTransferredNotification {
  const factory _TicketTransferredNotification(
      {required final String event,
      final String? channel,
      required final TicketTransferredData data,
      final DateTime? receivedAt}) = _$TicketTransferredNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  TicketTransferredData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$TicketTransferredNotificationImplCopyWith<
          _$TicketTransferredNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_checked_in.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketCheckedInData _$TicketCheckedInDataFromJson(Map<String, dynamic> json) {
  return _TicketCheckedInData.fromJson(json);
}

/// @nodoc
mixin _$TicketCheckedInData {
  @JsonKey(name: 'ticket_id')
  int get ticketId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_uuid')
  String get ticketUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String get qrCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'checked_in_at')
  DateTime? get checkedInAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'scan_location')
  String? get scanLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendee_name')
  String? get attendeeName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketCheckedInDataCopyWith<TicketCheckedInData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCheckedInDataCopyWith<$Res> {
  factory $TicketCheckedInDataCopyWith(
          TicketCheckedInData value, $Res Function(TicketCheckedInData) then) =
      _$TicketCheckedInDataCopyWithImpl<$Res, TicketCheckedInData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_id') int ticketId,
      @JsonKey(name: 'ticket_uuid') String ticketUuid,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'checked_in_at') DateTime? checkedInAt,
      @JsonKey(name: 'scan_location') String? scanLocation,
      @JsonKey(name: 'attendee_name') String? attendeeName});
}

/// @nodoc
class _$TicketCheckedInDataCopyWithImpl<$Res, $Val extends TicketCheckedInData>
    implements $TicketCheckedInDataCopyWith<$Res> {
  _$TicketCheckedInDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? ticketUuid = null,
    Object? qrCode = null,
    Object? eventId = null,
    Object? checkedInAt = freezed,
    Object? scanLocation = freezed,
    Object? attendeeName = freezed,
  }) {
    return _then(_value.copyWith(
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as int,
      ticketUuid: null == ticketUuid
          ? _value.ticketUuid
          : ticketUuid // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      checkedInAt: freezed == checkedInAt
          ? _value.checkedInAt
          : checkedInAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scanLocation: freezed == scanLocation
          ? _value.scanLocation
          : scanLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeName: freezed == attendeeName
          ? _value.attendeeName
          : attendeeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketCheckedInDataImplCopyWith<$Res>
    implements $TicketCheckedInDataCopyWith<$Res> {
  factory _$$TicketCheckedInDataImplCopyWith(_$TicketCheckedInDataImpl value,
          $Res Function(_$TicketCheckedInDataImpl) then) =
      __$$TicketCheckedInDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_id') int ticketId,
      @JsonKey(name: 'ticket_uuid') String ticketUuid,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'checked_in_at') DateTime? checkedInAt,
      @JsonKey(name: 'scan_location') String? scanLocation,
      @JsonKey(name: 'attendee_name') String? attendeeName});
}

/// @nodoc
class __$$TicketCheckedInDataImplCopyWithImpl<$Res>
    extends _$TicketCheckedInDataCopyWithImpl<$Res, _$TicketCheckedInDataImpl>
    implements _$$TicketCheckedInDataImplCopyWith<$Res> {
  __$$TicketCheckedInDataImplCopyWithImpl(_$TicketCheckedInDataImpl _value,
      $Res Function(_$TicketCheckedInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? ticketUuid = null,
    Object? qrCode = null,
    Object? eventId = null,
    Object? checkedInAt = freezed,
    Object? scanLocation = freezed,
    Object? attendeeName = freezed,
  }) {
    return _then(_$TicketCheckedInDataImpl(
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as int,
      ticketUuid: null == ticketUuid
          ? _value.ticketUuid
          : ticketUuid // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      checkedInAt: freezed == checkedInAt
          ? _value.checkedInAt
          : checkedInAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scanLocation: freezed == scanLocation
          ? _value.scanLocation
          : scanLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeName: freezed == attendeeName
          ? _value.attendeeName
          : attendeeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$TicketCheckedInDataImpl implements _TicketCheckedInData {
  const _$TicketCheckedInDataImpl(
      {@JsonKey(name: 'ticket_id') required this.ticketId,
      @JsonKey(name: 'ticket_uuid') required this.ticketUuid,
      @JsonKey(name: 'qr_code') required this.qrCode,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'checked_in_at') this.checkedInAt,
      @JsonKey(name: 'scan_location') this.scanLocation,
      @JsonKey(name: 'attendee_name') this.attendeeName});

  factory _$TicketCheckedInDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketCheckedInDataImplFromJson(json);

  @override
  @JsonKey(name: 'ticket_id')
  final int ticketId;
  @override
  @JsonKey(name: 'ticket_uuid')
  final String ticketUuid;
  @override
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'checked_in_at')
  final DateTime? checkedInAt;
  @override
  @JsonKey(name: 'scan_location')
  final String? scanLocation;
  @override
  @JsonKey(name: 'attendee_name')
  final String? attendeeName;

  @override
  String toString() {
    return 'TicketCheckedInData(ticketId: $ticketId, ticketUuid: $ticketUuid, qrCode: $qrCode, eventId: $eventId, checkedInAt: $checkedInAt, scanLocation: $scanLocation, attendeeName: $attendeeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketCheckedInDataImpl &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.ticketUuid, ticketUuid) ||
                other.ticketUuid == ticketUuid) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.checkedInAt, checkedInAt) ||
                other.checkedInAt == checkedInAt) &&
            (identical(other.scanLocation, scanLocation) ||
                other.scanLocation == scanLocation) &&
            (identical(other.attendeeName, attendeeName) ||
                other.attendeeName == attendeeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ticketId, ticketUuid, qrCode,
      eventId, checkedInAt, scanLocation, attendeeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketCheckedInDataImplCopyWith<_$TicketCheckedInDataImpl> get copyWith =>
      __$$TicketCheckedInDataImplCopyWithImpl<_$TicketCheckedInDataImpl>(
          this, _$identity);
}

abstract class _TicketCheckedInData implements TicketCheckedInData {
  const factory _TicketCheckedInData(
          {@JsonKey(name: 'ticket_id') required final int ticketId,
          @JsonKey(name: 'ticket_uuid') required final String ticketUuid,
          @JsonKey(name: 'qr_code') required final String qrCode,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'checked_in_at') final DateTime? checkedInAt,
          @JsonKey(name: 'scan_location') final String? scanLocation,
          @JsonKey(name: 'attendee_name') final String? attendeeName}) =
      _$TicketCheckedInDataImpl;

  factory _TicketCheckedInData.fromJson(Map<String, dynamic> json) =
      _$TicketCheckedInDataImpl.fromJson;

  @override
  @JsonKey(name: 'ticket_id')
  int get ticketId;
  @override
  @JsonKey(name: 'ticket_uuid')
  String get ticketUuid;
  @override
  @JsonKey(name: 'qr_code')
  String get qrCode;
  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'checked_in_at')
  DateTime? get checkedInAt;
  @override
  @JsonKey(name: 'scan_location')
  String? get scanLocation;
  @override
  @JsonKey(name: 'attendee_name')
  String? get attendeeName;
  @override
  @JsonKey(ignore: true)
  _$$TicketCheckedInDataImplCopyWith<_$TicketCheckedInDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TicketCheckedInNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  TicketCheckedInData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketCheckedInNotificationCopyWith<TicketCheckedInNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCheckedInNotificationCopyWith<$Res> {
  factory $TicketCheckedInNotificationCopyWith(
          TicketCheckedInNotification value,
          $Res Function(TicketCheckedInNotification) then) =
      _$TicketCheckedInNotificationCopyWithImpl<$Res,
          TicketCheckedInNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      TicketCheckedInData data,
      DateTime? receivedAt});

  $TicketCheckedInDataCopyWith<$Res> get data;
}

/// @nodoc
class _$TicketCheckedInNotificationCopyWithImpl<$Res,
        $Val extends TicketCheckedInNotification>
    implements $TicketCheckedInNotificationCopyWith<$Res> {
  _$TicketCheckedInNotificationCopyWithImpl(this._value, this._then);

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
              as TicketCheckedInData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TicketCheckedInDataCopyWith<$Res> get data {
    return $TicketCheckedInDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TicketCheckedInNotificationImplCopyWith<$Res>
    implements $TicketCheckedInNotificationCopyWith<$Res> {
  factory _$$TicketCheckedInNotificationImplCopyWith(
          _$TicketCheckedInNotificationImpl value,
          $Res Function(_$TicketCheckedInNotificationImpl) then) =
      __$$TicketCheckedInNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      TicketCheckedInData data,
      DateTime? receivedAt});

  @override
  $TicketCheckedInDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$TicketCheckedInNotificationImplCopyWithImpl<$Res>
    extends _$TicketCheckedInNotificationCopyWithImpl<$Res,
        _$TicketCheckedInNotificationImpl>
    implements _$$TicketCheckedInNotificationImplCopyWith<$Res> {
  __$$TicketCheckedInNotificationImplCopyWithImpl(
      _$TicketCheckedInNotificationImpl _value,
      $Res Function(_$TicketCheckedInNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$TicketCheckedInNotificationImpl(
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
              as TicketCheckedInData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$TicketCheckedInNotificationImpl
    implements _TicketCheckedInNotification {
  const _$TicketCheckedInNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final TicketCheckedInData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'TicketCheckedInNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketCheckedInNotificationImpl &&
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
  _$$TicketCheckedInNotificationImplCopyWith<_$TicketCheckedInNotificationImpl>
      get copyWith => __$$TicketCheckedInNotificationImplCopyWithImpl<
          _$TicketCheckedInNotificationImpl>(this, _$identity);
}

abstract class _TicketCheckedInNotification
    implements TicketCheckedInNotification {
  const factory _TicketCheckedInNotification(
      {required final String event,
      final String? channel,
      required final TicketCheckedInData data,
      final DateTime? receivedAt}) = _$TicketCheckedInNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  TicketCheckedInData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$TicketCheckedInNotificationImplCopyWith<_$TicketCheckedInNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_re_entered.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketReEnteredData _$TicketReEnteredDataFromJson(Map<String, dynamic> json) {
  return _TicketReEnteredData.fromJson(json);
}

/// @nodoc
mixin _$TicketReEnteredData {
  @JsonKey(name: 'ticket_id')
  int get ticketId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_uuid')
  String get ticketUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String get qrCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scanned_at')
  DateTime? get scannedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'scan_location')
  String? get scanLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_in_count')
  int? get checkInCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendee_name')
  String? get attendeeName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketReEnteredDataCopyWith<TicketReEnteredData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketReEnteredDataCopyWith<$Res> {
  factory $TicketReEnteredDataCopyWith(
          TicketReEnteredData value, $Res Function(TicketReEnteredData) then) =
      _$TicketReEnteredDataCopyWithImpl<$Res, TicketReEnteredData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_id') int ticketId,
      @JsonKey(name: 'ticket_uuid') String ticketUuid,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'scanned_at') DateTime? scannedAt,
      @JsonKey(name: 'scan_location') String? scanLocation,
      @JsonKey(name: 'check_in_count') int? checkInCount,
      @JsonKey(name: 'attendee_name') String? attendeeName});
}

/// @nodoc
class _$TicketReEnteredDataCopyWithImpl<$Res, $Val extends TicketReEnteredData>
    implements $TicketReEnteredDataCopyWith<$Res> {
  _$TicketReEnteredDataCopyWithImpl(this._value, this._then);

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
    Object? scannedAt = freezed,
    Object? scanLocation = freezed,
    Object? checkInCount = freezed,
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
      scannedAt: freezed == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scanLocation: freezed == scanLocation
          ? _value.scanLocation
          : scanLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      checkInCount: freezed == checkInCount
          ? _value.checkInCount
          : checkInCount // ignore: cast_nullable_to_non_nullable
              as int?,
      attendeeName: freezed == attendeeName
          ? _value.attendeeName
          : attendeeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketReEnteredDataImplCopyWith<$Res>
    implements $TicketReEnteredDataCopyWith<$Res> {
  factory _$$TicketReEnteredDataImplCopyWith(_$TicketReEnteredDataImpl value,
          $Res Function(_$TicketReEnteredDataImpl) then) =
      __$$TicketReEnteredDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_id') int ticketId,
      @JsonKey(name: 'ticket_uuid') String ticketUuid,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'scanned_at') DateTime? scannedAt,
      @JsonKey(name: 'scan_location') String? scanLocation,
      @JsonKey(name: 'check_in_count') int? checkInCount,
      @JsonKey(name: 'attendee_name') String? attendeeName});
}

/// @nodoc
class __$$TicketReEnteredDataImplCopyWithImpl<$Res>
    extends _$TicketReEnteredDataCopyWithImpl<$Res, _$TicketReEnteredDataImpl>
    implements _$$TicketReEnteredDataImplCopyWith<$Res> {
  __$$TicketReEnteredDataImplCopyWithImpl(_$TicketReEnteredDataImpl _value,
      $Res Function(_$TicketReEnteredDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? ticketUuid = null,
    Object? qrCode = null,
    Object? eventId = null,
    Object? scannedAt = freezed,
    Object? scanLocation = freezed,
    Object? checkInCount = freezed,
    Object? attendeeName = freezed,
  }) {
    return _then(_$TicketReEnteredDataImpl(
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
      scannedAt: freezed == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scanLocation: freezed == scanLocation
          ? _value.scanLocation
          : scanLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      checkInCount: freezed == checkInCount
          ? _value.checkInCount
          : checkInCount // ignore: cast_nullable_to_non_nullable
              as int?,
      attendeeName: freezed == attendeeName
          ? _value.attendeeName
          : attendeeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$TicketReEnteredDataImpl implements _TicketReEnteredData {
  const _$TicketReEnteredDataImpl(
      {@JsonKey(name: 'ticket_id') required this.ticketId,
      @JsonKey(name: 'ticket_uuid') required this.ticketUuid,
      @JsonKey(name: 'qr_code') required this.qrCode,
      @JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'scanned_at') this.scannedAt,
      @JsonKey(name: 'scan_location') this.scanLocation,
      @JsonKey(name: 'check_in_count') this.checkInCount,
      @JsonKey(name: 'attendee_name') this.attendeeName});

  factory _$TicketReEnteredDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketReEnteredDataImplFromJson(json);

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
  @JsonKey(name: 'scanned_at')
  final DateTime? scannedAt;
  @override
  @JsonKey(name: 'scan_location')
  final String? scanLocation;
  @override
  @JsonKey(name: 'check_in_count')
  final int? checkInCount;
  @override
  @JsonKey(name: 'attendee_name')
  final String? attendeeName;

  @override
  String toString() {
    return 'TicketReEnteredData(ticketId: $ticketId, ticketUuid: $ticketUuid, qrCode: $qrCode, eventId: $eventId, scannedAt: $scannedAt, scanLocation: $scanLocation, checkInCount: $checkInCount, attendeeName: $attendeeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketReEnteredDataImpl &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.ticketUuid, ticketUuid) ||
                other.ticketUuid == ticketUuid) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt) &&
            (identical(other.scanLocation, scanLocation) ||
                other.scanLocation == scanLocation) &&
            (identical(other.checkInCount, checkInCount) ||
                other.checkInCount == checkInCount) &&
            (identical(other.attendeeName, attendeeName) ||
                other.attendeeName == attendeeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ticketId, ticketUuid, qrCode,
      eventId, scannedAt, scanLocation, checkInCount, attendeeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketReEnteredDataImplCopyWith<_$TicketReEnteredDataImpl> get copyWith =>
      __$$TicketReEnteredDataImplCopyWithImpl<_$TicketReEnteredDataImpl>(
          this, _$identity);
}

abstract class _TicketReEnteredData implements TicketReEnteredData {
  const factory _TicketReEnteredData(
          {@JsonKey(name: 'ticket_id') required final int ticketId,
          @JsonKey(name: 'ticket_uuid') required final String ticketUuid,
          @JsonKey(name: 'qr_code') required final String qrCode,
          @JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'scanned_at') final DateTime? scannedAt,
          @JsonKey(name: 'scan_location') final String? scanLocation,
          @JsonKey(name: 'check_in_count') final int? checkInCount,
          @JsonKey(name: 'attendee_name') final String? attendeeName}) =
      _$TicketReEnteredDataImpl;

  factory _TicketReEnteredData.fromJson(Map<String, dynamic> json) =
      _$TicketReEnteredDataImpl.fromJson;

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
  @JsonKey(name: 'scanned_at')
  DateTime? get scannedAt;
  @override
  @JsonKey(name: 'scan_location')
  String? get scanLocation;
  @override
  @JsonKey(name: 'check_in_count')
  int? get checkInCount;
  @override
  @JsonKey(name: 'attendee_name')
  String? get attendeeName;
  @override
  @JsonKey(ignore: true)
  _$$TicketReEnteredDataImplCopyWith<_$TicketReEnteredDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TicketReEnteredNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  TicketReEnteredData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketReEnteredNotificationCopyWith<TicketReEnteredNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketReEnteredNotificationCopyWith<$Res> {
  factory $TicketReEnteredNotificationCopyWith(
          TicketReEnteredNotification value,
          $Res Function(TicketReEnteredNotification) then) =
      _$TicketReEnteredNotificationCopyWithImpl<$Res,
          TicketReEnteredNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      TicketReEnteredData data,
      DateTime? receivedAt});

  $TicketReEnteredDataCopyWith<$Res> get data;
}

/// @nodoc
class _$TicketReEnteredNotificationCopyWithImpl<$Res,
        $Val extends TicketReEnteredNotification>
    implements $TicketReEnteredNotificationCopyWith<$Res> {
  _$TicketReEnteredNotificationCopyWithImpl(this._value, this._then);

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
              as TicketReEnteredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TicketReEnteredDataCopyWith<$Res> get data {
    return $TicketReEnteredDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TicketReEnteredNotificationImplCopyWith<$Res>
    implements $TicketReEnteredNotificationCopyWith<$Res> {
  factory _$$TicketReEnteredNotificationImplCopyWith(
          _$TicketReEnteredNotificationImpl value,
          $Res Function(_$TicketReEnteredNotificationImpl) then) =
      __$$TicketReEnteredNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      TicketReEnteredData data,
      DateTime? receivedAt});

  @override
  $TicketReEnteredDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$TicketReEnteredNotificationImplCopyWithImpl<$Res>
    extends _$TicketReEnteredNotificationCopyWithImpl<$Res,
        _$TicketReEnteredNotificationImpl>
    implements _$$TicketReEnteredNotificationImplCopyWith<$Res> {
  __$$TicketReEnteredNotificationImplCopyWithImpl(
      _$TicketReEnteredNotificationImpl _value,
      $Res Function(_$TicketReEnteredNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$TicketReEnteredNotificationImpl(
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
              as TicketReEnteredData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$TicketReEnteredNotificationImpl
    implements _TicketReEnteredNotification {
  const _$TicketReEnteredNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final TicketReEnteredData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'TicketReEnteredNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketReEnteredNotificationImpl &&
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
  _$$TicketReEnteredNotificationImplCopyWith<_$TicketReEnteredNotificationImpl>
      get copyWith => __$$TicketReEnteredNotificationImplCopyWithImpl<
          _$TicketReEnteredNotificationImpl>(this, _$identity);
}

abstract class _TicketReEnteredNotification
    implements TicketReEnteredNotification {
  const factory _TicketReEnteredNotification(
      {required final String event,
      final String? channel,
      required final TicketReEnteredData data,
      final DateTime? receivedAt}) = _$TicketReEnteredNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  TicketReEnteredData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$TicketReEnteredNotificationImplCopyWith<_$TicketReEnteredNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

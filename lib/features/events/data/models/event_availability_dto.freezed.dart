// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_availability_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventAvailabilityResponseDto _$EventAvailabilityResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _EventAvailabilityResponseDto.fromJson(json);
}

/// @nodoc
mixin _$EventAvailabilityResponseDto {
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'calendar_type', fromJson: _parseString)
  String get calendarType => throw _privateConstructorUsedError;
  List<AvailabilitySlotDto> get slots => throw _privateConstructorUsedError;
  List<AvailabilityTicketDto> get tickets => throw _privateConstructorUsedError;
  RecurrenceDto? get recurrence => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_settings')
  BookingSettingsDto? get bookingSettings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventAvailabilityResponseDtoCopyWith<EventAvailabilityResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventAvailabilityResponseDtoCopyWith<$Res> {
  factory $EventAvailabilityResponseDtoCopyWith(
          EventAvailabilityResponseDto value,
          $Res Function(EventAvailabilityResponseDto) then) =
      _$EventAvailabilityResponseDtoCopyWithImpl<$Res,
          EventAvailabilityResponseDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'calendar_type', fromJson: _parseString)
      String calendarType,
      List<AvailabilitySlotDto> slots,
      List<AvailabilityTicketDto> tickets,
      RecurrenceDto? recurrence,
      @JsonKey(name: 'booking_settings') BookingSettingsDto? bookingSettings});

  $RecurrenceDtoCopyWith<$Res>? get recurrence;
  $BookingSettingsDtoCopyWith<$Res>? get bookingSettings;
}

/// @nodoc
class _$EventAvailabilityResponseDtoCopyWithImpl<$Res,
        $Val extends EventAvailabilityResponseDto>
    implements $EventAvailabilityResponseDtoCopyWith<$Res> {
  _$EventAvailabilityResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? calendarType = null,
    Object? slots = null,
    Object? tickets = null,
    Object? recurrence = freezed,
    Object? bookingSettings = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      calendarType: null == calendarType
          ? _value.calendarType
          : calendarType // ignore: cast_nullable_to_non_nullable
              as String,
      slots: null == slots
          ? _value.slots
          : slots // ignore: cast_nullable_to_non_nullable
              as List<AvailabilitySlotDto>,
      tickets: null == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<AvailabilityTicketDto>,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceDto?,
      bookingSettings: freezed == bookingSettings
          ? _value.bookingSettings
          : bookingSettings // ignore: cast_nullable_to_non_nullable
              as BookingSettingsDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecurrenceDtoCopyWith<$Res>? get recurrence {
    if (_value.recurrence == null) {
      return null;
    }

    return $RecurrenceDtoCopyWith<$Res>(_value.recurrence!, (value) {
      return _then(_value.copyWith(recurrence: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingSettingsDtoCopyWith<$Res>? get bookingSettings {
    if (_value.bookingSettings == null) {
      return null;
    }

    return $BookingSettingsDtoCopyWith<$Res>(_value.bookingSettings!, (value) {
      return _then(_value.copyWith(bookingSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventAvailabilityResponseDtoImplCopyWith<$Res>
    implements $EventAvailabilityResponseDtoCopyWith<$Res> {
  factory _$$EventAvailabilityResponseDtoImplCopyWith(
          _$EventAvailabilityResponseDtoImpl value,
          $Res Function(_$EventAvailabilityResponseDtoImpl) then) =
      __$$EventAvailabilityResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      @JsonKey(name: 'calendar_type', fromJson: _parseString)
      String calendarType,
      List<AvailabilitySlotDto> slots,
      List<AvailabilityTicketDto> tickets,
      RecurrenceDto? recurrence,
      @JsonKey(name: 'booking_settings') BookingSettingsDto? bookingSettings});

  @override
  $RecurrenceDtoCopyWith<$Res>? get recurrence;
  @override
  $BookingSettingsDtoCopyWith<$Res>? get bookingSettings;
}

/// @nodoc
class __$$EventAvailabilityResponseDtoImplCopyWithImpl<$Res>
    extends _$EventAvailabilityResponseDtoCopyWithImpl<$Res,
        _$EventAvailabilityResponseDtoImpl>
    implements _$$EventAvailabilityResponseDtoImplCopyWith<$Res> {
  __$$EventAvailabilityResponseDtoImplCopyWithImpl(
      _$EventAvailabilityResponseDtoImpl _value,
      $Res Function(_$EventAvailabilityResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? calendarType = null,
    Object? slots = null,
    Object? tickets = null,
    Object? recurrence = freezed,
    Object? bookingSettings = freezed,
  }) {
    return _then(_$EventAvailabilityResponseDtoImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      calendarType: null == calendarType
          ? _value.calendarType
          : calendarType // ignore: cast_nullable_to_non_nullable
              as String,
      slots: null == slots
          ? _value._slots
          : slots // ignore: cast_nullable_to_non_nullable
              as List<AvailabilitySlotDto>,
      tickets: null == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<AvailabilityTicketDto>,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceDto?,
      bookingSettings: freezed == bookingSettings
          ? _value.bookingSettings
          : bookingSettings // ignore: cast_nullable_to_non_nullable
              as BookingSettingsDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventAvailabilityResponseDtoImpl
    implements _EventAvailabilityResponseDto {
  const _$EventAvailabilityResponseDtoImpl(
      {@JsonKey(name: 'event_id') required this.eventId,
      @JsonKey(name: 'calendar_type', fromJson: _parseString)
      this.calendarType = 'manual',
      final List<AvailabilitySlotDto> slots = const [],
      final List<AvailabilityTicketDto> tickets = const [],
      this.recurrence,
      @JsonKey(name: 'booking_settings') this.bookingSettings})
      : _slots = slots,
        _tickets = tickets;

  factory _$EventAvailabilityResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$EventAvailabilityResponseDtoImplFromJson(json);

  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  @override
  @JsonKey(name: 'calendar_type', fromJson: _parseString)
  final String calendarType;
  final List<AvailabilitySlotDto> _slots;
  @override
  @JsonKey()
  List<AvailabilitySlotDto> get slots {
    if (_slots is EqualUnmodifiableListView) return _slots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slots);
  }

  final List<AvailabilityTicketDto> _tickets;
  @override
  @JsonKey()
  List<AvailabilityTicketDto> get tickets {
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tickets);
  }

  @override
  final RecurrenceDto? recurrence;
  @override
  @JsonKey(name: 'booking_settings')
  final BookingSettingsDto? bookingSettings;

  @override
  String toString() {
    return 'EventAvailabilityResponseDto(eventId: $eventId, calendarType: $calendarType, slots: $slots, tickets: $tickets, recurrence: $recurrence, bookingSettings: $bookingSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventAvailabilityResponseDtoImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.calendarType, calendarType) ||
                other.calendarType == calendarType) &&
            const DeepCollectionEquality().equals(other._slots, _slots) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.bookingSettings, bookingSettings) ||
                other.bookingSettings == bookingSettings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      calendarType,
      const DeepCollectionEquality().hash(_slots),
      const DeepCollectionEquality().hash(_tickets),
      recurrence,
      bookingSettings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventAvailabilityResponseDtoImplCopyWith<
          _$EventAvailabilityResponseDtoImpl>
      get copyWith => __$$EventAvailabilityResponseDtoImplCopyWithImpl<
          _$EventAvailabilityResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventAvailabilityResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _EventAvailabilityResponseDto
    implements EventAvailabilityResponseDto {
  const factory _EventAvailabilityResponseDto(
          {@JsonKey(name: 'event_id') required final int eventId,
          @JsonKey(name: 'calendar_type', fromJson: _parseString)
          final String calendarType,
          final List<AvailabilitySlotDto> slots,
          final List<AvailabilityTicketDto> tickets,
          final RecurrenceDto? recurrence,
          @JsonKey(name: 'booking_settings')
          final BookingSettingsDto? bookingSettings}) =
      _$EventAvailabilityResponseDtoImpl;

  factory _EventAvailabilityResponseDto.fromJson(Map<String, dynamic> json) =
      _$EventAvailabilityResponseDtoImpl.fromJson;

  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  @JsonKey(name: 'calendar_type', fromJson: _parseString)
  String get calendarType;
  @override
  List<AvailabilitySlotDto> get slots;
  @override
  List<AvailabilityTicketDto> get tickets;
  @override
  RecurrenceDto? get recurrence;
  @override
  @JsonKey(name: 'booking_settings')
  BookingSettingsDto? get bookingSettings;
  @override
  @JsonKey(ignore: true)
  _$$EventAvailabilityResponseDtoImplCopyWith<
          _$EventAvailabilityResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AvailabilitySlotDto _$AvailabilitySlotDtoFromJson(Map<String, dynamic> json) {
  return _AvailabilitySlotDto.fromJson(json);
}

/// @nodoc
mixin _$AvailabilitySlotDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
  String? get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
  String? get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull)
  int? get spotsTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
  int? get spotsRemaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available', fromJson: _parseBool)
  bool get isAvailable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailabilitySlotDtoCopyWith<AvailabilitySlotDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailabilitySlotDtoCopyWith<$Res> {
  factory $AvailabilitySlotDtoCopyWith(
          AvailabilitySlotDto value, $Res Function(AvailabilitySlotDto) then) =
      _$AvailabilitySlotDtoCopyWithImpl<$Res, AvailabilitySlotDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _parseString) String date,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
      String? startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) String? endTime,
      @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull) int? spotsTotal,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      int? spotsRemaining,
      @JsonKey(name: 'is_available', fromJson: _parseBool) bool isAvailable});
}

/// @nodoc
class _$AvailabilitySlotDtoCopyWithImpl<$Res, $Val extends AvailabilitySlotDto>
    implements $AvailabilitySlotDtoCopyWith<$Res> {
  _$AvailabilitySlotDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? spotsTotal = freezed,
    Object? spotsRemaining = freezed,
    Object? isAvailable = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      spotsTotal: freezed == spotsTotal
          ? _value.spotsTotal
          : spotsTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      spotsRemaining: freezed == spotsRemaining
          ? _value.spotsRemaining
          : spotsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailabilitySlotDtoImplCopyWith<$Res>
    implements $AvailabilitySlotDtoCopyWith<$Res> {
  factory _$$AvailabilitySlotDtoImplCopyWith(_$AvailabilitySlotDtoImpl value,
          $Res Function(_$AvailabilitySlotDtoImpl) then) =
      __$$AvailabilitySlotDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _parseString) String date,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
      String? startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) String? endTime,
      @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull) int? spotsTotal,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      int? spotsRemaining,
      @JsonKey(name: 'is_available', fromJson: _parseBool) bool isAvailable});
}

/// @nodoc
class __$$AvailabilitySlotDtoImplCopyWithImpl<$Res>
    extends _$AvailabilitySlotDtoCopyWithImpl<$Res, _$AvailabilitySlotDtoImpl>
    implements _$$AvailabilitySlotDtoImplCopyWith<$Res> {
  __$$AvailabilitySlotDtoImplCopyWithImpl(_$AvailabilitySlotDtoImpl _value,
      $Res Function(_$AvailabilitySlotDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? spotsTotal = freezed,
    Object? spotsRemaining = freezed,
    Object? isAvailable = null,
  }) {
    return _then(_$AvailabilitySlotDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      spotsTotal: freezed == spotsTotal
          ? _value.spotsTotal
          : spotsTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      spotsRemaining: freezed == spotsRemaining
          ? _value.spotsRemaining
          : spotsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailabilitySlotDtoImpl implements _AvailabilitySlotDto {
  const _$AvailabilitySlotDtoImpl(
      {required this.id,
      @JsonKey(fromJson: _parseString) required this.date,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull) this.startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) this.endTime,
      @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull) this.spotsTotal,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      this.spotsRemaining,
      @JsonKey(name: 'is_available', fromJson: _parseBool)
      this.isAvailable = true});

  factory _$AvailabilitySlotDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailabilitySlotDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(fromJson: _parseString)
  final String date;
  @override
  @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
  final String? startTime;
  @override
  @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
  final String? endTime;
  @override
  @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull)
  final int? spotsTotal;
  @override
  @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
  final int? spotsRemaining;
  @override
  @JsonKey(name: 'is_available', fromJson: _parseBool)
  final bool isAvailable;

  @override
  String toString() {
    return 'AvailabilitySlotDto(id: $id, date: $date, startTime: $startTime, endTime: $endTime, spotsTotal: $spotsTotal, spotsRemaining: $spotsRemaining, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailabilitySlotDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.spotsTotal, spotsTotal) ||
                other.spotsTotal == spotsTotal) &&
            (identical(other.spotsRemaining, spotsRemaining) ||
                other.spotsRemaining == spotsRemaining) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, startTime, endTime,
      spotsTotal, spotsRemaining, isAvailable);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailabilitySlotDtoImplCopyWith<_$AvailabilitySlotDtoImpl> get copyWith =>
      __$$AvailabilitySlotDtoImplCopyWithImpl<_$AvailabilitySlotDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailabilitySlotDtoImplToJson(
      this,
    );
  }
}

abstract class _AvailabilitySlotDto implements AvailabilitySlotDto {
  const factory _AvailabilitySlotDto(
      {required final String id,
      @JsonKey(fromJson: _parseString) required final String date,
      @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
      final String? startTime,
      @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
      final String? endTime,
      @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull)
      final int? spotsTotal,
      @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
      final int? spotsRemaining,
      @JsonKey(name: 'is_available', fromJson: _parseBool)
      final bool isAvailable}) = _$AvailabilitySlotDtoImpl;

  factory _AvailabilitySlotDto.fromJson(Map<String, dynamic> json) =
      _$AvailabilitySlotDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(fromJson: _parseString)
  String get date;
  @override
  @JsonKey(name: 'start_time', fromJson: _parseStringOrNull)
  String? get startTime;
  @override
  @JsonKey(name: 'end_time', fromJson: _parseStringOrNull)
  String? get endTime;
  @override
  @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull)
  int? get spotsTotal;
  @override
  @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull)
  int? get spotsRemaining;
  @override
  @JsonKey(name: 'is_available', fromJson: _parseBool)
  bool get isAvailable;
  @override
  @JsonKey(ignore: true)
  _$$AvailabilitySlotDtoImplCopyWith<_$AvailabilitySlotDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailabilityTicketDto _$AvailabilityTicketDtoFromJson(
    Map<String, dynamic> json) {
  return _AvailabilityTicketDto.fromJson(json);
}

/// @nodoc
mixin _$AvailabilityTicketDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_per_booking', fromJson: _parseInt)
  int get minPerBooking => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_per_booking', fromJson: _parseInt)
  int get maxPerBooking => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
  int? get quantityTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
  int? get quantityRemaining => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseBool)
  bool get available => throw _privateConstructorUsedError;
  @JsonKey(name: 'person_types')
  List<PersonTypeDto> get personTypes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailabilityTicketDtoCopyWith<AvailabilityTicketDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailabilityTicketDtoCopyWith<$Res> {
  factory $AvailabilityTicketDtoCopyWith(AvailabilityTicketDto value,
          $Res Function(AvailabilityTicketDto) then) =
      _$AvailabilityTicketDtoCopyWithImpl<$Res, AvailabilityTicketDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseDouble) double price,
      String currency,
      @JsonKey(fromJson: _parseStringOrNull) String? description,
      @JsonKey(name: 'min_per_booking', fromJson: _parseInt) int minPerBooking,
      @JsonKey(name: 'max_per_booking', fromJson: _parseInt) int maxPerBooking,
      @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
      int? quantityTotal,
      @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
      int? quantityRemaining,
      @JsonKey(fromJson: _parseBool) bool available,
      @JsonKey(name: 'person_types') List<PersonTypeDto> personTypes});
}

/// @nodoc
class _$AvailabilityTicketDtoCopyWithImpl<$Res,
        $Val extends AvailabilityTicketDto>
    implements $AvailabilityTicketDtoCopyWith<$Res> {
  _$AvailabilityTicketDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? description = freezed,
    Object? minPerBooking = null,
    Object? maxPerBooking = null,
    Object? quantityTotal = freezed,
    Object? quantityRemaining = freezed,
    Object? available = null,
    Object? personTypes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      minPerBooking: null == minPerBooking
          ? _value.minPerBooking
          : minPerBooking // ignore: cast_nullable_to_non_nullable
              as int,
      maxPerBooking: null == maxPerBooking
          ? _value.maxPerBooking
          : maxPerBooking // ignore: cast_nullable_to_non_nullable
              as int,
      quantityTotal: freezed == quantityTotal
          ? _value.quantityTotal
          : quantityTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityRemaining: freezed == quantityRemaining
          ? _value.quantityRemaining
          : quantityRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      personTypes: null == personTypes
          ? _value.personTypes
          : personTypes // ignore: cast_nullable_to_non_nullable
              as List<PersonTypeDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailabilityTicketDtoImplCopyWith<$Res>
    implements $AvailabilityTicketDtoCopyWith<$Res> {
  factory _$$AvailabilityTicketDtoImplCopyWith(
          _$AvailabilityTicketDtoImpl value,
          $Res Function(_$AvailabilityTicketDtoImpl) then) =
      __$$AvailabilityTicketDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseDouble) double price,
      String currency,
      @JsonKey(fromJson: _parseStringOrNull) String? description,
      @JsonKey(name: 'min_per_booking', fromJson: _parseInt) int minPerBooking,
      @JsonKey(name: 'max_per_booking', fromJson: _parseInt) int maxPerBooking,
      @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
      int? quantityTotal,
      @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
      int? quantityRemaining,
      @JsonKey(fromJson: _parseBool) bool available,
      @JsonKey(name: 'person_types') List<PersonTypeDto> personTypes});
}

/// @nodoc
class __$$AvailabilityTicketDtoImplCopyWithImpl<$Res>
    extends _$AvailabilityTicketDtoCopyWithImpl<$Res,
        _$AvailabilityTicketDtoImpl>
    implements _$$AvailabilityTicketDtoImplCopyWith<$Res> {
  __$$AvailabilityTicketDtoImplCopyWithImpl(_$AvailabilityTicketDtoImpl _value,
      $Res Function(_$AvailabilityTicketDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? description = freezed,
    Object? minPerBooking = null,
    Object? maxPerBooking = null,
    Object? quantityTotal = freezed,
    Object? quantityRemaining = freezed,
    Object? available = null,
    Object? personTypes = null,
  }) {
    return _then(_$AvailabilityTicketDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      minPerBooking: null == minPerBooking
          ? _value.minPerBooking
          : minPerBooking // ignore: cast_nullable_to_non_nullable
              as int,
      maxPerBooking: null == maxPerBooking
          ? _value.maxPerBooking
          : maxPerBooking // ignore: cast_nullable_to_non_nullable
              as int,
      quantityTotal: freezed == quantityTotal
          ? _value.quantityTotal
          : quantityTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityRemaining: freezed == quantityRemaining
          ? _value.quantityRemaining
          : quantityRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      personTypes: null == personTypes
          ? _value._personTypes
          : personTypes // ignore: cast_nullable_to_non_nullable
              as List<PersonTypeDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailabilityTicketDtoImpl implements _AvailabilityTicketDto {
  const _$AvailabilityTicketDtoImpl(
      {required this.id,
      @JsonKey(fromJson: _parseString) this.name = '',
      @JsonKey(fromJson: _parseDouble) this.price = 0,
      this.currency = 'EUR',
      @JsonKey(fromJson: _parseStringOrNull) this.description,
      @JsonKey(name: 'min_per_booking', fromJson: _parseInt)
      this.minPerBooking = 1,
      @JsonKey(name: 'max_per_booking', fromJson: _parseInt)
      this.maxPerBooking = 10,
      @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
      this.quantityTotal,
      @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
      this.quantityRemaining,
      @JsonKey(fromJson: _parseBool) this.available = true,
      @JsonKey(name: 'person_types')
      final List<PersonTypeDto> personTypes = const []})
      : _personTypes = personTypes;

  factory _$AvailabilityTicketDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailabilityTicketDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(fromJson: _parseString)
  final String name;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? description;
  @override
  @JsonKey(name: 'min_per_booking', fromJson: _parseInt)
  final int minPerBooking;
  @override
  @JsonKey(name: 'max_per_booking', fromJson: _parseInt)
  final int maxPerBooking;
  @override
  @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
  final int? quantityTotal;
  @override
  @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
  final int? quantityRemaining;
  @override
  @JsonKey(fromJson: _parseBool)
  final bool available;
  final List<PersonTypeDto> _personTypes;
  @override
  @JsonKey(name: 'person_types')
  List<PersonTypeDto> get personTypes {
    if (_personTypes is EqualUnmodifiableListView) return _personTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_personTypes);
  }

  @override
  String toString() {
    return 'AvailabilityTicketDto(id: $id, name: $name, price: $price, currency: $currency, description: $description, minPerBooking: $minPerBooking, maxPerBooking: $maxPerBooking, quantityTotal: $quantityTotal, quantityRemaining: $quantityRemaining, available: $available, personTypes: $personTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailabilityTicketDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.minPerBooking, minPerBooking) ||
                other.minPerBooking == minPerBooking) &&
            (identical(other.maxPerBooking, maxPerBooking) ||
                other.maxPerBooking == maxPerBooking) &&
            (identical(other.quantityTotal, quantityTotal) ||
                other.quantityTotal == quantityTotal) &&
            (identical(other.quantityRemaining, quantityRemaining) ||
                other.quantityRemaining == quantityRemaining) &&
            (identical(other.available, available) ||
                other.available == available) &&
            const DeepCollectionEquality()
                .equals(other._personTypes, _personTypes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      price,
      currency,
      description,
      minPerBooking,
      maxPerBooking,
      quantityTotal,
      quantityRemaining,
      available,
      const DeepCollectionEquality().hash(_personTypes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailabilityTicketDtoImplCopyWith<_$AvailabilityTicketDtoImpl>
      get copyWith => __$$AvailabilityTicketDtoImplCopyWithImpl<
          _$AvailabilityTicketDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailabilityTicketDtoImplToJson(
      this,
    );
  }
}

abstract class _AvailabilityTicketDto implements AvailabilityTicketDto {
  const factory _AvailabilityTicketDto(
      {required final String id,
      @JsonKey(fromJson: _parseString) final String name,
      @JsonKey(fromJson: _parseDouble) final double price,
      final String currency,
      @JsonKey(fromJson: _parseStringOrNull) final String? description,
      @JsonKey(name: 'min_per_booking', fromJson: _parseInt)
      final int minPerBooking,
      @JsonKey(name: 'max_per_booking', fromJson: _parseInt)
      final int maxPerBooking,
      @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
      final int? quantityTotal,
      @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
      final int? quantityRemaining,
      @JsonKey(fromJson: _parseBool) final bool available,
      @JsonKey(name: 'person_types')
      final List<PersonTypeDto> personTypes}) = _$AvailabilityTicketDtoImpl;

  factory _AvailabilityTicketDto.fromJson(Map<String, dynamic> json) =
      _$AvailabilityTicketDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(fromJson: _parseString)
  String get name;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get price;
  @override
  String get currency;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get description;
  @override
  @JsonKey(name: 'min_per_booking', fromJson: _parseInt)
  int get minPerBooking;
  @override
  @JsonKey(name: 'max_per_booking', fromJson: _parseInt)
  int get maxPerBooking;
  @override
  @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull)
  int? get quantityTotal;
  @override
  @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull)
  int? get quantityRemaining;
  @override
  @JsonKey(fromJson: _parseBool)
  bool get available;
  @override
  @JsonKey(name: 'person_types')
  List<PersonTypeDto> get personTypes;
  @override
  @JsonKey(ignore: true)
  _$$AvailabilityTicketDtoImplCopyWith<_$AvailabilityTicketDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PersonTypeDto _$PersonTypeDtoFromJson(Map<String, dynamic> json) {
  return _PersonTypeDto.fromJson(json);
}

/// @nodoc
mixin _$PersonTypeDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get min => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get max => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PersonTypeDtoCopyWith<PersonTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonTypeDtoCopyWith<$Res> {
  factory $PersonTypeDtoCopyWith(
          PersonTypeDto value, $Res Function(PersonTypeDto) then) =
      _$PersonTypeDtoCopyWithImpl<$Res, PersonTypeDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseDouble) double price,
      @JsonKey(fromJson: _parseInt) int min,
      @JsonKey(fromJson: _parseInt) int max});
}

/// @nodoc
class _$PersonTypeDtoCopyWithImpl<$Res, $Val extends PersonTypeDto>
    implements $PersonTypeDtoCopyWith<$Res> {
  _$PersonTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? min = null,
    Object? max = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as int,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonTypeDtoImplCopyWith<$Res>
    implements $PersonTypeDtoCopyWith<$Res> {
  factory _$$PersonTypeDtoImplCopyWith(
          _$PersonTypeDtoImpl value, $Res Function(_$PersonTypeDtoImpl) then) =
      __$$PersonTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseDouble) double price,
      @JsonKey(fromJson: _parseInt) int min,
      @JsonKey(fromJson: _parseInt) int max});
}

/// @nodoc
class __$$PersonTypeDtoImplCopyWithImpl<$Res>
    extends _$PersonTypeDtoCopyWithImpl<$Res, _$PersonTypeDtoImpl>
    implements _$$PersonTypeDtoImplCopyWith<$Res> {
  __$$PersonTypeDtoImplCopyWithImpl(
      _$PersonTypeDtoImpl _value, $Res Function(_$PersonTypeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? min = null,
    Object? max = null,
  }) {
    return _then(_$PersonTypeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as int,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonTypeDtoImpl implements _PersonTypeDto {
  const _$PersonTypeDtoImpl(
      {required this.id,
      @JsonKey(fromJson: _parseString) this.name = '',
      @JsonKey(fromJson: _parseDouble) this.price = 0,
      @JsonKey(fromJson: _parseInt) this.min = 0,
      @JsonKey(fromJson: _parseInt) this.max = 10});

  factory _$PersonTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonTypeDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(fromJson: _parseString)
  final String name;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double price;
  @override
  @JsonKey(fromJson: _parseInt)
  final int min;
  @override
  @JsonKey(fromJson: _parseInt)
  final int max;

  @override
  String toString() {
    return 'PersonTypeDto(id: $id, name: $name, price: $price, min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, min, max);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonTypeDtoImplCopyWith<_$PersonTypeDtoImpl> get copyWith =>
      __$$PersonTypeDtoImplCopyWithImpl<_$PersonTypeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonTypeDtoImplToJson(
      this,
    );
  }
}

abstract class _PersonTypeDto implements PersonTypeDto {
  const factory _PersonTypeDto(
      {required final String id,
      @JsonKey(fromJson: _parseString) final String name,
      @JsonKey(fromJson: _parseDouble) final double price,
      @JsonKey(fromJson: _parseInt) final int min,
      @JsonKey(fromJson: _parseInt) final int max}) = _$PersonTypeDtoImpl;

  factory _PersonTypeDto.fromJson(Map<String, dynamic> json) =
      _$PersonTypeDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(fromJson: _parseString)
  String get name;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get price;
  @override
  @JsonKey(fromJson: _parseInt)
  int get min;
  @override
  @JsonKey(fromJson: _parseInt)
  int get max;
  @override
  @JsonKey(ignore: true)
  _$$PersonTypeDtoImplCopyWith<_$PersonTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurrenceDto _$RecurrenceDtoFromJson(Map<String, dynamic> json) {
  return _RecurrenceDto.fromJson(json);
}

/// @nodoc
mixin _$RecurrenceDto {
  @JsonKey(fromJson: _parseString)
  String get frequency => throw _privateConstructorUsedError;
  List<String> get days => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
  String? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
  String? get defaultStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
  String? get defaultEndTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecurrenceDtoCopyWith<RecurrenceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceDtoCopyWith<$Res> {
  factory $RecurrenceDtoCopyWith(
          RecurrenceDto value, $Res Function(RecurrenceDto) then) =
      _$RecurrenceDtoCopyWithImpl<$Res, RecurrenceDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseString) String frequency,
      List<String> days,
      @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      String? startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) String? endDate,
      @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
      String? defaultStartTime,
      @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
      String? defaultEndTime});
}

/// @nodoc
class _$RecurrenceDtoCopyWithImpl<$Res, $Val extends RecurrenceDto>
    implements $RecurrenceDtoCopyWith<$Res> {
  _$RecurrenceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? days = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? defaultStartTime = freezed,
    Object? defaultEndTime = freezed,
  }) {
    return _then(_value.copyWith(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultStartTime: freezed == defaultStartTime
          ? _value.defaultStartTime
          : defaultStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultEndTime: freezed == defaultEndTime
          ? _value.defaultEndTime
          : defaultEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurrenceDtoImplCopyWith<$Res>
    implements $RecurrenceDtoCopyWith<$Res> {
  factory _$$RecurrenceDtoImplCopyWith(
          _$RecurrenceDtoImpl value, $Res Function(_$RecurrenceDtoImpl) then) =
      __$$RecurrenceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseString) String frequency,
      List<String> days,
      @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      String? startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) String? endDate,
      @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
      String? defaultStartTime,
      @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
      String? defaultEndTime});
}

/// @nodoc
class __$$RecurrenceDtoImplCopyWithImpl<$Res>
    extends _$RecurrenceDtoCopyWithImpl<$Res, _$RecurrenceDtoImpl>
    implements _$$RecurrenceDtoImplCopyWith<$Res> {
  __$$RecurrenceDtoImplCopyWithImpl(
      _$RecurrenceDtoImpl _value, $Res Function(_$RecurrenceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? days = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? defaultStartTime = freezed,
    Object? defaultEndTime = freezed,
  }) {
    return _then(_$RecurrenceDtoImpl(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultStartTime: freezed == defaultStartTime
          ? _value.defaultStartTime
          : defaultStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultEndTime: freezed == defaultEndTime
          ? _value.defaultEndTime
          : defaultEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceDtoImpl implements _RecurrenceDto {
  const _$RecurrenceDtoImpl(
      {@JsonKey(fromJson: _parseString) this.frequency = 'weekly',
      final List<String> days = const [],
      @JsonKey(name: 'start_date', fromJson: _parseStringOrNull) this.startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) this.endDate,
      @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
      this.defaultStartTime,
      @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
      this.defaultEndTime})
      : _days = days;

  factory _$RecurrenceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseString)
  final String frequency;
  final List<String> _days;
  @override
  @JsonKey()
  List<String> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
  final String? startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
  final String? endDate;
  @override
  @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
  final String? defaultStartTime;
  @override
  @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
  final String? defaultEndTime;

  @override
  String toString() {
    return 'RecurrenceDto(frequency: $frequency, days: $days, startDate: $startDate, endDate: $endDate, defaultStartTime: $defaultStartTime, defaultEndTime: $defaultEndTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceDtoImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.defaultStartTime, defaultStartTime) ||
                other.defaultStartTime == defaultStartTime) &&
            (identical(other.defaultEndTime, defaultEndTime) ||
                other.defaultEndTime == defaultEndTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frequency,
      const DeepCollectionEquality().hash(_days),
      startDate,
      endDate,
      defaultStartTime,
      defaultEndTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceDtoImplCopyWith<_$RecurrenceDtoImpl> get copyWith =>
      __$$RecurrenceDtoImplCopyWithImpl<_$RecurrenceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceDtoImplToJson(
      this,
    );
  }
}

abstract class _RecurrenceDto implements RecurrenceDto {
  const factory _RecurrenceDto(
      {@JsonKey(fromJson: _parseString) final String frequency,
      final List<String> days,
      @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
      final String? startDate,
      @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
      final String? endDate,
      @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
      final String? defaultStartTime,
      @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
      final String? defaultEndTime}) = _$RecurrenceDtoImpl;

  factory _RecurrenceDto.fromJson(Map<String, dynamic> json) =
      _$RecurrenceDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseString)
  String get frequency;
  @override
  List<String> get days;
  @override
  @JsonKey(name: 'start_date', fromJson: _parseStringOrNull)
  String? get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _parseStringOrNull)
  String? get endDate;
  @override
  @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull)
  String? get defaultStartTime;
  @override
  @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull)
  String? get defaultEndTime;
  @override
  @JsonKey(ignore: true)
  _$$RecurrenceDtoImplCopyWith<_$RecurrenceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingSettingsDto _$BookingSettingsDtoFromJson(Map<String, dynamic> json) {
  return _BookingSettingsDto.fromJson(json);
}

/// @nodoc
mixin _$BookingSettingsDto {
  @JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
  int get bookBeforeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
  int get maxTicketsPerBooking => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_approval', fromJson: _parseBool)
  bool get requiresApproval => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingSettingsDtoCopyWith<BookingSettingsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingSettingsDtoCopyWith<$Res> {
  factory $BookingSettingsDtoCopyWith(
          BookingSettingsDto value, $Res Function(BookingSettingsDto) then) =
      _$BookingSettingsDtoCopyWithImpl<$Res, BookingSettingsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
      int bookBeforeMinutes,
      @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
      int maxTicketsPerBooking,
      @JsonKey(name: 'requires_approval', fromJson: _parseBool)
      bool requiresApproval});
}

/// @nodoc
class _$BookingSettingsDtoCopyWithImpl<$Res, $Val extends BookingSettingsDto>
    implements $BookingSettingsDtoCopyWith<$Res> {
  _$BookingSettingsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookBeforeMinutes = null,
    Object? maxTicketsPerBooking = null,
    Object? requiresApproval = null,
  }) {
    return _then(_value.copyWith(
      bookBeforeMinutes: null == bookBeforeMinutes
          ? _value.bookBeforeMinutes
          : bookBeforeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxTicketsPerBooking: null == maxTicketsPerBooking
          ? _value.maxTicketsPerBooking
          : maxTicketsPerBooking // ignore: cast_nullable_to_non_nullable
              as int,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingSettingsDtoImplCopyWith<$Res>
    implements $BookingSettingsDtoCopyWith<$Res> {
  factory _$$BookingSettingsDtoImplCopyWith(_$BookingSettingsDtoImpl value,
          $Res Function(_$BookingSettingsDtoImpl) then) =
      __$$BookingSettingsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
      int bookBeforeMinutes,
      @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
      int maxTicketsPerBooking,
      @JsonKey(name: 'requires_approval', fromJson: _parseBool)
      bool requiresApproval});
}

/// @nodoc
class __$$BookingSettingsDtoImplCopyWithImpl<$Res>
    extends _$BookingSettingsDtoCopyWithImpl<$Res, _$BookingSettingsDtoImpl>
    implements _$$BookingSettingsDtoImplCopyWith<$Res> {
  __$$BookingSettingsDtoImplCopyWithImpl(_$BookingSettingsDtoImpl _value,
      $Res Function(_$BookingSettingsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookBeforeMinutes = null,
    Object? maxTicketsPerBooking = null,
    Object? requiresApproval = null,
  }) {
    return _then(_$BookingSettingsDtoImpl(
      bookBeforeMinutes: null == bookBeforeMinutes
          ? _value.bookBeforeMinutes
          : bookBeforeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxTicketsPerBooking: null == maxTicketsPerBooking
          ? _value.maxTicketsPerBooking
          : maxTicketsPerBooking // ignore: cast_nullable_to_non_nullable
              as int,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingSettingsDtoImpl implements _BookingSettingsDto {
  const _$BookingSettingsDtoImpl(
      {@JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
      this.bookBeforeMinutes = 0,
      @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
      this.maxTicketsPerBooking = 10,
      @JsonKey(name: 'requires_approval', fromJson: _parseBool)
      this.requiresApproval = false});

  factory _$BookingSettingsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingSettingsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
  final int bookBeforeMinutes;
  @override
  @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
  final int maxTicketsPerBooking;
  @override
  @JsonKey(name: 'requires_approval', fromJson: _parseBool)
  final bool requiresApproval;

  @override
  String toString() {
    return 'BookingSettingsDto(bookBeforeMinutes: $bookBeforeMinutes, maxTicketsPerBooking: $maxTicketsPerBooking, requiresApproval: $requiresApproval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingSettingsDtoImpl &&
            (identical(other.bookBeforeMinutes, bookBeforeMinutes) ||
                other.bookBeforeMinutes == bookBeforeMinutes) &&
            (identical(other.maxTicketsPerBooking, maxTicketsPerBooking) ||
                other.maxTicketsPerBooking == maxTicketsPerBooking) &&
            (identical(other.requiresApproval, requiresApproval) ||
                other.requiresApproval == requiresApproval));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, bookBeforeMinutes, maxTicketsPerBooking, requiresApproval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingSettingsDtoImplCopyWith<_$BookingSettingsDtoImpl> get copyWith =>
      __$$BookingSettingsDtoImplCopyWithImpl<_$BookingSettingsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingSettingsDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingSettingsDto implements BookingSettingsDto {
  const factory _BookingSettingsDto(
      {@JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
      final int bookBeforeMinutes,
      @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
      final int maxTicketsPerBooking,
      @JsonKey(name: 'requires_approval', fromJson: _parseBool)
      final bool requiresApproval}) = _$BookingSettingsDtoImpl;

  factory _BookingSettingsDto.fromJson(Map<String, dynamic> json) =
      _$BookingSettingsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'book_before_minutes', fromJson: _parseInt)
  int get bookBeforeMinutes;
  @override
  @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt)
  int get maxTicketsPerBooking;
  @override
  @JsonKey(name: 'requires_approval', fromJson: _parseBool)
  bool get requiresApproval;
  @override
  @JsonKey(ignore: true)
  _$$BookingSettingsDtoImplCopyWith<_$BookingSettingsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

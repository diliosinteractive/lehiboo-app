// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_api_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateBookingRequestDto _$CreateBookingRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateBookingRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingRequestDto {
  @JsonKey(name: 'event_id')
  int get eventId => throw _privateConstructorUsedError;
  List<BookingTicketRequestDto> get tickets =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_info')
  BuyerInfoDto get buyerInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_code')
  String? get couponCode => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateBookingRequestDtoCopyWith<CreateBookingRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingRequestDtoCopyWith<$Res> {
  factory $CreateBookingRequestDtoCopyWith(CreateBookingRequestDto value,
          $Res Function(CreateBookingRequestDto) then) =
      _$CreateBookingRequestDtoCopyWithImpl<$Res, CreateBookingRequestDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      List<BookingTicketRequestDto> tickets,
      @JsonKey(name: 'buyer_info') BuyerInfoDto buyerInfo,
      @JsonKey(name: 'coupon_code') String? couponCode,
      String? notes});

  $BuyerInfoDtoCopyWith<$Res> get buyerInfo;
}

/// @nodoc
class _$CreateBookingRequestDtoCopyWithImpl<$Res,
        $Val extends CreateBookingRequestDto>
    implements $CreateBookingRequestDtoCopyWith<$Res> {
  _$CreateBookingRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? tickets = null,
    Object? buyerInfo = null,
    Object? couponCode = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      tickets: null == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<BookingTicketRequestDto>,
      buyerInfo: null == buyerInfo
          ? _value.buyerInfo
          : buyerInfo // ignore: cast_nullable_to_non_nullable
              as BuyerInfoDto,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BuyerInfoDtoCopyWith<$Res> get buyerInfo {
    return $BuyerInfoDtoCopyWith<$Res>(_value.buyerInfo, (value) {
      return _then(_value.copyWith(buyerInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateBookingRequestDtoImplCopyWith<$Res>
    implements $CreateBookingRequestDtoCopyWith<$Res> {
  factory _$$CreateBookingRequestDtoImplCopyWith(
          _$CreateBookingRequestDtoImpl value,
          $Res Function(_$CreateBookingRequestDtoImpl) then) =
      __$$CreateBookingRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') int eventId,
      List<BookingTicketRequestDto> tickets,
      @JsonKey(name: 'buyer_info') BuyerInfoDto buyerInfo,
      @JsonKey(name: 'coupon_code') String? couponCode,
      String? notes});

  @override
  $BuyerInfoDtoCopyWith<$Res> get buyerInfo;
}

/// @nodoc
class __$$CreateBookingRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateBookingRequestDtoCopyWithImpl<$Res,
        _$CreateBookingRequestDtoImpl>
    implements _$$CreateBookingRequestDtoImplCopyWith<$Res> {
  __$$CreateBookingRequestDtoImplCopyWithImpl(
      _$CreateBookingRequestDtoImpl _value,
      $Res Function(_$CreateBookingRequestDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? tickets = null,
    Object? buyerInfo = null,
    Object? couponCode = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$CreateBookingRequestDtoImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int,
      tickets: null == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<BookingTicketRequestDto>,
      buyerInfo: null == buyerInfo
          ? _value.buyerInfo
          : buyerInfo // ignore: cast_nullable_to_non_nullable
              as BuyerInfoDto,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingRequestDtoImpl implements _CreateBookingRequestDto {
  const _$CreateBookingRequestDtoImpl(
      {@JsonKey(name: 'event_id') required this.eventId,
      required final List<BookingTicketRequestDto> tickets,
      @JsonKey(name: 'buyer_info') required this.buyerInfo,
      @JsonKey(name: 'coupon_code') this.couponCode,
      this.notes})
      : _tickets = tickets;

  factory _$CreateBookingRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingRequestDtoImplFromJson(json);

  @override
  @JsonKey(name: 'event_id')
  final int eventId;
  final List<BookingTicketRequestDto> _tickets;
  @override
  List<BookingTicketRequestDto> get tickets {
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tickets);
  }

  @override
  @JsonKey(name: 'buyer_info')
  final BuyerInfoDto buyerInfo;
  @override
  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateBookingRequestDto(eventId: $eventId, tickets: $tickets, buyerInfo: $buyerInfo, couponCode: $couponCode, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingRequestDtoImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            (identical(other.buyerInfo, buyerInfo) ||
                other.buyerInfo == buyerInfo) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      const DeepCollectionEquality().hash(_tickets),
      buyerInfo,
      couponCode,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingRequestDtoImplCopyWith<_$CreateBookingRequestDtoImpl>
      get copyWith => __$$CreateBookingRequestDtoImplCopyWithImpl<
          _$CreateBookingRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateBookingRequestDto implements CreateBookingRequestDto {
  const factory _CreateBookingRequestDto(
      {@JsonKey(name: 'event_id') required final int eventId,
      required final List<BookingTicketRequestDto> tickets,
      @JsonKey(name: 'buyer_info') required final BuyerInfoDto buyerInfo,
      @JsonKey(name: 'coupon_code') final String? couponCode,
      final String? notes}) = _$CreateBookingRequestDtoImpl;

  factory _CreateBookingRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateBookingRequestDtoImpl.fromJson;

  @override
  @JsonKey(name: 'event_id')
  int get eventId;
  @override
  List<BookingTicketRequestDto> get tickets;
  @override
  @JsonKey(name: 'buyer_info')
  BuyerInfoDto get buyerInfo;
  @override
  @JsonKey(name: 'coupon_code')
  String? get couponCode;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$CreateBookingRequestDtoImplCopyWith<_$CreateBookingRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BookingTicketRequestDto _$BookingTicketRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _BookingTicketRequestDto.fromJson(json);
}

/// @nodoc
mixin _$BookingTicketRequestDto {
  @JsonKey(name: 'ticket_type_id')
  String get ticketTypeId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  List<AttendeeInfoDto>? get attendees => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingTicketRequestDtoCopyWith<BookingTicketRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingTicketRequestDtoCopyWith<$Res> {
  factory $BookingTicketRequestDtoCopyWith(BookingTicketRequestDto value,
          $Res Function(BookingTicketRequestDto) then) =
      _$BookingTicketRequestDtoCopyWithImpl<$Res, BookingTicketRequestDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_type_id') String ticketTypeId,
      int quantity,
      List<AttendeeInfoDto>? attendees});
}

/// @nodoc
class _$BookingTicketRequestDtoCopyWithImpl<$Res,
        $Val extends BookingTicketRequestDto>
    implements $BookingTicketRequestDtoCopyWith<$Res> {
  _$BookingTicketRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketTypeId = null,
    Object? quantity = null,
    Object? attendees = freezed,
  }) {
    return _then(_value.copyWith(
      ticketTypeId: null == ticketTypeId
          ? _value.ticketTypeId
          : ticketTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      attendees: freezed == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<AttendeeInfoDto>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingTicketRequestDtoImplCopyWith<$Res>
    implements $BookingTicketRequestDtoCopyWith<$Res> {
  factory _$$BookingTicketRequestDtoImplCopyWith(
          _$BookingTicketRequestDtoImpl value,
          $Res Function(_$BookingTicketRequestDtoImpl) then) =
      __$$BookingTicketRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ticket_type_id') String ticketTypeId,
      int quantity,
      List<AttendeeInfoDto>? attendees});
}

/// @nodoc
class __$$BookingTicketRequestDtoImplCopyWithImpl<$Res>
    extends _$BookingTicketRequestDtoCopyWithImpl<$Res,
        _$BookingTicketRequestDtoImpl>
    implements _$$BookingTicketRequestDtoImplCopyWith<$Res> {
  __$$BookingTicketRequestDtoImplCopyWithImpl(
      _$BookingTicketRequestDtoImpl _value,
      $Res Function(_$BookingTicketRequestDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketTypeId = null,
    Object? quantity = null,
    Object? attendees = freezed,
  }) {
    return _then(_$BookingTicketRequestDtoImpl(
      ticketTypeId: null == ticketTypeId
          ? _value.ticketTypeId
          : ticketTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      attendees: freezed == attendees
          ? _value._attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<AttendeeInfoDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingTicketRequestDtoImpl implements _BookingTicketRequestDto {
  const _$BookingTicketRequestDtoImpl(
      {@JsonKey(name: 'ticket_type_id') required this.ticketTypeId,
      required this.quantity,
      final List<AttendeeInfoDto>? attendees})
      : _attendees = attendees;

  factory _$BookingTicketRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingTicketRequestDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ticket_type_id')
  final String ticketTypeId;
  @override
  final int quantity;
  final List<AttendeeInfoDto>? _attendees;
  @override
  List<AttendeeInfoDto>? get attendees {
    final value = _attendees;
    if (value == null) return null;
    if (_attendees is EqualUnmodifiableListView) return _attendees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BookingTicketRequestDto(ticketTypeId: $ticketTypeId, quantity: $quantity, attendees: $attendees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingTicketRequestDtoImpl &&
            (identical(other.ticketTypeId, ticketTypeId) ||
                other.ticketTypeId == ticketTypeId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality()
                .equals(other._attendees, _attendees));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ticketTypeId, quantity,
      const DeepCollectionEquality().hash(_attendees));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingTicketRequestDtoImplCopyWith<_$BookingTicketRequestDtoImpl>
      get copyWith => __$$BookingTicketRequestDtoImplCopyWithImpl<
          _$BookingTicketRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingTicketRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingTicketRequestDto implements BookingTicketRequestDto {
  const factory _BookingTicketRequestDto(
      {@JsonKey(name: 'ticket_type_id') required final String ticketTypeId,
      required final int quantity,
      final List<AttendeeInfoDto>? attendees}) = _$BookingTicketRequestDtoImpl;

  factory _BookingTicketRequestDto.fromJson(Map<String, dynamic> json) =
      _$BookingTicketRequestDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ticket_type_id')
  String get ticketTypeId;
  @override
  int get quantity;
  @override
  List<AttendeeInfoDto>? get attendees;
  @override
  @JsonKey(ignore: true)
  _$$BookingTicketRequestDtoImplCopyWith<_$BookingTicketRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BuyerInfoDto _$BuyerInfoDtoFromJson(Map<String, dynamic> json) {
  return _BuyerInfoDto.fromJson(json);
}

/// @nodoc
mixin _$BuyerInfoDto {
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuyerInfoDtoCopyWith<BuyerInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerInfoDtoCopyWith<$Res> {
  factory $BuyerInfoDtoCopyWith(
          BuyerInfoDto value, $Res Function(BuyerInfoDto) then) =
      _$BuyerInfoDtoCopyWithImpl<$Res, BuyerInfoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      String? phone});
}

/// @nodoc
class _$BuyerInfoDtoCopyWithImpl<$Res, $Val extends BuyerInfoDto>
    implements $BuyerInfoDtoCopyWith<$Res> {
  _$BuyerInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuyerInfoDtoImplCopyWith<$Res>
    implements $BuyerInfoDtoCopyWith<$Res> {
  factory _$$BuyerInfoDtoImplCopyWith(
          _$BuyerInfoDtoImpl value, $Res Function(_$BuyerInfoDtoImpl) then) =
      __$$BuyerInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      String? phone});
}

/// @nodoc
class __$$BuyerInfoDtoImplCopyWithImpl<$Res>
    extends _$BuyerInfoDtoCopyWithImpl<$Res, _$BuyerInfoDtoImpl>
    implements _$$BuyerInfoDtoImplCopyWith<$Res> {
  __$$BuyerInfoDtoImplCopyWithImpl(
      _$BuyerInfoDtoImpl _value, $Res Function(_$BuyerInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = freezed,
  }) {
    return _then(_$BuyerInfoDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuyerInfoDtoImpl implements _BuyerInfoDto {
  const _$BuyerInfoDtoImpl(
      {@JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      required this.email,
      this.phone});

  factory _$BuyerInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuyerInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String email;
  @override
  final String? phone;

  @override
  String toString() {
    return 'BuyerInfoDto(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyerInfoDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, email, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyerInfoDtoImplCopyWith<_$BuyerInfoDtoImpl> get copyWith =>
      __$$BuyerInfoDtoImplCopyWithImpl<_$BuyerInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuyerInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _BuyerInfoDto implements BuyerInfoDto {
  const factory _BuyerInfoDto(
      {@JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      required final String email,
      final String? phone}) = _$BuyerInfoDtoImpl;

  factory _BuyerInfoDto.fromJson(Map<String, dynamic> json) =
      _$BuyerInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String get email;
  @override
  String? get phone;
  @override
  @JsonKey(ignore: true)
  _$$BuyerInfoDtoImplCopyWith<_$BuyerInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendeeInfoDto _$AttendeeInfoDtoFromJson(Map<String, dynamic> json) {
  return _AttendeeInfoDto.fromJson(json);
}

/// @nodoc
mixin _$AttendeeInfoDto {
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttendeeInfoDtoCopyWith<AttendeeInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendeeInfoDtoCopyWith<$Res> {
  factory $AttendeeInfoDtoCopyWith(
          AttendeeInfoDto value, $Res Function(AttendeeInfoDto) then) =
      _$AttendeeInfoDtoCopyWithImpl<$Res, AttendeeInfoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      int? age});
}

/// @nodoc
class _$AttendeeInfoDtoCopyWithImpl<$Res, $Val extends AttendeeInfoDto>
    implements $AttendeeInfoDtoCopyWith<$Res> {
  _$AttendeeInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? age = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendeeInfoDtoImplCopyWith<$Res>
    implements $AttendeeInfoDtoCopyWith<$Res> {
  factory _$$AttendeeInfoDtoImplCopyWith(_$AttendeeInfoDtoImpl value,
          $Res Function(_$AttendeeInfoDtoImpl) then) =
      __$$AttendeeInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      int? age});
}

/// @nodoc
class __$$AttendeeInfoDtoImplCopyWithImpl<$Res>
    extends _$AttendeeInfoDtoCopyWithImpl<$Res, _$AttendeeInfoDtoImpl>
    implements _$$AttendeeInfoDtoImplCopyWith<$Res> {
  __$$AttendeeInfoDtoImplCopyWithImpl(
      _$AttendeeInfoDtoImpl _value, $Res Function(_$AttendeeInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? age = freezed,
  }) {
    return _then(_$AttendeeInfoDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendeeInfoDtoImpl implements _AttendeeInfoDto {
  const _$AttendeeInfoDtoImpl(
      {@JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      this.age});

  factory _$AttendeeInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendeeInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final int? age;

  @override
  String toString() {
    return 'AttendeeInfoDto(firstName: $firstName, lastName: $lastName, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendeeInfoDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.age, age) || other.age == age));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, age);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendeeInfoDtoImplCopyWith<_$AttendeeInfoDtoImpl> get copyWith =>
      __$$AttendeeInfoDtoImplCopyWithImpl<_$AttendeeInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendeeInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _AttendeeInfoDto implements AttendeeInfoDto {
  const factory _AttendeeInfoDto(
      {@JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      final int? age}) = _$AttendeeInfoDtoImpl;

  factory _AttendeeInfoDto.fromJson(Map<String, dynamic> json) =
      _$AttendeeInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  int? get age;
  @override
  @JsonKey(ignore: true)
  _$$AttendeeInfoDtoImplCopyWith<_$AttendeeInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateBookingResponseDto _$CreateBookingResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateBookingResponseDto.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingResponseDto {
  BookingInfoDto get booking => throw _privateConstructorUsedError;
  BookingEventInfoDto get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'tickets_summary')
  List<TicketSummaryDto> get ticketsSummary =>
      throw _privateConstructorUsedError;
  BookingPricingDto get pricing => throw _privateConstructorUsedError;
  BookingPaymentDto? get payment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateBookingResponseDtoCopyWith<CreateBookingResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingResponseDtoCopyWith<$Res> {
  factory $CreateBookingResponseDtoCopyWith(CreateBookingResponseDto value,
          $Res Function(CreateBookingResponseDto) then) =
      _$CreateBookingResponseDtoCopyWithImpl<$Res, CreateBookingResponseDto>;
  @useResult
  $Res call(
      {BookingInfoDto booking,
      BookingEventInfoDto event,
      @JsonKey(name: 'tickets_summary') List<TicketSummaryDto> ticketsSummary,
      BookingPricingDto pricing,
      BookingPaymentDto? payment});

  $BookingInfoDtoCopyWith<$Res> get booking;
  $BookingEventInfoDtoCopyWith<$Res> get event;
  $BookingPricingDtoCopyWith<$Res> get pricing;
  $BookingPaymentDtoCopyWith<$Res>? get payment;
}

/// @nodoc
class _$CreateBookingResponseDtoCopyWithImpl<$Res,
        $Val extends CreateBookingResponseDto>
    implements $CreateBookingResponseDtoCopyWith<$Res> {
  _$CreateBookingResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booking = null,
    Object? event = null,
    Object? ticketsSummary = null,
    Object? pricing = null,
    Object? payment = freezed,
  }) {
    return _then(_value.copyWith(
      booking: null == booking
          ? _value.booking
          : booking // ignore: cast_nullable_to_non_nullable
              as BookingInfoDto,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as BookingEventInfoDto,
      ticketsSummary: null == ticketsSummary
          ? _value.ticketsSummary
          : ticketsSummary // ignore: cast_nullable_to_non_nullable
              as List<TicketSummaryDto>,
      pricing: null == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as BookingPricingDto,
      payment: freezed == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as BookingPaymentDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingInfoDtoCopyWith<$Res> get booking {
    return $BookingInfoDtoCopyWith<$Res>(_value.booking, (value) {
      return _then(_value.copyWith(booking: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingEventInfoDtoCopyWith<$Res> get event {
    return $BookingEventInfoDtoCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingPricingDtoCopyWith<$Res> get pricing {
    return $BookingPricingDtoCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingPaymentDtoCopyWith<$Res>? get payment {
    if (_value.payment == null) {
      return null;
    }

    return $BookingPaymentDtoCopyWith<$Res>(_value.payment!, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateBookingResponseDtoImplCopyWith<$Res>
    implements $CreateBookingResponseDtoCopyWith<$Res> {
  factory _$$CreateBookingResponseDtoImplCopyWith(
          _$CreateBookingResponseDtoImpl value,
          $Res Function(_$CreateBookingResponseDtoImpl) then) =
      __$$CreateBookingResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BookingInfoDto booking,
      BookingEventInfoDto event,
      @JsonKey(name: 'tickets_summary') List<TicketSummaryDto> ticketsSummary,
      BookingPricingDto pricing,
      BookingPaymentDto? payment});

  @override
  $BookingInfoDtoCopyWith<$Res> get booking;
  @override
  $BookingEventInfoDtoCopyWith<$Res> get event;
  @override
  $BookingPricingDtoCopyWith<$Res> get pricing;
  @override
  $BookingPaymentDtoCopyWith<$Res>? get payment;
}

/// @nodoc
class __$$CreateBookingResponseDtoImplCopyWithImpl<$Res>
    extends _$CreateBookingResponseDtoCopyWithImpl<$Res,
        _$CreateBookingResponseDtoImpl>
    implements _$$CreateBookingResponseDtoImplCopyWith<$Res> {
  __$$CreateBookingResponseDtoImplCopyWithImpl(
      _$CreateBookingResponseDtoImpl _value,
      $Res Function(_$CreateBookingResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booking = null,
    Object? event = null,
    Object? ticketsSummary = null,
    Object? pricing = null,
    Object? payment = freezed,
  }) {
    return _then(_$CreateBookingResponseDtoImpl(
      booking: null == booking
          ? _value.booking
          : booking // ignore: cast_nullable_to_non_nullable
              as BookingInfoDto,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as BookingEventInfoDto,
      ticketsSummary: null == ticketsSummary
          ? _value._ticketsSummary
          : ticketsSummary // ignore: cast_nullable_to_non_nullable
              as List<TicketSummaryDto>,
      pricing: null == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as BookingPricingDto,
      payment: freezed == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as BookingPaymentDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingResponseDtoImpl implements _CreateBookingResponseDto {
  const _$CreateBookingResponseDtoImpl(
      {required this.booking,
      required this.event,
      @JsonKey(name: 'tickets_summary')
      required final List<TicketSummaryDto> ticketsSummary,
      required this.pricing,
      this.payment})
      : _ticketsSummary = ticketsSummary;

  factory _$CreateBookingResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingResponseDtoImplFromJson(json);

  @override
  final BookingInfoDto booking;
  @override
  final BookingEventInfoDto event;
  final List<TicketSummaryDto> _ticketsSummary;
  @override
  @JsonKey(name: 'tickets_summary')
  List<TicketSummaryDto> get ticketsSummary {
    if (_ticketsSummary is EqualUnmodifiableListView) return _ticketsSummary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ticketsSummary);
  }

  @override
  final BookingPricingDto pricing;
  @override
  final BookingPaymentDto? payment;

  @override
  String toString() {
    return 'CreateBookingResponseDto(booking: $booking, event: $event, ticketsSummary: $ticketsSummary, pricing: $pricing, payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingResponseDtoImpl &&
            (identical(other.booking, booking) || other.booking == booking) &&
            (identical(other.event, event) || other.event == event) &&
            const DeepCollectionEquality()
                .equals(other._ticketsSummary, _ticketsSummary) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, booking, event,
      const DeepCollectionEquality().hash(_ticketsSummary), pricing, payment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingResponseDtoImplCopyWith<_$CreateBookingResponseDtoImpl>
      get copyWith => __$$CreateBookingResponseDtoImplCopyWithImpl<
          _$CreateBookingResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateBookingResponseDto implements CreateBookingResponseDto {
  const factory _CreateBookingResponseDto(
      {required final BookingInfoDto booking,
      required final BookingEventInfoDto event,
      @JsonKey(name: 'tickets_summary')
      required final List<TicketSummaryDto> ticketsSummary,
      required final BookingPricingDto pricing,
      final BookingPaymentDto? payment}) = _$CreateBookingResponseDtoImpl;

  factory _CreateBookingResponseDto.fromJson(Map<String, dynamic> json) =
      _$CreateBookingResponseDtoImpl.fromJson;

  @override
  BookingInfoDto get booking;
  @override
  BookingEventInfoDto get event;
  @override
  @JsonKey(name: 'tickets_summary')
  List<TicketSummaryDto> get ticketsSummary;
  @override
  BookingPricingDto get pricing;
  @override
  BookingPaymentDto? get payment;
  @override
  @JsonKey(ignore: true)
  _$$CreateBookingResponseDtoImplCopyWith<_$CreateBookingResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BookingInfoDto _$BookingInfoDtoFromJson(Map<String, dynamic> json) {
  return _BookingInfoDto.fromJson(json);
}

/// @nodoc
mixin _$BookingInfoDto {
  int get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  String? get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingInfoDtoCopyWith<BookingInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingInfoDtoCopyWith<$Res> {
  factory $BookingInfoDtoCopyWith(
          BookingInfoDto value, $Res Function(BookingInfoDto) then) =
      _$BookingInfoDtoCopyWithImpl<$Res, BookingInfoDto>;
  @useResult
  $Res call(
      {int id,
      String reference,
      String status,
      @JsonKey(name: 'expires_at') String? expiresAt});
}

/// @nodoc
class _$BookingInfoDtoCopyWithImpl<$Res, $Val extends BookingInfoDto>
    implements $BookingInfoDtoCopyWith<$Res> {
  _$BookingInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingInfoDtoImplCopyWith<$Res>
    implements $BookingInfoDtoCopyWith<$Res> {
  factory _$$BookingInfoDtoImplCopyWith(_$BookingInfoDtoImpl value,
          $Res Function(_$BookingInfoDtoImpl) then) =
      __$$BookingInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String reference,
      String status,
      @JsonKey(name: 'expires_at') String? expiresAt});
}

/// @nodoc
class __$$BookingInfoDtoImplCopyWithImpl<$Res>
    extends _$BookingInfoDtoCopyWithImpl<$Res, _$BookingInfoDtoImpl>
    implements _$$BookingInfoDtoImplCopyWith<$Res> {
  __$$BookingInfoDtoImplCopyWithImpl(
      _$BookingInfoDtoImpl _value, $Res Function(_$BookingInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$BookingInfoDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingInfoDtoImpl implements _BookingInfoDto {
  const _$BookingInfoDtoImpl(
      {required this.id,
      required this.reference,
      required this.status,
      @JsonKey(name: 'expires_at') this.expiresAt});

  factory _$BookingInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingInfoDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String reference;
  @override
  final String status;
  @override
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  @override
  String toString() {
    return 'BookingInfoDto(id: $id, reference: $reference, status: $status, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingInfoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, reference, status, expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingInfoDtoImplCopyWith<_$BookingInfoDtoImpl> get copyWith =>
      __$$BookingInfoDtoImplCopyWithImpl<_$BookingInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingInfoDto implements BookingInfoDto {
  const factory _BookingInfoDto(
          {required final int id,
          required final String reference,
          required final String status,
          @JsonKey(name: 'expires_at') final String? expiresAt}) =
      _$BookingInfoDtoImpl;

  factory _BookingInfoDto.fromJson(Map<String, dynamic> json) =
      _$BookingInfoDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get reference;
  @override
  String get status;
  @override
  @JsonKey(name: 'expires_at')
  String? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingInfoDtoImplCopyWith<_$BookingInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingEventInfoDto _$BookingEventInfoDtoFromJson(Map<String, dynamic> json) {
  return _BookingEventInfoDto.fromJson(json);
}

/// @nodoc
mixin _$BookingEventInfoDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String? get venue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingEventInfoDtoCopyWith<BookingEventInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingEventInfoDtoCopyWith<$Res> {
  factory $BookingEventInfoDtoCopyWith(
          BookingEventInfoDto value, $Res Function(BookingEventInfoDto) then) =
      _$BookingEventInfoDtoCopyWithImpl<$Res, BookingEventInfoDto>;
  @useResult
  $Res call({int id, String title, String date, String? time, String? venue});
}

/// @nodoc
class _$BookingEventInfoDtoCopyWithImpl<$Res, $Val extends BookingEventInfoDto>
    implements $BookingEventInfoDtoCopyWith<$Res> {
  _$BookingEventInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = null,
    Object? time = freezed,
    Object? venue = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingEventInfoDtoImplCopyWith<$Res>
    implements $BookingEventInfoDtoCopyWith<$Res> {
  factory _$$BookingEventInfoDtoImplCopyWith(_$BookingEventInfoDtoImpl value,
          $Res Function(_$BookingEventInfoDtoImpl) then) =
      __$$BookingEventInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, String date, String? time, String? venue});
}

/// @nodoc
class __$$BookingEventInfoDtoImplCopyWithImpl<$Res>
    extends _$BookingEventInfoDtoCopyWithImpl<$Res, _$BookingEventInfoDtoImpl>
    implements _$$BookingEventInfoDtoImplCopyWith<$Res> {
  __$$BookingEventInfoDtoImplCopyWithImpl(_$BookingEventInfoDtoImpl _value,
      $Res Function(_$BookingEventInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = null,
    Object? time = freezed,
    Object? venue = freezed,
  }) {
    return _then(_$BookingEventInfoDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingEventInfoDtoImpl implements _BookingEventInfoDto {
  const _$BookingEventInfoDtoImpl(
      {required this.id,
      required this.title,
      required this.date,
      this.time,
      this.venue});

  factory _$BookingEventInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingEventInfoDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String date;
  @override
  final String? time;
  @override
  final String? venue;

  @override
  String toString() {
    return 'BookingEventInfoDto(id: $id, title: $title, date: $date, time: $time, venue: $venue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingEventInfoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.venue, venue) || other.venue == venue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, date, time, venue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingEventInfoDtoImplCopyWith<_$BookingEventInfoDtoImpl> get copyWith =>
      __$$BookingEventInfoDtoImplCopyWithImpl<_$BookingEventInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingEventInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingEventInfoDto implements BookingEventInfoDto {
  const factory _BookingEventInfoDto(
      {required final int id,
      required final String title,
      required final String date,
      final String? time,
      final String? venue}) = _$BookingEventInfoDtoImpl;

  factory _BookingEventInfoDto.fromJson(Map<String, dynamic> json) =
      _$BookingEventInfoDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get date;
  @override
  String? get time;
  @override
  String? get venue;
  @override
  @JsonKey(ignore: true)
  _$$BookingEventInfoDtoImplCopyWith<_$BookingEventInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketSummaryDto _$TicketSummaryDtoFromJson(Map<String, dynamic> json) {
  return _TicketSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$TicketSummaryDto {
  String get type => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketSummaryDtoCopyWith<TicketSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketSummaryDtoCopyWith<$Res> {
  factory $TicketSummaryDtoCopyWith(
          TicketSummaryDto value, $Res Function(TicketSummaryDto) then) =
      _$TicketSummaryDtoCopyWithImpl<$Res, TicketSummaryDto>;
  @useResult
  $Res call(
      {String type,
      int quantity,
      @JsonKey(name: 'unit_price') double unitPrice,
      double subtotal});
}

/// @nodoc
class _$TicketSummaryDtoCopyWithImpl<$Res, $Val extends TicketSummaryDto>
    implements $TicketSummaryDtoCopyWith<$Res> {
  _$TicketSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? subtotal = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketSummaryDtoImplCopyWith<$Res>
    implements $TicketSummaryDtoCopyWith<$Res> {
  factory _$$TicketSummaryDtoImplCopyWith(_$TicketSummaryDtoImpl value,
          $Res Function(_$TicketSummaryDtoImpl) then) =
      __$$TicketSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      int quantity,
      @JsonKey(name: 'unit_price') double unitPrice,
      double subtotal});
}

/// @nodoc
class __$$TicketSummaryDtoImplCopyWithImpl<$Res>
    extends _$TicketSummaryDtoCopyWithImpl<$Res, _$TicketSummaryDtoImpl>
    implements _$$TicketSummaryDtoImplCopyWith<$Res> {
  __$$TicketSummaryDtoImplCopyWithImpl(_$TicketSummaryDtoImpl _value,
      $Res Function(_$TicketSummaryDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? subtotal = null,
  }) {
    return _then(_$TicketSummaryDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketSummaryDtoImpl implements _TicketSummaryDto {
  const _$TicketSummaryDtoImpl(
      {required this.type,
      required this.quantity,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      required this.subtotal});

  factory _$TicketSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketSummaryDtoImplFromJson(json);

  @override
  final String type;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  final double subtotal;

  @override
  String toString() {
    return 'TicketSummaryDto(type: $type, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketSummaryDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, quantity, unitPrice, subtotal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketSummaryDtoImplCopyWith<_$TicketSummaryDtoImpl> get copyWith =>
      __$$TicketSummaryDtoImplCopyWithImpl<_$TicketSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketSummaryDto implements TicketSummaryDto {
  const factory _TicketSummaryDto(
      {required final String type,
      required final int quantity,
      @JsonKey(name: 'unit_price') required final double unitPrice,
      required final double subtotal}) = _$TicketSummaryDtoImpl;

  factory _TicketSummaryDto.fromJson(Map<String, dynamic> json) =
      _$TicketSummaryDtoImpl.fromJson;

  @override
  String get type;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  double get subtotal;
  @override
  @JsonKey(ignore: true)
  _$$TicketSummaryDtoImplCopyWith<_$TicketSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingPricingDto _$BookingPricingDtoFromJson(Map<String, dynamic> json) {
  return _BookingPricingDto.fromJson(json);
}

/// @nodoc
mixin _$BookingPricingDto {
  double get subtotal => throw _privateConstructorUsedError;
  DiscountDto? get discount => throw _privateConstructorUsedError;
  double get fees => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingPricingDtoCopyWith<BookingPricingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingPricingDtoCopyWith<$Res> {
  factory $BookingPricingDtoCopyWith(
          BookingPricingDto value, $Res Function(BookingPricingDto) then) =
      _$BookingPricingDtoCopyWithImpl<$Res, BookingPricingDto>;
  @useResult
  $Res call(
      {double subtotal,
      DiscountDto? discount,
      double fees,
      double total,
      String currency});

  $DiscountDtoCopyWith<$Res>? get discount;
}

/// @nodoc
class _$BookingPricingDtoCopyWithImpl<$Res, $Val extends BookingPricingDto>
    implements $BookingPricingDtoCopyWith<$Res> {
  _$BookingPricingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? discount = freezed,
    Object? fees = null,
    Object? total = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as DiscountDto?,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DiscountDtoCopyWith<$Res>? get discount {
    if (_value.discount == null) {
      return null;
    }

    return $DiscountDtoCopyWith<$Res>(_value.discount!, (value) {
      return _then(_value.copyWith(discount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingPricingDtoImplCopyWith<$Res>
    implements $BookingPricingDtoCopyWith<$Res> {
  factory _$$BookingPricingDtoImplCopyWith(_$BookingPricingDtoImpl value,
          $Res Function(_$BookingPricingDtoImpl) then) =
      __$$BookingPricingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double subtotal,
      DiscountDto? discount,
      double fees,
      double total,
      String currency});

  @override
  $DiscountDtoCopyWith<$Res>? get discount;
}

/// @nodoc
class __$$BookingPricingDtoImplCopyWithImpl<$Res>
    extends _$BookingPricingDtoCopyWithImpl<$Res, _$BookingPricingDtoImpl>
    implements _$$BookingPricingDtoImplCopyWith<$Res> {
  __$$BookingPricingDtoImplCopyWithImpl(_$BookingPricingDtoImpl _value,
      $Res Function(_$BookingPricingDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? discount = freezed,
    Object? fees = null,
    Object? total = null,
    Object? currency = null,
  }) {
    return _then(_$BookingPricingDtoImpl(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as DiscountDto?,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingPricingDtoImpl implements _BookingPricingDto {
  const _$BookingPricingDtoImpl(
      {required this.subtotal,
      this.discount,
      this.fees = 0.0,
      required this.total,
      this.currency = 'EUR'});

  factory _$BookingPricingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingPricingDtoImplFromJson(json);

  @override
  final double subtotal;
  @override
  final DiscountDto? discount;
  @override
  @JsonKey()
  final double fees;
  @override
  final double total;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'BookingPricingDto(subtotal: $subtotal, discount: $discount, fees: $fees, total: $total, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingPricingDtoImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.fees, fees) || other.fees == fees) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, subtotal, discount, fees, total, currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingPricingDtoImplCopyWith<_$BookingPricingDtoImpl> get copyWith =>
      __$$BookingPricingDtoImplCopyWithImpl<_$BookingPricingDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingPricingDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingPricingDto implements BookingPricingDto {
  const factory _BookingPricingDto(
      {required final double subtotal,
      final DiscountDto? discount,
      final double fees,
      required final double total,
      final String currency}) = _$BookingPricingDtoImpl;

  factory _BookingPricingDto.fromJson(Map<String, dynamic> json) =
      _$BookingPricingDtoImpl.fromJson;

  @override
  double get subtotal;
  @override
  DiscountDto? get discount;
  @override
  double get fees;
  @override
  double get total;
  @override
  String get currency;
  @override
  @JsonKey(ignore: true)
  _$$BookingPricingDtoImplCopyWith<_$BookingPricingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiscountDto _$DiscountDtoFromJson(Map<String, dynamic> json) {
  return _DiscountDto.fromJson(json);
}

/// @nodoc
mixin _$DiscountDto {
  String get code => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiscountDtoCopyWith<DiscountDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountDtoCopyWith<$Res> {
  factory $DiscountDtoCopyWith(
          DiscountDto value, $Res Function(DiscountDto) then) =
      _$DiscountDtoCopyWithImpl<$Res, DiscountDto>;
  @useResult
  $Res call({String code, double amount, String type, int value});
}

/// @nodoc
class _$DiscountDtoCopyWithImpl<$Res, $Val extends DiscountDto>
    implements $DiscountDtoCopyWith<$Res> {
  _$DiscountDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? amount = null,
    Object? type = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiscountDtoImplCopyWith<$Res>
    implements $DiscountDtoCopyWith<$Res> {
  factory _$$DiscountDtoImplCopyWith(
          _$DiscountDtoImpl value, $Res Function(_$DiscountDtoImpl) then) =
      __$$DiscountDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, double amount, String type, int value});
}

/// @nodoc
class __$$DiscountDtoImplCopyWithImpl<$Res>
    extends _$DiscountDtoCopyWithImpl<$Res, _$DiscountDtoImpl>
    implements _$$DiscountDtoImplCopyWith<$Res> {
  __$$DiscountDtoImplCopyWithImpl(
      _$DiscountDtoImpl _value, $Res Function(_$DiscountDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? amount = null,
    Object? type = null,
    Object? value = null,
  }) {
    return _then(_$DiscountDtoImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscountDtoImpl implements _DiscountDto {
  const _$DiscountDtoImpl(
      {required this.code,
      required this.amount,
      required this.type,
      required this.value});

  factory _$DiscountDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscountDtoImplFromJson(json);

  @override
  final String code;
  @override
  final double amount;
  @override
  final String type;
  @override
  final int value;

  @override
  String toString() {
    return 'DiscountDto(code: $code, amount: $amount, type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountDtoImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, amount, type, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountDtoImplCopyWith<_$DiscountDtoImpl> get copyWith =>
      __$$DiscountDtoImplCopyWithImpl<_$DiscountDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscountDtoImplToJson(
      this,
    );
  }
}

abstract class _DiscountDto implements DiscountDto {
  const factory _DiscountDto(
      {required final String code,
      required final double amount,
      required final String type,
      required final int value}) = _$DiscountDtoImpl;

  factory _DiscountDto.fromJson(Map<String, dynamic> json) =
      _$DiscountDtoImpl.fromJson;

  @override
  String get code;
  @override
  double get amount;
  @override
  String get type;
  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$DiscountDtoImplCopyWith<_$DiscountDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingPaymentDto _$BookingPaymentDtoFromJson(Map<String, dynamic> json) {
  return _BookingPaymentDto.fromJson(json);
}

/// @nodoc
mixin _$BookingPaymentDto {
  bool get required => throw _privateConstructorUsedError;
  @JsonKey(name: 'methods_available')
  List<String> get methodsAvailable => throw _privateConstructorUsedError;
  StripePaymentDto? get stripe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingPaymentDtoCopyWith<BookingPaymentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingPaymentDtoCopyWith<$Res> {
  factory $BookingPaymentDtoCopyWith(
          BookingPaymentDto value, $Res Function(BookingPaymentDto) then) =
      _$BookingPaymentDtoCopyWithImpl<$Res, BookingPaymentDto>;
  @useResult
  $Res call(
      {bool required,
      @JsonKey(name: 'methods_available') List<String> methodsAvailable,
      StripePaymentDto? stripe});

  $StripePaymentDtoCopyWith<$Res>? get stripe;
}

/// @nodoc
class _$BookingPaymentDtoCopyWithImpl<$Res, $Val extends BookingPaymentDto>
    implements $BookingPaymentDtoCopyWith<$Res> {
  _$BookingPaymentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? required = null,
    Object? methodsAvailable = null,
    Object? stripe = freezed,
  }) {
    return _then(_value.copyWith(
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      methodsAvailable: null == methodsAvailable
          ? _value.methodsAvailable
          : methodsAvailable // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stripe: freezed == stripe
          ? _value.stripe
          : stripe // ignore: cast_nullable_to_non_nullable
              as StripePaymentDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StripePaymentDtoCopyWith<$Res>? get stripe {
    if (_value.stripe == null) {
      return null;
    }

    return $StripePaymentDtoCopyWith<$Res>(_value.stripe!, (value) {
      return _then(_value.copyWith(stripe: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingPaymentDtoImplCopyWith<$Res>
    implements $BookingPaymentDtoCopyWith<$Res> {
  factory _$$BookingPaymentDtoImplCopyWith(_$BookingPaymentDtoImpl value,
          $Res Function(_$BookingPaymentDtoImpl) then) =
      __$$BookingPaymentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool required,
      @JsonKey(name: 'methods_available') List<String> methodsAvailable,
      StripePaymentDto? stripe});

  @override
  $StripePaymentDtoCopyWith<$Res>? get stripe;
}

/// @nodoc
class __$$BookingPaymentDtoImplCopyWithImpl<$Res>
    extends _$BookingPaymentDtoCopyWithImpl<$Res, _$BookingPaymentDtoImpl>
    implements _$$BookingPaymentDtoImplCopyWith<$Res> {
  __$$BookingPaymentDtoImplCopyWithImpl(_$BookingPaymentDtoImpl _value,
      $Res Function(_$BookingPaymentDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? required = null,
    Object? methodsAvailable = null,
    Object? stripe = freezed,
  }) {
    return _then(_$BookingPaymentDtoImpl(
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      methodsAvailable: null == methodsAvailable
          ? _value._methodsAvailable
          : methodsAvailable // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stripe: freezed == stripe
          ? _value.stripe
          : stripe // ignore: cast_nullable_to_non_nullable
              as StripePaymentDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingPaymentDtoImpl implements _BookingPaymentDto {
  const _$BookingPaymentDtoImpl(
      {required this.required,
      @JsonKey(name: 'methods_available')
      required final List<String> methodsAvailable,
      this.stripe})
      : _methodsAvailable = methodsAvailable;

  factory _$BookingPaymentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingPaymentDtoImplFromJson(json);

  @override
  final bool required;
  final List<String> _methodsAvailable;
  @override
  @JsonKey(name: 'methods_available')
  List<String> get methodsAvailable {
    if (_methodsAvailable is EqualUnmodifiableListView)
      return _methodsAvailable;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_methodsAvailable);
  }

  @override
  final StripePaymentDto? stripe;

  @override
  String toString() {
    return 'BookingPaymentDto(required: $required, methodsAvailable: $methodsAvailable, stripe: $stripe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingPaymentDtoImpl &&
            (identical(other.required, required) ||
                other.required == required) &&
            const DeepCollectionEquality()
                .equals(other._methodsAvailable, _methodsAvailable) &&
            (identical(other.stripe, stripe) || other.stripe == stripe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, required,
      const DeepCollectionEquality().hash(_methodsAvailable), stripe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingPaymentDtoImplCopyWith<_$BookingPaymentDtoImpl> get copyWith =>
      __$$BookingPaymentDtoImplCopyWithImpl<_$BookingPaymentDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingPaymentDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingPaymentDto implements BookingPaymentDto {
  const factory _BookingPaymentDto(
      {required final bool required,
      @JsonKey(name: 'methods_available')
      required final List<String> methodsAvailable,
      final StripePaymentDto? stripe}) = _$BookingPaymentDtoImpl;

  factory _BookingPaymentDto.fromJson(Map<String, dynamic> json) =
      _$BookingPaymentDtoImpl.fromJson;

  @override
  bool get required;
  @override
  @JsonKey(name: 'methods_available')
  List<String> get methodsAvailable;
  @override
  StripePaymentDto? get stripe;
  @override
  @JsonKey(ignore: true)
  _$$BookingPaymentDtoImplCopyWith<_$BookingPaymentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StripePaymentDto _$StripePaymentDtoFromJson(Map<String, dynamic> json) {
  return _StripePaymentDto.fromJson(json);
}

/// @nodoc
mixin _$StripePaymentDto {
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_secret')
  String get clientSecret => throw _privateConstructorUsedError;
  @JsonKey(name: 'publishable_key')
  String get publishableKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StripePaymentDtoCopyWith<StripePaymentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripePaymentDtoCopyWith<$Res> {
  factory $StripePaymentDtoCopyWith(
          StripePaymentDto value, $Res Function(StripePaymentDto) then) =
      _$StripePaymentDtoCopyWithImpl<$Res, StripePaymentDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_intent_id') String paymentIntentId,
      @JsonKey(name: 'client_secret') String clientSecret,
      @JsonKey(name: 'publishable_key') String publishableKey});
}

/// @nodoc
class _$StripePaymentDtoCopyWithImpl<$Res, $Val extends StripePaymentDto>
    implements $StripePaymentDtoCopyWith<$Res> {
  _$StripePaymentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentIntentId = null,
    Object? clientSecret = null,
    Object? publishableKey = null,
  }) {
    return _then(_value.copyWith(
      paymentIntentId: null == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      publishableKey: null == publishableKey
          ? _value.publishableKey
          : publishableKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StripePaymentDtoImplCopyWith<$Res>
    implements $StripePaymentDtoCopyWith<$Res> {
  factory _$$StripePaymentDtoImplCopyWith(_$StripePaymentDtoImpl value,
          $Res Function(_$StripePaymentDtoImpl) then) =
      __$$StripePaymentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_intent_id') String paymentIntentId,
      @JsonKey(name: 'client_secret') String clientSecret,
      @JsonKey(name: 'publishable_key') String publishableKey});
}

/// @nodoc
class __$$StripePaymentDtoImplCopyWithImpl<$Res>
    extends _$StripePaymentDtoCopyWithImpl<$Res, _$StripePaymentDtoImpl>
    implements _$$StripePaymentDtoImplCopyWith<$Res> {
  __$$StripePaymentDtoImplCopyWithImpl(_$StripePaymentDtoImpl _value,
      $Res Function(_$StripePaymentDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentIntentId = null,
    Object? clientSecret = null,
    Object? publishableKey = null,
  }) {
    return _then(_$StripePaymentDtoImpl(
      paymentIntentId: null == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      publishableKey: null == publishableKey
          ? _value.publishableKey
          : publishableKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StripePaymentDtoImpl implements _StripePaymentDto {
  const _$StripePaymentDtoImpl(
      {@JsonKey(name: 'payment_intent_id') required this.paymentIntentId,
      @JsonKey(name: 'client_secret') required this.clientSecret,
      @JsonKey(name: 'publishable_key') required this.publishableKey});

  factory _$StripePaymentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StripePaymentDtoImplFromJson(json);

  @override
  @JsonKey(name: 'payment_intent_id')
  final String paymentIntentId;
  @override
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @override
  @JsonKey(name: 'publishable_key')
  final String publishableKey;

  @override
  String toString() {
    return 'StripePaymentDto(paymentIntentId: $paymentIntentId, clientSecret: $clientSecret, publishableKey: $publishableKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StripePaymentDtoImpl &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.publishableKey, publishableKey) ||
                other.publishableKey == publishableKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentIntentId, clientSecret, publishableKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StripePaymentDtoImplCopyWith<_$StripePaymentDtoImpl> get copyWith =>
      __$$StripePaymentDtoImplCopyWithImpl<_$StripePaymentDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StripePaymentDtoImplToJson(
      this,
    );
  }
}

abstract class _StripePaymentDto implements StripePaymentDto {
  const factory _StripePaymentDto(
      {@JsonKey(name: 'payment_intent_id')
      required final String paymentIntentId,
      @JsonKey(name: 'client_secret') required final String clientSecret,
      @JsonKey(name: 'publishable_key')
      required final String publishableKey}) = _$StripePaymentDtoImpl;

  factory _StripePaymentDto.fromJson(Map<String, dynamic> json) =
      _$StripePaymentDtoImpl.fromJson;

  @override
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId;
  @override
  @JsonKey(name: 'client_secret')
  String get clientSecret;
  @override
  @JsonKey(name: 'publishable_key')
  String get publishableKey;
  @override
  @JsonKey(ignore: true)
  _$$StripePaymentDtoImplCopyWith<_$StripePaymentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingsListResponseDto _$BookingsListResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _BookingsListResponseDto.fromJson(json);
}

/// @nodoc
mixin _$BookingsListResponseDto {
  List<BookingListItemDto> get bookings => throw _privateConstructorUsedError;
  PaginationInfoDto get pagination => throw _privateConstructorUsedError;
  BookingsSummaryDto get summary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingsListResponseDtoCopyWith<BookingsListResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingsListResponseDtoCopyWith<$Res> {
  factory $BookingsListResponseDtoCopyWith(BookingsListResponseDto value,
          $Res Function(BookingsListResponseDto) then) =
      _$BookingsListResponseDtoCopyWithImpl<$Res, BookingsListResponseDto>;
  @useResult
  $Res call(
      {List<BookingListItemDto> bookings,
      PaginationInfoDto pagination,
      BookingsSummaryDto summary});

  $PaginationInfoDtoCopyWith<$Res> get pagination;
  $BookingsSummaryDtoCopyWith<$Res> get summary;
}

/// @nodoc
class _$BookingsListResponseDtoCopyWithImpl<$Res,
        $Val extends BookingsListResponseDto>
    implements $BookingsListResponseDtoCopyWith<$Res> {
  _$BookingsListResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? pagination = null,
    Object? summary = null,
  }) {
    return _then(_value.copyWith(
      bookings: null == bookings
          ? _value.bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<BookingListItemDto>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfoDto,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as BookingsSummaryDto,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoDtoCopyWith<$Res> get pagination {
    return $PaginationInfoDtoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingsSummaryDtoCopyWith<$Res> get summary {
    return $BookingsSummaryDtoCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingsListResponseDtoImplCopyWith<$Res>
    implements $BookingsListResponseDtoCopyWith<$Res> {
  factory _$$BookingsListResponseDtoImplCopyWith(
          _$BookingsListResponseDtoImpl value,
          $Res Function(_$BookingsListResponseDtoImpl) then) =
      __$$BookingsListResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BookingListItemDto> bookings,
      PaginationInfoDto pagination,
      BookingsSummaryDto summary});

  @override
  $PaginationInfoDtoCopyWith<$Res> get pagination;
  @override
  $BookingsSummaryDtoCopyWith<$Res> get summary;
}

/// @nodoc
class __$$BookingsListResponseDtoImplCopyWithImpl<$Res>
    extends _$BookingsListResponseDtoCopyWithImpl<$Res,
        _$BookingsListResponseDtoImpl>
    implements _$$BookingsListResponseDtoImplCopyWith<$Res> {
  __$$BookingsListResponseDtoImplCopyWithImpl(
      _$BookingsListResponseDtoImpl _value,
      $Res Function(_$BookingsListResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? pagination = null,
    Object? summary = null,
  }) {
    return _then(_$BookingsListResponseDtoImpl(
      bookings: null == bookings
          ? _value._bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<BookingListItemDto>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfoDto,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as BookingsSummaryDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingsListResponseDtoImpl implements _BookingsListResponseDto {
  const _$BookingsListResponseDtoImpl(
      {required final List<BookingListItemDto> bookings,
      required this.pagination,
      required this.summary})
      : _bookings = bookings;

  factory _$BookingsListResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingsListResponseDtoImplFromJson(json);

  final List<BookingListItemDto> _bookings;
  @override
  List<BookingListItemDto> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  @override
  final PaginationInfoDto pagination;
  @override
  final BookingsSummaryDto summary;

  @override
  String toString() {
    return 'BookingsListResponseDto(bookings: $bookings, pagination: $pagination, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingsListResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_bookings), pagination, summary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingsListResponseDtoImplCopyWith<_$BookingsListResponseDtoImpl>
      get copyWith => __$$BookingsListResponseDtoImplCopyWithImpl<
          _$BookingsListResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingsListResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingsListResponseDto implements BookingsListResponseDto {
  const factory _BookingsListResponseDto(
          {required final List<BookingListItemDto> bookings,
          required final PaginationInfoDto pagination,
          required final BookingsSummaryDto summary}) =
      _$BookingsListResponseDtoImpl;

  factory _BookingsListResponseDto.fromJson(Map<String, dynamic> json) =
      _$BookingsListResponseDtoImpl.fromJson;

  @override
  List<BookingListItemDto> get bookings;
  @override
  PaginationInfoDto get pagination;
  @override
  BookingsSummaryDto get summary;
  @override
  @JsonKey(ignore: true)
  _$$BookingsListResponseDtoImplCopyWith<_$BookingsListResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BookingListItemDto _$BookingListItemDtoFromJson(Map<String, dynamic> json) {
  return _BookingListItemDto.fromJson(json);
}

/// @nodoc
mixin _$BookingListItemDto {
  int get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  BookingEventInfoDto get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'tickets_count')
  int get ticketsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_paid')
  double get totalPaid => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_at')
  String get bookedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_upcoming')
  bool get isUpcoming => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_cancel')
  bool get canCancel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingListItemDtoCopyWith<BookingListItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingListItemDtoCopyWith<$Res> {
  factory $BookingListItemDtoCopyWith(
          BookingListItemDto value, $Res Function(BookingListItemDto) then) =
      _$BookingListItemDtoCopyWithImpl<$Res, BookingListItemDto>;
  @useResult
  $Res call(
      {int id,
      String reference,
      String status,
      BookingEventInfoDto event,
      @JsonKey(name: 'tickets_count') int ticketsCount,
      @JsonKey(name: 'total_paid') double totalPaid,
      String currency,
      @JsonKey(name: 'booked_at') String bookedAt,
      @JsonKey(name: 'is_upcoming') bool isUpcoming,
      @JsonKey(name: 'can_cancel') bool canCancel});

  $BookingEventInfoDtoCopyWith<$Res> get event;
}

/// @nodoc
class _$BookingListItemDtoCopyWithImpl<$Res, $Val extends BookingListItemDto>
    implements $BookingListItemDtoCopyWith<$Res> {
  _$BookingListItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? event = null,
    Object? ticketsCount = null,
    Object? totalPaid = null,
    Object? currency = null,
    Object? bookedAt = null,
    Object? isUpcoming = null,
    Object? canCancel = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as BookingEventInfoDto,
      ticketsCount: null == ticketsCount
          ? _value.ticketsCount
          : ticketsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPaid: null == totalPaid
          ? _value.totalPaid
          : totalPaid // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isUpcoming: null == isUpcoming
          ? _value.isUpcoming
          : isUpcoming // ignore: cast_nullable_to_non_nullable
              as bool,
      canCancel: null == canCancel
          ? _value.canCancel
          : canCancel // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingEventInfoDtoCopyWith<$Res> get event {
    return $BookingEventInfoDtoCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingListItemDtoImplCopyWith<$Res>
    implements $BookingListItemDtoCopyWith<$Res> {
  factory _$$BookingListItemDtoImplCopyWith(_$BookingListItemDtoImpl value,
          $Res Function(_$BookingListItemDtoImpl) then) =
      __$$BookingListItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String reference,
      String status,
      BookingEventInfoDto event,
      @JsonKey(name: 'tickets_count') int ticketsCount,
      @JsonKey(name: 'total_paid') double totalPaid,
      String currency,
      @JsonKey(name: 'booked_at') String bookedAt,
      @JsonKey(name: 'is_upcoming') bool isUpcoming,
      @JsonKey(name: 'can_cancel') bool canCancel});

  @override
  $BookingEventInfoDtoCopyWith<$Res> get event;
}

/// @nodoc
class __$$BookingListItemDtoImplCopyWithImpl<$Res>
    extends _$BookingListItemDtoCopyWithImpl<$Res, _$BookingListItemDtoImpl>
    implements _$$BookingListItemDtoImplCopyWith<$Res> {
  __$$BookingListItemDtoImplCopyWithImpl(_$BookingListItemDtoImpl _value,
      $Res Function(_$BookingListItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? event = null,
    Object? ticketsCount = null,
    Object? totalPaid = null,
    Object? currency = null,
    Object? bookedAt = null,
    Object? isUpcoming = null,
    Object? canCancel = null,
  }) {
    return _then(_$BookingListItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as BookingEventInfoDto,
      ticketsCount: null == ticketsCount
          ? _value.ticketsCount
          : ticketsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPaid: null == totalPaid
          ? _value.totalPaid
          : totalPaid // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isUpcoming: null == isUpcoming
          ? _value.isUpcoming
          : isUpcoming // ignore: cast_nullable_to_non_nullable
              as bool,
      canCancel: null == canCancel
          ? _value.canCancel
          : canCancel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingListItemDtoImpl implements _BookingListItemDto {
  const _$BookingListItemDtoImpl(
      {required this.id,
      required this.reference,
      required this.status,
      required this.event,
      @JsonKey(name: 'tickets_count') required this.ticketsCount,
      @JsonKey(name: 'total_paid') required this.totalPaid,
      required this.currency,
      @JsonKey(name: 'booked_at') required this.bookedAt,
      @JsonKey(name: 'is_upcoming') required this.isUpcoming,
      @JsonKey(name: 'can_cancel') required this.canCancel});

  factory _$BookingListItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingListItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String reference;
  @override
  final String status;
  @override
  final BookingEventInfoDto event;
  @override
  @JsonKey(name: 'tickets_count')
  final int ticketsCount;
  @override
  @JsonKey(name: 'total_paid')
  final double totalPaid;
  @override
  final String currency;
  @override
  @JsonKey(name: 'booked_at')
  final String bookedAt;
  @override
  @JsonKey(name: 'is_upcoming')
  final bool isUpcoming;
  @override
  @JsonKey(name: 'can_cancel')
  final bool canCancel;

  @override
  String toString() {
    return 'BookingListItemDto(id: $id, reference: $reference, status: $status, event: $event, ticketsCount: $ticketsCount, totalPaid: $totalPaid, currency: $currency, bookedAt: $bookedAt, isUpcoming: $isUpcoming, canCancel: $canCancel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingListItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.ticketsCount, ticketsCount) ||
                other.ticketsCount == ticketsCount) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt) &&
            (identical(other.isUpcoming, isUpcoming) ||
                other.isUpcoming == isUpcoming) &&
            (identical(other.canCancel, canCancel) ||
                other.canCancel == canCancel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, reference, status, event,
      ticketsCount, totalPaid, currency, bookedAt, isUpcoming, canCancel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingListItemDtoImplCopyWith<_$BookingListItemDtoImpl> get copyWith =>
      __$$BookingListItemDtoImplCopyWithImpl<_$BookingListItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingListItemDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingListItemDto implements BookingListItemDto {
  const factory _BookingListItemDto(
          {required final int id,
          required final String reference,
          required final String status,
          required final BookingEventInfoDto event,
          @JsonKey(name: 'tickets_count') required final int ticketsCount,
          @JsonKey(name: 'total_paid') required final double totalPaid,
          required final String currency,
          @JsonKey(name: 'booked_at') required final String bookedAt,
          @JsonKey(name: 'is_upcoming') required final bool isUpcoming,
          @JsonKey(name: 'can_cancel') required final bool canCancel}) =
      _$BookingListItemDtoImpl;

  factory _BookingListItemDto.fromJson(Map<String, dynamic> json) =
      _$BookingListItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get reference;
  @override
  String get status;
  @override
  BookingEventInfoDto get event;
  @override
  @JsonKey(name: 'tickets_count')
  int get ticketsCount;
  @override
  @JsonKey(name: 'total_paid')
  double get totalPaid;
  @override
  String get currency;
  @override
  @JsonKey(name: 'booked_at')
  String get bookedAt;
  @override
  @JsonKey(name: 'is_upcoming')
  bool get isUpcoming;
  @override
  @JsonKey(name: 'can_cancel')
  bool get canCancel;
  @override
  @JsonKey(ignore: true)
  _$$BookingListItemDtoImplCopyWith<_$BookingListItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationInfoDto _$PaginationInfoDtoFromJson(Map<String, dynamic> json) {
  return _PaginationInfoDto.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfoDto {
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationInfoDtoCopyWith<PaginationInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoDtoCopyWith<$Res> {
  factory $PaginationInfoDtoCopyWith(
          PaginationInfoDto value, $Res Function(PaginationInfoDto) then) =
      _$PaginationInfoDtoCopyWithImpl<$Res, PaginationInfoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_pages') int totalPages});
}

/// @nodoc
class _$PaginationInfoDtoCopyWithImpl<$Res, $Val extends PaginationInfoDto>
    implements $PaginationInfoDtoCopyWith<$Res> {
  _$PaginationInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoDtoImplCopyWith<$Res>
    implements $PaginationInfoDtoCopyWith<$Res> {
  factory _$$PaginationInfoDtoImplCopyWith(_$PaginationInfoDtoImpl value,
          $Res Function(_$PaginationInfoDtoImpl) then) =
      __$$PaginationInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_pages') int totalPages});
}

/// @nodoc
class __$$PaginationInfoDtoImplCopyWithImpl<$Res>
    extends _$PaginationInfoDtoCopyWithImpl<$Res, _$PaginationInfoDtoImpl>
    implements _$$PaginationInfoDtoImplCopyWith<$Res> {
  __$$PaginationInfoDtoImplCopyWithImpl(_$PaginationInfoDtoImpl _value,
      $Res Function(_$PaginationInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginationInfoDtoImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoDtoImpl implements _PaginationInfoDto {
  const _$PaginationInfoDtoImpl(
      {@JsonKey(name: 'current_page') required this.currentPage,
      @JsonKey(name: 'total_items') required this.totalItems,
      @JsonKey(name: 'total_pages') required this.totalPages});

  factory _$PaginationInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  @override
  @JsonKey(name: 'total_items')
  final int totalItems;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;

  @override
  String toString() {
    return 'PaginationInfoDto(currentPage: $currentPage, totalItems: $totalItems, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoDtoImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentPage, totalItems, totalPages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoDtoImplCopyWith<_$PaginationInfoDtoImpl> get copyWith =>
      __$$PaginationInfoDtoImplCopyWithImpl<_$PaginationInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfoDto implements PaginationInfoDto {
  const factory _PaginationInfoDto(
          {@JsonKey(name: 'current_page') required final int currentPage,
          @JsonKey(name: 'total_items') required final int totalItems,
          @JsonKey(name: 'total_pages') required final int totalPages}) =
      _$PaginationInfoDtoImpl;

  factory _PaginationInfoDto.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(ignore: true)
  _$$PaginationInfoDtoImplCopyWith<_$PaginationInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingsSummaryDto _$BookingsSummaryDtoFromJson(Map<String, dynamic> json) {
  return _BookingsSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$BookingsSummaryDto {
  int get upcoming => throw _privateConstructorUsedError;
  int get past => throw _privateConstructorUsedError;
  int get cancelled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingsSummaryDtoCopyWith<BookingsSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingsSummaryDtoCopyWith<$Res> {
  factory $BookingsSummaryDtoCopyWith(
          BookingsSummaryDto value, $Res Function(BookingsSummaryDto) then) =
      _$BookingsSummaryDtoCopyWithImpl<$Res, BookingsSummaryDto>;
  @useResult
  $Res call({int upcoming, int past, int cancelled});
}

/// @nodoc
class _$BookingsSummaryDtoCopyWithImpl<$Res, $Val extends BookingsSummaryDto>
    implements $BookingsSummaryDtoCopyWith<$Res> {
  _$BookingsSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upcoming = null,
    Object? past = null,
    Object? cancelled = null,
  }) {
    return _then(_value.copyWith(
      upcoming: null == upcoming
          ? _value.upcoming
          : upcoming // ignore: cast_nullable_to_non_nullable
              as int,
      past: null == past
          ? _value.past
          : past // ignore: cast_nullable_to_non_nullable
              as int,
      cancelled: null == cancelled
          ? _value.cancelled
          : cancelled // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingsSummaryDtoImplCopyWith<$Res>
    implements $BookingsSummaryDtoCopyWith<$Res> {
  factory _$$BookingsSummaryDtoImplCopyWith(_$BookingsSummaryDtoImpl value,
          $Res Function(_$BookingsSummaryDtoImpl) then) =
      __$$BookingsSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int upcoming, int past, int cancelled});
}

/// @nodoc
class __$$BookingsSummaryDtoImplCopyWithImpl<$Res>
    extends _$BookingsSummaryDtoCopyWithImpl<$Res, _$BookingsSummaryDtoImpl>
    implements _$$BookingsSummaryDtoImplCopyWith<$Res> {
  __$$BookingsSummaryDtoImplCopyWithImpl(_$BookingsSummaryDtoImpl _value,
      $Res Function(_$BookingsSummaryDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upcoming = null,
    Object? past = null,
    Object? cancelled = null,
  }) {
    return _then(_$BookingsSummaryDtoImpl(
      upcoming: null == upcoming
          ? _value.upcoming
          : upcoming // ignore: cast_nullable_to_non_nullable
              as int,
      past: null == past
          ? _value.past
          : past // ignore: cast_nullable_to_non_nullable
              as int,
      cancelled: null == cancelled
          ? _value.cancelled
          : cancelled // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingsSummaryDtoImpl implements _BookingsSummaryDto {
  const _$BookingsSummaryDtoImpl(
      {required this.upcoming, required this.past, required this.cancelled});

  factory _$BookingsSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingsSummaryDtoImplFromJson(json);

  @override
  final int upcoming;
  @override
  final int past;
  @override
  final int cancelled;

  @override
  String toString() {
    return 'BookingsSummaryDto(upcoming: $upcoming, past: $past, cancelled: $cancelled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingsSummaryDtoImpl &&
            (identical(other.upcoming, upcoming) ||
                other.upcoming == upcoming) &&
            (identical(other.past, past) || other.past == past) &&
            (identical(other.cancelled, cancelled) ||
                other.cancelled == cancelled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, upcoming, past, cancelled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingsSummaryDtoImplCopyWith<_$BookingsSummaryDtoImpl> get copyWith =>
      __$$BookingsSummaryDtoImplCopyWithImpl<_$BookingsSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingsSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingsSummaryDto implements BookingsSummaryDto {
  const factory _BookingsSummaryDto(
      {required final int upcoming,
      required final int past,
      required final int cancelled}) = _$BookingsSummaryDtoImpl;

  factory _BookingsSummaryDto.fromJson(Map<String, dynamic> json) =
      _$BookingsSummaryDtoImpl.fromJson;

  @override
  int get upcoming;
  @override
  int get past;
  @override
  int get cancelled;
  @override
  @JsonKey(ignore: true)
  _$$BookingsSummaryDtoImplCopyWith<_$BookingsSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketsListResponseDto _$TicketsListResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _TicketsListResponseDto.fromJson(json);
}

/// @nodoc
mixin _$TicketsListResponseDto {
  List<TicketDetailDto> get tickets => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketsListResponseDtoCopyWith<TicketsListResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketsListResponseDtoCopyWith<$Res> {
  factory $TicketsListResponseDtoCopyWith(TicketsListResponseDto value,
          $Res Function(TicketsListResponseDto) then) =
      _$TicketsListResponseDtoCopyWithImpl<$Res, TicketsListResponseDto>;
  @useResult
  $Res call({List<TicketDetailDto> tickets, int count});
}

/// @nodoc
class _$TicketsListResponseDtoCopyWithImpl<$Res,
        $Val extends TicketsListResponseDto>
    implements $TicketsListResponseDtoCopyWith<$Res> {
  _$TicketsListResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tickets = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      tickets: null == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<TicketDetailDto>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketsListResponseDtoImplCopyWith<$Res>
    implements $TicketsListResponseDtoCopyWith<$Res> {
  factory _$$TicketsListResponseDtoImplCopyWith(
          _$TicketsListResponseDtoImpl value,
          $Res Function(_$TicketsListResponseDtoImpl) then) =
      __$$TicketsListResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TicketDetailDto> tickets, int count});
}

/// @nodoc
class __$$TicketsListResponseDtoImplCopyWithImpl<$Res>
    extends _$TicketsListResponseDtoCopyWithImpl<$Res,
        _$TicketsListResponseDtoImpl>
    implements _$$TicketsListResponseDtoImplCopyWith<$Res> {
  __$$TicketsListResponseDtoImplCopyWithImpl(
      _$TicketsListResponseDtoImpl _value,
      $Res Function(_$TicketsListResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tickets = null,
    Object? count = null,
  }) {
    return _then(_$TicketsListResponseDtoImpl(
      tickets: null == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<TicketDetailDto>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketsListResponseDtoImpl implements _TicketsListResponseDto {
  const _$TicketsListResponseDtoImpl(
      {required final List<TicketDetailDto> tickets, required this.count})
      : _tickets = tickets;

  factory _$TicketsListResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketsListResponseDtoImplFromJson(json);

  final List<TicketDetailDto> _tickets;
  @override
  List<TicketDetailDto> get tickets {
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tickets);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'TicketsListResponseDto(tickets: $tickets, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketsListResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_tickets), count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketsListResponseDtoImplCopyWith<_$TicketsListResponseDtoImpl>
      get copyWith => __$$TicketsListResponseDtoImplCopyWithImpl<
          _$TicketsListResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketsListResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketsListResponseDto implements TicketsListResponseDto {
  const factory _TicketsListResponseDto(
      {required final List<TicketDetailDto> tickets,
      required final int count}) = _$TicketsListResponseDtoImpl;

  factory _TicketsListResponseDto.fromJson(Map<String, dynamic> json) =
      _$TicketsListResponseDtoImpl.fromJson;

  @override
  List<TicketDetailDto> get tickets;
  @override
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$TicketsListResponseDtoImplCopyWith<_$TicketsListResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TicketDetailDto _$TicketDetailDtoFromJson(Map<String, dynamic> json) {
  return _TicketDetailDto.fromJson(json);
}

/// @nodoc
mixin _$TicketDetailDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_number')
  String get ticketNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_label')
  String get statusLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String get qrCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type')
  String get ticketType => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  int? get bookingId => throw _privateConstructorUsedError;
  TicketAttendeeDto? get attendee => throw _privateConstructorUsedError;
  @JsonKey(name: 'seat_info')
  String? get seatInfo => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_at')
  String? get usedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  TicketEventInfoDto get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_download_pdf')
  bool get canDownloadPdf => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_upcoming')
  bool get isUpcoming => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketDetailDtoCopyWith<TicketDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketDetailDtoCopyWith<$Res> {
  factory $TicketDetailDtoCopyWith(
          TicketDetailDto value, $Res Function(TicketDetailDto) then) =
      _$TicketDetailDtoCopyWithImpl<$Res, TicketDetailDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'ticket_number') String ticketNumber,
      String status,
      @JsonKey(name: 'status_label') String statusLabel,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'ticket_type') String ticketType,
      @JsonKey(name: 'booking_id') int? bookingId,
      TicketAttendeeDto? attendee,
      @JsonKey(name: 'seat_info') String? seatInfo,
      double? price,
      @JsonKey(name: 'used_at') String? usedAt,
      @JsonKey(name: 'created_at') String? createdAt,
      TicketEventInfoDto event,
      @JsonKey(name: 'can_download_pdf') bool canDownloadPdf,
      String? instructions,
      @JsonKey(name: 'is_upcoming') bool isUpcoming});

  $TicketAttendeeDtoCopyWith<$Res>? get attendee;
  $TicketEventInfoDtoCopyWith<$Res> get event;
}

/// @nodoc
class _$TicketDetailDtoCopyWithImpl<$Res, $Val extends TicketDetailDto>
    implements $TicketDetailDtoCopyWith<$Res> {
  _$TicketDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketNumber = null,
    Object? status = null,
    Object? statusLabel = null,
    Object? qrCode = null,
    Object? ticketType = null,
    Object? bookingId = freezed,
    Object? attendee = freezed,
    Object? seatInfo = freezed,
    Object? price = freezed,
    Object? usedAt = freezed,
    Object? createdAt = freezed,
    Object? event = null,
    Object? canDownloadPdf = null,
    Object? instructions = freezed,
    Object? isUpcoming = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      ticketNumber: null == ticketNumber
          ? _value.ticketNumber
          : ticketNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String,
      ticketType: null == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int?,
      attendee: freezed == attendee
          ? _value.attendee
          : attendee // ignore: cast_nullable_to_non_nullable
              as TicketAttendeeDto?,
      seatInfo: freezed == seatInfo
          ? _value.seatInfo
          : seatInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as TicketEventInfoDto,
      canDownloadPdf: null == canDownloadPdf
          ? _value.canDownloadPdf
          : canDownloadPdf // ignore: cast_nullable_to_non_nullable
              as bool,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      isUpcoming: null == isUpcoming
          ? _value.isUpcoming
          : isUpcoming // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TicketAttendeeDtoCopyWith<$Res>? get attendee {
    if (_value.attendee == null) {
      return null;
    }

    return $TicketAttendeeDtoCopyWith<$Res>(_value.attendee!, (value) {
      return _then(_value.copyWith(attendee: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TicketEventInfoDtoCopyWith<$Res> get event {
    return $TicketEventInfoDtoCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TicketDetailDtoImplCopyWith<$Res>
    implements $TicketDetailDtoCopyWith<$Res> {
  factory _$$TicketDetailDtoImplCopyWith(_$TicketDetailDtoImpl value,
          $Res Function(_$TicketDetailDtoImpl) then) =
      __$$TicketDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'ticket_number') String ticketNumber,
      String status,
      @JsonKey(name: 'status_label') String statusLabel,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'ticket_type') String ticketType,
      @JsonKey(name: 'booking_id') int? bookingId,
      TicketAttendeeDto? attendee,
      @JsonKey(name: 'seat_info') String? seatInfo,
      double? price,
      @JsonKey(name: 'used_at') String? usedAt,
      @JsonKey(name: 'created_at') String? createdAt,
      TicketEventInfoDto event,
      @JsonKey(name: 'can_download_pdf') bool canDownloadPdf,
      String? instructions,
      @JsonKey(name: 'is_upcoming') bool isUpcoming});

  @override
  $TicketAttendeeDtoCopyWith<$Res>? get attendee;
  @override
  $TicketEventInfoDtoCopyWith<$Res> get event;
}

/// @nodoc
class __$$TicketDetailDtoImplCopyWithImpl<$Res>
    extends _$TicketDetailDtoCopyWithImpl<$Res, _$TicketDetailDtoImpl>
    implements _$$TicketDetailDtoImplCopyWith<$Res> {
  __$$TicketDetailDtoImplCopyWithImpl(
      _$TicketDetailDtoImpl _value, $Res Function(_$TicketDetailDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketNumber = null,
    Object? status = null,
    Object? statusLabel = null,
    Object? qrCode = null,
    Object? ticketType = null,
    Object? bookingId = freezed,
    Object? attendee = freezed,
    Object? seatInfo = freezed,
    Object? price = freezed,
    Object? usedAt = freezed,
    Object? createdAt = freezed,
    Object? event = null,
    Object? canDownloadPdf = null,
    Object? instructions = freezed,
    Object? isUpcoming = null,
  }) {
    return _then(_$TicketDetailDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      ticketNumber: null == ticketNumber
          ? _value.ticketNumber
          : ticketNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String,
      ticketType: null == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int?,
      attendee: freezed == attendee
          ? _value.attendee
          : attendee // ignore: cast_nullable_to_non_nullable
              as TicketAttendeeDto?,
      seatInfo: freezed == seatInfo
          ? _value.seatInfo
          : seatInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as TicketEventInfoDto,
      canDownloadPdf: null == canDownloadPdf
          ? _value.canDownloadPdf
          : canDownloadPdf // ignore: cast_nullable_to_non_nullable
              as bool,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      isUpcoming: null == isUpcoming
          ? _value.isUpcoming
          : isUpcoming // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketDetailDtoImpl implements _TicketDetailDto {
  const _$TicketDetailDtoImpl(
      {required this.id,
      @JsonKey(name: 'ticket_number') required this.ticketNumber,
      required this.status,
      @JsonKey(name: 'status_label') required this.statusLabel,
      @JsonKey(name: 'qr_code') required this.qrCode,
      @JsonKey(name: 'ticket_type') required this.ticketType,
      @JsonKey(name: 'booking_id') this.bookingId,
      this.attendee,
      @JsonKey(name: 'seat_info') this.seatInfo,
      this.price,
      @JsonKey(name: 'used_at') this.usedAt,
      @JsonKey(name: 'created_at') this.createdAt,
      required this.event,
      @JsonKey(name: 'can_download_pdf') this.canDownloadPdf = true,
      this.instructions,
      @JsonKey(name: 'is_upcoming') this.isUpcoming = false});

  factory _$TicketDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketDetailDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'ticket_number')
  final String ticketNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'status_label')
  final String statusLabel;
  @override
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @override
  @JsonKey(name: 'ticket_type')
  final String ticketType;
  @override
  @JsonKey(name: 'booking_id')
  final int? bookingId;
  @override
  final TicketAttendeeDto? attendee;
  @override
  @JsonKey(name: 'seat_info')
  final String? seatInfo;
  @override
  final double? price;
  @override
  @JsonKey(name: 'used_at')
  final String? usedAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  final TicketEventInfoDto event;
  @override
  @JsonKey(name: 'can_download_pdf')
  final bool canDownloadPdf;
  @override
  final String? instructions;
  @override
  @JsonKey(name: 'is_upcoming')
  final bool isUpcoming;

  @override
  String toString() {
    return 'TicketDetailDto(id: $id, ticketNumber: $ticketNumber, status: $status, statusLabel: $statusLabel, qrCode: $qrCode, ticketType: $ticketType, bookingId: $bookingId, attendee: $attendee, seatInfo: $seatInfo, price: $price, usedAt: $usedAt, createdAt: $createdAt, event: $event, canDownloadPdf: $canDownloadPdf, instructions: $instructions, isUpcoming: $isUpcoming)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketNumber, ticketNumber) ||
                other.ticketNumber == ticketNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.ticketType, ticketType) ||
                other.ticketType == ticketType) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.attendee, attendee) ||
                other.attendee == attendee) &&
            (identical(other.seatInfo, seatInfo) ||
                other.seatInfo == seatInfo) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.canDownloadPdf, canDownloadPdf) ||
                other.canDownloadPdf == canDownloadPdf) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.isUpcoming, isUpcoming) ||
                other.isUpcoming == isUpcoming));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ticketNumber,
      status,
      statusLabel,
      qrCode,
      ticketType,
      bookingId,
      attendee,
      seatInfo,
      price,
      usedAt,
      createdAt,
      event,
      canDownloadPdf,
      instructions,
      isUpcoming);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketDetailDtoImplCopyWith<_$TicketDetailDtoImpl> get copyWith =>
      __$$TicketDetailDtoImplCopyWithImpl<_$TicketDetailDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketDetailDto implements TicketDetailDto {
  const factory _TicketDetailDto(
          {required final int id,
          @JsonKey(name: 'ticket_number') required final String ticketNumber,
          required final String status,
          @JsonKey(name: 'status_label') required final String statusLabel,
          @JsonKey(name: 'qr_code') required final String qrCode,
          @JsonKey(name: 'ticket_type') required final String ticketType,
          @JsonKey(name: 'booking_id') final int? bookingId,
          final TicketAttendeeDto? attendee,
          @JsonKey(name: 'seat_info') final String? seatInfo,
          final double? price,
          @JsonKey(name: 'used_at') final String? usedAt,
          @JsonKey(name: 'created_at') final String? createdAt,
          required final TicketEventInfoDto event,
          @JsonKey(name: 'can_download_pdf') final bool canDownloadPdf,
          final String? instructions,
          @JsonKey(name: 'is_upcoming') final bool isUpcoming}) =
      _$TicketDetailDtoImpl;

  factory _TicketDetailDto.fromJson(Map<String, dynamic> json) =
      _$TicketDetailDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'ticket_number')
  String get ticketNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'status_label')
  String get statusLabel;
  @override
  @JsonKey(name: 'qr_code')
  String get qrCode;
  @override
  @JsonKey(name: 'ticket_type')
  String get ticketType;
  @override
  @JsonKey(name: 'booking_id')
  int? get bookingId;
  @override
  TicketAttendeeDto? get attendee;
  @override
  @JsonKey(name: 'seat_info')
  String? get seatInfo;
  @override
  double? get price;
  @override
  @JsonKey(name: 'used_at')
  String? get usedAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  TicketEventInfoDto get event;
  @override
  @JsonKey(name: 'can_download_pdf')
  bool get canDownloadPdf;
  @override
  String? get instructions;
  @override
  @JsonKey(name: 'is_upcoming')
  bool get isUpcoming;
  @override
  @JsonKey(ignore: true)
  _$$TicketDetailDtoImplCopyWith<_$TicketDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketAttendeeDto _$TicketAttendeeDtoFromJson(Map<String, dynamic> json) {
  return _TicketAttendeeDto.fromJson(json);
}

/// @nodoc
mixin _$TicketAttendeeDto {
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketAttendeeDtoCopyWith<TicketAttendeeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketAttendeeDtoCopyWith<$Res> {
  factory $TicketAttendeeDtoCopyWith(
          TicketAttendeeDto value, $Res Function(TicketAttendeeDto) then) =
      _$TicketAttendeeDtoCopyWithImpl<$Res, TicketAttendeeDto>;
  @useResult
  $Res call({String name, String? email});
}

/// @nodoc
class _$TicketAttendeeDtoCopyWithImpl<$Res, $Val extends TicketAttendeeDto>
    implements $TicketAttendeeDtoCopyWith<$Res> {
  _$TicketAttendeeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketAttendeeDtoImplCopyWith<$Res>
    implements $TicketAttendeeDtoCopyWith<$Res> {
  factory _$$TicketAttendeeDtoImplCopyWith(_$TicketAttendeeDtoImpl value,
          $Res Function(_$TicketAttendeeDtoImpl) then) =
      __$$TicketAttendeeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? email});
}

/// @nodoc
class __$$TicketAttendeeDtoImplCopyWithImpl<$Res>
    extends _$TicketAttendeeDtoCopyWithImpl<$Res, _$TicketAttendeeDtoImpl>
    implements _$$TicketAttendeeDtoImplCopyWith<$Res> {
  __$$TicketAttendeeDtoImplCopyWithImpl(_$TicketAttendeeDtoImpl _value,
      $Res Function(_$TicketAttendeeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = freezed,
  }) {
    return _then(_$TicketAttendeeDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketAttendeeDtoImpl implements _TicketAttendeeDto {
  const _$TicketAttendeeDtoImpl({required this.name, this.email});

  factory _$TicketAttendeeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketAttendeeDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String? email;

  @override
  String toString() {
    return 'TicketAttendeeDto(name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketAttendeeDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketAttendeeDtoImplCopyWith<_$TicketAttendeeDtoImpl> get copyWith =>
      __$$TicketAttendeeDtoImplCopyWithImpl<_$TicketAttendeeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketAttendeeDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketAttendeeDto implements TicketAttendeeDto {
  const factory _TicketAttendeeDto(
      {required final String name,
      final String? email}) = _$TicketAttendeeDtoImpl;

  factory _TicketAttendeeDto.fromJson(Map<String, dynamic> json) =
      _$TicketAttendeeDtoImpl.fromJson;

  @override
  String get name;
  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$TicketAttendeeDtoImplCopyWith<_$TicketAttendeeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketEventInfoDto _$TicketEventInfoDtoFromJson(Map<String, dynamic> json) {
  return _TicketEventInfoDto.fromJson(json);
}

/// @nodoc
mixin _$TicketEventInfoDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_end')
  String? get dateEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_end')
  String? get timeEnd => throw _privateConstructorUsedError;
  String? get venue => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  TicketLocationDto? get location => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_large')
  String? get thumbnailLarge => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketEventInfoDtoCopyWith<TicketEventInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketEventInfoDtoCopyWith<$Res> {
  factory $TicketEventInfoDtoCopyWith(
          TicketEventInfoDto value, $Res Function(TicketEventInfoDto) then) =
      _$TicketEventInfoDtoCopyWithImpl<$Res, TicketEventInfoDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String date,
      String? time,
      @JsonKey(name: 'date_end') String? dateEnd,
      @JsonKey(name: 'time_end') String? timeEnd,
      String? venue,
      String? address,
      String? city,
      TicketLocationDto? location,
      String? thumbnail,
      @JsonKey(name: 'thumbnail_large') String? thumbnailLarge});

  $TicketLocationDtoCopyWith<$Res>? get location;
}

/// @nodoc
class _$TicketEventInfoDtoCopyWithImpl<$Res, $Val extends TicketEventInfoDto>
    implements $TicketEventInfoDtoCopyWith<$Res> {
  _$TicketEventInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = null,
    Object? time = freezed,
    Object? dateEnd = freezed,
    Object? timeEnd = freezed,
    Object? venue = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? location = freezed,
    Object? thumbnail = freezed,
    Object? thumbnailLarge = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      dateEnd: freezed == dateEnd
          ? _value.dateEnd
          : dateEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      timeEnd: freezed == timeEnd
          ? _value.timeEnd
          : timeEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as TicketLocationDto?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailLarge: freezed == thumbnailLarge
          ? _value.thumbnailLarge
          : thumbnailLarge // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TicketLocationDtoCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $TicketLocationDtoCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TicketEventInfoDtoImplCopyWith<$Res>
    implements $TicketEventInfoDtoCopyWith<$Res> {
  factory _$$TicketEventInfoDtoImplCopyWith(_$TicketEventInfoDtoImpl value,
          $Res Function(_$TicketEventInfoDtoImpl) then) =
      __$$TicketEventInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String date,
      String? time,
      @JsonKey(name: 'date_end') String? dateEnd,
      @JsonKey(name: 'time_end') String? timeEnd,
      String? venue,
      String? address,
      String? city,
      TicketLocationDto? location,
      String? thumbnail,
      @JsonKey(name: 'thumbnail_large') String? thumbnailLarge});

  @override
  $TicketLocationDtoCopyWith<$Res>? get location;
}

/// @nodoc
class __$$TicketEventInfoDtoImplCopyWithImpl<$Res>
    extends _$TicketEventInfoDtoCopyWithImpl<$Res, _$TicketEventInfoDtoImpl>
    implements _$$TicketEventInfoDtoImplCopyWith<$Res> {
  __$$TicketEventInfoDtoImplCopyWithImpl(_$TicketEventInfoDtoImpl _value,
      $Res Function(_$TicketEventInfoDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = null,
    Object? time = freezed,
    Object? dateEnd = freezed,
    Object? timeEnd = freezed,
    Object? venue = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? location = freezed,
    Object? thumbnail = freezed,
    Object? thumbnailLarge = freezed,
  }) {
    return _then(_$TicketEventInfoDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      dateEnd: freezed == dateEnd
          ? _value.dateEnd
          : dateEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      timeEnd: freezed == timeEnd
          ? _value.timeEnd
          : timeEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as TicketLocationDto?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailLarge: freezed == thumbnailLarge
          ? _value.thumbnailLarge
          : thumbnailLarge // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketEventInfoDtoImpl implements _TicketEventInfoDto {
  const _$TicketEventInfoDtoImpl(
      {required this.id,
      required this.title,
      required this.date,
      this.time,
      @JsonKey(name: 'date_end') this.dateEnd,
      @JsonKey(name: 'time_end') this.timeEnd,
      this.venue,
      this.address,
      this.city,
      this.location,
      this.thumbnail,
      @JsonKey(name: 'thumbnail_large') this.thumbnailLarge});

  factory _$TicketEventInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketEventInfoDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String date;
  @override
  final String? time;
  @override
  @JsonKey(name: 'date_end')
  final String? dateEnd;
  @override
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @override
  final String? venue;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final TicketLocationDto? location;
  @override
  final String? thumbnail;
  @override
  @JsonKey(name: 'thumbnail_large')
  final String? thumbnailLarge;

  @override
  String toString() {
    return 'TicketEventInfoDto(id: $id, title: $title, date: $date, time: $time, dateEnd: $dateEnd, timeEnd: $timeEnd, venue: $venue, address: $address, city: $city, location: $location, thumbnail: $thumbnail, thumbnailLarge: $thumbnailLarge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketEventInfoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.dateEnd, dateEnd) || other.dateEnd == dateEnd) &&
            (identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.thumbnailLarge, thumbnailLarge) ||
                other.thumbnailLarge == thumbnailLarge));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, date, time, dateEnd,
      timeEnd, venue, address, city, location, thumbnail, thumbnailLarge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketEventInfoDtoImplCopyWith<_$TicketEventInfoDtoImpl> get copyWith =>
      __$$TicketEventInfoDtoImplCopyWithImpl<_$TicketEventInfoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketEventInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketEventInfoDto implements TicketEventInfoDto {
  const factory _TicketEventInfoDto(
          {required final int id,
          required final String title,
          required final String date,
          final String? time,
          @JsonKey(name: 'date_end') final String? dateEnd,
          @JsonKey(name: 'time_end') final String? timeEnd,
          final String? venue,
          final String? address,
          final String? city,
          final TicketLocationDto? location,
          final String? thumbnail,
          @JsonKey(name: 'thumbnail_large') final String? thumbnailLarge}) =
      _$TicketEventInfoDtoImpl;

  factory _TicketEventInfoDto.fromJson(Map<String, dynamic> json) =
      _$TicketEventInfoDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get date;
  @override
  String? get time;
  @override
  @JsonKey(name: 'date_end')
  String? get dateEnd;
  @override
  @JsonKey(name: 'time_end')
  String? get timeEnd;
  @override
  String? get venue;
  @override
  String? get address;
  @override
  String? get city;
  @override
  TicketLocationDto? get location;
  @override
  String? get thumbnail;
  @override
  @JsonKey(name: 'thumbnail_large')
  String? get thumbnailLarge;
  @override
  @JsonKey(ignore: true)
  _$$TicketEventInfoDtoImplCopyWith<_$TicketEventInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketLocationDto _$TicketLocationDtoFromJson(Map<String, dynamic> json) {
  return _TicketLocationDto.fromJson(json);
}

/// @nodoc
mixin _$TicketLocationDto {
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketLocationDtoCopyWith<TicketLocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketLocationDtoCopyWith<$Res> {
  factory $TicketLocationDtoCopyWith(
          TicketLocationDto value, $Res Function(TicketLocationDto) then) =
      _$TicketLocationDtoCopyWithImpl<$Res, TicketLocationDto>;
  @useResult
  $Res call({double? lat, double? lng});
}

/// @nodoc
class _$TicketLocationDtoCopyWithImpl<$Res, $Val extends TicketLocationDto>
    implements $TicketLocationDtoCopyWith<$Res> {
  _$TicketLocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_value.copyWith(
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketLocationDtoImplCopyWith<$Res>
    implements $TicketLocationDtoCopyWith<$Res> {
  factory _$$TicketLocationDtoImplCopyWith(_$TicketLocationDtoImpl value,
          $Res Function(_$TicketLocationDtoImpl) then) =
      __$$TicketLocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? lat, double? lng});
}

/// @nodoc
class __$$TicketLocationDtoImplCopyWithImpl<$Res>
    extends _$TicketLocationDtoCopyWithImpl<$Res, _$TicketLocationDtoImpl>
    implements _$$TicketLocationDtoImplCopyWith<$Res> {
  __$$TicketLocationDtoImplCopyWithImpl(_$TicketLocationDtoImpl _value,
      $Res Function(_$TicketLocationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_$TicketLocationDtoImpl(
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketLocationDtoImpl implements _TicketLocationDto {
  const _$TicketLocationDtoImpl({this.lat, this.lng});

  factory _$TicketLocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketLocationDtoImplFromJson(json);

  @override
  final double? lat;
  @override
  final double? lng;

  @override
  String toString() {
    return 'TicketLocationDto(lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketLocationDtoImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketLocationDtoImplCopyWith<_$TicketLocationDtoImpl> get copyWith =>
      __$$TicketLocationDtoImplCopyWithImpl<_$TicketLocationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketLocationDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketLocationDto implements TicketLocationDto {
  const factory _TicketLocationDto({final double? lat, final double? lng}) =
      _$TicketLocationDtoImpl;

  factory _TicketLocationDto.fromJson(Map<String, dynamic> json) =
      _$TicketLocationDtoImpl.fromJson;

  @override
  double? get lat;
  @override
  double? get lng;
  @override
  @JsonKey(ignore: true)
  _$$TicketLocationDtoImplCopyWith<_$TicketLocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

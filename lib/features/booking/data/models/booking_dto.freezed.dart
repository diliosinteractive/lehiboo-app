// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) {
  return _BookingDto.fromJson(json);
}

/// @nodoc
mixin _$BookingDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_id')
  int get slotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  int get activityId => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double? get totalPrice => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_provider')
  String? get paymentProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_reference')
  String? get paymentReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Nested objects
  ActivityDto? get activity => throw _privateConstructorUsedError;
  SlotDto? get slot => throw _privateConstructorUsedError;
  List<TicketDto>? get tickets =>
      throw _privateConstructorUsedError; // Customer info
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_first_name')
  String? get customerFirstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_last_name')
  String? get customerLastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError; // Reference
  String? get reference => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingDtoCopyWith<BookingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDtoCopyWith<$Res> {
  factory $BookingDtoCopyWith(
          BookingDto value, $Res Function(BookingDto) then) =
      _$BookingDtoCopyWithImpl<$Res, BookingDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'slot_id') int slotId,
      @JsonKey(name: 'activity_id') int activityId,
      int? quantity,
      @JsonKey(name: 'total_price') double? totalPrice,
      String? currency,
      String? status,
      @JsonKey(name: 'payment_provider') String? paymentProvider,
      @JsonKey(name: 'payment_reference') String? paymentReference,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      ActivityDto? activity,
      SlotDto? slot,
      List<TicketDto>? tickets,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'customer_first_name') String? customerFirstName,
      @JsonKey(name: 'customer_last_name') String? customerLastName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      String? reference});

  $ActivityDtoCopyWith<$Res>? get activity;
  $SlotDtoCopyWith<$Res>? get slot;
}

/// @nodoc
class _$BookingDtoCopyWithImpl<$Res, $Val extends BookingDto>
    implements $BookingDtoCopyWith<$Res> {
  _$BookingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? slotId = null,
    Object? activityId = null,
    Object? quantity = freezed,
    Object? totalPrice = freezed,
    Object? currency = freezed,
    Object? status = freezed,
    Object? paymentProvider = freezed,
    Object? paymentReference = freezed,
    Object? createdAt = freezed,
    Object? activity = freezed,
    Object? slot = freezed,
    Object? tickets = freezed,
    Object? customerEmail = freezed,
    Object? customerFirstName = freezed,
    Object? customerLastName = freezed,
    Object? customerPhone = freezed,
    Object? reference = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as int,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProvider: freezed == paymentProvider
          ? _value.paymentProvider
          : paymentProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activity: freezed == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as ActivityDto?,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as SlotDto?,
      tickets: freezed == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<TicketDto>?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      customerFirstName: freezed == customerFirstName
          ? _value.customerFirstName
          : customerFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerLastName: freezed == customerLastName
          ? _value.customerLastName
          : customerLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityDtoCopyWith<$Res>? get activity {
    if (_value.activity == null) {
      return null;
    }

    return $ActivityDtoCopyWith<$Res>(_value.activity!, (value) {
      return _then(_value.copyWith(activity: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SlotDtoCopyWith<$Res>? get slot {
    if (_value.slot == null) {
      return null;
    }

    return $SlotDtoCopyWith<$Res>(_value.slot!, (value) {
      return _then(_value.copyWith(slot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingDtoImplCopyWith<$Res>
    implements $BookingDtoCopyWith<$Res> {
  factory _$$BookingDtoImplCopyWith(
          _$BookingDtoImpl value, $Res Function(_$BookingDtoImpl) then) =
      __$$BookingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'slot_id') int slotId,
      @JsonKey(name: 'activity_id') int activityId,
      int? quantity,
      @JsonKey(name: 'total_price') double? totalPrice,
      String? currency,
      String? status,
      @JsonKey(name: 'payment_provider') String? paymentProvider,
      @JsonKey(name: 'payment_reference') String? paymentReference,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      ActivityDto? activity,
      SlotDto? slot,
      List<TicketDto>? tickets,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'customer_first_name') String? customerFirstName,
      @JsonKey(name: 'customer_last_name') String? customerLastName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      String? reference});

  @override
  $ActivityDtoCopyWith<$Res>? get activity;
  @override
  $SlotDtoCopyWith<$Res>? get slot;
}

/// @nodoc
class __$$BookingDtoImplCopyWithImpl<$Res>
    extends _$BookingDtoCopyWithImpl<$Res, _$BookingDtoImpl>
    implements _$$BookingDtoImplCopyWith<$Res> {
  __$$BookingDtoImplCopyWithImpl(
      _$BookingDtoImpl _value, $Res Function(_$BookingDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? slotId = null,
    Object? activityId = null,
    Object? quantity = freezed,
    Object? totalPrice = freezed,
    Object? currency = freezed,
    Object? status = freezed,
    Object? paymentProvider = freezed,
    Object? paymentReference = freezed,
    Object? createdAt = freezed,
    Object? activity = freezed,
    Object? slot = freezed,
    Object? tickets = freezed,
    Object? customerEmail = freezed,
    Object? customerFirstName = freezed,
    Object? customerLastName = freezed,
    Object? customerPhone = freezed,
    Object? reference = freezed,
  }) {
    return _then(_$BookingDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as int,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProvider: freezed == paymentProvider
          ? _value.paymentProvider
          : paymentProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activity: freezed == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as ActivityDto?,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as SlotDto?,
      tickets: freezed == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<TicketDto>?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      customerFirstName: freezed == customerFirstName
          ? _value.customerFirstName
          : customerFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerLastName: freezed == customerLastName
          ? _value.customerLastName
          : customerLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingDtoImpl implements _BookingDto {
  const _$BookingDtoImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'slot_id') required this.slotId,
      @JsonKey(name: 'activity_id') required this.activityId,
      this.quantity,
      @JsonKey(name: 'total_price') this.totalPrice,
      this.currency,
      this.status,
      @JsonKey(name: 'payment_provider') this.paymentProvider,
      @JsonKey(name: 'payment_reference') this.paymentReference,
      @JsonKey(name: 'created_at') this.createdAt,
      this.activity,
      this.slot,
      final List<TicketDto>? tickets,
      @JsonKey(name: 'customer_email') this.customerEmail,
      @JsonKey(name: 'customer_first_name') this.customerFirstName,
      @JsonKey(name: 'customer_last_name') this.customerLastName,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      this.reference})
      : _tickets = tickets;

  factory _$BookingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'slot_id')
  final int slotId;
  @override
  @JsonKey(name: 'activity_id')
  final int activityId;
  @override
  final int? quantity;
  @override
  @JsonKey(name: 'total_price')
  final double? totalPrice;
  @override
  final String? currency;
  @override
  final String? status;
  @override
  @JsonKey(name: 'payment_provider')
  final String? paymentProvider;
  @override
  @JsonKey(name: 'payment_reference')
  final String? paymentReference;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// Nested objects
  @override
  final ActivityDto? activity;
  @override
  final SlotDto? slot;
  final List<TicketDto>? _tickets;
  @override
  List<TicketDto>? get tickets {
    final value = _tickets;
    if (value == null) return null;
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Customer info
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @override
  @JsonKey(name: 'customer_first_name')
  final String? customerFirstName;
  @override
  @JsonKey(name: 'customer_last_name')
  final String? customerLastName;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
// Reference
  @override
  final String? reference;

  @override
  String toString() {
    return 'BookingDto(id: $id, userId: $userId, slotId: $slotId, activityId: $activityId, quantity: $quantity, totalPrice: $totalPrice, currency: $currency, status: $status, paymentProvider: $paymentProvider, paymentReference: $paymentReference, createdAt: $createdAt, activity: $activity, slot: $slot, tickets: $tickets, customerEmail: $customerEmail, customerFirstName: $customerFirstName, customerLastName: $customerLastName, customerPhone: $customerPhone, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentProvider, paymentProvider) ||
                other.paymentProvider == paymentProvider) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerFirstName, customerFirstName) ||
                other.customerFirstName == customerFirstName) &&
            (identical(other.customerLastName, customerLastName) ||
                other.customerLastName == customerLastName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        slotId,
        activityId,
        quantity,
        totalPrice,
        currency,
        status,
        paymentProvider,
        paymentReference,
        createdAt,
        activity,
        slot,
        const DeepCollectionEquality().hash(_tickets),
        customerEmail,
        customerFirstName,
        customerLastName,
        customerPhone,
        reference
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      __$$BookingDtoImplCopyWithImpl<_$BookingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingDto implements BookingDto {
  const factory _BookingDto(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'slot_id') required final int slotId,
      @JsonKey(name: 'activity_id') required final int activityId,
      final int? quantity,
      @JsonKey(name: 'total_price') final double? totalPrice,
      final String? currency,
      final String? status,
      @JsonKey(name: 'payment_provider') final String? paymentProvider,
      @JsonKey(name: 'payment_reference') final String? paymentReference,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      final ActivityDto? activity,
      final SlotDto? slot,
      final List<TicketDto>? tickets,
      @JsonKey(name: 'customer_email') final String? customerEmail,
      @JsonKey(name: 'customer_first_name') final String? customerFirstName,
      @JsonKey(name: 'customer_last_name') final String? customerLastName,
      @JsonKey(name: 'customer_phone') final String? customerPhone,
      final String? reference}) = _$BookingDtoImpl;

  factory _BookingDto.fromJson(Map<String, dynamic> json) =
      _$BookingDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'slot_id')
  int get slotId;
  @override
  @JsonKey(name: 'activity_id')
  int get activityId;
  @override
  int? get quantity;
  @override
  @JsonKey(name: 'total_price')
  double? get totalPrice;
  @override
  String? get currency;
  @override
  String? get status;
  @override
  @JsonKey(name: 'payment_provider')
  String? get paymentProvider;
  @override
  @JsonKey(name: 'payment_reference')
  String? get paymentReference;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override // Nested objects
  ActivityDto? get activity;
  @override
  SlotDto? get slot;
  @override
  List<TicketDto>? get tickets;
  @override // Customer info
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'customer_first_name')
  String? get customerFirstName;
  @override
  @JsonKey(name: 'customer_last_name')
  String? get customerLastName;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override // Reference
  String? get reference;
  @override
  @JsonKey(ignore: true)
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketDto _$TicketDtoFromJson(Map<String, dynamic> json) {
  return _TicketDto.fromJson(json);
}

/// @nodoc
mixin _$TicketDto {
  String get id => throw _privateConstructorUsedError;
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  String? get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_id')
  String get slotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type_id')
  String? get ticketTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type')
  String? get ticketType => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String? get qrCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code_data')
  String? get qrCodeData => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_secret')
  String? get qrSecret => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError; // Attendee info
  @JsonKey(name: 'attendee_first_name')
  String? get attendeeFirstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendee_last_name')
  String? get attendeeLastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendee_email')
  String? get attendeeEmail => throw _privateConstructorUsedError; // Pricing
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError; // Timestamps
  @JsonKey(name: 'used_at')
  DateTime? get usedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TicketDtoCopyWith<TicketDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketDtoCopyWith<$Res> {
  factory $TicketDtoCopyWith(TicketDto value, $Res Function(TicketDto) then) =
      _$TicketDtoCopyWithImpl<$Res, TicketDto>;
  @useResult
  $Res call(
      {String id,
      String? uuid,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'event_id') String? eventId,
      @JsonKey(name: 'slot_id') String slotId,
      @JsonKey(name: 'ticket_type_id') String? ticketTypeId,
      @JsonKey(name: 'ticket_type') String? ticketType,
      @JsonKey(name: 'qr_code') String? qrCode,
      @JsonKey(name: 'qr_code_data') String? qrCodeData,
      @JsonKey(name: 'qr_secret') String? qrSecret,
      String? status,
      @JsonKey(name: 'attendee_first_name') String? attendeeFirstName,
      @JsonKey(name: 'attendee_last_name') String? attendeeLastName,
      @JsonKey(name: 'attendee_email') String? attendeeEmail,
      double? price,
      String? currency,
      @JsonKey(name: 'used_at') DateTime? usedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$TicketDtoCopyWithImpl<$Res, $Val extends TicketDto>
    implements $TicketDtoCopyWith<$Res> {
  _$TicketDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? bookingId = null,
    Object? eventId = freezed,
    Object? slotId = null,
    Object? ticketTypeId = freezed,
    Object? ticketType = freezed,
    Object? qrCode = freezed,
    Object? qrCodeData = freezed,
    Object? qrSecret = freezed,
    Object? status = freezed,
    Object? attendeeFirstName = freezed,
    Object? attendeeLastName = freezed,
    Object? attendeeEmail = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? usedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketTypeId: freezed == ticketTypeId
          ? _value.ticketTypeId
          : ticketTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      qrSecret: freezed == qrSecret
          ? _value.qrSecret
          : qrSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeFirstName: freezed == attendeeFirstName
          ? _value.attendeeFirstName
          : attendeeFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeLastName: freezed == attendeeLastName
          ? _value.attendeeLastName
          : attendeeLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeEmail: freezed == attendeeEmail
          ? _value.attendeeEmail
          : attendeeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketDtoImplCopyWith<$Res>
    implements $TicketDtoCopyWith<$Res> {
  factory _$$TicketDtoImplCopyWith(
          _$TicketDtoImpl value, $Res Function(_$TicketDtoImpl) then) =
      __$$TicketDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? uuid,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'event_id') String? eventId,
      @JsonKey(name: 'slot_id') String slotId,
      @JsonKey(name: 'ticket_type_id') String? ticketTypeId,
      @JsonKey(name: 'ticket_type') String? ticketType,
      @JsonKey(name: 'qr_code') String? qrCode,
      @JsonKey(name: 'qr_code_data') String? qrCodeData,
      @JsonKey(name: 'qr_secret') String? qrSecret,
      String? status,
      @JsonKey(name: 'attendee_first_name') String? attendeeFirstName,
      @JsonKey(name: 'attendee_last_name') String? attendeeLastName,
      @JsonKey(name: 'attendee_email') String? attendeeEmail,
      double? price,
      String? currency,
      @JsonKey(name: 'used_at') DateTime? usedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$TicketDtoImplCopyWithImpl<$Res>
    extends _$TicketDtoCopyWithImpl<$Res, _$TicketDtoImpl>
    implements _$$TicketDtoImplCopyWith<$Res> {
  __$$TicketDtoImplCopyWithImpl(
      _$TicketDtoImpl _value, $Res Function(_$TicketDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? bookingId = null,
    Object? eventId = freezed,
    Object? slotId = null,
    Object? ticketTypeId = freezed,
    Object? ticketType = freezed,
    Object? qrCode = freezed,
    Object? qrCodeData = freezed,
    Object? qrSecret = freezed,
    Object? status = freezed,
    Object? attendeeFirstName = freezed,
    Object? attendeeLastName = freezed,
    Object? attendeeEmail = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? usedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TicketDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketTypeId: freezed == ticketTypeId
          ? _value.ticketTypeId
          : ticketTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      qrSecret: freezed == qrSecret
          ? _value.qrSecret
          : qrSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeFirstName: freezed == attendeeFirstName
          ? _value.attendeeFirstName
          : attendeeFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeLastName: freezed == attendeeLastName
          ? _value.attendeeLastName
          : attendeeLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendeeEmail: freezed == attendeeEmail
          ? _value.attendeeEmail
          : attendeeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketDtoImpl implements _TicketDto {
  const _$TicketDtoImpl(
      {required this.id,
      this.uuid,
      @JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'event_id') this.eventId,
      @JsonKey(name: 'slot_id') required this.slotId,
      @JsonKey(name: 'ticket_type_id') this.ticketTypeId,
      @JsonKey(name: 'ticket_type') this.ticketType,
      @JsonKey(name: 'qr_code') this.qrCode,
      @JsonKey(name: 'qr_code_data') this.qrCodeData,
      @JsonKey(name: 'qr_secret') this.qrSecret,
      this.status,
      @JsonKey(name: 'attendee_first_name') this.attendeeFirstName,
      @JsonKey(name: 'attendee_last_name') this.attendeeLastName,
      @JsonKey(name: 'attendee_email') this.attendeeEmail,
      this.price,
      this.currency,
      @JsonKey(name: 'used_at') this.usedAt,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$TicketDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String? uuid;
  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'event_id')
  final String? eventId;
  @override
  @JsonKey(name: 'slot_id')
  final String slotId;
  @override
  @JsonKey(name: 'ticket_type_id')
  final String? ticketTypeId;
  @override
  @JsonKey(name: 'ticket_type')
  final String? ticketType;
  @override
  @JsonKey(name: 'qr_code')
  final String? qrCode;
  @override
  @JsonKey(name: 'qr_code_data')
  final String? qrCodeData;
  @override
  @JsonKey(name: 'qr_secret')
  final String? qrSecret;
  @override
  final String? status;
// Attendee info
  @override
  @JsonKey(name: 'attendee_first_name')
  final String? attendeeFirstName;
  @override
  @JsonKey(name: 'attendee_last_name')
  final String? attendeeLastName;
  @override
  @JsonKey(name: 'attendee_email')
  final String? attendeeEmail;
// Pricing
  @override
  final double? price;
  @override
  final String? currency;
// Timestamps
  @override
  @JsonKey(name: 'used_at')
  final DateTime? usedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TicketDto(id: $id, uuid: $uuid, bookingId: $bookingId, eventId: $eventId, slotId: $slotId, ticketTypeId: $ticketTypeId, ticketType: $ticketType, qrCode: $qrCode, qrCodeData: $qrCodeData, qrSecret: $qrSecret, status: $status, attendeeFirstName: $attendeeFirstName, attendeeLastName: $attendeeLastName, attendeeEmail: $attendeeEmail, price: $price, currency: $currency, usedAt: $usedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.ticketTypeId, ticketTypeId) ||
                other.ticketTypeId == ticketTypeId) &&
            (identical(other.ticketType, ticketType) ||
                other.ticketType == ticketType) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.qrCodeData, qrCodeData) ||
                other.qrCodeData == qrCodeData) &&
            (identical(other.qrSecret, qrSecret) ||
                other.qrSecret == qrSecret) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.attendeeFirstName, attendeeFirstName) ||
                other.attendeeFirstName == attendeeFirstName) &&
            (identical(other.attendeeLastName, attendeeLastName) ||
                other.attendeeLastName == attendeeLastName) &&
            (identical(other.attendeeEmail, attendeeEmail) ||
                other.attendeeEmail == attendeeEmail) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uuid,
      bookingId,
      eventId,
      slotId,
      ticketTypeId,
      ticketType,
      qrCode,
      qrCodeData,
      qrSecret,
      status,
      attendeeFirstName,
      attendeeLastName,
      attendeeEmail,
      price,
      currency,
      usedAt,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketDtoImplCopyWith<_$TicketDtoImpl> get copyWith =>
      __$$TicketDtoImplCopyWithImpl<_$TicketDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketDtoImplToJson(
      this,
    );
  }
}

abstract class _TicketDto implements TicketDto {
  const factory _TicketDto(
          {required final String id,
          final String? uuid,
          @JsonKey(name: 'booking_id') required final String bookingId,
          @JsonKey(name: 'event_id') final String? eventId,
          @JsonKey(name: 'slot_id') required final String slotId,
          @JsonKey(name: 'ticket_type_id') final String? ticketTypeId,
          @JsonKey(name: 'ticket_type') final String? ticketType,
          @JsonKey(name: 'qr_code') final String? qrCode,
          @JsonKey(name: 'qr_code_data') final String? qrCodeData,
          @JsonKey(name: 'qr_secret') final String? qrSecret,
          final String? status,
          @JsonKey(name: 'attendee_first_name') final String? attendeeFirstName,
          @JsonKey(name: 'attendee_last_name') final String? attendeeLastName,
          @JsonKey(name: 'attendee_email') final String? attendeeEmail,
          final double? price,
          final String? currency,
          @JsonKey(name: 'used_at') final DateTime? usedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$TicketDtoImpl;

  factory _TicketDto.fromJson(Map<String, dynamic> json) =
      _$TicketDtoImpl.fromJson;

  @override
  String get id;
  @override
  String? get uuid;
  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  @JsonKey(name: 'event_id')
  String? get eventId;
  @override
  @JsonKey(name: 'slot_id')
  String get slotId;
  @override
  @JsonKey(name: 'ticket_type_id')
  String? get ticketTypeId;
  @override
  @JsonKey(name: 'ticket_type')
  String? get ticketType;
  @override
  @JsonKey(name: 'qr_code')
  String? get qrCode;
  @override
  @JsonKey(name: 'qr_code_data')
  String? get qrCodeData;
  @override
  @JsonKey(name: 'qr_secret')
  String? get qrSecret;
  @override
  String? get status;
  @override // Attendee info
  @JsonKey(name: 'attendee_first_name')
  String? get attendeeFirstName;
  @override
  @JsonKey(name: 'attendee_last_name')
  String? get attendeeLastName;
  @override
  @JsonKey(name: 'attendee_email')
  String? get attendeeEmail;
  @override // Pricing
  double? get price;
  @override
  String? get currency;
  @override // Timestamps
  @JsonKey(name: 'used_at')
  DateTime? get usedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TicketDtoImplCopyWith<_$TicketDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingItemDto _$BookingItemDtoFromJson(Map<String, dynamic> json) {
  return _BookingItemDto.fromJson(json);
}

/// @nodoc
mixin _$BookingItemDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type_id')
  String get ticketTypeId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type_name')
  String? get ticketTypeName => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingItemDtoCopyWith<BookingItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingItemDtoCopyWith<$Res> {
  factory $BookingItemDtoCopyWith(
          BookingItemDto value, $Res Function(BookingItemDto) then) =
      _$BookingItemDtoCopyWithImpl<$Res, BookingItemDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'ticket_type_id') String ticketTypeId,
      int quantity,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'total_price') double totalPrice,
      @JsonKey(name: 'ticket_type_name') String? ticketTypeName,
      String? currency});
}

/// @nodoc
class _$BookingItemDtoCopyWithImpl<$Res, $Val extends BookingItemDto>
    implements $BookingItemDtoCopyWith<$Res> {
  _$BookingItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? ticketTypeId = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? ticketTypeName = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketTypeId: null == ticketTypeId
          ? _value.ticketTypeId
          : ticketTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      ticketTypeName: freezed == ticketTypeName
          ? _value.ticketTypeName
          : ticketTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingItemDtoImplCopyWith<$Res>
    implements $BookingItemDtoCopyWith<$Res> {
  factory _$$BookingItemDtoImplCopyWith(_$BookingItemDtoImpl value,
          $Res Function(_$BookingItemDtoImpl) then) =
      __$$BookingItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'ticket_type_id') String ticketTypeId,
      int quantity,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'total_price') double totalPrice,
      @JsonKey(name: 'ticket_type_name') String? ticketTypeName,
      String? currency});
}

/// @nodoc
class __$$BookingItemDtoImplCopyWithImpl<$Res>
    extends _$BookingItemDtoCopyWithImpl<$Res, _$BookingItemDtoImpl>
    implements _$$BookingItemDtoImplCopyWith<$Res> {
  __$$BookingItemDtoImplCopyWithImpl(
      _$BookingItemDtoImpl _value, $Res Function(_$BookingItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? ticketTypeId = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? ticketTypeName = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$BookingItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketTypeId: null == ticketTypeId
          ? _value.ticketTypeId
          : ticketTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      ticketTypeName: freezed == ticketTypeName
          ? _value.ticketTypeName
          : ticketTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingItemDtoImpl implements _BookingItemDto {
  const _$BookingItemDtoImpl(
      {required this.id,
      @JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'ticket_type_id') required this.ticketTypeId,
      required this.quantity,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      @JsonKey(name: 'total_price') required this.totalPrice,
      @JsonKey(name: 'ticket_type_name') this.ticketTypeName,
      this.currency});

  factory _$BookingItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingItemDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'ticket_type_id')
  final String ticketTypeId;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @override
  @JsonKey(name: 'ticket_type_name')
  final String? ticketTypeName;
  @override
  final String? currency;

  @override
  String toString() {
    return 'BookingItemDto(id: $id, bookingId: $bookingId, ticketTypeId: $ticketTypeId, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, ticketTypeName: $ticketTypeName, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.ticketTypeId, ticketTypeId) ||
                other.ticketTypeId == ticketTypeId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.ticketTypeName, ticketTypeName) ||
                other.ticketTypeName == ticketTypeName) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, ticketTypeId,
      quantity, unitPrice, totalPrice, ticketTypeName, currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingItemDtoImplCopyWith<_$BookingItemDtoImpl> get copyWith =>
      __$$BookingItemDtoImplCopyWithImpl<_$BookingItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingItemDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingItemDto implements BookingItemDto {
  const factory _BookingItemDto(
      {required final String id,
      @JsonKey(name: 'booking_id') required final String bookingId,
      @JsonKey(name: 'ticket_type_id') required final String ticketTypeId,
      required final int quantity,
      @JsonKey(name: 'unit_price') required final double unitPrice,
      @JsonKey(name: 'total_price') required final double totalPrice,
      @JsonKey(name: 'ticket_type_name') final String? ticketTypeName,
      final String? currency}) = _$BookingItemDtoImpl;

  factory _BookingItemDto.fromJson(Map<String, dynamic> json) =
      _$BookingItemDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  @JsonKey(name: 'ticket_type_id')
  String get ticketTypeId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @JsonKey(name: 'total_price')
  double get totalPrice;
  @override
  @JsonKey(name: 'ticket_type_name')
  String? get ticketTypeName;
  @override
  String? get currency;
  @override
  @JsonKey(ignore: true)
  _$$BookingItemDtoImplCopyWith<_$BookingItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

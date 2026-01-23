// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get slotId => throw _privateConstructorUsedError;
  String get activityId => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get status =>
      throw _privateConstructorUsedError; // pending, confirmed, cancelled, refunded, completed
  String? get paymentProvider => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Expanded fields for UI
  Activity? get activity => throw _privateConstructorUsedError;
  Slot? get slot =>
      throw _privateConstructorUsedError; // Tickets associated with this booking
  List<Ticket>? get tickets =>
      throw _privateConstructorUsedError; // Customer info
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get customerFirstName => throw _privateConstructorUsedError;
  String? get customerLastName => throw _privateConstructorUsedError;
  String? get customerPhone =>
      throw _privateConstructorUsedError; // Reference (short code for display)
  String? get reference => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String slotId,
      String activityId,
      int? quantity,
      double? totalPrice,
      String? currency,
      String? status,
      String? paymentProvider,
      String? paymentReference,
      DateTime? createdAt,
      Activity? activity,
      Slot? slot,
      List<Ticket>? tickets,
      String? customerEmail,
      String? customerFirstName,
      String? customerLastName,
      String? customerPhone,
      String? reference});

  $ActivityCopyWith<$Res>? get activity;
  $SlotCopyWith<$Res>? get slot;
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

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
              as String,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
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
              as Activity?,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as Slot?,
      tickets: freezed == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<Ticket>?,
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
  $ActivityCopyWith<$Res>? get activity {
    if (_value.activity == null) {
      return null;
    }

    return $ActivityCopyWith<$Res>(_value.activity!, (value) {
      return _then(_value.copyWith(activity: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SlotCopyWith<$Res>? get slot {
    if (_value.slot == null) {
      return null;
    }

    return $SlotCopyWith<$Res>(_value.slot!, (value) {
      return _then(_value.copyWith(slot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
          _$BookingImpl value, $Res Function(_$BookingImpl) then) =
      __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String slotId,
      String activityId,
      int? quantity,
      double? totalPrice,
      String? currency,
      String? status,
      String? paymentProvider,
      String? paymentReference,
      DateTime? createdAt,
      Activity? activity,
      Slot? slot,
      List<Ticket>? tickets,
      String? customerEmail,
      String? customerFirstName,
      String? customerLastName,
      String? customerPhone,
      String? reference});

  @override
  $ActivityCopyWith<$Res>? get activity;
  @override
  $SlotCopyWith<$Res>? get slot;
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
      _$BookingImpl _value, $Res Function(_$BookingImpl) _then)
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
    return _then(_$BookingImpl(
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
              as String,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
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
              as Activity?,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as Slot?,
      tickets: freezed == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<Ticket>?,
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

class _$BookingImpl implements _Booking {
  const _$BookingImpl(
      {required this.id,
      required this.userId,
      required this.slotId,
      required this.activityId,
      this.quantity,
      this.totalPrice,
      this.currency,
      this.status,
      this.paymentProvider,
      this.paymentReference,
      this.createdAt,
      this.activity,
      this.slot,
      final List<Ticket>? tickets,
      this.customerEmail,
      this.customerFirstName,
      this.customerLastName,
      this.customerPhone,
      this.reference})
      : _tickets = tickets;

  @override
  final String id;
  @override
  final String userId;
  @override
  final String slotId;
  @override
  final String activityId;
  @override
  final int? quantity;
  @override
  final double? totalPrice;
  @override
  final String? currency;
  @override
  final String? status;
// pending, confirmed, cancelled, refunded, completed
  @override
  final String? paymentProvider;
  @override
  final String? paymentReference;
  @override
  final DateTime? createdAt;
// Expanded fields for UI
  @override
  final Activity? activity;
  @override
  final Slot? slot;
// Tickets associated with this booking
  final List<Ticket>? _tickets;
// Tickets associated with this booking
  @override
  List<Ticket>? get tickets {
    final value = _tickets;
    if (value == null) return null;
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Customer info
  @override
  final String? customerEmail;
  @override
  final String? customerFirstName;
  @override
  final String? customerLastName;
  @override
  final String? customerPhone;
// Reference (short code for display)
  @override
  final String? reference;

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, slotId: $slotId, activityId: $activityId, quantity: $quantity, totalPrice: $totalPrice, currency: $currency, status: $status, paymentProvider: $paymentProvider, paymentReference: $paymentReference, createdAt: $createdAt, activity: $activity, slot: $slot, tickets: $tickets, customerEmail: $customerEmail, customerFirstName: $customerFirstName, customerLastName: $customerLastName, customerPhone: $customerPhone, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
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
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);
}

abstract class _Booking implements Booking {
  const factory _Booking(
      {required final String id,
      required final String userId,
      required final String slotId,
      required final String activityId,
      final int? quantity,
      final double? totalPrice,
      final String? currency,
      final String? status,
      final String? paymentProvider,
      final String? paymentReference,
      final DateTime? createdAt,
      final Activity? activity,
      final Slot? slot,
      final List<Ticket>? tickets,
      final String? customerEmail,
      final String? customerFirstName,
      final String? customerLastName,
      final String? customerPhone,
      final String? reference}) = _$BookingImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get slotId;
  @override
  String get activityId;
  @override
  int? get quantity;
  @override
  double? get totalPrice;
  @override
  String? get currency;
  @override
  String? get status;
  @override // pending, confirmed, cancelled, refunded, completed
  String? get paymentProvider;
  @override
  String? get paymentReference;
  @override
  DateTime? get createdAt;
  @override // Expanded fields for UI
  Activity? get activity;
  @override
  Slot? get slot;
  @override // Tickets associated with this booking
  List<Ticket>? get tickets;
  @override // Customer info
  String? get customerEmail;
  @override
  String? get customerFirstName;
  @override
  String? get customerLastName;
  @override
  String? get customerPhone;
  @override // Reference (short code for display)
  String? get reference;
  @override
  @JsonKey(ignore: true)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Ticket {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get slotId => throw _privateConstructorUsedError;
  String? get ticketType => throw _privateConstructorUsedError;
  String? get qrCodeData => throw _privateConstructorUsedError;
  String? get qrSecret => throw _privateConstructorUsedError;
  String? get status =>
      throw _privateConstructorUsedError; // active, used, cancelled, expired
// Attendee info
  String? get attendeeFirstName => throw _privateConstructorUsedError;
  String? get attendeeLastName => throw _privateConstructorUsedError;
  String? get attendeeEmail => throw _privateConstructorUsedError; // Pricing
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError; // Timestamps
  DateTime? get usedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketCopyWith<Ticket> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCopyWith<$Res> {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) then) =
      _$TicketCopyWithImpl<$Res, Ticket>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      String slotId,
      String? ticketType,
      String? qrCodeData,
      String? qrSecret,
      String? status,
      String? attendeeFirstName,
      String? attendeeLastName,
      String? attendeeEmail,
      double? price,
      String? currency,
      DateTime? usedAt,
      DateTime? createdAt});
}

/// @nodoc
class _$TicketCopyWithImpl<$Res, $Val extends Ticket>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? slotId = null,
    Object? ticketType = freezed,
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
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TicketImplCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$$TicketImplCopyWith(
          _$TicketImpl value, $Res Function(_$TicketImpl) then) =
      __$$TicketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      String slotId,
      String? ticketType,
      String? qrCodeData,
      String? qrSecret,
      String? status,
      String? attendeeFirstName,
      String? attendeeLastName,
      String? attendeeEmail,
      double? price,
      String? currency,
      DateTime? usedAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$TicketImplCopyWithImpl<$Res>
    extends _$TicketCopyWithImpl<$Res, _$TicketImpl>
    implements _$$TicketImplCopyWith<$Res> {
  __$$TicketImplCopyWithImpl(
      _$TicketImpl _value, $Res Function(_$TicketImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? slotId = null,
    Object? ticketType = freezed,
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
    return _then(_$TicketImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
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

class _$TicketImpl implements _Ticket {
  const _$TicketImpl(
      {required this.id,
      required this.bookingId,
      required this.userId,
      required this.slotId,
      this.ticketType,
      this.qrCodeData,
      this.qrSecret,
      this.status,
      this.attendeeFirstName,
      this.attendeeLastName,
      this.attendeeEmail,
      this.price,
      this.currency,
      this.usedAt,
      this.createdAt});

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String userId;
  @override
  final String slotId;
  @override
  final String? ticketType;
  @override
  final String? qrCodeData;
  @override
  final String? qrSecret;
  @override
  final String? status;
// active, used, cancelled, expired
// Attendee info
  @override
  final String? attendeeFirstName;
  @override
  final String? attendeeLastName;
  @override
  final String? attendeeEmail;
// Pricing
  @override
  final double? price;
  @override
  final String? currency;
// Timestamps
  @override
  final DateTime? usedAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Ticket(id: $id, bookingId: $bookingId, userId: $userId, slotId: $slotId, ticketType: $ticketType, qrCodeData: $qrCodeData, qrSecret: $qrSecret, status: $status, attendeeFirstName: $attendeeFirstName, attendeeLastName: $attendeeLastName, attendeeEmail: $attendeeEmail, price: $price, currency: $currency, usedAt: $usedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.ticketType, ticketType) ||
                other.ticketType == ticketType) &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      userId,
      slotId,
      ticketType,
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
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      __$$TicketImplCopyWithImpl<_$TicketImpl>(this, _$identity);
}

abstract class _Ticket implements Ticket {
  const factory _Ticket(
      {required final String id,
      required final String bookingId,
      required final String userId,
      required final String slotId,
      final String? ticketType,
      final String? qrCodeData,
      final String? qrSecret,
      final String? status,
      final String? attendeeFirstName,
      final String? attendeeLastName,
      final String? attendeeEmail,
      final double? price,
      final String? currency,
      final DateTime? usedAt,
      final DateTime? createdAt}) = _$TicketImpl;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get userId;
  @override
  String get slotId;
  @override
  String? get ticketType;
  @override
  String? get qrCodeData;
  @override
  String? get qrSecret;
  @override
  String? get status;
  @override // active, used, cancelled, expired
// Attendee info
  String? get attendeeFirstName;
  @override
  String? get attendeeLastName;
  @override
  String? get attendeeEmail;
  @override // Pricing
  double? get price;
  @override
  String? get currency;
  @override // Timestamps
  DateTime? get usedAt;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingItem {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get ticketTypeId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String? get ticketTypeName => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingItemCopyWith<BookingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingItemCopyWith<$Res> {
  factory $BookingItemCopyWith(
          BookingItem value, $Res Function(BookingItem) then) =
      _$BookingItemCopyWithImpl<$Res, BookingItem>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String ticketTypeId,
      int quantity,
      double unitPrice,
      double totalPrice,
      String? ticketTypeName,
      String? currency});
}

/// @nodoc
class _$BookingItemCopyWithImpl<$Res, $Val extends BookingItem>
    implements $BookingItemCopyWith<$Res> {
  _$BookingItemCopyWithImpl(this._value, this._then);

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
abstract class _$$BookingItemImplCopyWith<$Res>
    implements $BookingItemCopyWith<$Res> {
  factory _$$BookingItemImplCopyWith(
          _$BookingItemImpl value, $Res Function(_$BookingItemImpl) then) =
      __$$BookingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String ticketTypeId,
      int quantity,
      double unitPrice,
      double totalPrice,
      String? ticketTypeName,
      String? currency});
}

/// @nodoc
class __$$BookingItemImplCopyWithImpl<$Res>
    extends _$BookingItemCopyWithImpl<$Res, _$BookingItemImpl>
    implements _$$BookingItemImplCopyWith<$Res> {
  __$$BookingItemImplCopyWithImpl(
      _$BookingItemImpl _value, $Res Function(_$BookingItemImpl) _then)
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
    return _then(_$BookingItemImpl(
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

class _$BookingItemImpl implements _BookingItem {
  const _$BookingItemImpl(
      {required this.id,
      required this.bookingId,
      required this.ticketTypeId,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      this.ticketTypeName,
      this.currency});

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String ticketTypeId;
  @override
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double totalPrice;
  @override
  final String? ticketTypeName;
  @override
  final String? currency;

  @override
  String toString() {
    return 'BookingItem(id: $id, bookingId: $bookingId, ticketTypeId: $ticketTypeId, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, ticketTypeName: $ticketTypeName, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingItemImpl &&
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

  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, ticketTypeId,
      quantity, unitPrice, totalPrice, ticketTypeName, currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingItemImplCopyWith<_$BookingItemImpl> get copyWith =>
      __$$BookingItemImplCopyWithImpl<_$BookingItemImpl>(this, _$identity);
}

abstract class _BookingItem implements BookingItem {
  const factory _BookingItem(
      {required final String id,
      required final String bookingId,
      required final String ticketTypeId,
      required final int quantity,
      required final double unitPrice,
      required final double totalPrice,
      final String? ticketTypeName,
      final String? currency}) = _$BookingItemImpl;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get ticketTypeId;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get totalPrice;
  @override
  String? get ticketTypeName;
  @override
  String? get currency;
  @override
  @JsonKey(ignore: true)
  _$$BookingItemImplCopyWith<_$BookingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

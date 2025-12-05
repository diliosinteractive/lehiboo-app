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
      throw _privateConstructorUsedError; // pending, confirmed, cancelled, refunded
  String? get paymentProvider => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Expanded fields for UI
  Activity? get activity => throw _privateConstructorUsedError;
  Slot? get slot => throw _privateConstructorUsedError;

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
      Slot? slot});

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
      Slot? slot});

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
      this.slot});

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
// pending, confirmed, cancelled, refunded
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

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, slotId: $slotId, activityId: $activityId, quantity: $quantity, totalPrice: $totalPrice, currency: $currency, status: $status, paymentProvider: $paymentProvider, paymentReference: $paymentReference, createdAt: $createdAt, activity: $activity, slot: $slot)';
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
            (identical(other.slot, slot) || other.slot == slot));
  }

  @override
  int get hashCode => Object.hash(
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
      slot);

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
      final Slot? slot}) = _$BookingImpl;

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
  @override // pending, confirmed, cancelled, refunded
  String? get paymentProvider;
  @override
  String? get paymentReference;
  @override
  DateTime? get createdAt;
  @override // Expanded fields for UI
  Activity? get activity;
  @override
  Slot? get slot;
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
  String? get status => throw _privateConstructorUsedError;

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
      String? status});
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
    Object? status = freezed,
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
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
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
      String? status});
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
    Object? status = freezed,
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
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
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
      this.status});

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
  final String? status;

  @override
  String toString() {
    return 'Ticket(id: $id, bookingId: $bookingId, userId: $userId, slotId: $slotId, ticketType: $ticketType, qrCodeData: $qrCodeData, status: $status)';
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
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, userId, slotId,
      ticketType, qrCodeData, status);

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
      final String? status}) = _$TicketImpl;

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
  String? get status;
  @override
  @JsonKey(ignore: true)
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

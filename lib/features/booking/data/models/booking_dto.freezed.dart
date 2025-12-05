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
      SlotDto? slot});

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
      SlotDto? slot});

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
      this.slot});

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

  @override
  String toString() {
    return 'BookingDto(id: $id, userId: $userId, slotId: $slotId, activityId: $activityId, quantity: $quantity, totalPrice: $totalPrice, currency: $currency, status: $status, paymentProvider: $paymentProvider, paymentReference: $paymentReference, createdAt: $createdAt, activity: $activity, slot: $slot)';
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
            (identical(other.slot, slot) || other.slot == slot));
  }

  @JsonKey(ignore: true)
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
      final SlotDto? slot}) = _$BookingDtoImpl;

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
  @JsonKey(ignore: true)
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketDto _$TicketDtoFromJson(Map<String, dynamic> json) {
  return _TicketDto.fromJson(json);
}

/// @nodoc
mixin _$TicketDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  int get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_id')
  int get slotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_type')
  String? get ticketType => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code_data')
  String? get qrCodeData => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

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
      {int id,
      @JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'slot_id') int slotId,
      @JsonKey(name: 'ticket_type') String? ticketType,
      @JsonKey(name: 'qr_code_data') String? qrCodeData,
      String? status});
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
              as int,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$TicketDtoImplCopyWith<$Res>
    implements $TicketDtoCopyWith<$Res> {
  factory _$$TicketDtoImplCopyWith(
          _$TicketDtoImpl value, $Res Function(_$TicketDtoImpl) then) =
      __$$TicketDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'booking_id') int bookingId,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'slot_id') int slotId,
      @JsonKey(name: 'ticket_type') String? ticketType,
      @JsonKey(name: 'qr_code_data') String? qrCodeData,
      String? status});
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
    Object? bookingId = null,
    Object? userId = null,
    Object? slotId = null,
    Object? ticketType = freezed,
    Object? qrCodeData = freezed,
    Object? status = freezed,
  }) {
    return _then(_$TicketDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as int,
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
@JsonSerializable()
class _$TicketDtoImpl implements _TicketDto {
  const _$TicketDtoImpl(
      {required this.id,
      @JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'slot_id') required this.slotId,
      @JsonKey(name: 'ticket_type') this.ticketType,
      @JsonKey(name: 'qr_code_data') this.qrCodeData,
      this.status});

  factory _$TicketDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'booking_id')
  final int bookingId;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'slot_id')
  final int slotId;
  @override
  @JsonKey(name: 'ticket_type')
  final String? ticketType;
  @override
  @JsonKey(name: 'qr_code_data')
  final String? qrCodeData;
  @override
  final String? status;

  @override
  String toString() {
    return 'TicketDto(id: $id, bookingId: $bookingId, userId: $userId, slotId: $slotId, ticketType: $ticketType, qrCodeData: $qrCodeData, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketDtoImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, userId, slotId,
      ticketType, qrCodeData, status);

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
      {required final int id,
      @JsonKey(name: 'booking_id') required final int bookingId,
      @JsonKey(name: 'user_id') required final int userId,
      @JsonKey(name: 'slot_id') required final int slotId,
      @JsonKey(name: 'ticket_type') final String? ticketType,
      @JsonKey(name: 'qr_code_data') final String? qrCodeData,
      final String? status}) = _$TicketDtoImpl;

  factory _TicketDto.fromJson(Map<String, dynamic> json) =
      _$TicketDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'booking_id')
  int get bookingId;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'slot_id')
  int get slotId;
  @override
  @JsonKey(name: 'ticket_type')
  String? get ticketType;
  @override
  @JsonKey(name: 'qr_code_data')
  String? get qrCodeData;
  @override
  String? get status;
  @override
  @JsonKey(ignore: true)
  _$$TicketDtoImplCopyWith<_$TicketDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

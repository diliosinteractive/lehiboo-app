// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookingStep {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() selectSlot,
    required TResult Function() participants,
    required TResult Function() payment,
    required TResult Function() confirmation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? selectSlot,
    TResult? Function()? participants,
    TResult? Function()? payment,
    TResult? Function()? confirmation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? selectSlot,
    TResult Function()? participants,
    TResult Function()? payment,
    TResult Function()? confirmation,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectSlot value) selectSlot,
    required TResult Function(_Participants value) participants,
    required TResult Function(_Payment value) payment,
    required TResult Function(_Confirmation value) confirmation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectSlot value)? selectSlot,
    TResult? Function(_Participants value)? participants,
    TResult? Function(_Payment value)? payment,
    TResult? Function(_Confirmation value)? confirmation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectSlot value)? selectSlot,
    TResult Function(_Participants value)? participants,
    TResult Function(_Payment value)? payment,
    TResult Function(_Confirmation value)? confirmation,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingStepCopyWith<$Res> {
  factory $BookingStepCopyWith(
          BookingStep value, $Res Function(BookingStep) then) =
      _$BookingStepCopyWithImpl<$Res, BookingStep>;
}

/// @nodoc
class _$BookingStepCopyWithImpl<$Res, $Val extends BookingStep>
    implements $BookingStepCopyWith<$Res> {
  _$BookingStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SelectSlotImplCopyWith<$Res> {
  factory _$$SelectSlotImplCopyWith(
          _$SelectSlotImpl value, $Res Function(_$SelectSlotImpl) then) =
      __$$SelectSlotImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SelectSlotImplCopyWithImpl<$Res>
    extends _$BookingStepCopyWithImpl<$Res, _$SelectSlotImpl>
    implements _$$SelectSlotImplCopyWith<$Res> {
  __$$SelectSlotImplCopyWithImpl(
      _$SelectSlotImpl _value, $Res Function(_$SelectSlotImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SelectSlotImpl implements _SelectSlot {
  const _$SelectSlotImpl();

  @override
  String toString() {
    return 'BookingStep.selectSlot()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SelectSlotImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() selectSlot,
    required TResult Function() participants,
    required TResult Function() payment,
    required TResult Function() confirmation,
  }) {
    return selectSlot();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? selectSlot,
    TResult? Function()? participants,
    TResult? Function()? payment,
    TResult? Function()? confirmation,
  }) {
    return selectSlot?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? selectSlot,
    TResult Function()? participants,
    TResult Function()? payment,
    TResult Function()? confirmation,
    required TResult orElse(),
  }) {
    if (selectSlot != null) {
      return selectSlot();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectSlot value) selectSlot,
    required TResult Function(_Participants value) participants,
    required TResult Function(_Payment value) payment,
    required TResult Function(_Confirmation value) confirmation,
  }) {
    return selectSlot(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectSlot value)? selectSlot,
    TResult? Function(_Participants value)? participants,
    TResult? Function(_Payment value)? payment,
    TResult? Function(_Confirmation value)? confirmation,
  }) {
    return selectSlot?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectSlot value)? selectSlot,
    TResult Function(_Participants value)? participants,
    TResult Function(_Payment value)? payment,
    TResult Function(_Confirmation value)? confirmation,
    required TResult orElse(),
  }) {
    if (selectSlot != null) {
      return selectSlot(this);
    }
    return orElse();
  }
}

abstract class _SelectSlot implements BookingStep {
  const factory _SelectSlot() = _$SelectSlotImpl;
}

/// @nodoc
abstract class _$$ParticipantsImplCopyWith<$Res> {
  factory _$$ParticipantsImplCopyWith(
          _$ParticipantsImpl value, $Res Function(_$ParticipantsImpl) then) =
      __$$ParticipantsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ParticipantsImplCopyWithImpl<$Res>
    extends _$BookingStepCopyWithImpl<$Res, _$ParticipantsImpl>
    implements _$$ParticipantsImplCopyWith<$Res> {
  __$$ParticipantsImplCopyWithImpl(
      _$ParticipantsImpl _value, $Res Function(_$ParticipantsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ParticipantsImpl implements _Participants {
  const _$ParticipantsImpl();

  @override
  String toString() {
    return 'BookingStep.participants()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ParticipantsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() selectSlot,
    required TResult Function() participants,
    required TResult Function() payment,
    required TResult Function() confirmation,
  }) {
    return participants();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? selectSlot,
    TResult? Function()? participants,
    TResult? Function()? payment,
    TResult? Function()? confirmation,
  }) {
    return participants?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? selectSlot,
    TResult Function()? participants,
    TResult Function()? payment,
    TResult Function()? confirmation,
    required TResult orElse(),
  }) {
    if (participants != null) {
      return participants();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectSlot value) selectSlot,
    required TResult Function(_Participants value) participants,
    required TResult Function(_Payment value) payment,
    required TResult Function(_Confirmation value) confirmation,
  }) {
    return participants(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectSlot value)? selectSlot,
    TResult? Function(_Participants value)? participants,
    TResult? Function(_Payment value)? payment,
    TResult? Function(_Confirmation value)? confirmation,
  }) {
    return participants?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectSlot value)? selectSlot,
    TResult Function(_Participants value)? participants,
    TResult Function(_Payment value)? payment,
    TResult Function(_Confirmation value)? confirmation,
    required TResult orElse(),
  }) {
    if (participants != null) {
      return participants(this);
    }
    return orElse();
  }
}

abstract class _Participants implements BookingStep {
  const factory _Participants() = _$ParticipantsImpl;
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
          _$PaymentImpl value, $Res Function(_$PaymentImpl) then) =
      __$$PaymentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$BookingStepCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
      _$PaymentImpl _value, $Res Function(_$PaymentImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PaymentImpl implements _Payment {
  const _$PaymentImpl();

  @override
  String toString() {
    return 'BookingStep.payment()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() selectSlot,
    required TResult Function() participants,
    required TResult Function() payment,
    required TResult Function() confirmation,
  }) {
    return payment();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? selectSlot,
    TResult? Function()? participants,
    TResult? Function()? payment,
    TResult? Function()? confirmation,
  }) {
    return payment?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? selectSlot,
    TResult Function()? participants,
    TResult Function()? payment,
    TResult Function()? confirmation,
    required TResult orElse(),
  }) {
    if (payment != null) {
      return payment();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectSlot value) selectSlot,
    required TResult Function(_Participants value) participants,
    required TResult Function(_Payment value) payment,
    required TResult Function(_Confirmation value) confirmation,
  }) {
    return payment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectSlot value)? selectSlot,
    TResult? Function(_Participants value)? participants,
    TResult? Function(_Payment value)? payment,
    TResult? Function(_Confirmation value)? confirmation,
  }) {
    return payment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectSlot value)? selectSlot,
    TResult Function(_Participants value)? participants,
    TResult Function(_Payment value)? payment,
    TResult Function(_Confirmation value)? confirmation,
    required TResult orElse(),
  }) {
    if (payment != null) {
      return payment(this);
    }
    return orElse();
  }
}

abstract class _Payment implements BookingStep {
  const factory _Payment() = _$PaymentImpl;
}

/// @nodoc
abstract class _$$ConfirmationImplCopyWith<$Res> {
  factory _$$ConfirmationImplCopyWith(
          _$ConfirmationImpl value, $Res Function(_$ConfirmationImpl) then) =
      __$$ConfirmationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConfirmationImplCopyWithImpl<$Res>
    extends _$BookingStepCopyWithImpl<$Res, _$ConfirmationImpl>
    implements _$$ConfirmationImplCopyWith<$Res> {
  __$$ConfirmationImplCopyWithImpl(
      _$ConfirmationImpl _value, $Res Function(_$ConfirmationImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ConfirmationImpl implements _Confirmation {
  const _$ConfirmationImpl();

  @override
  String toString() {
    return 'BookingStep.confirmation()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ConfirmationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() selectSlot,
    required TResult Function() participants,
    required TResult Function() payment,
    required TResult Function() confirmation,
  }) {
    return confirmation();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? selectSlot,
    TResult? Function()? participants,
    TResult? Function()? payment,
    TResult? Function()? confirmation,
  }) {
    return confirmation?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? selectSlot,
    TResult Function()? participants,
    TResult Function()? payment,
    TResult Function()? confirmation,
    required TResult orElse(),
  }) {
    if (confirmation != null) {
      return confirmation();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectSlot value) selectSlot,
    required TResult Function(_Participants value) participants,
    required TResult Function(_Payment value) payment,
    required TResult Function(_Confirmation value) confirmation,
  }) {
    return confirmation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectSlot value)? selectSlot,
    TResult? Function(_Participants value)? participants,
    TResult? Function(_Payment value)? payment,
    TResult? Function(_Confirmation value)? confirmation,
  }) {
    return confirmation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectSlot value)? selectSlot,
    TResult Function(_Participants value)? participants,
    TResult Function(_Payment value)? payment,
    TResult Function(_Confirmation value)? confirmation,
    required TResult orElse(),
  }) {
    if (confirmation != null) {
      return confirmation(this);
    }
    return orElse();
  }
}

abstract class _Confirmation implements BookingStep {
  const factory _Confirmation() = _$ConfirmationImpl;
}

/// @nodoc
mixin _$ParticipantInfo {
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ParticipantInfoCopyWith<ParticipantInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantInfoCopyWith<$Res> {
  factory $ParticipantInfoCopyWith(
          ParticipantInfo value, $Res Function(ParticipantInfo) then) =
      _$ParticipantInfoCopyWithImpl<$Res, ParticipantInfo>;
  @useResult
  $Res call({String? firstName, String? lastName});
}

/// @nodoc
class _$ParticipantInfoCopyWithImpl<$Res, $Val extends ParticipantInfo>
    implements $ParticipantInfoCopyWith<$Res> {
  _$ParticipantInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipantInfoImplCopyWith<$Res>
    implements $ParticipantInfoCopyWith<$Res> {
  factory _$$ParticipantInfoImplCopyWith(_$ParticipantInfoImpl value,
          $Res Function(_$ParticipantInfoImpl) then) =
      __$$ParticipantInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? firstName, String? lastName});
}

/// @nodoc
class __$$ParticipantInfoImplCopyWithImpl<$Res>
    extends _$ParticipantInfoCopyWithImpl<$Res, _$ParticipantInfoImpl>
    implements _$$ParticipantInfoImplCopyWith<$Res> {
  __$$ParticipantInfoImplCopyWithImpl(
      _$ParticipantInfoImpl _value, $Res Function(_$ParticipantInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
  }) {
    return _then(_$ParticipantInfoImpl(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ParticipantInfoImpl implements _ParticipantInfo {
  const _$ParticipantInfoImpl({this.firstName, this.lastName});

  @override
  final String? firstName;
  @override
  final String? lastName;

  @override
  String toString() {
    return 'ParticipantInfo(firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantInfoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantInfoImplCopyWith<_$ParticipantInfoImpl> get copyWith =>
      __$$ParticipantInfoImplCopyWithImpl<_$ParticipantInfoImpl>(
          this, _$identity);
}

abstract class _ParticipantInfo implements ParticipantInfo {
  const factory _ParticipantInfo(
      {final String? firstName,
      final String? lastName}) = _$ParticipantInfoImpl;

  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  @JsonKey(ignore: true)
  _$$ParticipantInfoImplCopyWith<_$ParticipantInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BuyerInfo {
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BuyerInfoCopyWith<BuyerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerInfoCopyWith<$Res> {
  factory $BuyerInfoCopyWith(BuyerInfo value, $Res Function(BuyerInfo) then) =
      _$BuyerInfoCopyWithImpl<$Res, BuyerInfo>;
  @useResult
  $Res call(
      {String? firstName, String? lastName, String? email, String? phone});
}

/// @nodoc
class _$BuyerInfoCopyWithImpl<$Res, $Val extends BuyerInfo>
    implements $BuyerInfoCopyWith<$Res> {
  _$BuyerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuyerInfoImplCopyWith<$Res>
    implements $BuyerInfoCopyWith<$Res> {
  factory _$$BuyerInfoImplCopyWith(
          _$BuyerInfoImpl value, $Res Function(_$BuyerInfoImpl) then) =
      __$$BuyerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? firstName, String? lastName, String? email, String? phone});
}

/// @nodoc
class __$$BuyerInfoImplCopyWithImpl<$Res>
    extends _$BuyerInfoCopyWithImpl<$Res, _$BuyerInfoImpl>
    implements _$$BuyerInfoImplCopyWith<$Res> {
  __$$BuyerInfoImplCopyWithImpl(
      _$BuyerInfoImpl _value, $Res Function(_$BuyerInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(_$BuyerInfoImpl(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BuyerInfoImpl implements _BuyerInfo {
  const _$BuyerInfoImpl(
      {this.firstName, this.lastName, this.email, this.phone});

  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? phone;

  @override
  String toString() {
    return 'BuyerInfo(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyerInfoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, email, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyerInfoImplCopyWith<_$BuyerInfoImpl> get copyWith =>
      __$$BuyerInfoImplCopyWithImpl<_$BuyerInfoImpl>(this, _$identity);
}

abstract class _BuyerInfo implements BuyerInfo {
  const factory _BuyerInfo(
      {final String? firstName,
      final String? lastName,
      final String? email,
      final String? phone}) = _$BuyerInfoImpl;

  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  @JsonKey(ignore: true)
  _$$BuyerInfoImplCopyWith<_$BuyerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingFlowState {
  BookingStep get step => throw _privateConstructorUsedError;
  Activity get activity => throw _privateConstructorUsedError;
  Slot? get selectedSlot => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  BuyerInfo? get buyerInfo => throw _privateConstructorUsedError;
  List<ParticipantInfo>? get participants => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  bool get isFree => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Booking? get confirmedBooking => throw _privateConstructorUsedError;
  List<Ticket>? get tickets => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingFlowStateCopyWith<BookingFlowState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingFlowStateCopyWith<$Res> {
  factory $BookingFlowStateCopyWith(
          BookingFlowState value, $Res Function(BookingFlowState) then) =
      _$BookingFlowStateCopyWithImpl<$Res, BookingFlowState>;
  @useResult
  $Res call(
      {BookingStep step,
      Activity activity,
      Slot? selectedSlot,
      int quantity,
      BuyerInfo? buyerInfo,
      List<ParticipantInfo>? participants,
      double? totalPrice,
      String? currency,
      bool isFree,
      bool isSubmitting,
      String? errorMessage,
      Booking? confirmedBooking,
      List<Ticket>? tickets});

  $BookingStepCopyWith<$Res> get step;
  $ActivityCopyWith<$Res> get activity;
  $SlotCopyWith<$Res>? get selectedSlot;
  $BuyerInfoCopyWith<$Res>? get buyerInfo;
  $BookingCopyWith<$Res>? get confirmedBooking;
}

/// @nodoc
class _$BookingFlowStateCopyWithImpl<$Res, $Val extends BookingFlowState>
    implements $BookingFlowStateCopyWith<$Res> {
  _$BookingFlowStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? activity = null,
    Object? selectedSlot = freezed,
    Object? quantity = null,
    Object? buyerInfo = freezed,
    Object? participants = freezed,
    Object? totalPrice = freezed,
    Object? currency = freezed,
    Object? isFree = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? confirmedBooking = freezed,
    Object? tickets = freezed,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as BookingStep,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as Activity,
      selectedSlot: freezed == selectedSlot
          ? _value.selectedSlot
          : selectedSlot // ignore: cast_nullable_to_non_nullable
              as Slot?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      buyerInfo: freezed == buyerInfo
          ? _value.buyerInfo
          : buyerInfo // ignore: cast_nullable_to_non_nullable
              as BuyerInfo?,
      participants: freezed == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ParticipantInfo>?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedBooking: freezed == confirmedBooking
          ? _value.confirmedBooking
          : confirmedBooking // ignore: cast_nullable_to_non_nullable
              as Booking?,
      tickets: freezed == tickets
          ? _value.tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<Ticket>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingStepCopyWith<$Res> get step {
    return $BookingStepCopyWith<$Res>(_value.step, (value) {
      return _then(_value.copyWith(step: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityCopyWith<$Res> get activity {
    return $ActivityCopyWith<$Res>(_value.activity, (value) {
      return _then(_value.copyWith(activity: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SlotCopyWith<$Res>? get selectedSlot {
    if (_value.selectedSlot == null) {
      return null;
    }

    return $SlotCopyWith<$Res>(_value.selectedSlot!, (value) {
      return _then(_value.copyWith(selectedSlot: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BuyerInfoCopyWith<$Res>? get buyerInfo {
    if (_value.buyerInfo == null) {
      return null;
    }

    return $BuyerInfoCopyWith<$Res>(_value.buyerInfo!, (value) {
      return _then(_value.copyWith(buyerInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingCopyWith<$Res>? get confirmedBooking {
    if (_value.confirmedBooking == null) {
      return null;
    }

    return $BookingCopyWith<$Res>(_value.confirmedBooking!, (value) {
      return _then(_value.copyWith(confirmedBooking: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingFlowStateImplCopyWith<$Res>
    implements $BookingFlowStateCopyWith<$Res> {
  factory _$$BookingFlowStateImplCopyWith(_$BookingFlowStateImpl value,
          $Res Function(_$BookingFlowStateImpl) then) =
      __$$BookingFlowStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BookingStep step,
      Activity activity,
      Slot? selectedSlot,
      int quantity,
      BuyerInfo? buyerInfo,
      List<ParticipantInfo>? participants,
      double? totalPrice,
      String? currency,
      bool isFree,
      bool isSubmitting,
      String? errorMessage,
      Booking? confirmedBooking,
      List<Ticket>? tickets});

  @override
  $BookingStepCopyWith<$Res> get step;
  @override
  $ActivityCopyWith<$Res> get activity;
  @override
  $SlotCopyWith<$Res>? get selectedSlot;
  @override
  $BuyerInfoCopyWith<$Res>? get buyerInfo;
  @override
  $BookingCopyWith<$Res>? get confirmedBooking;
}

/// @nodoc
class __$$BookingFlowStateImplCopyWithImpl<$Res>
    extends _$BookingFlowStateCopyWithImpl<$Res, _$BookingFlowStateImpl>
    implements _$$BookingFlowStateImplCopyWith<$Res> {
  __$$BookingFlowStateImplCopyWithImpl(_$BookingFlowStateImpl _value,
      $Res Function(_$BookingFlowStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? activity = null,
    Object? selectedSlot = freezed,
    Object? quantity = null,
    Object? buyerInfo = freezed,
    Object? participants = freezed,
    Object? totalPrice = freezed,
    Object? currency = freezed,
    Object? isFree = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? confirmedBooking = freezed,
    Object? tickets = freezed,
  }) {
    return _then(_$BookingFlowStateImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as BookingStep,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as Activity,
      selectedSlot: freezed == selectedSlot
          ? _value.selectedSlot
          : selectedSlot // ignore: cast_nullable_to_non_nullable
              as Slot?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      buyerInfo: freezed == buyerInfo
          ? _value.buyerInfo
          : buyerInfo // ignore: cast_nullable_to_non_nullable
              as BuyerInfo?,
      participants: freezed == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ParticipantInfo>?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedBooking: freezed == confirmedBooking
          ? _value.confirmedBooking
          : confirmedBooking // ignore: cast_nullable_to_non_nullable
              as Booking?,
      tickets: freezed == tickets
          ? _value._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<Ticket>?,
    ));
  }
}

/// @nodoc

class _$BookingFlowStateImpl implements _BookingFlowState {
  const _$BookingFlowStateImpl(
      {required this.step,
      required this.activity,
      this.selectedSlot,
      this.quantity = 1,
      this.buyerInfo,
      final List<ParticipantInfo>? participants,
      this.totalPrice,
      this.currency,
      this.isFree = false,
      this.isSubmitting = false,
      this.errorMessage,
      this.confirmedBooking,
      final List<Ticket>? tickets})
      : _participants = participants,
        _tickets = tickets;

  @override
  final BookingStep step;
  @override
  final Activity activity;
  @override
  final Slot? selectedSlot;
  @override
  @JsonKey()
  final int quantity;
  @override
  final BuyerInfo? buyerInfo;
  final List<ParticipantInfo>? _participants;
  @override
  List<ParticipantInfo>? get participants {
    final value = _participants;
    if (value == null) return null;
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? totalPrice;
  @override
  final String? currency;
  @override
  @JsonKey()
  final bool isFree;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;
  @override
  final Booking? confirmedBooking;
  final List<Ticket>? _tickets;
  @override
  List<Ticket>? get tickets {
    final value = _tickets;
    if (value == null) return null;
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BookingFlowState(step: $step, activity: $activity, selectedSlot: $selectedSlot, quantity: $quantity, buyerInfo: $buyerInfo, participants: $participants, totalPrice: $totalPrice, currency: $currency, isFree: $isFree, isSubmitting: $isSubmitting, errorMessage: $errorMessage, confirmedBooking: $confirmedBooking, tickets: $tickets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingFlowStateImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.selectedSlot, selectedSlot) ||
                other.selectedSlot == selectedSlot) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.buyerInfo, buyerInfo) ||
                other.buyerInfo == buyerInfo) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.confirmedBooking, confirmedBooking) ||
                other.confirmedBooking == confirmedBooking) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      step,
      activity,
      selectedSlot,
      quantity,
      buyerInfo,
      const DeepCollectionEquality().hash(_participants),
      totalPrice,
      currency,
      isFree,
      isSubmitting,
      errorMessage,
      confirmedBooking,
      const DeepCollectionEquality().hash(_tickets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingFlowStateImplCopyWith<_$BookingFlowStateImpl> get copyWith =>
      __$$BookingFlowStateImplCopyWithImpl<_$BookingFlowStateImpl>(
          this, _$identity);
}

abstract class _BookingFlowState implements BookingFlowState {
  const factory _BookingFlowState(
      {required final BookingStep step,
      required final Activity activity,
      final Slot? selectedSlot,
      final int quantity,
      final BuyerInfo? buyerInfo,
      final List<ParticipantInfo>? participants,
      final double? totalPrice,
      final String? currency,
      final bool isFree,
      final bool isSubmitting,
      final String? errorMessage,
      final Booking? confirmedBooking,
      final List<Ticket>? tickets}) = _$BookingFlowStateImpl;

  @override
  BookingStep get step;
  @override
  Activity get activity;
  @override
  Slot? get selectedSlot;
  @override
  int get quantity;
  @override
  BuyerInfo? get buyerInfo;
  @override
  List<ParticipantInfo>? get participants;
  @override
  double? get totalPrice;
  @override
  String? get currency;
  @override
  bool get isFree;
  @override
  bool get isSubmitting;
  @override
  String? get errorMessage;
  @override
  Booking? get confirmedBooking;
  @override
  List<Ticket>? get tickets;
  @override
  @JsonKey(ignore: true)
  _$$BookingFlowStateImplCopyWith<_$BookingFlowStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

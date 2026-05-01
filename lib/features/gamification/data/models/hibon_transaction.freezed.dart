// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hibon_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HibonTransaction _$HibonTransactionFromJson(Map<String, dynamic> json) {
  return _HibonTransaction.fromJson(json);
}

/// @nodoc
mixin _$HibonTransaction {
  String get id => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get pillar => throw _privateConstructorUsedError;
  int? get balanceAfter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HibonTransactionCopyWith<HibonTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HibonTransactionCopyWith<$Res> {
  factory $HibonTransactionCopyWith(
          HibonTransaction value, $Res Function(HibonTransaction) then) =
      _$HibonTransactionCopyWithImpl<$Res, HibonTransaction>;
  @useResult
  $Res call(
      {String id,
      TransactionType type,
      int amount,
      String description,
      DateTime timestamp,
      String? source,
      String? pillar,
      int? balanceAfter});
}

/// @nodoc
class _$HibonTransactionCopyWithImpl<$Res, $Val extends HibonTransaction>
    implements $HibonTransactionCopyWith<$Res> {
  _$HibonTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? timestamp = null,
    Object? source = freezed,
    Object? pillar = freezed,
    Object? balanceAfter = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      pillar: freezed == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceAfter: freezed == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HibonTransactionImplCopyWith<$Res>
    implements $HibonTransactionCopyWith<$Res> {
  factory _$$HibonTransactionImplCopyWith(_$HibonTransactionImpl value,
          $Res Function(_$HibonTransactionImpl) then) =
      __$$HibonTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      TransactionType type,
      int amount,
      String description,
      DateTime timestamp,
      String? source,
      String? pillar,
      int? balanceAfter});
}

/// @nodoc
class __$$HibonTransactionImplCopyWithImpl<$Res>
    extends _$HibonTransactionCopyWithImpl<$Res, _$HibonTransactionImpl>
    implements _$$HibonTransactionImplCopyWith<$Res> {
  __$$HibonTransactionImplCopyWithImpl(_$HibonTransactionImpl _value,
      $Res Function(_$HibonTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? timestamp = null,
    Object? source = freezed,
    Object? pillar = freezed,
    Object? balanceAfter = freezed,
  }) {
    return _then(_$HibonTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      pillar: freezed == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceAfter: freezed == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HibonTransactionImpl implements _HibonTransaction {
  const _$HibonTransactionImpl(
      {required this.id,
      required this.type,
      required this.amount,
      required this.description,
      required this.timestamp,
      this.source,
      this.pillar,
      this.balanceAfter});

  factory _$HibonTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$HibonTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final TransactionType type;
  @override
  final int amount;
  @override
  final String description;
  @override
  final DateTime timestamp;
  @override
  final String? source;
  @override
  final String? pillar;
  @override
  final int? balanceAfter;

  @override
  String toString() {
    return 'HibonTransaction(id: $id, type: $type, amount: $amount, description: $description, timestamp: $timestamp, source: $source, pillar: $pillar, balanceAfter: $balanceAfter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HibonTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.pillar, pillar) || other.pillar == pillar) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, amount, description,
      timestamp, source, pillar, balanceAfter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HibonTransactionImplCopyWith<_$HibonTransactionImpl> get copyWith =>
      __$$HibonTransactionImplCopyWithImpl<_$HibonTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HibonTransactionImplToJson(
      this,
    );
  }
}

abstract class _HibonTransaction implements HibonTransaction {
  const factory _HibonTransaction(
      {required final String id,
      required final TransactionType type,
      required final int amount,
      required final String description,
      required final DateTime timestamp,
      final String? source,
      final String? pillar,
      final int? balanceAfter}) = _$HibonTransactionImpl;

  factory _HibonTransaction.fromJson(Map<String, dynamic> json) =
      _$HibonTransactionImpl.fromJson;

  @override
  String get id;
  @override
  TransactionType get type;
  @override
  int get amount;
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  String? get source;
  @override
  String? get pillar;
  @override
  int? get balanceAfter;
  @override
  @JsonKey(ignore: true)
  _$$HibonTransactionImplCopyWith<_$HibonTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

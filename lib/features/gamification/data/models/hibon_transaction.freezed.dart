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

/// @nodoc
mixin _$HibonTransaction {
  String get id => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  String? get typeLabel => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String? get formattedAmount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get pillar => throw _privateConstructorUsedError;
  String? get pillarLabel => throw _privateConstructorUsedError;
  String? get pillarColor => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  TransactionContext? get context => throw _privateConstructorUsedError;
  int? get balanceAfter => throw _privateConstructorUsedError;

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
      String? typeLabel,
      int amount,
      String? formattedAmount,
      String description,
      DateTime timestamp,
      String? source,
      String? pillar,
      String? pillarLabel,
      String? pillarColor,
      String? title,
      String? subtitle,
      TransactionContext? context,
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
    Object? typeLabel = freezed,
    Object? amount = null,
    Object? formattedAmount = freezed,
    Object? description = null,
    Object? timestamp = null,
    Object? source = freezed,
    Object? pillar = freezed,
    Object? pillarLabel = freezed,
    Object? pillarColor = freezed,
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? context = freezed,
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
      typeLabel: freezed == typeLabel
          ? _value.typeLabel
          : typeLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      formattedAmount: freezed == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String?,
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
      pillarLabel: freezed == pillarLabel
          ? _value.pillarLabel
          : pillarLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      pillarColor: freezed == pillarColor
          ? _value.pillarColor
          : pillarColor // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as TransactionContext?,
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
      String? typeLabel,
      int amount,
      String? formattedAmount,
      String description,
      DateTime timestamp,
      String? source,
      String? pillar,
      String? pillarLabel,
      String? pillarColor,
      String? title,
      String? subtitle,
      TransactionContext? context,
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
    Object? typeLabel = freezed,
    Object? amount = null,
    Object? formattedAmount = freezed,
    Object? description = null,
    Object? timestamp = null,
    Object? source = freezed,
    Object? pillar = freezed,
    Object? pillarLabel = freezed,
    Object? pillarColor = freezed,
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? context = freezed,
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
      typeLabel: freezed == typeLabel
          ? _value.typeLabel
          : typeLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      formattedAmount: freezed == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String?,
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
      pillarLabel: freezed == pillarLabel
          ? _value.pillarLabel
          : pillarLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      pillarColor: freezed == pillarColor
          ? _value.pillarColor
          : pillarColor // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as TransactionContext?,
      balanceAfter: freezed == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$HibonTransactionImpl implements _HibonTransaction {
  const _$HibonTransactionImpl(
      {required this.id,
      required this.type,
      this.typeLabel,
      required this.amount,
      this.formattedAmount,
      required this.description,
      required this.timestamp,
      this.source,
      this.pillar,
      this.pillarLabel,
      this.pillarColor,
      this.title,
      this.subtitle,
      this.context = null,
      this.balanceAfter});

  @override
  final String id;
  @override
  final TransactionType type;
  @override
  final String? typeLabel;
  @override
  final int amount;
  @override
  final String? formattedAmount;
  @override
  final String description;
  @override
  final DateTime timestamp;
  @override
  final String? source;
  @override
  final String? pillar;
  @override
  final String? pillarLabel;
  @override
  final String? pillarColor;
  @override
  final String? title;
  @override
  final String? subtitle;
  @override
  @JsonKey()
  final TransactionContext? context;
  @override
  final int? balanceAfter;

  @override
  String toString() {
    return 'HibonTransaction(id: $id, type: $type, typeLabel: $typeLabel, amount: $amount, formattedAmount: $formattedAmount, description: $description, timestamp: $timestamp, source: $source, pillar: $pillar, pillarLabel: $pillarLabel, pillarColor: $pillarColor, title: $title, subtitle: $subtitle, context: $context, balanceAfter: $balanceAfter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HibonTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.typeLabel, typeLabel) ||
                other.typeLabel == typeLabel) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.formattedAmount, formattedAmount) ||
                other.formattedAmount == formattedAmount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.pillar, pillar) || other.pillar == pillar) &&
            (identical(other.pillarLabel, pillarLabel) ||
                other.pillarLabel == pillarLabel) &&
            (identical(other.pillarColor, pillarColor) ||
                other.pillarColor == pillarColor) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      typeLabel,
      amount,
      formattedAmount,
      description,
      timestamp,
      source,
      pillar,
      pillarLabel,
      pillarColor,
      title,
      subtitle,
      context,
      balanceAfter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HibonTransactionImplCopyWith<_$HibonTransactionImpl> get copyWith =>
      __$$HibonTransactionImplCopyWithImpl<_$HibonTransactionImpl>(
          this, _$identity);
}

abstract class _HibonTransaction implements HibonTransaction {
  const factory _HibonTransaction(
      {required final String id,
      required final TransactionType type,
      final String? typeLabel,
      required final int amount,
      final String? formattedAmount,
      required final String description,
      required final DateTime timestamp,
      final String? source,
      final String? pillar,
      final String? pillarLabel,
      final String? pillarColor,
      final String? title,
      final String? subtitle,
      final TransactionContext? context,
      final int? balanceAfter}) = _$HibonTransactionImpl;

  @override
  String get id;
  @override
  TransactionType get type;
  @override
  String? get typeLabel;
  @override
  int get amount;
  @override
  String? get formattedAmount;
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  String? get source;
  @override
  String? get pillar;
  @override
  String? get pillarLabel;
  @override
  String? get pillarColor;
  @override
  String? get title;
  @override
  String? get subtitle;
  @override
  TransactionContext? get context;
  @override
  int? get balanceAfter;
  @override
  @JsonKey(ignore: true)
  _$$HibonTransactionImplCopyWith<_$HibonTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

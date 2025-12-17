
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hibon_transaction.freezed.dart';
part 'hibon_transaction.g.dart';

enum TransactionType {
  earn,
  spend,
  buy,
}

@freezed
class HibonTransaction with _$HibonTransaction {
  const factory HibonTransaction({
    required String id,
    required TransactionType type,
    required int amount,
    required String description,
    required DateTime timestamp,
  }) = _HibonTransaction;

  factory HibonTransaction.fromJson(Map<String, dynamic> json) =>
      _$HibonTransactionFromJson(json);
}

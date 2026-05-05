
import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction_context.dart';

part 'hibon_transaction.freezed.dart';

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
    String? typeLabel,
    required int amount,
    String? formattedAmount,
    required String description,
    required DateTime timestamp,
    String? source,
    String? pillar,
    String? pillarLabel,
    String? pillarColor,
    String? title,
    String? subtitle,
    @Default(null) TransactionContext? context,
    int? balanceAfter,
  }) = _HibonTransaction;
}

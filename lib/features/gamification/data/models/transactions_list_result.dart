import 'earnings_by_pillar_entry.dart';
import 'hibon_transaction.dart';

/// Résultat domain de GET /mobile/hibons/transactions — items + agrégats meta.
class TransactionsListResult {
  final List<HibonTransaction> items;
  final int currentBalance;
  final int lifetimeEarned;
  final List<EarningsByPillarEntry> earningsByPillar;

  const TransactionsListResult({
    required this.items,
    required this.currentBalance,
    required this.lifetimeEarned,
    required this.earningsByPillar,
  });

  static const empty = TransactionsListResult(
    items: [],
    currentBalance: 0,
    lifetimeEarned: 0,
    earningsByPillar: [],
  );
}

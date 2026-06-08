import 'earnings_by_pillar_entry.dart';
import 'hibon_transaction.dart';

/// Résultat domain de GET /mobile/hibons/transactions — items + agrégats meta.
///
/// Les champs de pagination ([currentPage]/[lastPage]/[perPage]/[total]) sont
/// nullables : `null` en mode legacy (`limit`), renseignés en mode paginé
/// (`page`/`per_page`).
class TransactionsListResult {
  final List<HibonTransaction> items;
  final int currentBalance;
  final int lifetimeEarned;
  final List<EarningsByPillarEntry> earningsByPillar;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  const TransactionsListResult({
    required this.items,
    required this.currentBalance,
    required this.lifetimeEarned,
    required this.earningsByPillar,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  /// Vrai s'il reste au moins une page à charger (mode paginé uniquement).
  bool get hasMore =>
      currentPage != null && lastPage != null && currentPage! < lastPage!;

  static const empty = TransactionsListResult(
    items: [],
    currentBalance: 0,
    lifetimeEarned: 0,
    earningsByPillar: [],
  );
}

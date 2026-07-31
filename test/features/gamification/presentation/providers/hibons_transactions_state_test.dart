import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/gamification/data/models/transactions_list_result.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';

class _FlakyTransactionsRepository implements GamificationRepository {
  _FlakyTransactionsRepository(this.failure);

  final Object failure;
  final List<int> requestedPages = [];
  int pageTwoAttempts = 0;

  @override
  Future<TransactionsListResult> getTransactions({
    String? type,
    String? pillar,
    int? page,
    int? perPage,
  }) async {
    final requestedPage = page ?? 1;
    requestedPages.add(requestedPage);
    if (requestedPage == 1) {
      return TransactionsListResult(
        items: [_transaction('first')],
        currentBalance: 10,
        lifetimeEarned: 10,
        earningsByPillar: const [],
        currentPage: 1,
        lastPage: 2,
      );
    }

    pageTwoAttempts++;
    if (pageTwoAttempts == 1) throw failure;
    return TransactionsListResult(
      items: [_transaction('second')],
      currentBalance: 20,
      lifetimeEarned: 20,
      earningsByPillar: const [],
      currentPage: 2,
      lastPage: 2,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Hibons transaction pagination error can be cleared for retry', () {
    final state = const HibonsTransactionsState().copyWith(
      hasMore: true,
      loadMoreError: Exception('network failed'),
    );

    expect(state.loadMoreError, isNotNull);
    expect(state.hasMore, isTrue);
    expect(state.copyWith(loadMoreError: null).loadMoreError, isNull);
  });

  test(
      'failed page is preserved, automatic loadMore is blocked, and explicit retry succeeds',
      () async {
    final failure = StateError('page failed');
    final repository = _FlakyTransactionsRepository(failure);
    final notifier = HibonsTransactionsNotifier(
      repository,
      (type: null, pillar: null),
    );
    addTearDown(notifier.dispose);
    await _settle();

    expect(notifier.state.transactions.asData?.value.single.id, 'first');
    expect(notifier.state.hasMore, isTrue);

    await notifier.loadMore();

    expect(notifier.state.transactions.asData?.value.single.id, 'first');
    expect(notifier.state.currentPage, 1);
    expect(notifier.state.loadMoreError, same(failure));
    expect(repository.requestedPages, [1, 2]);

    // A scroll notification while the footer is visible must not create an
    // immediate retry loop.
    await notifier.loadMore();
    expect(repository.requestedPages, [1, 2]);

    await notifier.retryLoadMore();

    expect(
      notifier.state.transactions.asData?.value.map((item) => item.id),
      ['first', 'second'],
    );
    expect(repository.requestedPages, [1, 2, 2]);
    expect(notifier.state.currentPage, 2);
    expect(notifier.state.hasMore, isFalse);
    expect(notifier.state.loadMoreError, isNull);
    expect(notifier.state.currentBalance, 20);
  });
}

HibonTransaction _transaction(String id) {
  return HibonTransaction(
    id: id,
    type: TransactionType.earn,
    amount: 10,
    timestamp: DateTime(2026),
  );
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

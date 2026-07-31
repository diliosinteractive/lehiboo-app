import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/memberships/presentation/providers/private_events_provider.dart';

void main() {
  test('private events state retains and explicitly clears load-more errors',
      () {
    final failure = Exception('next page unavailable');
    final failed = const PrivateEventsState(
      events: [],
      page: 1,
      lastPage: 2,
      isLoadingMore: false,
    ).copyWith(loadMoreError: failure);

    expect(failed.loadMoreError, same(failure));
    expect(failed.copyWith().loadMoreError, same(failure));
    expect(failed.copyWith(loadMoreError: null).loadMoreError, isNull);
  });
}

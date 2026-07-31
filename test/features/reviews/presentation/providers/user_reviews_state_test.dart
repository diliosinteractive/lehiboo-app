import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/reviews/presentation/providers/user_reviews_provider.dart';

void main() {
  test('UserReviewsState keeps initial and pagination errors separate', () {
    final state = const UserReviewsState().copyWith(
      error: 'Could not load reviews.',
      loadMoreError: 'Could not load more reviews.',
    );

    expect(state.error, 'Could not load reviews.');
    expect(state.loadMoreError, 'Could not load more reviews.');
    expect(state.copyWith(loadMoreError: null).loadMoreError, isNull);
    expect(state.copyWith(loadMoreError: null).error, state.error);
  });
}

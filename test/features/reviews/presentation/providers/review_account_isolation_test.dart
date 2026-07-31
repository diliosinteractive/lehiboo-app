import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/reviews/domain/entities/can_review_result.dart';
import 'package:lehiboo/features/reviews/domain/entities/paginated_reviews.dart';
import 'package:lehiboo/features/reviews/domain/entities/review.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_enums.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_stats.dart';
import 'package:lehiboo/features/reviews/domain/entities/user_review.dart';
import 'package:lehiboo/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:lehiboo/features/reviews/presentation/providers/pending_count_provider.dart';
import 'package:lehiboo/features/reviews/presentation/providers/reviews_actions_provider.dart';
import 'package:lehiboo/features/reviews/presentation/providers/reviews_providers.dart';
import 'package:lehiboo/features/reviews/presentation/providers/user_reviews_provider.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  test('old actions notifier rejects work and results after A -> B -> A',
      () async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final accountANotifier = container.read(reviewsActionsProvider.notifier);
    final pendingDelete = accountANotifier.deleteReview(
      reviewUuid: 'review-a',
      eventSlug: 'event',
    );
    expect(repository.deleteRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'account-b';
    final accountBNotifier = container.read(reviewsActionsProvider.notifier);
    expect(accountBNotifier, isNot(same(accountANotifier)));

    container.read(_accountIdProvider.notifier).state = 'account-a';
    final replacementAccountANotifier =
        container.read(reviewsActionsProvider.notifier);
    expect(replacementAccountANotifier, isNot(same(accountANotifier)));
    expect(replacementAccountANotifier, isNot(same(accountBNotifier)));

    final rejectedLateAction = await accountANotifier.deleteReview(
      reviewUuid: 'review-a-late',
      eventSlug: 'event',
    );
    expect(rejectedLateAction, isA<ReviewActionFailure<void>>());
    expect(repository.deleteRequests, hasLength(1));

    repository.deleteRequests.single.complete();
    final staleResult = await pendingDelete;
    expect(staleResult, isA<ReviewActionFailure<void>>());
    final accountBState = container.read(reviewsActionsProvider);
    expect(accountBState, isA<AsyncData<void>>());
  });

  test('old user-review response cannot populate replacement A session',
      () async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final subscription = container.listen(
      userReviewsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    expect(repository.userReviewRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'account-b';
    container.read(authSessionKeyProvider);
    container.read(userReviewsProvider);
    expect(repository.userReviewRequests, hasLength(2));
    container.read(_accountIdProvider.notifier).state = 'account-a';
    container.read(authSessionKeyProvider);
    container.read(userReviewsProvider);
    expect(repository.userReviewRequests, hasLength(3));

    repository.userReviewRequests[0].complete(
      const PaginatedUserReviews(
        items: [
          UserReview(
            uuid: 'old-a-review',
            rating: 5,
            comment: 'Old A private content',
            eventTitle: 'Old A private event',
            eventSlug: 'old-a-event',
          ),
        ],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(container.read(userReviewsProvider).items, isEmpty);

    repository.userReviewRequests[2].complete(
      const PaginatedUserReviews(
        items: [
          UserReview(
            uuid: 'new-a-review',
            rating: 4,
            comment: 'New A content',
            eventTitle: 'New A event',
            eventSlug: 'new-a-event',
          ),
        ],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(userReviewsProvider).items.single.uuid,
      'new-a-review',
    );
  });

  test('old eligibility cannot populate replacement A after A -> B -> A',
      () async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final accountARequest = CanReviewParams(
      eventSlug: 'event',
      ownerSession: container.read(authSessionKeyProvider),
    );
    final accountAFuture = container.read(
      canReviewProvider(accountARequest).future,
    );
    expect(repository.canReviewRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'account-b';
    final accountBRequest = CanReviewParams(
      eventSlug: 'event',
      ownerSession: container.read(authSessionKeyProvider),
    );
    final accountBSubscription = container.listen(
      canReviewProvider(accountBRequest),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(accountBSubscription.close);
    final accountBFuture = container.read(
      canReviewProvider(accountBRequest).future,
    );
    expect(repository.canReviewRequests, hasLength(2));

    const accountBResult = CanReviewDenied(
      reason: CanReviewReason.notParticipated,
    );
    repository.canReviewRequests[1].complete(accountBResult);
    expect(await accountBFuture, accountBResult);

    container.read(_accountIdProvider.notifier).state = 'account-a';
    final replacementARequest = CanReviewParams(
      eventSlug: 'event',
      ownerSession: container.read(authSessionKeyProvider),
    );
    final replacementASubscription = container.listen(
      canReviewProvider(replacementARequest),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(replacementASubscription.close);
    final replacementAFuture = container.read(
      canReviewProvider(replacementARequest).future,
    );
    expect(repository.canReviewRequests, hasLength(3));
    const replacementAResult = CanReviewDenied(
      reason: CanReviewReason.alreadyReviewed,
    );
    repository.canReviewRequests[2].complete(replacementAResult);
    expect(await replacementAFuture, replacementAResult);

    repository.canReviewRequests[0].complete(const CanReviewAllowed());
    await accountAFuture.catchError((_) => const CanReviewAllowed());
    expect(
      container.read(canReviewProvider(replacementARequest)).valueOrNull,
      replacementAResult,
    );
  });

  test('old event reviews cannot populate replacement A family key', () async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final accountARequest = EventReviewsParams(
      eventSlug: 'event',
      ownerSession: container.read(authSessionKeyProvider),
    );
    final accountAFuture =
        container.read(eventReviewsProvider(accountARequest).future);
    expect(repository.eventReviewRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'account-b';
    final accountBRequest = EventReviewsParams(
      eventSlug: 'event',
      ownerSession: container.read(authSessionKeyProvider),
    );
    final accountBFuture =
        container.read(eventReviewsProvider(accountBRequest).future);
    expect(repository.eventReviewRequests, hasLength(2));
    repository.eventReviewRequests[1].complete(
      const PaginatedReviews(
        items: [
          Review(
            uuid: 'review-b',
            rating: 4,
            comment: 'B review',
          ),
        ],
      ),
    );
    expect((await accountBFuture).items.single.uuid, 'review-b');

    container.read(_accountIdProvider.notifier).state = 'account-a';
    final replacementARequest = EventReviewsParams(
      eventSlug: 'event',
      ownerSession: container.read(authSessionKeyProvider),
    );
    final replacementASubscription = container.listen(
      eventReviewsProvider(replacementARequest),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(replacementASubscription.close);
    final replacementAFuture =
        container.read(eventReviewsProvider(replacementARequest).future);
    expect(repository.eventReviewRequests, hasLength(3));
    repository.eventReviewRequests[2].complete(
      const PaginatedReviews(
        items: [
          Review(
            uuid: 'replacement-a-review',
            rating: 5,
            comment: 'Replacement A review',
          ),
        ],
      ),
    );
    expect(
      (await replacementAFuture).items.single.uuid,
      'replacement-a-review',
    );

    repository.eventReviewRequests[0].complete(
      const PaginatedReviews(
        items: [
          Review(
            uuid: 'old-a-review',
            rating: 1,
            comment: 'Old A review',
          ),
        ],
      ),
    );
    await accountAFuture.catchError((_) => const PaginatedReviews());
    expect(
      container
          .read(eventReviewsProvider(replacementARequest))
          .valueOrNull
          ?.items
          .single
          .uuid,
      'replacement-a-review',
    );
  });

  test('pending count uses a distinct cache entry for each exact session',
      () async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final accountAOwner = container.read(authSessionKeyProvider);
    final accountASubscription = container.listen(
      pendingReviewCountProvider(accountAOwner),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(accountASubscription.close);
    final accountAFuture = container.read(
      pendingReviewCountProvider(accountAOwner).future,
    );
    expect(repository.pendingCountRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'account-b';
    final accountBOwner = container.read(authSessionKeyProvider);
    final accountBSubscription = container.listen(
      pendingReviewCountProvider(accountBOwner),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(accountBSubscription.close);
    final accountBFuture = container.read(
      pendingReviewCountProvider(accountBOwner).future,
    );
    expect(repository.pendingCountRequests, hasLength(2));

    repository.pendingCountRequests[1].complete(2);
    expect(await accountBFuture, 2);

    container.read(_accountIdProvider.notifier).state = 'account-a';
    final replacementAOwner = container.read(authSessionKeyProvider);
    final replacementASubscription = container.listen(
      pendingReviewCountProvider(replacementAOwner),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(replacementASubscription.close);
    final replacementAFuture = container.read(
      pendingReviewCountProvider(replacementAOwner).future,
    );
    expect(repository.pendingCountRequests, hasLength(3));
    repository.pendingCountRequests[2].complete(3);
    expect(await replacementAFuture, 3);

    repository.pendingCountRequests[0].complete(9);
    await accountAFuture.catchError((_) => 0);

    expect(
      container.read(pendingReviewCountProvider(replacementAOwner)).valueOrNull,
      3,
    );
  });
}

ProviderContainer _container(_ReviewsRepository repository) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_accountIdProvider),
      ),
      reviewsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

class _ReviewsRepository implements ReviewsRepository {
  final List<Completer<void>> deleteRequests = [];
  final List<Completer<CanReviewResult>> canReviewRequests = [];
  final List<Completer<PaginatedReviews>> eventReviewRequests = [];
  final List<Completer<int>> pendingCountRequests = [];
  final List<Completer<PaginatedUserReviews>> userReviewRequests = [];

  @override
  Future<void> deleteReview(String reviewUuid) {
    final request = Completer<void>();
    deleteRequests.add(request);
    return request.future;
  }

  @override
  Future<CanReviewResult> canReview(String eventSlug) {
    final request = Completer<CanReviewResult>();
    canReviewRequests.add(request);
    return request.future;
  }

  @override
  Future<Review> createReview(
    String eventSlug, {
    required int rating,
    required String title,
    required String comment,
    String? bookingUuid,
  }) =>
      throw UnimplementedError();

  @override
  Future<PaginatedReviews> getEventReviews(
    String eventSlug, {
    ReviewsQuery query = const ReviewsQuery(),
  }) {
    final request = Completer<PaginatedReviews>();
    eventReviewRequests.add(request);
    return request.future;
  }

  @override
  Future<int> getPendingCount() {
    final request = Completer<int>();
    pendingCountRequests.add(request);
    return request.future;
  }

  @override
  Future<Review> getReview(String reviewUuid) => throw UnimplementedError();

  @override
  Future<ReviewStats> getEventReviewStats(String eventSlug) =>
      throw UnimplementedError();

  @override
  Future<PaginatedUserReviews> getUserReviews({
    int page = 1,
    int perPage = 10,
  }) {
    final request = Completer<PaginatedUserReviews>();
    userReviewRequests.add(request);
    return request.future;
  }

  @override
  Future<void> reportReview(
    String reviewUuid, {
    required ReportReason reason,
    String? details,
  }) =>
      throw UnimplementedError();

  @override
  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? title,
    String? comment,
  }) =>
      throw UnimplementedError();

  @override
  Future<VoteCounts> unvoteReview(String reviewUuid) =>
      throw UnimplementedError();

  @override
  Future<VoteCounts> voteReview(
    String reviewUuid, {
    required bool isHelpful,
  }) =>
      throw UnimplementedError();
}

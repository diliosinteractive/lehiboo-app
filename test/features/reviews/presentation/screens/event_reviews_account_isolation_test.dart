import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/reviews/domain/entities/can_review_result.dart';
import 'package:lehiboo/features/reviews/domain/entities/paginated_reviews.dart';
import 'package:lehiboo/features/reviews/domain/entities/review.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_enums.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_stats.dart';
import 'package:lehiboo/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:lehiboo/features/reviews/presentation/screens/event_reviews_full_screen.dart';
import 'package:lehiboo/features/reviews/presentation/widgets/review_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets('A vote marker disappears before B review response arrives',
      (tester) async {
    _useLargeSurface(tester);
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));
    await tester.pump();
    repository.reviewPages.single.complete(
      _page(_review(userVote: true, helpfulCount: 3)),
    );
    await tester.pumpAndSettle();
    expect(_reviewIcon(Icons.thumb_up), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pump();

    expect(repository.reviewPages, hasLength(2));
    expect(_reviewIcon(Icons.thumb_up), findsNothing);
    expect(find.byType(ReviewCard), findsNothing);

    repository.reviewPages[1].complete(
      _page(_review(userVote: null, helpfulCount: 3)),
    );
    await tester.pumpAndSettle();

    expect(_reviewIcon(Icons.thumb_up_outlined), findsOneWidget);
    expect(_reviewIcon(Icons.thumb_up), findsNothing);
  });

  testWidgets('in-flight A vote cannot update B review state', (tester) async {
    _useLargeSurface(tester);
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));
    await tester.pump();
    repository.reviewPages.single.complete(
      _page(_review(userVote: null, helpfulCount: 2)),
    );
    await tester.pumpAndSettle();

    await tester.tap(_reviewIcon(Icons.thumb_up_outlined));
    await tester.pump();
    expect(repository.voteRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pump();
    expect(repository.reviewPages, hasLength(2));

    repository.reviewPages[1].complete(
      _page(_review(userVote: null, helpfulCount: 4)),
    );
    await tester.pumpAndSettle();
    expect(_reviewCount('4'), findsOneWidget);

    repository.voteRequests.single.complete(
      const VoteCounts(helpfulCount: 99, notHelpfulCount: 99),
    );
    await tester.pump();
    await tester.pump();

    expect(_reviewCount('99'), findsNothing);
    expect(_reviewCount('4'), findsOneWidget);
    expect(_reviewIcon(Icons.thumb_up_outlined), findsOneWidget);
  });

  testWidgets('rendered A vote callback is rejected after A -> B -> A',
      (tester) async {
    _useLargeSurface(tester);
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));
    await tester.pump();
    repository.reviewPages.single.complete(
      _page(_review(userVote: null, helpfulCount: 2)),
    );
    await tester.pumpAndSettle();

    final staleVote =
        tester.widget<ReviewCard>(find.byType(ReviewCard)).onVote!;

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pump();
    container.read(_accountIdProvider.notifier).state = 'account-a';
    await tester.pump();

    staleVote('review', true);
    await tester.pump();

    expect(repository.voteRequests, isEmpty);
  });

  testWidgets('account-owned review route blanks permanently on mismatch',
      (tester) async {
    _useLargeSurface(tester);
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final ownerSession = container.read(authSessionKeyProvider);

    await tester.pumpWidget(
      _app(container, ownerSession: ownerSession),
    );
    await tester.pump();
    repository.reviewPages.single.complete(
      _page(_review(userVote: null, helpfulCount: 2)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ReviewCard), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pump();
    container.read(_accountIdProvider.notifier).state = 'account-a';
    await tester.pump();

    expect(find.byType(ReviewCard), findsNothing);
    expect(repository.reviewPages, hasLength(1));
  });
}

ProviderContainer _container(_ReviewsRepository repository) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_accountIdProvider),
      ),
      isAuthenticatedProvider.overrideWith(
        (ref) => ref.watch(_accountIdProvider) != null,
      ),
      reviewsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

Widget _app(
  ProviderContainer container, {
  AuthSessionKey? ownerSession,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EventReviewsFullScreen(
        eventSlug: 'event',
        eventTitle: ownerSession == null ? null : 'Account A event',
        ownerSession: ownerSession,
      ),
    ),
  );
}

Review _review({required bool? userVote, required int helpfulCount}) {
  return Review(
    uuid: 'review',
    rating: 5,
    title: 'Review',
    comment: 'Public review content',
    helpfulCount: helpfulCount,
    notHelpfulCount: 1,
    userVote: userVote,
  );
}

PaginatedReviews _page(Review review) {
  return PaginatedReviews(
    items: [review],
    meta: const PaginationMeta(total: 1),
  );
}

Finder _reviewIcon(IconData icon) {
  return find.descendant(
    of: find.byType(ReviewCard),
    matching: find.byIcon(icon),
  );
}

Finder _reviewCount(String value) {
  return find.descendant(
    of: find.byType(ReviewCard),
    matching: find.text(value),
  );
}

void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

class _ReviewsRepository implements ReviewsRepository {
  final List<Completer<PaginatedReviews>> reviewPages = [];
  final List<Completer<VoteCounts>> voteRequests = [];

  @override
  Future<PaginatedReviews> getEventReviews(
    String eventSlug, {
    ReviewsQuery query = const ReviewsQuery(),
  }) {
    final request = Completer<PaginatedReviews>();
    reviewPages.add(request);
    return request.future;
  }

  @override
  Future<VoteCounts> voteReview(
    String reviewUuid, {
    required bool isHelpful,
  }) {
    final request = Completer<VoteCounts>();
    voteRequests.add(request);
    return request.future;
  }

  @override
  Future<CanReviewResult> canReview(String eventSlug) async =>
      const CanReviewDenied(reason: CanReviewReason.notParticipated);

  @override
  Future<ReviewStats> getEventReviewStats(String eventSlug) async =>
      const ReviewStats(
        totalReviews: 1,
        averageRating: 5,
        distribution: {5: 1},
        percentages: {5: 100},
      );

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
  Future<void> deleteReview(String reviewUuid) => throw UnimplementedError();

  @override
  Future<int> getPendingCount() => throw UnimplementedError();

  @override
  Future<Review> getReview(String reviewUuid) => throw UnimplementedError();

  @override
  Future<PaginatedUserReviews> getUserReviews({
    int page = 1,
    int perPage = 10,
  }) =>
      throw UnimplementedError();

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
}

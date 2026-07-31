import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/reviews/domain/entities/can_review_result.dart';
import 'package:lehiboo/features/reviews/domain/entities/paginated_reviews.dart';
import 'package:lehiboo/features/reviews/domain/entities/review.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_enums.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_stats.dart';
import 'package:lehiboo/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:lehiboo/features/reviews/presentation/screens/event_reviews_full_screen.dart';
import 'package:lehiboo/features/reviews/presentation/widgets/event_reviews_section.dart';
import 'package:lehiboo/features/reviews/presentation/widgets/review_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

const _review = Review(
  uuid: 'review-1',
  rating: 5,
  title: 'Great',
  comment: 'A useful review',
  helpfulCount: 2,
  notHelpfulCount: 1,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => AppLocaleCache.setLanguageCode('en'));
  tearDown(() => AppLocaleCache.setLanguageCode('fr'));

  testWidgets('failed full-screen vote rolls back and reports the failure',
      (tester) async {
    _useLargeSurface(tester);
    final vote = Completer<VoteCounts>();
    final repository = _FakeReviewsRepository(
      onVote: (_) {
        return vote.future;
      },
    );

    await tester.pumpWidget(_app(
      repository,
      const EventReviewsFullScreen(eventSlug: 'event'),
    ));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byIcon(Icons.thumb_up_outlined));
    await tester.tap(find.byIcon(Icons.thumb_up_outlined));
    await tester.pump();

    expect(repository.voteCalls, 1);
    expect(_reviewCount('3'), findsOneWidget);

    // The optimistic active button is disabled while the request is pending.
    await tester.tap(find.byIcon(Icons.thumb_up));
    await tester.pump();
    expect(repository.voteCalls, 1);

    vote.completeError(StateError('internal vote diagnostic'));
    await tester.pumpAndSettle();

    expect(_reviewCount('2'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up_outlined), findsOneWidget);
    expect(
      find.text("We couldn't record your vote. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets('successful vote applies authoritative server counts',
      (tester) async {
    _useLargeSurface(tester);
    final repository = _FakeReviewsRepository(
      onVote: (_) async => const VoteCounts(
        helpfulCount: 9,
        notHelpfulCount: 4,
      ),
    );

    await tester.pumpWidget(_app(
      repository,
      const EventReviewsFullScreen(eventSlug: 'event'),
    ));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byIcon(Icons.thumb_up_outlined));
    await tester.tap(find.byIcon(Icons.thumb_up_outlined));
    await tester.pumpAndSettle();

    expect(repository.voteCalls, 1);
    expect(_reviewCount('9'), findsOneWidget);
    expect(_reviewCount('4'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);
  });

  testWidgets('eligibility error hides write CTA and offers a working retry',
      (tester) async {
    _useLargeSurface(tester);
    var eligibilityCalls = 0;
    final repository = _FakeReviewsRepository(
      onCanReview: () async {
        eligibilityCalls++;
        if (eligibilityCalls == 1) {
          throw StateError('internal eligibility diagnostic');
        }
        return const CanReviewAllowed();
      },
    );

    await tester.pumpWidget(_app(
      repository,
      const EventReviewsFullScreen(eventSlug: 'event'),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(
      find.text(
        "We couldn't check whether you can review this event. "
        'Retry before writing a review.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(eligibilityCalls, 2);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Write a review'), findsOneWidget);
  });

  testWidgets('event section exposes write only after explicit eligibility',
      (tester) async {
    _useLargeSurface(tester);
    final eligibility = Completer<CanReviewResult>();
    final repository = _FakeReviewsRepository(
      onCanReview: () => eligibility.future,
    );

    await tester.pumpWidget(_app(
      repository,
      SingleChildScrollView(
        child: EventReviewsSection(
          eventSlug: 'event',
          onWriteReview: () {},
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('Write'), findsNothing);
    expect(find.text('Write the first review'), findsNothing);
    expect(
      find.text('Checking whether you can write a review…'),
      findsOneWidget,
    );

    eligibility.complete(const CanReviewAllowed());
    await tester.pumpAndSettle();

    expect(find.text('Write'), findsOneWidget);
  });
}

void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Finder _reviewCount(String value) {
  return find.descendant(
    of: find.byType(ReviewCard),
    matching: find.text(value),
  );
}

Widget _app(ReviewsRepository repository, Widget home) {
  return ProviderScope(
    overrides: [reviewsRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

class _FakeReviewsRepository implements ReviewsRepository {
  final Future<CanReviewResult> Function()? onCanReview;
  final Future<VoteCounts> Function(bool isHelpful)? onVote;

  int voteCalls = 0;

  _FakeReviewsRepository({this.onCanReview, this.onVote});

  @override
  Future<PaginatedReviews> getEventReviews(
    String eventSlug, {
    ReviewsQuery query = const ReviewsQuery(),
  }) async {
    return const PaginatedReviews(
      items: [_review],
      meta: PaginationMeta(total: 1),
    );
  }

  @override
  Future<ReviewStats> getEventReviewStats(String eventSlug) async {
    return const ReviewStats(
      totalReviews: 1,
      averageRating: 5,
      distribution: {5: 1},
      percentages: {5: 100},
    );
  }

  @override
  Future<CanReviewResult> canReview(String eventSlug) {
    return onCanReview?.call() ?? Future.value(const CanReviewAllowed());
  }

  @override
  Future<VoteCounts> voteReview(
    String reviewUuid, {
    required bool isHelpful,
  }) {
    voteCalls++;
    return onVote?.call(isHelpful) ?? Future.value(const VoteCounts());
  }

  @override
  Future<VoteCounts> unvoteReview(String reviewUuid) async {
    return const VoteCounts();
  }

  @override
  Future<Review> createReview(
    String eventSlug, {
    required int rating,
    required String title,
    required String comment,
    String? bookingUuid,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteReview(String reviewUuid) {
    throw UnimplementedError();
  }

  @override
  Future<int> getPendingCount() async => 0;

  @override
  Future<Review> getReview(String reviewUuid) {
    throw UnimplementedError();
  }

  @override
  Future<PaginatedUserReviews> getUserReviews({
    int page = 1,
    int perPage = 10,
  }) async {
    return const PaginatedUserReviews();
  }

  @override
  Future<void> reportReview(
    String reviewUuid, {
    required ReportReason reason,
    String? details,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? title,
    String? comment,
  }) {
    throw UnimplementedError();
  }
}

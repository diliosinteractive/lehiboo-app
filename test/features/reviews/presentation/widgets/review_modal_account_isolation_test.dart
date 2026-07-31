import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/reviews/domain/entities/can_review_result.dart';
import 'package:lehiboo/features/reviews/domain/entities/paginated_reviews.dart';
import 'package:lehiboo/features/reviews/domain/entities/review.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_enums.dart';
import 'package:lehiboo/features/reviews/domain/entities/review_stats.dart';
import 'package:lehiboo/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:lehiboo/features/reviews/presentation/widgets/my_review_block.dart';
import 'package:lehiboo/features/reviews/presentation/widgets/report_review_sheet.dart';
import 'package:lehiboo/features/reviews/presentation/widgets/write_review_sheet.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'account-a');

const _review = Review(
  uuid: 'review-a',
  rating: 5,
  title: 'Account A review',
  comment: 'Account A private review comment',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => AppLocaleCache.setLanguageCode('en'));
  tearDown(() => AppLocaleCache.setLanguageCode('fr'));

  testWidgets('write sheet clears and closes an A draft on A -> B',
      (tester) async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        Consumer(
          builder: (context, ref, _) {
            final owner = ref.watch(authSessionKeyProvider);
            return TextButton(
              onPressed: owner.accountId == null
                  ? null
                  : () => WriteReviewSheet.show(
                        context,
                        eventSlug: 'event',
                        eventTitle: 'Event',
                        ownerSession: owner,
                      ),
              child: const Text('Open write'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open write'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.first, 'Account A secret draft');
    expect(find.text('Account A secret draft'), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.byType(WriteReviewSheet), findsNothing);
    expect(find.text('Account A secret draft'), findsNothing);

    await tester.tap(find.text('Open write'));
    await tester.pumpAndSettle();
    final reopenedFields = find.byType(TextFormField);
    expect(reopenedFields, findsNWidgets(2));
    expect(tester.widget<TextFormField>(reopenedFields.first).controller?.text,
        isEmpty);
  });

  testWidgets('report sheet clears and closes an A draft on logout',
      (tester) async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        Consumer(
          builder: (context, ref, _) {
            final owner = ref.watch(authSessionKeyProvider);
            return TextButton(
              onPressed: owner.accountId == null
                  ? null
                  : () => ReportReviewSheet.show(
                        context,
                        reviewUuid: 'review-a',
                        ownerSession: owner,
                      ),
              child: const Text('Open report'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open report'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField),
      'Account A report details',
    );
    expect(find.text('Account A report details'), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = null;
    await tester.pumpAndSettle();

    expect(find.byType(ReportReviewSheet), findsNothing);
    expect(find.text('Account A report details'), findsNothing);
    expect(repository.reportCalls, 0);
  });

  testWidgets('delete confirmation closes on switch and executes nothing',
      (tester) async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        Consumer(
          builder: (context, ref, _) => MyReviewBlock(
            review: _review,
            eventSlug: 'event',
            eventTitle: 'Event',
            ownerSession: ref.watch(authSessionKeyProvider),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.deleteCalls, 0);
  });

  testWidgets('stale A edit and delete callbacks fail after A -> B -> A',
      (tester) async {
    final repository = _ReviewsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        Consumer(
          builder: (context, ref, _) => MyReviewBlock(
            review: _review,
            eventSlug: 'event',
            eventTitle: 'Event',
            ownerSession: ref.watch(authSessionKeyProvider),
          ),
        ),
      ),
    );

    final staleEdit = tester
        .widget<IconButton>(
          find.ancestor(
            of: find.byIcon(Icons.edit_outlined),
            matching: find.byType(IconButton),
          ),
        )
        .onPressed!;
    final staleDelete = tester
        .widget<IconButton>(
          find.ancestor(
            of: find.byIcon(Icons.delete_outline),
            matching: find.byType(IconButton),
          ),
        )
        .onPressed!;

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await tester.pump();
    container.read(_accountIdProvider.notifier).state = 'account-a';
    await tester.pump();

    staleEdit();
    staleDelete();
    await tester.pumpAndSettle();

    expect(find.byType(WriteReviewSheet), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.deleteCalls, 0);
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

Widget _app(ProviderContainer container, Widget body) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: body),
    ),
  );
}

class _ReviewsRepository implements ReviewsRepository {
  int deleteCalls = 0;
  int reportCalls = 0;

  @override
  Future<CanReviewResult> canReview(String eventSlug) async =>
      const CanReviewAllowed();

  @override
  Future<void> deleteReview(String reviewUuid) async {
    deleteCalls++;
  }

  @override
  Future<void> reportReview(
    String reviewUuid, {
    required ReportReason reason,
    String? details,
  }) async {
    reportCalls++;
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
  }) =>
      throw UnimplementedError();

  @override
  Future<ReviewStats> getEventReviewStats(String eventSlug) =>
      throw UnimplementedError();

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

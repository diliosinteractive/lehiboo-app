import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_list_controller.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/data/models/toggle_favorite_result.dart';
import 'package:lehiboo/features/favorites/domain/entities/favorite_list.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorite_lists_provider.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/features/reminders/data/repositories/reminders_repository_impl.dart';
import 'package:lehiboo/features/reminders/domain/entities/reminder.dart';
import 'package:lehiboo/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:lehiboo/features/reminders/presentation/providers/reminders_provider.dart';
import 'package:lehiboo/features/reviews/domain/entities/paginated_reviews.dart';
import 'package:lehiboo/features/reviews/domain/entities/user_review.dart';
import 'package:lehiboo/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:lehiboo/features/reviews/presentation/providers/user_reviews_provider.dart';
import 'package:lehiboo/features/trip_plans/domain/entities/trip_plan.dart';
import 'package:lehiboo/features/trip_plans/domain/repositories/trip_plans_repository.dart';
import 'package:lehiboo/features/trip_plans/presentation/providers/trip_plans_provider.dart';

final _sessionUserIdProvider = StateProvider<String?>((ref) => 'user-a');

void main() {
  test('late booking response from the previous account is ignored', () async {
    final repository = _BookingRepository();
    final container = _container(
      bookingRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      bookingsListControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    _switchAccount(container);
    await _flush();
    expect(repository.requests, hasLength(2));

    repository.requests[1].complete([_booking('booking-b')]);
    await _flush();
    expect(
      container.read(bookingsListControllerProvider).allBookings.single.id,
      'booking-b',
    );

    repository.requests[0].complete([_booking('booking-a')]);
    await _flush();
    expect(
      container.read(bookingsListControllerProvider).allBookings.single.id,
      'booking-b',
    );
  });

  test('late favorites response from the previous account is ignored',
      () async {
    final repository = _FavoritesRepository();
    final container = _container(
      favoritesRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      favoritesProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.favoriteRequests, hasLength(1));
    _switchAccount(container);
    await _flush();
    expect(repository.favoriteRequests, hasLength(2));

    repository.favoriteRequests[1].complete([_event('event-b')]);
    await _flush();
    expect(container.read(favoritesProvider).valueOrNull?.single.id, 'event-b');

    repository.favoriteRequests[0].complete([_event('event-a')]);
    await _flush();
    expect(container.read(favoritesProvider).valueOrNull?.single.id, 'event-b');
  });

  test('an old-account favorite rollback cannot restore its snapshot',
      () async {
    final repository = _FavoritesRepository();
    final container = _container(
      favoritesRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      favoritesProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.favoriteRequests.single.complete([]);
    await _flush();
    final oldNotifier = container.read(favoritesProvider.notifier);
    final oldMutation = oldNotifier.toggleFavorite(_event('event-a'));
    final failure = Exception('old account request failed');
    final failureExpectation = expectLater(
      oldMutation,
      throwsA(same(failure)),
    );

    _switchAccount(container);
    await _flush();
    repository.favoriteRequests[1].complete([_event('event-b')]);
    await _flush();

    repository.toggleRequest.completeError(failure, StackTrace.current);
    await failureExpectation;
    expect(container.read(favoritesProvider).valueOrNull?.single.id, 'event-b');
  });

  test('late favorite-list response from the previous account is ignored',
      () async {
    final repository = _FavoritesRepository();
    final container = _container(
      favoritesRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      favoriteListsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.listRequests, hasLength(1));
    _switchAccount(container);
    await _flush();
    expect(repository.listRequests, hasLength(2));

    repository.listRequests[1].complete([_favoriteList('list-b')]);
    await _flush();
    expect(
      container.read(favoriteListsProvider).valueOrNull?.single.id,
      'list-b',
    );

    repository.listRequests[0].complete([_favoriteList('list-a')]);
    await _flush();
    expect(
      container.read(favoriteListsProvider).valueOrNull?.single.id,
      'list-b',
    );
  });

  test('late reminder responses cannot cross account boundaries', () async {
    final repository = _RemindersRepository();
    final container = _container(
      remindersRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final listSubscription = container.listen(
      remindersListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final accountASession = container.read(authSessionKeyProvider);
    final accountAQuery = (
      ownerSession: accountASession,
      eventUuid: 'event',
    );
    final eventSubscription = container.listen(
      eventRemindersProvider(accountAQuery),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(listSubscription.close);
    addTearDown(eventSubscription.close);

    expect(repository.listRequests, hasLength(1));
    expect(repository.eventRequests, hasLength(1));
    _switchAccount(container);
    final accountBSession = container.read(authSessionKeyProvider);
    final accountBQuery = (
      ownerSession: accountBSession,
      eventUuid: 'event',
    );
    final accountBSubscription = container.listen(
      eventRemindersProvider(accountBQuery),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(accountBSubscription.close);
    expect(
      container.read(eventRemindersProvider(accountBQuery)).valueOrNull,
      isNull,
    );
    await _flush();
    expect(repository.listRequests, hasLength(2));
    expect(repository.eventRequests, hasLength(2));

    repository.listRequests[1].complete([_reminder('slot-b')]);
    repository.eventRequests[1].complete(['slot-b']);
    await _flush();
    expect(
      container.read(remindersListProvider).valueOrNull?.single.id,
      'slot-b',
    );
    expect(
      container.read(eventRemindersProvider(accountBQuery)).valueOrNull,
      {'slot-b'},
    );

    repository.listRequests[0].complete([_reminder('slot-a')]);
    repository.eventRequests[0].complete(['slot-a']);
    await _flush();
    expect(
      container.read(remindersListProvider).valueOrNull?.single.id,
      'slot-b',
    );
    expect(
      container.read(eventRemindersProvider(accountBQuery)).valueOrNull,
      {'slot-b'},
    );
  });

  test('late trip-plan response from the previous account is ignored',
      () async {
    final repository = _TripPlansRepository();
    final container = _container(
      tripPlansRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      tripPlansProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    _switchAccount(container);
    await _flush();
    expect(repository.requests, hasLength(2));

    repository.requests[1].complete([_tripPlan('trip-b')]);
    await _flush();
    expect(
        container.read(tripPlansProvider).valueOrNull?.single.uuid, 'trip-b');

    repository.requests[0].complete([_tripPlan('trip-a')]);
    await _flush();
    expect(
        container.read(tripPlansProvider).valueOrNull?.single.uuid, 'trip-b');
  });

  test('late user-review response from the previous account is ignored',
      () async {
    final repository = _ReviewsRepository();
    final container = _container(
      reviewsRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      userReviewsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    _switchAccount(container);
    await _flush();
    expect(repository.requests, hasLength(2));

    repository.requests[1].complete(
      PaginatedUserReviews(items: [_review('review-b')]),
    );
    await _flush();
    expect(container.read(userReviewsProvider).items.single.uuid, 'review-b');

    repository.requests[0].complete(
      PaginatedUserReviews(items: [_review('review-a')]),
    );
    await _flush();
    expect(container.read(userReviewsProvider).items.single.uuid, 'review-b');
  });
}

ProviderContainer _container(Override repositoryOverride) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_sessionUserIdProvider),
      ),
      repositoryOverride,
    ],
  );
}

void _switchAccount(ProviderContainer container) {
  container.read(_sessionUserIdProvider.notifier).state = 'user-b';
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

Booking _booking(String id) => Booking(
      id: id,
      userId: id,
      slotId: 'slot',
      activityId: 'activity',
    );

Event _event(String id) => Event.minimal(id: id, slug: id, title: id);

FavoriteList _favoriteList(String id) => FavoriteList(id: id, name: id);

Reminder _reminder(String id) => Reminder(
      id: id,
      createdAt: DateTime(2026),
      eventUuid: 'event',
      eventSlug: 'event',
      eventTitle: 'Event',
      slotDate: DateTime(2026, 8),
    );

TripPlan _tripPlan(String id) => TripPlan(
      uuid: id,
      title: id,
      stopsCount: 0,
      stops: const [],
      createdAt: DateTime(2026),
    );

UserReview _review(String id) => UserReview(
      uuid: id,
      rating: 5,
      comment: id,
      eventTitle: 'Event',
      eventSlug: 'event',
    );

class _BookingRepository implements BookingRepository {
  final List<Completer<List<Booking>>> requests = [];

  @override
  Future<List<Booking>> getMyBookings() {
    final request = Completer<List<Booking>>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FavoritesRepository implements FavoritesRepository {
  final List<Completer<List<Event>>> favoriteRequests = [];
  final List<Completer<List<FavoriteList>>> listRequests = [];
  final Completer<ToggleFavoriteResult> toggleRequest =
      Completer<ToggleFavoriteResult>();

  @override
  Future<List<Event>> getFavorites({String? listId}) {
    final request = Completer<List<Event>>();
    favoriteRequests.add(request);
    return request.future;
  }

  @override
  Future<List<FavoriteList>> getLists() {
    final request = Completer<List<FavoriteList>>();
    listRequests.add(request);
    return request.future;
  }

  @override
  Future<ToggleFavoriteResult> toggleFavorite(
    String eventUuid, {
    String? listId,
  }) =>
      toggleRequest.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RemindersRepository implements RemindersRepository {
  final List<Completer<List<Reminder>>> listRequests = [];
  final List<Completer<List<String>>> eventRequests = [];

  @override
  Future<List<Reminder>> getMyReminders({int page = 1, int perPage = 50}) {
    final request = Completer<List<Reminder>>();
    listRequests.add(request);
    return request.future;
  }

  @override
  Future<List<String>> getEventReminders(String eventUuid) {
    final request = Completer<List<String>>();
    eventRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TripPlansRepository implements TripPlansRepository {
  final List<Completer<List<TripPlan>>> requests = [];

  @override
  Future<List<TripPlan>> getTripPlans() {
    final request = Completer<List<TripPlan>>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ReviewsRepository implements ReviewsRepository {
  final List<Completer<PaginatedUserReviews>> requests = [];

  @override
  Future<PaginatedUserReviews> getUserReviews({
    int page = 1,
    int perPage = 10,
  }) {
    final request = Completer<PaginatedUserReviews>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

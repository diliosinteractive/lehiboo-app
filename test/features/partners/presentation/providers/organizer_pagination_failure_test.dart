import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';
import 'package:lehiboo/features/partners/data/models/organizer_profile_dto.dart';
import 'package:lehiboo/features/partners/domain/repositories/organizer_repository.dart';
import 'package:lehiboo/features/partners/presentation/providers/followed_organizers_providers.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizer_profile_providers.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizer_reviews_providers.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizers_directory_providers.dart';
import 'package:lehiboo/features/reviews/data/models/review_dto.dart';

class _FlakyPaginationRepository implements OrganizerRepository {
  int directoryPageTwoCalls = 0;
  int followedPageTwoCalls = 0;
  int eventsPageTwoCalls = 0;
  int reviewsPageTwoCalls = 0;

  @override
  Future<OrganizerEventsPage> getEvents(
    String identifier, {
    int page = 1,
    int perPage = 12,
  }) async {
    if (page == 1) {
      return OrganizerEventsPage(
        events: const [],
        page: 1,
        perPage: perPage,
        total: 1,
        lastPage: 2,
      );
    }
    eventsPageTwoCalls++;
    if (eventsPageTwoCalls == 1) throw StateError('page failed');
    return OrganizerEventsPage(
      events: const [],
      page: 2,
      perPage: perPage,
      total: 1,
      lastPage: 2,
    );
  }

  @override
  Future<ReviewsResponseDto> getReviews(
    String identifier, {
    int? rating,
    bool verifiedOnly = false,
    String sortBy = 'helpful',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 20,
  }) async {
    if (page == 1) {
      return const ReviewsResponseDto(
        meta: PaginationMetaDto(currentPage: 1, lastPage: 2),
      );
    }
    reviewsPageTwoCalls++;
    if (reviewsPageTwoCalls == 1) throw StateError('page failed');
    return const ReviewsResponseDto(
      meta: PaginationMetaDto(currentPage: 2, lastPage: 2),
    );
  }

  @override
  Future<OrganizersDirectoryPage> getOrganizers({
    String? search,
    String? city,
    String sortBy = 'name',
    String? sortOrder,
    int page = 1,
    int perPage = 20,
  }) async {
    if (page == 1) {
      return const OrganizersDirectoryPage(
        items: [_firstOrganizer],
        page: 1,
        perPage: 20,
        total: 2,
        lastPage: 2,
      );
    }
    directoryPageTwoCalls++;
    if (directoryPageTwoCalls == 1) throw StateError('page failed');
    return const OrganizersDirectoryPage(
      items: [_secondOrganizer],
      page: 2,
      perPage: 20,
      total: 2,
      lastPage: 2,
    );
  }

  @override
  Future<FollowedOrganizersPage> getFollowing({
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    if (page == 1) {
      return const FollowedOrganizersPage(
        items: [_firstOrganizer],
        page: 1,
        perPage: 20,
        total: 2,
        lastPage: 2,
      );
    }
    followedPageTwoCalls++;
    if (followedPageTwoCalls == 1) throw StateError('page failed');
    return const FollowedOrganizersPage(
      items: [_secondOrganizer],
      page: 2,
      perPage: 20,
      total: 2,
      lastPage: 2,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _firstOrganizer = OrganizerProfileDto(
  uuid: 'organizer-1',
  slug: 'first',
  name: 'First',
);

const _secondOrganizer = OrganizerProfileDto(
  uuid: 'organizer-2',
  slug: 'second',
  name: 'Second',
);

void main() {
  test('directory preserves rows and exposes a retry after pagination failure',
      () async {
    final repository = _FlakyPaginationRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      organizersDirectoryControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container.read(organizersDirectoryControllerProvider.future);

    await container
        .read(organizersDirectoryControllerProvider.notifier)
        .loadMore();
    expect(repository.directoryPageTwoCalls, 1);

    var state =
        container.read(organizersDirectoryControllerProvider).valueOrNull!;
    expect(state.items, [_firstOrganizer]);
    expect(state.hasLoadMoreError, isTrue);

    await container
        .read(organizersDirectoryControllerProvider.notifier)
        .loadMore();
    expect(repository.directoryPageTwoCalls, 1);

    await container
        .read(organizersDirectoryControllerProvider.notifier)
        .retryLoadMore();

    state = container.read(organizersDirectoryControllerProvider).valueOrNull!;
    expect(state.items, [_firstOrganizer, _secondOrganizer]);
    expect(state.hasLoadMoreError, isFalse);
  });

  test(
      'followed organizers preserves rows and exposes a retry after pagination failure',
      () async {
    final repository = _FlakyPaginationRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      followedOrganizersControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container.read(followedOrganizersControllerProvider.future);

    await container
        .read(followedOrganizersControllerProvider.notifier)
        .loadMore();
    expect(repository.followedPageTwoCalls, 1);

    var state =
        container.read(followedOrganizersControllerProvider).valueOrNull!;
    expect(state.items, [_firstOrganizer]);
    expect(state.hasLoadMoreError, isTrue);

    await container
        .read(followedOrganizersControllerProvider.notifier)
        .loadMore();
    expect(repository.followedPageTwoCalls, 1);

    await container
        .read(followedOrganizersControllerProvider.notifier)
        .retryLoadMore();

    state = container.read(followedOrganizersControllerProvider).valueOrNull!;
    expect(state.items, [_firstOrganizer, _secondOrganizer]);
    expect(state.hasLoadMoreError, isFalse);
  });

  test('organizer activities exposes a retry after pagination failure',
      () async {
    final repository = _FlakyPaginationRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final provider = organizerEventsControllerProvider('organizer-1');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container.read(provider.future);

    await container.read(provider.notifier).loadMore();
    expect(repository.eventsPageTwoCalls, 1);
    expect(container.read(provider).valueOrNull?.hasLoadMoreError, isTrue);

    await container.read(provider.notifier).loadMore();
    expect(repository.eventsPageTwoCalls, 1);

    await container.read(provider.notifier).retryLoadMore();
    final state = container.read(provider).valueOrNull!;
    expect(state.page, 2);
    expect(state.hasLoadMoreError, isFalse);
  });

  test('organizer reviews exposes a retry after pagination failure', () async {
    final repository = _FlakyPaginationRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final provider = organizerReviewsControllerProvider('organizer-1');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container.read(provider.future);

    await container.read(provider.notifier).loadMore();
    expect(repository.reviewsPageTwoCalls, 1);
    expect(container.read(provider).valueOrNull?.hasLoadMoreError, isTrue);

    await container.read(provider.notifier).loadMore();
    expect(repository.reviewsPageTwoCalls, 1);

    await container.read(provider.notifier).retryLoadMore();
    final state = container.read(provider).valueOrNull!;
    expect(state.page, 2);
    expect(state.hasLoadMoreError, isFalse);
  });
}

ProviderContainer _container(OrganizerRepository repository) {
  return ProviderContainer(
    overrides: [organizerRepositoryProvider.overrideWithValue(repository)],
  );
}

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/checkin/domain/entities/active_organization.dart';
import 'package:lehiboo/features/checkin/presentation/providers/active_organization_provider.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/memberships/data/datasources/memberships_api_datasource.dart';
import 'package:lehiboo/features/memberships/data/models/membership_dto.dart';
import 'package:lehiboo/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:lehiboo/features/memberships/presentation/providers/private_events_provider.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';
import 'package:lehiboo/features/partners/data/models/organizer_profile_dto.dart';
import 'package:lehiboo/features/partners/domain/repositories/organizer_repository.dart';
import 'package:lehiboo/features/partners/presentation/providers/followed_organizers_providers.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizer_profile_providers.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';
import 'package:lehiboo/features/profile/data/datasources/saved_participants_api_datasource.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';
import 'package:lehiboo/features/profile/presentation/providers/profile_provider.dart';
import 'package:lehiboo/features/profile/presentation/providers/saved_participants_provider.dart';

void main() {
  test('late profile stats from account A cannot publish into account B',
      () async {
    final api = _ControlledProfileApi();
    final container = _container([
      profileApiDataSourceProvider.overrideWithValue(api),
    ]);
    addTearDown(container.dispose);
    final subscription = container.listen(
      userStatsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(api.requests, hasLength(1));
    _switchAccount(container, 'user-b');
    await _flush();
    expect(api.requests, hasLength(2));
    expect(container.read(userStatsProvider).valueOrNull, isNull);

    api.requests[1].complete(_stats(22));
    await _flush();
    expect(
      container.read(userStatsProvider).valueOrNull?.bookingsCount,
      22,
    );

    api.requests[0].complete(_stats(11));
    await _flush();
    expect(
      container.read(userStatsProvider).valueOrNull?.bookingsCount,
      22,
    );
  });

  test('saved participants reject old actions and late account A loads',
      () async {
    final api = _ControlledSavedParticipantsApi();
    final container = _container([
      savedParticipantsApiDataSourceProvider.overrideWithValue(api),
    ]);
    addTearDown(container.dispose);
    final subscription = container.listen(
      savedParticipantsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    final oldActions = container.read(savedParticipantsActionsProvider);

    expect(api.listRequests, hasLength(1));
    _switchAccount(container, 'user-b');
    await _flush();
    expect(api.listRequests, hasLength(2));
    expect(container.read(savedParticipantsProvider).valueOrNull, isNull);

    await expectLater(
      oldActions.delete('participant-a'),
      throwsA(isA<StateError>()),
    );
    expect(api.deleteRequests, isEmpty);

    api.listRequests[1].complete([_participant('participant-b')]);
    await _flush();
    api.listRequests[0].complete([_participant('participant-a')]);
    await _flush();
    expect(
      container.read(savedParticipantsProvider).valueOrNull?.single.uuid,
      'participant-b',
    );
  });

  test('an in-flight saved participant mutation cannot reload account B',
      () async {
    final api = _ControlledSavedParticipantsApi();
    final container = _container([
      savedParticipantsApiDataSourceProvider.overrideWithValue(api),
    ]);
    addTearDown(container.dispose);
    final subscription = container.listen(
      savedParticipantsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    api.listRequests.single.complete([_participant('participant-a')]);
    await _flush();
    final oldActions = container.read(savedParticipantsActionsProvider);
    final mutation = oldActions.delete('participant-a');
    expect(api.deleteRequests, hasLength(1));

    _switchAccount(container, 'user-b');
    await _flush();
    api.listRequests[1].complete([_participant('participant-b')]);
    await _flush();

    api.deleteRequests.single.complete();
    await mutation;
    await _flush();
    expect(api.listRequests, hasLength(2));
    expect(
      container.read(savedParticipantsProvider).valueOrNull?.single.uuid,
      'participant-b',
    );
  });

  test('followed organizers ignore late load and old-account rollback',
      () async {
    final repository = _ControlledOrganizerRepository();
    final container = _container([
      organizerRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);
    final subscription = container.listen(
      followedOrganizersControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.pageRequests.single.complete(_organizerPage('organizer-a'));
    await _flush();
    final oldNotifier =
        container.read(followedOrganizersControllerProvider.notifier);
    final mutation = oldNotifier.unfollow('organizer-a');
    final failure = StateError('old-account unfollow failed');

    _switchAccount(container, 'user-b');
    await _flush();
    expect(repository.pageRequests, hasLength(2));
    repository.pageRequests[1].complete(_organizerPage('organizer-b'));
    await _flush();

    repository.unfollowRequests.single.completeError(
      failure,
      StackTrace.current,
    );
    await mutation;
    expect(
      container
          .read(followedOrganizersControllerProvider)
          .valueOrNull
          ?.items
          .single
          .uuid,
      'organizer-b',
    );

    final requestCount = repository.pageRequests.length;
    await oldNotifier.loadMore();
    expect(repository.pageRequests, hasLength(requestCount));
  });

  test('organizer personalized profile ignores account A late response',
      () async {
    final repository = _ControlledOrganizerRepository();
    final container = _container([
      organizerRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);
    final provider = organizerProfileFutureProvider('organizer');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    final oldNotifier = container.read(provider.notifier);

    expect(repository.profileRequests, hasLength(1));
    _switchAccount(container, 'user-b');
    await _flush();
    expect(repository.profileRequests, hasLength(2));
    expect(container.read(provider).valueOrNull, isNull);

    repository.profileRequests[1].complete(
      _organizerProfile('organizer-b', isFollowed: true, followersCount: 20),
    );
    await _flush();
    repository.profileRequests[0].complete(
      _organizerProfile('organizer-a', isFollowed: false, followersCount: 10),
    );
    await _flush();
    expect(container.read(provider).valueOrNull?.uuid, 'organizer-b');
    expect(container.read(provider).valueOrNull?.isFollowed, isTrue);

    final requestCount = repository.profileRequests.length;
    await oldNotifier.refresh();
    expect(repository.profileRequests, hasLength(requestCount));
  });

  test('old organizer follow completion cannot publish or roll back in B',
      () async {
    final repository = _ControlledOrganizerRepository();
    final container = _container([
      organizerRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);
    final provider = followStateControllerProvider('organizer');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.profileRequests.single.complete(
      _organizerProfile('organizer', isFollowed: false, followersCount: 10),
    );
    await _flush();
    final oldNotifier = container.read(provider.notifier);
    final mutation = oldNotifier.toggle();
    expect(repository.followRequests, hasLength(1));
    expect(container.read(provider).valueOrNull?.isFollowed, isTrue);

    _switchAccount(container, 'user-b');
    await _flush();
    expect(repository.profileRequests, hasLength(2));
    repository.profileRequests[1].complete(
      _organizerProfile('organizer', isFollowed: true, followersCount: 20),
    );
    await _flush();

    final failure = StateError('old-account follow failed');
    repository.followRequests.single.completeError(
      failure,
      StackTrace.current,
    );
    await mutation;
    expect(container.read(provider).valueOrNull?.isFollowed, isTrue);
    expect(container.read(provider).valueOrNull?.followersCount, 20);

    await expectLater(oldNotifier.toggle(), throwsA(isA<StateError>()));
    expect(repository.followRequests, hasLength(1));
  });

  test('private event filters reset and late account A pagination is ignored',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container([
      membershipsRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);
    container.read(privateEventsSearchProvider.notifier).state = 'secret-a';
    container.read(privateEventsOrgFilterProvider.notifier).state = 'org-a';
    final subscription = container.listen(
      privateEventsControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final firstPage = repository.requests.single;
    expect(firstPage.search, 'secret-a');
    expect(firstPage.organizationId, 'org-a');
    firstPage.completer.complete(_privateEventsPage('event-a', lastPage: 2));
    await _flush();

    final oldNotifier =
        container.read(privateEventsControllerProvider.notifier);
    final pagination = oldNotifier.loadMore();
    expect(repository.requests.last.page, 2);
    final oldPageTwo = repository.requests.last;

    _switchAccount(container, 'user-b');
    await _flush();
    expect(container.read(privateEventsSearchProvider), isEmpty);
    expect(container.read(privateEventsOrgFilterProvider), isNull);
    final accountBRequest = repository.requests.last;
    expect(accountBRequest.page, 1);
    expect(accountBRequest.search, isEmpty);
    expect(accountBRequest.organizationId, isNull);
    accountBRequest.completer.complete(_privateEventsPage('event-b'));
    await _flush();

    oldPageTwo.completer.complete(_privateEventsPage('event-a-2', page: 2));
    await pagination;
    await _flush();
    expect(
      container
          .read(privateEventsControllerProvider)
          .valueOrNull
          ?.events
          .single
          .uuid,
      'event-b',
    );
  });

  test('anonymous account scope is empty and issues no user requests', () {
    final profileApi = _ControlledProfileApi();
    final participantsApi = _ControlledSavedParticipantsApi();
    final organizerRepository = _ControlledOrganizerRepository();
    final membershipsRepository = _ControlledMembershipsRepository();
    final activeOrgStorage = _ControlledActiveOrganizationStorage();
    final container = _container([
      profileApiDataSourceProvider.overrideWithValue(profileApi),
      savedParticipantsApiDataSourceProvider.overrideWithValue(participantsApi),
      organizerRepositoryProvider.overrideWithValue(organizerRepository),
      membershipsRepositoryProvider.overrideWithValue(membershipsRepository),
      activeOrganizationStorageProvider.overrideWithValue(activeOrgStorage),
    ]);
    addTearDown(container.dispose);
    _switchAccount(container, null);

    final subscriptions = [
      container.listen(userStatsProvider, (_, __) {}, fireImmediately: true),
      container.listen(
        savedParticipantsProvider,
        (_, __) {},
        fireImmediately: true,
      ),
      container.listen(
        followedOrganizersControllerProvider,
        (_, __) {},
        fireImmediately: true,
      ),
      container.listen(
        privateEventsControllerProvider,
        (_, __) {},
        fireImmediately: true,
      ),
      container.listen(
        activeOrganizationProvider,
        (_, __) {},
        fireImmediately: true,
      ),
    ];
    addTearDown(() {
      for (final subscription in subscriptions) {
        subscription.close();
      }
    });

    expect(profileApi.requests, isEmpty);
    expect(participantsApi.listRequests, isEmpty);
    expect(organizerRepository.pageRequests, isEmpty);
    expect(membershipsRepository.requests, isEmpty);
    expect(activeOrgStorage.readRequests, isEmpty);
    expect(container.read(userStatsProvider).valueOrNull?.bookingsCount, 0);
    expect(container.read(savedParticipantsProvider).valueOrNull, isEmpty);
    expect(
      container.read(followedOrganizersControllerProvider).valueOrNull?.items,
      isEmpty,
    );
    expect(
      container.read(privateEventsControllerProvider).valueOrNull?.events,
      isEmpty,
    );
    expect(container.read(activeOrganizationProvider), isNull);
    expect(ActiveOrganizationCache.uuid, isNull);
  });

  test('active organization rehydrate and writes are isolated by account',
      () async {
    final storage = _ControlledActiveOrganizationStorage();
    final container = _container([
      activeOrganizationStorageProvider.overrideWithValue(storage),
    ]);
    addTearDown(container.dispose);
    final subscription = container.listen(
      activeOrganizationProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final accountAKey = activeOrganizationStorageKeyForAccount('user-a');
    final accountBKey = activeOrganizationStorageKeyForAccount('user-b');
    expect(storage.readRequests[accountAKey], hasLength(1));
    final oldNotifier = container.read(activeOrganizationProvider.notifier);

    _switchAccount(container, 'user-b');
    await _flush();
    expect(container.read(activeOrganizationProvider), isNull);
    expect(ActiveOrganizationCache.uuid, isNull);
    expect(storage.readRequests[accountBKey], hasLength(1));

    storage.readRequests[accountBKey]!.single.complete(
      _persistedOrganization('user-b', _organization('org-b')),
    );
    await _flush();
    expect(container.read(activeOrganizationProvider)?.uuid, 'org-b');
    expect(ActiveOrganizationCache.uuid, 'org-b');

    storage.readRequests[accountAKey]!.single.complete(
      _persistedOrganization('user-a', _organization('org-a')),
    );
    await _flush();
    expect(container.read(activeOrganizationProvider)?.uuid, 'org-b');
    expect(ActiveOrganizationCache.uuid, 'org-b');

    await expectLater(
      oldNotifier.set(_organization('stale-org-a')),
      throwsA(isA<StateError>()),
    );
    expect(storage.writes, isEmpty);

    await container
        .read(activeOrganizationProvider.notifier)
        .set(_organization('org-b-2'));
    final persisted =
        jsonDecode(storage.writes.single.value) as Map<String, dynamic>;
    expect(storage.writes.single.key, accountBKey);
    expect(persisted['account_id'], 'user-b');
    expect(
      (persisted['organization'] as Map<String, dynamic>)['uuid'],
      'org-b-2',
    );
  });
}

ProviderContainer _container(List<Override> overrides) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(_MutableAuthNotifier.new),
      ...overrides,
    ],
  );
}

void _switchAccount(ProviderContainer container, String? accountId) {
  (container.read(authProvider.notifier) as _MutableAuthNotifier)
      .publishAccount(accountId);
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

UserStatsDto _stats(int count) => UserStatsDto(
      bookingsCount: count,
      favoritesCount: count,
      reviewsCount: count,
      upcomingEventsCount: count,
    );

SavedParticipant _participant(String uuid) => SavedParticipant(
      uuid: uuid,
      displayName: uuid,
      firstName: uuid,
      lastName: 'Participant',
    );

FollowedOrganizersPage _organizerPage(String uuid) => FollowedOrganizersPage(
      items: [
        OrganizerProfileDto(uuid: uuid, slug: uuid, name: uuid),
      ],
      page: 1,
      perPage: 20,
      total: 1,
      lastPage: 1,
    );

OrganizerProfileDto _organizerProfile(
  String uuid, {
  required bool isFollowed,
  required int followersCount,
}) =>
    OrganizerProfileDto(
      uuid: uuid,
      slug: uuid,
      name: uuid,
      isFollowed: isFollowed,
      followersCount: followersCount,
    );

PrivateEventsPage _privateEventsPage(
  String uuid, {
  int page = 1,
  int lastPage = 1,
}) =>
    PrivateEventsPage(
      events: [EventDto(id: page, uuid: uuid, title: uuid, slug: uuid)],
      page: page,
      perPage: 15,
      total: lastPage,
      lastPage: lastPage,
    );

ActiveOrganization _organization(String uuid) => ActiveOrganization(
      uuid: uuid,
      name: uuid,
      role: MembershipRole.staff,
    );

String _persistedOrganization(
  String accountId,
  ActiveOrganization organization,
) =>
    jsonEncode({
      'account_id': accountId,
      'organization': organization.toJson(),
    });

class _ControlledProfileApi extends ProfileApiDataSource {
  _ControlledProfileApi() : super(Dio());

  final List<Completer<UserStatsDto>> requests = [];

  @override
  Future<UserStatsDto> getStats() {
    final request = Completer<UserStatsDto>();
    requests.add(request);
    return request.future;
  }
}

class _ControlledSavedParticipantsApi extends SavedParticipantsApiDataSource {
  _ControlledSavedParticipantsApi() : super(Dio());

  final List<Completer<List<SavedParticipant>>> listRequests = [];
  final List<Completer<void>> deleteRequests = [];

  @override
  Future<List<SavedParticipant>> list() {
    final request = Completer<List<SavedParticipant>>();
    listRequests.add(request);
    return request.future;
  }

  @override
  Future<void> delete(String uuid) {
    final request = Completer<void>();
    deleteRequests.add(request);
    return request.future;
  }
}

class _ControlledOrganizerRepository implements OrganizerRepository {
  final List<Completer<FollowedOrganizersPage>> pageRequests = [];
  final List<Completer<OrganizerProfileDto>> profileRequests = [];
  final List<Completer<FollowStateDto>> followRequests = [];
  final List<Completer<FollowStateDto>> unfollowRequests = [];

  @override
  Future<OrganizerProfileDto> getProfile(String identifier) {
    final request = Completer<OrganizerProfileDto>();
    profileRequests.add(request);
    return request.future;
  }

  @override
  Future<FollowStateDto> follow(String identifier) {
    final request = Completer<FollowStateDto>();
    followRequests.add(request);
    return request.future;
  }

  @override
  Future<FollowedOrganizersPage> getFollowing({
    String? search,
    int page = 1,
    int perPage = 20,
  }) {
    final request = Completer<FollowedOrganizersPage>();
    pageRequests.add(request);
    return request.future;
  }

  @override
  Future<FollowStateDto> unfollow(String identifier) {
    final request = Completer<FollowStateDto>();
    unfollowRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PrivateEventsRequest {
  _PrivateEventsRequest({
    required this.search,
    required this.organizationId,
    required this.page,
  });

  final String? search;
  final String? organizationId;
  final int page;
  final Completer<PrivateEventsPage> completer = Completer<PrivateEventsPage>();
}

class _ControlledMembershipsRepository implements MembershipsRepository {
  final List<_PrivateEventsRequest> requests = [];

  @override
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 20,
  }) {
    final request = _PrivateEventsRequest(
      search: search,
      organizationId: organizationId,
      page: page,
    );
    requests.add(request);
    return request.completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StorageWrite {
  const _StorageWrite(this.key, this.value);

  final String key;
  final String value;
}

class _ControlledActiveOrganizationStorage
    implements ActiveOrganizationStorage {
  final Map<String, List<Completer<String?>>> readRequests = {};
  final List<_StorageWrite> writes = [];
  final List<String> deletes = [];

  @override
  Future<String?> read({required String key}) {
    final request = Completer<String?>();
    readRequests.putIfAbsent(key, () => []).add(request);
    return request.future;
  }

  @override
  Future<void> write({required String key, required String value}) async {
    writes.add(_StorageWrite(key, value));
  }

  @override
  Future<void> delete({required String key}) async {
    deletes.add(key);
  }
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    publishAccount('user-a');
  }

  void publishAccount(String? accountId) {
    state = accountId == null
        ? const AuthState(status: AuthStatus.unauthenticated)
        : AuthState(
            status: AuthStatus.authenticated,
            user: HbUser(
              id: accountId,
              email: '$accountId@example.test',
              displayName: accountId,
            ),
          );
  }
}

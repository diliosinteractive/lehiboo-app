import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/checkin/data/datasources/managed_organizations_api_datasource.dart';
import 'package:lehiboo/features/checkin/data/models/managed_organization_dto.dart';
import 'package:lehiboo/features/checkin/presentation/providers/managed_organizations_provider.dart';
import 'package:lehiboo/features/memberships/data/datasources/memberships_api_datasource.dart';
import 'package:lehiboo/features/memberships/data/models/invitation_dto.dart';
import 'package:lehiboo/features/memberships/data/models/membership_dto.dart';
import 'package:lehiboo/features/memberships/data/models/personalized_feed_dto.dart';
import 'package:lehiboo/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:lehiboo/features/memberships/presentation/providers/invitation_peek_provider.dart';
import 'package:lehiboo/features/memberships/presentation/providers/membership_content_revision_provider.dart';
import 'package:lehiboo/features/memberships/presentation/providers/membership_state_providers.dart';
import 'package:lehiboo/features/memberships/presentation/providers/memberships_screen_providers.dart';
import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';
import 'package:lehiboo/features/memberships/presentation/providers/private_events_provider.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';
import 'package:lehiboo/features/partners/domain/repositories/organizer_repository.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizer_profile_providers.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';

void main() {
  test('personalized feed clears synchronously at an account boundary',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      personalizedFeedProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.personalizedFeedRequests, hasLength(1));
    final accountALoad =
        container.read(personalizedFeedProvider.notifier).waitForInitialLoad();
    repository.personalizedFeedRequests.single.complete(
      PersonalizedFeedDto.empty(),
    );
    await accountALoad;
    expect(container.read(personalizedFeedProvider).hasValue, isTrue);

    _setAccount(container, 'user-b');
    container.read(personalizedFeedProvider);

    expect(container.read(personalizedFeedProvider).isLoading, isTrue);
    expect(container.read(personalizedFeedProvider).hasValue, isFalse);
    expect(repository.personalizedFeedRequests, hasLength(2));

    repository.personalizedFeedRequests.last.complete(
      PersonalizedFeedDto.empty(),
    );
    await container
        .read(personalizedFeedProvider.notifier)
        .waitForInitialLoad();
  });

  test('membership lists clear immediately and ignore old-account responses',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final membershipsSubscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final invitationsSubscription = container.listen(
      myInvitationsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(membershipsSubscription.close);
    addTearDown(invitationsSubscription.close);

    expect(repository.membershipsRequests, hasLength(1));
    expect(repository.invitationsRequests, hasLength(1));

    repository.membershipsRequests.single.complete(_membershipsPage('org-a'));
    repository.invitationsRequests.single.complete([
      _invitation(1, 'token-a'),
    ]);
    await _flush();
    expect(
      container
          .read(myMembershipsListProvider)
          .requireValue
          .data
          .single
          .organization
          ?.uuid,
      'org-a',
    );
    expect(container.read(myInvitationsProvider).requireValue.single.token,
        'token-a');

    final oldMembershipRefresh =
        container.read(myMembershipsListProvider.notifier).refresh();
    final oldInvitationRefresh =
        container.read(myInvitationsProvider.notifier).refresh();

    _setAccount(container, 'user-b');
    await _flush();

    expect(container.read(myMembershipsListProvider).isLoading, isTrue);
    expect(container.read(myMembershipsListProvider).valueOrNull, isNull);
    expect(container.read(myInvitationsProvider).isLoading, isTrue);
    expect(container.read(myInvitationsProvider).valueOrNull, isNull);
    expect(repository.membershipsRequests, hasLength(3));
    expect(repository.invitationsRequests, hasLength(3));

    repository.membershipsRequests[2].complete(_membershipsPage('org-b'));
    repository.invitationsRequests[2].complete([_invitation(2, 'token-b')]);
    await _flush();

    expect(
      container
          .read(myMembershipsListProvider)
          .requireValue
          .data
          .single
          .organization
          ?.uuid,
      'org-b',
    );
    expect(container.read(myInvitationsProvider).requireValue.single.token,
        'token-b');

    repository.membershipsRequests[1].complete(_membershipsPage('org-a-stale'));
    repository.invitationsRequests[1]
        .complete([_invitation(3, 'token-a-stale')]);
    await Future.wait([oldMembershipRefresh, oldInvitationRefresh]);

    expect(
      container
          .read(myMembershipsListProvider)
          .requireValue
          .data
          .single
          .organization
          ?.uuid,
      'org-b',
    );
    expect(container.read(myInvitationsProvider).requireValue.single.token,
        'token-b');

    _setAccount(container, null);
    await _flush();

    expect(
        container.read(myMembershipsListProvider).requireValue.data, isEmpty);
    expect(container.read(myInvitationsProvider).requireValue, isEmpty);
    expect(repository.membershipsRequests, hasLength(3));
    expect(repository.invitationsRequests, hasLength(3));
  });

  test('rapid A to B to A creates fresh blank membership state', () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final membershipsSubscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final invitationsSubscription = container.listen(
      myInvitationsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(membershipsSubscription.close);
    addTearDown(invitationsSubscription.close);

    repository.membershipsRequests.single.complete(_membershipsPage('org-a'));
    repository.invitationsRequests.single.complete([
      _invitation(1, 'token-a'),
    ]);
    await _flush();

    final firstMembershipsNotifier =
        container.read(myMembershipsListProvider.notifier);
    final firstInvitationsNotifier =
        container.read(myInvitationsProvider.notifier);

    // Do not yield or read either account-scoped provider between these two
    // transitions. The final string id is again `user-a`, but it is a new
    // authenticated session and must not recover the first notifier/cache.
    _setAccount(container, 'user-b');
    _setAccount(container, 'user-a');

    final secondMembershipsNotifier =
        container.read(myMembershipsListProvider.notifier);
    final secondInvitationsNotifier =
        container.read(myInvitationsProvider.notifier);
    expect(identical(secondMembershipsNotifier, firstMembershipsNotifier),
        isFalse);
    expect(identical(secondInvitationsNotifier, firstInvitationsNotifier),
        isFalse);
    expect(container.read(myMembershipsListProvider).isLoading, isTrue);
    expect(container.read(myMembershipsListProvider).valueOrNull, isNull);
    expect(container.read(myInvitationsProvider).isLoading, isTrue);
    expect(container.read(myInvitationsProvider).valueOrNull, isNull);

    final membershipsRequestCount = repository.membershipsRequests.length;
    final invitationsRequestCount = repository.invitationsRequests.length;
    await firstMembershipsNotifier.refresh();
    await firstInvitationsNotifier.refresh();
    expect(repository.membershipsRequests, hasLength(membershipsRequestCount));
    expect(repository.invitationsRequests, hasLength(invitationsRequestCount));

    for (var i = 1; i < repository.membershipsRequests.length; i++) {
      final request = repository.membershipsRequests[i];
      if (!request.isCompleted) request.complete(_membershipsPage('org-$i'));
    }
    for (var i = 1; i < repository.invitationsRequests.length; i++) {
      final request = repository.invitationsRequests[i];
      if (!request.isCompleted) {
        request.complete([_invitation(i + 1, 'token-$i')]);
      }
    }
    await _flush();
  });

  test(
      'membership notifications silently reconcile the cached organizer status',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.membershipsRequests.single.complete(
      _membershipsPage(
        'org-a',
        status: MembershipStatus.pending,
      ),
    );
    await _flush();

    final coordinator = container.read(membershipStateSyncProvider);
    final approvalRefresh = coordinator.reconcileFromNotification(
      'organization_join_approved',
      data: const {'organization_id': 1},
    );
    // A duplicate realtime/push signal shares the active reconciliation.
    final duplicateRefresh = coordinator.reconcileFromNotification(
      'organization_join_approved',
      data: const {'organization_id': 1},
    );

    expect(repository.membershipsRequests, hasLength(2));
    final refreshing = container.read(myMembershipsListProvider);
    expect(refreshing.isLoading, isTrue);
    expect(
      refreshing.valueOrNull?.data.single.status,
      MembershipStatus.pending,
    );

    repository.membershipsRequests.last.complete(
      _membershipsPage(
        'org-a',
        status: MembershipStatus.active,
      ),
    );
    await Future.wait([approvalRefresh, duplicateRefresh]);

    expect(
      container.read(myMembershipsListProvider).requireValue.data.single.status,
      MembershipStatus.active,
    );

    final revokedRefresh = coordinator.reconcileFromNotification(
      'organization_membership_revoked',
      data: const {'organization_id': 1},
    );
    expect(repository.membershipsRequests, hasLength(3));
    repository.membershipsRequests.last.complete(
      const MembershipsPage(data: []),
    );
    await revokedRefresh;

    expect(
      container.read(myMembershipsListProvider).requireValue.data,
      isEmpty,
    );

    await coordinator.reconcileFromNotification('new_message');
    expect(repository.membershipsRequests, hasLength(3));
  });

  test('distinct membership transition in flight gets a trailing fetch',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.membershipsRequests.single.complete(
      _membershipsPage('org-a'),
    );
    await _flush();

    final coordinator = container.read(membershipStateSyncProvider);
    final firstRevocation = coordinator.reconcileFromNotification(
      'organization_membership_revoked',
      data: const {'organization_id': 1},
    );
    final secondRevocation = coordinator.reconcileFromNotification(
      'organization_membership_revoked',
      data: const {'organization_id': 2},
    );

    expect(repository.membershipsRequests, hasLength(2));
    repository.membershipsRequests.last.complete(
      _membershipsPage('org-b'),
    );
    await _flush();

    // The first response may have been captured before the second revocation.
    // A distinct organization therefore requires one trailing reconciliation.
    expect(repository.membershipsRequests, hasLength(3));
    repository.membershipsRequests.last.complete(
      const MembershipsPage(data: []),
    );
    await Future.wait([firstRevocation, secondRevocation]);

    expect(
      container.read(myMembershipsListProvider).requireValue.data,
      isEmpty,
    );
  });

  test('membership notification queues a fetch behind an older initial load',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.membershipsRequests, hasLength(1));
    final reconciliation =
        container.read(membershipStateSyncProvider).reconcileFromNotification(
      'organization_join_approved',
      data: const {'organization_id': 1},
    );

    // The existing request started before the notification, so it cannot be
    // trusted as the reconciliation response.
    expect(repository.membershipsRequests, hasLength(1));
    repository.membershipsRequests.single.complete(
      _membershipsPage(
        'org-a',
        status: MembershipStatus.pending,
      ),
    );
    await _flush();

    expect(repository.membershipsRequests, hasLength(2));
    final trailingRefresh = container.read(myMembershipsListProvider);
    expect(trailingRefresh.isLoading, isTrue);
    expect(
      trailingRefresh.valueOrNull?.data.single.status,
      MembershipStatus.pending,
    );

    repository.membershipsRequests.last.complete(
      _membershipsPage(
        'org-a',
        status: MembershipStatus.active,
      ),
    );
    await reconciliation;

    expect(
      container.read(myMembershipsListProvider).requireValue.data.single.status,
      MembershipStatus.active,
    );
  });

  test('membership reconciliation invalidates membership-gated event caches',
      () async {
    final repository = _ControlledMembershipsRepository();
    final organizerRepository = _ControlledOrganizerRepository();
    final container = _container(
      repository,
      organizerRepository: organizerRepository,
    );
    addTearDown(container.dispose);

    final membershipsSubscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final privateEventsSubscription = container.listen(
      privateEventsControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final organizerEventsProvider = organizerEventsControllerProvider('org-a');
    final organizerEventsSubscription = container.listen(
      organizerEventsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(membershipsSubscription.close);
    addTearDown(privateEventsSubscription.close);
    addTearDown(organizerEventsSubscription.close);

    repository.membershipsRequests.single.complete(
      _membershipsPage(
        'org-a',
        status: MembershipStatus.pending,
      ),
    );
    repository.privateEventsRequests.single.complete(_privateEventsPage());
    organizerRepository.eventsRequests.single.complete(_organizerEventsPage());
    await _flush();

    expect(container.read(membershipContentRevisionProvider), 0);
    final reconciliation =
        container.read(membershipStateSyncProvider).reconcileFromNotification(
      'organization_membership_revoked',
      data: const {'organization_id': 1},
    );
    await _flush();

    expect(container.read(membershipContentRevisionProvider), 1);
    expect(repository.membershipsRequests, hasLength(2));
    expect(repository.privateEventsRequests, hasLength(2));
    expect(organizerRepository.eventsRequests, hasLength(2));

    repository.membershipsRequests.last.complete(
      const MembershipsPage(data: []),
    );
    repository.privateEventsRequests.last.complete(_privateEventsPage());
    organizerRepository.eventsRequests.last.complete(_organizerEventsPage());
    await reconciliation;
    await _flush();

    expect(
      container.read(myMembershipsListProvider).requireValue.data,
      isEmpty,
    );
  });

  test('old and anonymous membership actions cannot issue or publish',
      () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final oldInvitation = container.read(
      invitationActionControllerProvider('token-a').notifier,
    );
    final accepting = oldInvitation.accept(fallbackMessage: 'failed');
    expect(repository.acceptRequests, hasLength(1));

    _setAccount(container, 'user-b');
    repository.acceptRequests.single.complete();
    expect(await accepting, isFalse);
    expect(await oldInvitation.accept(fallbackMessage: 'failed'), isFalse);
    expect(repository.acceptRequests, hasLength(1));

    final oldMembership = container.read(
      membershipActionControllerProvider('org-b').notifier,
    );
    final leaving = oldMembership.cancelOrLeave(fallbackMessage: 'failed');
    expect(repository.cancelRequests, hasLength(1));

    _setAccount(container, 'user-c');
    repository.cancelRequests.single.complete();
    expect(await leaving, isFalse);
    expect(
      await oldMembership.cancelOrLeave(fallbackMessage: 'failed'),
      isFalse,
    );
    expect(repository.cancelRequests, hasLength(1));

    _setAccount(container, null);
    final anonymousInvitation = container.read(
      invitationActionControllerProvider('token-public').notifier,
    );
    final anonymousMembership = container.read(
      membershipActionControllerProvider('org-public').notifier,
    );
    expect(
      await anonymousInvitation.accept(fallbackMessage: 'failed'),
      isFalse,
    );
    expect(
      await anonymousMembership.cancelOrLeave(fallbackMessage: 'failed'),
      isFalse,
    );
    expect(repository.acceptRequests, hasLength(1));
    expect(repository.cancelRequests, hasLength(1));
  });

  test(
      'management invitation refreshes auth and managed organizations '
      'without populating customer memberships', () async {
    final repository = _ControlledMembershipsRepository();
    final profileApi = _ControlledProfileApiDataSource();
    final managedOrganizationsApi =
        _ControlledManagedOrganizationsApiDataSource();
    final container = _container(
      repository,
      profileApi: profileApi,
      managedOrganizationsApi: managedOrganizationsApi,
    );
    addTearDown(container.dispose);
    _setAccount(container, '1');

    final membershipsSubscription = container.listen(
      myMembershipsListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final ownerSession = container.read(authSessionKeyProvider);
    final managedProvider = managedOrganizationsProvider(ownerSession);
    final managedSubscription = container.listen(
      managedProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(membershipsSubscription.close);
    addTearDown(managedSubscription.close);

    repository.membershipsRequests.single.complete(
      const MembershipsPage(data: []),
    );
    managedOrganizationsApi.requests.single.complete(const []);
    await _flush();

    final accepting = container
        .read(invitationActionControllerProvider('staff-token').notifier)
        .accept(
          fallbackMessage: 'failed',
          accessKind: InvitationAccessKind.management,
        );
    repository.acceptRequests.single.complete();
    await _flush();

    expect(profileApi.requests, hasLength(1));
    profileApi.requests.single.complete(
      const UserDto(
        id: 1,
        email: 'user@example.test',
        displayName: 'Vendor User',
        role: 'vendor',
      ),
    );

    expect(await accepting, isTrue);
    await _flush();

    final user = container.read(authProvider).user;
    expect(user?.role, UserRole.partner);
    expect(user?.capabilities.canScanTickets, isTrue);
    expect(repository.membershipsRequests, hasLength(1));
    expect(managedOrganizationsApi.requests, hasLength(2));

    managedOrganizationsApi.requests.last.complete(const []);
    await _flush();
  });

  test(
      'invitation peek replaces authed data per account and uses public API '
      'after logout', () async {
    final repository = _ControlledMembershipsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final provider = invitationPeekProvider('token');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.authedPeekRequests, hasLength(1));
    repository.authedPeekRequests.single.complete(_preview('account-a'));
    await _flush();
    expect(container.read(provider).requireValue.message, 'account-a');

    final oldRefresh = container.read(provider.notifier).refresh();
    _setAccount(container, 'user-b');
    await _flush();

    expect(container.read(provider).isLoading, isTrue);
    expect(container.read(provider).valueOrNull, isNull);
    expect(repository.authedPeekRequests, hasLength(3));

    repository.authedPeekRequests[2].complete(_preview('account-b'));
    await _flush();
    expect(container.read(provider).requireValue.message, 'account-b');

    repository.authedPeekRequests[1].complete(_preview('account-a-stale'));
    await oldRefresh;
    expect(container.read(provider).requireValue.message, 'account-b');

    _setAccount(container, null);
    await _flush();
    expect(container.read(provider).isLoading, isTrue);
    expect(container.read(provider).valueOrNull, isNull);
    expect(repository.publicPeekRequests, hasLength(1));

    repository.publicPeekRequests.single.complete(_preview('public'));
    await _flush();
    expect(container.read(provider).requireValue.message, 'public');
  });
}

ProviderContainer _container(
  MembershipsRepository repository, {
  OrganizerRepository? organizerRepository,
  ProfileApiDataSource? profileApi,
  ManagedOrganizationsApiDataSource? managedOrganizationsApi,
}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(_MutableAuthNotifier.new),
      analyticsServiceProvider.overrideWithValue(
        const NoopAnalyticsService(),
      ),
      membershipsRepositoryProvider.overrideWithValue(repository),
      if (organizerRepository != null)
        organizerRepositoryProvider.overrideWithValue(organizerRepository),
      if (profileApi != null)
        profileApiDataSourceProvider.overrideWithValue(profileApi),
      if (managedOrganizationsApi != null)
        managedOrganizationsApiDataSourceProvider.overrideWithValue(
          managedOrganizationsApi,
        ),
    ],
  );
}

void _setAccount(ProviderContainer container, String? accountId) {
  (container.read(authProvider.notifier) as _MutableAuthNotifier)
      .publishAccount(accountId);
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

MembershipsPage _membershipsPage(
  String organizationUuid, {
  MembershipStatus status = MembershipStatus.active,
}) =>
    MembershipsPage(
      data: [
        MembershipDto(
          id: 1,
          status: status,
          organization: OrganizationSummaryDto(
            uuid: organizationUuid,
            name: organizationUuid,
          ),
        ),
      ],
    );

InvitationDto _invitation(int id, String token) => InvitationDto(
      id: id,
      token: token,
    );

InvitationPreviewDto _preview(String message) =>
    InvitationPreviewDto(message: message);

PrivateEventsPage _privateEventsPage() => const PrivateEventsPage(
      events: [],
      page: 1,
      perPage: 15,
      total: 0,
      lastPage: 1,
    );

OrganizerEventsPage _organizerEventsPage() => const OrganizerEventsPage(
      events: [],
      page: 1,
      perPage: 12,
      total: 0,
      lastPage: 1,
    );

class _ControlledMembershipsRepository implements MembershipsRepository {
  final List<Completer<MembershipsPage>> membershipsRequests = [];
  final List<Completer<List<InvitationDto>>> invitationsRequests = [];
  final List<Completer<InvitationPreviewDto>> authedPeekRequests = [];
  final List<Completer<InvitationPreviewDto>> publicPeekRequests = [];
  final List<Completer<void>> acceptRequests = [];
  final List<Completer<void>> cancelRequests = [];
  final List<Completer<PersonalizedFeedDto>> personalizedFeedRequests = [];
  final List<Completer<PrivateEventsPage>> privateEventsRequests = [];

  @override
  Future<PersonalizedFeedDto> getPersonalizedFeed({int limit = 8}) {
    final request = Completer<PersonalizedFeedDto>();
    personalizedFeedRequests.add(request);
    return request.future;
  }

  @override
  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page = 1,
    int perPage = 15,
  }) {
    final request = Completer<MembershipsPage>();
    membershipsRequests.add(request);
    return request.future;
  }

  @override
  Future<List<InvitationDto>> getMyInvitations() {
    final request = Completer<List<InvitationDto>>();
    invitationsRequests.add(request);
    return request.future;
  }

  @override
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 15,
  }) {
    final request = Completer<PrivateEventsPage>();
    privateEventsRequests.add(request);
    return request.future;
  }

  @override
  Future<InvitationPreviewDto> peekInvitationAuthed(String token) {
    final request = Completer<InvitationPreviewDto>();
    authedPeekRequests.add(request);
    return request.future;
  }

  @override
  Future<InvitationPreviewDto> peekInvitationPublic(String token) {
    final request = Completer<InvitationPreviewDto>();
    publicPeekRequests.add(request);
    return request.future;
  }

  @override
  Future<void> acceptInvitation(String token) {
    final request = Completer<void>();
    acceptRequests.add(request);
    return request.future;
  }

  @override
  Future<void> cancelOrLeaveMembership(String organizationIdentifier) {
    final request = Completer<void>();
    cancelRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ControlledOrganizerRepository implements OrganizerRepository {
  final List<Completer<OrganizerEventsPage>> eventsRequests = [];

  @override
  Future<OrganizerEventsPage> getEvents(
    String identifier, {
    int page = 1,
    int perPage = 12,
  }) {
    final request = Completer<OrganizerEventsPage>();
    eventsRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  Future<void> persistUser(HbUser user) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ControlledProfileApiDataSource extends ProfileApiDataSource {
  _ControlledProfileApiDataSource() : super(Dio());

  final List<Completer<UserDto>> requests = [];

  @override
  Future<UserDto> getProfile() {
    final request = Completer<UserDto>();
    requests.add(request);
    return request.future;
  }
}

class _ControlledManagedOrganizationsApiDataSource
    extends ManagedOrganizationsApiDataSource {
  _ControlledManagedOrganizationsApiDataSource() : super(Dio());

  final List<Completer<List<ManagedOrganizationDto>>> requests = [];

  @override
  Future<List<ManagedOrganizationDto>> getManagedOrganizations() {
    final request = Completer<List<ManagedOrganizationDto>>();
    requests.add(request);
    return request.future;
  }
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

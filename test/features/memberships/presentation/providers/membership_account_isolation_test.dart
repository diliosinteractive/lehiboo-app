import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/memberships/data/models/invitation_dto.dart';
import 'package:lehiboo/features/memberships/data/models/membership_dto.dart';
import 'package:lehiboo/features/memberships/data/models/personalized_feed_dto.dart';
import 'package:lehiboo/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:lehiboo/features/memberships/presentation/providers/invitation_peek_provider.dart';
import 'package:lehiboo/features/memberships/presentation/providers/membership_state_providers.dart';
import 'package:lehiboo/features/memberships/presentation/providers/memberships_screen_providers.dart';
import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';

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

ProviderContainer _container(MembershipsRepository repository) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(_MutableAuthNotifier.new),
      membershipsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

void _setAccount(ProviderContainer container, String? accountId) {
  (container.read(authProvider.notifier) as _MutableAuthNotifier)
      .publishAccount(accountId);
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

MembershipsPage _membershipsPage(String organizationUuid) => MembershipsPage(
      data: [
        MembershipDto(
          id: 1,
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

class _ControlledMembershipsRepository implements MembershipsRepository {
  final List<Completer<MembershipsPage>> membershipsRequests = [];
  final List<Completer<List<InvitationDto>>> invitationsRequests = [];
  final List<Completer<InvitationPreviewDto>> authedPeekRequests = [];
  final List<Completer<InvitationPreviewDto>> publicPeekRequests = [];
  final List<Completer<void>> acceptRequests = [];
  final List<Completer<void>> cancelRequests = [];
  final List<Completer<PersonalizedFeedDto>> personalizedFeedRequests = [];

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

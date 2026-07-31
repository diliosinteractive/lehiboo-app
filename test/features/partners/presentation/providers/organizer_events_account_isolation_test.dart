import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';
import 'package:lehiboo/features/partners/domain/repositories/organizer_repository.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizer_profile_providers.dart';

void main() {
  test('account switch clears organizer events and rejects stale load-more',
      () async {
    final repository = _PendingOrganizerRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    final provider = organizerEventsControllerProvider('organizer');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final firstPageFuture =
        container.read(provider.notifier).waitForInitialLoad();
    expect(repository.requests, hasLength(1));
    repository.requests[0].completer.complete(
      _page('account-a-page-1', page: 1, lastPage: 2),
    );
    await firstPageFuture;

    final oldNotifier = container.read(provider.notifier);
    final staleLoadMore = oldNotifier.loadMore();
    expect(repository.requests, hasLength(2));

    auth.setUser(_accountB);
    final accountBFuture =
        container.read(provider.notifier).waitForInitialLoad();
    final switched = container.read(provider);
    expect(switched.isLoading, isTrue);
    expect(switched.valueOrNull, isNull);
    expect(repository.requests, hasLength(3));

    repository.requests[1].completer.complete(
      _page('stale-account-a-page-2', page: 2, lastPage: 2),
    );
    await staleLoadMore;
    await pumpEventQueue();
    expect(container.read(provider).valueOrNull, isNull);

    repository.requests[2].completer.complete(
      _page('account-b-page-1', page: 1, lastPage: 1),
    );
    await accountBFuture;
    expect(
      container.read(provider).requireValue.events.single.title,
      'account-b-page-1',
    );
  });

  test('organizer events reject A to B to A late responses', () async {
    final repository = _PendingOrganizerRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    final provider = organizerEventsControllerProvider('organizer');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final firstANotifier = container.read(provider.notifier);
    final firstAFuture = firstANotifier.waitForInitialLoad();
    expect(repository.requests, hasLength(1));
    auth.setUser(_accountB);
    final accountBNotifier = container.read(provider.notifier);
    final accountBFuture = accountBNotifier.waitForInitialLoad();
    expect(repository.requests, hasLength(2));
    auth.setUser(_accountA);
    final secondANotifier = container.read(provider.notifier);
    final secondAFuture = secondANotifier.waitForInitialLoad();
    expect(repository.requests, hasLength(3));

    repository.requests[2].completer.complete(
      _page('second-account-a', page: 1, lastPage: 1),
    );
    await secondAFuture;
    repository.requests[1].completer.complete(
      _page('stale-account-b', page: 1, lastPage: 1),
    );
    repository.requests[0].completer.complete(
      _page('stale-first-account-a', page: 1, lastPage: 1),
    );
    await Future.wait([firstAFuture, accountBFuture]);
    await pumpEventQueue();

    expect(
      container.read(provider).requireValue.events.single.title,
      'second-account-a',
    );
  });
}

ProviderContainer _container(
  OrganizerRepository repository,
  void Function(_TestAuthNotifier notifier) captureAuth,
) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _TestAuthNotifier(ref, _accountA);
        captureAuth(notifier);
        return notifier;
      }),
      organizerRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _PendingOrganizerRequest {
  const _PendingOrganizerRequest(this.page, this.completer);

  final int page;
  final Completer<OrganizerEventsPage> completer;
}

class _PendingOrganizerRepository implements OrganizerRepository {
  final requests = <_PendingOrganizerRequest>[];

  @override
  Future<OrganizerEventsPage> getEvents(
    String identifier, {
    int page = 1,
    int perPage = 12,
  }) {
    final completer = Completer<OrganizerEventsPage>();
    requests.add(_PendingOrganizerRequest(page, completer));
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

OrganizerEventsPage _page(
  String title, {
  required int page,
  required int lastPage,
}) {
  return OrganizerEventsPage(
    events: [EventDto(id: page, title: title, slug: title)],
    page: page,
    perPage: 12,
    total: lastPage,
    lastPage: lastPage,
  );
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

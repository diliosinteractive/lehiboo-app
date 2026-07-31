import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_detail_state.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    setUser(_accountA);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _DeferredEventRepository extends Fake implements EventRepository {
  final detailRequests = <Completer<Event>>[];

  @override
  Future<Event> getEvent(String identifier) {
    final request = Completer<Event>();
    detailRequests.add(request);
    return request.future;
  }
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

Event _event(String title) => Event.minimal(
      id: 'private-event',
      slug: 'private-event',
      title: title,
    ).copyWith(isMembersOnly: true);

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  test('a late event-detail response cannot cross from account A to B',
      () async {
    final repository = _DeferredEventRepository();
    late _MutableAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _MutableAuthNotifier(ref);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final ownerA = container.read(authSessionKeyProvider);
    final providerA = eventDetailControllerProvider(
      eventDetailRequest(ownerA, 'private-event'),
    );
    final subscriptionA = container.listen(
      providerA,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscriptionA.close);
    await _flush();
    expect(repository.detailRequests, hasLength(1));

    auth.setUser(_accountB);
    await _flush();
    final ownerB = container.read(authSessionKeyProvider);
    final providerB = eventDetailControllerProvider(
      eventDetailRequest(ownerB, 'private-event'),
    );
    final subscriptionB = container.listen(
      providerB,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscriptionB.close);
    await _flush();
    expect(repository.detailRequests, hasLength(2));

    repository.detailRequests[0].complete(_event('Account A private event'));
    repository.detailRequests[1].complete(_event('Account B private event'));
    await _flush();

    final current = container.read(providerB).requireValue;
    expect(current, isA<EventDetailLoaded>());
    expect(
      (current as EventDetailLoaded).event.title,
      'Account B private event',
    );
    expect(
      container.read(providerA).valueOrNull,
      isNot(isA<EventDetailLoaded>().having(
        (state) => state.event.title,
        'title',
        'Account A private event',
      )),
    );
  });

  test('an A to B to A cycle creates a distinct event-detail cache', () async {
    final repository = _DeferredEventRepository();
    late _MutableAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _MutableAuthNotifier(ref);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final firstOwnerA = container.read(authSessionKeyProvider);
    final firstProviderA = eventDetailControllerProvider(
      eventDetailRequest(firstOwnerA, 'private-event'),
    );
    final firstSubscription = container.listen(
      firstProviderA,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(firstSubscription.close);
    await _flush();

    auth.setUser(_accountB);
    await _flush();
    auth.setUser(_accountA);
    await _flush();
    final secondOwnerA = container.read(authSessionKeyProvider);
    expect(identical(firstOwnerA, secondOwnerA), isFalse);

    final secondProviderA = eventDetailControllerProvider(
      eventDetailRequest(secondOwnerA, 'private-event'),
    );
    final secondSubscription = container.listen(
      secondProviderA,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(secondSubscription.close);
    await _flush();
    expect(repository.detailRequests, hasLength(2));

    final oldController = container.read(firstProviderA.notifier);
    expect(
      oldController.seed(_event('Stale A event'), owner: firstOwnerA),
      isFalse,
    );

    repository.detailRequests[0].complete(_event('Old A response'));
    repository.detailRequests[1].complete(_event('Fresh A response'));
    await _flush();

    final current = container.read(secondProviderA).requireValue;
    expect((current as EventDetailLoaded).event.title, 'Fresh A response');
  });
}

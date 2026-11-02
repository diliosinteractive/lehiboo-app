import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_detail_state.dart';
import 'package:lehiboo/features/events/domain/entities/locked_event_shell.dart';
import 'package:lehiboo/features/events/domain/exceptions/event_password_exceptions.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FixedAuthNotifier extends AuthNotifier {
  _FixedAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    state = const AuthState(status: AuthStatus.authenticated, user: _account);
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

  @override
  Future<Event> verifyEventPassword(String identifier, String password) async =>
      _unlocked;
}

const _account = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _shell = LockedEventShell(uuid: 'protected-event', title: 'Private');

final _unlocked = Event.minimal(
  id: 'protected-event',
  slug: 'protected-event',
  title: 'Private',
).copyWith(description: 'Full programme');

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  final lateAnswers = <String, void Function(Completer<Event>)>{
    'the locked shell': (request) =>
        request.completeError(const EventPasswordRequiredException(_shell)),
    'a stale payload': (request) => request.complete(
          _unlocked.copyWith(description: 'Stale programme'),
        ),
    'a network failure': (request) =>
        request.completeError(Exception('connection timeout')),
  };

  for (final MapEntry(key: answer, value: complete) in lateAnswers.entries) {
    test('a GET answering $answer after the unlock keeps the unlocked event',
        () async {
      final repository = _DeferredEventRepository();
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(_FixedAuthNotifier.new),
          eventRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final owner = container.read(authSessionKeyProvider);
      final provider = eventDetailControllerProvider(
        eventDetailRequest(owner, 'protected-event'),
      );
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      await _flush();
      expect(repository.detailRequests, hasLength(1));

      await container.read(provider.notifier).unlock('secret', owner: owner);
      complete(repository.detailRequests.single);
      await _flush();

      final state = container.read(provider);
      expect(state.hasError, isFalse);
      expect(
        state.requireValue,
        isA<EventDetailLoaded>().having(
          (loaded) => loaded.event.description,
          'description',
          'Full programme',
        ),
      );
    });
  }
}

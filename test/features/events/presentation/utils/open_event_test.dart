import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_detail_state.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart';
import 'package:lehiboo/features/events/presentation/utils/open_event.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

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

/// The backend never remembers an unlock: every plain GET of a protected
/// event answers `password_required` again.
class _ProtectedEventRepository extends Fake implements EventRepository {
  int detailRequests = 0;

  @override
  Future<Event> getEvent(String identifier) {
    detailRequests++;
    return Completer<Event>().future;
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

final _listed = Event.minimal(
  id: 'protected-event',
  slug: 'protected-event',
  title: 'Private evening',
).copyWith(isPasswordProtected: true);

final _unlocked = _listed.copyWith(description: 'Full programme');

class _ListTile extends ConsumerWidget {
  const _ListTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
        onPressed: () => openEvent(
          context,
          ref,
          _listed,
          ownerSession: ref.read(authSessionKeyProvider),
        ),
        child: const Text('open'),
      );
}

/// Stands in for the detail screen: it subscribes to the same controller.
class _DetailProbe extends ConsumerWidget {
  const _DetailProbe(this.identifier);

  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request =
        eventDetailRequest(ref.watch(authSessionKeyProvider), identifier);
    final state = ref.watch(eventDetailControllerProvider(request)).valueOrNull;
    return Scaffold(
      body: Text(switch (state) {
        EventDetailLoaded(:final event) => 'unlocked: ${event.description}',
        EventDetailLocked() => 'locked',
        null => 'loading',
      }),
    );
  }
}

Future<({_ProtectedEventRepository repository, GoRouter router})> _pumpApp(
  WidgetTester tester,
) async {
  final repository = _ProtectedEventRepository();
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const Scaffold(body: _ListTile())),
      GoRoute(
        path: '/event/:id',
        builder: (_, state) => _DetailProbe(state.pathParameters['id']!),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_FixedAuthNotifier.new),
        eventRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
  return (repository: repository, router: router);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _openFromList(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await _settle(tester);
}

Future<void> _submitPassword(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField), 'secret');
  await tester.tap(find.text('Unlock'));
  await _settle(tester);
}

void main() {
  testWidgets(
      'an event unlocked from a list opens without a second password prompt',
      (tester) async {
    final (:repository, router: _) = await _pumpApp(tester);

    await _openFromList(tester);
    final requestsBeforeUnlock = repository.detailRequests;
    await _submitPassword(tester);

    expect(repository.detailRequests, requestsBeforeUnlock,
        reason: 'a fresh GET is answered with password_required again');
    expect(find.text('unlocked: Full programme'), findsOneWidget);
  });

  testWidgets('the unlocked payload is released once the detail is closed',
      (tester) async {
    final (repository: _, :router) = await _pumpApp(tester);
    await _openFromList(tester);
    await _submitPassword(tester);
    final container =
        ProviderScope.containerOf(tester.element(find.byType(Navigator)));
    final provider = eventDetailControllerProvider(
      eventDetailRequest(container.read(authSessionKeyProvider), _listed.id),
    );
    expect(container.exists(provider), isTrue);

    router.pop();
    await _settle(tester);

    expect(container.exists(provider), isFalse);
  });
}

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
import 'package:lehiboo/features/events/domain/entities/locked_event_shell.dart';
import 'package:lehiboo/features/events/domain/exceptions/event_password_exceptions.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart';
import 'package:lehiboo/features/events/presentation/utils/open_event.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_locked_view.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_password_sheet.dart';
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
/// event answers `password_required`.
class _ProtectedEventRepository extends Fake implements EventRepository {
  int passwordChecks = 0;

  @override
  Future<Event> getEvent(String identifier) async =>
      throw const EventPasswordRequiredException(_shell);

  @override
  Future<Event> verifyEventPassword(String identifier, String password) async {
    passwordChecks++;
    return _unlocked;
  }
}

const _account = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _shell =
    LockedEventShell(uuid: 'protected-event', title: 'Private evening');

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

/// The detail screen's state switch, without the loaded body's dependencies.
class _DetailProbe extends ConsumerWidget {
  const _DetailProbe(this.identifier);

  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request =
        eventDetailRequest(ref.watch(authSessionKeyProvider), identifier);
    return switch (
        ref.watch(eventDetailControllerProvider(request)).valueOrNull) {
      EventDetailLoaded(:final event) =>
        Scaffold(body: Text('unlocked: ${event.description}')),
      EventDetailLocked(:final shell) =>
        EventLockedView(shell: shell, identifier: identifier),
      null => const Scaffold(body: Text('loading')),
    };
  }
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('a protected event from a list asks for its password once',
      (tester) async {
    final repository = _ProtectedEventRepository();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: _ListTile()),
        ),
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

    await tester.tap(find.text('open'));
    await _settle(tester);

    expect(find.byType(EventLockedView), findsOneWidget,
        reason: 'the password is asked on the event page, not over the list');
    expect(find.byType(EventPasswordSheet), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'secret');
    await tester.tap(find.text('Unlock'));
    await _settle(tester);

    expect(find.text('unlocked: Full programme'), findsOneWidget);
    expect(find.byType(EventPasswordSheet), findsNothing);
    expect(repository.passwordChecks, 1);
  });
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/data/models/toggle_favorite_result.dart';
import 'package:lehiboo/features/favorites/domain/entities/favorite_list.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref, {HbUser? initialUser})
      : super(_NeverCompletingAuthRepository(), ref) {
    if (initialUser == null) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    } else {
      setUser(initialUser);
    }
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _FavoritesRepository implements FavoritesRepository {
  Completer<ToggleFavoriteResult>? pendingToggle;
  int toggleCalls = 0;

  @override
  Future<List<Event>> getFavorites({String? listId}) async => const [];

  @override
  Future<List<FavoriteList>> getLists() async => const [];

  @override
  Future<ToggleFavoriteResult> toggleFavorite(
    String eventUuid, {
    String? listId,
  }) async {
    toggleCalls++;
    return pendingToggle == null
        ? const ToggleFavoriteResult(isFavorite: true)
        : pendingToggle!.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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

final _event = Event.minimal(
  id: 'private-event',
  slug: 'private-event',
  title: 'Private event',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'late favorite result cannot update UI after A to B to A',
    (tester) async {
      final repository = _FavoritesRepository();
      repository.pendingToggle = Completer<ToggleFavoriteResult>();
      late _MutableAuthNotifier auth;
      var changedCalls = 0;
      final container = _container(repository, (notifier) => auth = notifier);
      addTearDown(container.dispose);
      final ownerA = container.read(authSessionKeyProvider);

      await tester.pumpWidget(
        _app(
          container,
          FavoriteButton(
            event: _event,
            ownerSession: ownerA,
            chooseListOnAdd: false,
            onChanged: (_) => changedCalls++,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();
      expect(repository.toggleCalls, 1);

      auth.setUser(_accountB);
      await tester.pump();
      auth.setUser(_accountA);
      await tester.pump();
      expect(
          identical(container.read(authSessionKeyProvider), ownerA), isFalse);

      repository.pendingToggle!.complete(
        const ToggleFavoriteResult(isFavorite: true),
      );
      await tester.pump();

      expect(changedCalls, 0);
    },
  );

  testWidgets('a stale rendered button cannot start an A to B to A action',
      (tester) async {
    final repository = _FavoritesRepository();
    late _MutableAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    final ownerA = container.read(authSessionKeyProvider);

    await tester.pumpWidget(
      _app(
        container,
        FavoriteButton(
          event: _event,
          ownerSession: ownerA,
          chooseListOnAdd: false,
        ),
      ),
    );
    await tester.pump();

    auth.setUser(_accountB);
    await tester.pump();
    auth.setUser(_accountA);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(repository.toggleCalls, 0);
  });

  testWidgets('guest login adopts the new session once and resumes favorite',
      (tester) async {
    final repository = _FavoritesRepository();
    late _MutableAuthNotifier auth;
    final container = _container(
      repository,
      (notifier) => auth = notifier,
      initialUser: null,
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        Consumer(
          builder: (context, ref, _) => FavoriteButton(
            event: _event,
            ownerSession: ref.watch(authSessionKeyProvider),
            chooseListOnAdd: false,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.byType(GuestRestrictionDialog), findsOneWidget);

    auth.setUser(_accountA);
    await tester.pumpAndSettle();

    expect(find.byType(GuestRestrictionDialog), findsNothing);
    expect(repository.toggleCalls, 1);
  });
}

ProviderContainer _container(
  _FavoritesRepository repository,
  void Function(_MutableAuthNotifier notifier) captureAuth, {
  HbUser? initialUser = _accountA,
}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _MutableAuthNotifier(ref, initialUser: initialUser);
        captureAuth(notifier);
        return notifier;
      }),
      analyticsServiceProvider.overrideWithValue(
        const NoopAnalyticsService(),
      ),
      favoritesRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

Widget _app(ProviderContainer container, Widget body) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: body)),
    ),
  );
}

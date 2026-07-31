import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/favorites/domain/entities/favorite_list.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/create_list_dialog.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/edit_list_dialog.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

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

void main() {
  testWidgets('create-list draft closes after an exact A to B to A cycle',
      (tester) async {
    final repository = _FavoritesRepository();
    late _MutableAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    await tester.pumpWidget(_app(
      container,
      onPressed: (context, ref) => CreateListDialog.show(
        context,
        ownerSession: ref.read(authSessionKeyProvider),
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Account A private list');
    await tester.enterText(fields.at(1), 'Account A private description');

    auth.setUser(_accountB);
    auth.setUser(_accountA);
    await tester.pumpAndSettle();

    expect(find.text('Account A private list'), findsNothing);
    expect(find.text('Account A private description'), findsNothing);
    expect(repository.createCalls, isEmpty);
  });

  testWidgets('edit-list and nested delete confirmation both close on switch',
      (tester) async {
    final repository = _FavoritesRepository();
    late _MutableAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    await tester.pumpWidget(_app(
      container,
      onPressed: (context, ref) => EditListDialog.show(
        context,
        const FavoriteList(
          id: 'account-a-list',
          name: 'Account A secret list',
          description: 'Account A secret description',
        ),
        ownerSession: ref.read(authSessionKeyProvider),
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Account A secret list'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    auth.setUser(_accountB);
    await tester.pumpAndSettle();

    expect(find.text('Account A secret list'), findsNothing);
    expect(find.text('Account A secret description'), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.deleteCalls, isEmpty);
  });

  testWidgets('stale A list payload is not rendered after A to B to A',
      (tester) async {
    final repository = _FavoritesRepository();
    late _MutableAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    final staleOwner = container.read(authSessionKeyProvider);

    auth.setUser(_accountB);
    auth.setUser(_accountA);

    await tester.pumpWidget(_app(
      container,
      onPressed: (context, _) => EditListDialog.show(
        context,
        const FavoriteList(
          id: 'account-a-list',
          name: 'Stale Account A secret list',
          description: 'Stale Account A secret description',
        ),
        ownerSession: staleOwner,
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Stale Account A secret list'), findsNothing);
    expect(find.text('Stale Account A secret description'), findsNothing);
    expect(repository.deleteCalls, isEmpty);
  });
}

ProviderContainer _container(
  _FavoritesRepository repository,
  void Function(_MutableAuthNotifier notifier) captureAuth,
) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _MutableAuthNotifier(ref);
        captureAuth(notifier);
        return notifier;
      }),
      favoritesRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

Widget _app(
  ProviderContainer container, {
  required void Function(BuildContext context, WidgetRef ref) onPressed,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Consumer(
        builder: (context, ref, _) => Scaffold(
          body: TextButton(
            onPressed: () => onPressed(context, ref),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}

class _FavoritesRepository implements FavoritesRepository {
  final createCalls = <String>[];
  final deleteCalls = <String>[];

  @override
  Future<List<FavoriteList>> getLists() async => const [];

  @override
  Future<FavoriteList> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    createCalls.add(name);
    return FavoriteList(id: 'created', name: name);
  }

  @override
  Future<void> deleteList(String listId) async {
    deleteCalls.add(listId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

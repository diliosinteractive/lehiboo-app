import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/features/alerts/domain/entities/alert.dart';
import 'package:lehiboo/features/alerts/domain/repositories/alerts_repository.dart';
import 'package:lehiboo/features/alerts/presentation/screens/alerts_list_screen.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:lehiboo/features/search/presentation/widgets/save_search_sheet.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets('account switch closes and clears a saved-search draft',
      (tester) async {
    final container = _container(_AlertsRepository());
    addTearDown(container.dispose);
    SaveSearchResult? result;

    await tester.pumpWidget(
      _app(
        container,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await SaveSearchSheet.show(
                  context,
                  filter: const EventFilter(),
                  ownerAccountId: 'account-a',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Account A private search');
    expect(find.text('Account A private search'), findsOneWidget);

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.text('Account A private search'), findsNothing);
    expect(find.byType(SaveSearchSheet), findsNothing);
    expect(result, isNull);
  });

  testWidgets('account switch closes alert deletion without deleting',
      (tester) async {
    final repository = _AlertsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(container, home: const AlertsListScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Account A private alert'), findsOneWidget);
    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.deleteCalls, isEmpty);
  });

  testWidgets(
      'stale account A alert tap cannot copy its filter or navigate under B',
      (tester) async {
    final repository = _AlertsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const AlertsListScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (_, __) => const Scaffold(
            body: Text('Search destination'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_routerApp(container, router));
    await tester.pumpAndSettle();

    final staleCard = tester.widget<GestureDetector>(
      find.byKey(const ValueKey('alert-card-alert-a')),
    );
    expect(container.read(eventFilterProvider).searchQuery, isEmpty);

    // Keep the already-rendered A callback, but rotate the provider session to
    // B before invoking it. This is the transition-frame race the UI must deny.
    container.read(_activeAccountProvider.notifier).state = 'account-b';
    staleCard.onTap?.call();

    expect(container.read(eventFilterProvider).searchQuery, isEmpty);
    expect(router.routeInformationProvider.value.uri.path, '/');
    expect(find.text('Search destination'), findsNothing);
  });

  testWidgets('stale account A alert swipe cannot open or delete under B',
      (tester) async {
    final repository = _AlertsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(container, home: const AlertsListScreen()),
    );
    await tester.pumpAndSettle();

    final staleDismissible =
        tester.widget<Dismissible>(find.byType(Dismissible));
    container.read(_activeAccountProvider.notifier).state = 'account-b';

    final confirmed = await staleDismissible.confirmDismiss?.call(
      DismissDirection.endToStart,
    );

    expect(confirmed, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.deleteCalls, isEmpty);
  });
}

ProviderContainer _container(_AlertsRepository repository) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_activeAccountProvider),
      ),
      eventFilterProvider.overrideWith((ref) => EventFilterNotifier()),
      alertsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

Widget _app(ProviderContainer container, {required Widget home}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

Widget _routerApp(ProviderContainer container, GoRouter router) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

class _AlertsRepository implements AlertsRepository {
  final deleteCalls = <String>[];

  @override
  Future<List<Alert>> getAlerts() async => [_alert];

  @override
  Future<Alert> createAlert(
    String name,
    EventFilter filter, {
    bool enablePush = true,
    bool enableEmail = false,
  }) async {
    return _alert;
  }

  @override
  Future<void> deleteAlert(String id) async {
    deleteCalls.add(id);
  }
}

final _alert = Alert(
  id: 'alert-a',
  name: 'Account A private alert',
  filter: const EventFilter(searchQuery: 'private-a'),
  createdAt: DateTime(2026),
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizers_directory_providers.dart';
import 'package:lehiboo/features/partners/presentation/screens/organizers_directory_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  // Signed in, the directory is a Profile page with no bottom nav. Opened
  // directly it has no page under it either: without its own back button,
  // iOS users are stuck.
  testWidgets('the directory opened directly has a back button to home', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/organizers',
      routes: [
        ShellRoute(
          builder: (context, state, child) => child,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const Scaffold(body: Text('Home page')),
            ),
            GoRoute(
              path: '/organizers',
              builder: (context, state) => const OrganizersDirectoryScreen(),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          organizersDirectoryControllerProvider.overrideWith(
            _EmptyDirectory.new,
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Home page'), findsOneWidget);
  });
}

class _EmptyDirectory extends OrganizersDirectoryController {
  @override
  Future<OrganizersDirectoryState> build() async =>
      const OrganizersDirectoryState(
        items: [],
        page: 1,
        lastPage: 1,
        total: 0,
        isLoadingMore: false,
      );
}

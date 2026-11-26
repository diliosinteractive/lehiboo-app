import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/petit_boo/data/models/tool_schema_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/tool_cards/profile_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  setUp(() => AppLocaleCache.setLanguageCode('fr'));

  // The chat sits outside the bottom-nav shell, which is already under it.
  // Pushing /profile, a shell page, from there makes go_router build a second
  // shell with the same page key, and the navigator fails.
  testWidgets('opens the profile from the chat', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
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
              path: '/profile',
              builder: (context, state) =>
                  const Scaffold(body: Text('Profile page')),
            ),
          ],
        ),
        GoRoute(
          path: '/petit-boo',
          builder: (context, state) => const Scaffold(
            body: ProfileCard(
              schema: ToolSchemaDto(
                name: 'getMyProfile',
                displayType: 'profile',
              ),
              data: {'first_name': 'Alice', 'email': 'alice@example.test'},
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    router.push('/petit-boo');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ProfileCard));
    await tester.pumpAndSettle();

    expect(find.text('Profile page'), findsOneWidget);
  });
}

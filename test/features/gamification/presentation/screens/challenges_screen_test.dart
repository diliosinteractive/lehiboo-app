import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:lehiboo/features/gamification/presentation/screens/challenges_screen.dart';
import 'package:lehiboo/features/gamification/presentation/screens/gamification_dashboard_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('shows the localized challenges coming-soon message',
      (tester) async {
    await tester.pumpWidget(_app(const Locale('en')));

    expect(find.text('Challenges'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
    expect(find.text('Challenges will be available soon'), findsOneWidget);
    expect(
      find.text(
        "We're putting the finishing touches on this experience. "
        'Come back soon to take on challenges and earn Hibons.',
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.flag_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the coming-soon content usable on a narrow screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(const Locale('fr')));

    expect(find.text('Bientôt disponible'), findsOneWidget);
    expect(
      find.text('Les challenges seront bientôt disponibles'),
      findsOneWidget,
    );
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens when the Challenges card is tapped', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const GamificationDashboardScreen(),
        ),
        GoRoute(
          path: '/hibons/challenges',
          builder: (context, state) => const ChallengesScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAuthenticatedProvider.overrideWithValue(false),
          gamificationSessionProvider.overrideWithValue(null),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Challenges'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Challenges'));
    await tester.pumpAndSettle();

    expect(find.byType(ChallengesScreen), findsOneWidget);
    expect(find.text('Challenges will be available soon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const ChallengesScreen(),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/core/widgets/main_scaffold.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/checkin/presentation/providers/vendor_eligibility_provider.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _active = Color(0xFFFF601F);

void main() {
  setUp(() => AppLocaleCache.setLanguageCode('fr'));

  group('back on a bottom nav screen', () {
    for (final (signedIn, tab, page) in [
      (true, 'Explorer', 'Explore page'),
      (true, 'Réservations', 'Bookings page'),
      (false, 'Organisateurs', 'Organizers page'),
    ]) {
      testWidgets('$tab returns home, then home leaves the app', (
        tester,
      ) async {
        final shell = await _Shell.pump(tester, signedIn: signedIn);

        await tester.tap(find.text(tab));
        await tester.pumpAndSettle();
        expect(find.text(page), findsOneWidget);
        expect(shell.labelColor(tab), _active);
        expect(shell.labelColor('Accueil'), isNot(_active));

        await shell.systemBack();
        expect(shell.location, '/');
        expect(find.text('Home page'), findsOneWidget);
        expect(shell.labelColor('Accueil'), _active);
        expect(shell.exits, 0, reason: 'Back on a tab must not leave the app.');

        await shell.systemBack();
        expect(shell.exits, 1, reason: 'Back on home leaves the app.');
      });
    }

    testWidgets('a page reached by a link goes home too', (tester) async {
      final shell = await _Shell.pump(tester, initialLocation: '/profile');

      await shell.systemBack();

      expect(shell.location, '/');
      expect(shell.exits, 0);
    });
  });

  // Petit Boo, for one, pushes /profile from outside the shell. When the
  // session started outside the shell (a link to /petit-boo), the shell is
  // then the only page over that screen, and back must return to it.
  group('a shell page opened from a screen outside the shell', () {
    Future<_Shell> openedFromOutside(WidgetTester tester) async {
      final shell = await _Shell.pump(tester, initialLocation: '/outside');
      shell.router.push('/profile');
      await tester.pumpAndSettle();
      expect(find.text('Profile page'), findsOneWidget);
      return shell;
    }

    testWidgets('back returns to that screen', (tester) async {
      final shell = await openedFromOutside(tester);

      await shell.systemBack();

      expect(find.text('Outside page'), findsOneWidget);
      expect(shell.location, '/outside');
    });

    testWidgets(
      'the iOS edge swipe returns to that screen',
      (tester) async {
        final shell = await openedFromOutside(tester);

        await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
        await tester.pumpAndSettle();

        expect(find.text('Outside page'), findsOneWidget);
        expect(shell.location, '/outside');
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );
  });

  group('bottom nav visibility', () {
    testWidgets('the profile opened from home hides it until back on home', (
      tester,
    ) async {
      final shell = await _Shell.pump(tester);

      shell.router.push('/profile');
      await tester.pumpAndSettle();
      expect(find.text('Profile page'), findsOneWidget);
      expect(find.byType(BottomAppBar), findsNothing);

      await shell.systemBack();
      expect(find.text('Home page'), findsOneWidget);
      expect(find.byType(BottomAppBar), findsOneWidget);
      expect(shell.labelColor('Accueil'), _active);
    });

    testWidgets('bookings opened from the profile are a page of the profile', (
      tester,
    ) async {
      final shell = await _Shell.pump(tester);

      shell.router.push('/profile');
      await tester.pumpAndSettle();
      shell.router.push('/my-bookings');
      await tester.pumpAndSettle();
      expect(find.text('Bookings page'), findsOneWidget);
      expect(find.byType(BottomAppBar), findsNothing);

      await shell.systemBack();
      expect(find.text('Profile page'), findsOneWidget);
    });

    testWidgets('the organizers directory is a profile page once signed in', (
      tester,
    ) async {
      final shell = await _Shell.pump(tester, initialLocation: '/organizers');

      expect(find.text('Organizers page'), findsOneWidget);
      expect(find.byType(BottomAppBar), findsNothing);
      expect(shell.exits, 0);
    });

    testWidgets('the map opens over the current tab, back returns to it', (
      tester,
    ) async {
      final shell = await _Shell.pump(tester);

      await tester.tap(find.text('Explorer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Carte'));
      await tester.pumpAndSettle();
      expect(find.text('Map page'), findsOneWidget);

      await shell.systemBack();
      expect(find.text('Explore page'), findsOneWidget);
      expect(shell.labelColor('Explorer'), _active);
    });
  });
}

/// The app's shell (MainScaffold over the bottom nav routes) with stand-in
/// pages, plus the full-screen map pushed above it.
class _Shell {
  _Shell._(this.tester, this.router);

  final WidgetTester tester;
  final GoRouter router;
  int exits = 0;

  static Future<_Shell> pump(
    WidgetTester tester, {
    bool signedIn = true,
    String initialLocation = '/',
  }) async {
    SharedPreferences.setMockInitialValues({
      // Consent already given and Petit Boo already opened today, so neither
      // the consent gate nor the welcome bubble shows up.
      'analytics_consent_status': 'denied',
      'analytics_consent_version': 1,
      'petit_boo_last_click_date': DateTime.now().toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            _page('/', 'Home page'),
            _page('/explore', 'Explore page'),
            _page('/profile', 'Profile page'),
            _page('/my-bookings', 'Bookings page'),
            _page('/organizers', 'Organizers page'),
          ],
        ),
        _page('/map', 'Map page'),
        _page('/outside', 'Outside page'),
      ],
    );
    addTearDown(router.dispose);

    final shell = _Shell._(tester, router);
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') shell.exits++;
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          analyticsServiceProvider.overrideWithValue(
            const NoopAnalyticsService(),
          ),
          isAuthenticatedProvider.overrideWithValue(signedIn),
          vendorEligibilityProvider.overrideWithValue(false),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return shell;
  }

  String get location => router.routeInformationProvider.value.uri.path;

  Color? labelColor(String label) =>
      tester.widget<Text>(find.text(label)).style?.color;

  /// The Android back button or gesture, as the engine sends it.
  Future<void> systemBack() async {
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/navigation',
      const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute')),
      (_) {},
    );
    await tester.pumpAndSettle();
  }
}

GoRoute _page(String path, String title) => GoRoute(
      path: path,
      builder: (context, state) => Scaffold(body: Text(title)),
    );

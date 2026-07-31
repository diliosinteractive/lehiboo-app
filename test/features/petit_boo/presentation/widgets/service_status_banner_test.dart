import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/service_status_banner.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

Widget _app({
  required PetitBooServiceStatus status,
  required VoidCallback onRetry,
}) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: PetitBooServiceStatusBanner(
        status: status,
        onRetry: onRetry,
      ),
    ),
  );
}

void main() {
  testWidgets('check failure shows connectivity guidance and retry',
      (tester) async {
    var retryCount = 0;
    await tester.pumpWidget(
      _app(
        status: PetitBooServiceStatus.checkFailed,
        onRetry: () => retryCount++,
      ),
    );

    expect(
      find.text(
        "We couldn't check whether Petit Boo is available. "
        'Check your internet connection and try again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Petit Boo is temporarily unavailable'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('petit-boo-service-retry')));
    expect(retryCount, 1);
  });

  testWidgets('unhealthy response keeps the service-unavailable guidance',
      (tester) async {
    await tester.pumpWidget(
      _app(
        status: PetitBooServiceStatus.unavailable,
        onRetry: () {},
      ),
    );

    expect(find.text('Petit Boo is temporarily unavailable'), findsOneWidget);
    expect(find.textContaining("couldn't check"), findsNothing);
    expect(
      find.byKey(const ValueKey('petit-boo-service-retry')),
      findsOneWidget,
    );
  });

  testWidgets('checking state replaces retry with progress', (tester) async {
    await tester.pumpWidget(
      _app(
        status: PetitBooServiceStatus.checking,
        onRetry: () {},
      ),
    );

    expect(
        find.text('Checking the connection to Petit Boo...'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('petit-boo-service-checking-progress')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('petit-boo-service-retry')),
      findsNothing,
    );
  });
}

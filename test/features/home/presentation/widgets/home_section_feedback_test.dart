import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/home/presentation/widgets/home_section_feedback.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:lehiboo/l10n/generated/app_localizations_fr.dart';

void main() {
  final l10n = AppLocalizationsFr();

  Widget localizedApp(Widget child) => MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );

  testWidgets('renders an empty message without a retry action',
      (tester) async {
    await tester.pumpWidget(
      localizedApp(
        const HomeSectionFeedback(
          message: 'Aucune activité pour aujourd’hui',
        ),
      ),
    );

    expect(find.text('Aucune activité pour aujourd’hui'), findsOneWidget);
    expect(find.text(l10n.commonRetry), findsNothing);
  });

  testWidgets('awaits retry and prevents duplicate taps', (tester) async {
    final retryCompleter = Completer<void>();
    var retryCount = 0;

    await tester.pumpWidget(
      localizedApp(
        HomeSectionFeedback(
          message: 'Impossible de charger les activités.',
          isError: true,
          onRetry: () {
            retryCount++;
            return retryCompleter.future;
          },
        ),
      ),
    );

    await tester.tap(find.text(l10n.commonRetry));
    await tester.pump();

    expect(retryCount, 1);
    expect(find.text(l10n.commonLoading), findsOneWidget);

    await tester.tap(find.text(l10n.commonLoading));
    await tester.pump();
    expect(retryCount, 1);

    retryCompleter.complete();
    await tester.pumpAndSettle();

    expect(find.text(l10n.commonRetry), findsOneWidget);
  });
}

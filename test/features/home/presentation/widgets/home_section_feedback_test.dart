import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/home/presentation/widgets/home_section_feedback.dart';

void main() {
  testWidgets('renders an empty message without a retry action',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeSectionFeedback(
            message: 'Aucune activité pour aujourd’hui',
          ),
        ),
      ),
    );

    expect(find.text('Aucune activité pour aujourd’hui'), findsOneWidget);
    expect(find.text('Réessayer'), findsNothing);
  });

  testWidgets('awaits retry and prevents duplicate taps', (tester) async {
    final retryCompleter = Completer<void>();
    var retryCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSectionFeedback(
            message: 'Impossible de charger les activités.',
            isError: true,
            onRetry: () {
              retryCount++;
              return retryCompleter.future;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Réessayer'));
    await tester.pump();

    expect(retryCount, 1);
    expect(find.text('Chargement…'), findsOneWidget);

    await tester.tap(find.text('Chargement…'));
    await tester.pump();
    expect(retryCount, 1);

    retryCompleter.complete();
    await tester.pumpAndSettle();

    expect(find.text('Réessayer'), findsOneWidget);
  });
}

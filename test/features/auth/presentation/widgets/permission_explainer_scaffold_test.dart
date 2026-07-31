import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/widgets/permission_explainer_scaffold.dart';

void main() {
  testWidgets('shows a recoverable error and an optional secondary action',
      (tester) async {
    var skipped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PermissionExplainerScaffold(
          icon: Icons.notifications,
          title: 'Notifications',
          intro: 'Intro',
          bullets: const ['One useful alert'],
          reassurance: 'You stay in control.',
          ctaLabel: 'Retry',
          busy: false,
          onContinue: () {},
          errorMessage: 'Setup could not finish.',
          secondaryCtaLabel: 'Not now',
          onSecondaryCta: () => skipped = true,
        ),
      ),
    );

    expect(find.text('Setup could not finish.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);

    await tester.tap(find.text('Not now'));
    expect(skipped, isTrue);
  });
}

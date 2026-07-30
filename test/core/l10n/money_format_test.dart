import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/l10n.dart';

void main() {
  group('API amount text', () {
    test('keeps API decimals and removes only a synthetic whole-number suffix',
        () {
      expect(apiAmountText(5.5), '5.5');
      expect(apiAmountText(14.3), '14.3');
      expect(apiAmountText(5), '5');
      expect(apiAmountText(5.0), '5');
    });

    test('localizes only the decimal separator', () {
      expect(localizedApiAmountText(5.5, 'fr'), '5,5');
      expect(localizedApiAmountText(14.3, 'fr'), '14,3');
      expect(localizedApiAmountText(5.0, 'fr'), '5');

      expect(localizedApiAmountText(5.5, 'en'), '5.5');
      expect(localizedApiAmountText(14.3, 'en'), '14.3');
      expect(localizedApiAmountText(5.0, 'en'), '5');
    });
  });

  group('localized money BuildContext helpers', () {
    testWidgets('renders exact API amounts in French', (tester) async {
      await tester.pumpWidget(
        _localizedApp(
          locale: const Locale('fr'),
          builder: (context) => Text(
            [
              context.appEuroAmount(5.5),
              context.appEuroAmount(14.3),
              context.appEuroAmount(5.0),
            ].join('|'),
          ),
        ),
      );

      expect(find.text('5,5€|14,3€|5€'), findsOneWidget);
    });

    testWidgets('renders exact API amounts in English', (tester) async {
      await tester.pumpWidget(
        _localizedApp(
          locale: const Locale('en'),
          builder: (context) => Text(
            [
              context.appEuroAmount(5.5),
              context.appEuroAmount(14.3),
              context.appEuroAmount(5.0),
            ].join('|'),
          ),
        ),
      );

      expect(find.text('€5.5|€14.3|€5'), findsOneWidget);
    });

    testWidgets(
      'removes floating-point artifacts from calculated French amounts',
      (tester) async {
        const calculatedAmount = 0.1 + 0.2;

        await tester.pumpWidget(
          _localizedApp(
            locale: const Locale('fr'),
            builder: (context) => Text(
              context.appCalculatedEuroAmount(calculatedAmount),
            ),
          ),
        );

        expect(find.text('0,3€'), findsOneWidget);
        expect(find.textContaining('00000000000000004'), findsNothing);
      },
    );

    testWidgets(
      'removes floating-point artifacts from calculated English amounts',
      (tester) async {
        const calculatedAmount = 0.1 + 0.2;

        await tester.pumpWidget(
          _localizedApp(
            locale: const Locale('en'),
            builder: (context) => Text(
              context.appCalculatedEuroAmount(calculatedAmount),
            ),
          ),
        );

        expect(find.text('€0.3'), findsOneWidget);
        expect(find.textContaining('00000000000000004'), findsNothing);
      },
    );
  });
}

Widget _localizedApp({
  required Locale locale,
  required WidgetBuilder builder,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(builder: builder),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_indicative_prices.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('displays indicative service prices', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EventIndicativePrices(
            prices: [
              IndicativePrice(
                uuid: 'price-1',
                label: 'Cloack room',
                price: 0,
                currency: 'EUR',
                sortOrder: 0,
              ),
              IndicativePrice(
                uuid: 'price-2',
                label: 'Massage parlor',
                price: 5,
                currency: 'EUR',
                sortOrder: 1,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Additional services (indicative)'), findsOneWidget);
    expect(find.text('Cloack room'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Massage parlor'), findsOneWidget);
    expect(find.text('5.00 €'), findsOneWidget);
  });
}

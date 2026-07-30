import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_discovery_pricing_section.dart';

Event _discoveryEvent({
  String? pricingType,
  String? priceDetails,
  double? price,
  double? minPrice,
  double? maxPrice,
  List<IndicativePrice> indicativePrices = const [],
}) {
  return Event.minimal(
    id: 'discovery-event',
    slug: 'discovery-event',
    title: 'Discovery event',
  ).copyWith(
    hasDirectBooking: false,
    isDiscovery: true,
    discoveryPricingType: pricingType,
    priceDetails: priceDetails,
    price: price,
    minPrice: minPrice,
    maxPrice: maxPrice,
    indicativePrices: indicativePrices,
  );
}

Future<void> _pumpSection(WidgetTester tester, Event event) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: EventDiscoveryPricingSection(event: event),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() {
    AppLocaleCache.setLanguageCode('fr');
  });

  group('EventDiscoveryPricingSection', () {
    testWidgets('shows the localized API display for a paid event', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'paid',
          priceDetails: '22,00€',
          minPrice: 22,
          maxPrice: 0,
        ),
      );

      expect(find.text('Payant'), findsOneWidget);
      expect(find.text('22,00€'), findsOneWidget);
      expect(find.text('Non définie'), findsNothing);
    });

    testWidgets('falls back to a positive numeric price', (tester) async {
      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'paid',
          priceDetails: '0,00€',
          minPrice: 15.5,
        ),
      );

      expect(find.text('Payant'), findsOneWidget);
      expect(find.text('15,5€'), findsOneWidget);
      expect(find.text('15,50€'), findsNothing);
      expect(find.text('0,00€'), findsNothing);

      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'paid',
          priceDetails: 'Free',
          minPrice: 16,
        ),
      );
      expect(find.text('16€'), findsOneWidget);
      expect(find.text('Free'), findsNothing);
    });

    testWidgets('uses price and max after a non-positive minimum', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'paid',
          minPrice: 0,
          price: 12,
          maxPrice: 25,
        ),
      );
      expect(find.text('12€'), findsOneWidget);

      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'paid',
          minPrice: 0,
          price: 0,
          maxPrice: 25,
        ),
      );
      expect(find.text('25€'), findsOneWidget);
    });

    testWidgets('keeps paid classification when no amount is available', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        _discoveryEvent(pricingType: 'paid'),
      );

      expect(find.text('Payant'), findsOneWidget);
      expect(find.text('Prix non communiqué'), findsOneWidget);
      expect(find.text('Non définie'), findsNothing);
    });

    testWidgets('renders indicative services separately and in sort order', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'paid',
          priceDetails: '20,00€',
          indicativePrices: const [
            IndicativePrice(
              uuid: 'parking',
              label: 'Parking',
              price: 5.5,
              currency: 'EUR',
              sortOrder: 2,
            ),
            IndicativePrice(
              uuid: 'cloakroom',
              label: 'Vestiaire',
              price: 2.5,
              currency: 'EUR',
              sortOrder: 1,
            ),
          ],
        ),
      );

      expect(
        find.text('Prix indicatifs communiqués par l\'organisateur'),
        findsOneWidget,
      );
      expect(find.text('20,00€'), findsOneWidget);
      expect(find.text('2,5€'), findsOneWidget);
      expect(find.text('5,5€'), findsOneWidget);
      expect(find.text('2,50€'), findsNothing);
      expect(find.text('5,50€'), findsNothing);

      final labels = tester
          .widgetList<Text>(find.byType(Text))
          .map((widget) => widget.data)
          .whereType<String>()
          .toList();
      expect(labels.indexOf('Vestiaire'), lessThan(labels.indexOf('Parking')));
    });

    testWidgets('keeps the existing free presentation', (tester) async {
      await _pumpSection(
        tester,
        _discoveryEvent(pricingType: 'free', minPrice: 25),
      );

      expect(find.text('Gratuit'), findsOneWidget);
      expect(find.text('Aucun frais d\'entrée'), findsOneWidget);
      expect(find.text('25€'), findsNothing);
    });

    testWidgets('shows undefined only when classification is missing', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        _discoveryEvent(pricingType: null, minPrice: 20),
      );

      expect(find.text('Non définie'), findsOneWidget);
      expect(find.text('Payant'), findsNothing);
      expect(find.text('20€'), findsNothing);
    });

    testWidgets('does not infer paid from an unknown classification', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        _discoveryEvent(
          pricingType: 'donation',
          priceDetails: '20,00€',
          minPrice: 20,
        ),
      );

      expect(find.text('Non définie'), findsOneWidget);
      expect(find.text('Payant'), findsNothing);
      expect(find.text('20,00€'), findsNothing);
    });
  });
}

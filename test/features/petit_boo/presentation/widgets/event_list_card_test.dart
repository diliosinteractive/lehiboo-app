import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/petit_boo/data/models/tool_schema_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/tool_cards/event_list_card.dart';

const _schema = ToolSchemaDto(
  name: 'searchEvents',
  description: 'Search events',
  displayType: 'event_list',
  responseSchema: ToolResponseSchemaDto(
    itemsKey: 'events',
    totalKey: 'total',
  ),
);

Future<void> _pumpEvent(WidgetTester tester, Map<String, dynamic> event) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: EventListCard(
          schema: _schema,
          data: {
            'events': [event],
            'total': 1,
          },
        ),
      ),
    ),
  );
}

void main() {
  group('Petit Boo event discovery pricing', () {
    testWidgets('shows Gratuit from discovery_pricing_type', (tester) async {
      await _pumpEvent(tester, {
        'title': 'Free discovery',
        'booking_mode': 'discovery',
        'discovery_pricing_type': 'free',
        'is_free': false,
      });

      expect(find.text('Gratuit'), findsOneWidget);
    });

    testWidgets('does not use a contradictory generic free flag', (
      tester,
    ) async {
      await _pumpEvent(tester, {
        'title': 'Paid discovery',
        'bookingMode': 'discovery',
        'discoveryPricingType': 'paid',
        'is_free': true,
        'price_from': 0,
      });

      expect(find.text('Gratuit'), findsNothing);
    });
  });
}

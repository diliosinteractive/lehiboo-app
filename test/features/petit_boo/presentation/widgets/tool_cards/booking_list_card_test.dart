import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/petit_boo/data/models/tool_schema_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/tool_cards/booking_list_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'shows the exact buyer total from numeric and string API values',
    (tester) async {
      AppLocaleCache.setLanguageCode('fr');

      final priceCases = <Map<String, dynamic>>[
        {
          'buyer_total': '5.5',
          'grand_total': 5,
          'total_price': 5,
        },
        {
          'buyerTotal': 5.5,
          'grandTotal': 5,
          'total_amount': 5,
        },
        {
          'grand_total': '5.5',
          'total_price': 5,
        },
        {
          'grandTotal': 5.5,
          'total_amount': 5,
        },
        {'total_price': '5.5'},
        {'total_amount': 5.5},
      ];

      for (final priceFields in priceCases) {
        await tester.pumpWidget(_bookingApp(priceFields));

        expect(find.text('5,5€'), findsOneWidget);
        expect(find.text('5€'), findsNothing);
        expect(find.text('6€'), findsNothing);
      }
    },
  );
}

Widget _bookingApp(Map<String, dynamic> priceFields) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BookingListCard(
        schema: _bookingListSchema,
        data: {
          'bookings': [
            {
              'event_title': 'Atelier créatif',
              'slot_date': '2026-06-10',
              'slot_time': '14:00',
              'tickets_count': 1,
              ...priceFields,
            },
          ],
          'total': 1,
        },
      ),
    ),
  );
}

const _bookingListSchema = ToolSchemaDto(
  name: 'getMyBookings',
  displayType: 'booking_list',
  icon: 'confirmation_number',
  color: '#FF601F',
  title: 'Mes réservations',
  responseSchema: ToolResponseSchemaDto(
    itemsKey: 'bookings',
    totalKey: 'total',
    itemSchema: ToolItemSchemaDto(
      titleField: 'event_title',
      dateField: 'slot_date',
      timeField: 'slot_time',
    ),
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_sticky_booking_bar.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_ticket_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

Event _bookingEvent(double buyerPrice) {
  return Event.minimal(
    id: 'booking-event-$buyerPrice',
    slug: 'booking-event-$buyerPrice',
    title: 'Booking event',
  ).copyWith(
    minPrice: buyerPrice,
    allInclusivePriceFrom: buyerPrice,
  );
}

Widget _localizedApp(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('Event detail booking prices', () {
    for (final testCase in [
      (price: 5.5, expected: '5,5€', padded: '5,50€'),
      (price: 14.3, expected: '14,3€', padded: '14,30€'),
    ]) {
      testWidgets(
        'ticket card preserves API price ${testCase.price}',
        (tester) async {
          await tester.pumpWidget(
            _localizedApp(
              EventTicketCard(
                ticket: Ticket(
                  id: 'ticket-${testCase.price}',
                  name: 'Standard',
                  price: testCase.price,
                  allInclusivePrice: testCase.price,
                ),
                quantity: 0,
                onQuantityChanged: (_) {},
              ),
            ),
          );

          expect(find.text(testCase.expected), findsOneWidget);
          expect(find.text(testCase.padded), findsNothing);
        },
      );

      testWidgets(
        'sticky bar preserves API price ${testCase.price}',
        (tester) async {
          await tester.pumpWidget(
            _localizedApp(
              EventStickyBookingBar(
                event: _bookingEvent(testCase.price),
                ticketQuantities: const {},
                totalPrice: 0,
              ),
            ),
          );

          expect(find.text(testCase.expected), findsOneWidget);
          expect(find.text(testCase.padded), findsNothing);
        },
      );
    }

    testWidgets('sticky bar preserves a selected ticket total of 5.5', (
      tester,
    ) async {
      await tester.pumpWidget(
        _localizedApp(
          EventStickyBookingBar(
            event: _bookingEvent(5.5),
            ticketQuantities: const {'standard': 1},
            totalPrice: 5.5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5,5€'), findsOneWidget);
      expect(find.text('5€'), findsNothing);
      expect(find.text('6€'), findsNothing);
      expect(find.text('5,50€'), findsNothing);
    });
  });
}

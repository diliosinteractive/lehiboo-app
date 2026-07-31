import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_ticket_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

Widget _ticketHarness(Ticket ticket, ValueNotifier<int> quantity) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: quantity,
        builder: (context, value, child) {
          return EventTicketCard(
            ticket: ticket,
            quantity: value,
            onQuantityChanged: (nextQuantity) {
              quantity.value = nextQuantity;
            },
          );
        },
      ),
    ),
  );
}

void main() {
  testWidgets('shows sold-out state and hides quantity controls', (
    tester,
  ) async {
    final quantity = ValueNotifier(0);
    addTearDown(quantity.dispose);
    final ticket = Ticket.fromJson(const {
      'uuid': 'sold-out-ticket',
      'name': 'Standard',
      'price': 5.5,
      'is_available': false,
      'is_sold_out': true,
    });

    await tester.pumpWidget(_ticketHarness(ticket, quantity));

    expect(find.text('Épuisé'), findsOneWidget);
    expect(find.byIcon(Icons.block), findsOneWidget);
    expect(find.byIcon(Icons.event_busy_outlined), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.remove), findsNothing);
  });

  testWidgets('shows unavailable state for contradictory booking limits', (
    tester,
  ) async {
    final quantity = ValueNotifier(0);
    addTearDown(quantity.dispose);
    const ticket = Ticket(
      id: 'contradictory-ticket',
      name: 'Standard',
      price: 5.5,
      minPerBooking: 5,
      maxPerBooking: 1,
      isAvailable: true,
      isSoldOut: false,
    );

    await tester.pumpWidget(_ticketHarness(ticket, quantity));

    expect(find.byIcon(Icons.event_busy_outlined), findsOneWidget);
    expect(find.text('Épuisé'), findsNothing);
    expect(find.byIcon(Icons.block), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.remove), findsNothing);
  });

  testWidgets('selects the minimum from zero and decrements it back to zero', (
    tester,
  ) async {
    final quantity = ValueNotifier(0);
    addTearDown(quantity.dispose);
    const ticket = Ticket(
      id: 'minimum-ticket',
      name: 'Standard',
      price: 5.5,
      minPerBooking: 3,
      maxPerBooking: 5,
    );

    await tester.pumpWidget(_ticketHarness(ticket, quantity));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(quantity.value, 3);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(quantity.value, 0);
  });

  testWidgets('never increments beyond the remaining-stock cap', (
    tester,
  ) async {
    final quantity = ValueNotifier(0);
    addTearDown(quantity.dispose);
    const ticket = Ticket(
      id: 'stock-capped-ticket',
      name: 'Standard',
      price: 5.5,
      minPerBooking: 1,
      maxPerBooking: 10,
      remainingPlaces: 2,
    );

    await tester.pumpWidget(_ticketHarness(ticket, quantity));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(quantity.value, 1);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(quantity.value, 2);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(quantity.value, 2);
  });
}

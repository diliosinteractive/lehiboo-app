import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/booking/presentation/widgets/cart_summary_section.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

void main() {
  testWidgets('formats cart recap slot times without seconds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartSummarySection(
            items: [
              OrderCartItem(
                event: Event.minimal(
                  id: 'event-1',
                  slug: 'event-1',
                  title: 'Atelier',
                  organizerName: 'Le Hiboo',
                ),
                slotId: 'slot-1',
                selectedSlot: _slot(startTime: '09:30:00'),
                ticket: const Ticket(
                  id: 'ticket-1',
                  name: 'Standard',
                  price: 12,
                ),
                quantity: 1,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('10/05/2026 · 09:30'), findsOneWidget);
    expect(find.textContaining('09:30:00'), findsNothing);
  });
}

CalendarDateSlot _slot({required String startTime}) {
  return CalendarDateSlot(
    id: 'slot-1',
    date: DateTime(2026, 5, 10),
    startTime: startTime,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_list_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

Booking _booking(double price) {
  return Booking(
    id: 'booking-$price',
    userId: 'user-1',
    slotId: 'slot-1',
    activityId: 'event-1',
    quantity: 1,
    totalPrice: price,
    status: 'confirmed',
    activity: const Activity(
      id: 'event-1',
      title: 'Booking event',
      slug: 'booking-event',
      description: '',
    ),
  );
}

Future<void> _pumpCard(WidgetTester tester, double price) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: BookingListCard(
          booking: _booking(price),
          onTap: () {},
        ),
      ),
    ),
  );
}

void main() {
  group('BookingListCard price', () {
    for (final testCase in [
      (price: 5.5, expected: '5,5€', rounded: '6€'),
      (price: 14.3, expected: '14,3€', rounded: '14€'),
    ]) {
      testWidgets(
        'preserves API decimal ${testCase.price}',
        (tester) async {
          await _pumpCard(tester, testCase.price);

          expect(find.text(testCase.expected), findsOneWidget);
          expect(find.text(testCase.rounded), findsNothing);
        },
      );
    }

    testWidgets('does not add a synthetic decimal to whole prices', (
      tester,
    ) async {
      await _pumpCard(tester, 55);

      expect(find.text('55€'), findsOneWidget);
      expect(find.text('55,0€'), findsNothing);
    });
  });
}

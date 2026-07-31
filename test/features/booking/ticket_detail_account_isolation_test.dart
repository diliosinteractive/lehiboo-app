import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/presentation/screens/ticket_detail_screen.dart';
import 'package:lehiboo/features/booking/presentation/widgets/fullscreen_qr_sheet.dart';
import 'package:lehiboo/features/booking/presentation/widgets/large_qr_code.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _sessionUserIdProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets(
    'hides ticket data and closes a full-screen QR after an account switch',
    (tester) async {
      const ticket = Ticket(
        id: 'ticket-a',
        bookingId: 'booking-a',
        userId: 'account-a',
        slotId: 'slot-a',
        ticketType: 'Private VIP ticket',
        qrCodeData: 'private-account-a-qr',
        status: 'active',
        attendeeFirstName: 'Alice',
        attendeeLastName: 'Account A',
        attendeeEmail: 'alice@example.test',
      );
      const booking = Booking(
        id: 'booking-a',
        userId: 'account-a',
        slotId: 'slot-a',
        activityId: 'event-a',
        activity: Activity(
          id: 'event-a',
          slug: 'account-a-event',
          title: 'Account A private event',
          description: '',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authSessionUserIdProvider.overrideWith(
              (ref) => ref.watch(_sessionUserIdProvider),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: TicketDetailScreen(
              ticketId: ticket.id,
              ticket: ticket,
              booking: booking,
              initialDataOwnerAccountId: 'account-a',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Account A private event'), findsOneWidget);
      expect(find.text('private-account-a-qr'), findsOneWidget);

      await tester.tap(find.byType(LargeQRCode));
      await tester.pumpAndSettle();
      expect(find.byType(FullscreenQRSheet), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(TicketDetailScreen)),
      );
      container.read(_sessionUserIdProvider.notifier).state = 'account-b';
      await tester.pumpAndSettle();

      expect(find.byType(FullscreenQRSheet), findsNothing);
      expect(find.text('Account A private event'), findsNothing);
      expect(find.text('private-account-a-qr'), findsNothing);
      expect(find.text('Alice Account A'), findsNothing);
      expect(find.text('Ticket not found'), findsOneWidget);
    },
  );

  testWidgets('does not turn a ticket identifier into QR data', (tester) async {
    const ticket = Ticket(
      id: 'real-ticket-id-is-not-a-qr-payload',
      bookingId: 'booking-a',
      userId: 'account-a',
      slotId: 'slot-a',
      qrCodeData: '   ',
      status: 'active',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionUserIdProvider.overrideWith(
            (ref) => ref.watch(_sessionUserIdProvider),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: TicketDetailScreen(
            ticketId: ticket.id,
            ticket: ticket,
            initialDataOwnerAccountId: 'account-a',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LargeQRCode), findsNothing);
    expect(
      find.text(
        'This ticket is still being generated. Please try again in a moment.',
      ),
      findsOneWidget,
    );
    expect(find.text(ticket.id), findsNothing);
  });
}

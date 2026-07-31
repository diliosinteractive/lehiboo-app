import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/data/models/booking_api_dto.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/screens/booking_detail_screen.dart';
import 'package:lehiboo/features/booking/presentation/widgets/ticket_preview_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _testSessionUserIdProvider = StateProvider<String?>((ref) => 'user-a');

void main() {
  testWidgets('uses detail lookup and renders a true 404 as not found',
      (tester) async {
    final repository = _DetailRepository(result: null);

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(repository.detailCalls, 1);
    expect(repository.listCalls, 0);
    expect(find.text('Booking not found'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('renders a load failure with retry instead of not found',
      (tester) async {
    final repository = _DetailRepository(
      error: Exception('Booking service temporarily unavailable.'),
    );

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(repository.detailCalls, 1);
    expect(repository.listCalls, 0);
    expect(find.text('Booking not found'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
    expect(
      find.textContaining('Booking service temporarily unavailable.'),
      findsOneWidget,
    );
  });

  testWidgets('uses the booking-specific fallback for unsafe failures',
      (tester) async {
    final repository = _DetailRepository(
      error: StateError('internal parser detail'),
    );

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Booking not found'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
    expect(
      find.textContaining(
        "We couldn't load this booking. Check your connection and try again.",
      ),
      findsOneWidget,
    );
    expect(find.textContaining('internal parser detail'), findsNothing);
  });

  testWidgets(
      'does not render embedded or synthetic tickets while real tickets load',
      (tester) async {
    final ticketsCompleter = Completer<List<BookingTicketDto>>();
    final dataSource = _TicketDataSource(
      (_) => ticketsCompleter.future,
    );
    const embeddedTicket = Ticket(
      id: 'booking-uuid_ticket_0',
      bookingId: 'booking-uuid',
      userId: 'user-a',
      slotId: 'slot-1',
      qrCodeData: 'fabricated-qr-payload',
      status: 'active',
    );

    await tester.pumpWidget(
      _app(
        _DetailRepository(),
        dataSource: dataSource,
        initialBooking: _booking(tickets: [embeddedTicket]),
      ),
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Generating your tickets...'),
      300,
    );

    expect(find.text('Generating your tickets...'), findsOneWidget);
    expect(find.byType(TicketPreviewCard), findsNothing);

    ticketsCompleter.complete(const []);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Your tickets are still being generated. Please try again in a moment.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('booking-tickets-retry')), findsOneWidget);
    expect(find.byType(TicketPreviewCard), findsNothing);
  });

  testWidgets('renders only UUID and QR data returned by the ticket endpoint',
      (tester) async {
    final dataSource = _TicketDataSource(
      (_) async => [
        _ticket(
          id: 'legacy-ticket-id',
          uuid: 'real-ticket-uuid',
          qrCode: 'signed-api-qr-payload',
        ),
      ],
    );

    await tester.pumpWidget(
      _app(
        _DetailRepository(),
        dataSource: dataSource,
        initialBooking: _booking(
          tickets: const [
            Ticket(
              id: 'synthetic-ticket-id',
              bookingId: 'booking-uuid',
              userId: 'user-a',
              slotId: 'slot-1',
              qrCodeData: 'fabricated-qr-payload',
              status: 'active',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(TicketPreviewCard), 300);

    final card = tester.widget<TicketPreviewCard>(
      find.byType(TicketPreviewCard),
    );
    expect(card.ticket.id, 'real-ticket-uuid');
    expect(card.ticket.qrCodeData, 'signed-api-qr-payload');
    expect(card.ticket.status, 'active');
    expect(card.ticket.id, isNot('synthetic-ticket-id'));
  });

  testWidgets('shows a safe ticket failure and retries independently',
      (tester) async {
    var attempts = 0;
    final dataSource = _TicketDataSource((_) async {
      attempts++;
      if (attempts == 1) {
        throw StateError('database host and internal parser details');
      }
      return [_ticket()];
    });

    await tester.pumpWidget(
      _app(
        _DetailRepository(),
        dataSource: dataSource,
        initialBooking: _booking(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Could not load tickets'), 300);

    expect(find.text('Could not load tickets'), findsOneWidget);
    expect(find.textContaining('database host'), findsNothing);
    expect(find.byType(TicketPreviewCard), findsNothing);

    await tester.tap(find.byKey(const Key('booking-tickets-retry')));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.byType(TicketPreviewCard), findsOneWidget);
    expect(find.text('Could not load tickets'), findsNothing);
  });

  testWidgets('ignores a booking detail response from the previous account',
      (tester) async {
    final oldRequest = Completer<Booking?>();
    final newRequest = Completer<Booking?>();
    var calls = 0;
    final repository = _DetailRepository(
      loader: (_) => calls++ == 0 ? oldRequest.future : newRequest.future,
    );

    await tester.pumpWidget(_app(repository));
    await tester.pump();
    expect(repository.detailCalls, 1);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(BookingDetailScreen)),
    );
    container.read(_testSessionUserIdProvider.notifier).state = 'user-b';
    await tester.pump();
    await tester.pump();
    expect(repository.detailCalls, 2);

    oldRequest.complete(_booking(title: 'Old account booking'));
    await tester.pump();
    expect(find.text('Old account booking'), findsNothing);

    newRequest.complete(
      _booking(
        title: 'New account booking',
        status: 'pending',
        userId: 'user-b',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Old account booking'), findsNothing);
    expect(find.text('New account booking'), findsOneWidget);
  });

  testWidgets('clears tickets and ignores their response after account switch',
      (tester) async {
    final oldTickets = Completer<List<BookingTicketDto>>();
    final dataSource = _TicketDataSource((_) => oldTickets.future);
    final repository = _DetailRepository(
      result: _booking(
        title: 'New account booking',
        status: 'pending',
        userId: 'user-b',
      ),
    );

    await tester.pumpWidget(
      _app(
        repository,
        dataSource: dataSource,
        initialBooking: _booking(title: 'Old account booking'),
      ),
    );
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(BookingDetailScreen)),
    );
    container.read(_testSessionUserIdProvider.notifier).state = 'user-b';
    await tester.pump();
    await tester.pumpAndSettle();

    oldTickets.complete([_ticket()]);
    await tester.pumpAndSettle();

    expect(find.byType(TicketPreviewCard), findsNothing);
    expect(find.text('Old account booking'), findsNothing);
    expect(find.text('New account booking'), findsOneWidget);
  });
}

Widget _app(
  BookingRepository repository, {
  BookingApiDataSource? dataSource,
  Booking? initialBooking,
}) {
  return ProviderScope(
    overrides: [
      bookingRepositoryProvider.overrideWithValue(repository),
      bookingApiDataSourceProvider.overrideWithValue(
        dataSource ?? _TicketDataSource((_) async => const []),
      ),
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_testSessionUserIdProvider),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: BookingDetailScreen(
        bookingId: 'booking-uuid',
        initialBooking: initialBooking,
        initialBookingOwnerAccountId: initialBooking == null ? null : 'user-a',
      ),
    ),
  );
}

class _DetailRepository extends Fake implements BookingRepository {
  _DetailRepository({this.result, this.error, this.loader});

  final Booking? result;
  final Object? error;
  final Future<Booking?> Function(String bookingId)? loader;
  int detailCalls = 0;
  int listCalls = 0;

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    detailCalls++;
    if (loader != null) return loader!(bookingId);
    if (error != null) throw error!;
    return result;
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    listCalls++;
    return const [];
  }
}

class _TicketDataSource extends BookingApiDataSource {
  _TicketDataSource(this.loader) : super(Dio());

  final Future<List<BookingTicketDto>> Function(String bookingUuid) loader;
  int calls = 0;

  @override
  Future<List<BookingTicketDto>> getBookingTickets({
    required String bookingUuid,
  }) {
    calls++;
    return loader(bookingUuid);
  }
}

Booking _booking({
  String title = 'Test event',
  String status = 'confirmed',
  String userId = 'user-a',
  List<Ticket>? tickets,
}) {
  return Booking(
    id: 'booking-uuid',
    userId: userId,
    slotId: 'slot-1',
    activityId: 'event-1',
    quantity: 1,
    status: status,
    tickets: tickets,
    activity: Activity(
      id: 'event-1',
      title: title,
      slug: 'test-event',
      description: '',
    ),
  );
}

BookingTicketDto _ticket({
  String id = 'real-ticket-id',
  String? uuid,
  String qrCode = 'real-qr-payload',
}) {
  return BookingTicketDto(
    id: id,
    uuid: uuid,
    qrCode: qrCode,
    status: 'active',
    attendeeFirstName: 'Ada',
    attendeeLastName: 'Lovelace',
    attendeeEmail: 'ada@example.test',
  );
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/data/models/booking_api_dto.dart';
import 'package:lehiboo/features/booking/data/models/order_api_dto.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/screens/booking_success_screen.dart';
import 'package:lehiboo/features/booking/presentation/screens/order_success_screen.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

final _sessionUserIdProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets('late ticket polling cannot populate a different account',
      (tester) async {
    final ticketResponse = Completer<List<BookingTicketDto>>();
    final dataSource = _ControlledTicketDataSource(
      () => ticketResponse.future,
    );

    await tester.pumpWidget(
      _app(
        BookingSuccessScreen(
          bookingId: 'booking-a',
          event: _bookingEvent('Account A private event'),
          initialDataOwnerAccountId: 'account-a',
        ),
        dataSource: dataSource,
      ),
    );
    await tester.pump();
    expect(dataSource.calls, 1);
    expect(find.text('Account A private event'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(BookingSuccessScreen)),
    );
    container.read(_sessionUserIdProvider.notifier).state = 'account-b';
    await tester.pump();

    ticketResponse.complete([
      _ticket(qrCode: 'private-account-a-qr'),
    ]);
    await tester.pump();

    expect(
      find.byKey(const Key('booking-success-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('Account A private event'), findsNothing);
    expect(find.text('private-account-a-qr'), findsNothing);
    expect(find.byType(QrImageView), findsNothing);
  });

  testWidgets('rejects stale success extras reconstructed for another account',
      (tester) async {
    final dataSource = _ControlledTicketDataSource(
      () async => [_ticket(qrCode: '   ')],
    );
    const staleOrder = CreateOrderResponseDto(
      uuid: 'secret-order-a',
      status: 'confirmed',
      totalAmount: 25,
      bookings: [
        OrderBookingDto(
          uuid: 'secret-booking-a',
          eventTitle: 'Account A secret order event',
          totalAmount: 25,
        ),
      ],
    );

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            Expanded(
              child: BookingSuccessScreen(
                bookingId: 'route-booking',
                bookingResponse: const CreateBookingResponseDto(
                  uuid: 'secret-booking-a',
                  status: 'confirmed',
                  totalAmount: 25,
                  reference: 'SECRET-A-REFERENCE',
                ),
                event: _bookingEvent('Account A secret booking event'),
                initialDataOwnerAccountId: 'account-a',
              ),
            ),
            const Expanded(
              child: OrderSuccessScreen(
                orderId: 'route-order',
                order: staleOrder,
                initialDataOwnerAccountId: 'account-a',
              ),
            ),
          ],
        ),
        dataSource: dataSource,
        initialSessionUserId: 'account-b',
      ),
    );
    await tester.pumpAndSettle();

    expect(dataSource.calls, 0);
    expect(
      find.byKey(const Key('booking-success-session-invalid')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('order-success-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('Account A secret booking event'), findsNothing);
    expect(find.text('SECRET-A-REFERENCE'), findsNothing);
    expect(find.text('Account A secret order event'), findsNothing);
    expect(find.text('secret-booking-a'), findsNothing);
    expect(find.text('secret-order-a'), findsNothing);
    expect(find.textContaining('route-booking'), findsNothing);
    expect(find.textContaining('route-order'), findsNothing);
    expect(find.byType(QrImageView), findsNothing);
  });

  test('an old booking flow does not confirm after the account changes',
      () async {
    final repository = _ControlledBookingRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_sessionUserIdProvider),
        ),
        bookingRepositoryProvider.overrideWithValue(repository),
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final provider = bookingFlowControllerProvider(_activity('Booking flow'));
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    final controller = container.read(provider.notifier);
    controller.selectSlot(_slot);
    controller.updateBuyerInfo(
      const BuyerInfo(
        firstName: 'Alice',
        lastName: 'Account A',
        email: 'alice@example.test',
      ),
    );
    await controller.goToPaymentStep();

    final submission =
        controller.submitPaidBooking(paymentIntentId: 'payment-a');
    await Future<void>.delayed(Duration.zero);
    expect(repository.createCalls, 1);

    container.read(_sessionUserIdProvider.notifier).state = 'account-b';
    await Future<void>.delayed(Duration.zero);
    repository.createResponse.complete(_booking('booking-a'));
    await submission;

    expect(repository.confirmCalls, 0);
    expect(container.read(provider).confirmedBooking, isNull);
    expect(container.read(provider).tickets, isNull);
  });
}

Widget _app(
  Widget home, {
  required BookingApiDataSource dataSource,
  String initialSessionUserId = 'account-a',
}) {
  return ProviderScope(
    overrides: [
      _sessionUserIdProvider.overrideWith(
        (ref) => initialSessionUserId,
      ),
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_sessionUserIdProvider),
      ),
      bookingApiDataSourceProvider.overrideWithValue(dataSource),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: home,
    ),
  );
}

final _slot = Slot(
  id: 'slot-a',
  activityId: 'event-a',
  startDateTime: DateTime(2026, 8),
  endDateTime: DateTime(2026, 8, 1, 1),
  priceMin: 10,
);

Activity _activity(String title) => Activity(
      id: 'event-a',
      title: title,
      slug: 'event-a',
      description: '',
      priceMin: 10,
      nextSlot: _slot,
    );

Event _bookingEvent(String title) => Event.minimal(
      id: 'event-a',
      slug: 'event-a',
      title: title,
    );

Booking _booking(String id) => Booking(
      id: id,
      userId: 'account-a',
      slotId: 'slot-a',
      activityId: 'event-a',
      status: 'pending',
    );

BookingTicketDto _ticket({required String qrCode}) => BookingTicketDto(
      id: 'ticket-a',
      qrCode: qrCode,
      status: 'active',
    );

class _ControlledTicketDataSource extends BookingApiDataSource {
  _ControlledTicketDataSource(this.response) : super(Dio());

  final Future<List<BookingTicketDto>> Function() response;
  int calls = 0;

  @override
  Future<List<BookingTicketDto>> getBookingTickets({
    required String bookingUuid,
  }) {
    calls++;
    return response();
  }
}

class _ControlledBookingRepository implements BookingRepository {
  final createResponse = Completer<Booking>();
  int createCalls = 0;
  int confirmCalls = 0;

  @override
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required List<TicketSelection> ticketSelections,
    required BuyerInfo buyer,
    bool acceptTerms = false,
    bool acceptRefundPolicy = false,
    bool acceptNewsletter = false,
    String? promoCode,
  }) {
    createCalls++;
    return createResponse.future;
  }

  @override
  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  }) async {
    confirmCalls++;
    return _booking(bookingId).copyWith(status: 'confirmed');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

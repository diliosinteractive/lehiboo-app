import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/screens/booking_detail_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

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
}

Widget _app(BookingRepository repository) {
  return ProviderScope(
    overrides: [
      bookingRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: const BookingDetailScreen(bookingId: 'booking-uuid'),
    ),
  );
}

class _DetailRepository extends Fake implements BookingRepository {
  _DetailRepository({this.result, this.error});

  final Booking? result;
  final Object? error;
  int detailCalls = 0;
  int listCalls = 0;

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    detailCalls++;
    if (error != null) throw error!;
    return result;
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    listCalls++;
    return const [];
  }
}

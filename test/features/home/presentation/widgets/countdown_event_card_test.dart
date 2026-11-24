import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/widgets/countdown_event_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'urgency cards use discovery pricing type instead of zero prices',
    (tester) async {
      final now = DateTime(2026, 11, 24, 10);
      final events = [
        _event(
          id: 'authoritatively-free',
          start: DateTime(2026, 11, 24, 11),
          end: DateTime(2026, 11, 24, 12),
          discoveryPricingType: 'free',
        ),
        _event(
          id: 'authoritatively-paid',
          start: DateTime(2026, 11, 24, 12),
          end: DateTime(2026, 11, 24, 13),
          discoveryPricingType: 'paid',
          priceType: PriceType.free,
        ),
      ];

      await _pumpUrgencySection(tester, events: events, now: () => now);

      expect(find.text('Gratuit'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'a slot stays on the rail from twelve hours before its start until it ends',
    (tester) async {
      var now = DateTime(2026, 11, 24, 10);
      final start = now.add(const Duration(hours: 12, minutes: 30));
      final end = start.add(const Duration(hours: 1));
      final event = _event(
        id: 'moving-window-event',
        title: 'Moving window event',
        start: start,
        end: end,
      );

      await _pumpUrgencySection(tester, events: [event], now: () => now);
      expect(find.text('Moving window event'), findsNothing);

      now = now.add(const Duration(minutes: 31));
      await tester.pump(const Duration(minutes: 1));
      expect(find.text('Moving window event'), findsOneWidget);
      expect(find.text('En cours'), findsNothing);

      now = start.add(const Duration(minutes: 1));
      await tester.pump(const Duration(minutes: 1));
      expect(find.text('Moving window event'), findsOneWidget);
      expect(find.text('En cours'), findsOneWidget);

      now = end.add(const Duration(minutes: 1));
      await tester.pump(const Duration(minutes: 1));
      expect(find.text('Moving window event'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('a live card says until when it runs', (tester) async {
    final now = DateTime(2026, 11, 24, 10);
    final event = _event(
      id: 'live-event',
      title: 'Live event',
      start: DateTime(2026, 11, 24, 9, 30),
      end: DateTime(2026, 11, 24, 11, 30),
    );

    await _pumpUrgencySection(tester, events: [event], now: () => now);

    expect(find.text('En cours'), findsOneWidget);
    expect(find.text("Jusqu'à 11:30"), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a start-only live card shows no end time', (tester) async {
    final now = DateTime(2026, 11, 24, 16);
    final event = _event(
      id: 'start-only-event',
      title: 'Start-only event',
      start: DateTime(2026, 11, 24, 14),
      timeKind: SlotTimeKind.startOnly,
    );

    await _pumpUrgencySection(tester, events: [event], now: () => now);

    expect(find.text('En cours'), findsOneWidget);
    expect(find.textContaining('Jusqu'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<void> _pumpUrgencySection(
  WidgetTester tester, {
  required List<Event> events,
  required DateTime Function() now,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isAuthenticatedProvider.overrideWithValue(false),
        authSessionUserIdProvider.overrideWithValue(null),
        favoritesRepositoryProvider.overrideWithValue(
          _FakeFavoritesRepository(),
        ),
        homeNowProvider.overrideWithValue(now),
        homeHappeningNowEventsProvider.overrideWith(
          (ref) => AsyncData(events),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: UrgencySection()),
      ),
    ),
  );
  await tester.pump();
}

Event _event({
  required String id,
  String? title,
  required DateTime start,
  DateTime? end,
  SlotTimeKind timeKind = SlotTimeKind.exact,
  String discoveryPricingType = 'paid',
  PriceType priceType = PriceType.paid,
}) {
  final slotEnd = timeKind == SlotTimeKind.startOnly ? null : end;
  final slot = CalendarDateSlot(
    id: '$id-slot',
    date: DateTime(start.year, start.month, start.day),
    endDate: slotEnd == null
        ? null
        : DateTime(slotEnd.year, slotEnd.month, slotEnd.day),
    startTime: _clockTime(start),
    endTime: slotEnd == null ? null : _clockTime(slotEnd),
    timeKind: timeKind,
  );

  return Event.minimal(
    id: id,
    slug: id,
    title: title ?? id,
  ).copyWith(
    startDate: start,
    endDate: end ?? start,
    calendar: CalendarConfig(type: 'manual', dateSlots: [slot]),
    hasDirectBooking: false,
    discoveryPricingType: discoveryPricingType,
    priceType: priceType,
    minPrice: 0,
    maxPrice: 0,
  );
}

String _clockTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute:00';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/booking/presentation/widgets/cart_summary_section.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AppLocaleCache.setLanguageCode('fr');
  });

  testWidgets(
    'a Pro ticket stays 10 + 1.50 = 11.50 from API payload to cart UI',
    (tester) async {
      final event = EventMapper.toEvent(
        EventDto.fromJson(_bookingEventPayload),
      );
      final activity = EventToActivityMapper.toActivity(event);
      final ticket = event.tickets.single;

      expect(ticket.price, 10);
      expect(ticket.platformFee, 1.5);
      expect(ticket.buyerPrice, 11.5);
      expect(event.buyerPriceFrom, 11.5);

      await tester.pumpWidget(
        _localizedApp(
          (ownerSession) => Column(
            children: [
              SizedBox(
                width: 220,
                child: EventCard(
                  activity: activity,
                  ownerSession: ownerSession,
                  imageHeight: 80,
                ),
              ),
              CartSummarySection(
                items: [
                  OrderCartItem(
                    event: event,
                    slotId: 'slot-pro',
                    ticket: ticket,
                    quantity: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('À partir de 11,5€'), findsOneWidget);
      expect(find.text('Prix des billets'), findsOneWidget);
      expect(find.text('Frais de service'), findsOneWidget);
      expect(find.text('Total payé'), findsOneWidget);
      expect(find.text('10 €'), findsOneWidget);
      expect(find.text('1,5 €'), findsOneWidget);
      expect(find.text('11,5 €'), findsWidgets);
    },
  );

  testWidgets('a paid discovery payload never renders a booking price label', (
    tester,
  ) async {
    final event = EventMapper.toEvent(
      EventDto.fromJson(_discoveryEventPayload),
    );
    final activity = EventToActivityMapper.toActivity(event);

    expect(event.hasDirectBooking, isFalse);
    expect(event.discoveryPricingType, 'paid');
    expect(activity.isBookingActivity, isFalse);

    await tester.pumpWidget(
      _localizedApp(
        (ownerSession) => SizedBox(
          width: 220,
          child: EventCard(
            activity: activity,
            ownerSession: ownerSession,
            imageHeight: 80,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('À partir de'), findsNothing);
    expect(find.text('Gratuit'), findsNothing);
  });
}

Widget _localizedApp(Widget Function(AuthSessionKey) builder) {
  return ProviderScope(
    overrides: [
      isAuthenticatedProvider.overrideWithValue(false),
      authSessionUserIdProvider.overrideWithValue(null),
      favoritesRepositoryProvider.overrideWithValue(_FakeFavoritesRepository()),
    ],
    child: MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Consumer(
        builder: (context, ref, _) => Scaffold(
          body: SingleChildScrollView(
            child: builder(ref.watch(authSessionKeyProvider)),
          ),
        ),
      ),
    ),
  );
}

class _FakeFavoritesRepository implements FavoritesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _bookingEventPayload = <String, dynamic>{
  'id': 1,
  'uuid': 'event-pro-ticket',
  'slug': 'pro-ticket',
  'title': 'Billet Pro',
  'booking_mode': 'booking',
  'price_from': 10,
  'all_inclusive_price_from': 11.5,
  'pricing': {
    'min': 10,
    'max': 10,
    'is_free': false,
    'all_inclusive_min': 11.5,
    'all_inclusive_max': 11.5,
  },
  'organizer': {'uuid': 'org-pro', 'name': 'Organisation Pro'},
  'tickets': [
    {
      'uuid': 'ticket-pro',
      'name': 'Standard',
      'price': 10,
      'platform_fee': 1.5,
      'all_inclusive_price': 11.5,
      'buyer_pricing': {
        'organizer_price': 10,
        'platform_fee': 1.5,
        'all_inclusive_price': 11.5,
        'currency': 'EUR',
      },
    },
  ],
};

const _discoveryEventPayload = <String, dynamic>{
  'id': 2,
  'uuid': 'event-paid-discovery',
  'slug': 'paid-discovery',
  'title': 'Découverte payante',
  'booking_mode': 'discovery',
  'discovery_pricing_type': 'paid',
  'price_from': 25,
  'pricing': {'min': 25, 'max': 25, 'display': '25 €', 'is_free': false},
};

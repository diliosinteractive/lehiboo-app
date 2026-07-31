import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/petit_boo/data/models/tool_schema_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/tool_cards/event_list_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _schema = ToolSchemaDto(
  name: 'searchEvents',
  description: 'Search events',
  displayType: 'event_list',
  responseSchema: ToolResponseSchemaDto(
    itemsKey: 'events',
    totalKey: 'total',
  ),
);

Future<void> _pumpEvent(WidgetTester tester, Map<String, dynamic> event) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        isAuthenticatedProvider.overrideWithValue(false),
        authSessionUserIdProvider.overrideWithValue(null),
        favoritesRepositoryProvider.overrideWithValue(
          _FakeFavoritesRepository(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EventListCard(
            schema: _schema,
            data: {
              'events': [event],
              'total': 1,
            },
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('Petit Boo event discovery pricing', () {
    testWidgets('shows Gratuit from discovery_pricing_type', (tester) async {
      await _pumpEvent(tester, {
        'title': 'Free discovery',
        'booking_mode': 'discovery',
        'discovery_pricing_type': 'free',
        'is_free': false,
      });

      expect(find.text('Gratuit'), findsOneWidget);
    });

    testWidgets('does not use a contradictory generic free flag', (
      tester,
    ) async {
      await _pumpEvent(tester, {
        'title': 'Paid discovery',
        'bookingMode': 'discovery',
        'discoveryPricingType': 'paid',
        'is_free': true,
        'price_from': 0,
      });

      expect(find.text('Gratuit'), findsNothing);
    });
  });
}

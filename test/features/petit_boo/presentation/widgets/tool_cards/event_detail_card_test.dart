import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/petit_boo/data/models/tool_schema_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/tool_cards/event_detail_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('renders wrapped getEventDetails payload fields', (tester) async {
    AppLocaleCache.setLanguageCode('fr');

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EventDetailCard(
            schema: _eventDetailsSchema,
            data: {
              'type': 'event_details',
              'success': true,
              'data': {
                'uuid': 'event-1',
                'title': 'Pique-nique party du jeudi !',
                'slug': 'pique-nique-party-du-jeudi',
                'description': 'Un super plan en plein air.',
                'venue': {
                  'name': 'Jardin Jacques Chirac',
                  'city': 'Valenciennes',
                },
                'next_slot': {
                  'date': '2026-06-10',
                  'time': '22:00',
                },
                'ticket_types': [
                  {
                    'name': 'Standard',
                    'price': 0,
                    'available': true,
                  },
                ],
              },
            },
          ),
        ),
      ),
    );

    expect(find.text('Pique-nique party du jeudi !'), findsOneWidget);
    expect(find.text('Jardin Jacques Chirac, Valenciennes'), findsOneWidget);
    expect(find.text('2026-06-10 à 22:00'), findsOneWidget);
    expect(find.text('Gratuit'), findsOneWidget);
    expect(find.text('Événement'), findsNothing);
  });

  testWidgets('does not render fallback CTA for malformed event data',
      (tester) async {
    AppLocaleCache.setLanguageCode('fr');

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EventDetailCard(
            schema: _eventDetailsSchema,
            data: {
              'type': 'event_details',
              'success': true,
              'data': <String, Object?>{},
            },
          ),
        ),
      ),
    );

    expect(find.text('Événement'), findsNothing);
    expect(find.text('Voir les disponibilités'), findsNothing);
  });
}

const _eventDetailsSchema = ToolSchemaDto(
  name: 'getEventDetails',
  displayType: 'event_detail',
  icon: 'event',
  color: '#FF601F',
  responseSchema: ToolResponseSchemaDto(
    itemSchema: ToolItemSchemaDto(
      titleField: 'title',
      subtitleField: 'venue.name',
      imageField: 'image_url',
      navigation: ToolNavigationDto(
        route: '/event/{slug}',
        idField: 'slug',
      ),
    ),
  ),
);

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/data/models/event_reference_data_dto.dart';
import 'package:lehiboo/features/events/data/models/search_suggestions_dto.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:lehiboo/features/search/presentation/widgets/filter_bottom_sheet.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    AppLocaleCache.setLanguageCode('fr');
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('an event suggestion that has ended is marked as such', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _GuestAuthNotifier(ref)),
          eventRepositoryProvider.overrideWithValue(_SuggestionsRepository()),
          eventReferenceDataProvider.overrideWith((ref) async => _noReference),
          popularCitiesProvider.overrideWith(_NoPopularCities.new),
          filterPreviewCountProvider.overrideWith(
            (ref, filter) => const AsyncValue.data(0),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: FilterBottomSheet()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'exp');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(_tileOf('Expo terminée'), findsOneWidget);
    expect(
      find.descendant(
          of: _tileOf('Expo terminée'), matching: find.text('Terminé')),
      findsOneWidget,
    );
    expect(
      find.descendant(
          of: _tileOf('Expo à venir'), matching: find.text('Terminé')),
      findsNothing,
    );
  });
}

Finder _tileOf(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(InkWell),
    );

const _noReference = EventReferenceDataDto(
  categories: [],
  eventTags: [],
  audienceGroups: [],
  themes: [],
  specialEvents: [],
  emotions: [],
);

class _SuggestionsRepository implements EventRepository {
  @override
  Future<SearchSuggestionsDto> getSearchSuggestions({
    required String query,
    required List<String> types,
    int limit = 5,
  }) async {
    return SearchSuggestionsDto.fromJson({
      'events': [
        {
          'type': 'event',
          'slug': 'expo-a-venir',
          'label': 'Expo à venir',
          'is_past': false,
        },
        {
          'type': 'event',
          'slug': 'expo-terminee',
          'label': 'Expo terminée',
          'is_past': true,
        },
      ],
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoPopularCities extends PopularCitiesNotifier {
  @override
  Future<PopularCitiesResult> build() async =>
      const PopularCitiesResult(cities: [], isFallback: false);
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GuestAuthNotifier extends AuthNotifier {
  _GuestAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

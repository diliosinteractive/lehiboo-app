import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/models/event_reference_data_dto.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('active filter chips mirror web events core semantics', () async {
    SharedPreferences.setMockInitialValues({});

    final notifier = EventFilterNotifier();
    notifier.applyFilters(
      eventFilterFromQueryParams(const {
        'search': 'atelier',
        'category': 'arts-plastiques,couture',
        'location': 'Denain',
        'radius_km': '10',
        'date_from': '2026-05-15',
        'date_to': '2026-05-15',
      }),
    );

    final container = ProviderContainer(
      overrides: [
        eventFilterProvider.overrideWith((ref) => notifier),
        eventReferenceDataProvider.overrideWith((ref) => _referenceData),
      ],
    );
    addTearDown(container.dispose);

    await container.read(eventReferenceDataProvider.future);

    final chips = container.read(activeFilterChipsProvider);

    expect(chips.map((chip) => chip.id), [
      'date',
      'city',
      'category',
    ]);
    expect(chips.firstWhere((chip) => chip.id == 'date').label,
        '2026-05-15 → 2026-05-15');
    final cityChip = chips.firstWhere((chip) => chip.id == 'city');
    expect(cityChip.label, 'Denain');
    expect(cityChip.value, '10');
    expect(chips.firstWhere((chip) => chip.id == 'category').label,
        'Arts Plastiques, Couture');
  });

  test('removing a grouped category chip clears all selected categories', () {
    SharedPreferences.setMockInitialValues({});

    final notifier = EventFilterNotifier();
    final container = ProviderContainer(
      overrides: [
        eventFilterProvider.overrideWith((ref) => notifier),
      ],
    );
    addTearDown(container.dispose);

    notifier.applyFilters(
      const EventFilter(categoriesSlugs: ['arts-plastiques', 'couture']),
    );

    notifier.removeFilterByType(FilterChipType.category);

    expect(container.read(eventFilterProvider).categoriesSlugs, isEmpty);
  });

  test('public filter chips use grouped backend labels and remove by key',
      () async {
    SharedPreferences.setMockInitialValues({});

    final notifier = EventFilterNotifier();
    notifier.applyFilters(
      const EventFilter(targetAudienceSlugs: ['family', 'pmr']),
    );

    final container = ProviderContainer(
      overrides: [
        eventFilterProvider.overrideWith((ref) => notifier),
        eventReferenceDataProvider.overrideWith((ref) => _referenceData),
      ],
    );
    addTearDown(container.dispose);

    await container.read(eventReferenceDataProvider.future);

    final chips = container.read(activeFilterChipsProvider);
    expect(chips.map((chip) => chip.id), [
      'public_filter_family',
      'public_filter_pmr',
    ]);
    expect(chips.firstWhere((chip) => chip.id == 'public_filter_family').label,
        'En famille');
    expect(chips.firstWhere((chip) => chip.id == 'public_filter_pmr').label,
        'Accessible PMR');

    notifier.removeFilterByType(
      FilterChipType.targetAudience,
      value: 'family',
    );

    expect(container.read(eventFilterProvider).targetAudienceSlugs, ['pmr']);
  });
}

const _referenceData = EventReferenceDataDto(
  categories: [
    EventReferenceCategoryDto(
      id: 1,
      name: 'Arts Plastiques',
      slug: 'arts-plastiques',
      children: [
        EventReferenceCategoryDto(
          id: 2,
          parentId: 1,
          name: 'Couture',
          slug: 'couture',
        ),
      ],
    ),
  ],
  eventTags: [],
  audienceGroups: [],
  publicFilters: [
    EventReferencePublicFilterDto(
      key: 'family',
      label: 'En famille',
      param: 'public_filters',
      value: 'family',
    ),
    EventReferencePublicFilterDto(
      key: 'pmr',
      label: 'Accessible PMR',
      param: 'public_filters',
      value: 'pmr',
    ),
  ],
  themes: [],
  specialEvents: [],
  emotions: [],
);

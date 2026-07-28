import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/search/presentation/widgets/category_cascade.dart';

void main() {
  group('cascadeParentSelection', () {
    test('selecting parent (off → on) adds parent and all children', () {
      final result = cascadeParentSelection(
        currentSlugs: const [],
        parentSlug: 'sport',
        childSlugs: const ['tennis', 'football'],
      );
      expect(result, ['sport', 'tennis', 'football']);
    });

    test('selecting parent dedupes children already present', () {
      final result = cascadeParentSelection(
        currentSlugs: const ['tennis'],
        parentSlug: 'sport',
        childSlugs: const ['tennis', 'football'],
      );
      expect(result, ['tennis', 'sport', 'football']);
    });

    test('selecting parent preserves order of unrelated existing slugs', () {
      final result = cascadeParentSelection(
        currentSlugs: const ['culture', 'food'],
        parentSlug: 'sport',
        childSlugs: const ['tennis'],
      );
      expect(result, ['culture', 'food', 'sport', 'tennis']);
    });

    test('deselecting parent (on → off) removes parent and all children', () {
      final result = cascadeParentSelection(
        currentSlugs: const ['sport', 'tennis', 'football'],
        parentSlug: 'sport',
        childSlugs: const ['tennis', 'football'],
      );
      expect(result, isEmpty);
    });

    test('deselecting parent also removes children not added via cascade', () {
      final result = cascadeParentSelection(
        currentSlugs: const ['tennis', 'sport', 'football', 'culture'],
        parentSlug: 'sport',
        childSlugs: const ['tennis', 'football'],
      );
      expect(result, ['culture']);
    });

    test('parent with no children behaves like single-slug toggle (on)', () {
      final result = cascadeParentSelection(
        currentSlugs: const ['culture'],
        parentSlug: 'sport',
        childSlugs: const [],
      );
      expect(result, ['culture', 'sport']);
    });

    test('parent with no children behaves like single-slug toggle (off)', () {
      final result = cascadeParentSelection(
        currentSlugs: const ['sport', 'culture'],
        parentSlug: 'sport',
        childSlugs: const [],
      );
      expect(result, ['culture']);
    });
  });

  group('selectedParentCategorySlugs', () {
    test('returns parents selected directly or through selected children', () {
      final result = selectedParentCategorySlugs(
        selectedSlugs: const ['sport', 'museum', 'unknown'],
        childSlugsByParent: const {
          'sport': ['tennis', 'football'],
          'culture': ['museum', 'theatre'],
          'food': ['market'],
        },
      );

      expect(result, {'sport', 'culture'});
    });

    test('returns an empty set when no category slug is selected', () {
      final result = selectedParentCategorySlugs(
        selectedSlugs: const [],
        childSlugsByParent: const {
          'sport': ['tennis', 'football'],
        },
      );

      expect(result, isEmpty);
    });
  });

  group('prioritizedCategoryGroupSlugs', () {
    test('uses backend order up to the limit when nothing is selected', () {
      final result = prioritizedCategoryGroupSlugs(
        orderedParentSlugs: const ['sport', 'culture', 'food', 'music'],
        selectedParentSlugs: const {},
        limit: 3,
      );

      expect(result, ['sport', 'culture', 'food']);
    });

    test('pins selected groups before filling remaining slots', () {
      final result = prioritizedCategoryGroupSlugs(
        orderedParentSlugs: const ['sport', 'culture', 'food', 'music'],
        selectedParentSlugs: const {'music'},
        limit: 3,
      );

      expect(result, ['music', 'sport', 'culture']);
    });

    test('keeps every selected group visible when selections exceed the limit',
        () {
      final result = prioritizedCategoryGroupSlugs(
        orderedParentSlugs: const ['sport', 'culture', 'food', 'music'],
        selectedParentSlugs: const {'culture', 'food', 'music'},
        limit: 2,
      );

      expect(result, ['culture', 'food', 'music']);
    });

    test('ignores selected slugs that are not parent categories', () {
      final result = prioritizedCategoryGroupSlugs(
        orderedParentSlugs: const ['sport', 'culture', 'food'],
        selectedParentSlugs: const {'unknown', 'food'},
        limit: 2,
      );

      expect(result, ['food', 'sport']);
    });
  });

  group('prioritizedFilterOptionSlugs', () {
    test('pins selected options before filling remaining slots', () {
      final result = prioritizedFilterOptionSlugs(
        orderedSlugs: const ['nature', 'culture', 'sport', 'creative'],
        selectedSlugs: const {'creative'},
        limit: 3,
      );

      expect(result, ['creative', 'nature', 'culture']);
    });
  });
}

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
}

# Category Parent → Children Cascade — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Selecting a parent category chip in the Filter bottom sheet cascades selection to all its children; deselecting a parent removes itself and all its children; child taps stay independent (option A — see spec).

**Architecture:** Extract the cascade logic into a small pure top-level function in a new file under `lib/features/search/presentation/widgets/`. The `_CategoriesFilterSection` state class becomes a thin caller of that helper. The helper is unit-testable without any Flutter widget machinery; the visible wire-up in the bottom sheet is a one-line change per chip.

**Tech Stack:** Flutter (Dart). Tests use `flutter_test` (`test()` for pure logic; the existing `test/` tree already contains both widget and pure-logic tests).

**Spec:** `docs/superpowers/specs/2026-05-13-category-parent-cascade-design.md`

---

## File Structure

| Path | Action | Responsibility |
|---|---|---|
| `lib/features/search/presentation/widgets/category_cascade.dart` | **Create** | Pure helper: `cascadeParentSelection(currentSlugs, parentSlug, childSlugs) → List<String>`. No Flutter imports. |
| `lib/features/search/presentation/widgets/filter_bottom_sheet.dart` | **Modify** (~1718–1847) | `_CategoriesFilterSectionState`: rename `_toggleSlug` → `_toggleChild`; add `_toggleParent(category)` that delegates to the helper; update `_buildCategoryGroup` wire-up. |
| `test/features/search/widgets/category_cascade_test.dart` | **Create** | Unit tests for the helper: parent on, parent off, partial-children states, empty children, dedupe, ordering. |

---

### Task 1: Add cascade helper with tests

**Files:**
- Create: `lib/features/search/presentation/widgets/category_cascade.dart`
- Test: `test/features/search/widgets/category_cascade_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/features/search/widgets/category_cascade_test.dart`:

```dart
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
```

- [ ] **Step 2: Run tests and verify they fail**

```bash
cd /home/gshot/StudioProjects/lehiboo-app
flutter test test/features/search/widgets/category_cascade_test.dart
```

Expected: compile error / "Target of URI doesn't exist: 'package:lehiboo/.../category_cascade.dart'".

- [ ] **Step 3: Implement the helper**

Create `lib/features/search/presentation/widgets/category_cascade.dart`:

```dart
/// Pure cascade logic for the parent-category chip in the filter bottom sheet.
///
/// If [parentSlug] is currently in [currentSlugs], the parent is treated as
/// selected and this returns a new list with the parent and every entry in
/// [childSlugs] removed. Otherwise the parent and every entry in [childSlugs]
/// are appended, deduped against entries already present, preserving the
/// relative order of pre-existing slugs.
List<String> cascadeParentSelection({
  required List<String> currentSlugs,
  required String parentSlug,
  required List<String> childSlugs,
}) {
  final isSelected = currentSlugs.contains(parentSlug);

  if (isSelected) {
    final toRemove = {parentSlug, ...childSlugs};
    return currentSlugs.where((slug) => !toRemove.contains(slug)).toList();
  }

  final result = List<String>.from(currentSlugs);
  for (final slug in [parentSlug, ...childSlugs]) {
    if (!result.contains(slug)) {
      result.add(slug);
    }
  }
  return result;
}
```

- [ ] **Step 4: Run tests and verify they pass**

```bash
flutter test test/features/search/widgets/category_cascade_test.dart
```

Expected: all 7 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/features/search/presentation/widgets/category_cascade.dart \
        test/features/search/widgets/category_cascade_test.dart
git commit -m "feat(search): add cascadeParentSelection helper for category chips"
```

---

### Task 2: Wire cascade into the filter bottom sheet

**Files:**
- Modify: `lib/features/search/presentation/widgets/filter_bottom_sheet.dart` (around lines 1718–1847)

- [ ] **Step 1: Add the import**

At the top of `filter_bottom_sheet.dart`, alongside existing local imports, add:

```dart
import 'package:lehiboo/features/search/presentation/widgets/category_cascade.dart';
```

(If imports are ordered, place it with the other `features/search/presentation/widgets` imports.)

- [ ] **Step 2: Rename `_toggleSlug` → `_toggleChild` and add `_toggleParent`**

In `_CategoriesFilterSectionState` (currently ends around line 1847), replace the existing `_toggleSlug` method:

```dart
  void _toggleSlug(String slug) {
    final newList = List<String>.from(widget.selectedSlugs);
    if (newList.contains(slug)) {
      newList.remove(slug);
    } else {
      newList.add(slug);
    }
    widget.onChanged(newList);
  }
```

with:

```dart
  void _toggleChild(String slug) {
    final newList = List<String>.from(widget.selectedSlugs);
    if (newList.contains(slug)) {
      newList.remove(slug);
    } else {
      newList.add(slug);
    }
    widget.onChanged(newList);
  }

  void _toggleParent(EventReferenceCategoryDto category) {
    final childSlugs = category.children.map((c) => c.slug).toList();
    final newList = cascadeParentSelection(
      currentSlugs: widget.selectedSlugs,
      parentSlug: category.slug,
      childSlugs: childSlugs,
    );
    widget.onChanged(newList);
  }
```

- [ ] **Step 3: Update `_buildCategoryGroup` wire-up**

In `_buildCategoryGroup` (around lines 1792–1836), find the parent chip:

```dart
          _SelectableChip(
            label: _labelWithCount(category.name, category.eventCount),
            icon: _iconForReference(category.icon, category.slug),
            isSelected: isSelected,
            onTap: () => _toggleSlug(category.slug),
          ),
```

Change `onTap` to `() => _toggleParent(category)`:

```dart
          _SelectableChip(
            label: _labelWithCount(category.name, category.eventCount),
            icon: _iconForReference(category.icon, category.slug),
            isSelected: isSelected,
            onTap: () => _toggleParent(category),
          ),
```

Find the child chip (a few lines below):

```dart
                  return _SelectableChip(
                    label: _labelWithCount(child.name, child.eventCount),
                    icon: _iconForReference(child.icon, child.slug),
                    isSelected: isChildSelected,
                    onTap: () => _toggleSlug(child.slug),
                  );
```

Change `onTap` to `() => _toggleChild(child.slug)`:

```dart
                  return _SelectableChip(
                    label: _labelWithCount(child.name, child.eventCount),
                    icon: _iconForReference(child.icon, child.slug),
                    isSelected: isChildSelected,
                    onTap: () => _toggleChild(child.slug),
                  );
```

- [ ] **Step 4: Confirm no other references to `_toggleSlug` remain**

```bash
grep -n "_toggleSlug" lib/features/search/presentation/widgets/filter_bottom_sheet.dart
```

Expected: no matches (the method has been split and both old call sites are rewired). If any match appears, update it before continuing.

- [ ] **Step 5: Run analyzer and full test suite**

```bash
flutter analyze lib/features/search/presentation/widgets/filter_bottom_sheet.dart lib/features/search/presentation/widgets/category_cascade.dart
flutter test test/features/search/widgets/category_cascade_test.dart
```

Expected: analyzer reports no issues for the touched files; helper tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/features/search/presentation/widgets/filter_bottom_sheet.dart
git commit -m "feat(search): cascade parent-category selection to all children"
```

---

### Task 3: Manual UI verification

**Files:** None (verification only).

- [ ] **Step 1: Launch the app**

```bash
flutter run
```

(Use whatever device target is configured.)

- [ ] **Step 2: Walk the spec's verification list**

Open Explore → Filtres → Catégories card and verify each:

1. Tap a parent that has children → parent chip and all its child chips become selected. ✅
2. Tap the same parent again → parent and all its children become deselected. ✅
3. Select parent, then tap one child → child becomes deselected, parent stays selected (option A). ✅
4. Select a single child without ever tapping the parent → only that child is selected; parent stays off. ✅
5. Type in the categories search field → filtering still works; selecting a partially-visible parent still cascades to *all* its children (re-clear search after to confirm). ✅
6. The "Filtres actifs" counter at the top of the sheet updates correctly across the steps above. ✅

- [ ] **Step 3: If anything fails, file a follow-up task and do not mark the plan complete**

If a step fails, capture the failing scenario, do **not** declare the work done, and return to Task 2 to fix the wire-up.

---

## Out of scope (per spec)

- No "all children selected → auto-promote parent" inference.
- No tri-state visual on the parent chip.
- No backend / `EventFilter` model changes.
- No change to thematiques or any other reference section.

# Category Parent → Children Cascade in Filter Bottom Sheet

**Date:** 2026-05-13
**Surface:** Explore page → "Filtres" bottom sheet → "Catégories" card
**Scope:** Behavior change to one filter section. No backend, model, or API changes.

## Problem

In the filter bottom sheet, parent categories and their children are independent chips. Selecting a parent category like "Sport" does not select its children ("Tennis", "Football", …). Users who want "everything in Sport" must tap every child manually, which is tedious and inconsistent with the mental model that "selecting Sport means I want Sport in all its forms."

## Goal

Tapping a parent category chip cascades selection to all of its children. Tapping it again deselects the parent and all its children. Tapping an individual child remains an independent operation.

## Behavior Specification

### Decision: Option A (asymmetric cascade)

| User action | Result |
|---|---|
| Tap parent (currently off) | Add parent slug **and every child slug** to selection. |
| Tap parent (currently on) | Remove parent slug **and every child slug** from selection. |
| Tap child | Toggle that single child slug. Parent slug is **not** touched, even if this leaves the parent with zero selected children. |

No tri-state/indeterminate visual on the parent. The parent chip's selected appearance is driven solely by whether the parent slug itself is in `selectedSlugs` — same rule as today.

### Why option A

The user explicitly chose this option during brainstorming. It keeps each chip's visual state independently driven by its own slug, avoids a tri-state UI, and matches the intuition that the parent chip represents "I asked for the parent" — what the user did with individual children afterwards is their business.

### Edge cases

- **Parent with no children** (`category.children` empty) → behaves identically to today's single-slug toggle.
- **Some children already selected when parent is tapped on** → no duplicates; the existing children entries are preserved.
- **Some children already selected when parent is tapped off** → those children are also removed (full cascade, not "only what we added").
- **Active search query** in the categories search field → filtering is purely a display concern. The toggle operates on the *full* `category.children` list, not just visible ones, so a user can't end up with hidden-but-selected children they didn't intend.

## Implementation Sketch

**File:** `lib/features/search/presentation/widgets/filter_bottom_sheet.dart`
**Class:** `_CategoriesFilterSectionState` (~ lines 1718–1847)

Replace the single `_toggleSlug(String slug)` method with two intent-named callbacks:

1. `_toggleChild(String slug)` — equivalent to today's `_toggleSlug`. Toggles one slug in/out of `selectedSlugs` and emits `onChanged`.
2. `_toggleParent(EventReferenceCategoryDto category)` — new. Determines whether the parent slug is currently in the selection:
   - If selected → produce a new list with the parent slug **and every `category.children[*].slug`** removed.
   - If not selected → produce a new list with the parent slug **and every `category.children[*].slug`** appended (deduped against existing entries, preserving the existing order of already-present slugs).
   - Emit `onChanged` once with the new list.

Wire-up in `_buildCategoryGroup`:
- Parent chip `onTap` → `_toggleParent(category)`
- Child chip `onTap` → `_toggleChild(child.slug)` (unchanged behavior, renamed call)

The output is still a `List<String>` because that is what the consumer (`onChanged`) and the surrounding filter model expect.

## Non-goals

- No "all children manually selected → auto-promote parent" inference.
- No tri-state/indeterminate visual on the parent chip.
- No change to the backend, the `EventFilter` model, or how `categoriesSlugs` is serialized into API requests.
- No change to the categories search input behavior.
- No change to thematiques or any other reference-data section.

## Risk / Verification

Low risk: change is local to one widget, no model or API change. Verify by:

1. Open Explore → Filtres → Catégories.
2. Tap a parent with children → parent chip and all its child chips become selected.
3. Tap the same parent again → parent and all its children become deselected.
4. Select parent, then tap one child → child becomes deselected, parent stays selected.
5. Select a single child without ever tapping the parent → only that child is selected; parent stays off.
6. Type in the categories search → filtering still works; selecting a partially-visible parent still cascades to *all* its children (including hidden ones).
7. The "Filtres actifs" counter (top of the sheet) reflects the new count correctly.

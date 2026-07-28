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

/// Returns the parent slugs that should stay visible because either the parent
/// itself or one of its children is selected.
Set<String> selectedParentCategorySlugs({
  required List<String> selectedSlugs,
  required Map<String, List<String>> childSlugsByParent,
}) {
  if (selectedSlugs.isEmpty) return <String>{};

  final selected = selectedSlugs.toSet();
  final parents = <String>{};

  for (final entry in childSlugsByParent.entries) {
    if (selected.contains(entry.key) ||
        entry.value.any((slug) => selected.contains(slug))) {
      parents.add(entry.key);
    }
  }

  return parents;
}

/// Builds the collapsed category group order.
///
/// Selected parent groups are pinned first, then the original backend order is
/// used to fill the remaining slots up to [limit]. When selected groups exceed
/// the limit they all remain visible.
List<String> prioritizedCategoryGroupSlugs({
  required List<String> orderedParentSlugs,
  required Set<String> selectedParentSlugs,
  required int limit,
}) {
  return prioritizedFilterOptionSlugs(
    orderedSlugs: orderedParentSlugs,
    selectedSlugs: selectedParentSlugs,
    limit: limit,
  );
}

/// Builds a collapsed option order for filter chips.
///
/// Selected options are pinned first, then the original backend order is used
/// to fill the remaining slots up to [limit]. When selected options exceed the
/// limit they all remain visible.
List<String> prioritizedFilterOptionSlugs({
  required List<String> orderedSlugs,
  required Set<String> selectedSlugs,
  required int limit,
}) {
  final result = <String>[];
  final added = <String>{};
  final availableSlugs = orderedSlugs.toSet();

  void addIfPresent(String slug) {
    if (availableSlugs.contains(slug) && added.add(slug)) {
      result.add(slug);
    }
  }

  for (final slug in orderedSlugs) {
    if (selectedSlugs.contains(slug)) {
      addIfPresent(slug);
    }
  }

  if (limit <= 0) return result;

  for (final slug in orderedSlugs) {
    if (result.length >= limit) break;
    addIfPresent(slug);
  }

  return result;
}

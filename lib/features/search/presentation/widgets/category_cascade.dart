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

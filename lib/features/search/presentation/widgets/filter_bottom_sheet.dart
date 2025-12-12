import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../../../thematiques/presentation/providers/thematiques_provider.dart';
import '../../../thematiques/data/models/thematique_dto.dart';

/// Show the filter bottom sheet
Future<void> showFilterBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  );
}

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late EventFilter _tempFilter;

  @override
  void initState() {
    super.initState();
    _tempFilter = ref.read(eventFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                    const Text(
                      'Filtres',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        filterNotifier.resetAll();
                        setState(() => _tempFilter = const EventFilter());
                      },
                      child: const Text(
                        'Effacer',
                        style: TextStyle(color: Color(0xFFFF601F)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Filter sections
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Date filter section
                    _FilterSection(
                      title: 'Date',
                      icon: Icons.calendar_today,
                      child: _DateFilterSection(
                        selectedType: _tempFilter.dateFilterType,
                        onChanged: (type) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(dateFilterType: type);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Price filter section
                    _FilterSection(
                      title: 'Budget',
                      icon: Icons.euro,
                      child: _PriceFilterSection(
                        onlyFree: _tempFilter.onlyFree,
                        priceMin: _tempFilter.priceMin,
                        priceMax: _tempFilter.priceMax,
                        onFreeChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(onlyFree: value);
                          });
                        },
                        onRangeChanged: (min, max) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              priceMin: min,
                              priceMax: max,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Thematiques filter section
                    Consumer(
                      builder: (context, ref, child) {
                        final thematiquesAsync = ref.watch(thematiquesProvider);
                        return thematiquesAsync.when(
                          data: (thematiques) => _FilterSection(
                            title: 'Thématiques',
                            icon: Icons.category,
                            child: _ThematiquesFilterSection(
                              selectedSlugs: _tempFilter.thematiquesSlugs,
                              thematiques: thematiques,
                              onChanged: (slugs) {
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(thematiquesSlugs: slugs);
                                });
                              },
                            ),
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (_, __) => const SizedBox(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Audience filter section
                    _FilterSection(
                      title: 'Public',
                      icon: Icons.people,
                      child: _AudienceFilterSection(
                        familyFriendly: _tempFilter.familyFriendly,
                        accessiblePMR: _tempFilter.accessiblePMR,
                        onFamilyChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(familyFriendly: value);
                          });
                        },
                        onPMRChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(accessiblePMR: value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Format filter section
                    _FilterSection(
                      title: 'Format',
                      icon: Icons.videocam,
                      child: _FormatFilterSection(
                        onlineOnly: _tempFilter.onlineOnly,
                        inPersonOnly: _tempFilter.inPersonOnly,
                        onOnlineChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              onlineOnly: value,
                              inPersonOnly: value ? false : _tempFilter.inPersonOnly,
                            );
                          });
                        },
                        onInPersonChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              inPersonOnly: value,
                              onlineOnly: value ? false : _tempFilter.onlineOnly,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sort section
                    _FilterSection(
                      title: 'Trier par',
                      icon: Icons.sort,
                      child: _SortFilterSection(
                        selectedSort: _tempFilter.sortBy,
                        onChanged: (sort) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(sortBy: sort);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              // Apply button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        filterNotifier.applyFilters(_tempFilter);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF601F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Appliquer les filtres',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Reusable filter section container
class _FilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFFFF601F)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

/// Date filter section
class _DateFilterSection extends StatelessWidget {
  final DateFilterType? selectedType;
  final ValueChanged<DateFilterType?> onChanged;

  const _DateFilterSection({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _SelectableChip(
          label: "Aujourd'hui",
          isSelected: selectedType == DateFilterType.today,
          onTap: () => onChanged(selectedType == DateFilterType.today ? null : DateFilterType.today),
        ),
        _SelectableChip(
          label: 'Demain',
          isSelected: selectedType == DateFilterType.tomorrow,
          onTap: () => onChanged(selectedType == DateFilterType.tomorrow ? null : DateFilterType.tomorrow),
        ),
        _SelectableChip(
          label: 'Cette semaine',
          isSelected: selectedType == DateFilterType.thisWeek,
          onTap: () => onChanged(selectedType == DateFilterType.thisWeek ? null : DateFilterType.thisWeek),
        ),
        _SelectableChip(
          label: 'Ce week-end',
          isSelected: selectedType == DateFilterType.thisWeekend,
          onTap: () => onChanged(selectedType == DateFilterType.thisWeekend ? null : DateFilterType.thisWeekend),
        ),
        _SelectableChip(
          label: 'Ce mois',
          isSelected: selectedType == DateFilterType.thisMonth,
          onTap: () => onChanged(selectedType == DateFilterType.thisMonth ? null : DateFilterType.thisMonth),
        ),
      ],
    );
  }
}

/// Price filter section
class _PriceFilterSection extends StatelessWidget {
  final bool onlyFree;
  final double priceMin;
  final double priceMax;
  final ValueChanged<bool> onFreeChanged;
  final void Function(double, double) onRangeChanged;

  static const double _sliderMin = 0;
  static const double _sliderMax = 500;

  const _PriceFilterSection({
    required this.onlyFree,
    required this.priceMin,
    required this.priceMax,
    required this.onFreeChanged,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp values to valid range
    final clampedMin = priceMin.clamp(_sliderMin, _sliderMax);
    final clampedMax = priceMax.clamp(_sliderMin, _sliderMax);
    // Ensure min <= max
    final validMin = clampedMin <= clampedMax ? clampedMin : _sliderMin;
    final validMax = clampedMax >= clampedMin ? clampedMax : _sliderMax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Free toggle
        Row(
          children: [
            _SelectableChip(
              label: 'Gratuit uniquement',
              icon: Icons.local_offer,
              isSelected: onlyFree,
              onTap: () => onFreeChanged(!onlyFree),
            ),
          ],
        ),
        if (!onlyFree) ...[
          const SizedBox(height: 16),
          // Price range slider
          Text(
            '${validMin.toInt()}€ - ${validMax.toInt()}€${validMax >= _sliderMax ? '+' : ''}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(validMin, validMax),
            min: _sliderMin,
            max: _sliderMax,
            divisions: 50,
            activeColor: const Color(0xFFFF601F),
            inactiveColor: Colors.grey[300],
            labels: RangeLabels(
              '${validMin.toInt()}€',
              '${validMax.toInt()}€${validMax >= _sliderMax ? '+' : ''}',
            ),
            onChanged: (values) {
              onRangeChanged(values.start, values.end);
            },
          ),
        ],
      ],
    );
  }
}

/// Thematiques filter section
class _ThematiquesFilterSection extends StatelessWidget {
  final List<String> selectedSlugs;
  final List<ThematiqueDto> thematiques;
  final ValueChanged<List<String>> onChanged;

  const _ThematiquesFilterSection({
    required this.selectedSlugs,
    required this.thematiques,
    required this.onChanged,
  });

  // Icon mapping
  static const _iconMapping = {
    'concert': Icons.music_note,
    'spectacle': Icons.theater_comedy,
    'sport': Icons.sports,
    'atelier': Icons.build,
    'exposition': Icons.museum,
    'festival': Icons.celebration,
    'conference': Icons.mic,
    'cinema': Icons.movie,
    'gastronomie': Icons.restaurant,
    'marche': Icons.store,
    'nature': Icons.park,
    'visite': Icons.location_city,
    'famille-enfants': Icons.child_care,
    'art-culture': Icons.palette,
    'musique-concert': Icons.music_note,
    'cinema-spectacle': Icons.theater_comedy,
    'cuisine-gastronomie': Icons.restaurant,
    'formation-education': Icons.school,
    'litterature-lecture': Icons.menu_book,
    'mode-design': Icons.checkroom,
    'nature-environnement': Icons.park,
    'numerique-technologie': Icons.computer,
    'patrimoine-histoire': Icons.castle,
    'sport-bien-etre': Icons.fitness_center,
  };

  @override
  Widget build(BuildContext context) {
    if (thematiques.isEmpty) {
      return const Text('Aucune thématique disponible');
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: thematiques.map((t) {
        final isSelected = selectedSlugs.contains(t.slug);
        
        // Try to find icon from mapping, or use category default
        final icon = _iconMapping[t.slug] ?? 
                     _iconMapping[t.slug.split('-').last] ?? // Try partial match
                     Icons.local_activity;

        return _SelectableChip(
          label: t.name,
          icon: icon,
          isSelected: isSelected,
          onTap: () {
            final newList = List<String>.from(selectedSlugs);
            if (isSelected) {
              newList.remove(t.slug);
            } else {
              newList.add(t.slug);
            }
            onChanged(newList);
          },
        );
      }).toList(),
    );
  }
}

/// Audience filter section
class _AudienceFilterSection extends StatelessWidget {
  final bool familyFriendly;
  final bool accessiblePMR;
  final ValueChanged<bool> onFamilyChanged;
  final ValueChanged<bool> onPMRChanged;

  const _AudienceFilterSection({
    required this.familyFriendly,
    required this.accessiblePMR,
    required this.onFamilyChanged,
    required this.onPMRChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _SelectableChip(
          label: 'En famille',
          icon: Icons.family_restroom,
          isSelected: familyFriendly,
          onTap: () => onFamilyChanged(!familyFriendly),
        ),
        _SelectableChip(
          label: 'Accessible PMR',
          icon: Icons.accessible,
          isSelected: accessiblePMR,
          onTap: () => onPMRChanged(!accessiblePMR),
        ),
      ],
    );
  }
}

/// Format filter section
class _FormatFilterSection extends StatelessWidget {
  final bool onlineOnly;
  final bool inPersonOnly;
  final ValueChanged<bool> onOnlineChanged;
  final ValueChanged<bool> onInPersonChanged;

  const _FormatFilterSection({
    required this.onlineOnly,
    required this.inPersonOnly,
    required this.onOnlineChanged,
    required this.onInPersonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _SelectableChip(
          label: 'En ligne',
          icon: Icons.videocam,
          isSelected: onlineOnly,
          onTap: () => onOnlineChanged(!onlineOnly),
        ),
        _SelectableChip(
          label: 'En présentiel',
          icon: Icons.location_on,
          isSelected: inPersonOnly,
          onTap: () => onInPersonChanged(!inPersonOnly),
        ),
      ],
    );
  }
}

/// Sort filter section
class _SortFilterSection extends StatelessWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption> onChanged;

  const _SortFilterSection({
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _SelectableChip(
          label: 'Pertinence',
          isSelected: selectedSort == SortOption.relevance,
          onTap: () => onChanged(SortOption.relevance),
        ),
        _SelectableChip(
          label: 'Date (plus proche)',
          isSelected: selectedSort == SortOption.dateAsc,
          onTap: () => onChanged(SortOption.dateAsc),
        ),
        _SelectableChip(
          label: 'Prix (croissant)',
          isSelected: selectedSort == SortOption.priceAsc,
          onTap: () => onChanged(SortOption.priceAsc),
        ),
        _SelectableChip(
          label: 'Prix (décroissant)',
          isSelected: selectedSort == SortOption.priceDesc,
          onTap: () => onChanged(SortOption.priceDesc),
        ),
        _SelectableChip(
          label: 'Popularité',
          isSelected: selectedSort == SortOption.popularity,
          onTap: () => onChanged(SortOption.popularity),
        ),
      ],
    );
  }
}

/// Reusable selectable chip
class _SelectableChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
